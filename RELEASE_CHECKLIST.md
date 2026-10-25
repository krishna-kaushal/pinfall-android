# Pinfall Rescue — Play Store + AdMob release checklist

The code is ready. Everything below needs a human with accounts — none of
it can be done from this sandbox. Work top to bottom; step 0 comes before
any release build.

## 0. Swap the AdMob test IDs (before any release build)

The app currently ships Google's test IDs in
`app/src/main/res/values/strings.xml` (test ads, zero revenue).

1. Sign up at https://admob.google.com with your Google account.
2. Apps → Add App → if the app is not published yet, choose "No, it is not
   listed". Name it "Pinfall Rescue", platform Android.
3. Note the **App ID** (`ca-app-pub-XXXX~YYYY`, tilde) and create one
   **Banner** ad unit (`ca-app-pub-XXXX/YYYY`, slash). Do not mix them up.
4. Replace `admob_app_id` and `admob_banner_id` in `strings.xml` with the
   real IDs, then rebuild. New ad units can take a few hours to serve ads.

Rules that get accounts banned — do not break them:

- **Never click your own ads**, not even once to test.
- **Never test with real IDs.** Keep the test IDs for debug builds; only the
  release build gets real IDs. (Or register your phone as a test device in
  the AdMob console: Settings → Test devices.)

## 1. Play Console account

- https://play.google.com/console — one-time **$25** registration fee, then
  identity verification (Google asks for an ID document; takes a few days).
- Create the app: name "Pinfall Rescue", package `com.pinfall.rescue`,
  category Puzzle, free, no in-app purchases.

## 2. Upload key (Android Studio, once)

Build → Generate Signed App Bundle / APK → create a **new upload key**
(keystore file + passwords). Back the keystore up somewhere safe — losing
it locks you out of future updates. Enable **Play App Signing** so Google
holds the final signing key and you only manage the upload key.

## 3. Build the release bundle

```sh
./gradlew bundleRelease   # produces app/build/outputs/bundle/release/app-release.aab
```

First sync downloads Gradle 9.6.0, AGP 9.4.0, and SDK 36 automatically.
Upload the `.aab` (not an APK) to Play Console.

## 4. Store listing (paste-ready)

- **Title:** Pinfall Rescue
- **Short description (78 chars):**
  Pull the pins. Dodge lava and poison. Rescue the gold in 100 tricky puzzles.
- **Full description:**
  Pinfall Rescue is a pull-the-pin physics puzzle. Pull pins in the right
  order to guide water, lava, poison, and gold through the cave — and get at
  least 30 gold coins down to your hero without letting lava or poison
  anywhere near him. Watch out: poison contaminates water, lava destroys
  gold, and goblins patrol the chambers.

  100 hand-built levels, from gentle tutorials to brutal multi-pin traps.
  No timers, no lives, no pressure — just think, pull, and watch it flow
  (or flood). Progress saves on your device, and the game plays fully
  offline. Free with ads.
- **Category:** Puzzle. **Tags:** puzzle, physics, brain, casual.
- **Icon:** `store-icon-512.png` (512×512).
- **Feature graphic + screenshots:** capture from a real phone (levels 1, 7,
  and 13 show the range well). Play requires at least 2 screenshots.
- **Privacy policy:** host `PRIVACY_POLICY.md` somewhere public and paste
  the URL. (GitHub Pages on this repo works if Pages is enabled in the repo
  settings; the policy already discloses AdMob.)
- **Content rating questionnaire:** cartoon fantasy violence only (goblins),
  no user interaction, banner ads, no in-app purchases.
- **Data safety form:** no personal data collected by the app itself;
  advertising ID collected by Google's AdMob SDK (declare it: "Device or
  other IDs — Advertising").

## 5. Rollout

Internal testing track first (invite yourself, install from the Play link,
confirm the banner shows a real ad and the game plays). Then production.
Link the published store listing back in the AdMob console (Apps → your app
→ link to Play).

## Later (after launch, not blocking)

- **Interstitial ads** between levels (every 3–5 completions) pay more than
  banners; needs a small native bridge for level-complete events.
- **Consent (UMP SDK)** before monetising EU traffic properly — AdMob's
  User Messaging Platform form. India-first launch does not need it on day 1.
- **app-ads.txt:** once the app is live, AdMob asks you to publish an
  app-ads.txt file (a one-line text file on the developer website domain)
  to prove you own the app. It raises fill rates; it is not blocking.

## Honest revenue expectation

Publishing unlocks the *possibility* of revenue, not revenue itself. Banner
ads in India pay roughly $0.10–$0.50 per 1,000 impressions (directional,
not a promise), so income scales with daily players, not with the listing.
The next problem after publishing is distribution — getting players — not
more code.
