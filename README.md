# Pinfall Rescue — Android app

WebView shell around the tested web game (`app/src/main/assets/pinfall-rescue.html`).
The game itself is offline (progress saved on-device in localStorage); the
only network use is the AdMob banner ad at the bottom of the screen.

- Package: `com.pinfall.rescue`
- Version: 1.0 (versionCode 1)
- minSdk 24, targetSdk 36 (Play Store requirement for new apps since Aug 2026)
- Launcher icon: goblin + gold coins (`store-icon-512.png` is the Play listing icon)
- Ads: banner via Google Mobile Ads SDK (`play-services-ads:25.5.0`), currently
  wired to Google's **test IDs** in `app/src/main/res/values/strings.xml`.
  Test ads earn nothing — swap in real AdMob IDs before any release build
  (see `RELEASE_CHECKLIST.md`).

## Building

The app now depends on `play-services-ads`, which needs Gradle's dependency
resolution and manifest merging, so builds go through Gradle. The old
`build-apk.sh` CLI script is retired (it prints the Gradle commands and exits).

```sh
./gradlew assembleDebug   # debug APK for sideload testing
./gradlew bundleRelease   # .aab for the Play Store (needs an upload key)
```

First sync downloads Gradle 9.6.0, AGP 9.4.0, and SDK 36 automatically.
**Do not submit a debug build to Play** — only the signed release bundle.

## Play Store release path

Full step-by-step list, including the AdMob and listing details, lives in
`RELEASE_CHECKLIST.md`. In short:

1. AdMob account → real App ID + banner ad unit ID → replace the two test
   IDs in `strings.xml`. Never test with real IDs, never click your own ads.
2. Play Console account ($25 one-time + identity verification).
3. Build → Generate Signed App Bundle in Android Studio → create a **new
   upload key** (keep it safe — losing it locks you out of future updates;
   enable Play App Signing so Google holds the final signing key).
4. Upload the `.aab`, paste the store listing from `RELEASE_CHECKLIST.md`,
   host `PRIVACY_POLICY.md` somewhere public and paste the URL, answer the
   content rating questionnaire (cartoon goblins, banner ads, no purchases).
5. Internal testing track first, then production.

## Notes

- `debug.keystore` is intentionally not shipped in the project zip; a rebuild
  elsewhere needs the old APK uninstalled first.
- The game asset in `app/src/main/assets/` is the 100-level build with the
  poison-contaminates-water and lava-destroys-gold mechanics.
