export VERSION ?= 0.1~dev

VARIANTS := $(patsubst configs/%,%,$(wildcard configs/*-*-*))

all: \
	$(patsubst %,%-$(VERSION)-armhf.tar.xz,$(VARIANTS)) \
	$(patsubst %,%-$(VERSION)-arm64.tar.xz,$(VARIANTS))

info:
	@echo $(VARIANTS)

%.xz: %
	xz -T 0 -f -3 $<

%.tar:
	eatmydata -- bash build.sh "$@" \
		"$(shell basename "$@" -$(VERSION)-$(BUILD_ARCH).tar)" \
		"$(BUILD_MODE)" \
		"$(BUILD_SUITE)" \
		"$(BUILD_ARCH)"

%-armhf.tar.xz: BUILD_ARCH=armhf
%-arm64.tar.xz: BUILD_ARCH=arm64

$(addsuffix -arm64, $(VARIANTS)): %-arm64: %-$(VERSION)-arm64.tar.xz

debian-%.tar.xz: BUILD_MODE=debian
debian-bookworm-%.tar.xz: BUILD_SUITE=bookworm

.PHONY: shell		# run docker shell to build image
shell:
	@echo Entering shell...
	@docker run --rm \
		-it \
		-e HOME -v $(HOME):$(HOME) \
		--privileged \
		-h rock64-build-env \
		-v $(CURDIR):$(CURDIR) \
		-w $(CURDIR) \
		ayufan/rock64-dockerfiles:bookworm
