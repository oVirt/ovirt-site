---
title: Vdsm for PPC64
category: vdsm
authors: bpradipt, danken, gustavo.pedrosa, lbianc, sandrobonazzola, vitordelima
feature_name: VDSM for PPC64
feature_modules: VDSM
feature_status: Released
---

# Vdsm for PPC64

## Summary

This feature provides support for managing KVM on IBM POWER processors via oVirt.

Qemu and Libvirt support for KVM on IBM POWER processors is already available and is part of the respective upstream versions of the packages

All POWER Linux distributions (RHEL 6.x, SLES 11.x, Debian 6.x, Fedora 16+) that support Power7 native mode are supported as KVM guests. This limits older distributions, such as SUSE 10 and RHEL 5.x

## Original Owners

*   Feature owner: Pradipta Kr. Banerjee <bpradip@in.ibm.com>
    -   REST Component owner: Ricardo Marin Matinata <rmm@br.ibm.com>
    -   Engine Component owner: Ricardo Marin Matinata <rmm@br.ibm.com>
    -   VDSM Component owner: Pradipta Kr. Banerjee <bpradip@in.ibm.com>
    -   QA Owner: Li AG Zhang <zhlbj@cn.ibm.com>
    -   Developers: Leonardo Bianconi <leonardo.bianconi@eldorado.org.br>; Vitor de Lima <vitor.lima@eldorado.org.br>; Gustavo Frederico Temple Pedrosa <gustavo.pedrosa@eldorado.org.br>

## Current Status

*   Status: Merged

## Detailed Description

This feature will introduce the capability of managing KVM on IBM POWER processors via oVirt. Administrators will be able to perform management fuctionalities like:

*   Add/Activate KVM on IBM POWER host
*   Create cluster of KVM on IBM POWER hosts
*   Perform VM lifecycle management on any IBM POWER host
    -   create
    -   start
    -   stop
    -   edit
    -   remove
    -   pause
    -   migrate

Migrate is still work in progress for KVM on IBM POWER processor

### Approach

Managing KVM on IBM POWER processors requires changes to both vdsm and ovirt-engine. However the intent is to keep ovirt-engine changes to the minimum

Following are the key changes that will be required

*   Enhancing the bootstrapping mechanism in VDSM to handle IBM POWER processor and ppc64 specifics (like cpuid, cpu speed, cpu flags)
*   Adding a new CPU type (IBM POWER) to ovirt-engine
*   Enhancing the VM templates based on guest device models (disk, network, video) supported by KVM on IBM POWER

KVM on IBM POWER supports the following device models for guest

*   VirtIO-SCSI, virt-io, spapr-vscsi for disk
*   virt-io, e1000, rtl and spapr-vlan for network
*   vga device is supported for guest video
*   Only VNC backend is supported for guest console access.

There is currently no support for SPICE protocol and USB support in guests.

Both NFS and SAN storage is supported for the hosts. iSCSI support is currently work in progress

### User Interface

No new user interfaces are required to be added. However few of the existing interfaces needs to be updated to reflect KVM on IBM POWER related specifics.

At the minimum following user interfaces will be affected

*   New Server/New Desktop Virtual Machine in userportal
*   New Server/New Desktop Virtual Machine in webadmin
*   Make Template in userportal and webadmin
*   Editing Virtual Disks and Editing Network Interfaces in webadmin
*   New Cluster in webadmin

## Installing VDSM in a ppc64 host

*   Install Fedora Core 20 in your host

<!-- -->

*   Update your Fedora

<!-- -->

    yum update

*   Build and install RPMs for recent versions of python-cpopen, libvirt, libvirt-python and QEMU

<!-- -->

    yum install fedpkg

    mkdir ~/srpms

    cd ~/srpms
    fedpkg co -a qemu
    cd qemu
    fedpkg srpm
    yum-builddep *.src.rpm
    rpmbuild --rebuild *.src.rpm

    cd ~/srpms
    fedpkg co -a libvirt
    cd libvirt
    fedpkg srpm
    yum-builddep *.src.rpm
    rpmbuild --rebuild *.src.rpm

    cd ~/srpms
    fedpkg co -a libvirt-python
    cd libvirt-python
    fedpkg srpm
    yum-builddep *.src.rpm
    rpmbuild --rebuild *.src.rpm

    cd ~/srpms
    fedpkg co -a python-cpopen
    cd python-cpopen
    fedpkg srpm
    yum-builddep *.src.rpm
    rpmbuild --rebuild *.src.rpm

    cd ~/srpms
    fedpkg co -a seabios
    cd seabios
    fedpkg srpm
    yum-builddep *.src.rpm
    rpmbuild --rebuild *.src.rpm

    cd ~/rpmbuild/RPMS/noarch
    yum install *
    cd ~/rpmbuild/RPMS/ppc64
    yum install *

*   Replace your POWER7 optimized glibc for the generic ppc64 package (this is a workaround for [this](https://bugzilla.redhat.com/show_bug.cgi?id=1059428) bug: ):

<!-- -->

    rpm -e --nodeps --justdb glibc.ppc64p7
    yum install glibc.ppc64

*   Install libguestfs and glusterfs from the Fedora updates repository, this can be done automatically using yum or manually, using the following commands:

<!-- -->

    wget http://mirrors.kernel.org/fedora-secondary/updates/20/ppc64/libguestfs-1.24.6-1.fc20.ppc64.rpm http://mirrors.kernel.org/fedora-secondary/updates/20/ppc64/libguestfs-tools-c-1.24.6-1.fc20.ppc64.rpm
    yum install libguestfs-1.24.6-1.fc20.ppc64.rpm
    yum install libguestfs-tools-c-1.24.6-1.fc20.ppc64.rpm

    wget http://mirrors.kernel.org/fedora-secondary/updates/20/ppc64/glusterfs-3.4.2-1.fc20.ppc64.rpm http://mirrors.kernel.org/fedora-secondary/updates/20/ppc64/glusterfs-api-3.4.2-1.fc20.ppc64.rpm http://mirrors.kernel.org/fedora-secondary/updates/20/ppc64/glusterfs-api-devel-3.4.2-1.fc20.ppc64.rpm http://mirrors.kernel.org/fedora-secondary/updates/20/ppc64/glusterfs-cli-3.4.2-1.fc20.ppc64.rpm http://mirrors.kernel.org/fedora-secondary/updates/20/ppc64/glusterfs-devel-3.4.2-1.fc20.ppc64.rpm http://mirrors.kernel.org/fedora-secondary/updates/20/ppc64/glusterfs-fuse-3.4.2-1.fc20.ppc64.rpm http://mirrors.kernel.org/fedora-secondary/updates/20/ppc64/glusterfs-geo-replication-3.4.2-1.fc20.ppc64.rpm http://mirrors.kernel.org/fedora-secondary/updates/20/ppc64/glusterfs-libs-3.4.2-1.fc20.ppc64.rpm http://mirrors.kernel.org/fedora-secondary/updates/20/ppc64/glusterfs-rdma-3.4.2-1.fc20.ppc64.rpm http://mirrors.kernel.org/fedora-secondary/updates/20/ppc64/glusterfs-resource-agents-3.4.2-1.fc20.noarch.rpm http://mirrors.kernel.org/fedora-secondary/updates/20/ppc64/glusterfs-server-3.4.2-1.fc20.ppc64.rpm

    yum install glusterfs-*

*   Clone VDSM from the git repository, install its build dependencies, create and install RPMs

<!-- -->

    yum install gcc rpm-build dosfstools psmisc libnl libselinux-python genisoimage openssl m2crypto python python-devel python-nose python-netaddr python-ethtool python-inotify python-pthreading python-dmidecode python-argparse python-ordereddict python-ethtool python-ioprocess autoconf automake gettext-devel libtool pyflakes python-pep8 systemd-units

    cd ~/
    git clone "https://gerrit.ovirt.org/vdsm"
    cd vdsm
    git checkout ovirt-3.4
    ./autogen.sh
    make NOSE_EXCLUDE=testMirroring\|testMirroringWithDistraction\|testReplacePrio\|test_.*aligned_image\|testStressTest rpm

    cd ~/rpmbuild/RPMS
    yum install noarch/vdsm* ppc64/vdsm*

*   Configure the bridge Interface:

[Installing VDSM from rpm#Configuring the bridge Interface](/develop/developer-guide/vdsm/installing-vdsm-from-rpm.html#configuring-the-bridge-interface)

*   Configure and start VDSM

<!-- -->

    vdsm-tool configure --force
    service vdsmd start

## Testing the PPC64 support

You can follow these steps to test the PPC64 support using the QEMU emulated mode in either x86-64 or ppc64 hosts:

*   Install the faqemu VDSM hook

<!-- -->

*   Create the directory '/etc/ovirt-host-deploy.conf.d'

<!-- -->

*   Create the '/etc/ovirt-host-deploy.conf.d/50-fake.conf' file with the following contents:

<!-- -->

    [environment:enforce]
    VDSM/checkVirtHardware=bool:False
    VDSM/configOverride=bool:False

*   Create the file '/etc/ovirt-host-deploy.conf.d/50-development.conf' file with the following contents:

<!-- -->

    [environment:enforce]
    VDSM/configOverride=bool:False

*   Enable the fake mode in the /etc/vdsm/vdsm.conf file:

<!-- -->

    fake_kvm_support = true
    fake_kvm_architecture = ppc64

*   Execute the command to restart VDSM:

systemctl restart vdsmd.service

## Benefits to oVirt

oVirt would be able to support KVM running on IBM POWER processor based systems

## Dependencies / Related Features and Projects

Affected oVirt projects:

*   Engine-core
*   VDSM

## Documentation / External references

KVM on IBM POWER : <http://www.linux-kvm.org/images/5/5d/2011-forum-KVM_on_the_IBM_POWER7_Processor.pdf>


## Future Work

## Open Issues

These features are still a work in progress, so won't work yet:

*   [Migration](http://bugzilla.redhat.com/show_bug.cgi?id=1057178)
*   [Suspend](http://bugzilla.redhat.com/show_bug.cgi?id=1070189)
*   [Memory Snapshot](http://bugzilla.redhat.com/show_bug.cgi?id=1061774)

Known limitations:

*   [Support only in the Fedora 20 and onwards](http://bugzilla.redhat.com/show_bug.cgi?id=1057724)
*   [VDSM for ppc64 needs qemu 1.6](http://bugzilla.redhat.com/show_bug.cgi?id=1063799)


