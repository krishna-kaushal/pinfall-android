# Pinfall Rescue — Android app

WebView shell around the tested web game (`app/src/main/assets/pinfall-rescue.html`).
Fully offline: no permissions, no servers, progress saved on-device in localStorage.

- Package: `com.pinfall.rescue`
- Version: 1.0 (versionCode 1)
- minSdk 24, targetSdk 36 (Play Store requirement for new apps since Aug 2026)
- Launcher icon: goblin + gold coins (`store-icon-512.png` is the Play listing icon)

## Test build (this machine)

```sh
./build-apk.sh   # needs ANDROID_HOME set, or the SDK at ~/workspace/dost-ai/tools/android-sdk
```

Produces `out/pinfall-debug.apk`, signed with a locally generated debug keystore.
Install on a phone with `adb install out/pinfall-debug.apk`. **Do not submit the
debug APK to Play** — it is for sideload testing only.

## Play Store release path (Android Studio, on your machine)

1. Open this folder in Android Studio (or copy `app/` into a new Empty Activity
   project with package `com.pinfall.rescue`).
2. Install API 36 (SDK Manager) — the Gradle project already sets compileSdk 36 and targetSdk 36.
3. Build → Generate Signed App Bundle / APK → create a **new upload key**
   (keep it safe — losing it locks you out of future updates; enable Play App
   Signing so Google holds the final signing key).
4. Upload the `.aab` to Play Console, add the store listing:
   - Icon: `store-icon-512.png` (512×512)
   - Feature graphic + phone screenshots: capture from a real phone
     (screenshots of levels 1, 7, 13 show the range well)
   - Short + full description, category: Puzzle
   - Privacy policy: `PRIVACY_POLICY.md` — host it somewhere public
     (e.g. a GitHub Pages page) and paste the URL; the game collects nothing,
     so the policy is short.
   - Content rating questionnaire: no violence beyond cartoon goblins,
     no ads, no in-app purchases in v1.0.
5. Internal testing track first, then production.

## Notes

- The CLI build links against the android-34 platform jar (the newest installed
  here) while the manifest declares targetSdk 36. The app uses only long-stable
  APIs, so this is safe for testing; the Gradle release build compiles against
  API 36 (compileSdk 36 in `app/build.gradle`).
- `debug.keystore` is intentionally not shipped in the project zip; the build
  script regenerates it if missing, so a rebuild elsewhere needs the old APK
  uninstalled first.
