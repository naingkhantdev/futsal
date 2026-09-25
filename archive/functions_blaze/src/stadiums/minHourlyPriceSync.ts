import { getFirestore } from "firebase-admin/firestore";
import * as logger from "firebase-functions/logger";
import { onDocumentWritten } from "firebase-functions/v2/firestore";

import { isValidAmount } from "../booking/policy";
import { REGION } from "../config";
import { COURTS, CourtFields, STADIUMS, StadiumFields } from "../collections";

/**
 * Keeps stadiums/{id}.minHourlyPrice = lowest hourlyPrice (int MMK) among
 * the stadium's active courts, or null when there are none. Used for the
 * "From MMK x/hr" label in discovery without reading every court.
 *
 * Writes only when the value changes. The stadium trigger ignores
 * minHourlyPrice edits, so there is no loop.
 */
export const onCourtWrittenSyncMinPrice = onDocumentWritten(
  { document: `${STADIUMS}/{stadiumId}/${COURTS}/{courtId}`, region: REGION },
  async (event) => {
    const before = event.data?.before;
    const after = event.data?.after;
    const relevant =
      !before?.exists ||
      !after?.exists ||
      before.get(CourtFields.hourlyPrice) !== after.get(CourtFields.hourlyPrice) ||
      before.get(CourtFields.isActive) !== after.get(CourtFields.isActive);
    if (!relevant) return;

    const db = getFirestore();
    const stadiumRef = db.collection(STADIUMS).doc(event.params.stadiumId);

    const changed = await db.runTransaction(async (tx) => {
      const stadium = await tx.get(stadiumRef);
      if (!stadium.exists) return false;
      const courts = await tx.get(stadiumRef.collection(COURTS));

      let min: number | null = null;
      for (const court of courts.docs) {
        if (court.get(CourtFields.isActive) !== true) continue;
        const price: unknown = court.get(CourtFields.hourlyPrice);
        if (!isValidAmount(price)) continue;
        if (min === null || price < min) min = price;
      }

      const current: unknown = stadium.get(StadiumFields.minHourlyPrice);
      if ((current ?? null) === min) return false;
      tx.update(stadiumRef, { [StadiumFields.minHourlyPrice]: min });
      return true;
    });

    if (changed) {
      logger.info("Stadium minHourlyPrice synced", {
        stadiumId: event.params.stadiumId,
      });
    }
  },
);
