# Archived Cloud Functions (Blaze plan only)

These TypeScript Cloud Functions are **not deployed and not used**. The project runs on the
Firebase **Spark (free) plan**, which cannot deploy Cloud Functions. Everything they did is now
enforced by `firestore.rules` plus client code (see `docs/architecture/firestore_schema.md`):

| Archived function | Replacement on Spark |
|---|---|
| `onUserCreated` (custom claims + `users/{uid}`) | Client creates `users/{uid}` as `customer`; rules pin role/shopId/isActive. Roles live in `users/{uid}`, not claims. |
| `updateUserStatus` (disable Auth + `isActive`) | Superadmin writes `users/{uid}.isActive` directly (rules-checked). Auth accounts are no longer disabled. |
| `onShopWrittenSyncStadiums` / `onStadiumWrittenSyncPublished` | `stadiums.isPublished` is client-maintained (superadmin/shop-admin write paths, Phase 4+). The booking rule re-checks the shop itself. |
| `onCourtWrittenSyncMinPrice` | `stadiums.minHourlyPrice` is client-maintained by the shop admin (Phase 5), display only. |
| `booking/policy.ts` | Mirrored in `firestore.rules` (booking create rule) and `lib/core/constants/booking_policy.dart`. |
| `scripts/set-superadmin.ts` | Console bootstrap: set `users/{uid}.role = 'superadmin'` in Firestore. |

`functions/lib`, `node_modules` and `package-lock.json` were deleted; `firebase.json` no longer
has a `functions` entry.

## Restoring (only after upgrading to Blaze)

1. Move this folder back to `functions/` and add the `functions` block back to `firebase.json`.
2. `npm --prefix functions install && npm --prefix functions run build`.
3. The code still assumes **custom claims** and the old `days/` lock doc. Before deploying, port it
   to the current design (roles in `users/{uid}`, slot lock docs under
   `stadiums/{sid}/courts/{cid}/slots/`), or the rules and the functions will disagree.
