// Roles (users/{uid}) and SHOP-scope isolation: shop admin A must never
// read or change shop B's data.

const { describe, it, before, beforeEach, after } = require('node:test');
const { assertFails, assertSucceeds } = require('@firebase/rules-unit-testing');
const {
  doc, getDoc, getDocs, setDoc, updateDoc, writeBatch, collection, query, where,
  serverTimestamp,
} = require('firebase/firestore');
const h = require('./helpers');

describe('users and roles', () => {
  let env;
  before(async () => { env = await h.createEnv(); });
  beforeEach(async () => { await env.clearFirestore(); await h.seed(env); });
  after(async () => { await env.cleanup(); });

  const selfDoc = (uid, extra = {}) => ({
    name: 'New User',
    email: `${uid}@example.com`,
    role: 'customer',
    shopId: null,
    isActive: true,
    createdAt: serverTimestamp(),
    updatedAt: serverTimestamp(),
    ...extra,
  });

  it('a new user can register as an active customer', async () => {
    await assertSucceeds(setDoc(doc(h.as(env, 'newbie'), 'users/newbie'), selfDoc('newbie')));
  });

  it('a new user cannot register as a shop admin', async () => {
    await assertFails(setDoc(doc(h.as(env, 'newbie'), 'users/newbie'),
      selfDoc('newbie', { role: 'shopAdmin', shopId: 'shop-a' })));
  });

  it('a new user cannot register as a superadmin', async () => {
    await assertFails(setDoc(doc(h.as(env, 'newbie'), 'users/newbie'),
      selfDoc('newbie', { role: 'superadmin' })));
  });

  it('a user cannot create someone else\'s doc', async () => {
    await assertFails(setDoc(doc(h.as(env, 'newbie'), 'users/other'), selfDoc('other')));
  });

  it('a customer cannot promote themselves', async () => {
    await assertFails(updateDoc(doc(h.as(env, 'alice'), 'users/alice'),
      { role: 'superadmin', updatedAt: serverTimestamp() }));
  });

  it('a customer can edit their own name', async () => {
    await assertSucceeds(updateDoc(doc(h.as(env, 'alice'), 'users/alice'),
      { name: 'Alice K', updatedAt: serverTimestamp() }));
  });

  it('a customer cannot re-activate a disabled account', async () => {
    await assertFails(updateDoc(doc(h.as(env, 'carol'), 'users/carol'),
      { isActive: true, updatedAt: serverTimestamp() }));
  });

  it('a shop admin cannot move themselves to another shop', async () => {
    await assertFails(updateDoc(doc(h.as(env, 'adminA'), 'users/adminA'),
      { shopId: 'shop-b', updatedAt: serverTimestamp() }));
  });

  it('a superadmin can make a customer a shop admin', async () => {
    await assertSucceeds(updateDoc(doc(h.as(env, 'superadmin'), 'users/bob'),
      { role: 'shopAdmin', shopId: 'shop-b', updatedAt: serverTimestamp() }));
  });

  it('a superadmin cannot assign a shop that does not exist', async () => {
    await assertFails(updateDoc(doc(h.as(env, 'superadmin'), 'users/bob'),
      { role: 'shopAdmin', shopId: 'no-such-shop', updatedAt: serverTimestamp() }));
  });

  it('a superadmin cannot demote themselves', async () => {
    await assertFails(updateDoc(doc(h.as(env, 'superadmin'), 'users/superadmin'),
      { role: 'customer', updatedAt: serverTimestamp() }));
  });

  it('a shop admin cannot change another user\'s role', async () => {
    await assertFails(updateDoc(doc(h.as(env, 'adminA'), 'users/bob'),
      { role: 'shopAdmin', shopId: 'shop-a', updatedAt: serverTimestamp() }));
  });

  it('a customer cannot read another user\'s profile', async () => {
    await assertFails(getDoc(doc(h.as(env, 'alice'), 'users/bob')));
  });

  it('a shop admin cannot read user profiles', async () => {
    await assertFails(getDoc(doc(h.as(env, 'adminA'), 'users/alice')));
  });
});

describe('shop isolation', () => {
  let env;
  before(async () => { env = await h.createEnv(); });
  beforeEach(async () => { await env.clearFirestore(); await h.seed(env); });
  after(async () => { await env.cleanup(); });

  const aliceAtA = () => h.bookingRequest({ uid: 'alice', bookingId: 'b1' });

  it('a shop admin can read their own shop\'s private details', async () => {
    await assertSucceeds(getDoc(doc(h.as(env, 'adminA'), 'shops/shop-a/private/details')));
  });

  it('a shop admin cannot read another shop\'s private details', async () => {
    await assertFails(getDoc(doc(h.as(env, 'adminA'), 'shops/shop-b/private/details')));
  });

  it('a shop admin cannot edit shop docs (superadmin only)', async () => {
    await assertFails(updateDoc(doc(h.as(env, 'adminA'), 'shops/shop-a'),
      { status: 'active', isListed: true, updatedAt: serverTimestamp() }));
  });

  it('a shop admin cannot create a stadium for another shop', async () => {
    await assertFails(setDoc(doc(h.as(env, 'adminA'), 'stadiums/new'), {
      shopId: 'shop-b', name: 'Sneaky', openMinute: 360, closeMinute: 1380,
      timeZone: 'Asia/Yangon', isActive: true, isPublished: true,
      createdAt: serverTimestamp(), updatedAt: serverTimestamp(),
    }));
  });

  it('a shop admin can create a stadium for their own shop', async () => {
    await assertSucceeds(setDoc(doc(h.as(env, 'adminA'), 'stadiums/new'), {
      shopId: 'shop-a', name: 'Second Stadium', openMinute: 360, closeMinute: 1380,
      timeZone: 'Asia/Yangon', isActive: true, isPublished: true,
      createdAt: serverTimestamp(), updatedAt: serverTimestamp(),
    }));
  });

  it('a shop admin cannot change another shop\'s court price', async () => {
    await assertFails(updateDoc(doc(h.as(env, 'adminB'), 'stadiums/st-a/courts/ct-a'),
      { hourlyPrice: 1, updatedAt: serverTimestamp() }));
  });

  it('court slotMinutes cannot change after create', async () => {
    await assertFails(updateDoc(doc(h.as(env, 'adminA'), 'stadiums/st-a/courts/ct-a'),
      { slotMinutes: 30, updatedAt: serverTimestamp() }));
  });

  it('a shop admin cannot read another shop\'s booking', async () => {
    await h.seedBooking(env, aliceAtA());
    await assertSucceeds(getDoc(doc(h.as(env, 'adminA'), 'bookings/b1')));
    await assertFails(getDoc(doc(h.as(env, 'adminB'), 'bookings/b1')));
  });

  it('a shop admin cannot list another shop\'s bookings', async () => {
    await h.seedBooking(env, aliceAtA());
    const db = h.as(env, 'adminB');
    await assertFails(getDocs(query(collection(db, 'bookings'), where('shopId', '==', 'shop-a'))));
    await assertSucceeds(getDocs(query(collection(db, 'bookings'), where('shopId', '==', 'shop-b'))));
  });

  it('a shop admin cannot confirm another shop\'s booking', async () => {
    await h.seedBooking(env, aliceAtA());
    await assertFails(updateDoc(doc(h.as(env, 'adminB'), 'bookings/b1'),
      { status: 'confirmed', updatedAt: serverTimestamp() }));
  });

  it('a shop admin cannot blacklist a customer at another shop', async () => {
    await assertFails(setDoc(doc(h.as(env, 'adminB'), 'shops/shop-a/blacklist/alice'), {
      shopId: 'shop-a', customerId: 'alice', customerNameSnapshot: 'Alice',
      reason: 'noShow', createdBy: 'adminB', createdAt: serverTimestamp(),
    }));
  });

  // Block doc + its slot docs in one batch, as BlockedSlotRepositoryImpl writes it.
  const commitBlock = (uid, venue, start, end) => {
    const db = h.as(env, uid);
    const date = h.DATE;
    const batch = writeBatch(db);
    batch.set(doc(db, 'blocked_slots/blk1'), {
      shopId: venue.shopId, stadiumId: venue.stadiumId, courtId: venue.courtId, date,
      startMinute: start, endMinute: end, slotMinutes: 60,
      startAt: h.instant(date, start), endAt: h.instant(date, end),
      reason: 'maintenance', note: null, createdBy: uid,
      createdAt: serverTimestamp(), updatedAt: serverTimestamp(),
    });
    for (let m = start; m < end; m += 60) {
      batch.set(doc(db, h.slotPath(venue, h.slotId(date, m))), {
        shopId: venue.shopId, stadiumId: venue.stadiumId, courtId: venue.courtId, date,
        startMinute: m, endMinute: m + 60, kind: 'blocked', refId: 'blk1',
        createdBy: uid, createdAt: serverTimestamp(),
      });
    }
    return batch.commit();
  };

  it('a shop admin can block 4 slots on their own court', async () => {
    await assertSucceeds(commitBlock('adminA', h.VENUES.a, 1080, 1320));
  });

  it('a shop admin cannot block slots on another shop\'s court', async () => {
    await assertFails(commitBlock('adminB', h.VENUES.a, 1080, 1140));
  });

  it('customers see only published stadiums', async () => {
    const db = h.as(env, 'alice');
    await assertSucceeds(getDoc(doc(db, 'stadiums/st-a')));
    await assertFails(getDoc(doc(db, 'stadiums/st-c')));
  });

  it('signed-out users cannot read stadiums', async () => {
    await assertFails(getDoc(doc(env.unauthenticatedContext().firestore(), 'stadiums/st-a')));
  });

  it('unknown collections are closed', async () => {
    await assertFails(setDoc(doc(h.as(env, 'superadmin'), 'secrets/x'), { a: 1 }));
  });
});
