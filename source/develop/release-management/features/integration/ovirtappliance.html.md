---
title: oVirtAppliance
category: feature
authors: didi, doron, fabiand, mgoldboi, obasan
feature_name: oVirt Appliance
feature_modules: node
feature_status: Done
---

# oVirt Appliance

## Summary

oVirt appliance will be a raw disk or an ova file that you can import to your existing virtual machine manager and boot it with a complete pre installed oVirt setup.

The first step will be to create an image with the correct functionality, in a second step the correct delivery format will be choosen. The latter might be currently blocked by the missing functionality in the build tools.

## Owner

*   Name: Fabian Deutsch (fabiand)
*   Email: fabiand@redhat.com
*   Tracker <https://bugzilla.redhat.com/show_bug.cgi?id=1053435>
*   Gitweb: <http://gerrit.ovirt.org/gitweb?p=ovirt-appliance.git>

## Current status

Builds are stable, built daily, and based on latest oVirt 3.6 packages.

The last 3.5 build is still available, and master builds are available too.

Availability:

*   <http://jenkins.ovirt.org/view/All/job/ovirt-appliance-engine_3.5_merged/>
*   <http://jenkins.ovirt.org/view/All/job/ovirt-appliance_ovirt-3.6_build-artifacts-el7-x86_64/>
*   <http://jenkins.ovirt.org/view/All/job/ovirt-appliance_master_build-artifacts-el7-x86_64/>

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

1.  Download [the ova image above](#current-status)
2.  Either use the ova in combination with hosted-engine or extract the ova image
3.  When the image is booted
    1.  When the assistant comes up, set a root password
    2.  Login as root
    3.  Start the Engine configuration using: `engine-setup --offline --config-append=ovirt-engine-answers`
    4.  Answer the remaining questions, **take care to use a FQDN which is resolvable on your network**

