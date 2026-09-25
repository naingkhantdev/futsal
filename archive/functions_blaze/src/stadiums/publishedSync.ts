import { DocumentReference, getFirestore } from "firebase-admin/firestore";
import * as logger from "firebase-functions/logger";
import { onDocumentWritten } from "firebase-functions/v2/firestore";

import { isShopBookable } from "../booking/policy";
import { REGION } from "../config";
import { SHOPS, STADIUMS, ShopFields, StadiumFields } from "../collections";

/**
 * Keeps stadiums/{id}.isPublished ==
 *   shop.status == "active" && shop.isListed == true && stadium.isActive == true
 *
 * Customers can only read/list stadiums with isPublished == true
 * (firestore.rules), so this is what hides a suspended/unlisted shop's
 * venues. Courts inherit visibility through the parent stadium.
 *
 * Loop safety: the transaction writes only when the stored value differs,
 * so the stadium trigger re-fired by our own write recomputes the same
 * value and stops.
 */
export async function syncStadiumPublished(
  stadiumRef: DocumentReference,
): Promise<boolean> {
  const db = getFirestore();
  return db.runTransaction(async (tx) => {
    const stadium = await tx.get(stadiumRef);
    if (!stadium.exists) return false;

    const shopId = stadium.get(StadiumFields.shopId);
    let shopBookable = false;
    if (typeof shopId === "string" && shopId !== "") {
      const shop = await tx.get(db.collection(SHOPS).doc(shopId));
      shopBookable =
        shop.exists &&
        isShopBookable(shop.get(ShopFields.status), shop.get(ShopFields.isListed));
    }

    const expected = shopBookable && stadium.get(StadiumFields.isActive) === true;
    if (stadium.get(StadiumFields.isPublished) === expected) return false;

    tx.update(stadiumRef, { [StadiumFields.isPublished]: expected });
    return true;
  });
}

/** PLATFORM: a shop's status / listing changed -> resync its stadiums. */
export const onShopWrittenSyncStadiums = onDocumentWritten(
  { document: `${SHOPS}/{shopId}`, region: REGION },
  async (event) => {
    const before = event.data?.before;
    const after = event.data?.after;
    const visibilityChanged =
      !before?.exists ||
      !after?.exists ||
      before.get(ShopFields.status) !== after.get(ShopFields.status) ||
      before.get(ShopFields.isListed) !== after.get(ShopFields.isListed);
    if (!visibilityChanged) return;

    const shopId = event.params.shopId;
    const stadiums = await getFirestore()
      .collection(STADIUMS)
      .where(StadiumFields.shopId, "==", shopId)
      .select()
      .get();

    const results = await Promise.all(
      stadiums.docs.map((doc) => syncStadiumPublished(doc.ref)),
    );
    const updated = results.filter(Boolean).length;
    logger.info("Shop visibility synced to stadiums", {
      shopId,
      stadiums: stadiums.size,
      updated,
    });
  },
);

/**
 * SHOP: a stadium was created, or its isActive / shopId / isPublished
 * changed -> recompute. Other edits (name, minHourlyPrice, ...) are ignored.
 */
export const onStadiumWrittenSyncPublished = onDocumentWritten(
  { document: `${STADIUMS}/{stadiumId}`, region: REGION },
  async (event) => {
    const before = event.data?.before;
    const after = event.data?.after;
    if (!after?.exists) return;

    const relevant =
      !before?.exists ||
      before.get(StadiumFields.isActive) !== after.get(StadiumFields.isActive) ||
      before.get(StadiumFields.shopId) !== after.get(StadiumFields.shopId) ||
      before.get(StadiumFields.isPublished) !== after.get(StadiumFields.isPublished);
    if (!relevant) return;

    const updated = await syncStadiumPublished(after.ref);
    if (updated) {
      logger.info("Stadium isPublished synced", { stadiumId: event.params.stadiumId });
    }
  },
);
