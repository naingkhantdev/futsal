/**
 * Booking policy — SERVER-AUTHORITATIVE.
 *
 * MIRRORED on the client (display/preview only). Keep these in sync:
 *  - blocking statuses  -> lib/core/constants/booking_policy.dart
 *  - ranges / slots     -> lib/core/utils/time_range.dart
 *  - price + rounding   -> lib/core/utils/money.dart
 *  - date keys          -> lib/core/utils/date_key.dart
 * The Dart unit tests under test/core/ document the expected behaviour.
 *
 * AVAILABILITY / LOCK DESIGN
 * stadiums/{sid}/courts/{cid}/days/{yyyy-MM-dd} holds
 *   { shopId, stadiumId, courtId, date, busy: BusyRange[], updatedAt }
 * with NO customer data (any signed-in user may read it). Only server code
 * writes it. The booking callable (Phase 9) runs one Firestore transaction
 * that reads this doc, rejects any overlap with `busy`, then writes the
 * booking and the updated `busy` list. Because every booking for the same
 * court+date reads and writes the same doc, concurrent attempts are
 * serialised by Firestore's transaction contention: one commits, the other
 * retries, sees the new range and fails with `booking-conflict`.
 * Blocked-slot writes (Phase 11) and booking cancellations/rejections must
 * update `busy` through server code in the same way.
 *
 * Times are minutes from local midnight in the stadium's time zone; ranges
 * never cross midnight (overnight bookings are not supported yet).
 */

export const BOOKING_STATUSES = [
  "pending",
  "confirmed",
  "rejected",
  "cancelled",
  "completed",
] as const;
export type BookingStatus = (typeof BOOKING_STATUSES)[number];

export const PAYMENT_STATUSES = ["unpaid", "pending", "paid", "refunded"] as const;
export type PaymentStatus = (typeof PAYMENT_STATUSES)[number];

/**
 * THE blocking rule: bookings in these statuses occupy court time.
 * cancelled / rejected free the time; completed bookings are in the past and
 * do not block future availability.
 * Mirror: BookingPolicy.blockingStatuses (Dart).
 */
export const BLOCKING_BOOKING_STATUSES: readonly BookingStatus[] = [
  "pending",
  "confirmed",
];

export function isBookingStatus(value: unknown): value is BookingStatus {
  return (
    typeof value === "string" &&
    (BOOKING_STATUSES as readonly string[]).includes(value)
  );
}

/**
 * Whether a stored status blocks availability. Unknown values fail closed
 * (block), matching the client, which reads an unknown status as `pending`.
 */
export function blocksAvailability(status: unknown): boolean {
  if (!isBookingStatus(status)) return true;
  return BLOCKING_BOOKING_STATUSES.includes(status);
}

// --- Shop visibility ------------------------------------------------------

export const SHOP_STATUSES = [
  "pending",
  "active",
  "suspended",
  "rejected",
  "inactive",
] as const;
export type ShopStatus = (typeof SHOP_STATUSES)[number];

/** Active + listed: discoverable and open for new bookings. */
export function isShopBookable(status: unknown, isListed: unknown): boolean {
  return status === "active" && isListed === true;
}

// --- Constants ------------------------------------------------------------

export const MINUTES_PER_DAY = 24 * 60;
export const DEFAULT_SLOT_MINUTES = 60;
export const DEFAULT_TIME_ZONE = "Asia/Yangon";
export const CURRENCY = "MMK";

export const BUSY_KINDS = ["booked", "blocked"] as const;
export type BusyKind = (typeof BUSY_KINDS)[number];

/** Half-open [startMinute, endMinute) in minutes from local midnight. */
export interface TimeRange {
  startMinute: number;
  endMinute: number;
}

/** One entry of a court-day doc's `busy` list. */
export interface BusyRange extends TimeRange {
  kind: BusyKind;
  /** Booking id or blocked-slot id. */
  refId: string;
}

// --- Ranges and slots -----------------------------------------------------

function isInt(v: unknown): v is number {
  return typeof v === "number" && Number.isSafeInteger(v);
}

/** Non-empty, inside one day: 0 <= start < end <= 1440. */
export function isValidRange(r: TimeRange): boolean {
  return (
    isInt(r.startMinute) &&
    isInt(r.endMinute) &&
    r.startMinute >= 0 &&
    r.endMinute > r.startMinute &&
    r.endMinute <= MINUTES_PER_DAY
  );
}

/** THE overlap rule: aStart < bEnd && aEnd > bStart (adjacent = no overlap). */
export function rangesOverlap(a: TimeRange, b: TimeRange): boolean {
  return a.startMinute < b.endMinute && a.endMinute > b.startMinute;
}

export function isValidOpeningHours(openMinute: number, closeMinute: number): boolean {
  return (
    isInt(openMinute) &&
    isInt(closeMinute) &&
    openMinute >= 0 &&
    closeMinute > openMinute &&
    closeMinute <= MINUTES_PER_DAY
  );
}

/**
 * Consecutive slots from openMinute; a trailing partial slot is dropped.
 * Empty for invalid hours or a non-positive slot length.
 */
export function generateSlots(
  openMinute: number,
  closeMinute: number,
  slotMinutes: number,
): TimeRange[] {
  if (!isInt(slotMinutes) || slotMinutes <= 0) return [];
  if (!isValidOpeningHours(openMinute, closeMinute)) return [];
  const slots: TimeRange[] = [];
  for (let start = openMinute; start + slotMinutes <= closeMinute; start += slotMinutes) {
    slots.push({ startMinute: start, endMinute: start + slotMinutes });
  }
  return slots;
}

/**
 * Valid range, inside opening hours, starting on a slot boundary counted
 * from openMinute, lasting a whole number of slots.
 */
export function isBookableWindow(
  range: TimeRange,
  openMinute: number,
  closeMinute: number,
  slotMinutes: number,
): boolean {
  return (
    isInt(slotMinutes) &&
    slotMinutes > 0 &&
    isValidRange(range) &&
    isValidOpeningHours(openMinute, closeMinute) &&
    range.startMinute >= openMinute &&
    range.endMinute <= closeMinute &&
    (range.startMinute - openMinute) % slotMinutes === 0 &&
    (range.endMinute - range.startMinute) % slotMinutes === 0
  );
}

// --- Money ----------------------------------------------------------------

/** A non-negative whole-kyat amount. */
export function isValidAmount(v: unknown): v is number {
  return isInt(v) && v >= 0;
}

/**
 * hourlyPrice * minutes / 60 in integer arithmetic.
 *
 * Returns null (reject, never round the duration) unless minutes is a
 * positive multiple of slotMinutes, slotMinutes is positive and hourlyPrice
 * is a non-negative integer.
 *
 * Rounding: when hourlyPrice * minutes is not divisible by 60 the result is
 * rounded half up to the nearest whole kyat: floor((p * m + 30) / 60).
 * Identical to Dart `(p * m + 30) ~/ 60` for non-negative inputs.
 */
export function calculateTotalPrice(
  hourlyPrice: number,
  minutes: number,
  slotMinutes: number,
): number | null {
  if (!isValidAmount(hourlyPrice)) return null;
  if (!isInt(minutes) || minutes <= 0) return null;
  if (!isInt(slotMinutes) || slotMinutes <= 0) return null;
  if (minutes % slotMinutes !== 0) return null;
  const scaled = hourlyPrice * minutes + 30;
  if (!Number.isSafeInteger(scaled)) return null;
  return Math.floor(scaled / 60);
}

// --- Date keys ------------------------------------------------------------

const DATE_KEY = /^(\d{4})-(\d{2})-(\d{2})$/;

/** yyyy-MM-dd that is a real calendar date (rejects 2026-02-30). */
export function isValidDateKey(key: unknown): key is string {
  if (typeof key !== "string") return false;
  const m = DATE_KEY.exec(key);
  if (!m) return false;
  const y = Number(m[1]);
  const mo = Number(m[2]);
  const d = Number(m[3]);
  // setUTCFullYear avoids Date.UTC's 0-99 => 1900s mapping.
  const date = new Date(0);
  date.setUTCFullYear(y, mo - 1, d);
  return (
    date.getUTCFullYear() === y &&
    date.getUTCMonth() === mo - 1 &&
    date.getUTCDate() === d
  );
}
