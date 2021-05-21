---
title: Vdsm Functional Tests
category: vdsm
authors:
  - mei liu
  - zhshzhou
---

VDSM functional tests are to test the basic features on an actual running VDSM instance. It should covers the most frequently used APIs and common tasks, for example create storage domain, pool, image, volume and generate VM. The functional tests code is place under tests/functional sub-directory, and is installed to /usr/share/vdsm/tests/functional .

# Running Functional Tests

*   Build and install VDSM RPMs including vdsm-tests
*   Start vdsmd service
*   Setup prerequisites

Some of tests assume the prerequisites are already setup, other tests setup and tear down those prerequisites themselves. See the detailed information for each test bellow to setup the prerequisites.

*   Execute the following commands

<!-- -->

    cd /usr/share/vdsm/tests
    ./run_tests.sh [options] functional/*.py

The **options** are passed to nose. If you want to skip some tests, use NOSE_EXCLUDE environment variable or --ignore-files option. You can man nosetests to see what variables and options are available. The functional tests invoke XML-RPC APIs via TLS, so the user running the tests must have the authority to access VDSM certificates. Some tests also setup iSCSI LUNs and NFS exports for VDSM, so in most cases, the user running the tests should be root.

# MOM Tests

MOM is started by VDSM automaticly. Its tests are implemented in momTests.py, it's for testing interaction MOM with VDSM.

## Setting up prerequisites

To run MOM tests, we have to install MOM RPMs first.

## KSM tests

mom.conf must include KSM and HostKSM in controllers and host collectors respectively. KSM test can be run directly with sudo command.

## Balloon tests

mom.conf must include Balloon in controllers, and HostMemory and GuestBalloon in guest collectors. For this test, you can reference <http://gerrit.ovirt.org/#/c/13156/>. This test requires at least one running vm. Note that the vm should be equipped with active ovirt-guest-agent service before the tests since GuestMemory is by default in the config file.

# SOS Plugin Tests

The tests are implemented in sosPluginTests.py .

## Setting Up Prerequisites

Not needed

# XML-RPC Tests

The tests are implemented in xmlrpcTests.py . It invokes VDSM APIs through the XML-RPC binding. It covers creation and destruction of iSCSI/LocalFS/GlusterFS/NFS([Under Review](http://gerrit.ovirt.org/#/c/13105/)) storage domain, pool, image and volume. It also creates and shutdown VMs with and without storage.

## Setting Up Prerequisites

### iSCSI storage tests

Install the latest python-rtslib and Linux kernel. The python-rtslib is for the tests to configure iSCSI LUNs. A latest Linux kernel providing LIO iSCSI target feature is needed as well.

### LocalFS storage tests

Not needed.

### GlusterFS storage tests

*   Install the latest GlusterFS RPMs.

You can download the .repo file to /etc/yum.repos.d from the [GlusterFS official site](https://download.gluster.org/pub/gluster/glusterfs/).

*   Start glusterd system service
*   Setup testing volume

Prepare the backend

<!-- -->

    mkdir /testGlusterBrick && chmod 777 /testGlusterBrick

Start gluster shell by running the command **gluster**

<!-- -->

    gluster> volume create testvol YOUR_HOST_NAME:/testGlusterBrick
    gluster> volume start testvol
    gluster> volume set testvol server.allow-insecure on

*   Edit /etc/glusterfs/glusterd.vol

Add "option rpc-auth-allow-insecure on" and save.

### NFS storage tests

Start nfs-server system service.

### VM related tests

VM functional tests boot virtual machine using host kernel and initramfs, so we should authorize the QEMU process to read our kernel image and initramfs. This can be done by the following command.

    chmod a+r /boot/vmlinuz-* /boot/initramfs-*

