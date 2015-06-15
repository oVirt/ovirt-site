---
title: Using EL6 hosts with Ovirt
authors: deadhorseconsulting, sandrobonazzola
wiki_title: Using EL6 hosts with Ovirt
wiki_revision_count: 16
wiki_last_updated: 2014-09-26
---

# Using EL6 hosts with Ovirt

<big>**WARNING: THIS PAGE REFERS TO OBSOLETE AND UNSUPPORTED VERSIONS OF OVIRT. IGNORE THIS PAGE IF YOU'RE INSTALLING A CURRENT RELEASE**</big>

How to use EL6 based hosts with Ovirt-Engine 3.1+

## Assumptions and Prerequisities

<big>**WARNING: THIS PAGE REFERS TO OBSOLETE AND UNSUPPORTED VERSIONS OF OVIRT. IGNORE THIS PAGE IF YOU'RE INSTALLING A CURRENT RELEASE**</big>

*   An installed and running instance of ovirt-engine See: [Installing_ovirt-engine_from_rpm](Installing_ovirt-engine_from_rpm)
*   You will need to do the following on the system running your ovirt-engine to make it handle EL6 nodes instead of Fedora nodes:

For ovirt-engine 3.0

       psql -U postgres -d engine -c "update vdc_options set option_value='rhel6.2.0' where option_name='EmulatedMachine' and version='3.0';"

For ovirt-engine 3.1

       psql -U postgres -d engine -c "update vdc_options set option_value='rhel6.3.0' where option_name='EmulatedMachine' and version='3.1';"

*   A system or VM loaded with some flavor of EL6 EG: RHEL, CentOS, SL, OEL (Best practice is to use the one you intend to use for the node)
    -   At minimum the following from the Development package group should be installed:
        -   Development tools
        -   Additional Development
        -   Server Platform Development
*   An active webserver to host a package repository and the kickstart (EG: An EL6 or Fedora box with httpd loaded and running)
*   **At this point in time getting an EL6 host to work and play nicely with ovirt-engine is not trivial**

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
    repo --name="your-repo-name" --baseurl="http://<url_to_the_server_hosting_your_rpms>/therpms/"

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

### Hosting the Kickstart

*   We can also use the same apache webserver we created for hosting the extra RPMS built prior to host the kickstart
*   Create another directory on the webserver to hold the kickstart:

Example for httpd on EL6:

       mkdir /var/www/html/ks

*   Copy the kickstart file to the newly created directory

Example using sl6v.ks as the name of the kickstart file

       cp sl6v.ks /var/www/html/ks/

*   Thus given the above location and assuming a webserver FQDN of ovirt.azeroth.net the URL for the kickstart would be:

<!-- -->

    http://ovirt.azeroth.net/ks/sl6v.ks

*   This remotely accessible Kickstart can now be fed into a DVD or PXE install

### Booting and installing via DVD

*   Booting and installing from the DVD media is the simplest method which works easily with most modern servers via their respective remote DVD media redirection capabilties:
    -   Sun Oracle ILOM
    -   Dell DRAC
    -   HP ILO
*   EL6 Kickstart options are covered in depth here: [Starting a Kickstart Installation](http://access.redhat.com/knowledge/docs/en-US/Red_Hat_Enterprise_Linux/6/html/Installation_Guide/s1-kickstart2-startinginstall.html)
*   Assuming one of the above server media redirection methods attach the ISO of your choosen EL6 flavor to the remote re-direction console/media re-direct method.
*   Boot the server and choose to boot from the redirected media
*   Once at the initial grub boot menu of the install media highlight the "Install or upgrade an existing system " choice (this is the default in the case of all the EL6 distros)
*   Hit the tab key
*   Using the above URL to the kickstart you created and copied to your webserver add the following boot option

<!-- -->

     ks=http://url-to-your-webserver/kickstart-directory/name-of-you-kickstart-file

*   Next we need to tell it which network card to activate DHCP on and use to communicate on the network
*   Assuming the cable is plugged into the servers first ethernet port and that port will be "eth0" add the following boot option

       ksdevice=eth0

*   Hit enter to start the install
*   If all goes well anaconda will find the kickstart and begin the automated install

### Booting and installing via PXE

*   Setting up PXE boot and install under EL6 is covered in depth here: [Setting Up an Installation Server](http://access.redhat.com/knowledge/docs/en-US/Red_Hat_Enterprise_Linux/6/html/Installation_Guide/ap-install-server.html)
*   Setting up PXE boot and install under Fedora is covered in depth here: [Manually configure a PXE server](http://docs.fedoraproject.org/en-US/Fedora/17/html/Installation_Guide/sn-pxe-server-manual.html)
*   EL6 Kickstart options are covered in depth here: [Starting a Kickstart Installation](http://access.redhat.com/knowledge/docs/en-US/Red_Hat_Enterprise_Linux/6/html/Installation_Guide/s1-kickstart2-startinginstall.html)
*   Assuming a PXE boot and install server has been setup per the above documentation
*   Assuming that a copy of your respective distro's pxeboot "vmlinuz" has been copied to a directory in /var/lib/tftpboot/ called "boot" EG: /var/lib/tftpboot/boot
*   Assuming that a copy of your respective distro's pxeboot "initrd" has been copied to a directory in /var/lib/tftpboot/ called "boot" EG: /var/lib/tftpboot/boot
*   Edit /var/lib/tftpboot/pxelinux.cfg/default and add the following:

<!-- -->

      label somelabel-goes-here
      kernel boot/vmlinuz
      append ks initrd=boot/initrd.img ramdisk_size=100000 ksdevice=eth0  repo=http://url-to-your-distros-base-install/ ks=http://url-to-your-webserver/kickstart-directory/name-of-you-kickstart-file

*   Given the above example eth0 is assumed as the ethernet port on the server which has an active link to the network

Where you are specifying that you copied the installation media or mirrored the install data for your choosen distro to:

     repo=http://url-to-your-distros-base-install 

Example Using SL:

    http://ftp.scientificlinux.org/linux/scientific/6.3/x86_64/os/

Where you specified that you copied the kickstart file created above:

    ks=http://url-to-your-webserver/kickstart-directory/name-of-you-kickstart-file

Example using the above kickstart:

    http://ovirt.azeroth.net/ks/sl6v.ks

*   Assuming all the configuration is correct boot your server via PXE
    -   Usually F12 in most modern servers
    -   OR Set the servers bootdev/order via the respective remote management method (ILOM, DRAC, ILO)
    -   OR set the chassis bootdev to PXE via ipmitool to the respective remote BMC (ILOM, DRAC)
*   If all is well with the configuration the server will obtain an IP address from the ISC DHCP server you configured prior as part of the PXE server configuration
*   Once booted to the PXE server menu (assuming you have configured a menu, see EL6/Fedora documentation on this topic) type whatever label name you choose and hit return.
*   Alternatively you could have configured the PXE server to automatically kicked into your choosen label name (see EL6/Fedora documentation on this topic).
*   If all goes well the server will find the base repo fire up anaconda which will find the kickstart and begin the automated install

## Setting up the Host

*   Provided all went well and you now have a cleanly loaded host via kickstart the system will now need some configuration.

### Configure Networking

*   Need to configure networking on the system by editing/creating the following files
*   Below example configurations use:
*   A system named orgrimmar.azeroth.net (FQDN)
*   Uses eth0 and the according assigned physical ethernet port to talk to the ovirt-engine
*   Uses the IP/mask 192.168.1.1/24
*   Uses a default Gateway of 192.168.1.254
*   Uses the DNS domain of azeroth.net
*   Uses a DNS server at 192.168.1.100 for name resolution
*   Substitute your own values for the parameters in the below examples

Edit: /etc/hosts

       127.0.0.1     localhost localhost.localdomain localhost4 localhost4.localdomain4
       ::1           localhost6 localhost6.localdomain6
       192.168.1.1    durotar durotar.azeroth.net

Edit: /etc/resolv.conf

       search azeroth.net
       domain azeroth.net
       nameserver 192.168.1.100

Edit: /etc/sysconfig/network

       NETWORKING=yes
       NETWORKING_IPV6=no
       HOSTNAME=durotar.azeroth.net
       GATEWAY=192.168.1.254

Edit /etc/sysconfig/network-scripts/ifcfg-eth0

       DEVICE=eth0
` HWADDR=`<HW MAC Address of eth0>
       ONBOOT=yes
       BOOTPROTO=none
       IPV6INIT=no
       BRIDGE=ovirtmgmt
       PEERDNS=no

Create: /etc/sysconfig/network-scripts/ifcfg-ovirtmgmt

       DEVICE=ovirtmgmt
       ONBOOT=yes
       BOOTPROTO=none
       IPV6INIT=no
       TYPE=Bridge
       STP=off
       DELAY=0
       IPADDR=192.168.1.1
       PREFIX=24
       PEERDNS=no

*   Once networking is configured restart the network service

       service network restart

### Configure NTP

*   NTP needs to be configured and the host should talk to the same NTP server as the ovirt-engine which manages it.
*   The ovirt-engine and nodes need to be in sync with each other time wise
*   Also the ntpd service is required to be configured and running by VDSM
*   We use the example ntp server address of 192.168.101
*   Again substitute your own value for ntp server address

Edit: /etc/ntp.conf

       driftfile /var/lib/ntp/drift
       includefile /etc/ntp/crypto/pw
       keys /etc/ntp/keys
       server 192.168.1.101

### Optional Configurations

*   Change the ISCSI initiator name

Edit: /etc/iscsi/initiatorname.iscsi

       InitiatorName=iqn.2012-08.net.azeroth:durotar

*   Perhaps more depending on how much you want to customize/modify

### Add yum repository containing the extra rpms

*   We need to add a repository definition for the repo containing the extra rpms built prior
*   Uses the same values for the repo definition you defined in the kickstart
*   create a file in /etc/yum.repos.d/<your-repo-name>.repo

Example using the same examples in the above kickstart:

    [your-repo-name]
    name=your-repo-name
    baseurl=http://<url_to_the_server_hosting_your_rpms>/therpms/
    enabled=1
    gpgcheck=0

Actual Example with values (substitute in your own values):

    [sl6v]
    name=Scientific Linux 6.3 Hypervisor
    baseurl=http://ovirt.azeroth.net/sl6v/
    enabled=1
    gpgcheck=0

### Bring things up to date

*   You will want to bring things up to date updates wise
*   In SL ensure both the security and fastbugs yum repositories are enabled
    -   in /etc/yum.repos.d/sl.repo both "sl" and "sl-security" should be enabled (EG: enabled=1 for both)
    -   in /etc/yum.repos.d/sl-other sl-fastbugs should be enabled (EG: enabled=1)
*   In CentOS both the base and updates repositories should be enabled
    -   The CentOS fasttrack should also be enabled in /etc/yum.repos.d/CentOS-fasttrack.repo (EG: enabled=1)
*   In OEL ensure that ol6_latest and ol6_UEK_latest are enabled
    -   in /etc/public-yum-ol6-.repo ol6_latest and ol6_UEK_latest should be enabled (EG: enabled=1 for both)
*   In RHEL the sytem should be subscribed and able to talk to RHN
*   Once the you ensure the proper yum repositories are enabled update the system via yum

       yum -y update

*   Once the system is updated, reboot it
*   The system is now ready for assimilation into your ovirt-engine collective

## Adding the Host to Ovirt

*   Assuming system has now been updated and configured

### Disable un-needed services

*   Disable some services which will not be needed or will conflict:
*   libvirt-guests

       chkconfig libvirt-guests off

*   glusterd
*   Currently used by Fedora hosts but with this setup could be used by your EL6 hosts too

       chkconfig glusterd off 

### Optional services to enable/disable

*   Firewall can be optionally enabled or disabled
*   If it is enabled ports will need to be opened for SSH and VDSM (EG: 22 and 54321)

Enable the firewall:

       chkconfig iptables on
       chkconfig ip6tables on

Disable the firewall:

       chkconfig iptables off
       chkconfig ip6tables off

*   Enable or disable kernel core dumping

Enable kdump:

       chkconfig kdump on

Disable kdump:

       chkconfig kdump off

*   Any other services you may want enabled or disabled

### Enable needed services

*   ntpd
*   iscsi
*   mutltipathd
*   Check the following services they should already be enabled and running
    -   libvirtd
    -   sanlock
    -   sshd
    -   wdmd

### Configure SSH

*   Currently the deployutil.py in vdsm-bootstrap and vdsm-reg either fails to:
    -   Copy the engine's SSH RSA key to EL6 based hosts authorized_keys file to EL6 based hosts authorized_keys file
    -   Improperly copies the engines SSH RSA key to EL6 based hosts authorized_keys file to EL6 based hosts authorized_keys file
    -   Or the deployutil.py getAuthKeysFile() function outright fails to run altogether when dealing with EL6 based hosts
*   Given the prior we can simply do the needful manually assuming we will be using vdsm-reg to add the host
*   ssh to the host from the ovirt-engine server and create the file /root/.ssh/authorized_keys
*   copy the contents of the file /etc/pki/ovirt-engine/keys/engine.ssh.key.txt to the file you just created on the host

Example;

       mkdir /root/.ssh
       cat engine.ssh.key.txt >> /root/.ssh/authorized_keys

*   If adding the host via vds_bootstrap.py one can also just comment out the codeblock in the file (since we copied the key manually):

       if not oDeploy.setSSHAccess(iurl, engine_ssh_key):
       logging.error('setSSHAccess test failed')
       return False

### Install VDSM

*   Now you will need to install the VDSM rpms from your extra RPMS repository
*   Ensure you added (per the above) the repository definition for the repository you created which contains the VDSM RPMS you built and placed there previously

Install the neccesary VDSM RPMS:

       yum -y install vdsm vdsm-python vdsm-cli vdsm-gluster vdsm-reg vdsm-xmlrpc

*   If this fails something is not right in your setup and you will want to trace back a few steps
*   Once the VDSM RPMS are installed you will want to turn off the vdsm-reg service (we will be manually invoking it)

       chkconfig vdsm-reg off

### Configure VDSM

*   Now that VDSM in installed we need to create a configuration for it
*   VDSM stores it's configuration file in /etc/vdsm/

Create: /etc/vdsm/vdsm.conf and add the following content to the file:

       [vars]
       trust_store_path = /usr/local/etc/pki/vdsm
       ssl = true
       [addresses]
       management_port = 54321

### Configure VDSM-reg

*   We will use vdsm-reg to assimilate the host into your ovirt-engine collective
*   We need to edit the configuration file for vdsm-reg stored in /etc/vdsm-reg/vdsm-reg.conf
*   In the below example configuration uses an ovirt-engine instance named ovirt.azeroth.net (FQDN)
*   You will need to substitute the FQDN of your ovirt-engine instance

Edit: /etc/vdsm-reg/vdsm-reg.conf

    [vars]
    reg_req_interval = 5
    vdsm_conf_file=/etc/vdsm/vdsm.conf
    pidfile=/var/run/vdsm-reg.pid
    logger_conf=/etc/vdsm-reg/logger.conf
    vdc_host_name=ovirt.azeroth.net
    vdc_host_port=443
    vdc_reg_uri=/OvirtEngineWeb/register
    #upgrade_iso_file=/data/updates/ovirt-node-image.iso
    #upgrade_mount_point=/live
    ticket=

*   Now that the ssh, vdsm, and vdsm-reg configurations are in place it's time to notify the ovirt-engine about our host

Start the vdsm-reg service

       service vdsm-reg start

*   The vdsm-reg service will stop once it has successfully registered the host with your ovirt-engine instance
*   If registration was successful with your ovirt-engine instance you will see the host listed in the ovirt webadmin portal hosts tab and pending approval

### Approve the host

*   Now that the host is registered go to the hosts tab in the ovirt webadmin portal
*   Click on the host and click approve
*   A dialog will pop up where you can configure
    -   Choose a data center to assign the host to
    -   Choose a cluster to assign the host to
    -   Change or modify the name that ovirt refers to the host as
    -   power management options (Note must have at least one other active host to do this)
    -   the SPM priority of the host
*   If the host addition is successful the status of the host will change to "Up"
*   If all was successful the log entries should look something like:

       `<date>`, `<time>` Host cluster Horde was updated by system 
       `<date>`, `<time>` Detected new Host orgrimmar Host state was set to Up. 
       `<date>`, `<time>` Host orgrimmar was successfully approved. 
       `<date>`, `<time>` Installing Host orgrimmar Step: RHEV_INSTALL. 
       `<date>`, `<time>` Installing Host orgrimmar Step: Restart; Details: Restarting vdsmd service. 
       `<date>`, `<time>` Installing Host orgrimmar Step: VDS Configuration. 
       `<date>`, `<time>` Installing Host orgrimmar Step: cleanAll. 
       `<date>`, `<time>` Installing Host orgrimmar Step: CoreDump. 
       `<date>`, `<time>` Installing Host orgrimmar Step: instCert. 
       `<date>`, `<time>` Installing Host orgrimmar Step: RHEV_INSTALL. 
       `<date>`, `<time>` Installing Host orgrimmar Step: Encryption setup. 
       `<date>`, `<time>` Installing Host orgrimmar Step: RHEV_INSTALL; Details: Connected to Host 192.168.1.1 with SSH key fingerprint: `<the SSH fingerprint>`. 
       `<date>`, `<time>` orgrimmar.azeroth.net parameters were updated by admin@internal. 
       `<date>`, `<time>` Power Management is not configured for Host orgrimmar 
       `<date>`, `<time>` Host orgrimmar.azeroth.net  registered. 
       `<date>`, `<time>` Host orgrimmar.azeroth.net  was added by UserName. 
       `<date>`, `<time>` Power Management is not configured for Host orgrimmar.azeroth.net

*   After the approval and registration some junk from the failed ssh key exchange issues will be left in the authorized_keys file of the :

Usually looks like this:

    <!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML 2.0//EN">
    <html><head>
    <title>400 Bad Request</title>
    </head><body>
    <h1>Bad Request</h1>
    <p>Your browser sent a request that this server could not understand.<br />
    Reason: You're speaking plain HTTP to an SSL-enabled server port.<br />
    Instead use the HTTPS scheme to access this URL, please.<br />
    <blockquote>Hint: <a href="https://ovirt.azeroth.net/"><b>https://ovirt.azeroth.net/</b></a></blockquote></p>
    <hr>
    <address>Apache/2.2.22 (Fedora) Server at ovirt.azeroth.net Port 443</address>
    </body></html>

*   Delete the everything but the engine's SSH RSA key that you copied in previously in the hosts authorized_keys file
