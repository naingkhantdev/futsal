/**
 * Platform roles and the custom-claims shape.
 *
 * Wire values must match the Flutter `UserRole` enum names
 * (lib/core/constants/domain_enums.dart) and firestore.rules.
 *
 * Scopes:
 *  - superadmin -> PLATFORM (all shops, all data)
 *  - shopAdmin  -> SHOP (only records whose shopId === claims.shopId)
 *  - customer   -> CUSTOMER (own profile / bookings, public shop data)
 */
export const ROLES = ["superadmin", "shopAdmin", "customer"] as const;
export type Role = (typeof ROLES)[number];

/**
 * Custom claims set on Firebase Auth users. `shopId` is present only for
 * shopAdmin (set by the future shop-admin invitation flow).
 */
export interface RoleClaims {
  role: Role;
  shopId?: string;
}

export function isRole(value: unknown): value is Role {
  return typeof value === "string" && (ROLES as readonly string[]).includes(value);
}
