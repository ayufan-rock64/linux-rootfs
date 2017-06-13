export RELEASE_NAME ?= 0.1~dev

all: \
	xenial-mate-$(RELEASE_NAME)-armhf.tar.xz \
	xenial-mate-$(RELEASE_NAME)-arm64.tar.xz \
	xenial-i3-$(RELEASE_NAME)-arm64.tar.xz \
	xenial-i3-$(RELEASE_NAME)-armhf.tar.xz \
	xenial-minimal-$(RELEASE_NAME)-arm64.tar.xz \
	xenial-minimal-$(RELEASE_NAME)-armhf.tar.xz

%.tar.xz:
	bash build.sh "$@" "$(shell basename "$@" -$(RELEASE_NAME)-$(BUILD_ARCH).tar.xz)" "$(BUILD_MODE)" "$(BUILD_SUITE)" "$(BUILD_ARCH)"

%-armhf.tar.xz: BUILD_ARCH=armhf
%-arm64.tar.xz: BUILD_ARCH=arm64

xenial-%.tar.xz: BUILD_SUITE=xenial
xenial-%.tar.xz: BUILD_MODE=ubuntu
