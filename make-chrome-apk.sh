#!/bin/bash
source ./build/envsetup.sh
lunch full-eng
cd external/chrome
source ./build/android/envsetup.sh
clank_gyp
make -j16 libchromeview.so
echo "Building Chrome APK from locally built libchromeview.so..."
cd apk
echo "cp ../out/Release/lib.target/libchromeview.so Chrome/lib/armeabi-v7a/libchromeview.so.."
cp ../out/Release/lib.target/libchromeview.so Chrome/lib/armeabi-v7a/libchromeview.so
#echo "Stripping..."
#arm-eabi-strip Chrome/lib/armeabi-v7a/libchromeview.so
echo "./apktool b Chrome Chromium_unaligned.apk..."
apktool b Chrome Chromium_unaligned.apk
echo "jarsigner -sigalg MD5withRSA -digestalg SHA1 -keystore $ANDROID_SDK_ROOT/.android/debug.keystore -storepass android Chromium_unaligned.apk androiddebugkey..."
jarsigner -sigalg MD5withRSA -digestalg SHA1 -keystore $ANDROID_SDK_ROOT/.android/debug.keystore -storepass android Chromium_unaligned.apk androiddebugkey
echo "zipalign -f -v 4 Chromium_unaligned.apk Chromium.apk..."
zipalign -f -v 4 Chromium_unaligned.apk Chromium.apk
echo "adb install -r Chromium.apk..."
adb install -r Chromium.apk
