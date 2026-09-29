# Futsal Booking — Design System & Phase 1 UX Spec

Owner: Senior UI/UX Designer · Consumer: Senior Flutter Developer · Target: Flutter 3.22.2 / Material 3
Scope: PLATFORM-wide UI foundation (no data, no `shopId` impact). Everything here lives in `lib/core/theme`,
`lib/core/widgets`, `lib/core/router`. No hardcoded colors, sizes or text styles in feature widgets.

---

## 0. v5 visual language: "Premium" (supersedes §1–5 and all earlier versions where they conflict)

Restrained · premium · smooth. Replaced the colorful v4 "Floodlight" (2026-09-29): the user rejected colorful
and green designs and asked for a premium look with smooth motion and a premium font. The code in
`lib/core/theme` is the source of truth for exact values.

- **Type: Plus Jakarta Sans** (bundled, static 400–800, OFL) + **Noto Sans Myanmar** (bundled, 400–700, OFL) as
  `fontFamilyFallback`, so Burmese looks the same on every phone. Headings Bold with tight negative tracking;
  body Regular, line height 1.5–1.55, +0.1 tracking; labels SemiBold, gently tracked. Myanmar keeps its own
  taller line heights and zero tracking (`AppTypography.forMyanmar`).
- **Color: the logo's navy + gold only.** Light: navy `primary` `#0F1B33`, gold `secondary` `#8C6A2A` (text-safe)
  / `AppGradients.gold` `#C9A355` (accents), warm ivory page `#F7F6F2`, white cards. Dark: gold `primary` on a
  deep navy page. Gold is an accent (eyebrows, prices on photos, rings, icons), never a large fill. Status tones are
  muted: success bronze-gold, warning burnt orange, info slate, danger red. No green, no multi-color accents.
- **Gradients: `AppGradients`** tonal navy only: `hero` (the one navy fill: BrandMark, `BookingTicket`), `primary`
  (buttons, selected slot), `pitch` (photo placeholder), `scrim` (navy veil so text reads on venue photos);
  `gold` accent color.
- **Imagery first (2026-09-29 "not AI-generated" pass):** venue photos carry the customer screens. `StadiumCard`
  is the photo itself (name / place / facilities on the `scrim`, price in gold, no white frame or chips);
  stadium details opens on a full-bleed `StadiumPhoto` header. No photo -> `PitchPlaceholder` (drawn court
  lines), never a clip-art ball icon.
- **Depth:** flat by default. `AppCard`, `StatCard`, `GroupedList` = white + hairline, no shadow; shadows only
  on things that float (bars, sheets, dialogs, `SearchField(raised)`).
- **Components:** `HeroHeader` is an editorial intro (gold eyebrow such as today's date, large title, muted
  subtitle), not a box: no gradient, watermark or rule · section titles are plain `titleLarge` with space above
  (no accent bars) · `StatCard` flat, small muted icon + label, big `displaySmall` number, `highlight` = gold
  border + dot · repeated rows (bookings, customers, courts) are flat rows in one `GroupedList` with inset
  hairlines, not a card per row (`BookingGroup`) · `BookingTicket` navy match ticket for "next game" and the
  confirmation · `DayStrip` weekday-over-number day picker (home, slot grid) · `PrimaryButton` navy sheen ·
  `SlotTile` selected = navy with a gold ring · `BrandMark` navy tile, gold ball.
- **Copy:** task-first, no filler greetings ("Ready to play?", "Welcome back"). The sample-data note is one
  muted line at the end of preview content, not a colored banner on top.
- **Motion (`AppMotion`, `core/widgets/motion.dart`):** `AppScrollBehavior` = bouncing momentum scroll everywhere
  (set on `MaterialApp.router`); Cupertino slide page transitions on all platforms; `FadeSlideIn` staggered
  fade + 16dp rise, used once per page (`PreviewBody` enters as one block; photo headers show at once),
  limited to the first 700 ms of an `EntranceScope` so lazy lists don't re-animate on scroll back; `AsyncValueView` crossfades skeleton → content; `Pressable` scales tappable
  cards to 0.975. Everything respects the OS reduce-motion setting.

## 1. Design direction (v1 — see §0 for the current look)

- **Premium, calm, fast.** Neutral cool-grey surfaces, one confident brand blue, strong photography. Color is reserved for meaning (CTA, status).
- **Sports energy through imagery and type, not decoration.** Big stadium photos, bold numerals (times, prices, KPIs), tight headings. No gradients, near-zero shadows.
- **Booking CTA always visible.** One filled primary button per screen, sticky at the bottom on booking screens.
- **Status is never color-only.** Every state = container color + icon + text label.
- **Admin = dense but calm.** Same system, tighter lists, KPI cards, filters as chips.

Why blue, not pitch-green: green is reserved for *success/available/paid/active* semantics. A green brand would make "Confirmed" and a primary button indistinguishable. Blue keeps brand and status channels separate.

---

## 2. Color system

Construct both schemes with the explicit `ColorScheme(...)` constructor (not `fromSeed`), so values are exact.
Unlisted optional roles (`primaryFixed*`, etc.) may be left at defaults — they are not used by our components.

### 2.1 ColorScheme — Light (`Brightness.light`)

| Role | Hex | | Role | Hex |
|---|---|---|---|---|
| primary | `#1F4FD1` | | onPrimary | `#FFFFFF` |
| primaryContainer | `#DCE4FF` | | onPrimaryContainer | `#0A2472` |
| secondary | `#4F5B76` | | onSecondary | `#FFFFFF` |
| secondaryContainer | `#DDE3F3` | | onSecondaryContainer | `#111C33` |
| tertiary | `#4F5B76` (= secondary, unused) | | onTertiary | `#FFFFFF` |
| tertiaryContainer | `#DDE3F3` | | onTertiaryContainer | `#111C33` |
| error | `#BA1A1A` | | onError | `#FFFFFF` |
| errorContainer | `#FFDAD6` | | onErrorContainer | `#410002` |
| surface | `#F8F9FC` | | onSurface | `#151A23` |
| surfaceDim | `#D8DCE4` | | surfaceBright | `#F8F9FC` |
| surfaceContainerLowest | `#FFFFFF` | | onSurfaceVariant | `#4A5263` |
| surfaceContainerLow | `#F2F4F8` | | outline | `#767E8F` |
| surfaceContainer | `#ECEFF4` | | outlineVariant | `#C6CBD5` |
| surfaceContainerHigh | `#E6E9F0` | | inverseSurface | `#2B303A` |
| surfaceContainerHighest | `#E0E4EC` | | onInverseSurface | `#EFF1F6` |
| surfaceTint | `#1F4FD1` | | inversePrimary | `#B4C5FF` |
| shadow | `#000000` | | scrim | `#000000` |

### 2.2 ColorScheme — Dark (`Brightness.dark`)

| Role | Hex | | Role | Hex |
|---|---|---|---|---|
| primary | `#B4C5FF` | | onPrimary | `#002A78` |
| primaryContainer | `#1A3FA8` | | onPrimaryContainer | `#DCE4FF` |
| secondary | `#BDC6DE` | | onSecondary | `#273047` |
| secondaryContainer | `#3D4760` | | onSecondaryContainer | `#DDE3F3` |
| tertiary | `#BDC6DE` (= secondary, unused) | | onTertiary | `#273047` |
| tertiaryContainer | `#3D4760` | | onTertiaryContainer | `#DDE3F3` |
| error | `#FFB4AB` | | onError | `#690005` |
| errorContainer | `#93000A` | | onErrorContainer | `#FFDAD6` |
| surface | `#0F1218` | | onSurface | `#E2E5EC` |
| surfaceDim | `#0F1218` | | surfaceBright | `#353A44` |
| surfaceContainerLowest | `#0A0D12` | | onSurfaceVariant | `#C3C8D3` |
| surfaceContainerLow | `#171B22` | | outline | `#8D93A0` |
| surfaceContainer | `#1B1F27` | | outlineVariant | `#434956` |
| surfaceContainerHigh | `#252A33` | | inverseSurface | `#E2E5EC` |
| surfaceContainerHighest | `#30353E` | | onInverseSurface | `#2B303A` |
| surfaceTint | `#B4C5FF` | | inversePrimary | `#1F4FD1` |
| shadow | `#000000` | | scrim | `#000000` |

### 2.3 Semantic colors — `AppColors` ThemeExtension

| Token | Light | Dark |
|---|---|---|
| success | `#1E7A3C` | `#7BD897` |
| onSuccess | `#FFFFFF` | `#00391A` |
| successContainer | `#D3F5DC` | `#135C2C` |
| onSuccessContainer | `#0B3D1C` | `#C8F2D3` |
| warning | `#8A5A00` | `#F5BE5A` |
| onWarning | `#FFFFFF` | `#452B00` |
| warningContainer | `#FFE7B8` | `#654100` |
| onWarningContainer | `#3D2800` | `#FFE7B8` |
| info | `#0B6E99` | `#7FCFF2` |
| onInfo | `#FFFFFF` | `#003549` |
| infoContainer | `#D2EEFB` | `#004D6B` |
| onInfoContainer | `#003549` | `#D2EEFB` |
| skeleton | `#E6E9F0` (= surfaceContainerHigh) | `#252A33` |
| imagePlaceholder | `#ECEFF4` (= surfaceContainer) | `#1B1F27` |

Rule: badges and banners always use **container + onContainer**. The solid `success/warning/info` are for icons on neutral surfaces only.

### 2.4 Contrast (WCAG 2.1, computed) — pairs we rely on

| Pair | Light | Dark | Use |
|---|---|---|---|
| onPrimary / primary | 6.78 | 7.72 | filled buttons, selected slot |
| primary / surface | 6.44 | 11.05 | text buttons, links |
| onPrimaryContainer / primaryContainer | 11.00 | 7.15 | brand badges |
| onSecondaryContainer / secondaryContainer | 13.21 | 7.21 | selected chips, nav indicator |
| onSurface / surface | 16.57 | 14.87 | body text |
| onSurfaceVariant / surface | 7.45 | 11.18 | secondary text |
| onSurfaceVariant / surfaceContainerHighest | 6.15 | 7.35 | booked slot, neutral badge |
| onError / error | 6.46 | 7.72 | destructive button |
| onErrorContainer / errorContainer | 13.26 | 7.24 | error badge/banner |
| onSuccessContainer / successContainer | 10.52 | 6.59 | success badge |
| onWarningContainer / warningContainer | 11.57 | 7.52 | warning badge |
| onInfoContainer / infoContainer | 10.82 | 7.64 | info badge |
| success, warning, info on white (light icons/text) | 5.38 / 5.93 / 5.67 | — | icon on card |
| outline / surface (non-text, ≥3:1) | 3.87 | 6.08 | input borders, available slot border |

All text pairs ≥ 4.5:1 (AA normal text). `outlineVariant` is decorative only (dividers, card borders) — never the sole boundary of an interactive control.

---

## 3. Typography

**Font: Inter** (SIL OFL), bundled as assets — **no `google_fonts` package** (avoids runtime fetch, works offline, pinned SDK).
Files: `assets/fonts/Inter-Regular.ttf` (400), `Inter-Medium.ttf` (500), `Inter-SemiBold.ttf` (600), `Inter-Bold.ttf` (700), declared in `pubspec.yaml` under family `Inter`.
Non-Latin scripts (e.g. Myanmar) fall back to the platform font automatically — do not set `fontFamilyFallback` unless a gap is found.
If the font files are not yet present, the app still runs on Roboto/SF — the user must add the TTFs.

Numerals: times, prices, KPIs and booking IDs use `fontFeatures: [FontFeature.tabularFigures()]` (expose as `AppTypography.tabular(TextStyle)`).

| Style | Size | Weight | Line height | Letter spacing |
|---|---|---|---|---|
| displayLarge | 57 | 700 | 64 | -0.5 |
| displayMedium | 45 | 700 | 52 | -0.25 |
| displaySmall | 36 | 700 | 44 | 0 |
| headlineLarge | 32 | 700 | 40 | -0.25 |
| headlineMedium | 28 | 700 | 36 | -0.25 |
| headlineSmall | 24 | 600 | 32 | 0 |
| titleLarge | 22 | 600 | 28 | 0 |
| titleMedium | 16 | 600 | 24 | 0.1 |
| titleSmall | 14 | 600 | 20 | 0.1 |
| bodyLarge | 16 | 400 | 24 | 0.15 |
| bodyMedium | 14 | 400 | 20 | 0.25 |
| bodySmall | 12 | 400 | 16 | 0.4 |
| labelLarge | 14 | 600 | 20 | 0.1 |
| labelMedium | 12 | 600 | 16 | 0.5 |
| labelSmall | 11 | 500 | 16 | 0.5 |

Flutter `height` = line height / size (e.g. bodyLarge `height: 1.5`). Colors are applied by the theme (`onSurface`), not baked into styles.
Minimum text size anywhere: 11 (labelSmall). Body copy never below 14. Respect system text scaling (no `textScaler` clamping except capping at 1.3 inside slot tiles and badges).

---

## 4. Tokens

### 4.1 Spacing — `AppSpacing` (4dp base)

| Token | dp | Typical use |
|---|---|---|
| xxs | 2 | icon–text nudge |
| xs | 4 | badge icon gap |
| sm | 8 | chip gap, grid gap, tight stacks |
| md | 12 | list item inner gap |
| lg | 16 | **screen gutter (phone)**, card padding |
| xl | 24 | **screen gutter (tablet)**, section gap, sheet padding |
| xxl | 32 | large section gap |
| xxxl | 48 | empty-state vertical padding |

### 4.2 Radius — `AppRadius`

| Token | dp | Use |
|---|---|---|
| xs | 4 | skeleton text lines |
| sm | 8 | chips, small thumbnails |
| md | 12 | buttons, inputs, slot tiles, snackbars |
| lg | 16 | cards, images in cards |
| xl | 28 | dialogs, bottom-sheet top corners |
| full | 999 | badges, avatars, nav indicator |

### 4.3 Elevation policy
- Default elevation **0** everywhere. Separation = tonal surface step + 1dp `outlineVariant` border.
- Set `surfaceTintColor: Colors.transparent` on AppBar, Card, NavigationBar, BottomSheet, Dialog, Menu (no tint wash).
- Only floating elements get shadow: FAB (elevation 2), menus/dropdowns (elevation 3), snackbar (M3 default). Nothing else.
- AppBar `scrolledUnderElevation: 0`; when content scrolls under it, show a 1dp `outlineVariant` bottom divider instead.

### 4.4 Sizes — `AppSizes`

| Token | Value |
|---|---|
| iconXs / Sm / Md / Lg / Xl | 14 / 16 / 20 / 24 / 32 ; empty-state icon 48 |
| minTouchTarget | 48 (keep `MaterialTapTargetSize.padded`) |
| buttonHeight / buttonHeightLarge | 48 / 56 |
| inputHeight | 56 |
| appBarHeight | 64 |
| navBarHeight | 72 |
| Breakpoints | compact < 600 · medium 600–839 · expanded ≥ 840 · large ≥ 1200 |
| Max width: auth | 440 |
| Max width: forms / detail / booking flow | 640 |
| Max width: lists | 840 |
| Max width: dashboards / grids | 1200 |

Content wider than its max width is centered (`ContentConstraint` widget), background stays `surface`.

### 4.5 Motion
Durations 150ms (state), 250ms (enter/exit), `Curves.easeOutCubic`. If `MediaQuery.disableAnimationsOf(context)` → no pulse, no transitions beyond default route.

---

## 5. Components

Flutter 3.22 note: `ThemeData` still takes `CardTheme`, `DialogTheme`, `TabBarTheme` (not `*ThemeData`), `WidgetStateProperty` is available, use `Color.withOpacity` (not `withValues`).

### 5.1 Buttons

| | FilledButton (primary) | OutlinedButton (secondary) | TextButton (tertiary) |
|---|---|---|---|
| Height | 48 (default) · 56 (`large`, sticky booking CTAs) | 48 / 56 | 40 visual, 48 tap |
| Radius | md 12 | md 12 | md 12 |
| Padding | h 24 | h 24 | h 12 |
| Text | labelLarge (15/600 for large) | labelLarge | labelLarge |
| Colors | primary / onPrimary | fg primary, border 1dp `outline` | fg primary |
| Icon | 20, gap 8 | 20, gap 8 | 20, gap 8 |
| Width | full-width in forms, sheets, sticky bars | full-width when paired below a primary | intrinsic |

- **Destructive**: FilledButton with `error`/`onError` (e.g. "Cancel booking" confirm). **Tonal**: `FilledButton.tonal` (secondaryContainer) for empty-state actions and secondary admin actions.
- **Disabled**: M3 defaults — bg `onSurface` 12%, fg `onSurface` 38%. Disabled buttons must have an adjacent reason when not obvious (e.g. "Select a time to continue" helper above sticky CTA).
- **Loading** (`isLoading: true`): width locked to its idle width; label replaced by `CircularProgressIndicator` 20×20, `strokeWidth 2.5`, color = foreground; keeps **enabled colors** (not greyed); taps ignored; `Semantics(label: '<label>, loading', button: true)`. One loading button per screen; sibling fields become read-only.
- Only **one** FilledButton visible per screen region.

### 5.2 Text inputs — `AppTextField`
- Style: **outlined + filled**. fill `surfaceContainerLowest` (light) / `surfaceContainerLow` (dark); radius md 12; height 56; contentPadding h 16 v 16.
- Borders: enabled 1dp `outline`; focused 2dp `primary`; error 1dp `error`; focused-error 2dp `error`; disabled 1dp `onSurface` 12%, text 38%.
- Label: floating label (`labelText`, bodyLarge → bodySmall when floated), always present — no placeholder-only fields. Hint only for format examples ("09xxxxxxxxx").
- Helper: bodySmall `onSurfaceVariant`, 1 line. Error text replaces helper (bodySmall `error`, `errorMaxLines: 2`) and a trailing `Icons.error_outline` 20 in `error` appears.
- Validation timing: `AutovalidateMode.disabled` until first submit, then `onUserInteraction`. Messages are specific and actionable (see §9).
- Prefix icons 20 `onSurfaceVariant`, optional. Password: suffix `IconButton` toggling `Icons.visibility_outlined` / `Icons.visibility_off_outlined`, tooltip "Show password"/"Hide password".
- Always set `textInputAction`, `keyboardType`, `autofillHints`.
- Search field variant: height 48, radius full, fill `surfaceContainerHigh`, no border, prefix `Icons.search`.

### 5.3 Cards

**Base `AppCard`**: color `surfaceContainerLowest` (light) / `surfaceContainerLow` (dark), elevation 0, border 1dp `outlineVariant`, radius lg 16, padding 16, `clipBehavior: antiAlias`, ink ripple when tappable.

**StadiumCard** (customer lists)
- Image top, **16:9** (vertical list) / **4:3** in horizontal carousels (card width 280). Stadium details hero gallery: **16:10**, full-bleed, page indicator dots.
- `CachedNetworkImage`; placeholder = `imagePlaceholder` + `Icons.sports_soccer_outlined` 32 `onSurfaceVariant`; error = same bg + `Icons.image_not_supported_outlined`.
- Body (padding 16, gap 4): name `titleMedium` (1 line, ellipsis) · location row `Icons.place_outlined` 16 + `bodyMedium onSurfaceVariant` (township, city) · bottom row: "From {price}/hr" `titleSmall` tabular `primary` left; up to 2 facility chips (labelSmall) right; "+N".
- Optional top-left overlay badge on image (e.g. "Unavailable today") using StatusBadge on its container color — never text directly on photos.
- Semantics: whole card is one button: "{name}, {township}, from {price} per hour".

**InfoCard / StatCard** (dashboards)
- Padding 16; top: icon 20 in 40dp circle `primaryContainer`/`onPrimaryContainer` (or semantic container for warnings, e.g. pending count); value `headlineSmall` tabular; label `bodyMedium onSurfaceVariant`; optional footer `labelMedium` (e.g. "+3 today").
- Grid: 2 cols compact, 3 medium, 4 expanded; gap 8 (compact) / 16.

### 5.4 Chips
- **FilterChip** (Explore filters, admin booking filters): height 32, radius sm 8, labelLarge; unselected: transparent bg, border 1dp `outline`, fg `onSurfaceVariant`; selected: `secondaryContainer` bg, no border, fg `onSecondaryContainer`, leading `Icons.check` 18. Horizontal scroll row, gap 8, gutter padding 16. A trailing "Filters" chip with `Icons.tune` opens the filter bottom sheet showing active count ("Filters · 2").
- **ChoiceChip** (single choice: booking tabs in admin, duration): same metrics; selected shows check.
- Tap target stays 48 via padded tap target size.
- **Date strip** (booking): custom tiles 56w × 68h, radius md 12, weekday `labelSmall` + day `titleLarge` tabular; today has a 4dp `primary` dot under day; selected = `primary` bg / `onPrimary`; unavailable (closed day / beyond booking window) = `onSurfaceVariant` text + strike-through-free `Icons.block` 12 under day. 14 days visible via horizontal scroll + calendar icon button for further dates.

### 5.5 Bottom sheets
- `showModalBottomSheet(useSafeArea: true, isScrollControlled: true, showDragHandle: true)`; bg `surfaceContainerLow`; top radius xl 28; max width 640; padding h 24, bottom 24 + safe area.
- Structure: title `titleLarge` → content (scrollable) → action area pinned at bottom (full-width FilledButton, optional OutlinedButton/TextButton "Reset").
- Use for: filters, booking conflict, admin actions with a reason field (reject / cancel / block time), sort.

### 5.6 Dialogs
- Only for short blocking decisions (destructive confirm, discard changes, sign out). bg `surfaceContainerHigh`, radius xl 28, max width 400, padding 24.
- Title `headlineSmall`, body `bodyMedium onSurfaceVariant`, actions right-aligned: TextButton (dismiss, e.g. "Keep booking") + FilledButton / destructive FilledButton (e.g. "Cancel booking"). Verb labels only — never "OK/Yes/No".

### 5.7 Snackbars
- `SnackBarBehavior.floating`, radius md 12, bg `inverseSurface`, text bodyMedium `onInverseSurface`, action `inversePrimary`, margin 16 (above nav bar / sticky CTA), max 2 lines, duration 4s (6s with action).
- Optional leading icon 20 (`Icons.check_circle` success / `Icons.error_outline` error) in `onInverseSurface`.
- For non-critical feedback only ("Stadium saved", "Couldn't refresh"). **Never** for booking success (full-screen confirmation) or booking conflict (sheet).

### 5.8 App bars
- `centerTitle: false`, bg `surface`, elevation 0, `scrolledUnderElevation: 0`, tint transparent, height 64, title `titleLarge`.
- Top-level tabs: title = tab name (Home uses a custom greeting header instead). Pushed screens: back arrow (auto), title = entity name, max 2 actions + overflow `Icons.more_vert`.
- Admin list screens: search `IconButton(Icons.search)` expands to search field.

### 5.9 Navigation — `AdaptiveNavShell`
- **Compact (< 600): `NavigationBar`** height 72, bg `surfaceContainer`, tint transparent, elevation 0, 1dp `outlineVariant` top border, indicator `secondaryContainer` (radius full), icons 24 (outlined when unselected, filled when selected), labels `labelMedium`, `labelBehavior: alwaysShow`. Badge (`Badge` widget, `error` bg) for counts (unread notifications, pending bookings, pending onboarding), max "99+".
- **Medium/expanded (≥ 600): `NavigationRail`**, `labelType: all`, bg `surfaceContainer`, same icons/indicator, 1dp `outlineVariant` right border; `extended: true` with `labelType: none` at ≥ 1200. Optional leading: app logo 32.
- **Same destinations, same order** on bar and rail (no extra rail-only items) so muscle memory transfers.
- Each tab keeps its own stack (StatefulShellRoute.indexedStack). Re-tapping the active tab pops to its root.

---

## 6. Status badges & slot tiles

### 6.1 `StatusBadge` anatomy
Pill, radius full; height 24 (`small`, lists) / 28 (`medium`, detail headers); padding h 8 / 10; leading icon 14 / 16; gap 4; text `labelSmall`/`labelMedium`, weight 600; bg = container token, icon+text = onContainer token. Text scale capped at 1.3.
Semantics: `Semantics(label: '{kind}: {label}', excludeSemantics: true)` e.g. "Booking status: Confirmed".

**Tones** (`StatusTone` enum → colors):

| Tone | Container | Foreground |
|---|---|---|
| neutral | `surfaceContainerHighest` | `onSurfaceVariant` |
| brand | `primaryContainer` | `onPrimaryContainer` |
| success | `successContainer` | `onSuccessContainer` |
| warning | `warningContainer` | `onWarningContainer` |
| info | `infoContainer` | `onInfoContainer` |
| danger | `errorContainer` | `onErrorContainer` |

### 6.2 Booking status
| Status | Tone | Icon | Label |
|---|---|---|---|
| pending | warning | `Icons.hourglass_top` | Pending |
| confirmed | success | `Icons.check_circle` | Confirmed |
| rejected | danger | `Icons.cancel` | Rejected |
| cancelled | neutral | `Icons.event_busy` | Cancelled |
| completed | brand | `Icons.task_alt` | Completed |

### 6.3 Payment status
| Status | Tone | Icon | Label |
|---|---|---|---|
| unpaid | neutral | `Icons.money_off` | Unpaid |
| pending | warning | `Icons.schedule` | Payment pending |
| paid | success | `Icons.paid` | Paid |
| refunded | info | `Icons.currency_exchange` | Refunded |

### 6.4 Shop status (+ listing)
| Status | Tone | Icon | Label |
|---|---|---|---|
| pending | warning | `Icons.pending` | Pending review |
| active | success | `Icons.verified` | Active |
| suspended | danger | `Icons.pause_circle` | Suspended |
| rejected | danger | `Icons.cancel` | Rejected |
| inactive | neutral | `Icons.power_settings_new` | Inactive |
| listed (`isListed: true`) | brand | `Icons.visibility` | Listed |
| unlisted (`isListed: false`) | neutral | `Icons.visibility_off` | Unlisted |

Shop rows show both badges side by side (status first, then listing).

### 6.5 Slot states & `SlotTile`

**Tile layout**
- Grid: 3 cols (compact), 4 (medium), 6 (expanded); gap 8; tile min height 64 (≥ 48 touch target), radius md 12, padding h 8 v 10.
- Row 1: start time `titleSmall` tabular (e.g. "18:00" or "6:00 PM" per locale via `intl`).
- Row 2: icon 14 + state label `labelSmall` (weight 600).
- Selected tiles additionally get a 2dp border so the change is visible in greyscale; state change animates 150ms.

| State | Background | Border | Foreground | Icon | Label (customer) | Label (admin) | Tappable |
|---|---|---|---|---|---|---|---|
| available | surfaceContainerLowest (dark: surfaceContainerLow) | 1dp `outline` | onSurface / label onSurfaceVariant | `Icons.add_circle_outline` | Available | Available | yes |
| selected | `primary` | 2dp `primary` | `onPrimary` | `Icons.check_circle` | Selected | Selected | yes (deselect) |
| booked | `surfaceContainerHighest` | none | `onSurfaceVariant` | `Icons.event_busy` | Booked | Booked (tap → booking detail) | customer no · admin yes |
| blocked | `surfaceContainerHigh` | none | `onSurfaceVariant` | `Icons.block` | Closed | Blocked (tap → block detail) | customer no · admin yes |
| unavailable (past, outside hours, court/shop inactive) | transparent | 1dp `outlineVariant` | `onSurfaceVariant` | `Icons.do_not_disturb_on_outlined` | Unavailable | Unavailable | no |

**Selection rules (customer):** tap selects one slot; tapping an adjacent available slot extends the range; tapping a non-adjacent slot restarts the selection there; tapping a selected edge slot shrinks the range. Sticky summary bar (surfaceContainerLow, 1dp top border) shows "18:00–20:00 · 2 hrs · {total}" + large FilledButton "Review booking" (disabled with helper "Select a time to continue" when empty). Displayed price is indicative; server computes final price.

**Semantics** (`Semantics(button: tappable, selected: isSelected, enabled: tappable, excludeSemantics: true)`), times spoken in locale 12/24h format:
- available: "6:00 PM to 7:00 PM, available, {price} per hour" · onTapHint "select"
- selected: "6:00 PM to 7:00 PM, selected" · onTapHint "deselect"
- booked: "6:00 PM to 7:00 PM, booked, not available"
- blocked: "6:00 PM to 7:00 PM, closed, not available" (admin: "blocked, {reason}")
- unavailable: "6:00 PM to 7:00 PM, unavailable"

---

## 7. Async state patterns

Implement once as `AsyncValueView<T>` (wraps Riverpod `AsyncValue<T>`) with `data`, optional `loading`, `empty` (predicate + widget), `error` builders. Never a blank screen.

### 7.1 Loading
| Situation | Pattern |
|---|---|
| First load of a screen/section with known layout (lists, cards, details, dashboards) | **Skeleton** matching final layout (`SkeletonBox`, `SkeletonListTile`, `SkeletonStadiumCard`, `SkeletonStatCard`); color `skeleton`, radius xs/lg; gentle opacity pulse 1.0↔0.55, 1s, static if animations disabled. Semantics: "Loading {thing}". |
| Refresh / re-fetch while data exists (`isRefreshing` / `hasValue`) | Keep data visible + 2dp `LinearProgressIndicator` under app bar (or pull-to-refresh indicator). |
| User-initiated action (submit, confirm booking, approve shop) | **Spinner in the button** (§5.1). Never a full-screen overlay, except booking confirm which also disables the back gesture until response. |
| Splash / auth resolution | Logo centered; small 24 spinner appears only after 600ms. |
| Slot availability (date/court change) | Skeleton grid of tiles (same dimensions) — avoids layout jump. |

### 7.2 Empty — `EmptyView`
Layout (centered, max width 320, vertical padding 48): icon 48 `onSurfaceVariant` in 96dp circle `surfaceContainerHigh` → gap 16 → title `titleMedium` → gap 8 → message `bodyMedium onSurfaceVariant` center → gap 24 → optional `FilledButton.tonal`.
No illustrations in Phase 1 (icon only). Inline variant: horizontal, icon 32, no circle, padding 16 — for sections inside a scroll view.

| Where | Icon | Title | Message | Action |
|---|---|---|---|---|
| Customer bookings (upcoming) | `Icons.event_available_outlined` | No upcoming bookings | Find a court and book your next game. | Explore stadiums |
| Explore (no results) | `Icons.search_off` | No stadiums match | Try removing a filter or searching a different area. | Clear filters |
| Notifications | `Icons.notifications_none` | You're all caught up | Booking updates will appear here. | — |
| Slots (no availability) | `Icons.event_busy_outlined` | No times left on this day | Try another date or court. | Next available day |
| Shop admin stadiums | `Icons.stadium_outlined` | Add your first stadium | Customers can book once a stadium and court are set up. | Add stadium |
| Admin bookings (filtered) | `Icons.filter_alt_off_outlined` | No bookings for these filters | Change the date or status filter. | Clear filters |
| Superadmin onboarding | `Icons.inbox_outlined` | No pending requests | New shop requests will show here. | — |

### 7.3 Error — `ErrorView`
- Full-screen: icon 48 in 96dp `errorContainer` circle (`onErrorContainer` icon) → title `titleMedium` → message (`AppException.message`, friendly, never raw Firebase text) → `OutlinedButton.icon(Icons.refresh, "Try again")`.
- Icon/title by type: network → `Icons.cloud_off` "You're offline"; permission → `Icons.lock_outline` "You don't have access"; not found → `Icons.search_off` "Not found"; other → `Icons.error_outline` "Something went wrong".
- Inline (section inside a screen): AppCard, row: `Icons.error_outline` 20 `error` + bodyMedium message + trailing TextButton "Retry".
- Error with stale data present: keep data, show snackbar "Couldn't refresh" + action "Retry".
- Form/action errors: inline banner above the primary button (errorContainer, radius md, padding 12, `Icons.error_outline` 20 + bodyMedium `onErrorContainer`), announced via `SemanticsService.announce`.

### 7.4 Booking conflict ("slot just taken")
1. **While selecting** (live availability stream): if a selected slot turns booked/blocked, auto-deselect it and show a `MaterialBanner`-style inline banner above the grid (warningContainer, `Icons.info_outline`): "18:00 was just booked by someone else. Pick another time." — dismiss button "OK, got it" (TextButton). Summary bar recalculates.
2. **On confirm** (server returns booking conflict): stay on review, open a bottom sheet (not a snackbar):
   - Icon `Icons.event_busy` 32 in 64dp `warningContainer` circle
   - Title: "That time was just booked"
   - Message: "Someone booked Court 1, 18:00–19:00 moments ago. Nothing was charged or booked for you."
   - Primary: "Choose another time" → pops back to slot selection with same stadium/court/date kept, availability refreshed, conflicting slot now shown as Booked.
   - Secondary (TextButton): "Try another court".
3. **Venue can't take bookings** (shop suspended/unlisted, court inactive, outside hours): same sheet pattern, icon `Icons.storefront_outlined`, title "This venue isn't taking bookings right now", primary "Back to explore".

---

## 8. Navigation & route map

### 8.1 Bottom-nav destinations

**Customer** (5, fits NavigationBar)
| # | Label | Icon (unselected / selected) | Path |
|---|---|---|---|
| 1 | Home | `Icons.home_outlined` / `Icons.home` | `/customer/home` |
| 2 | Explore | `Icons.explore_outlined` / `Icons.explore` | `/customer/explore` |
| 3 | Bookings | `Icons.calendar_month_outlined` / `Icons.calendar_month` | `/customer/bookings` |
| 4 | Notifications | `Icons.notifications_outlined` / `Icons.notifications` (+ unread Badge) | `/customer/notifications` |
| 5 | Profile | `Icons.person_outline` / `Icons.person` | `/customer/profile` |

**Shop admin — decision: 5 destinations; Courts merged into Stadiums.**
Courts are a subcollection of a stadium, so they are managed in context: the Stadiums tab has a top `SegmentedButton` "Stadiums | Courts" (flat courts list across the shop's stadiums, filterable by stadium), and each stadium detail lists its courts. Bookings moves to position 2 (most frequent daily task). Blocked slots are reached from Bookings (app bar action "Block time") and court detail; shop profile lives in Settings. Rejected alternatives: a drawer hides primary tasks; "More" tab adds a click to Settings for no gain.
| # | Label | Icon | Path |
|---|---|---|---|
| 1 | Dashboard | `Icons.space_dashboard_outlined` / `Icons.space_dashboard` | `/shop-admin/dashboard` |
| 2 | Bookings | `Icons.calendar_month_outlined` / `Icons.calendar_month` (+ pending Badge) | `/shop-admin/bookings` |
| 3 | Stadiums | `Icons.stadium_outlined` / `Icons.stadium` | `/shop-admin/stadiums` (`?view=courts` selects Courts segment) |
| 4 | Customers | `Icons.groups_outlined` / `Icons.groups` | `/shop-admin/customers` |
| 5 | Settings | `Icons.settings_outlined` / `Icons.settings` | `/shop-admin/settings` |

**Superadmin — decision: 5 destinations; Onboarding merged into Shops.**
Onboarding requests are shops in `pending` status — same entity, same detail screen. The Shops tab has a `TabBar` "All shops | Onboarding (n)"; the Shops nav item carries a Badge with the pending count so the queue is never hidden. Dashboard "Review requests" deep-links to `/superadmin/shops?tab=onboarding`. Announcements and platform settings live in Settings.
| # | Label | Icon | Path |
|---|---|---|---|
| 1 | Dashboard | `Icons.space_dashboard_outlined` / `Icons.space_dashboard` | `/superadmin/dashboard` |
| 2 | Shops | `Icons.storefront_outlined` / `Icons.storefront` (+ pending Badge) | `/superadmin/shops` (`?tab=onboarding`) |
| 3 | Bookings | `Icons.calendar_month_outlined` / `Icons.calendar_month` | `/superadmin/bookings` |
| 4 | Customers | `Icons.groups_outlined` / `Icons.groups` | `/superadmin/customers` |
| 5 | Settings | `Icons.settings_outlined` / `Icons.settings` | `/superadmin/settings` |

Rail at ≥ 600 uses exactly the same 5 items per role.

### 8.2 Full path list
"Shell" = tab root inside `StatefulShellRoute.indexedStack` (nav visible). "Pushed" = child route with `parentNavigatorKey: rootNavigatorKey` (full screen, nav hidden, back arrow). Path params are camelCase; segments kebab-case. Pass IDs in paths, not objects in `extra` (survives restoration/deep links); booking draft lives in a Riverpod provider.

**Auth / system (top-level, no shell)**
| Path | Screen |
|---|---|
| `/splash` | Session/role resolution |
| `/login` | Login (`?from=` optional return path) |
| `/register` | Customer self-registration |
| `/forgot-password` | Reset link request |
| `/account-blocked` | Disabled account / shop-admin without valid shop assignment |

**Customer**
| Path | Type |
|---|---|
| `/customer/home` | Shell |
| `/customer/explore` | Shell |
| `/customer/bookings` | Shell (segments: Upcoming · Pending · Past · Cancelled) |
| `/customer/notifications` | Shell |
| `/customer/profile` | Shell |
| `/customer/stadiums/:stadiumId` | Pushed — stadium details (sticky "Book a court") |
| `/customer/stadiums/:stadiumId/book` | Pushed — date → court → slots (`?courtId=&date=yyyy-MM-dd`) |
| `/customer/stadiums/:stadiumId/book/review` | Pushed — review & confirm |
| `/customer/bookings/:bookingId` | Pushed — booking detail (cancel if eligible) |
| `/customer/bookings/:bookingId/confirmation` | Pushed via `go` (replaces booking-flow stack; back → Bookings) |
| `/customer/profile/edit` | Pushed |
| `/customer/profile/change-password` | Pushed |

**Shop admin**
| Path | Type |
|---|---|
| `/shop-admin/dashboard` | Shell |
| `/shop-admin/bookings` | Shell (filters: date, stadium, court, status) |
| `/shop-admin/stadiums` | Shell (`?view=courts`) |
| `/shop-admin/customers` | Shell |
| `/shop-admin/settings` | Shell |
| `/shop-admin/bookings/:bookingId` | Pushed — confirm / reject / cancel / complete |
| `/shop-admin/stadiums/new` | Pushed |
| `/shop-admin/stadiums/:stadiumId` | Pushed — detail + courts list |
| `/shop-admin/stadiums/:stadiumId/edit` | Pushed |
| `/shop-admin/stadiums/:stadiumId/courts/new` | Pushed |
| `/shop-admin/stadiums/:stadiumId/courts/:courtId` | Pushed — court detail + slot grid (admin labels) |
| `/shop-admin/stadiums/:stadiumId/courts/:courtId/edit` | Pushed |
| `/shop-admin/blocked-slots` | Pushed — list |
| `/shop-admin/blocked-slots/new` | Pushed (`?stadiumId=&courtId=&date=`) |
| `/shop-admin/customers/:customerId` | Pushed — profile + booking history (this shop only) |
| `/shop-admin/settings/shop-profile` | Pushed |

**Superadmin**
| Path | Type |
|---|---|
| `/superadmin/dashboard` | Shell |
| `/superadmin/shops` | Shell (`?tab=onboarding`) |
| `/superadmin/bookings` | Shell (+ shop filter) |
| `/superadmin/customers` | Shell |
| `/superadmin/settings` | Shell |
| `/superadmin/shops/new` | Pushed — create shop |
| `/superadmin/shops/:shopId` | Pushed — detail / review (approve, reject, activate, suspend, list/unlist) |
| `/superadmin/shops/:shopId/edit` | Pushed |
| `/superadmin/shops/:shopId/admins` | Pushed — shop admins list, revoke |
| `/superadmin/shops/:shopId/admins/invite` | Pushed |
| `/superadmin/bookings/:bookingId` | Pushed |
| `/superadmin/customers/:customerId` | Pushed |
| `/superadmin/settings/announcements` | Pushed |
| `/superadmin/settings/announcements/new` | Pushed |

Role home: customer → `/customer/home` · shopAdmin → `/shop-admin/dashboard` · superadmin → `/superadmin/dashboard`.

### 8.3 Redirect behavior (evaluated in order; `refreshListenable` = session provider)
1. Session loading (auth or role claims not yet resolved) → `/splash`. If role can't be resolved within ~10s, splash shows ErrorView "We couldn't load your account" + "Try again" / "Sign out".
2. Unauthenticated → allow `/login`, `/register`, `/forgot-password`; anything else → `/login?from=<path>`.
3. Authenticated + account disabled (or shopAdmin with no `shopId`) → `/account-blocked` (only allowed route; action "Sign out").
4. Authenticated on `/splash` or an auth route → `from` if it belongs to the user's role prefix, else role home.
5. Path prefix not matching role (`/customer`, `/shop-admin`, `/superadmin`) → role home. No error screen, no flash of the wrong UI.
6. Unknown path → role home (authenticated) or `/login`.

Guards are UX only — every protected read/write is still enforced by Security Rules / Cloud Functions.

---

## 9. Auth screens

Shared layout: `Scaffold` (surface), `SafeArea`, scroll view, content centered at max width 440, padding h 24 (compact) / 32, top spacing 48. Header: logo mark 48 → gap 24 → headline `headlineMedium` → gap 8 → subtitle `bodyLarge onSurfaceVariant` → gap 32 → form (fields gap 16) → primary CTA (FilledButton 56, full width) → footer link. Keyboard: `textInputAction.next` between fields, `done` on last submits. During submit: button loading, fields read-only. Auth failures appear in the inline error banner above the CTA (§7.3). No social login in Phase 1.

**Login**
- Headline "Welcome back" · subtitle "Log in to book your next game."
- Fields: Email (`Icons.mail_outline`, `AutofillHints.email`), Password (toggle, `AutofillHints.password`).
- Right-aligned TextButton "Forgot password?" under password.
- CTA "Log in". Footer: "New here?" + TextButton "Create an account".
- Wrong credentials: "Email or password is incorrect." (never reveal which). Too many attempts: "Too many attempts. Try again in a few minutes." Offline: "You're offline. Check your connection and try again."

**Register (customers only — no role picker)**
- Headline "Create your account" · subtitle "Book futsal courts in a few taps."
- Fields: Full name (`AutofillHints.name`, words capitalization), Email, Phone (optional; helper "Venues use this to reach you about bookings"; `AutofillHints.telephoneNumber`), Password (helper "At least 8 characters", `AutofillHints.newPassword`). No confirm-password field (show/hide toggle instead).
- Small print `bodySmall`: "By continuing you agree to the Terms and Privacy Policy." (links as TextButtons/TextSpan).
- CTA "Create account". Footer: "Already have an account?" + "Log in".
- Info note below footer (bodySmall `onSurfaceVariant`, `Icons.storefront_outlined` 16): "Own a futsal venue? Shop accounts are set up by our team — contact us to join." Role is assigned server-side (customer); shop admins are invited by the superadmin.
- Email already used: "An account with this email already exists. Log in instead?" with inline TextButton "Log in".

**Forgot password**
- Headline "Reset your password" · subtitle "Enter your email and we'll send you a reset link."
- Field: Email. CTA "Send reset link". Footer: "Back to log in".
- Success replaces the form (same screen): icon `Icons.mark_email_read_outlined` 48 in `primaryContainer` circle, title "Check your email", message "If an account exists for {email}, a reset link is on its way." (no account enumeration), FilledButton "Back to log in", TextButton "Resend" disabled for 60s with countdown ("Resend in 42s").

**Validation messages**
| Field | Rule | Message |
|---|---|---|
| Name | required, ≥ 2 chars | "Enter your name" |
| Email | required | "Enter your email" |
| Email | format | "Enter a valid email address" |
| Phone | optional; if present 7–15 digits (allow +, spaces) | "Enter a valid phone number" |
| Password (login) | required | "Enter your password" |
| Password (register) | ≥ 8 chars | "Use at least 8 characters" |

**Account blocked** (`/account-blocked`): centered EmptyView layout, icon `Icons.lock_outline`, title "Account unavailable", message "Your account has been disabled. Contact support if you think this is a mistake." (shopAdmin without shop: "Your shop access isn't set up yet. Contact the platform team."), OutlinedButton "Sign out".

---

## 10. Phase 1 implementation checklist (developer)

**Assets / pubspec**
- [ ] `assets/fonts/Inter-{Regular,Medium,SemiBold,Bold}.ttf` + `fonts:` block (family `Inter`, weights 400/500/600/700). Tell the user to drop in the TTFs if not downloadable.

**`lib/core/theme/`**
- [ ] `app_color_schemes.dart` — `AppColorSchemes.light` / `.dark` (explicit `ColorScheme` values from §2.1–2.2).
- [ ] `app_colors.dart` — `AppColors extends ThemeExtension<AppColors>` (success/warning/info ×4, skeleton, imagePlaceholder; `light`/`dark` consts, `copyWith`, `lerp`).
- [ ] `app_typography.dart` — `AppTypography.textTheme` (§3 table, family Inter) + `tabular(TextStyle)` helper.
- [ ] `app_spacing.dart` (§4.1), `app_radius.dart` (§4.2 doubles + `BorderRadius` helpers), `app_sizes.dart` (icons, heights, breakpoints, max widths).
- [ ] `app_theme.dart` — `AppTheme.light` / `AppTheme.dark`: `useMaterial3: true`, scheme, textTheme, extensions `[AppColors]`, `scaffoldBackgroundColor: surface`, and component themes: filled/outlined/text button, inputDecoration, card, chip, navigationBar, navigationRail, appBar, bottomSheet, dialog, snackBar, divider (`outlineVariant`, 1dp), listTile, segmentedButton, tabBar, progressIndicator, floatingActionButton (elevation 2).
- [ ] `theme_context_ext.dart` — `context.colors` (ColorScheme), `context.appColors`, `context.textStyles`, `context.isCompact/isMedium/isExpanded`.
- [ ] `status_tone.dart` — `StatusTone` enum + `(Color bg, Color fg) colorsFor(BuildContext)`; status→(tone, icon, label) mappings from §6.2–6.4 (as extensions on the status enums once VOs exist in Phase 3; for now plain mapping functions keyed by the status string constants).

**`lib/core/widgets/`**
- [ ] `app_button.dart` — `PrimaryButton`, `SecondaryButton` (outlined), `AppTextButton`, `DestructiveButton`; params: `label`, `onPressed`, `icon`, `isLoading`, `size` (`medium` 48 / `large` 56), `expand`.
- [ ] `app_text_field.dart` — `AppTextField` (+ `PasswordField`, `SearchField`).
- [ ] `status_badge.dart` — `StatusBadge(tone, icon, label, size, semanticsPrefix)`.
- [ ] `slot_tile.dart` — `SlotTile(state, startLabel, semanticLabel, onTap, isAdmin)` + `SlotState` enum (§6.5).
- [ ] `async_value_view.dart` — `AsyncValueView<T>` (loading/empty/error/data, refresh bar when `isRefreshing`).
- [ ] `loading_view.dart` (centered spinner) + `skeleton.dart` (`SkeletonBox`, `SkeletonListTile`, `SkeletonStadiumCard`, `SkeletonStatCard`, `SkeletonSlotGrid`).
- [ ] `empty_view.dart` — full + `inline` variant.
- [ ] `error_view.dart` — full + `inline` variant; takes `AppException` (or message + type) and `onRetry`.
- [ ] `inline_banner.dart` — tone-based banner (error/warning/info) for forms & conflict notices.
- [ ] `app_card.dart`, `stat_card.dart`, `stadium_card.dart` (visual shell only; data wiring in Phase 6).
- [ ] `section_header.dart` — title `titleMedium` + optional "See all" TextButton.
- [ ] `content_constraint.dart` — centers child at a max width (auth/form/list/dashboard presets) with responsive gutter.
- [ ] `sticky_bottom_bar.dart` — surfaceContainerLow, 1dp top border, safe-area padding, holds summary + CTA.
- [ ] `app_dialogs.dart` — `showConfirmDialog(...)` (destructive flag); `app_bottom_sheet.dart` — `showAppBottomSheet(...)`; `app_snackbar.dart` — `showAppSnackBar(context, message, {tone, action})`.
- [ ] `adaptive_nav_shell.dart` — `AdaptiveNavShell(navigationShell, destinations)` switching NavigationBar/NavigationRail at 600 (extended at 1200).

**`lib/core/router/`**
- [ ] `app_routes.dart` — path constants + names + builders for param paths (`AppRoutes.customerStadium(id)`).
- [ ] `app_router.dart` — `GoRouter` provider (Riverpod), root navigator key, three `StatefulShellRoute.indexedStack` shells (5 branches each), pushed routes with `parentNavigatorKey: root`, `redirect` per §8.3, `refreshListenable` from session provider (stub the session provider in Phase 1).
- [ ] `nav_destinations.dart` — per-role destination lists (label, outlined icon, filled icon) from §8.1.
- [ ] Placeholder screens per route (AppBar title + `EmptyView` "Coming soon") so the map is navigable end to end.

Out of scope for Phase 1: real auth, data, images, notification counts (badges wired to stub providers returning 0).
