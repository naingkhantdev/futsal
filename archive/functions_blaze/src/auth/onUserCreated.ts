import { getAuth } from "firebase-admin/auth";
import { FieldValue, getFirestore } from "firebase-admin/firestore";
import * as logger from "firebase-functions/logger";
import * as functionsV1 from "firebase-functions/v1";

import { REGION } from "../config";
import { USERS, UserFields } from "../collections";
import { isRole, RoleClaims } from "../roles";

/**
 * Auth onCreate (v1 trigger; blocking functions would need Identity Platform).
 *
 * CUSTOMER scope: every self-registered account becomes a customer. The
 * client never chooses a role.
 *
 * Guarantees:
 *  - Idempotent (triggers are at-least-once): re-running is a no-op once
 *    the claims and users/{uid} doc exist.
 *  - Never downgrades: if the user already has a valid role claim, or a
 *    server-written users/{uid} doc with a privileged role (e.g. a shop admin
 *    pre-provisioned by the superadmin flow with a chosen uid), claims are
 *    left untouched.
 *  - Order: claims first, then users/{uid}.claimsUpdatedAt, so a client
 *    that refreshes its token on that signal always sees the new claims.
 */
export const onUserCreated = functionsV1
  .region(REGION)
  .auth.user()
  .onCreate(async (user) => {
    const auth = getAuth();
    const db = getFirestore();
    const userRef = db.collection(USERS).doc(user.uid);

    // Re-read: the record passed to the trigger can predate claims set by
    // another server flow right after account creation.
    const fresh = await auth.getUser(user.uid);
    const existingClaims = fresh.customClaims ?? {};
    const existingSnap = await userRef.get();
    const docRole = existingSnap.get(UserFields.role);

    const hasClaimRole = isRole(existingClaims.role);
    const hasPrivilegedDocRole = isRole(docRole) && docRole !== "customer";

    let claimsChanged = false;
    if (!hasClaimRole && !hasPrivilegedDocRole) {
      const claims: RoleClaims = { role: "customer" };
      // Keep unrelated claims; drop any stray shopId (customers have none).
      const { shopId: _dropped, ...rest } = existingClaims;
      void _dropped;
      await auth.setCustomUserClaims(user.uid, { ...rest, ...claims });
      claimsChanged = true;
    }

    const role = hasClaimRole
      ? existingClaims.role
      : hasPrivilegedDocRole
        ? docRole
        : "customer";
    const shopId =
      role === "shopAdmin" && typeof existingClaims.shopId === "string"
        ? existingClaims.shopId
        : null;

    await db.runTransaction(async (tx) => {
      const snap = await tx.get(userRef);
      const now = FieldValue.serverTimestamp();
      if (snap.exists) {
        // Doc already written (retry, or pre-provisioned by a server flow
        // that owns its claims). Never overwrite role / isActive here; only
        // signal a claims change if this run made one.
        if (!claimsChanged) return;
        tx.update(userRef, {
          [UserFields.claimsUpdatedAt]: now,
          [UserFields.updatedAt]: now,
        });
        return;
      }
      tx.create(userRef, {
        [UserFields.name]: user.displayName ?? "",
        [UserFields.email]: user.email ?? "",
        [UserFields.phone]: user.phoneNumber ?? null,
        [UserFields.profileImage]: null,
        [UserFields.role]: role,
        [UserFields.shopId]: shopId,
        [UserFields.isActive]: !fresh.disabled,
        [UserFields.createdAt]: now,
        [UserFields.updatedAt]: now,
        [UserFields.claimsUpdatedAt]: now,
      });
    });

    logger.info("User provisioned", { uid: user.uid, role });
  });
