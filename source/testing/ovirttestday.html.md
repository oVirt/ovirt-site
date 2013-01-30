---
title: OvirtTestDay
authors: aglitke, alkaplan, alourie, amureini, anthony liguori, apuimedo, atal, danken,
  dcaroest, didi, dron, gianluca, hateya, jhenner, jlibosva, lhornyak, lvernia, mburns,
  mgoldboi, mkolesni, mkrcmari, moti, msalem, obasan, ofri, pradeep, pstehlik, rvaknin,
  sming, tdosek, tjelinek, wuzhy, ykaul, zvi
wiki_title: Testing/OvirtTestDay
wiki_revision_count: 113
wiki_last_updated: 2013-07-24
---

# Ovirt Test Day

## **oVirt 3.2 test day**

## Objective

The purpose of test days initiative is to accomplish the following goals:

*   Get multiple engineers and stakeholders to have hands-on opportunity to learn more about Ovirt functionality and features.
*   Improve the quality of oVirt, towards its first release.
*   Establish a quality baseline.
*   Introducing and validating new oVirt 3.2 features
*   While learning about the project, the stakeholders can come with their own test cases, in different categories for regression testing:
    -   installation/migration from 3.1
    -   Storage
    -   Networking
    -   interfaces
    -   Spice
    -   User Interface
    -   Tools

in addition participate in exploring [new features](OVirt_3.2_release-management#Features) .

## What to do as a participant

*   If you already have the hardware, verify if it meets the hardware requirement, refer information detail section below
*   Update the Participants section.
*   Accomplish the goals set in objective section , run the tests, update the test matrix.
*   Running into any issues - contact any participant in the list

## Participants

Test Days are open to anyone. If you have your own setup we will provide all the software packages and the required information. Please refer - [What to do as a participant](Testing/OvirtTestDay#What_to_do_as_a_participant) - in the section below, if you're willing to participate please add yourself to the below table:

| Name     | allInOne/distributed/migration from 3.1 | Storage | Networking                                                              | APIs       | Spice | User Interface    | Tools | Distribution |
|----------|-----------------------------------------|---------|-------------------------------------------------------------------------|------------|-------|-------------------|-------|--------------|
| mgoldboi | clean install- AIO                      | NFS     | basic + port mirroring                                                  | python sdk | V     | admin+user-portal |       | Fedora-18    |
| lvernia  | -                                       | NFS     | everything                                                              | -          | -     | webadmin          |       | Fedora-18    |
| danken   | -                                       | NFS     | rollback on setupNet error                                              | -          | -     | webadmin          |       | el6          |
| lhornyak | -                                       | iscsi   | -                                                                       | -          | -     | webadmin          |       | el6          |
| apuimedo | -                                       | NFS     | guest net operation, hotplugging nets and (if possible) live net change | -          | -     | webadmin          |       | el6          |

## Test Dates

The overall test dates are spread across multiple duration which are driven by the beta releases from the engineering. The following are the list of test days scheduled -

*   JAN 18th, 2012 - First Release (3.0)
*   Jun 14th, 2012 - Second Release (3.1)
*   JAN 31th, 2013 - Third Release (3.2)

## Execution Plan and Guidelines

The following is the list of categories which we would like to focus on. this is basically regression testing:

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
| Create several live snapshots from a VM (Each time change something in the guest)                                   |      |
| Restore a previous snapshot                                                                                         |      |
| Live migrate a disk between storage domains                                                                         |      |
| Storage Failovers                                                                                                   |      |
| Host Failovers                                                                                                      |      |
| Power User Portal provides power users the ability to create and manage virtual machines from the power user portal |      |
| High Availability scenarios provides instructions to configure virtual machine and host high availability           |      |

### Network

*   Base config - single NIC, bridge on top, VMs attached to NIC
*   Advanced configurations:

![](Vlan bonding.jpg "fig:Vlan bonding.jpg") make sure each of the configs can:

*   survive a reboot
*   test network at both host and VM level
*   ping and transfer large amounts of data (2Gb size files should be enough)
*   remain operational over time (1hr of uptime should be sufficient for the basic testing)

#### New to v3.1:

*   port mirroring: one can setup a VM that sniffs all IP traffic between VMs on a network on a host.
*   no mac spoofing: VMs cannot emit packets with spoofed mac address (unless specifically allowed to).
*   Sync network: change network MTU (or other property) on host, verify that Engine may overwrite it with Sync network
*   Jumbo packets: see if can be configured and used by storage

#### New to v3.2:

*   Network main tab operational: you can search hosts and VM based on their network connectivity
*   Guest agent reported devices: install guest agent on a VM and see it report internal information of the vNics (internal device name, IPv4 and IPv6)
*   Network Linking: allow changing network the VM is connect to while it is running

### APIs

by default we'll be using the webadmin as our API for testing on this section we'll try to have default deployment with the different APIs

| Scenario                       | Webadmin | UserPortal | Rest | Python-SDK | CLI |
|--------------------------------|----------|------------|------|------------|-----|
| Create a data-center           |          |            |      |            |     |
| Create a cluster               |          |            |      |            |     |
| Update cluster                 |          |            |      |            |     |
| Install a host                 |          |            |      |            |     |
| Create a storage domain on DC  |          |            |      |            |     |
| Attach export/ISO domain to DC |          |            |      |            |     |
| Create vm                      |          |            |      |            |     |
| Delete vm                      |          |            |      |            |     |
| Import vm                      |          |            |      |            |     |
| Start/hibernate/resume/stop vm |          |            |      |            |     |
| Create a snapshot to vm        |          |            |      |            |     |
| Create a template from vm      |          |            |      |            |     |
| Create vm from template        |          |            |      |            |     |
| Sign out                       |          |            |      |            |     |
| General                        |          |            |      |            |     |

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

### User Interface

Webadmin:

### Node

Pre-built node available [here](http://resources.ovirt.org/releases/beta/iso/ovirt-node-iso-2.6.0-201301290835.fc18.iso).

Please check [Node_Release_Notes](Node_Release_Notes) prior to testing for information on current known issues

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

### SLA

| Scenario                                                 | Bugs |
|----------------------------------------------------------|------|
| Set DC Quota enforcement mode to 'Enforced'              |      |
| Create new Quota which limits storage                    |      |
| Create new Quota which limits cpu and memory             |      |
| Define consumers for the quotas                          |      |
| Asign the quotas to VMs and Disks                        |      |
| Run VM with quota                                        |      |
| Move a disk                                              |      |
| Snapshot a vm (disk)                                     |      |
| Stop VM                                                  |      |
| Commit snapshot                                          |      |
| See that quota usage makes sance                         |      |
| Open User Portal                                         |      |
| Log-in as a user defined as quota consumer               |      |
| Create VMs and Disks                                     |      |
| Run VMs                                                  |      |
| Go to resources tab and see that quota usage makes sance |      |

## Ovirt Information Details

Beta RPMs for Fedora 18 are available from <http://resources.ovirt.org/releases/beta/rpm/Fedora/18>. In order to use it create a `/etc/yum.repos.d/ovirt-engine-beta.repo` file with the following content:

    [ovirt-beta]
    name=ovirt-beta
    baseurl=http://resources.ovirt.org/releases/beta/rpm/Fedora/18/
    enabled=1
    skip_if_unavailable=1
    gpgcheck=0

The run `yum install ovirt-engine`.

Please refer the following documents for more information on hardware requirements, installation procedure and software download locations:

*   <http://ovirt.org/wiki/Installing_ovirt_from_rpm>
*   <http://ovirt.org/wiki/Installing_ovirt-node_from_rpm>

Please refer the following documents for Ovirt Installation guide, bits location and admin guide:

*   <http://ovirt.org/wiki/Documentation>

Please refer the following document for 'virt-to-date' tool, simple tool for setting up local yum repo with all required packages and easy deployment.

*   <http://ovirt.org/wiki/virt-to-date>

In case you would like to test a product with a new test case, there is a template to be used for creating test cases. Please copy this template for the test case, and update the link in this document to point to the results table below. It is not necessary that the person who is writing the test case will also be the person executing the test case, please make sure the instructions are explicit enough that anyone who may want to participate in the test day can follow them, and execute it.

## Bug Reporting

*   ovirt - <https://bugzilla.redhat.com/enter_bug.cgi?product=oVirt>
*   Spice - <https://bugs.freedesktop.org/> under Spice product
*   VDSM - <https://bugzilla.redhat.com/show_bug.cgi?id=831998>

Tracker bug for the release - <https://bugzilla.redhat.com/881006>

## Miscellaneous

IRC - #ovirt at irc.oftc.net

## Current Issues
