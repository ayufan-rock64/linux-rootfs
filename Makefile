all: xenial-i3-arm64.tar.xz xenial-mate-arm64.tar.xz xenial-minimal-arm64.tar.xz \
	xenial-i3-armhf.tar.xz xenial-mate-armhf.tar.xz xenial-minimal-armhf.tar.xz

%.tar.xz: %.tar
	pxz -f -3 $<

%.img.xz: %.img
	pxz -f -3 $<

%.tar:
	bash build.sh "$@" "$(shell basename "$@" -$(BUILD_ARCH).tar)" "$(BUILD_MODE)" "$(BUILD_SUITE)" "$(BUILD_ARCH)"

%-armhf.tar: BUILD_ARCH=arm64
%-arm64.tar: BUILD_ARCH=arm64

xenial-%.tar: BUILD_SUITE=xenial
xenial-%.tar: BUILD_MODE=ubuntu
