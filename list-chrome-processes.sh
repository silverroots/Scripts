#!/bin/sh

echo "adb root..."
adb root
echo "adb remount..."
adb remount
echo "adb forward tcp:5039 tcp:5039..."
adb forward tcp:5039 tcp:5039
echo "adb shell ps |grep chrom..."
adb shell ps |grep chrom
echo "adb shell gdbserver :5039 --attach "
