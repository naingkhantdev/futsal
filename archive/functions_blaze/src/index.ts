import { initializeApp } from "firebase-admin/app";

initializeApp();

export { onUserCreated } from "./auth/onUserCreated";
export { updateUserStatus } from "./users/updateUserStatus";
export {
  onShopWrittenSyncStadiums,
  onStadiumWrittenSyncPublished,
} from "./stadiums/publishedSync";
export { onCourtWrittenSyncMinPrice } from "./stadiums/minHourlyPriceSync";
