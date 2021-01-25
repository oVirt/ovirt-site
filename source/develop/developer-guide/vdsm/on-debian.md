---
title: VDSM on Debian
category: vdsm
authors: stirabos
---

The aim is this page is tracking the progress to have oVirt managing a Debian based host for virtualizaion purposes.
oVirt require to have an agent on each host, the agent is called VDSM so the first step is to have VDSM running on Debian.

Targeted Debian Version: Debian Jessie (8), is current testing and feature frozen, it should be releases when ready so it's about months.

# VDSM on Debian

The aim is to have VDSM 4.17 on Debian.
Here we have a patch for the packaging work.
<http://gerrit.ovirt.org/#/c/37737/> Currently VDSM is just running on Fedora/RHEL/Centos and derivates.
No positive feedback on other distribution till today.

### Building it

The build command is:

      fakeroot debian/rules binary

The clean up one:

      fakeroot debian/rules binary

### Creating a simple repo for it

To build a simple repo:

      $ mkdir ~/debian
      $ mkdir ~/debian/binary
      $ mkdir ~/debian/source

copy all the .deb to ~/debian/binary than regenerate Packages.gz and Source.gz

      $ cd ~/debian
      $ dpkg-scanpackages binary /dev/null | gzip -9c > binary/Packages.gz
      $ cd ~/debian
      $ dpkg-scansources source /dev/null | gzip -9c > source/Sources.gz

Than add Release files:

      stirabos@debian8t1:~/archive_20150624$ cat ~/debian/binary/Release 
      Archive: unstable
      Component: contrib
      Origin: stirabos
      Label: First attempt to have VDSM on Debian Jessie (still not working)
      Architecture: amd64
      stirabos@debian8t1:~/archive_20150624$ cat ~/debian/source/Release 
      Archive: unstable
      Component: contrib
      Origin: stirabos
      Label: First attempt to have VDSM on Debian Jessie (still not working)
      Architecture: source

Upload it to the destination folder

You can use it adding

      # vdsm 4.17
      deb `[`http://resources.ovirt.org/pub/ovirt-3.6-pre/debian/`](http://resources.ovirt.org/pub/ovirt-3.6-pre/debian/)` binary/

under /etc/apt/sources.list Than $ sudo apt-get update $ sudo apt-get install vdsm to install vdsm

## Dependency Packages

*   python-cpopen - Creates a subprocess in simpler safer manner
    -   Currently not available in Debian
    -   Here we have a patch to package it for Debian <http://gerrit.ovirt.org/#/c/37926/>
    -   Here the corresponding ITP <https://www.mail-archive.com/debian-bugs-dist@lists.debian.org/msg1302660.html>
*   python-pthreading - Reimplement threading.Lock, RLock and Condition with libpthr
    -   Currently not available in Debian
    -   Here we have a patch to package it for Debian <http://gerrit.ovirt.org/#/c/37916/>
    -   Here the corresponding ITP <https://www.mail-archive.com/debian-bugs-dist@lists.debian.org/msg1302710.html>
*   python-ioprocess - Slave process for safe IO on linux
    -   Currently not available in Debian
    -   Here we have a patch to package it for Debian <http://gerrit.ovirt.org/#/c/38074/>
    -   previously packed by evilissimo

## Open Issue

VDSM is relaying on a custom release of M2Crypto python libraries. M2Crypto is an OpenSSL wrapper. Upstream release of M2Crypto is available here: <https://github.com/M2Crypto/M2Crypto/>

Fedora release (and derivate including RHEL and Centos) includes some additional patches, in particular one to properly work with SSL timeouts: [m2crypto-0.21.1-timeouts.patch](http://www.zhangsheng.org/magic/3.0/sources/SOURCES.m/m2crypto/m2crypto-0.21.1-timeouts.patch)
The patch was submitted for upstream but never merged cause not compatible with Windows.

VDSM needs that for SSL communication; an attempt to have a patch to avoid it was done here <http://gerrit.ovirt.org/#/c/37746/> but it was not enough to pass SSL unit tests.

The bug is tracked here: <https://bugzilla.redhat.com/show_bug.cgi?id=1192496>
I asked to the M2Crypto upstream maintainer about the process to have the patch merged but it's quite a long process
and we need to ensure it works on every platform. One possible alternative is repackaging M2Crypto for Debian in a custom
version with the timeout patch requiring it instead of the vanilla one for VDSM. Apply:

1.  [m2crypto-0.21.1-timeouts.patch](http://www.zhangsheng.org/magic/3.0/sources/SOURCES.m/m2crypto/m2crypto-0.21.1-timeouts.patch)
2.  [m2crypto-0.21.1-memoryview.patch](http://www.zhangsheng.org/magic/3.0/sources/SOURCES.m/m2crypto/m2crypto-0.21.1-memoryview.patch)

and rebuilding it starting from <git://anonscm.debian.org/collab-maint/m2crypto>

Applying the two patches seams to be enough to pass most of SSL unit tests. Still an open issue on sslTests.VerifyingTransportTests

To complete some unit tests, VDSM is looking for /etc/pki/vdsm/keys/libvirt_password which of course doesn't exists prior of VDSM installation. Creating that file with the right content seams to be enough to pass that tests.

## Current results

VDSM building process is running 915 unit tests skipping 20 of them and getting errors on 1.

## TODO

*   Successfully pass each unit test on Debian
*   Add CI jobs to keep it nigtly-builded
*   start testing activities of hosts

# Existing Efforts

*   [oVirt build on debian/ubuntu](/develop/developer-guide/ubuntu.html)
*   [Porting oVirt](/develop/developer-guide/porting-ovirt.html)
*   [VDSM_on_Ubuntu](/develop/developer-guide/vdsm/on-ubuntu.html)
