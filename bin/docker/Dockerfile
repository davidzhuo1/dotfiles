# Stupid simple Docker instance

# Start with Ubuntu 16.04 LTS
FROM ubuntu:16.04

ARG SSH_KEY

# Re-sync package index files from their sources
RUN apt-get update && apt-get -y upgrade && apt-get install -y --no-install-recommends \
    # intel-opencl \
    # mg \
    autoconf \
    bison \
    build-essential \
    cpio \
    debhelper \
    debmake \
    dh-make \
    dosfstools \
    dpkg-dev \
    ethtool \
    fakeroot \
    file \
    fio \
    flex \
    git \
    grub-efi-amd64 \
    iasl \
    iperf3 \
    less \
    locales \
    locate \
    logrotate \
    lshw \
    manpages-dev \
    manpages-posix-dev \
    msr-tools \
    net-tools \
    openssh-server \
    parted \
    pciutils \
    pigz \
    pkg-config \
    python3-debian \
    silversearcher-ag \
    squashfs-tools \
    strace \
    stress-ng \
    systemd-container \
    usbutils \
    vim-common \
    xorriso \
    zsh \
    --

# Setup locales
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US
ENV LC_ALL en_US.UTF-8
RUN dpkg-reconfigure --frontend noninteractive locales

# Launch sshd (not using systemd, because Docker doesn't like it)
RUN mkdir -p /var/run/sshd /root/.ssh/
RUN echo ${SSH_KEY} > /root/.ssh/authorized_keys

# Setup niceties
RUN chsh -s /bin/zsh
COPY ./resources/zshrc /root/.zshrc
COPY ./resources/mg /root/.mg

# Run it
CMD /usr/sbin/sshd && zsh
