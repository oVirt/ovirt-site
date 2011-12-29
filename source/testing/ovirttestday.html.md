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

| Name     | General | Storage | Networking | APIs         | Spice | User Interface | Tools |
|----------|---------|---------|------------|--------------|-------|----------------|-------|
| mgoldboi | V       | V       | Basic      | Webadmin,CLI | V     |                |       |

## Test Dates

The overall test dates are spread across multiple duration which are driven by the beta releases from the engineering. The following are the list of test days scheduled -

*   JAN 14th, 2011 - First Release

## Summary of Test Days Results

| Test Day | No. Registered Participants | total bugs | bugs list |
|----------|-----------------------------|------------|-----------|
| 14JAN    |                             |            |           |

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

![](vlan_bonding.png "fig:vlan_bonding.png") make sure each of the configs can:

*   survive a reboot
*   test network at both host and VM level
*   ping and transfer large amounts of data (2Gb size files should be enough)
*   remain operational over time (1hr of uptime should be sufficient for the basic testing)

### APIs

by default we'll be using the webadmin as our API for testing on this section we'll try to have default deployment with the different APIs

| Scenario                       | Webadmin | UserPortal | Rest | Python-SDK | CLI |
|--------------------------------|----------|------------|------|------------|-----|
| Create a data-center           |          |            |      |            |     |
| Create a cluster               |          |            |      |            |     |
| Install a host                 |          |            |      |            |     |
| Create a storage domain on DC  |          |            |      |            |     |
| Attach export/ISO domain to DC |          |            |      |            |     |
| Create vm                      |          |            |      |            |     |
| Import vm                      |          |            |      |            |     |
| Start/hibernate/resume/stop vm |          |            |      |            |     |
| Create a snapshot to vm        |          |            |      |            |     |
| Create a template from vm      |          |            |      |            |     |
| Create vm from template        |          |            |      |            |     |

### Spice

Follow the General configuration

| Scenario                                                                                                               | Bugs |
|------------------------------------------------------------------------------------------------------------------------|------|
| Install Windows VM and a Linux VM with Guest Tools                                                                     |      |
| Assign user to these vms, login to a user portal, from your client machine, and connect to it using the Spice protocol |      |
| Try to watch a clip via YouTube or any other web based video                                                           |      |
| Try to watch a Local movie                                                                                             |      |
| Install AutoCAD or any other graphic application a try to work with it                                                 |      |

## Ovirt Information Details

Please refer the following document for hardware requirements, installation procedure, software download location

*   <http://ovirt.org/wiki/Installing_ovirt_from_rpm>
*   <http://ovirt.org/wiki/Installing_ovirt-node_from_rpm>

Please refer the following documents for Ovirt Installation guide, bits location, admin guide

*   <http://ovirt.org/wiki/Documentation>

In case you would like to test a product with a new test case, there is a template to be used for creating test cases. Please copy this template for the test case, and update the link in this document to point to the results table below. It is not necessary that the person who is writing the test case will also be the person executing the test case, please make sure the instructions are explicit enough that anyone who may want to participate in the test day can follow them, and execute it.

## What to do as a participant

*   If you already have the hardware, verify if it meets the hardware requirement, refer information detail section below
*   If you do not have the hardware and would like to participate, please select the hardware available ( refer allocated hardware section below )
*   Update the Participants section in First Test Day Execution and Report document. If you are using the lab resources, please update the IP addresses and duration to avoid overallocation.
*   Accomplish the goals set in objective section , run the tests, update the test matrix.
*   Running into any issues - contact any participant in the list - First Test Execution and Report maintains the list automatically when you sign up
*   ping iirc channels #zzz, as an alternative - send an email to ovirt-zzz list.

## Allocated Hardware by Site

## Site based Test Days Results

## Miscellaneous
