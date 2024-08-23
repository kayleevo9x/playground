#!/bin/bash
ROOTDIR=$1
set -e

if ! command -v sha256sum &> /dev/null
then
    echo "sha256sum could not be found"
    exit
fi

if ! command -v curl &> /dev/null
then
    echo "curlcould not be found"
    exit
fi

# KinD 1.30 (release 0.23.0)
# https://github.com/kubernetes-sigs/kind/releases/tag/v0.23.0
KIND_VERSION=v0.23.0

WINDOWS=https://github.com/kubernetes-sigs/kind/releases/download/$KIND_VERSION/kind-windows-amd64
LINUX=https://github.com/kubernetes-sigs/kind/releases/download/$KIND_VERSION/kind-linux-amd64
MACOS=https://github.com/kubernetes-sigs/kind/releases/download/$KIND_VERSION/kind-darwin-amd64
MACOS_ARM=https://github.com/kubernetes-sigs/kind/releases/download/$KIND_VERSION/kind-darwin-arm64

WINDOWS_TARGET_FILE=kind-windows-amd64
WINDOWS_TARGET_DIR=$ROOTDIR/executables/windows
LINUX_TARGET_FILE=kind-linux-amd64
LINUX_TARGET_DIR=$ROOTDIR/executables/linux
MACOS_TARGET_FILE=kind-darwin-amd64
MACOS_TARGET_DIR=$ROOTDIR/executables/macos
MACOS_ARM_TARGET_FILE=kind-darwin-arm64
MACOS_ARM_TARGET_DIR=$ROOTDIR/executables/macos

mkdir -p $WINDOWS_TARGET_DIR
mkdir -p $LINUX_TARGET_DIR
mkdir -p $MACOS_TARGET_DIR

echo "Downloading $WINDOWS to $WINDOWS_TARGET_DIR/$WINDOWS_TARGET_FILE"
curl -s -L $WINDOWS --output $WINDOWS_TARGET_DIR/$WINDOWS_TARGET_FILE
curl -s -L $WINDOWS.sha256sum --output $WINDOWS_TARGET_DIR/$WINDOWS_TARGET_FILE.sha256sum
cd $WINDOWS_TARGET_DIR; sha256sum -c $WINDOWS_TARGET_FILE.sha256sum
cp $WINDOWS_TARGET_DIR/$WINDOWS_TARGET_FILE $WINDOWS_TARGET_DIR/kind-amd64.exe

echo "Downloading $LINUX"
curl -s -L $LINUX --output $LINUX_TARGET_DIR/$LINUX_TARGET_FILE
curl -s -L $LINUX.sha256sum --output $LINUX_TARGET_DIR/$LINUX_TARGET_FILE.sha256sum
cd $LINUX_TARGET_DIR; sha256sum -c $LINUX_TARGET_FILE.sha256sum

echo "Downloading $MACOS AMD"
curl -s -L $MACOS --output $MACOS_TARGET_DIR/$MACOS_TARGET_FILE
curl -s -L $MACOS.sha256sum --output $MACOS_TARGET_DIR/$MACOS_TARGET_FILE.sha256sum
cd $MACOS_TARGET_DIR; sha256sum -c $MACOS_TARGET_FILE.sha256sum

echo "Downloading $MACOS_ARM ARM"
curl -s -L $MACOS_ARM --output $MACOS_ARM_TARGET_DIR/$MACOS_ARM_TARGET_FILE
curl -s -L $MACOS_ARM.sha256sum --output $MACOS_ARM_TARGET_DIR/$MACOS_ARM_TARGET_FILE.sha256sum
cd $MACOS_ARM_TARGET_DIR; sha256sum -c $MACOS_ARM_TARGET_FILE.sha256sum

chmod u+x $WINDOWS_TARGET_DIR/$WINDOWS_TARGET_FILE $WINDOWS_TARGET_DIR/kind-amd64.exe
chmod u+x $LINUX_TARGET_DIR/*
chmod u+x $MACOS_TARGET_DIR/*
chmod u+x $MACOS_ARM_TARGET_DIR/*