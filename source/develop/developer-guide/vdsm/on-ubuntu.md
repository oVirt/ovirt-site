---
title: VDSM on Ubuntu
category: vdsm
authors: danken, zhshzhou
---

# VDSM on Ubuntu

This page describes Ubuntu imcompabilities that must be fixed to run VDSM.
With the workaround, it is possible to build VDSM on Ubuntu and run some functional tests.
The last section presents a code repository containing the modified VDSM to be run on Ubuntu.
This is a working VDSM snapshot with the following workarounds.
If you are interested, please pick a workaround and create long term solution patch for it, then paste the Gerrit link beside the workdaround.

Targeted Ubuntu Version: **Ubuntu Server 12.10**

## Dependency deb Packages

*   For accessing the git repo

git git-email git-completion git-review git-man git-doc

*   For Packaging

autoconf automake genisoimage gcc gdb make libtool libguestfs-tools policycoreutils sasl2-bin sysv-rc

*   Python related

python-parted python-nose pep8 pyflakes python-libvirt python-dev python-ethtool python-pip python-m2crypto python-selinux python-rpm python-libguestfs

*   Security

selinux-utils

*   Other dependencies

fence-agents ntp iproute nfs-server nfs-client lvm2 e2fsprogs open-iscsi psmisc bridge-utils dosfstools glusterfs-client glusterfs-common multipath-tools libsanlock-dev sanlock qemu-kvm-spice qemu-kvm qemu-utils gnutls-bin python-rtslib

**Workaround**: install them manually through apt-get

### Dependency Problems

*   Missing dependencies

mom sos policycoreutils-python vhostmd

**Workaround**: ignore or skip the related feature.

*   python-pthreading is not available through apt-get

**Workaround**: use pip to install it.

*   sanlock-python is not available through neither apit-get nor pip

**Workaround**: compile and install sanlock from the source. GCC 4.7 requires all link flags comes after source file names, should adjust the Makefile in the sanlock git to avoid symbol not defined error. Firstly install Ubuntu's sanlock and libsanlock-dev to get the init files, then compile and install sanlock from source but do not install the init files. The init files in the sanlock source is not compatible with Ubuntu.

*   /usr/lib/libvirt/lock-driver/sanlock.so is not available

**Workaround**: disable sanlock in qemu.conf of libvirt

*   python-rtslib is not fresh enough

**Workaround**: install python-rtslib from pip

## Failed Unit Tests

*   Exception in ssl test

M2Crypto API differs between versions. Ubuntu and Fedora have different versions of M2Crypto .

**Workaround**: Modify M2Crypto related VDSM code of the SSL wrapper and add the missing API adapter

*   AlignmentScanTests.test_aligned_image and AlignmentScanTests.test_nonaligned_image fails with the same error

libguestfs is not in vdsm dependency, after installing it, should run update-guestfs-appliance

The libguestfs-test-tool fails as well, the default path of guest appliance is wrong

**Workaround**: ln -s /usr/lib/guestfs /usr/lib/x86_64-linux-gnu/guestfs

*   AlignmentScanTests sometimes cause the CPU stuck

**Workaround**: Ubuntu should provide new kernel version with better nested KVM support. Now just skip the test.

*   testMethodMissingMethod

**Workaround**: Fail in both Fedora and Ubuntu, just skip it

## Packaging

*   chkconfig is not in 12.10. It's called in vdsmd and the post installation script in rpm.

**Workaround**: use update-rc.d or sysv-rc-conf, but they do not respect the runlevel and start sequence in the chkconfig header. So the start sequence must be defined manually when adding a service.

*   Different Service names

| Fedora     | Ubuntu          |
|------------|-----------------|
| libvirtd   | libvirt-bin     |
| iscsid     | open-iscsi      |
| multipathd | multipath-tools |
| ntpd       | ntp             |
| network    | networking      |

**Workaround**: edit vdsmd.init to change the service name

*   Ubuntu has no /etc/init.d/functions, should use /lib/lsb/init-functions in the init scripts.

**Workaround**: edit vdsmd.init to change the service name

*   /etc/init.d/functions v.s. /lib/lsb/init-functions

Fedora has daemon util function definition in /etc/init.d/functions, Ubuntu has start_daemon, the options are different, no equivalent to --user option in Fedora.

If we can not define the running user, vdsm main programme will detect it and exit immediately

**Workaround**: use /usr/sbin/sudo -u vdsm to start respawn in the init script instead of start respawn directly

The killproc() function in /etc/init.d/functions supports "-d delay" option, /lib/lsb/init-functions does not.

**Workaround**: delete "-d" option from all invocation of killproc() in vdsmd.init.in.

*   Some functions namely "success" and "failure" do not exist in /lib/lsb/init-functions

**Workaround**: write empty "success" and "failure" functions in vdsmd.init.

## File System Hierachy

| Fedora                                  | Ubuntu                                               | **Workaround**                                                                                         |
|-----------------------------------------|------------------------------------------------------|--------------------------------------------------------------------------------------------------------|
| /sbin/nologin                           | /usr/sbin/nologin                                    | change the path in the code and script                                                                 |
| /sbin/service                           | /usr/sbin/service                                    | change the path in the code and script                                                                 |
| /var/lock/subsys/                       | /var/lock/                                           | change the path in the code and script                                                                 |
| /etc/sysconfig/libvirtd                 | /etc/default/libvirt-bin                             | change the path in the code and script                                                                 |
| /usr/lib/udev/scsi_id                  | /lib/udev/scsi_id                                   | change the path in the code and script [Patch](http://gerrit.ovirt.org/#/c/13086/)                     |
| /sys/class/cpuid/                       | equivalent not found                                 | change the code to use os.sysconf('SC_NPROCESSORS_ONLN') [Patch](http://gerrit.ovirt.org/#/c/12815/) |
| /etc/iscsi/initiatorname.iscsi 644      | same file but permission is 600, vdsm cannot read it | chmod in the installation script                                                                       |
| /boot/initramfs-kernelVer.img           | /boot/initrd.img-kernelVer                           | change the path in the code and script                                                                 |
| /var/lib/libvirt/qemu/channels vdsm:kvm | owner is root:root                                   | chmod in the installation script                                                                       |

*   User and Group

Fedora qemu process started by libvirt is qemu:qemu

Ubuntu qemu process started by libvirt is libvirt-qemu:kvm, and there is no group name qemu, only group kvm

**Workaround**: some code and scripts are changed to use the path and group in Ubuntu.

[Patch](http://gerrit.ovirt.org/12915)

*   Ubuntu does not mount configfs by default.

**Workaround**: configfs is used by LIO target, LIO target is used by iSCSI functional test, the user should mount the filesystem manually mount -t configfs configfs /sys/kernel/config/ .Now I modprobe the iscsi target module and mount configfs in run_tests.sh.in .

## Differences of the Underlying Tools

*   Ubuntu uses apparmor not selinux by default, apparmor prevents qemu from binding unix socket, and maybe prevent other things that affect vdsm.

**Workaround**: disable apparmor in the install script

*   No --copy option in Ubuntu sed

**Workaround**: delete this option in the script

*   bug in Ubuntu kill, parsing kill -9 -xxx will go wrong

**Workaround**: must use kill -9 -- -xxx

[Patch](http://gerrit.ovirt.org/#/c/12817/)

*   udev problem

There is a 85-lvm2.rules under Ubuntu /lib/udev/rules.d/, it sets the owner group of LV to "disk', preventing VDSM from chown-ing, reading, writing the LV. VDSM will chown the LV in the code and 12-vdsm-lvm.rules does this as well. However 85-lvm2.rules are run after 12-vdsm-lvm.rules, so the owner is always set by 85-lvm2.rules "root:disk" finally. In Fedora, there is no such 85-lvm2.rules, so there is no such problem.

**Workaround**:rename 12-vdsm-lvm.rules to 86-vdsm-lvm.rules, so that VDSM udev rules run after the default lvm rules.

[Patch](http://gerrit.ovirt.org/#/c/12816/)

## upstart vs. systemd

As <https://wiki.ubuntu.com/systemd> says, systemd is very incompatible with upstart, we should create upstart jobs for vdsm. We should not run systemd within or instead of upstart. since upstats can run traditional sysv services, we can use vdsdm.init directly, just with some necessary modifications

DK: it would be highly advises to break the nasty SysV service to something smaller, that makes calls to vdsm-tool commands. Then, a port to upstart could become much simpler.

## Existing Effort

*   [oVirt build on debian/ubuntu](/develop/developer-guide/ubuntu.html)
*   [Porting oVirt](/develop/developer-guide/porting-ovirt.html)

## Code

Most of the workarounds needs to modify the source code and scripts. The modified VDSM source code is as follow. After resolve the dependencies manually as mentioned in the first section of this WIKI, you can clone the code, and run ./ubuntuInstall.sh to build, run unit tests and install VDSM. After the installation you can use "service vdsmd start" to start VDSM daemon.

To run functional tests, cd to /usr/share/vdsm/tests and ./run_tests.sh functional/xmlrpcTests.py . Currently we can run VM creation tests with iSCSI and LOCALFS storage.

<https://github.com/edwardbadboy/vdsm-ubuntu>

Contact: zhshzhou AT linux DOT vnet DOT ibm DOT com

