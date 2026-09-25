/**
 * One-off bootstrap: grant the PLATFORM `superadmin` role to an existing
 * Firebase Auth account. Run locally by the platform owner only — never
 * deployed, never callable from the app.
 *
 * Steps:
 *  1. Register the owner account in the app (it becomes a customer).
 *  2. Firebase console -> Project settings -> Service accounts ->
 *     "Generate new private key". Save it OUTSIDE the repo (or as
 *     functions/service-account.json, which is git-ignored). Keep it secret.
 *  3. From the functions/ folder:
 *       npm install
 *       # macOS/Linux
 *       GOOGLE_APPLICATION_CREDENTIALS=/path/to/key.json npm run set-superadmin -- owner@example.com
 *       # Windows PowerShell
 *       $env:GOOGLE_APPLICATION_CREDENTIALS="C:\path\to\key.json"; npm run set-superadmin -- owner@example.com
 *  4. The app picks the new role up automatically (it watches
 *     users/{uid}.claimsUpdatedAt and refreshes its ID token). If the app is
 *     closed, the next launch sees it.
 *  5. Delete / rotate the key when done if you don't need it again.
 *
 * Effect: claims become exactly { role: "superadmin" } (any shopId removed),
 * users/{uid} is created or updated with role "superadmin", isActive true,
 * and the account is re-enabled if it was disabled.
 */
import { applicationDefault, initializeApp } from "firebase-admin/app";
import { getAuth } from "firebase-admin/auth";
import { FieldValue, getFirestore } from "firebase-admin/firestore";

import { USERS, UserFields } from "../src/collections";
import { RoleClaims } from "../src/roles";

async function main(): Promise<void> {
  const email = process.argv[2]?.trim();
  if (!email) {
    console.error("Usage: npm run set-superadmin -- <email>");
    process.exit(1);
  }

  initializeApp({ credential: applicationDefault() });
  const auth = getAuth();
  const db = getFirestore();

  const user = await auth.getUserByEmail(email);
  const claims: RoleClaims = { role: "superadmin" };

  // Claims first, then claimsUpdatedAt (the client's refresh signal).
  await auth.setCustomUserClaims(user.uid, claims);
  if (user.disabled) {
    await auth.updateUser(user.uid, { disabled: false });
  }

  const ref = db.collection(USERS).doc(user.uid);
  const snap = await ref.get();
  const now = FieldValue.serverTimestamp();
  await ref.set(
    {
      [UserFields.email]: user.email ?? email,
      [UserFields.role]: "superadmin",
      [UserFields.shopId]: null,
      [UserFields.isActive]: true,
      [UserFields.updatedAt]: now,
      [UserFields.claimsUpdatedAt]: now,
      ...(snap.exists
        ? {}
        : {
            [UserFields.name]: user.displayName ?? "",
            [UserFields.phone]: user.phoneNumber ?? null,
            [UserFields.profileImage]: null,
            [UserFields.createdAt]: now,
          }),
    },
    { merge: true },
  );

  console.log(`OK: ${email} (${user.uid}) is now superadmin.`);
}

main().catch((error: unknown) => {
  console.error("Failed:", error instanceof Error ? error.message : error);
  process.exit(1);
});
