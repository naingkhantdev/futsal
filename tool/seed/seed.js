/**
 * Test-account seeder (Spark plan friendly: runs locally, no Cloud Functions).
 *
 * Creates / resets 3 accounts and the shop the shop admin belongs to:
 *   superadmin@test.com  role superadmin
 *   shopadmin@test.com   role shopAdmin, shopId "seed-shop"
 *   customer@test.com    role customer
 * All with password Test1234!
 *
 * Uses the Admin SDK, which bypasses firestore.rules. TEST PROJECTS ONLY.
 * Safe to run again: existing accounts get their password and role reset.
 *
 * Run from this folder:
 *   npm install
 *   node seed.js
 * The service-account key is read from ./service-account.json, or from the
 * path in GOOGLE_APPLICATION_CREDENTIALS.
 */
const fs = require('fs');
const path = require('path');
const admin = require('firebase-admin');

const PASSWORD = 'Test1234!';
const SHOP_ID = 'seed-shop';

const ACCOUNTS = [
  { email: 'superadmin@test.com', name: 'Test Superadmin', role: 'superadmin', shopId: null },
  { email: 'shopadmin@test.com', name: 'Test Shop Admin', role: 'shopAdmin', shopId: SHOP_ID },
  { email: 'customer@test.com', name: 'Test Customer', role: 'customer', shopId: null },
];

function credential() {
  const local = path.join(__dirname, 'service-account.json');
  if (fs.existsSync(local)) return admin.credential.cert(require(local));
  if (process.env.GOOGLE_APPLICATION_CREDENTIALS) return admin.credential.applicationDefault();
  console.error('No key found. Put service-account.json in tool/seed/ or set GOOGLE_APPLICATION_CREDENTIALS.');
  process.exit(1);
}

async function upsertAuthUser(auth, { email, name }) {
  try {
    const user = await auth.getUserByEmail(email);
    return auth.updateUser(user.uid, { password: PASSWORD, displayName: name, disabled: false });
  } catch (e) {
    if (e.code !== 'auth/user-not-found') throw e;
    return auth.createUser({ email, password: PASSWORD, displayName: name });
  }
}

async function main() {
  admin.initializeApp({ credential: credential() });
  const auth = admin.auth();
  const db = admin.firestore();
  const now = admin.firestore.FieldValue.serverTimestamp();

  const uids = {};
  for (const account of ACCOUNTS) {
    const user = await upsertAuthUser(auth, account);
    uids[account.role] = user.uid;

    const ref = db.collection('users').doc(user.uid);
    const exists = (await ref.get()).exists;
    await ref.set(
      {
        name: account.name,
        email: account.email,
        role: account.role,
        shopId: account.shopId,
        isActive: true,
        updatedAt: now,
        ...(exists ? {} : { createdAt: now }),
      },
      { merge: true },
    );
    console.log(`${account.role.padEnd(10)} ${account.email}  uid=${user.uid}`);
  }

  const shopRef = db.collection('shops').doc(SHOP_ID);
  const shopExists = (await shopRef.get()).exists;
  await shopRef.set(
    {
      name: 'Seed Futsal',
      city: 'Yangon',
      status: 'active',
      isListed: true,
      approvedAt: now,
      updatedAt: now,
      ...(shopExists ? {} : { createdAt: now }),
    },
    { merge: true },
  );
  await shopRef.collection('private').doc('details').set(
    {
      shopId: SHOP_ID,
      adminIds: [uids.shopAdmin],
      approvedBy: uids.superadmin,
      updatedAt: now,
    },
    { merge: true },
  );
  console.log(`shop       shops/${SHOP_ID}  (active, listed)`);
  console.log(`\nPassword for all accounts: ${PASSWORD}`);
}

main().then(
  () => process.exit(0),
  (e) => {
    console.error(e);
    process.exit(1);
  },
);
