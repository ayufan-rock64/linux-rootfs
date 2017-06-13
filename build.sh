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

set -ex

if [[ ! -d "configs/$BUILD_VARIANT" ]]; then
    echo "Invalid BUILD_VARIANT: $BUILD_VARIANT (missing configs/$BUILD_VARIANT)"
    exit 1
fi

mkdir -p out/

TEMP=$(mktemp -d $(readlink -f out)/build.XXXXX)
cleanup() {
	sudo rm -rf "$TEMP"
}
trap cleanup EXIT

pushd $TEMP

if [[ "$BUILD_ARCH" == "arm64" ]]; then
    QEMU_BUILD_ARCH=aarch64
elif [[ "$BUILD_ARCH" == "armhf" ]]; then
    QEMU_BUILD_ARCH=arm
else
    echo "Unsupported BUILD_ARCH: $BUILD_ARCH."
    exit 1
fi

if [[ "$BUILD_MODE" == "debian" ]]; then
    ARCHIVE_AREAS="main contrib non-free"
elif [[ "$BUILD_MODE" == "ubuntu" ]]; then
    ARCHIVE_AREAS="main restricted universe multiverse"
else
    echo "Unsupported BUILD_MODE: $BUILD_MODE."
    exit 1
fi

lb config \
    --apt-indices false \
    --apt-recommends false \
    --apt-secure true \
    --architectures "$BUILD_ARCH" \
    --archive-areas "$ARCHIVE_AREAS" \
    --backports false \
    --binary-filesystem ext4 \
    --binary-images tar \
    --bootstrap-qemu-arch "$BUILD_ARCH" \
    --bootstrap-qemu-static "/usr/bin/qemu-$QEMU_BUILD_ARCH-static" \
    --chroot-filesystem none \
    --compression none \
    --distribution "$BUILD_SUITE" \
    --linux-flavours none \
    --linux-packages none \
    --mode "$BUILD_MODE" \
    --security true \
    --system normal

for path in $BUILD_MODE $BUILD_MODE-$BUILD_SUITE $BUILD_VARIANT; do
    if [[ -d "$ROOT_DIR/configs/$path" ]]; then
        cp -av "$ROOT_DIR/configs/$path/." config/
    fi
done

sudo lb build
sudo chown "$(id -u)" binary-tar.tar

mv binary-tar.tar "$BUILD_OUTPUT"
