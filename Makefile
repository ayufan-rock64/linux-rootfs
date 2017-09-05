export RELEASE_NAME ?= 0.1~dev

all: \
	ubuntu-xenial-mate-$(RELEASE_NAME)-armhf.tar.xz \
	ubuntu-xenial-mate-$(RELEASE_NAME)-arm64.tar.xz \
	ubuntu-zesty-mate-$(RELEASE_NAME)-armhf.tar.xz \
	ubuntu-zesty-mate-$(RELEASE_NAME)-arm64.tar.xz \
	ubuntu-artful-mate-$(RELEASE_NAME)-armhf.tar.xz \
	ubuntu-artful-mate-$(RELEASE_NAME)-arm64.tar.xz \
	ubuntu-xenial-i3-$(RELEASE_NAME)-arm64.tar.xz \
	ubuntu-xenial-i3-$(RELEASE_NAME)-armhf.tar.xz \
	ubuntu-zesty-i3-$(RELEASE_NAME)-arm64.tar.xz \
	ubuntu-zesty-i3-$(RELEASE_NAME)-armhf.tar.xz \
	ubuntu-xenial-minimal-$(RELEASE_NAME)-arm64.tar.xz \
	ubuntu-xenial-minimal-$(RELEASE_NAME)-armhf.tar.xz \
	ubuntu-zesty-minimal-$(RELEASE_NAME)-arm64.tar.xz \
	ubuntu-zesty-minimal-$(RELEASE_NAME)-armhf.tar.xz \
	ubuntu-artful-minimal-$(RELEASE_NAME)-arm64.tar.xz \
	ubuntu-artful-minimal-$(RELEASE_NAME)-armhf.tar.xz \
	debian-jessie-minimal-$(RELEASE_NAME)-arm64.tar.xz \
	debian-jessie-minimal-$(RELEASE_NAME)-armhf.tar.xz \
	debian-jessie-openmediavault-$(RELEASE_NAME)-arm64.tar.xz \
	debian-jessie-openmediavault-$(RELEASE_NAME)-armhf.tar.xz \
	debian-stretch-minimal-$(RELEASE_NAME)-arm64.tar.xz \
	debian-stretch-minimal-$(RELEASE_NAME)-armhf.tar.xz \
	debian-stretch-openmediavault-$(RELEASE_NAME)-arm64.tar.xz \
	debian-stretch-openmediavault-$(RELEASE_NAME)-armhf.tar.xz \

%.xz: %
	pxz -f -3 $<

%.tar:
	bash build.sh "$@" \
		"$(shell basename "$@" -$(RELEASE_NAME)-$(BUILD_ARCH).tar)" \
		"$(BUILD_MODE)" \
		"$(BUILD_SUITE)" \
		"$(BUILD_ARCH)"

%-armhf.tar.xz: BUILD_ARCH=armhf
%-arm64.tar.xz: BUILD_ARCH=arm64

ubuntu-%.tar.xz: BUILD_MODE=ubuntu
ubuntu-xenial-%.tar.xz: BUILD_SUITE=xenial
ubuntu-zesty-%.tar.xz: BUILD_SUITE=zesty
ubuntu-artful-%.tar.xz: BUILD_SUITE=artful

debian-%.tar.xz: BUILD_MODE=debian
debian-jessie-%.tar.xz: BUILD_SUITE=jessie
debian-stretch-%.tar.xz: BUILD_SUITE=stretch
