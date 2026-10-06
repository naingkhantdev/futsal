// Booking updates: cancel / confirm / reject / complete / payment status.

const { describe, it, before, beforeEach, after } = require('node:test');
const { assertFails, assertSucceeds } = require('@firebase/rules-unit-testing');
const { doc, getDoc, updateDoc, deleteDoc, serverTimestamp } = require('firebase/firestore');
const h = require('./helpers');

describe('booking lifecycle', () => {
  let env;
  let req;
  before(async () => { env = await h.createEnv(); });
  beforeEach(async () => {
    await env.clearFirestore();
    await h.seed(env);
    req = h.bookingRequest({ uid: 'alice', bookingId: 'b1' });
    await h.seedBooking(env, req);
  });
  after(async () => { await env.cleanup(); });

  const update = (uid, patch) =>
    updateDoc(doc(h.as(env, uid), 'bookings/b1'), { ...patch, updatedAt: serverTimestamp() });

  describe('customer', () => {
    it('can read their own booking, not someone else\'s', async () => {
      await assertSucceeds(getDoc(doc(h.as(env, 'alice'), 'bookings/b1')));
      await assertFails(getDoc(doc(h.as(env, 'bob'), 'bookings/b1')));
    });

    it('can cancel their own booking (slots freed in the same batch)', async () => {
      await assertSucceeds(h.commitRelease(h.as(env, 'alice'), req, {
        status: 'cancelled', cancelledAt: serverTimestamp(), cancelReason: 'Rain',
      }));
    });

    it('cannot cancel without freeing the slots', async () => {
      await assertFails(update('alice', { status: 'cancelled', cancelledAt: serverTimestamp() }));
    });

    it('cannot cancel someone else\'s booking', async () => {
      await assertFails(h.commitRelease(h.as(env, 'bob'), req, {
        status: 'cancelled', cancelledAt: serverTimestamp(),
      }));
    });

    it('cannot cancel after the booking has started', async () => {
      const past = h.bookingRequest({ uid: 'alice', bookingId: 'old', date: h.dateKey(-1) });
      await h.seedBooking(env, past, { status: 'confirmed' });
      await assertFails(h.commitRelease(h.as(env, 'alice'), past, {
        status: 'cancelled', cancelledAt: serverTimestamp(),
      }));
    });

    it('cannot confirm their own booking', async () => {
      await assertFails(update('alice', { status: 'confirmed' }));
    });

    it('cannot mark their own booking as paid', async () => {
      await assertFails(update('alice', { paymentStatus: 'pending' }));
    });

    it('cannot change the price after booking', async () => {
      await assertFails(update('alice', { totalPrice: 1 }));
    });
  });

  describe('shop staff', () => {
    it('can confirm a pending booking', async () => {
      await assertSucceeds(update('adminA', { status: 'confirmed' }));
    });

    it('cannot change the price while confirming', async () => {
      await assertFails(update('adminA', { status: 'confirmed', totalPrice: 1 }));
    });

    it('can reject and free the slots', async () => {
      await assertSucceeds(h.commitRelease(h.as(env, 'adminA'), req, {
        status: 'rejected', cancelReason: 'Court closed',
      }));
    });

    it('can reject a 4-slot booking (largest request, expression budget)', async () => {
      const big = h.bookingRequest({ uid: 'alice', bookingId: 'big', start: 600, end: 840 });
      await h.seedBooking(env, big);
      await assertSucceeds(h.commitRelease(h.as(env, 'adminA'), big, {
        status: 'rejected', cancelReason: 'Court closed',
      }));
    });

    it('cannot reject without freeing the slots', async () => {
      await assertFails(update('adminA', { status: 'rejected' }));
    });

    it('cannot complete a booking that has not started', async () => {
      await update('adminA', { status: 'confirmed' });
      await assertFails(update('adminA', { status: 'completed' }));
    });

    it('can complete a confirmed booking after it started', async () => {
      const past = h.bookingRequest({ uid: 'alice', bookingId: 'old', date: h.dateKey(-1) });
      await h.seedBooking(env, past, { status: 'confirmed' });
      await assertSucceeds(updateDoc(doc(h.as(env, 'adminA'), 'bookings/old'),
        { status: 'completed', updatedAt: serverTimestamp() }));
    });

    it('cannot move a cancelled booking back to confirmed', async () => {
      await h.commitRelease(h.as(env, 'alice'), req, {
        status: 'cancelled', cancelledAt: serverTimestamp(),
      });
      await assertFails(update('adminA', { status: 'confirmed' }));
    });

    it('payment: unpaid -> pending -> paid -> refunded', async () => {
      await assertSucceeds(update('adminA', { paymentStatus: 'pending' }));
      await assertSucceeds(update('adminA', { paymentStatus: 'paid' }));
      await assertSucceeds(update('adminA', { paymentStatus: 'refunded' }));
    });

    it('payment: cannot skip from unpaid to paid', async () => {
      await assertFails(update('adminA', { paymentStatus: 'paid' }));
    });

    it('payment: cannot refund an unpaid booking', async () => {
      await assertFails(update('adminA', { paymentStatus: 'refunded' }));
    });

    it('superadmin can manage any shop\'s booking', async () => {
      await assertSucceeds(update('superadmin', { status: 'confirmed' }));
    });

    it('bookings can never be deleted', async () => {
      await assertFails(deleteDoc(doc(h.as(env, 'superadmin'), 'bookings/b1')));
    });
  });
});
