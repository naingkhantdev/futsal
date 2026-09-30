# Notifications (Spark plan)

Two separate channels. Nothing here needs Cloud Functions or billing.

## 1. In-app notifications (automatic, booking events)

Collection `notifications/{bookingId}_{type}`. The app writes one right after a booking change
(`BookingRepositoryImpl._notify`, best effort); `firestore.rules` checks every field against the
stored booking, so nobody can fake one.

| Event | Written by | Goes to |
|---|---|---|
| `bookingRequested` | customer (create) | the shop's inbox (all its admins) |
| `bookingCancelled` | customer (cancel) | the shop's inbox |
| `bookingConfirmed` | shop admin / superadmin | the customer |
| `bookingRejected` | shop admin / superadmin | the customer |

Shown in: customer **Notifications** tab (badge = unread count), shop admin bell on the Dashboard
(`/shop-admin/notifications`), and a snackbar when a new one arrives while the app is open.

**Limit:** the phone gets no system notification while the app is closed. That needs a server to
send FCM (Blaze + a Cloud Function on `notifications` create). The docs already have everything
such a function needs.

Deploy after pulling:

```
firebase deploy --only firestore:rules,firestore:indexes
```

## 2. Push notifications (manual, from the Firebase console)

On sign-in the app asks for notification permission and subscribes to topics
(`lib/core/constants/push_topics.dart`):

| Topic | Who |
|---|---|
| `all` | every signed-in user |
| `role_customer`, `role_shopAdmin`, `role_superadmin` | users of that role |
| `shop_{shopId}` | admins of that shop |

On sign-out the install's token is deleted, which drops all topics.

To send: Firebase console → **Messaging** → **New campaign** → **Notifications** → fill in
title/text → **Target: Topic** → e.g. `role_customer` → Review → Publish.

Optional: under **Additional options → Custom data** add key `route` with an in-app path
(e.g. `/customer/explore`). Tapping the push opens it; without it the app opens the inbox.
While the app is open, a push shows as a snackbar instead of a system notification.

Anyone can subscribe to a topic, so never send private data in a topic push.

## Platform setup

- **Android:** done (`POST_NOTIFICATIONS` in the manifest, asked at runtime on Android 13+).
- **iOS:** not set up. Needs `ios/Runner/GoogleService-Info.plist`, the Push Notifications and
  Background Modes → Remote notifications capabilities in Xcode, and an APNs key uploaded under
  Firebase console → Project settings → Cloud Messaging.
