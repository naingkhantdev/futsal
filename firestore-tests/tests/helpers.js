// Shared fixtures for the firestore.rules tests.
//
// Seed data (written with rules disabled):
//   users   : superadmin, adminA (shop-a), adminB (shop-b), alice + bob
//             (customers), carol (inactive customer)
//   shops   : shop-a, shop-b (active + listed), shop-c (suspended)
//   stadiums: st-a (shop-a), st-b (shop-b), st-c (shop-c); open 06:00-23:00
//   courts  : ct-a, ct-b, ct-c (60-minute slots, MMK 20,000 / hour)
//
// Bookings are built exactly like lib/data/repositories/booking_request_builder.dart
// so a "valid" request here is one the real app would send.

const fs = require('node:fs');
const path = require('node:path');
const {
  initializeTestEnvironment,
} = require('@firebase/rules-unit-testing');
const {
  doc,
  setDoc,
  writeBatch,
  serverTimestamp,
  Timestamp,
} = require('firebase/firestore');

const PROJECT_ID = 'demo-futsal';
const HOURLY_PRICE = 20000;
const SLOT_MINUTES = 60;
const YANGON_OFFSET_MINUTES = 390; // UTC+06:30, mirror of BookingPolicy

async function createEnv() {
  return initializeTestEnvironment({
    projectId: PROJECT_ID,
    firestore: {
      rules: fs.readFileSync(path.join(__dirname, '..', '..', 'firestore.rules'), 'utf8'),
    },
  });
}

// --- Dates ------------------------------------------------------------------

/** yyyy-MM-dd of the Yangon calendar day `daysAhead` from today. */
function dateKey(daysAhead) {
  const yangonNow = new Date(Date.now() + YANGON_OFFSET_MINUTES * 60000);
  const d = new Date(Date.UTC(
    yangonNow.getUTCFullYear(),
    yangonNow.getUTCMonth(),
    yangonNow.getUTCDate() + daysAhead,
  ));
  return d.toISOString().slice(0, 10);
}

/** Mirror of LocalTime.instantFor / localInstant() in the rules. */
function instant(key, minute) {
  const [y, m, d] = key.split('-').map(Number);
  return Timestamp.fromMillis(Date.UTC(y, m - 1, d) + (minute - YANGON_OFFSET_MINUTES) * 60000);
}

function slotId(key, minute) {
  return `${key}_${String(minute).padStart(4, '0')}`;
}

/** Mirror of Money.totalPrice. */
function totalPrice(hourlyPrice, minutes) {
  return Math.floor((hourlyPrice * minutes + 30) / 60);
}

// --- Seed -------------------------------------------------------------------

const DATE = dateKey(3);

function userDoc(role, shopId, extra = {}) {
  return {
    name: `${role} user`,
    email: `${role}@example.com`,
    phone: '09123456789',
    role,
    shopId,
    isActive: true,
    createdAt: Timestamp.now(),
    updatedAt: Timestamp.now(),
    ...extra,
  };
}

function shopDoc(name, status, isListed = true) {
  return {
    name,
    status,
    isListed,
    createdAt: Timestamp.now(),
    updatedAt: Timestamp.now(),
  };
}

function stadiumDoc(shopId, name, isPublished = true) {
  return {
    shopId,
    name,
    openMinute: 360,
    closeMinute: 1380,
    timeZone: 'Asia/Yangon',
    isActive: true,
    isPublished,
    freeCancelHours: 24,
    createdAt: Timestamp.now(),
    updatedAt: Timestamp.now(),
  };
}

function courtDoc(shopId, stadiumId, name) {
  return {
    shopId,
    stadiumId,
    name,
    hourlyPrice: HOURLY_PRICE,
    currency: 'MMK',
    slotMinutes: SLOT_MINUTES,
    isActive: true,
    createdAt: Timestamp.now(),
    updatedAt: Timestamp.now(),
  };
}

const VENUES = {
  a: { shopId: 'shop-a', stadiumId: 'st-a', courtId: 'ct-a', stadiumName: 'Stadium A', courtName: 'Court A1' },
  b: { shopId: 'shop-b', stadiumId: 'st-b', courtId: 'ct-b', stadiumName: 'Stadium B', courtName: 'Court B1' },
  c: { shopId: 'shop-c', stadiumId: 'st-c', courtId: 'ct-c', stadiumName: 'Stadium C', courtName: 'Court C1' },
};

async function seed(env) {
  await env.withSecurityRulesDisabled(async (ctx) => {
    const db = ctx.firestore();
    await Promise.all([
      setDoc(doc(db, 'users/superadmin'), userDoc('superadmin', null)),
      setDoc(doc(db, 'users/adminA'), userDoc('shopAdmin', 'shop-a')),
      setDoc(doc(db, 'users/adminB'), userDoc('shopAdmin', 'shop-b')),
      setDoc(doc(db, 'users/alice'), userDoc('customer', null, { name: 'Alice', email: 'alice@example.com' })),
      setDoc(doc(db, 'users/bob'), userDoc('customer', null, { name: 'Bob', email: 'bob@example.com' })),
      setDoc(doc(db, 'users/carol'), userDoc('customer', null, { name: 'Carol', isActive: false })),
      setDoc(doc(db, 'shops/shop-a'), shopDoc('Shop A', 'active')),
      setDoc(doc(db, 'shops/shop-b'), shopDoc('Shop B', 'active')),
      setDoc(doc(db, 'shops/shop-c'), shopDoc('Shop C', 'suspended')),
      setDoc(doc(db, 'shops/shop-a/private/details'), { shopId: 'shop-a', updatedAt: Timestamp.now() }),
      setDoc(doc(db, 'shops/shop-b/private/details'), { shopId: 'shop-b', updatedAt: Timestamp.now() }),
      ...Object.values(VENUES).flatMap((v) => [
        setDoc(doc(db, `stadiums/${v.stadiumId}`),
          stadiumDoc(v.shopId, v.stadiumName, v.shopId !== 'shop-c')),
        setDoc(doc(db, `stadiums/${v.stadiumId}/courts/${v.courtId}`),
          courtDoc(v.shopId, v.stadiumId, v.courtName)),
      ]),
    ]);
  });
}

// --- Booking requests --------------------------------------------------------

const CUSTOMERS = {
  alice: { name: 'Alice', phone: '09123456789' },
  bob: { name: 'Bob', phone: '09123456789' },
  carol: { name: 'Carol', phone: '09123456789' },
};

/**
 * The booking doc + slot docs the app would write for `uid`.
 * `override` patches the booking doc (tampering tests); `slotsFor` lets a
 * test send a different set of slot docs than the booking needs.
 */
function bookingRequest({
  uid,
  bookingId,
  venue = VENUES.a,
  date = DATE,
  start = 1080,
  end = 1140,
  override = {},
  slotStarts,
}) {
  const customer = CUSTOMERS[uid] ?? { name: 'Someone', phone: null };
  const booking = {
    shopId: venue.shopId,
    customerId: uid,
    stadiumId: venue.stadiumId,
    courtId: venue.courtId,
    bookingDate: date,
    startMinute: start,
    endMinute: end,
    slotMinutes: SLOT_MINUTES,
    startAt: instant(date, start),
    endAt: instant(date, end),
    pricePerHour: HOURLY_PRICE,
    totalPrice: totalPrice(HOURLY_PRICE, end - start),
    currency: 'MMK',
    status: 'pending',
    paymentStatus: 'unpaid',
    customerNameSnapshot: customer.name,
    customerPhoneSnapshot: customer.phone,
    stadiumNameSnapshot: venue.stadiumName,
    courtNameSnapshot: venue.courtName,
    freeCancelHours: 24,
    createdAt: serverTimestamp(),
    updatedAt: serverTimestamp(),
    ...override,
  };
  const starts = slotStarts ?? range(start, end, SLOT_MINUTES);
  const slots = starts.map((m) => ({
    id: slotId(date, m),
    data: {
      shopId: venue.shopId,
      stadiumId: venue.stadiumId,
      courtId: venue.courtId,
      date,
      startMinute: m,
      endMinute: m + SLOT_MINUTES,
      kind: 'booked',
      refId: bookingId,
      createdBy: uid,
      createdAt: serverTimestamp(),
    },
  }));
  return { bookingId, venue, booking, slots };
}

function range(start, end, step) {
  const out = [];
  for (let m = start; m < end; m += step) out.push(m);
  return out;
}

function slotPath(venue, id) {
  return `stadiums/${venue.stadiumId}/courts/${venue.courtId}/slots/${id}`;
}

/** One atomic batch: booking + its slot docs (as BookingRepositoryImpl does). */
function commitBooking(db, req) {
  const batch = writeBatch(db);
  batch.set(doc(db, `bookings/${req.bookingId}`), req.booking);
  for (const s of req.slots) batch.set(doc(db, slotPath(req.venue, s.id)), s.data);
  return batch.commit();
}

/** Status change + slot deletes in one batch (cancel / reject). */
function commitRelease(db, req, patch) {
  const batch = writeBatch(db);
  batch.update(doc(db, `bookings/${req.bookingId}`), { ...patch, updatedAt: serverTimestamp() });
  for (const s of req.slots) batch.delete(doc(db, slotPath(req.venue, s.id)));
  return batch.commit();
}

/** Writes a booking + slots with rules disabled (fixture for update tests). */
async function seedBooking(env, req, bookingPatch = {}) {
  await env.withSecurityRulesDisabled(async (ctx) => {
    const db = ctx.firestore();
    const batch = writeBatch(db);
    batch.set(doc(db, `bookings/${req.bookingId}`), {
      ...req.booking,
      createdAt: Timestamp.now(),
      updatedAt: Timestamp.now(),
      ...bookingPatch,
    });
    for (const s of req.slots) {
      batch.set(doc(db, slotPath(req.venue, s.id)), { ...s.data, createdAt: Timestamp.now() });
    }
    await batch.commit();
  });
}

function as(env, uid) {
  return env.authenticatedContext(uid, { email: `${uid}@example.com` }).firestore();
}

module.exports = {
  createEnv,
  seed,
  dateKey,
  instant,
  slotId,
  slotPath,
  totalPrice,
  bookingRequest,
  commitBooking,
  commitRelease,
  seedBooking,
  as,
  DATE,
  VENUES,
  HOURLY_PRICE,
};
