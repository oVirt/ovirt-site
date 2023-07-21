---
title: oVirt Node
---
# oVirt Node

oVirt Node is a minimal operating system based on CentOS that is designed to provide a simple method for setting up a
physical machine to act as a hypervisor in an oVirt environment. The minimal operating system contains only the packages
required for the machine to act as a hypervisor, and features a Cockpit user interface for monitoring the host and
performing administrative tasks.

Due to this minimalistic approach, oVirt Node NG is not recommended if you need to customize the configuration of
your virtualization hosts with multiple additional packages or third party software.

## Installing oVirt Node

Before you start installing oVirt Node be sure to meet requirements on your virtualization host, see
[Host Requirements](/documentation/installing_ovirt_as_a_self-hosted_engine_using_the_command_line/#host-requirements) in the
[Installing oVirt as a self-hosted engine using the command line](/documentation/installing_ovirt_as_a_self-hosted_engine_using_the_command_line/) guide.

Once ready, see
[oVirt Nodes](/documentation/installing_ovirt_as_a_self-hosted_engine_using_the_command_line/#Red_Hat_Virtualization_Hosts_SHE_cli_deploy) in the
[Installing oVirt as a self-hosted engine using the command line](/documentation/installing_ovirt_as_a_self-hosted_engine_using_the_command_line/)
guide for installation instructions.

> **Note:** CentOS Stream 9 based ISO images are provided as tech preview!

### oVirt Node 4.5 - Stable Release

This is the site hosting oVirt Node 4.5 images including the latest oVirt 4.5 released packages.

* [Released Installation ISO site](https://resources.ovirt.org/pub/ovirt-4.5/iso/ovirt-node-ng-installer/)

### oVirt Node 4.5 - Pre Release

This is the site hosting oVirt Node 4.5 pre release images including the latest oVirt 4.5 pre release packages.

* [Pre-Release Installation ISO site](https://resources.ovirt.org/pub/ovirt-4.5-pre/iso/ovirt-node-ng-installer/)

### oVirt Node Master - Latest master, experimental

This is the oVirt Node image build based on oVirt packages from the master branches.

* [oVirt Node master experimental ISO](https://resources.ovirt.org/repos/ovirt/github-ci/ovirt-node-ng-image/)

-----

## Old releases

The oVirt community developers can't commit to backport fixes to older releases: please consider upgrading to latest stable release as soon as practical.

### oVirt Node 4.4

This is the oVirt Node 4.4 image including the latest oVirt 4.4 packages.

* [Installation ISO (4.4.10 based on el8)](https://resources.ovirt.org/pub/ovirt-4.4/iso/ovirt-node-ng-installer/4.4.10-2022030308/el8/ovirt-node-ng-installer-4.4.10-2022030308.el8.iso)

### oVirt Node 4.3

This is the oVirt Node 4.3 image including the latest oVirt 4.3 packages.

* [Installation ISO (4.3.10 based on el7)](https://resources.ovirt.org/pub/ovirt-4.3/iso/ovirt-node-ng-installer/4.3.10-2020060117/el7/ovirt-node-ng-installer-4.3.10-2020060117.el7.iso)

### oVirt Node 4.2

This is the oVirt Node 4.2 image including the latest oVirt 4.2 packages.

* [Installation ISO](https://resources.ovirt.org/pub/ovirt-4.2/iso/ovirt-node-ng-installer/4.2.0-2019012210.el7/ovirt-node-ng-installer-4.2.0-2019012210.el7.iso)

### oVirt Node 4.1

This is the oVirt Node 4.1 image including the latest oVirt 4.1 packages.

* [Installation ISO](https://resources.ovirt.org/pub/ovirt-4.1/iso/ovirt-node-ng-installer-ovirt/4.1-2018012411/ovirt-node-ng-installer-ovirt-4.1-2018012411.iso)
