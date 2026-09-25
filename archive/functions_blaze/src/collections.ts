/** Firestore collection / field names shared by functions and scripts. */
export const USERS = "users";

/** users/{uid} fields. Mirrors lib/firebase/firestore/user_fields.dart. */
export const UserFields = {
  name: "name",
  email: "email",
  phone: "phone",
  profileImage: "profileImage",
  role: "role",
  shopId: "shopId",
  isActive: "isActive",
  createdAt: "createdAt",
  updatedAt: "updatedAt",
  /**
   * Written right AFTER custom claims change. The client force-refreshes its
   * ID token when this is newer than the token's issue time.
   */
  claimsUpdatedAt: "claimsUpdatedAt",
} as const;

// --- Phase 3 collections --------------------------------------------------
// Mirrors lib/firebase/firestore/firestore_paths.dart and the *_fields.dart
// files next to it. Keep names identical on both sides.

export const SHOPS = "shops";
/** Subcollection of shops/{shopId}; holds the single doc SHOP_PRIVATE_DOC. */
export const SHOP_PRIVATE = "private";
export const SHOP_PRIVATE_DOC = "details";
export const STADIUMS = "stadiums";
/** Subcollection of stadiums/{stadiumId}. */
export const COURTS = "courts";
/** Subcollection of stadiums/{stadiumId}/courts/{courtId}; id = yyyy-MM-dd. */
export const DAYS = "days";
export const BOOKINGS = "bookings";
export const BLOCKED_SLOTS = "blocked_slots";

/** shops/{shopId} — customer-safe public fields only. */
export const ShopFields = {
  name: "name",
  slug: "slug",
  description: "description",
  logo: "logo",
  coverImage: "coverImage",
  phone: "phone",
  email: "email",
  address: "address",
  township: "township",
  city: "city",
  latitude: "latitude",
  longitude: "longitude",
  status: "status",
  isListed: "isListed",
  approvedAt: "approvedAt",
  createdAt: "createdAt",
  updatedAt: "updatedAt",
} as const;

/** shops/{shopId}/private/details — superadmin + that shop's admins. */
export const ShopPrivateFields = {
  shopId: "shopId",
  ownerName: "ownerName",
  ownerPhone: "ownerPhone",
  adminIds: "adminIds",
  approvedBy: "approvedBy",
  suspendedAt: "suspendedAt",
  suspendedReason: "suspendedReason",
  updatedAt: "updatedAt",
} as const;

/** stadiums/{stadiumId}. */
export const StadiumFields = {
  shopId: "shopId",
  name: "name",
  description: "description",
  address: "address",
  township: "township",
  city: "city",
  latitude: "latitude",
  longitude: "longitude",
  images: "images",
  facilities: "facilities",
  openMinute: "openMinute",
  closeMinute: "closeMinute",
  timeZone: "timeZone",
  isActive: "isActive",
  /** Server-maintained by stadiums/publishedSync.ts. */
  isPublished: "isPublished",
  /** Server-maintained by stadiums/minHourlyPriceSync.ts. */
  minHourlyPrice: "minHourlyPrice",
  createdAt: "createdAt",
  updatedAt: "updatedAt",
} as const;

/** stadiums/{stadiumId}/courts/{courtId}. */
export const CourtFields = {
  shopId: "shopId",
  stadiumId: "stadiumId",
  name: "name",
  description: "description",
  surfaceType: "surfaceType",
  capacity: "capacity",
  hourlyPrice: "hourlyPrice",
  currency: "currency",
  slotMinutes: "slotMinutes",
  images: "images",
  isActive: "isActive",
  createdAt: "createdAt",
  updatedAt: "updatedAt",
} as const;

/** bookings/{bookingId}. */
export const BookingFields = {
  shopId: "shopId",
  customerId: "customerId",
  stadiumId: "stadiumId",
  courtId: "courtId",
  bookingDate: "bookingDate",
  startMinute: "startMinute",
  endMinute: "endMinute",
  startAt: "startAt",
  endAt: "endAt",
  pricePerHour: "pricePerHour",
  totalPrice: "totalPrice",
  currency: "currency",
  status: "status",
  paymentStatus: "paymentStatus",
  customerNameSnapshot: "customerNameSnapshot",
  customerPhoneSnapshot: "customerPhoneSnapshot",
  stadiumNameSnapshot: "stadiumNameSnapshot",
  courtNameSnapshot: "courtNameSnapshot",
  createdAt: "createdAt",
  updatedAt: "updatedAt",
} as const;

/** blocked_slots/{blockedSlotId}. */
export const BlockedSlotFields = {
  shopId: "shopId",
  stadiumId: "stadiumId",
  courtId: "courtId",
  date: "date",
  startMinute: "startMinute",
  endMinute: "endMinute",
  startAt: "startAt",
  endAt: "endAt",
  reason: "reason",
  note: "note",
  createdBy: "createdBy",
  createdAt: "createdAt",
  updatedAt: "updatedAt",
} as const;

/**
 * stadiums/{stadiumId}/courts/{courtId}/days/{yyyy-MM-dd} — the public
 * availability + lock doc. See booking/policy.ts for the design.
 */
export const CourtDayFields = {
  shopId: "shopId",
  stadiumId: "stadiumId",
  courtId: "courtId",
  date: "date",
  busy: "busy",
  updatedAt: "updatedAt",
} as const;

/** Keys of one entry in CourtDayFields.busy. */
export const BusyRangeFields = {
  startMinute: "startMinute",
  endMinute: "endMinute",
  kind: "kind",
  refId: "refId",
} as const;
