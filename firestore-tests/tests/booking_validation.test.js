// Booking create: the rules re-check everything the client sends.

const { describe, it, before, beforeEach, after } = require('node:test');
const { assertFails, assertSucceeds } = require('@firebase/rules-unit-testing');
const { doc, setDoc, Timestamp } = require('firebase/firestore');
const h = require('./helpers');

describe('booking validation', () => {
  let env;
  before(async () => { env = await h.createEnv(); });
  beforeEach(async () => { await env.clearFirestore(); await h.seed(env); });
  after(async () => { await env.cleanup(); });

  const tryBook = (uid, opts) =>
    h.commitBooking(h.as(env, uid), h.bookingRequest({ uid, bookingId: 'b1', ...opts }));

  it('a valid 4-slot booking succeeds', async () => {
    await assertSucceeds(tryBook('alice', { start: 1080, end: 1320 }));
  });

  describe('price', () => {
    it('a lowered totalPrice is refused', async () => {
      await assertFails(tryBook('alice', { override: { totalPrice: 1 } }));
    });

    it('a zero totalPrice is refused', async () => {
      await assertFails(tryBook('alice', { override: { totalPrice: 0 } }));
    });

    it('a lowered pricePerHour (with matching total) is refused', async () => {
      await assertFails(tryBook('alice', { override: { pricePerHour: 1000, totalPrice: 1000 } }));
    });

    it('a different currency is refused', async () => {
      await assertFails(tryBook('alice', { override: { currency: 'USD' } }));
    });
  });

  describe('status and payment', () => {
    it('cannot create an already confirmed booking', async () => {
      await assertFails(tryBook('alice', { override: { status: 'confirmed' } }));
    });

    it('cannot create an already paid booking', async () => {
      await assertFails(tryBook('alice', { override: { paymentStatus: 'paid' } }));
    });

    it('cannot add unknown fields', async () => {
      await assertFails(tryBook('alice', { override: { discount: 100 } }));
    });
  });

  describe('time', () => {
    it('a past date is refused', async () => {
      await assertFails(tryBook('alice', { date: h.dateKey(-1) }));
    });

    it('more than 30 days ahead is refused', async () => {
      await assertFails(tryBook('alice', { date: h.dateKey(31) }));
    });

    it('before opening time is refused', async () => {
      await assertFails(tryBook('alice', { start: 300, end: 360 }));
    });

    it('after closing time is refused', async () => {
      await assertFails(tryBook('alice', { start: 1380, end: 1440 }));
    });

    it('off the slot grid is refused', async () => {
      await assertFails(tryBook('alice', { start: 1110, end: 1170 }));
    });

    it('more than 4 slots is refused', async () => {
      await assertFails(tryBook('alice', { start: 1020, end: 1320 }));
    });

    it('startAt that does not match the date + minute is refused', async () => {
      await assertFails(tryBook('alice', {
        override: { startAt: Timestamp.fromMillis(Date.now() + 86400000) },
      }));
    });

    it('a cancellation policy different from the stadium is refused', async () => {
      await assertFails(tryBook('alice', { override: { freeCancelHours: 0 } }));
    });
  });

  describe('venue', () => {
    it('a suspended shop cannot be booked', async () => {
      await assertFails(tryBook('alice', { venue: h.VENUES.c }));
    });

    it('an unlisted shop cannot be booked', async () => {
      await env.withSecurityRulesDisabled(async (ctx) => {
        await setDoc(doc(ctx.firestore(), 'shops/shop-a'),
          { isListed: false }, { merge: true });
      });
      await assertFails(tryBook('alice'));
    });

    it('an inactive court cannot be booked', async () => {
      await env.withSecurityRulesDisabled(async (ctx) => {
        await setDoc(doc(ctx.firestore(), 'stadiums/st-a/courts/ct-a'),
          { isActive: false }, { merge: true });
      });
      await assertFails(tryBook('alice'));
    });

    it('a court with a mismatched shopId is refused', async () => {
      await assertFails(tryBook('alice', { override: { shopId: 'shop-b' } }));
    });
  });

  describe('who is booking', () => {
    it('a customer blacklisted by the shop is refused there', async () => {
      await env.withSecurityRulesDisabled(async (ctx) => {
        await setDoc(doc(ctx.firestore(), 'shops/shop-a/blacklist/alice'), {
          shopId: 'shop-a', customerId: 'alice', customerNameSnapshot: 'Alice',
          reason: 'noShow', createdBy: 'adminA', createdAt: Timestamp.now(),
        });
      });
      await assertFails(tryBook('alice'));
    });

    it('... but can still book at another shop', async () => {
      await env.withSecurityRulesDisabled(async (ctx) => {
        await setDoc(doc(ctx.firestore(), 'shops/shop-a/blacklist/alice'), {
          shopId: 'shop-a', customerId: 'alice', customerNameSnapshot: 'Alice',
          reason: 'noShow', createdBy: 'adminA', createdAt: Timestamp.now(),
        });
      });
      await assertSucceeds(tryBook('alice', { venue: h.VENUES.b }));
    });

    it('cannot book in someone else\'s name', async () => {
      await assertFails(tryBook('alice', { override: { customerId: 'bob' } }));
    });

    it('the name snapshot must match the profile', async () => {
      await assertFails(tryBook('alice', { override: { customerNameSnapshot: 'Bob' } }));
    });

    it('an inactive customer cannot book', async () => {
      await assertFails(tryBook('carol'));
    });

    it('a shop admin cannot create a booking', async () => {
      await assertFails(tryBook('adminA'));
    });

    it('a signed-out user cannot book', async () => {
      const req = h.bookingRequest({ uid: 'alice', bookingId: 'b1' });
      await assertFails(h.commitBooking(env.unauthenticatedContext().firestore(), req));
    });
  });
});
