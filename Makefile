export RELEASE_NAME ?= 0.1~dev

VARIANTS := $(patsubst configs/%,%,$(wildcard configs/*-*-*))

all: \
	$(patsubst %,%-$(RELEASE_NAME)-armhf.tar.xz,$(VARIANTS)) \
	$(patsubst %,%-$(RELEASE_NAME)-arm64.tar.xz,$(VARIANTS))

info:
	@echo $(VARIANTS)

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

$(addsuffix -armhf, $(VARIANTS)): %-armhf: %-$(RELEASE_NAME)-armhf.tar.xz
$(addsuffix -arm64, $(VARIANTS)): %-arm64: %-$(RELEASE_NAME)-arm64.tar.xz

ubuntu-%.tar.xz: BUILD_MODE=ubuntu
ubuntu-xenial-%.tar.xz: BUILD_SUITE=xenial
ubuntu-zesty-%.tar.xz: BUILD_SUITE=zesty
ubuntu-artful-%.tar.xz: BUILD_SUITE=artful
ubuntu-bionic-%.tar.xz: BUILD_SUITE=bionic

debian-%.tar.xz: BUILD_MODE=debian
debian-jessie-%.tar.xz: BUILD_SUITE=jessie
debian-stretch-%.tar.xz: BUILD_SUITE=stretch

.PHONY: shell		# run docker shell to build image
shell:
	@echo Building environment...
	@docker build -q -t rock64-rootfs:build-environment environment/
	@echo Entering shell...
	@docker run --rm \
		-it \
		-e HOME -v $(HOME):$(HOME) \
		--privileged \
		-h rock64-build-env \
		-v $(CURDIR):$(CURDIR) \
		-w $(CURDIR) \
		rock64-rootfs:build-environment
