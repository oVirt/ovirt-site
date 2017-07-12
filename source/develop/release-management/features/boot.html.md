---
title: Boot
category: feature
authors: fabiand
feature_name: Boot oVirt.org
feature_modules: appliance
feature_status: WIP
---

# Boot oVirt.org

## Summary

This feature will provide an [ISO](http://jenkins.ovirt.org/fabiand_boo_build_testing/) to install an stable oVirt Engine Appliance or oVirt Node Appliance to a host. The appliances are fetched over the internet from Jenkins.

**Note: This feature will download a lot of data from the internet. Thus the speed of the installation depends on the speed of your internet connection.**

![](/images/wiki/Ipxe-iso-screenshot.png)

## Owner

*   Name: Fabian Deutsch (fabiand)
*   Email: <fabiand@redhat.com>
*   IRC: fabiand

## Detailed Description

This feature is about creating an iPXE based bootloader, pointing to the correct kickstart files in Jenkins.

The relevant files are around:

*   iPXE script (embedded in iPXE bootloader)
*   anaconda kernel, initrd and squashfs
*   kickstart files pointing to the correct oVirt Engine/Node Appliance jobs
*   oVirt Engine and Node Appliance images

## Benefit to oVirt

This is a very simple way to get oVirt up and running. The idea is that a user will get a tested image when he installs oVirt through this feature. The testing of the images is part of the appliance build jobs.

Link to the Jenkins job: <http://jenkins.ovirt.org/fabiand_boo_build_testing/>

## Dependencies / Related Features

*   The appliance jobs need to provide the correct images.
    -   Engine Appliance: <http://jenkins.ovirt.org/job/ovirt-appliance_engine-3.5_master_merged/>
    -   Node Appliance: <http://jenkins.ovirt.org/job/ovirt-appliance_node-3.5_master_merged/>

## Documentation / External references

*   Technical documentation: <https://github.com/fabiand/boot-ovirt/blob/master/README.md>

## Testing

**Note: This feature will download a lot of data from the internet. Thus the speed of the installation depends on the speed of your internet connection.**

To test or use this feature:

1.  Download the [*ovirt-ipxe.iso*](http://jenkins.ovirt.org/user/fabiand/my-views/view/Node/job/fabiand_boo_build_testing/lastSuccessfulBuild/artifact/ovirt-ipxe.iso) or [*ovirt-ipxe.usb*](http://jenkins.ovirt.org/user/fabiand/my-views/view/Node/job/fabiand_boo_build_testing/lastSuccessfulBuild/artifact/ovirt-ipxe.usb)]
2.  Write the ISO or USB media image to an CD-ROM or a USB media or use it in a VM
3.  Boot the host or VM from the ISO or USB media
4.  Select *Engine / Interactive Installation* or *Node / Interactive Installation*
5.  Wait for the installer to come up.
6.  Answer the unanswered questions and click *Begin*
7.  Let the installation start
8.  Set a root password while the installation is running
9.  After the installation completes, the host will reboot
10. Login using *root* and the password you set during the installation
11. **For Engine** - to complete the Engine setup
    1.  Run `engine-setup --config-append=ovirt-engine-answers` to setup engine
    2.  Log into the web ui using *admin* and the password you've set during the `engine-setup`
    3.  Add the Node appliance using the *Add host* menu item on the *Hosts* tab. Use *root* and the password set during the Node appliance installation

## Contingency Plan

None

## Release Notes

      == Boot oVirt.org ==
      An ISO and USB media image is available to provide a simple way to install the oVirt Engine and oVirt Node appliances.



