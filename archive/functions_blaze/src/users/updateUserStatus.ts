import { getAuth } from "firebase-admin/auth";
import { FieldValue, getFirestore } from "firebase-admin/firestore";
import * as logger from "firebase-functions/logger";
import { HttpsError, onCall } from "firebase-functions/v2/https";

import { REGION } from "../config";
import { USERS, UserFields } from "../collections";

interface UpdateUserStatusRequest {
  uid: string;
  isActive: boolean;
}

interface UpdateUserStatusResponse {
  uid: string;
  isActive: boolean;
}

/**
 * PLATFORM scope — superadmin only.
 *
 * Activates / deactivates any user account:
 *  - Firebase Auth `disabled` flag (blocks sign-in and token refresh)
 *  - users/{uid}.isActive (drives the client's "account unavailable" screen)
 *  - on deactivate, revokes refresh tokens so existing sessions end.
 *
 * Authorization comes from the caller's ID-token custom claim, never from
 * request data. A superadmin cannot deactivate their own account.
 */
export const updateUserStatus = onCall<
  UpdateUserStatusRequest,
  Promise<UpdateUserStatusResponse>
>(
  // TODO(phase15): enforceAppCheck: true once App Check tokens are registered.
  { region: REGION },
  async (request) => {
    const caller = request.auth;
    if (!caller) {
      throw new HttpsError("unauthenticated", "Sign in required.");
    }
    if (caller.token.role !== "superadmin") {
      throw new HttpsError("permission-denied", "Superadmin only.");
    }

    const { uid, isActive } = (request.data ?? {}) as Partial<UpdateUserStatusRequest>;
    if (typeof uid !== "string" || uid.trim() === "" || typeof isActive !== "boolean") {
      throw new HttpsError(
        "invalid-argument",
        "Expected { uid: string, isActive: boolean }.",
      );
    }
    if (uid === caller.uid && !isActive) {
      throw new HttpsError(
        "failed-precondition",
        "You can't deactivate your own account.",
      );
    }

    const auth = getAuth();
    try {
      await auth.getUser(uid);
    } catch {
      throw new HttpsError("not-found", "User not found.");
    }

    await auth.updateUser(uid, { disabled: !isActive });
    if (!isActive) {
      await auth.revokeRefreshTokens(uid);
    }

    // merge: tolerate a missing doc (e.g. legacy account) without clobbering
    // other fields. Only server code writes isActive (rules deny clients).
    await getFirestore()
      .collection(USERS)
      .doc(uid)
      .set(
        {
          [UserFields.isActive]: isActive,
          [UserFields.updatedAt]: FieldValue.serverTimestamp(),
        },
        { merge: true },
      );

    logger.info("User status updated", { uid, isActive, by: caller.uid });
    return { uid, isActive };
  },
);
