#!/usr/bin/env bash
# RETIRED: the app now depends on play-services-ads, which needs Gradle's
# dependency resolution and manifest merging. The SDK command-line tools
# alone cannot build it anymore (javac would fail on the missing
# com.google.android.gms.ads classes, and the library's resources and
# manifest entries would be missing from the APK).
#
# Build with Gradle instead (on a machine where the Gradle daemon runs):
#   ./gradlew assembleDebug   # debug APK for sideload testing
#   ./gradlew bundleRelease   # .aab for the Play Store (needs an upload key)
#
# See RELEASE_CHECKLIST.md for the full Play + AdMob release path.
echo "build-apk.sh is retired: use ./gradlew assembleDebug (or bundleRelease)." >&2
exit 1
