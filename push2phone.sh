#!/bin/sh

echo "Building chrome..."
./panda_chromium_build_using_ms2_toolchain.sh /scratchbox/users/silverroots/targets/$1/
echo "Creating out/Release/bin_patch directory..."
mkdir -p out/Release/bin_patch/
echo "Deleting existing contents of bin_patch..."
rm -rf out/Release/bin_patch/*
echo "Copying chrome binaries to bin_patch folder..."
cd out/Release/
cp -r chrome* gen* locales/ mksnapshot product_logo_48.png protoc pyproto/ re2c resources* ssl_false_start_blacklist_process xdg* yasm out/Release/bin_patch/
cd -
echo "Striping down binaries..."
/scratchbox/compilers/arm-linux-cs2010q1-202/bin/arm-none-linux-gnueabi-strip out/Release/bin_patch/*
echo "Pushing bin_patch to device at /userdata/chrome..."
sudo adb push out/Release/bin_patch/ /userdata/chrome/
