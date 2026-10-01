# Maps setup (shop + stadium location)

**Nothing to set up.** In-app maps use **OpenStreetMap** tiles through `flutter_map`: no API key,
no Google Cloud project, no billing account. (Google Maps SDK was dropped: it requires a billing
account, which isn't available from Myanmar.)

## What uses the map

- **Pick on map** (superadmin shop form, shop-admin stadium form): drag the map until the pin is on the
  venue. The bottom bar shows the detected township / city / street as you move
  (phone's own geocoder via the `geocoding` package, also free / no key). "Use this location" fills the
  form's address from the pin. Screen: `LocationPickerScreen`.
- **Location card** (shop detail, shop profile, stadium pages): still map preview + gold pin.
  Tap the map or **Directions** to open the Google Maps app / website (no key needed for that).

Shops and stadiums store `latitude` / `longitude` (+ `address` / `township` / `city` filled from the pin),
validated by `firestore.rules` → `validLocation` (both or neither, valid range).

## OpenStreetMap tile policy

The free `tile.openstreetmap.org` servers are fine for this app's light use (admins pinning venues, venue
previews) as long as the app:

- sends its package name as User-Agent (`MapsConfig.userAgentPackage`), and
- shows the "© OpenStreetMap contributors" credit on every map (`VenueMap` does this).

If traffic grows (many customers viewing maps), switch `MapsConfig.tileUrl` to a hosted tile provider with a
free tier (e.g. MapTiler, Stadia Maps); only that one constant changes.

## Versions

Pinned for Flutter 3.22.2: `flutter_map ^7.0.2` + `latlong2 ^0.9.1` (8.x needs a newer Flutter),
`geocoding ^3.0.0` (4.x needs newer Android Gradle), `url_launcher ^6.3.1`.
