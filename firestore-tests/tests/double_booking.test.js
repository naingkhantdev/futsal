// Booking integrity: slot lock docs make double booking impossible.

const { describe, it, before, beforeEach, after } = require('node:test');
const assert = require('node:assert/strict');
const { assertFails, assertSucceeds } = require('@firebase/rules-unit-testing');
const { doc, getDoc, setDoc, deleteDoc, serverTimestamp } = require('firebase/firestore');
const h = require('./helpers');

describe('double booking', () => {
  let env;
  before(async () => { env = await h.createEnv(); });
  beforeEach(async () => { await env.clearFirestore(); await h.seed(env); });
  after(async () => { await env.cleanup(); });

  it('a customer can book a free slot', async () => {
    const req = h.bookingRequest({ uid: 'alice', bookingId: 'b1' });
    await assertSucceeds(h.commitBooking(h.as(env, 'alice'), req));
  });

  it('a second customer cannot book the same slot', async () => {
    await h.commitBooking(h.as(env, 'alice'), h.bookingRequest({ uid: 'alice', bookingId: 'b1' }));
    const bob = h.bookingRequest({ uid: 'bob', bookingId: 'b2' });
    await assertFails(h.commitBooking(h.as(env, 'bob'), bob));
  });

  it('the same customer cannot book the same slot twice', async () => {
    await h.commitBooking(h.as(env, 'alice'), h.bookingRequest({ uid: 'alice', bookingId: 'b1' }));
    await assertFails(h.commitBooking(h.as(env, 'alice'), h.bookingRequest({ uid: 'alice', bookingId: 'b2' })));
  });

  it('an overlapping booking fails as a whole (no partial slots left behind)', async () => {
    // alice holds 18:00-19:00; bob asks for 17:00-19:00.
    await h.commitBooking(h.as(env, 'alice'), h.bookingRequest({ uid: 'alice', bookingId: 'b1' }));
    const bob = h.bookingRequest({ uid: 'bob', bookingId: 'b2', start: 1020, end: 1140 });
    await assertFails(h.commitBooking(h.as(env, 'bob'), bob));

    await env.withSecurityRulesDisabled(async (ctx) => {
      const db = ctx.firestore();
      const freeSlot = await getDoc(doc(db, h.slotPath(h.VENUES.a, h.slotId(h.DATE, 1020))));
      const booking = await getDoc(doc(db, 'bookings/b2'));
      assert.equal(freeSlot.exists(), false, '17:00 slot must not be taken');
      assert.equal(booking.exists(), false, 'booking b2 must not exist');
    });
  });

  it('concurrent requests for the same slot: exactly one wins', async () => {
    const results = await Promise.allSettled([
      h.commitBooking(h.as(env, 'alice'), h.bookingRequest({ uid: 'alice', bookingId: 'b1' })),
      h.commitBooking(h.as(env, 'bob'), h.bookingRequest({ uid: 'bob', bookingId: 'b2' })),
    ]);
    const ok = results.filter((r) => r.status === 'fulfilled').length;
    assert.equal(ok, 1, `expected exactly one success, got ${ok}`);
  });

  it('the next slot (touching, not overlapping) is still bookable', async () => {
    await h.commitBooking(h.as(env, 'alice'), h.bookingRequest({ uid: 'alice', bookingId: 'b1' }));
    const bob = h.bookingRequest({ uid: 'bob', bookingId: 'b2', start: 1140, end: 1200 });
    await assertSucceeds(h.commitBooking(h.as(env, 'bob'), bob));
  });

  it('the same time on another court is bookable', async () => {
    await h.commitBooking(h.as(env, 'alice'), h.bookingRequest({ uid: 'alice', bookingId: 'b1' }));
    const bob = h.bookingRequest({ uid: 'bob', bookingId: 'b2', venue: h.VENUES.b });
    await assertSucceeds(h.commitBooking(h.as(env, 'bob'), bob));
  });

  it('a booking without its slot docs is refused', async () => {
    const req = h.bookingRequest({ uid: 'alice', bookingId: 'b1', slotStarts: [] });
    await assertFails(h.commitBooking(h.as(env, 'alice'), req));
  });

  it('a 2-slot booking holding only one slot doc is refused', async () => {
    const req = h.bookingRequest({ uid: 'alice', bookingId: 'b1', start: 1080, end: 1200, slotStarts: [1080] });
    await assertFails(h.commitBooking(h.as(env, 'alice'), req));
  });

  it('a slot doc without its booking is refused', async () => {
    const req = h.bookingRequest({ uid: 'alice', bookingId: 'ghost' });
    const s = req.slots[0];
    await assertFails(setDoc(doc(h.as(env, 'alice'), h.slotPath(req.venue, s.id)), s.data));
  });

  it('a taken slot doc can never be overwritten', async () => {
    await h.commitBooking(h.as(env, 'alice'), h.bookingRequest({ uid: 'alice', bookingId: 'b1' }));
    const bob = h.bookingRequest({ uid: 'bob', bookingId: 'b2' });
    const s = bob.slots[0];
    await assertFails(setDoc(doc(h.as(env, 'bob'), h.slotPath(bob.venue, s.id)), s.data));
  });

  it('another customer cannot delete a held slot doc', async () => {
    const req = h.bookingRequest({ uid: 'alice', bookingId: 'b1' });
    await h.commitBooking(h.as(env, 'alice'), req);
    await assertFails(deleteDoc(doc(h.as(env, 'bob'), h.slotPath(req.venue, req.slots[0].id))));
  });

  it('the owner cannot free a slot while the booking stays active', async () => {
    const req = h.bookingRequest({ uid: 'alice', bookingId: 'b1' });
    await h.commitBooking(h.as(env, 'alice'), req);
    await assertFails(deleteDoc(doc(h.as(env, 'alice'), h.slotPath(req.venue, req.slots[0].id))));
  });

  it('after a cancel the slot can be booked again', async () => {
    const alice = h.bookingRequest({ uid: 'alice', bookingId: 'b1' });
    await h.commitBooking(h.as(env, 'alice'), alice);
    await assertSucceeds(h.commitRelease(h.as(env, 'alice'), alice, {
      status: 'cancelled',
      cancelledAt: serverTimestamp(),
    }));
    const bob = h.bookingRequest({ uid: 'bob', bookingId: 'b2' });
    await assertSucceeds(h.commitBooking(h.as(env, 'bob'), bob));
  });

  it('a blocked slot cannot be booked', async () => {
    await env.withSecurityRulesDisabled(async (ctx) => {
      await setDoc(doc(ctx.firestore(), h.slotPath(h.VENUES.a, h.slotId(h.DATE, 1080))), {
        shopId: 'shop-a', stadiumId: 'st-a', courtId: 'ct-a', date: h.DATE,
        startMinute: 1080, endMinute: 1140, kind: 'blocked', refId: 'block1',
        createdBy: 'adminA', createdAt: new Date(),
      });
    });
    await assertFails(h.commitBooking(h.as(env, 'alice'), h.bookingRequest({ uid: 'alice', bookingId: 'b1' })));
  });
});
