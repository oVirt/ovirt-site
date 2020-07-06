---
title: oVirtTestDay3.1
authors: aglitke, gcheresh, jhernand, mburns, mkolesni, rmiddle, rvaknin, snmishra,
  ykaul
---

# oVirt Test Day 3.1

## Objective

The purpose of test days initiative is to accomplish the following goals:

*   Get multiple engineers and stakeholders to have hands-on opportunity to learn more about Ovirt functionality and features.
*   Improve the quality of oVirt, towards its second release (aka '3.1')
*   While learning about the project, the stakeholders can come with their own test cases, in different categories:
    -   General/Project installation
    -   Storage
    -   Networking
    -   APIs, SDK, CLI
    -   Spice
    -   User Interface
    -   Tools

## Participants

Test Days are open to anyone. If you have your own setup we will provide all the software packages and the required information. Please refer - What to do as a participant - in the section below, if you're willing to participate please add yourself to the below table:

| Name     | General | Storage | Networking | APIs | Spice | User Interface | Tools | Distribution |
|----------|---------|---------|------------|------|-------|----------------|-------|--------------|
| snmishra | V       |         | Basic      |      |       | V              |       | RHEL 6.2     |
| rvaknin  |         |         |            | SDK  |       | V              |       | Fedora 16    |
| mkolesni |         |         | Advanced   |      |       |                |       | Fedora 17    |
| gcheresh |         |         | Basic      |      |       | V              |       | Fedora 17    |
| rmiddle  | V       |         | Basic      |      |       | V              |       | Fedora 17    |

## Test Dates

The overall test dates are spread across multiple duration which are driven by the beta releases from the engineering. The following are the list of test days scheduled -

*   JAN 18th, 2012 - First Release (3.0)
*   Jun 14th, 2012 - Second Release (3.1)

## Execution Plan and Guidelines

The following is the list of categories which we would like to focus on. However the scope is not limited and they are guidelines only. Feel free to extend it to the limitations of the software.

### General

You need at least two physical servers to install and configure a basic yet complete oVirt environment with shared storage to exercise the following:

| Scenario                                                                                                                                                                                                              | Bugs |
|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------|
| Setup oVirt engine using either Active Directory or Local IPA, two hosts configured as hypervisors (Fedora / Ovirt-Node / other) with power management (Storage Domains - Data Domain / ISO Domain and Export Domain) |      |
| Use ISO Uploader to populate images of OS and tools                                                                                                                                                                   |      |
| Basic Network Configuration                                                                                                                                                                                           |      |
| Create virtual machines and assign them to users                                                                                                                                                                      |      |
| Migrate Virtual Machines between the hypervisors                                                                                                                                                                      |      |
| Collect log file using the log collector tool                                                                                                                                                                         |      |

### Configuration

| Scenario                                                                                                                                                            | Bugs |
|---------------------------------------------------------------------------------------------------------------------------------------------------------------------|------|
| Configure high availability for virtual machines which are running mission critical workloads, so they will be restarted on another host if hardware failure occurs |      |
| Use the multi-level administration feature to assign different levels of user permissions                                                                           |      |
| Live Migration Scenarios                                                                                                                                            |      |

### Storage

| Scenario                                                                                                            | Bugs |
|---------------------------------------------------------------------------------------------------------------------|------|
| Use the General configuration as a base configuration                                                               |      |
| Create different types of storage domains (NFS, ISCSI, FC, local storage) with 2 or more data domains               |      |
| Install at least 2 VMs on each of the Data Centers                                                                  |      |
| Move the master domain to a different domain within the Data Center                                                 |      |
| Export one of the installed VMs, delete it, import it to another Data Center                                        |      |
| Create a template from one of the VMs and then create a new VM based on this template                               |      |
| Move the newly created VM to another data domain                                                                    |      |
| Create several snapshots from a VM (Each time change something in the guest)                                        |      |
| Restore a previous snapshot                                                                                         |      |
| Storage Failovers                                                                                                   |      |
| Host Failovers                                                                                                      |      |
| Power User Portal provides power users the ability to create and manage virtual machines from the power user portal |      |
| High Availability scenarios provides instructions to configure virtual machine and host high availability           |      |

### Network

*   Base config - single NIC, bridge on top, VMs attached to NIC
*   Advanced configurations:

![](/images/wiki/Vlan_bonding.png) make sure each of the configs can:

*   survive a reboot
*   test network at both host and VM level
*   ping and transfer large amounts of data (2Gb size files should be enough)
*   remain operational over time (1hr of uptime should be sufficient for the basic testing)

### APIs

by default we'll be using the webadmin as our API for testing on this section we'll try to have default deployment with the different APIs

| Scenario                       | Webadmin | UserPortal | Rest | Python-SDK | CLI |
|--------------------------------|----------|------------|------|------------|-----|
| Create a data-center           |          |            |      | V          |     |
| Create a cluster               |          |            |      | V          |     |
| Update cluster                 |          |            |      | V          |     |
| Install a host                 |          |            |      | V          |     |
| Create a storage domain on DC  |          |            |      | V          |     |
| Attach export/ISO domain to DC |          |            |      | V          |     |
| Create vm                      |          |            |      | V          |     |
| Delete vm                      |          |            |      | V          |     |
| Import vm                      |          |            |      | V          |     |
| Start/hibernate/resume/stop vm |          |            |      | V          |     |
| Create a snapshot to vm        |          |            |      | V          |     |
| Create a template from vm      |          |            |      | V          |     |
| Create vm from template        |          |            |      | V          |     |
| Sign out                       |          |            |      | V          |     |
| General                        |          |            |      | V          |     |

Python API of the above scenarios can be found in: [Testing/PythonApi](/develop/api/pythonapi/)

### Spice

For details about configuration check [Testing/Spice](/develop/infra/testing/spice/)

| Scenario                                                                                                               | Bugs |
|------------------------------------------------------------------------------------------------------------------------|------|
| Install Windows VM and a Linux VM with Guest Tools (QXL graphic driver and spice vdagent)                              |      |
| Assign user to these vms, login to a user portal, from your client machine, and connect to it using the Spice protocol |      |
| Try to watch a clip via YouTube or any other web based video (with QXL driver installed on VM)                         |      |
| Try to watch a Local movie (with QXL driver installed on VM)                                                           |      |
| Try to use client mouse mode and clipboard share between client and VM (with spice agent installed on VM)              |      |
| Install AutoCAD or any other graphic application a try to work with it (with QXL driver installed on VM)               |      |

### User Interface

Webadmin: BZ#832046, BZ#832064, BZ#832128

### Node

Pre-built node available [here](/releases/beta/binary/ovirt-node-iso-2.4.0-1.1.fc17.iso).

Please check [Node_Release_Notes](/develop/projects/node/release-notes/) prior to testing for information on current known issues

| Scenario                                                                                                                                                                                                                                                                                                        | Bugs |
|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------|
| Boot image and install using the TUI on a single disk                                                                                                                                                                                                                                                           |      |
| Boot image and install using the TUI on multiple disks                                                                                                                                                                                                                                                          |      |
| Boot image and install using autoinstall parameters from [here](http://docs.redhat.com/docs/en-US/Red_Hat_Enterprise_Linux/6/html/Hypervisor_Deployment_Guide/sect-Deployment_Guide-Installing_Red_Hat_Enterprise_Virtualization_Hypervisors-RHEV_Hypervisor_Kernel_Parameters_and_Automated_Installation.html) |      |
| Configure Networking using the TUI                                                                                                                                                                                                                                                                              |      |
| Configure ssh password auth and attempt to login using ssh                                                                                                                                                                                                                                                      |      |
| Configure remote logging                                                                                                                                                                                                                                                                                        |      |
| Configure kdump                                                                                                                                                                                                                                                                                                 |      |
| Configure iscsi initiator name                                                                                                                                                                                                                                                                                  |      |
| Configure collectd                                                                                                                                                                                                                                                                                              |      |
| Configure oVirt Engine hostname and port                                                                                                                                                                                                                                                                        |      |
| Configure admin password on oVirt Engine screen and add host through ovirt engine                                                                                                                                                                                                                               |      |
| Once registered, run vms on top of ovirt-node                                                                                                                                                                                                                                                                   |      |
|                                                                                                                                                                                                                                                                                                                 |      |

## oVirt Information Details

Beta RPMs for Fedora 17 are available from [here](/releases/beta/fedora/17/). In order to use it create a `/etc/yum.repos.d/ovirt-engine-beta.repo` file with the following content:

    [ovirt-beta]
    name=ovirt-beta
    baseurl=http://ovirt.org/releases/beta/fedora/17
    enabled=1
    skip_if_unavailable=1
    gpgcheck=0

The run `yum install ovirt-engine`.

***Note:** Take into account that if this repository is not configured propertly you will be installing version 3.0 of the engine (it is part of Fedora 17), which is not the subject of this test day.*

Please refer the following documents for more information on hardware requirements, installation procedure and software download locations:

*   [Installing ovirt from rpm](/develop/developer-guide/engine/installing-engine-from-rpm/)
*   [Installing ovirt-node from rpm](/develop/developer-guide/vdsm/installing-vdsm-from-rpm/)

Please refer the following documents for Ovirt Installation guide, bits location and admin guide:

*   [Documentation](/documentation/)

Please refer the following document for 'virt-to-date' tool, simple tool for setting up local yum repo with all required packages and easy deployment.

*   [virt-to-date](/documentation/admin-guide/virt/virt-to-date/)

In case you would like to test a product with a new test case, there is a template to be used for creating test cases. Please copy this template for the test case, and update the link in this document to point to the results table below. It is not necessary that the person who is writing the test case will also be the person executing the test case, please make sure the instructions are explicit enough that anyone who may want to participate in the test day can follow them, and execute it.

## What to do as a participant

*   If you already have the hardware, verify if it meets the hardware requirement, refer information detail section below
*   Update the Participants section.
*   Accomplish the goals set in objective section , run the tests, update the test matrix.
*   Running into any issues - contact any participant in the list

## Bug Reporting

*   ovirt - <https://bugzilla.redhat.com/enter_bug.cgi?classification=oVirt>
*   Spice - <https://bugs.freedesktop.org/> under Spice product
*   VDSM - <https://bugzilla.redhat.com/show_bug.cgi?id=831998>

Track bug for the release - <https://bugzilla.redhat.com/show_bug.cgi?id=822145>

## Miscellaneous

IRC - #ovirt at irc.oftc.net

## Current Issues

*   VM state shown as Non-responsive in UI even though VM is Up according to vdsm
*   [Bug 832158 - ISO List is not refreshed after new ISO is uploaded](https://bugzilla.redhat.com/show_bug.cgi?id=832158)
*   Fixed in ovirt-node-iso-2.4.0-1.0.fc17.iso - ovirt-node-iso network interface config not working. New build expected with a fixed shortly.
*   [Bug 769571 - Console icon doesn't get reenabled when spice console is closed](https://bugzilla.redhat.com/769571)
*   ovirt-node-iso [Bug 832196 - Getting directory not found error.](https://bugzilla.redhat.com/show_bug.cgi?id=832196)
*   [Bug 832199 - vdsmd init script times out due to lengthy semanage operation](https://bugzilla.redhat.com/show_bug.cgi?id=832199)
*   Workaround for sanlock error: "Readonly leases are not supported."
    -   comment out: lock_manager="sanlock" in /etc/libvirt/qemu.conf and restart libvirt and vdsm
