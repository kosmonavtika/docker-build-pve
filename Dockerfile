FROM debian:10.0
ARG DEBIAN_FRONTEND="noninteractive"

RUN mkdir /build

# build dependencies
RUN \
  apt-get update && \
  apt-get install -y \
    apt-utils \
    build-essential \
    git \
    debhelper \
    autogen \
    dh-autoreconf \
    wget \
    lintian \
    rsync

# quasar-ve component packages
RUN \
  apt-get install -y \
    corosync \
    rsyslog \
    systemd \
    libprotobuf-dev \
    protobuf-c-compiler \
    protobuf-compiler python-protobuf \
    libarchive-any-perl \
    lvm2 \
    novnc \
    openvswitch-switch \
    libspice-server1 \
    libspice-protocol-dev \
    smartmontools

# pve-common
RUN \
    apt-get install -y \
        libdevel-cycle-perl \
        libfilesys-df-perl \
        liblinux-inotify2-perl \
        libstring-shellquote-perl \
        libcrypt-openssl-random-perl \
        libcrypt-openssl-rsa-perl \
        libio-stringy-perl \
        libmime-base32-perl \
        libnet-dbus-perl \
        libjson-perl \
    && \
    git -C /build/ clone git://git.proxmox.com/git/pve-common.git && \
    cd /build/pve-common && \
    make dinstall

# libjs-extjs
RUN \
    wget -P /build/ http://download.proxmox.com/debian/pve/dists/buster/pve-no-subscription/binary-amd64/libjs-extjs_6.0.1-10_all.deb && \
    dpkg -i /build/libjs-extjs_6.0.1-10_all.deb

# libpve-apiclient-perl
RUN \
    apt-get install -y \
        libcrypt-ssleay-perl \
        libhttp-message-perl \
        libio-socket-ssl-perl \
        libjson-perl \
        liburi-perl \
        libwww-perl \
    && \
    wget -P /build/ http://download.proxmox.com/debian/pve/dists/buster/pve-no-subscription/binary-amd64/libpve-apiclient-perl_3.0-2_all.deb && \
    dpkg -i /build/libpve-apiclient-perl_3.0-2_all.deb

# pve-docs (generator)
RUN \
    apt-get install -y \
        asciidoc-dblatex \
        docbook-xsl \
        graphviz \
        imagemagick-6.q16 \
        librsvg2-bin \
        source-highlight \
    && \
    git -C /build/ clone git://git.proxmox.com/git/pve-docs.git && \
    cd /build/pve-docs && \
    make pve-doc-generator.mk && \
    make gen-install 

# pve-i18n
RUN \
    wget -P /build/ http://download.proxmox.com/debian/pve/dists/buster/pve-no-subscription/binary-amd64/pve-i18n_2.0-2_all.deb && \
    dpkg -i /build/pve-i18n_2.0-2_all.deb

# proxmox-widget-toolkit
RUN \
    wget -P /build/ http://download.proxmox.com/debian/pve/dists/buster/pve-no-subscription/binary-amd64/proxmox-widget-toolkit_2.0-5_all.deb && \
    dpkg -i /build/proxmox-widget-toolkit_2.0-5_all.deb

# pve-zsync
RUN \
    wget -P /build/ http://download.proxmox.com/debian/pve/dists/buster/pve-no-subscription/binary-amd64/pve-zsync_2.0-1_all.deb && \
    dpkg -i /build/pve-zsync_2.0-1_all.deb

# pve-edk2-firmware
RUN \
    wget -P /build http://download.proxmox.com/debian/pve/dists/buster/pve-no-subscription/binary-amd64/pve-edk2-firmware_2.20190614-1_all.deb && \
    dpkg -i /build/pve-edk2-firmware_2.20190614-1_all.deb

# libpve-http-server-perl
RUN \
    apt-get install -y \
        libanyevent-http-perl \
        libanyevent-perl \
        libnet-ip-perl \
        libjs-bootstrap \
    && \
    wget -P /build/ http://download.proxmox.com/debian/pve/dists/buster/pve-no-subscription/binary-amd64/libpve-http-server-perl_3.0-2_all.deb && \
    dpkg -i /build/libpve-http-server-perl_3.0-2_all.deb

# vncterm
RUN \
    apt-get install -y \
        libglib2.0-dev \
        libgnutls28-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        unifont \
        quilt \ 
    && \
    git -C /build/ clone git://git.proxmox.com/git/vncterm.git && \
    cd /build/vncterm && \
    make dinstall

# pve-qemu
RUN \
    apt-get install -y \
        libspice-server-dev \
        libpixman-1-dev \
        libfdt-dev \
        libjpeg62-turbo \
        libjpeg62-turbo-dev \
        check \
        glusterfs-common \
        libacl1-dev \
        libaio-dev \
        libcap-dev \
        libiscsi-dev \
        libjemalloc-dev \
        libnuma-dev \
        libpci-dev \
        librbd-dev \
        libsdl1.2-dev \
        libusb-1.0-0-dev \
        libusbredirparser-dev \
        texi2html \
        texinfo \
        uuid-dev \
        xfslibs-dev \
        ceph-common \
        iproute2 \
        numactl \
        libspice-server1 \
        libcurl4-gnutls-dev \
        libseccomp-dev \
        python3-sphinx \
        flex \
        bison \
    && \
    git -C /build/ clone git://git.proxmox.com/git/pve-qemu.git && \
    cd /build/pve-qemu && \
    make dinstall

# pve-docs (docs)
RUN \
    cd /build/pve-docs && \
    make dinstall

# pve-access-control (1/2)
RUN \
    git -C /build/ clone git://git.proxmox.com/git/pve-access-control.git && \
    cd /build/pve-access-control/PVE && \
    PERLDIR=/usr/share/perl5 make install

# libpve-u2f-server-perl
RUN \
    apt-get install -y \
      libu2f-server-dev \
    && \
    git -C /build/ clone git://git.proxmox.com/git/libpve-u2f-server-perl.git && \
    cd /build/libpve-u2f-server-perl && \
    make dinstall

# pve-cluster
RUN \
    apt-get install -y \
        corosync \
        dh-systemd \
        libcmap-dev \
        libcpg-dev \
        libfuse-dev \
        libquorum-dev \
        librrd-dev \
        librrds-perl \
        libsqlite3-dev \
        libuuid-perl \
        rrdcached \
        sqlite3 \
        fakeroot \
        fuse \
        glib2.0 \
        libglib2.0-dev \
        libglib2.0 \
        libnet-ldap-perl \
        libauthen-pam-perl \
        faketime \
    && \
    git -C /build/ clone git://git.proxmox.com/git/pve-cluster.git && \
    cd /build/pve-cluster && \
    make dinstall

# pve-access-control (2/2)
RUN \
    apt-get install -y \
        libauthen-pam-perl \
        libnet-ldap-perl \
    && \
    cd /build/pve-access-control && \
    make dinstall

# pve-firewall
RUN \
    apt-get install -y \
        libnetfilter-conntrack-dev \
        libnetfilter-log-dev \
        ebtables \
        ipset \
    && \
    git -C /build/ clone git://git.proxmox.com/git/pve-firewall.git && \
    cd /build/pve-firewall && \
    make dinstall

# librados2-perl
RUN \
    git -C /build/ clone git://git.proxmox.com/git/librados2-perl.git && \
    cd /build/librados2-perl && \
    make dinstall

# pve-storage
RUN \
    apt-get install -y \
        smbclient \
        cifs-utils \
        cstream \
        glusterfs-client \
        libfile-chdir-perl \
        nfs-common \
        thin-provisioning-tools \
        udev \
        ceph-fuse \
    && \
    wget -P /build/ http://download.proxmox.com/debian/dists/buster/pve-no-subscription/binary-amd64/libpve-storage-perl_6.0-6_all.deb && \
    dpkg -i /build/libpve-storage-perl_6.0-6_all.deb

# pve-guest-common
RUN \
    git -C /build/ clone git://git.proxmox.com/git/pve-guest-common.git && \
    cd /build/pve-guest-common && \
    make dinstall

# pve-ha-manager
RUN \
    apt-get install -y \
        libglib-perl \
        libgtk3-perl \
        dh-systemd \
    && \
    git -C /build/ clone git://git.proxmox.com/git/pve-ha-manager.git && \
    cd /build/pve-ha-manager && \
    make dinstall

# criu
RUN \
    apt-get install -y \
        asciidoc \
        dh-python \
        libnet1-dev \
        libnl-3-dev \
        libprotobuf-c-dev \
        python-all \
        python-future \
        python-ipaddr \
    && \
    git -C /build/ clone git://git.proxmox.com/git/criu.git && \
    cd /build/criu && \
    make dinstall

# lxcfs
RUN \
    apt-get install -y \
        help2man \
        libpam0g-dev \
    && \
    git -C /build/ clone git://git.proxmox.com/git/lxcfs.git && \
    cd /build/lxcfs && \
    sed -i "s/x86_64-linux-gnu/`uname -m`-linux-gnu/g" debian/rules && \
    sed -i "s/x86_64-linux-gnu/`uname -m`-linux-gnu/g" debian/lxcfs.links && \
    make dinstall

# lxc
RUN \
    apt-get install -y \
        bash-completion \
        dh-apparmor \
        docbook2x \
        doxygen \
        libapparmor-dev \
        apparmor \
        bridge-utils \
        uidmap \
    && \
    git -C /build/ clone git://git.proxmox.com/git/lxc.git && \
    cd /build/lxc && \
    make dinstall

# pve-container
RUN \
    apt-get install -y libtest-mockmodule-perl && \
    git -C /build/ clone git://git.proxmox.com/git/pve-container.git && \
    cd /build/pve-container && \
    rm src/test/Makefile && \
    echo "all: test\n\ntest: test_setup test_snapshot test_bindmount\n\ntest_setup:\n\n\n\ntest_snapshot:\n\n\n\ntest_bindmount:\n\n\n\nclean:\n	rm -rf tmprootfs" > src/test/Makefile && \
    make dinstall

# qemu-server
RUN \
    apt-get install -y \
        libjson-c-dev \
        libio-multiplex-perl \
        genisoimage \
        libterm-readline-gnu-perl \
        socat \
        pve-qemu-kvm \
    && \
    git -C /build/ clone git://git.proxmox.com/git/qemu-server.git && \
    cd /build/qemu-server && \
    rm test/Makefile && \
    echo "all: test\n\ntest: test_snapshot test_ovf test_cfg_to_cmd\n\ntest_snapshot:\ntest_ovf:\ntest_cfg_to_cmd:\n" > test/Makefile && \
    make dinstall

# libqb
RUN \
    apt-get install -y doxygen && \
    git -C /build/ clone git://git.proxmox.com/git/libqb.git && \
    cd /build/libqb && \
    make dinstall

# novnc-pve
RUN \
    wget -P /build/ http://download.proxmox.com/debian/dists/buster/pve-no-subscription/binary-amd64/novnc-pve_1.0.0-60_all.deb && \
    dpkg -i /build/novnc-pve_1.0.0-60_all.deb

# pve-xtermjs
RUN \
    git -C /build/ clone git://git.proxmox.com/git/pve-xtermjs.git && \
    cd /build/pve-xtermjs && \
    make dinstall

# spiceterm
RUN \
    git -C /build/ clone git://git.proxmox.com/git/spiceterm.git && \
    cd /build/spiceterm && \
    make dinstall

# proxmox-mini-journalreader
RUN \
    apt-get install -y libsystemd-dev && \
    git -C /build/ clone git://git.proxmox.com/git/proxmox-mini-journalreader.git && \
    cd /build/proxmox-mini-journalreader && \
    sed -i 's/\"b:e:d:n:f:t:h\")) != -1)/\"b:e:d:n:f:t:h\")) != (char) -1)/' src/mini-journalreader.c && \
    make dinstall

# pve-manager
RUN \
    apt-get install -y \
        libfile-readbackwards-perl \
        liblocale-po-perl \
        libtemplate-perl \
        dtach \
        fonts-font-awesome \
        gdisk \
        hdparm \
        ifenslave \
        lzop \
        pciutils \
    && \
    git -C /build/ clone git://git.proxmox.com/git/pve-manager.git && \
    cd /build/pve-manager && \
    rm test/Makefile && \
    echo "include ../defines.mk\n\nall:\n\nexport PERLLIB=..\n\ncheck:\n\n\n.PHONY: install\ninstall:\n\n\n.PHONY: clean\n\n\nclean:\n	rm -rf *~ .mocked_* *.tmp\n" > test/Makefile && \
    make dinstall

# pve-kernel
RUN \
    apt-get install -y \
        bc \
        cpio \
        libdw-dev \
        libelf-dev \
        libiberty-dev \
        libssl-dev \
        openssh-server \
        linux-base \
        busybox \
        initramfs-tools \
    && \
    git -C /build/ clone git://git.proxmox.com/git/pve-kernel.git && \
    cd /build/pve-kernel && \
    cp debian/rules.d/amd64.mk debian/rules.d/arm64.mk && \
    sed -i "s/x86/arm64/g" debian/rules.d/arm64.mk && \
    make deb

# pve-kernel-meta
RUN \
    git -C /build/ clone git://git.proxmox.com/git/pve-kernel-meta.git && \
    cd /build/pve-kernel-meta && \
    make deb

# proxmox-ve
RUN \
    git -C /build/ clone git://git.proxmox.com/git/proxmox-ve.git && \
    cd /build/proxmox-ve && \
    make deb

# libgtk3-webkit-perl
RUN \
    apt-get install -y gir1.2-webkit-3.0 && \
    git -C /build/ clone git://git.proxmox.com/git/libgtk3-webkit-perl.git && \
    cd /build/libgtk3-webkit-perl && \
    make dinstall

# pve-installer
RUN \
    apt-get install -y geoip-bin \
        squashfs-tools \
        libgtk3-webkit2-perl \
    && \
    git -C /build/ clone git://git.proxmox.com/git/pve-installer.git && \
    cd /build/pve-installer && \
    make deb

RUN \
    echo "DONE!"

# upload artifacts
RUN apt-get install -y python3 python3-pip && \
  pip3 install awscli && \
  pip3 install awscli-plugin-endpoint && \
  mkdir -p /root/.aws
ADD ./s3/config /root/.aws/config
ADD ./s3/credentials /root/.aws/credentials
RUN mkdir -p /dist/ && \
  find /build/ -name '*.deb' -exec cp -prv '{}' '/dist/' ';' && \
  aws s3 cp --recursive /dist/ s3://`uname -m | sed 's/x86_64/amd64/g'`-deb/ && \
