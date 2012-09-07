---
title: Using EL6 hosts with Ovirt
authors: deadhorseconsulting, sandrobonazzola
wiki_title: Using EL6 hosts with Ovirt
wiki_revision_count: 16
wiki_last_updated: 2014-09-26
---

# Using EL6 hosts with Ovirt

How to use EL6 based hosts with Ovirt-Engine 3.1+

## Assumptions and Prerequisities

*   An installed and running instance of ovirt-engine See: [Installing_ovirt-engine_from_rpm](Installing_ovirt-engine_from_rpm)
*   A system or VM loaded with some flavor of EL6 EG: RHEL, CentOS, SL, OEL (Best practice is to use the one you intend to use for the node)
    -   At minimum the following from the Development package group should be installed:
        -   Development tools
        -   Additional Development
        -   Server Platform Development
*   An active webserver to host a package repository and the kickstart (EG: An EL6 or Fedora box with httpd loaded and running)

## Building the Needed Packages

*   Some packages need to be built which will work with and are needed for VDSM
*   Some of these packages are not yet in EL6 or out of date for what upstream VDSM requires
*   Tend to stick with newer versions to match upstream VDSM

### Building logrotate

*   Pull the latest logrotate source rpm from the Fedora 17 stable or updates repositories (use the newest)
*   Optionally if you don't mind living on the edge a bit you can pull the newest logrotate source RPM from the Rawhide repositories
*   PackageName: logrotate-<version>.fc<releasever>.src.rpm
*   The following packages are BuildRequires for logrotate
    -   libselinux-devel
    -   popt-devel
    -   libacl-devel
*   To build logrotate:

       rpmbuild --rebuild logrotate-`<version>`.fc`<releasever>`.src.rpm

*   Resulting RPMS:
    -   logrotate-<version>.el6.x86_64.rpm
    -   logrotate-debuginfo-<version>.el6.x86_64.rpm

### Building sanlock

*   Pull the latest sanlock source rpm from the Fedora 17 stable or updates repositories (use the newest)
*   Optionally if you don't mind living on the edge a bit you can pull the newest sanlock source RPM from the Rawhide repositories
*   PackageName: sanlock-<version>.fc<releasever>.src.rpm
*   The following packages are BuildRequires for sanlock
    -   libblkid-devel
    -   libaio-devel
    -   python python-devel
*   To build logrotate:

       rpmbuild --rebuild sanlock-`<version>`.fc`<releasever>`.src.rpm

*   Resulting RPMS:
    -   sanlock-<version>.el6.x86_64.rpm
    -   sanlock-debuginfo-<version>.el6.x86_64.rpm
    -   sanlock-devel-<version>.el6.x86_64.rpm
    -   sanlock-lib-<version>.el6.x86_64.rpm
    -   sanlock-python-<version>.el6.x86_64.rpm

### Building Glusterfs

*   Pull the latest glusterfs source from [Glusterfs LATEST](http://download.gluster.org/pub/gluster/glusterfs/LATEST/)
*   Source is a tar.gz and is named glusterfs-<version>.tar.gz
*   The following packages are BuildRequires for glusterfs
    -   bison
    -   flex
    -   gcc
    -   make
    -   automake
    -   libtool
    -   ncurses-devel
    -   readline-devel
    -   openssl-devel
    -   libxml2-devel
    -   python-ctypes
    -   python-devel
    -   libibverbs-devel
*   To build glusterfs:

       rpmbuild -tb glusterfs-`<version>`.tar.gz

*   Resulting RPMS:
    -   glusterfs-<version>.el6.x86_64.rpm
    -   glusterfs-debuginfo-<version>.el6.x86_64.rpm
    -   glusterfs-devel-<version>.el6.x86_64.rpm
    -   glusterfs-fuse-<version>.el6.x86_64.rpm
    -   glusterfs-geo-replication-<version>.el6.x86_64.rpm
    -   glusterfs-rdma-<version>.el6.x86_64.rpm
    -   glusterfs-server-<version>.el6.x86_64.rpm

### Building VDSM

*   Get the latest VDSM sources from GIT:

` git clone `[`http://gerrit.ovirt.org/p/vdsm`](http://gerrit.ovirt.org/p/vdsm)

*   The following packages are BuildRequires for VDSM
    -   python
    -   python-devel
    -   pyflakes
    -   python-nose
    -   python-pep8
    -   python-ethtool
    -   libvirt-python
    -   sanlock-python >= 2.3
    -   genisoimage
    -   qemu-img (not in the vdsm.spec but seems to be needed by the vdsm-tests)
*   NOTE for the build requirement of sanlock-python you will need to install the following sanlock rpms you built prior:
    -   sanlock-<version>.el6.x86_64.rpm
    -   sanlock-lib-<version>.el6.x86_64.rpm
    -   sanlock-python-<version>.el6.x86_64.rpm
*   Change directory into the resulting vdsm git source tree
*   Do the following to build VDSM

Run autogen.sh

       ./autogen.sh

Run make

       make

Make the rpms

       make rpm

*   Resulting RPMS:
    -   vdsm-<version>.el6.x86_64.rpm
    -   vdsm-debuginfo-<version>.el6.x86_64.rpm
    -   vdsm-python-<version>.el6.x86_64.rpm
    -   vdsm-bootstrap-<version>.el6.noarch.rpm
    -   vdsm-cli-<version>.el6.noarch.rpm
    -   vdsm-debug-plugin-<version>.el6.noarch.rpm
    -   vdsm-gluster-<version>.el6.noarch.rpm
    -   vdsm-hook-faqemu-<version>.el6.noarch.rpm
    -   vdsm-hook-qemucmdline-<version>.el6.noarch.rpm
    -   vdsm-hook-vhostmd-<version>.el6.noarch.rpm
    -   vdsm-reg-<version>.el6.noarch.rpm
    -   vdsm-rest-<version>.el6.noarch.rpm
    -   vdsm-tests-<version>.el6.noarch.rpm
    -   vdsm-xmlrpc-<version>.el6.noarch.rpm

## Deploying the RPMS via a yum repository

### Hosting the repository

*   The easiest way to do this is to load a system with Fedora or EL6 and use an apache webserver to host the repository.
*   Setting up an apache webserver under EL6 is covered in depth here: [Apache HTTP Server](http://access.redhat.com/knowledge/docs/en-US/Red_Hat_Enterprise_Linux/6/html/Deployment_Guide/ch-Web_Servers.html#s1-The_Apache_HTTP_Server)
*   Setting up an apache webserver under FC17 is covered in depth here: [Apache HTTP Server](http://docs.fedoraproject.org/en-US/Fedora/17/html/System_Administrators_Guide/ch-Web_Servers.html#s1-The_Apache_HTTP_Server)

### Creating the repository

*   Create a directory on the webserver at the desired location which will hold the rpms and the repository data.
    -   Example for httpd on EL6:

       mkdir /var/www/html/sl6v

*   Thus given the above location and assuming a webserver FQDN of ovirt.azeroth.net the URL for the repository would be:

<!-- -->

     http://ovirt.azeroth.net/sl6v/

*   You will now need to copy some of the rpms built previously into that hosted directory you created
*   Copy the following RPMS into the directory
    -   logrotate-<version>.el6.x86_64.rpm
    -   sanlock-<version>.el6.x86_64.rpm
    -   sanlock-lib-<version>.el6.x86_64.rpm
    -   sanlock-python-<version>.el6.x86_64.rpm
    -   glusterfs-<version>.el6.x86_64.rpm
    -   glusterfs-fuse-<version>.el6.x86_64.rpm
    -   glusterfs-geo-replication-<version>.el6.x86_64.rpm
    -   glusterfs-rdma-<version>.el6.x86_64.rpm
    -   glusterfs-server-<version>.el6.x86_64.rpm
    -   vdsm-<version>.el6.x86_64.rpm
    -   vdsm-python-<version>.el6.x86_64.rpm
    -   vdsm-cli-<version>.el6.noarch.rpm
    -   vdsm-gluster-<version>.el6.noarch.rpm
    -   vdsm-reg-<version>.el6.noarch.rpm
    -   vdsm-xmlrpc-<version>.el6.noarch.rpm
*   Now we need to turn the directory into a yum repository to do this we will use createrepo
*   If createrepo is not installed on the system install it via:

       yum -y install createrepo

*   Descend into the directory where you just copied the RPMS to and issue the following command:

       createrepo -d .

*   You now have yum repository hosting the needed rpms built prior

## Kickstarting Things

*   The best way to load a system to use as an ovirt VM host is to load it from a kickstart.
*   This allows for the following:
    -   Automates the load and install process
    -   Loads a minimal amount of packages (only what is needed and nothing more)
    -   Reduces the install size and footprint
    -   Saves time loading hosts
    -   Makes it easier to reload hosts
*   Benefits over a stateless host
    -   Can easily load or update drivers or custom 3rd party drivers
    -   Configurations and data can be easily customized
    -   Allows for loading of any additional software/packaged required for whatever reason
    -   Easier to enable/disable services
    -   Easier to enable/disable iptables or selinux
    -   Easier to custom VDSM hooks
    -   Easier to make customizations to networking
    -   Easier to make customizations or changes via core libvirt where needed EG: virsh, libvirt networks, storage, etc
*   Kickstarting the load is best done via:
    -   Booting from the DVD medi
    -   PXE boot and install

### Building the Kickstart

*   Building a kickstart for EL6 is covered more in depth here: [Kickstart Installations](http://access.redhat.com/knowledge/docs/en-US/Red_Hat_Enterprise_Linux/6/html/Installation_Guide/ch-kickstart2.html)
*   Included below is an example kickstart generated for using with Scientfic Linux 6.3

<!-- -->

*   Things you might want to customize in the below kickstart:
    -   Disk partitioning sizes and layout - the below load will wipe the partition tables and lay down a swap and "/" partition only
    -   Enable the firewall if so desired
    -   Enable selinux if so desired
    -   Change the default system language
    -   Change the default system keyboard layout
    -   Change the timezone

<!-- -->

*   Things you do want to change:
    -   The #version=
        -   Below we use SL so we call it SL6V for short for Scientific Linux 6.x Hypervisor
    -   The root password
    -   The repository definition for your distro
        -   Below we are using SL so the repo definition for the base OS looks like:

Example:

     repo --name="Scientific Linux 6.3 - x86_64" --baseurl="http://ftp.scientificlinux.org/linux/scientific/6.3/x86_64/os/" 

*   The repository definition for the additional rpms

Example:

     repo --name="sl6v" --baseurl="http://ovirt.azeroth.net/sl6v/" 

*   The package <distroname>-release
    -   Below we are using SL so it is sl-release change it whatever you are using EG: centos-release or redhat-release
*   Included in the below example kickstart is the package epel-release which SL includes yum repository definitions for [EPEL](http://fedoraproject.org/wiki/EPEL)
    -   SL includes the EPEL repository defintions package
    -   CentOS does not include it
    -   RHEL does not include it
    -   OEL does not include it
*   Thus in the case of the three EL6 distros which do not natively contain the EPEL repository definitions RPM you would need to add that RPM to the yum repository you created prior to hold the extra RPMS built above.
*   The EPEL repository definitions RPM can be found here: [EPEL x86_64 Repo](http://dl.fedoraproject.org/pub/epel/6/x86_64/) and is named: epel-release-<version>.noarch.rpm
*   Alternatively you can choose to remove the epel-release package from the package list in the example kickstart below.

Example EL6 Kickstart to load a minimal ovirt VM host:

    #platform=x86, AMD64, or Intel EM64T
    #version=SL6V
    # Firewall configuration
    firewall --disabled
    # Install OS instead of upgrade
    install
    # Use CDROM installation media
    cdrom
    # Root password
    rootpw --plaintext <your password goes here>
    # System authorization information
    auth  --useshadow  --passalgo=sha512
    # Use text mode install
    text
    # System keyboard
    keyboard us
    # System language
    lang en_US
    # SELinux configuration
    selinux --disabled
    # Do not configure the X Window System
    skipx
    # Installation logging level
    logging --level=info
    # Reboot after installation
    reboot
    # System timezone
    timezone  America/Chicago
    # System bootloader configuration
    bootloader --append="elevator=deadline processor.max_cstate=1" --location=mbr
    # Clear the Master Boot Record
    zerombr
    # Partition clearing information
    clearpart --all --initlabel 
    # Disk partitioning information
    part swap --fstype="swap" --size=4096
    part / --fstype="ext4" --grow --size=1

    repo --name="Scientific Linux 6.3 - x86_64" --baseurl="http://ftp.scientificlinux.org/linux/scientific/6.3/x86_64/os/"
    repo --name="sl6v" --baseurl="http://<url_to_the_server_hosting_your_rpms>/sl6v/"

    %packages --nobase
    @ Core
    ConsoleKit-libs
    MAKEDEV
    PyPAM
    PyXML
    SDL
    acl
    acpid
    aic94xx-firmware
    alsa-lib
    attr
    audit
    audit-libs
    audit-libs-python
    augeas
    augeas-libs
    avahi-libs
    basesystem
    bash
    bc
    bfa-firmware
    bind-libs
    bind-utils
    binutils
    biosdevname
    bridge-utils
    btrfs-progs
    busybox
    bzip2
    bzip2-libs
    ca-certificates
    celt051
    chkconfig
    cim-schema
    coreutils
    coreutils-libs
    cpio
    cracklib
    cracklib-dicts
    cracklib-python
    cronie
    cronie-anacron
    crontabs
    cryptsetup-luks
    cryptsetup-luks-libs
    curl
    cyrus-sasl
    cyrus-sasl-gssapi
    cyrus-sasl-lib
    cyrus-sasl-md5
    dash
    db4
    db4-utils
    dbus
    dbus-glib
    dbus-libs
    dbus-python
    device-mapper
    device-mapper-event
    device-mapper-event-libs
    device-mapper-libs
    device-mapper-multipath
    device-mapper-multipath-libs
    dhclient
    dhcp-common
    diffutils
    dmidecode
    dmraid
    dnsmasq
    dosfstools
    dracut
    dracut-fips
    dracut-kernel
    dracut-network
    e2fsprogs
    e2fsprogs-libs
    ebtables
    efibootmgr
    eggdbus
    eject
    elfutils-libelf
    elfutils-libs
    epel-release
    ethtool
    expat
    fence-agents
    file
    file-libs
    filesystem
    findutils
    fipscheck
    fipscheck-lib
    flac
    fuse
    fuse-libs
    gawk
    gdb
    gdbm
    genisoimage
    glib2
    glibc
    glibc-common
    glusterfs
    glusterfs-fuse
    glusterfs-geo-replication
    glusterfs-rdma
    glusterfs-server
    gmp
    gnutls
    gnutls-utils
    gpgme
    gpxe-roms-qemu
    grep
    groff
    grub
    grubby
    gzip
    hal
    hal-info
    hal-libs
    hivex
    hmaccalc
    hwdata
    info
    initscripts
    ipmitool
    iproute
    iptables
    iptables-ipv6
    iputils
    irqbalance
    iscsi-initiator-utils
    kbd
    kbd-misc
    kernel
    kernel-firmware
    kexec-tools
    keyutils
    keyutils-libs
    kpartx
    krb5-libs
    krb5-workstation
    less
    libICE
    libSM
    libX11
    libX11-common
    libXau
    libXext
    libXi
    libXtst
    libacl
    libaio
    libasyncns
    libattr
    libblkid
    libcap
    libcap-ng
    libcgroup
    libcmpiutil
    libcom_err
    libconfig
    libcurl
    libdrm
    libedit
    libevent
    libffi
    libgcc
    libgcrypt
    libgcrypt-devel
    libgomp
    libgpg-error
    libgpg-error-devel
    libgssglue
    libgudev1
    libguestfs
    libguestfs-tools-c
    libguestfs-winsupport
    libibverbs
    libidn
    libjpeg
    libmlx4
    libnih
    libnl
    libogg
    libpcap
    libpciaccess
    libselinux
    libselinux-python
    libselinux-utils
    libsemanage
    libsepol
    libsndfile
    libss
    libssh2
    libstdc++
    libsysfs
    libtasn1
    libtirpc
    libudev
    libusb
    libusb1
    libuser
    libuser-python
    libutempter
    libuuid
    libvirt
    libvirt-cim
    libvirt-client
    libvirt-lock-sanlock
    libvirt-python
    libvorbis
    libxcb
    libxml2
    libxml2-python
    libxslt
    lm_sensors-libs
    logrotate
    lsof
    lsscsi
    ltrace
    lua
    lvm2
    lvm2-libs
    lzo
    lzop
    m2crypto
    m4
    man
    mdadm
    mesa-libGLU
    mingetty
    module-init-tools
    nc
    ncurses
    ncurses-base
    ncurses-libs
    net-snmp
    net-snmp-libs
    net-snmp-utils
    net-tools
    netcf-libs
    newt
    newt-python
    nfs-utils
    nfs-utils-lib
    nspr
    nss
    nss-softokn
    nss-softokn-freebl
    nss-sysinit
    nss-tools
    nss-util
    ntp
    ntpdate
    numactl
    numad
    openldap
    openssh
    openssh-clients
    openssh-server
    openssl
    pam
    parted
    passwd
    patch
    pciutils
    pciutils-libs
    pcre
    perl-libs
    pexpect
    pinentry
    pixman
    pkgconfig
    plymouth
    plymouth-core-libs
    plymouth-scripts
    policycoreutils
    policycoreutils-python
    polkit
    popt
    procps
    psmisc
    pth
    pulseaudio-libs
    pyOpenSSL
    pygobject2
    pygpgme
    pyparted
    python
    python-decorator
    python-dmidecode
    python-ethtool
    python-gudev
    python-hivex
    python-iniparse
    python-libguestfs
    python-libs
    python-pycurl
    python-setuptools
    python-simplejson
    python-suds
    python-urlgrabber
    python-virtinst
    qemu-img
    qemu-kvm
    qemu-kvm-tools
    ql2100-firmware
    ql2200-firmware
    ql23xx-firmware
    ql2400-firmware
    ql2500-firmware
    radvd
    readline
    redhat-logos
    rootfiles
    rpcbind
    rpm
    rpm-libs
    rpm-python
    rsync
    rsyslog
    sanlock
    sanlock-lib
    sanlock-python
    sblim-sfcb
    scrub
    seabios
    sed
    selinux-policy
    selinux-policy-targeted
    setools-console
    setup
    sg3_utils
    sg3_utils-libs
    sgabios-bin
    shadow-utils
    slang
    sl-release
    sos
    spice-server
    sqlite
    strace
    sudo
    sysfsutils
    sysstat
    system-config-keyboard-base
    systemtap-runtime
    sysvinit-tools
    tar
    tcp_wrappers-libs
    tcpdump
    telnet
    traceroute
    tree
    tzdata
    udev
    unzip
    upstart
    usbredir
    usbutils
    ustr
    util-linux-ng
    vconfig
    vgabios
    vim-minimal
    virt-what
    virt-who
    wget
    which
    xz
    xz-libs
    xz-lzma-compat
    yajl
    zlib
    -NetworkManager
    %end

### Booting and installing via DVD

### Booting and installing via PXE

## Setting up the Host

### Configure Networking

### Bring things up to date

### Add yum repository containing the extra rpms

## Adding the Host to Ovirt

### Disable un-needed services

### Enable needed services

### Configure SSH

### Install VDSM

### Configure VDSM

### Configure VDSM-reg

### Add the host
