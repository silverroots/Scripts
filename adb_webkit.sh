#!/bin/sh
echo "adb root..."
adb root
echo "adb remount..."
adb remount
echo "Forwarding adb port..."
adb forward tcp:5039 tcp:5039
echo "available chrome processes..."
adb shell ps |grep chrom
echo "adb shell gdbserver :5039 --attach "
