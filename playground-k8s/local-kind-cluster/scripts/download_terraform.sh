#!/bin/bash
TF_VERSION=1.8.1
ROOTDIR=$1
set -e

if ! command -v curl &> /dev/null
then
    echo "curlcould not be found"
    exit
fi

WINDOWS=https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_windows_amd64.zip
LINUX=https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip
MACOS=https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_darwin_amd64.zip
MACOS_ARM=https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_darwin_arm64.zip

WINDOWS_TARGET_FILE=terraform-windows-amd64
WINDOWS_TARGET_DIR=$ROOTDIR/executables/windows
LINUX_TARGET_FILE=terraform-linux-amd64
LINUX_TARGET_DIR=$ROOTDIR/executables/linux
MACOS_TARGET_FILE=terraform-darwin-amd64
MACOS_TARGET_DIR=$ROOTDIR/executables/macos
MACOS_ARM_TARGET_FILE=terraform-darwin-arm64
MACOS_ARM_TARGET_DIR=$ROOTDIR/executables/macos

mkdir -p $WINDOWS_TARGET_DIR
mkdir -p $LINUX_TARGET_DIR
mkdir -p $MACOS_TARGET_DIR

echo "Downloading $WINDOWS to $WINDOWS_TARGET_DIR/$WINDOWS_TARGET_FILE"
curl -s -L $WINDOWS --output $WINDOWS_TARGET_DIR/$WINDOWS_TARGET_FILE
cp $WINDOWS_TARGET_DIR/$WINDOWS_TARGET_FILE $WINDOWS_TARGET_DIR/terraform-amd64.exe

echo "Downloading $LINUX"
curl -s -L $LINUX --output $LINUX_TARGET_DIR/$LINUX_TARGET_FILE

echo "Downloading $MACOS AMD"
curl -s -L $MACOS --output $MACOS_TARGET_DIR/$MACOS_TARGET_FILE

echo "Downloading $MACOS_ARM ARM"
curl -s -L $MACOS_ARM --output $MACOS_ARM_TARGET_DIR/$MACOS_ARM_TARGET_FILE

chmod u+x $WINDOWS_TARGET_DIR/$WINDOWS_TARGET_FILE $WINDOWS_TARGET_DIR/terraform-amd64.exe
chmod u+x $LINUX_TARGET_DIR/*
chmod u+x $MACOS_TARGET_DIR/*
chmod u+x $MACOS_ARM_TARGET_DIR/*