#!/usr/bin/env bash
# Builds the Pinfall Rescue debug APK using only the Android SDK command-line tools.
# No Gradle needed, so this works even where the Gradle daemon is broken.
# Note: the manifest declares targetSdk 36 (Play Store requirement for new apps
# since Aug 2026) while linking against the installed android-34 platform jar.
# The app uses only long-stable APIs, so this is safe; for a Play release build,
# use Android Studio with API 36 installed (see README.md).
# Usage: ANDROID_HOME=/path/to/android-sdk ./build-apk.sh
set -euo pipefail

SDK="${ANDROID_HOME:-$HOME/workspace/dost-ai/tools/android-sdk}"
BT="$SDK/build-tools/34.0.0"
PLATFORM="$SDK/platforms/android-34/android.jar"
ROOT="$(cd "$(dirname "$0")" && pwd)"
OUT="$ROOT/out"

rm -rf "$OUT"
mkdir -p "$OUT/compiled-res" "$OUT/classes" "$OUT/dex"

echo "==> aapt2 compile resources"
"$BT/aapt2" compile --dir "$ROOT/app/src/main/res" -o "$OUT/compiled-res.zip"

echo "==> aapt2 link"
"$BT/aapt2" link -o "$OUT/app-unaligned.apk" \
  -I "$PLATFORM" \
  --manifest "$ROOT/app/src/main/AndroidManifest.xml" \
  -R "$OUT/compiled-res.zip" \
  --auto-add-overlay \
  -A "$ROOT/app/src/main/assets"

echo "==> javac"
javac -source 8 -target 8 -nowarn -Xlint:-options -cp "$PLATFORM" \
  -d "$OUT/classes" \
  "$ROOT/app/src/main/java/com/pinfall/rescue/MainActivity.java"

echo "==> d8"
"$BT/d8" --lib "$PLATFORM" --output "$OUT/dex" "$OUT/classes/com/pinfall/rescue/MainActivity.class"

echo "==> add dex to apk"
python3 - "$OUT/app-unaligned.apk" "$OUT/dex/classes.dex" <<'PYEOF'
import sys, zipfile
apk, dex = sys.argv[1], sys.argv[2]
with zipfile.ZipFile(apk, 'a', zipfile.ZIP_DEFLATED) as z:
    z.write(dex, 'classes.dex')
PYEOF

echo "==> zipalign"
"$BT/zipalign" -f 4 "$OUT/app-unaligned.apk" "$OUT/app-aligned.apk"

if [ ! -f "$ROOT/debug.keystore" ]; then
  echo "==> generating debug keystore (local testing only, never ship this)"
  keytool -genkeypair -keystore "$ROOT/debug.keystore" -alias androiddebugkey \
    -storepass android -keypass android \
    -dname "CN=Android Debug,O=Android,C=US" -keyalg RSA -keysize 2048 -validity 10000 -noprompt
fi

echo "==> apksigner"
"$BT/apksigner" sign --ks "$ROOT/debug.keystore" --ks-pass pass:android --key-pass pass:android \
  --out "$OUT/pinfall-debug.apk" "$OUT/app-aligned.apk"

echo "==> verify"
"$BT/apksigner" verify "$OUT/pinfall-debug.apk"
"$BT/aapt2" dump badging "$OUT/pinfall-debug.apk" | head -8
ls -la "$OUT/pinfall-debug.apk"
echo "OK: $OUT/pinfall-debug.apk"
