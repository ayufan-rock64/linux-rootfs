export VERSION ?= 0.1~dev

VARIANTS := $(patsubst configs/%,%,$(wildcard configs/*-*-*))

ARCHS := arm64
TARGETS := $(foreach arch,$(ARCHS),$(patsubst %,%-$(VERSION)-$(arch).tar.xz,$(VARIANTS)))

all: $(TARGETS)

keyring:
	bash -c 'dpkg -s ubuntu-keyring &>/dev/null || \
		( wget -c http://mirrors.kernel.org/ubuntu/pool/main/u/ubuntu-keyring/ubuntu-keyring_2021.03.26_all.deb && \
		  dpkg -i ubuntu-keyring_2021.03.26_all.deb && \
			rm ubuntu-keyring_2021.03.26_all.deb )'

info:
	@echo $(VARIANTS)

targets:
	@echo $(TARGETS)

%.xz: %
	xz -T 0 -f -3 $<

%.tar:
	eatmydata -- bash build.sh "$@" \
		"$(word 1,$(subst -, , $@))-$(word 2,$(subst -, , $@))-$(word 3,$(subst -, , $@))" \
		"$(word 1,$(subst -, , $@))" \
		"$(word 2,$(subst -, , $@))" \
		"$(lastword $(subst -, , $(basename $@)))"

$(foreach arch,$(ARCHS),$(addsuffix -$(arch), $(VARIANTS)): %-$(arch): %-$(VERSION)-$(arch).tar.xz)
