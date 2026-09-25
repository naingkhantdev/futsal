# Firestore schema (Phase 3)

Source of names: `lib/firebase/firestore/*_fields.dart` and `firestore_paths.dart`, mirrored in
`functions/src/collections.ts`. Rules: `firestore.rules`. Indexes: `firestore.indexes.json`.

Conventions
- Every shop-owned doc carries `shopId`.
- Money: **int MMK** (whole kyat), never doubles. `currency` = `'MMK'`.
- Local time: `yyyy-MM-dd` date strings and `startMinute`/`endMinute` ints (minutes from local midnight in
  the stadium's `timeZone`, default `Asia/Yangon`). `0 <= start < end <= 1440`. **Ranges never cross
  midnight** (overnight bookings unsupported for now). `startAt`/`endAt` Timestamps (UTC) hold the same
  range for queries.
- Overlap rule: `aStart < bEnd && aEnd > bStart` (adjacent ranges do not overlap).
- Blocking statuses (one constant): `pending`, `confirmed`. `cancelled`, `rejected`, `completed` do not
  block. Dart `BookingPolicy.blockingStatuses` = TS `BLOCKING_BOOKING_STATUSES` (`src/booking/policy.ts`).
- Price = `hourlyPrice * minutes / 60`; minutes must be a positive multiple of `slotMinutes` (else rejected);
  non-divisible results round half up: `(p * m + 30) div 60`. Server computes; client previews only.
- "Server" = Cloud Functions / Admin SDK (bypass rules). No client writes to any Phase 3 collection.

## `shops/{shopId}`: public shop profile

| Field | Type | Notes |
|---|---|---|
| name, slug, description, logo, coverImage, phone, email, address, township, city | string | customer-safe only |
| latitude, longitude | number? | |
| status | string | `pending`/`active`/`suspended`/`rejected`/`inactive`; unknown → treated as inactive |
| isListed | bool | missing → false |
| approvedAt, createdAt, updatedAt | timestamp | |

Writes: server only (for now). Read: superadmin; admin of this shop; any signed-in user if
`status == 'active' && isListed == true`.

### `shops/{shopId}/private/details`: admin-only

| Field | Type |
|---|---|
| shopId, ownerName, ownerPhone, approvedBy, suspendedReason | string |
| adminIds | string[] (display only; the `shopId` claim grants access) |
| suspendedAt, updatedAt | timestamp |

Writes: server only. Read: superadmin; admin of this shop. (Split out because rules cannot hide fields.)

## `stadiums/{stadiumId}`

| Field | Type | Notes |
|---|---|---|
| shopId, name, description, address, township, city | string | |
| latitude, longitude | number? | |
| images | string[] | |
| facilities | string[] | `parking, shower, changingRoom, drinkingWater, floodLights, seating, restroom, cafe, equipmentRental` |
| openMinute, closeMinute | int | `0 <= open < close <= 1440` |
| timeZone | string | IANA, default `Asia/Yangon` |
| isActive | bool | admin-controlled (Phase 4) |
| isPublished | bool | **server-maintained** = shop active && shop listed && stadium active |
| minHourlyPrice | int? | **server-maintained** = min `hourlyPrice` of active courts |
| createdAt, updatedAt | timestamp | |

Writes: server only (Phase 4 opens admin writes; `isPublished`/`minHourlyPrice` must stay server-only).
Read: superadmin; shop admin where `shopId` matches; signed-in if `isPublished == true`.
Customer list queries **must** include `where('isPublished', '==', true)`.

## `stadiums/{stadiumId}/courts/{courtId}`

| Field | Type | Notes |
|---|---|---|
| shopId, stadiumId, name, description, surfaceType | string | |
| capacity | int? | |
| hourlyPrice | int | MMK per hour |
| currency | string | `MMK` |
| slotMinutes | int | default 60 |
| images | string[] | |
| isActive | bool | |
| createdAt, updatedAt | timestamp | |

Writes: server only (Phase 5 opens admin writes). Read: superadmin; admin of the **parent stadium's** shop;
signed-in if `isActive == true` and parent stadium `isPublished == true` (one `get()` per request).
Customer list queries **must** include `where('isActive', '==', true)`.

## `stadiums/{stadiumId}/courts/{courtId}/days/{yyyy-MM-dd}`: availability + lock

| Field | Type | Notes |
|---|---|---|
| shopId, stadiumId, courtId, date | string | |
| busy | array of `{startMinute:int, endMinute:int, kind:'booked'\|'blocked', refId:string}` | **no customer data** |
| updatedAt | timestamp | |

Writes: **server only**. Read: any signed-in user. Missing doc = nothing busy.

Lock design:
1. The Phase 9 booking callable runs **one transaction**: read shop/stadium/court, read this day doc,
   validate the window (`isBookableWindow`), reject overlap with `busy`, compute price, then write
   the booking **and** the updated `busy` list.
2. All bookings for the same court+date read and write this one doc, so Firestore transaction contention
   serialises them. The loser retries, sees the new range and fails with `booking-conflict`.
3. Blocked-slot create/delete (Phase 11) and booking cancel/reject (Phases 10–11) update `busy` the same way
   through server code. Only blocking-status bookings appear in `busy`.
4. Clients use the doc only to render slot states; the server re-checks it.

## `bookings/{bookingId}`

| Field | Type | Notes |
|---|---|---|
| shopId, customerId, stadiumId, courtId | string | |
| bookingDate | string | `yyyy-MM-dd`, stadium local |
| startMinute, endMinute | int | local minutes; `end > start`, same day |
| startAt, endAt | timestamp | UTC |
| pricePerHour, totalPrice | int | MMK, server-computed |
| currency | string | `MMK` |
| status | string | `pending`/`confirmed`/`rejected`/`cancelled`/`completed`; unknown → `pending` |
| paymentStatus | string | `unpaid`/`pending`/`paid`/`refunded`; unknown → `unpaid` |
| customerNameSnapshot, stadiumNameSnapshot, courtNameSnapshot | string | |
| customerPhoneSnapshot | string? | so shop admins need no `users/` access |
| createdAt, updatedAt | timestamp | |

Writes: **server only** (Phase 9 create, Phases 10–11 status changes). Read: superadmin; shop admin where
`shopId` matches; the customer where `customerId == auth.uid`. List queries must filter on
`customerId` (customer) or `shopId` (shop admin). Duration is derived (`endMinute - startMinute`);
`totalHours` is not stored.

## `blocked_slots/{blockedSlotId}`

| Field | Type | Notes |
|---|---|---|
| shopId, stadiumId, courtId | string | |
| date | string | `yyyy-MM-dd`, stadium local |
| startMinute, endMinute | int | |
| startAt, endAt | timestamp | UTC |
| reason | string | `maintenance`/`privateEvent`/`cleaning`/`tournament`/`temporaryClosure`/`other` (unknown → other) |
| note, createdBy | string? | |
| createdAt, updatedAt | timestamp | |

Writes: server only (Phase 11). Read: superadmin; shop admin where `shopId` matches. Customers see
blocked time only via the day doc.

## Composite indexes

| Collection | Fields | Query |
|---|---|---|
| stadiums | isPublished, name | discovery |
| stadiums | isPublished, city, name | discovery by city |
| stadiums | isPublished, township, name | discovery by township |
| stadiums | isPublished, city, township, name | discovery by city + township |
| courts | isActive, name | active courts of a stadium |
| bookings | customerId, startAt desc | my bookings |
| bookings | shopId, startAt | shop bookings in a date range |

## Server triggers (`functions/src/stadiums/`)

| Trigger | On | Does |
|---|---|---|
| `onShopWrittenSyncStadiums` | `shops/{shopId}` status/isListed change, create, delete | recompute `isPublished` for the shop's stadiums |
| `onStadiumWrittenSyncPublished` | `stadiums/{id}` create, isActive/shopId/isPublished change | recompute `isPublished` |
| `onCourtWrittenSyncMinPrice` | `courts/{id}` create/delete, hourlyPrice/isActive change | recompute `minHourlyPrice` |

Each recompute runs in a transaction and writes only when the value differs, so there are no trigger loops.
