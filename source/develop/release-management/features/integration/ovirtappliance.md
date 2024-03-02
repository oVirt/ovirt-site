---
title: oVirtAppliance
category: feature
authors:
  - didi
  - doron
  - fabiand
  - mgoldboi
  - obasan
---

# oVirt Appliance

## Summary

oVirt appliance will be a raw disk or an ova file that you can import to your existing virtual machine manager and boot it with a complete pre installed oVirt setup.

The first step will be to create an image with the correct functionality, in a second step the correct delivery format will be choosen. The latter might be currently blocked by the missing functionality in the build tools.

## Owner

*   Name: Fabian Deutsch (fabiand)
*   Email: fabiand@redhat.com
*   Tracker <https://bugzilla.redhat.com/show_bug.cgi?id=1053435>
*   GitHub: <https://github.com/oVirt/ovirt-appliance>

## Current status

Builds are stable and based on latest packages.

Availability:

*  master nightly builds: <https://resources.ovirt.org/repos/ovirt/github-ci/ovirt-appliance/>


## Details

*   The appliance will be created using the [livemedia-creator](https://fedorahosted.org/lorax/) - later probably using [image-factory](http://imgfac.org/).
    -   Reasoning behind this is, that these tools are maintained and support different platforms.
*   The platform will be either Fedora or CentOS.
    -   Fedora for now.
*   Configuration
    -   Engine installed and partially preconfigured

Current limitations:

*   It's not built using livemedia-creator, sysprep'ed and sparsify'ed because libvirt is not working nicely on jenkins

## Use / Test

Prerequisites:

*   FQDN which can be resolved on your local network

To use the appliance proceed as follows:

1.  Download [the ovirt appliance rpmfile above](#current-status)
2.  On a RPM based Linux system you can simply install the RPM and you'll find the OVA under /usr/share/ovirt-engine-appliance/  **OR**
3.  Use rpm2cpio to extract the file. Such as:
```
        [gocallag@rrr-meep-1 ~]$ rpm2cpio ovirt-engine-appliance-4.5-20240131072037.1.el9.x86_64.rpm | cpio -imdv
        ./etc/ovirt-hosted-engine/10-appliance.conf
        ./usr/share/doc/ovirt-engine-appliance
        ./usr/share/doc/ovirt-engine-appliance/ovirt-engine-appliance-manifest-rpm
        ./usr/share/ovirt-engine-appliance
        ./usr/share/ovirt-engine-appliance/ovirt-engine-appliance-4.5-20240131072037.1.el9.ova
        3116974 blocks
```
4.  Deploy the OVA as normal
5.  When the OVA is booted
    1.  When the assistant comes up, set a root password
    2.  Login as root
    3.  Start the Engine configuration using: `engine-setup --offline --config-append=ovirt-engine-answers`
    4.  Answer the remaining questions, **take care to use a FQDN which is resolvable on your network**

