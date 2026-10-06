# Firestore rules tests

`firestore.rules` is the only line of defence (Spark plan, no Cloud Functions), so these tests
run real requests against the Firestore emulator and check the rules accept or refuse them.

| File | Covers |
|---|---|
| `tests/double_booking.test.js` | slot lock docs: same slot, overlap, concurrency, partial slots, overwrite, rebook after cancel, blocked slots |
| `tests/booking_validation.test.js` | price tampering, status/payment on create, date/hours/grid/max slots, suspended/unlisted shop, blacklist, impersonation, inactive users |
| `tests/booking_lifecycle.test.js` | cancel / confirm / reject / complete, payment transitions, who may do each |
| `tests/roles_and_shops.test.js` | self-registration, role changes, shop admin A vs shop B isolation |

Fixtures in `tests/helpers.js` build bookings the same way as
`lib/data/repositories/booking_request_builder.dart`. When a rule or a booking field changes,
update both.

## Run

Needs Node 22+, firebase-tools, and Java 21 (the Android Studio JDK works).

```
cd firestore-tests
npm install
npm test
```

`npm test` starts the Firestore emulator under the offline project `demo-futsal` (never touches
the real project), runs every test file one after another, and stops the emulator.

If `java` is not on PATH (PowerShell):

```
$env:JAVA_HOME = "C:\Program Files\Android\Android Studio\jbr"
$env:Path = "$env:JAVA_HOME\bin;$env:Path"
npm test
```

With an emulator already running (`firebase emulators:start --only firestore --project demo-futsal`):

```
$env:FIRESTORE_EMULATOR_HOST = "127.0.0.1:8080"
npm run test:run
```
