---
title: oVirtTestDay3.0
authors: mgoldboi
wiki_title: Testing/OvirtTestDay3.0
wiki_revision_count: 2
wiki_last_updated: 2013-01-28
---

# oVirt Test Day 3.0

## Objective

The purpose of test days initiative is to accomplish the following goals:

*   Get multiple engineers and stakeholders to have hands-on opportunity to learn more about Ovirt functionality and features.
*   Improve the quality of oVirt, towards its first release.
*   Establish a quality baseline.
*   While learning about the project, the stakeholders can come with their own test cases, in different categories:
    -   General/Project installation
    -   Storage
    -   Networking
    -   APIs
    -   Spice
    -   User Interface
    -   Tools

## Participants

Test Days are open to anyone. If you have your own setup we will provide all the software packages and the required information. Please refer - What to do as a participant - in the section below, if you're willing to participate please add yourself to the below table:

| Name     | General | Storage | Networking | APIs                    | Spice | User Interface | Tools | Distribution |
|----------|---------|---------|------------|-------------------------|-------|----------------|-------|--------------|
| mgoldboi | V       | V       | Basic      | Webadmin,CLI            | V     |                |       | Fedora16     |
| mkrcmari | V       |         |            |                         | V     |                |       | Fedora16     |
| djasa    | V       | V       | Basic      |                         | V     |                |       | Fedora16     |
| hateya   | V       | V       | Basic      | Webadmin,cli,python SDK | V     |                |       | Fedora16     |
| rvaknin  | V       | V       | Basic      |                         | V     |                |       | Fedora16     |
| atal     | V       | V       | Basic      |                         | V     |                |       | Fedora16     |
| aliguori | V       | V       | Basic      |                         | V     |                |       | Fedora16     |
| sming    | V       | V       | Basic      |                         | V     |                |       | RHEL 6.2     |
| aglitke  | V       | V       | Basic      | Webadmin,CLI,vdsm       | V     | V              |       | Fedora16     |
| Pradeep  | V       | V       | Basic      |                         | V     |                |       | RHEL 6.2     |
| wuzhy    | V       | V       | Basic      |                         | V     |                |       | Fedora16     |
| tdosek   | V       | V       | Basic      | Webadmin, Userportal    |       | V              |       | Fedora16     |
| jlibosva | V       | V       | Basic      | Webadmin                |       | V              | V     | Fedora16     |
| jhenner  |         |         | Basic      | python SDK              |       |                |       | Fedora16     |
| pstehlik | V       |         | Basic      | ActiveDirectory         |       | V              | V     | Fedora16     |
| zvi      | V       | V       | Advanced   | Webadmin                | V     | V              | V     | Fedora16     |
| dron     | V       | V       | Advanced   | Webadmin                | V     | V              | V     | Fedora16     |

## Test Dates

The overall test dates are spread across multiple duration which are driven by the beta releases from the engineering. The following are the list of test days scheduled -

*   JAN 18th, 2012 - First Release

## Summary of Test Days Results

| Test Day | No. Registered Participants | total bugs | bugs list |
|----------|-----------------------------|------------|-----------|
| 18JAN    |                             |            |           |

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

| Scenario                                                                                                            | Bugs                                                                                                                                                                                                                                                                                         |
|---------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Use the General configuration as a base configuration                                                               |                                                                                                                                                                                                                                                                                              |
| Create different types of storage domains (NFS, ISCSI, FC, local storage) with 2 or more data domains               | FAILED in iscsi for following issues -- [782432](https://bugzilla.redhat.com/show_bug.cgi?id=782432) , [781805](https://bugzilla.redhat.com/show_bug.cgi?id=781805) , [782864](https://bugzilla.redhat.com/show_bug.cgi?id=782864) , [1](https://bugzilla.redhat.com/show_bug.cgi?id=783098) |
| Install at least 2 VMs on each of the Data Centers                                                                  |                                                                                                                                                                                                                                                                                              |
| Move the master domain to a different domain within the Data Center                                                 |                                                                                                                                                                                                                                                                                              |
| Export one of the installed VMs, delete it, import it to another Data Center                                        |                                                                                                                                                                                                                                                                                              |
| Create a template from one of the VMs and then create a new VM based on this template                               |                                                                                                                                                                                                                                                                                              |
| Move the newly created VM to another data domain                                                                    |                                                                                                                                                                                                                                                                                              |
| Create several snapshots from a VM (Each time change something in the guest)                                        |                                                                                                                                                                                                                                                                                              |
| Restore a previous snapshot                                                                                         |                                                                                                                                                                                                                                                                                              |
| Storage Failovers                                                                                                   |                                                                                                                                                                                                                                                                                              |
| Host Failovers                                                                                                      |                                                                                                                                                                                                                                                                                              |
| Power User Portal provides power users the ability to create and manage virtual machines from the power user portal |                                                                                                                                                                                                                                                                                              |
| High Availability scenarios provides instructions to configure virtual machine and host high availability           |                                                                                                                                                                                                                                                                                              |

### Network

*   Base config - single NIC, bridge on top, VMs attached to NIC
*   Advanced configurations:

![](Vlan bonding.jpg "fig:Vlan bonding.jpg") make sure each of the configs can:

*   survive a reboot
*   test network at both host and VM level
*   ping and transfer large amounts of data (2Gb size files should be enough)
*   remain operational over time (1hr of uptime should be sufficient for the basic testing)

### APIs

by default we'll be using the webadmin as our API for testing on this section we'll try to have default deployment with the different APIs

| Scenario                       | Webadmin                                                     | UserPortal                                                   | Rest                                                         | Python-SDK                                                   | CLI                                                                                                                       |
|--------------------------------|--------------------------------------------------------------|--------------------------------------------------------------|--------------------------------------------------------------|--------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------|
| Create a data-center           |                                                              |                                                              |                                                              |                                                              |                                                                                                                           |
| Create a cluster               |                                                              |                                                              |                                                              |                                                              | [782713](https://bugzilla.redhat.com/show_bug.cgi?id=782713)                                                              |
| Update cluster                 |                                                              |                                                              |                                                              | [782828](https://bugzilla.redhat.com/show_bug.cgi?id=782828) |                                                                                                                           |
| Install a host                 |                                                              |                                                              | [782737](https://bugzilla.redhat.com/show_bug.cgi?id=782737) |                                                              | [782734](https://bugzilla.redhat.com/show_bug.cgi?id=782734),[782734](https://bugzilla.redhat.com/show_bug.cgi?id=782734) |
| Create a storage domain on DC  |                                                              |                                                              |                                                              |                                                              |                                                                                                                           |
| Attach export/ISO domain to DC |                                                              |                                                              |                                                              |                                                              |                                                                                                                           |
| Create vm                      |                                                              | [782794](https://bugzilla.redhat.com/show_bug.cgi?id=782794) |                                                              |                                                              |                                                                                                                           |
| Delete vm                      |                                                              |                                                              |                                                              | [782830](https://bugzilla.redhat.com/show_bug.cgi?id=782830) |                                                                                                                           |
| Import vm                      | [782717](https://bugzilla.redhat.com/show_bug.cgi?id=782717) |                                                              |                                                              |                                                              |                                                                                                                           |
| Start/hibernate/resume/stop vm |                                                              |                                                              |                                                              |                                                              |                                                                                                                           |
| Create a snapshot to vm        |                                                              |                                                              |                                                              |                                                              |                                                                                                                           |
| Create a template from vm      |                                                              |                                                              |                                                              |                                                              |                                                                                                                           |
| Create vm from template        |                                                              |                                                              |                                                              |                                                              |                                                                                                                           |
| Sign out                       | [782779](https://bugzilla.redhat.com/show_bug.cgi?id=782779) |                                                              |                                                              |                                                              |                                                                                                                           |
| General                        |                                                              |                                                              |                                                              | [782891](https://bugzilla.redhat.com/show_bug.cgi?id=782891) |                                                                                                                           |

Python API of the above scenarios can be found in: <http://www.ovirt.org/wiki/Testing/PythonApi>

### Spice

For details about configuration check <http://www.ovirt.org/wiki/Testing/Spice>

| Scenario                                                                                                               | Bugs |
|------------------------------------------------------------------------------------------------------------------------|------|
| Install Windows VM and a Linux VM with Guest Tools (QXL graphic driver and spice vdagent)                              |      |
| Assign user to these vms, login to a user portal, from your client machine, and connect to it using the Spice protocol |      |
| Try to watch a clip via YouTube or any other web based video (with QXL driver installed on VM)                         |      |
| Try to watch a Local movie (with QXL driver installed on VM)                                                           |      |
| Try to use client mouse mode and clipboard share between client and VM (with spice agent installed on VM)              |      |
| Install AutoCAD or any other graphic application a try to work with it (with QXL driver installed on VM)               |      |

### Node

Pre-built node available [here](http://ovirt.org/releases/nightly/binary/ovirt-node-image-2.2.1-3.6.fc16.iso).

Please check [Node_Release_Notes](Node_Release_Notes) prior to testing for information on current known issues

Apply workaround in [782660](https://bugzilla.redhat.com/show_bug.cgi?id=782660) before attempting to register to ovirt-engine

| Scenario                                                                                                                                                                                                                                                                                                        | Bugs                                                                   |
|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------|
| Boot image and install using the TUI on a single disk                                                                                                                                                                                                                                                           |                                                                        |
| Boot image and install using the TUI on multiple disks                                                                                                                                                                                                                                                          |                                                                        |
| Boot image and install using autoinstall parameters from [here](http://docs.redhat.com/docs/en-US/Red_Hat_Enterprise_Linux/6/html/Hypervisor_Deployment_Guide/sect-Deployment_Guide-Installing_Red_Hat_Enterprise_Virtualization_Hypervisors-RHEV_Hypervisor_Kernel_Parameters_and_Automated_Installation.html) |                                                                        |
| Configure Networking using the TUI                                                                                                                                                                                                                                                                              |                                                                        |
| Configure ssh password auth and attempt to login using ssh                                                                                                                                                                                                                                                      |                                                                        |
| Configure remote logging                                                                                                                                                                                                                                                                                        |                                                                        |
| Configure kdump                                                                                                                                                                                                                                                                                                 |                                                                        |
| Configure iscsi initiator name                                                                                                                                                                                                                                                                                  |                                                                        |
| Configure collectd                                                                                                                                                                                                                                                                                              |                                                                        |
| Configure oVirt Engine hostname and port                                                                                                                                                                                                                                                                        | FAILED -- [782663](https://bugzilla.redhat.com/show_bug.cgi?id=782663) |
| Configure admin password on oVirt Engine screen and add host through ovirt engine                                                                                                                                                                                                                               | FAILED -- [782660](https://bugzilla.redhat.com/show_bug.cgi?id=782660) |
| Once registered, run vms on top of ovirt-node                                                                                                                                                                                                                                                                   |                                                                        |
|                                                                                                                                                                                                                                                                                                                 |                                                                        |

## oVirt Information Details

Please refer the following document for hardware requirements, installation procedure, software download location

*   <http://ovirt.org/wiki/Installing_ovirt_from_rpm>
*   <http://ovirt.org/wiki/Installing_ovirt-node_from_rpm>

Please refer the following documents for Ovirt Installation guide, bits location, admin guide

*   <http://ovirt.org/wiki/Documentation>

Please refer the following document for 'virt-to-date' tool, simple tool for setting up local yum repo with all required packages and easy deployment.

*   <http://ovirt.org/wiki/virt-to-date>

In case you would like to test a product with a new test case, there is a template to be used for creating test cases. Please copy this template for the test case, and update the link in this document to point to the results table below. It is not necessary that the person who is writing the test case will also be the person executing the test case, please make sure the instructions are explicit enough that anyone who may want to participate in the test day can follow them, and execute it.

## What to do as a participant

*   If you already have the hardware, verify if it meets the hardware requirement, refer information detail section below
*   Update the Participants section.
*   Accomplish the goals set in objective section , run the tests, update the test matrix.
*   Running into any issues - contact any participant in the list

## Bug Reporting

*   ovirt - <https://bugzilla.redhat.com/enter_bug.cgi?product=oVirt>
*   Spice - <https://bugs.freedesktop.org/> under Spice product

## Miscellaneous

IRC - #ovirt at irc.oftc.net
