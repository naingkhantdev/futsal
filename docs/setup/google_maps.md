# Google Maps setup (stadium location)

Stadiums store an optional map pin (`latitude` / `longitude`, validated by `firestore.rules` → `validLocation`).
Customers see it on the stadium page with **Directions**; shop admins set it in the stadium form.

**Directions / "Open in Google Maps" work with no setup** (they hand off to the Maps app or website).
Only the **in-app map** (static preview + pin picker) needs a Maps SDK key.

## 1. Create the key — keep Firebase on the free Spark plan

The Maps SDK for Android / iOS is free to use, but Google requires a Cloud project **with a billing account**.
Linking billing to the Firebase project (`my-cool-futsal`) would upgrade Firebase to Blaze, so:

1. In Google Cloud Console create a **separate project** (e.g. `futsal-maps`) and attach a billing account to it.
2. Enable **Maps SDK for Android** (and **Maps SDK for iOS** later).
3. Create an API key and **restrict** it:
   - Application restriction: Android apps → package `com.futsalbooking.futsal_booking` + your SHA-1
     (debug: `keytool -list -v -keystore %USERPROFILE%\.android\debug.keystore -alias androiddebugkey -storepass android`).
   - API restriction: Maps SDK for Android (and iOS).
4. Optional: set a budget alert on that project.

## 2. Android

Add to `android/local.properties` (gitignored, never commit the key):

```
MAPS_API_KEY=AIza...your key...
```

`android/app/build.gradle` injects it into `AndroidManifest.xml` (`com.google.android.geo.API_KEY`).

## 3. Turn the in-app map on

```
flutter pub get
flutter run --dart-define=MAPS_ENABLED=true
```

Without `MAPS_ENABLED=true` the app shows a map-free location card instead of grey tiles
(`lib/core/constants/maps_config.dart`). For VS Code add `"toolArgs": ["--dart-define=MAPS_ENABLED=true"]`
to the launch configuration.

## iOS (when the iOS project is set up)

The `ios/` folder currently has no `AppDelegate.swift` / Podfile. After regenerating it, in `AppDelegate.swift`:

```swift
import GoogleMaps
// in application(_:didFinishLaunchingWithOptions:)
GMSServices.provideAPIKey("YOUR_IOS_KEY")
```

## Versions

Pinned for Flutter 3.22.2: `google_maps_flutter ^2.10.1` (2.11+ needs Flutter 3.27), `url_launcher ^6.3.1`.
