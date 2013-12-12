#!/bin/bash

usage() {
    echo "Bad argument(s)"
    echo "$0: Usage:"
    echo "        --build        Starts a target build in debug mode. --release can be specified for release mode"
    echo "                       --online flag can also be specified if it is a clean build"
    echo "        --install      Push and install the latest rpm package on target"
    echo "                       Also setup debugging environment i.e. install the rpm packages on local machine"
    echo "                       --external flag can be specified to setup of external rpm"
    echo "        --debug        Start browser on the remote device and attach gdbserver to WebProcess"
    echo "        --attach       Attach gdbserver to existing WebProcess"
    echo "        --inspect      Setups the device to enable Remote Web Inspector"
}

TIZEN_BINARIES_ROOT=/home/user/tizenBinaries/
OSCE_ROOT=/home/user/osce/osce-root/


TARGET_BINARIES_LOCATION=${TIZEN_BINARIES_ROOT}latest/
TEMP_BINARY_NAME=`ls ${TARGET_BINARIES_LOCATION}`
TEMP_BINARY_NAME=($TEMP_BINARY_NAME)
TEMP_BINARY_NAME=${TEMP_BINARY_NAME[0]}
BINARY_VERSION_NUMBER=${TEMP_BINARY_NAME:12:(-17)}
INSTAL_BINARY_NAME="webkit2-efl-${BINARY_VERSION_NUMBER}-local.armv7l.rpm"

buildTarget() {
    export http_proxy=
    export https_proxy=
    buildArgs="--debug"
    if [ "$arg2" == "--release" ] || [ "$arg3" == "--release" ]; then
        buildArgs="--release"
    fi

    if [ "$arg2" == "--online" ] || [ "$arg3" == "--online" ]; then
        buildArgs="$buildArgs --online"
    else
        buildArgs="$buildArgs --offline"
    fi

    osce build armv7el $buildArgs
    sudo rm -rf ${TIZEN_BINARIES_ROOT}latest
    mkdir -p ${TIZEN_BINARIES_ROOT}latest
    cp ${OSCE_ROOT}output/* ${TIZEN_BINARIES_ROOT}latest
}

setupDebugging() {
    TARGET_BINARIES_OUT_LOCATION=${TIZEN_BINARIES_ROOT}out/

    sudo rm -rf $TARGET_BINARIES_OUT_LOCATION
    mkdir -p $TARGET_BINARIES_OUT_LOCATION
    cd $TARGET_BINARIES_OUT_LOCATION
    rpm2cpio ${TARGET_BINARIES_LOCATION}webkit2-efl-${BINARY_VERSION_NUMBER}-local.armv7l.rpm | cpio -idvm
    rpm2cpio ${TARGET_BINARIES_LOCATION}webkit2-efl-debuginfo-${BINARY_VERSION_NUMBER}-local.armv7l.rpm | cpio -idvm

    if [ "$arg2" == "--external" ]; then
        rpm2cpio ${TARGET_BINARIES_LOCATION}webkit2-efl-debugsource-${BINARY_VERSION_NUMBER}-local.armv7l.rpm | cpio -idvm
    else
        cd -
        mkdir -p ${TARGET_BINARIES_OUT_LOCATION}usr/src/debug
        ln -sf `pwd` ${TARGET_BINARIES_OUT_LOCATION}usr/src/debug/webkit2-efl-$BINARY_VERSION_NUMBER
    fi
}

pushAndInstall() {
    REMOTE_BINARY_DIR=/opt/media/browserBinary/

    sdb shell rm -rf $REMOTE_BINARY_DIR
    sdb shell mkdir -p $REMOTE_BINARY_DIR

    sdb push ${TARGET_BINARIES_LOCATION}${INSTAL_BINARY_NAME} $REMOTE_BINARY_DIR
    sdb shell change-booting-mode.sh --update
    sdb shell rpm -Uvh --force ${REMOTE_BINARY_DIR}${INSTAL_BINARY_NAME}

    # Install on local machine as well
    setupDebugging
}

startGDBServer() {
    sdb shell pkill gdbserver

    PID_WEBPROCESS=`sdb shell pidof WebProcess`
    sdb shell gdbserver :1234 --attach ${PID_WEBPROCESS:0:${#PID_WEBPROCESS}-1} >/dev/null 2>/dev/null &
    sdb forward tcp:9999 tcp:1234
    echo "gdbserver listening on local port :9999"
}

restartBrowser() {
    sdb shell pkill browser
    sdb shell /usr/apps/com.samsung.browser/bin/browser >/dev/null 2>/dev/null &
    echo "Waiting to launch browser...."
    sleep 5s
}

restartAndAttach() {
    restartBrowser
    startGDBServer
}

initiateWebInspector() {
    sdb shell pkill browser
    sleep 2s
    sdb shell sqlite3 /opt/usr/apps/com.samsung.browser/data/.pref.db " update pref set pref_data=1 where pref_key='DemoMode'; update pref set pref_data=1 where pref_key='RemoteWebInspector';"
    sdb shell /usr/apps/com.samsung.browser/bin/browser >/dev/null 2>/dev/null &
    read -p "Enter Remote Web Inspector Port number: " rwi_port
    sdb forward tcp:9999 tcp:$rwi_port
    google-chrome http://127.0.0.1:9999 >/dev/null 2>/dev/null &
}

if [ -z $1 ]; then
    arg=""
else
    arg=$1
fi

arg2=$2
arg3=$3

sdb root on

case $arg in
    "--build") buildTarget ;;
    "--install") pushAndInstall ;;
    "--debug") restartAndAttach ;;
    "--attach") startGDBServer ;;
    "--inspect") initiateWebInspector ;;
    *) usage ;;
esac

