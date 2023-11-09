FROM debian:latest

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update -y && \
    apt-get install -y git-core gnupg flex bison gperf build-essential \
    zip curl zlib1g-dev python3-dev \
    x11proto-core-dev libx11-dev ccache \
    libgl1-mesa-dev libxml2-utils xsltproc unzip mtools u-boot-tools \
    htop iotop sysstat iftop pigz bc device-tree-compiler lunzip \
    dosfstools gcc-aarch64-linux-gnu g++-aarch64-linux-gnu \
    gcc-arm-linux-gnueabi g++-arm-linux-gnueabi ccache \
    sudo cpio nano vim kmod kpartx wget libarchive-tools qemu-user-static \
    xz-utils ruby-dev debootstrap multistrap libssl-dev parted \
    live-build golang-go

ENV GOPATH=/go \
    PATH=$PATH:/go/bin

RUN go install github.com/github-release/github-release@v0.10.0 && \
    which github-release

ENV USER=root \
    HOME=/root
