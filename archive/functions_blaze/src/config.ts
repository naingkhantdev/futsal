/**
 * Deployment region = Firestore database location (asia-southeast1,
 * Singapore, closest to Myanmar). Firestore triggers must run in the
 * database region. The Flutter client must call callables with
 * FirebaseFunctions.instanceFor(region: kFunctionsRegion) (it defaults to
 * us-central1).
 */
export const REGION = "asia-southeast1";
