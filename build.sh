#!/bin/bash

if [[ $# -ne 5 ]]; then
    echo "usage: $0 <output> <variant> <mode> <suite> <arch>"
    exit 1
fi

BUILD_OUTPUT="$1"
BUILD_VARIANT="$2"
BUILD_MODE="$3"
BUILD_SUITE="$4"
BUILD_ARCH="$5"

BUILD_OUTPUT="$(readlink -f "$1")"

ROOT_DIR="$(pwd)"

set -e

mkdir -p out/

TEMP=$(mktemp -d out/build.XXXXX)
cleanup() {
	sudo rm -rf "$TEMP"
}
trap cleanup EXIT

pushd $TEMP

QEMU_BUILD_ARCH=$BUILD_ARCH
if [[ "$QEMU_BUILD_ARCH" == "arm64" ]]; then
    QEMU_BUILD_ARCH=aarch64
fi

lb config \
    --apt-indices false \
    --apt-recommends false \
    --apt-secure true \
    --architectures "$BUILD_ARCH" \
    --archive-areas 'main restricted universe multiverse' \
    --backports false \
    --binary-filesystem ext4 \
    --binary-images tar \
    --bootstrap-qemu-arch $BUILD_ARCH \
    --bootstrap-qemu-static "/usr/bin/qemu-$QEMU_BUILD_ARCH-static" \
    --chroot-filesystem none \
    --compression xz \
    --distribution "$BUILD_SUITE" \
    --linux-flavours none \
    --linux-packages none \
    --mode "$BUILD_MODE" \
    --security true \
    --system normal

cp -av $ROOT_DIR/configs/$BUILD_MODE/. config/
cp -av $ROOT_DIR/configs/$BUILD_VARIANT/. config/

sudo lb build
sudo chmod "$(id -u)" binary-tar.tar.xz

mv binary-tar.tar.xz "$OUTPUT"
