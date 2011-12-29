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

The purpose of test days initiative is to accomplish the following goals.

*   Get multiple engineers and stakeholders within the organization to have hands on opportunity to learn more about RHEV 3.0 functionality and new features.
*   While learning the product, the stakeholders can come with their own test cases, defined in the categories
    -   General
    -   Storage
    -   Networking
    -   APIs
    -   Spice
    -   Configuration of the test plan and setup

## Participants

Test Days are open to anyone. If you have your own setup we will provide all the software packages and the required information. Please refer - What to do as a participant - in the section below.

## Test Dates

The overall test dates are spread across multiple duration which are driven by the beta releases from the engineering. The following are the list of test days scheduled -

*   JAN 14th, 2011 - First Beta Release

## Summary of Test Days Results

| Test Day | No. Registered Participants | total bugs | bugs list |
|----------|-----------------------------|------------|-----------|
| 14JAN    |                             |            |           |

## Execution Plan and Guidelines

The following is the list of categories where we would like you to focus with the defined scope, however the scope is not limited and they are just guidelines only, please feel free to extend it to the limitations of the software.

### General

You need two to three physical servers to install and configure a basic RHEV 3.0 environment with shared storage to exercise the following:

*   Setup rhev manager using either Active Directory or Local IPA, two hosts configured as hypervisor ( either RHEL or RHEV-H ) with power management

(Storage Domains - Data Domain / ISO Domain and Export Domain

*   Use ISO Uploader to populate images of 3-4 OS and tools
*   Basic Network Configuration
*   Create virtual machines and assign them to users
*   Migrate VM's between the hypervisors
*   Collect log file using the log collector tool.

### Configuration

*   configure high availability for virtual machines which are running mission critical workloads, so they will be restarted another host if hardware failure occurs
*   multi-level administration system to assign different levels of user permissions, which is ideal for a company with diverse employee roles
*   Live Migration Scenarios

### Storage

| Scenario                                                                               | Bugs |
|----------------------------------------------------------------------------------------|------|
| Use the General configuration as a base config                                         |      |
| Create 3 types of storage domains (NFS, ISCSI, FC) with 2 or more data domains         |      |
| Install at least 2 VMs on each of the DataCenters                                      |      |
| Try moving the master domain to a different domain within the DataCenter               |      |
| Try exporting one of the installed VMs, delete it, and import it to another DataCenter |      |
| Create a template from one of the VMs and then create a new VM from this template      |      |

             Move the newly created VM to another data domain
             Create several snapshots from a VM (Each time change something in the guest)
             Try to restore an old snapshot
             Storage Failovers
             Host Failovers
             Power User Portal provides instructions to create and manage virtual machines from the power user portal
             High Availability scenarios provides instructions to configure virtual machine and host high availability
             provide instructions on creating an additional data center with Red Hat Enterprise Linux hosts.

         Network 

             Base config - single NIC, bridge on top, VMs attached to NIC
             Advanced configurations:

vlan_bonding.png make sure each of the configs can

         survive a reboot

         test network at both host and VM level
         ping and transfer large amounts of data (2Gb size files should be enough)
         remain operational over time (1hr of uptime should be sufficient for the basic testing)

         Spice
             Follow the General configuration
             Install Windows VM and a Linux VM with Guest Tools
             Assign user to these vms, login to a user portal, from your client machine,  and connect to it using the Spice protocol
             Try to watch a clip via YouTube  or any other web based video
             Try to watch a Local movie
             Install AutoCAD or any other graphic application a try to work with it.

RHEV 3.0 Information Details

         Please refer the following document for hardware requirements,  installation procedure, software download location 

           RHEV 3 Internal Beta - use the external beta now:

         Please refer the following documents for RHEV 3.0 Installation guide, bits location, admin guide
`   `[`http://documentation-stage.bne.redhat.com/docs/en-US/Red_Hat_Enterprise_Virtualization/3.0/html/Installation_Guide/index.html`](http://documentation-stage.bne.redhat.com/docs/en-US/Red_Hat_Enterprise_Virtualization/3.0/html/Installation_Guide/index.html)
`   `[`https://access.redhat.com/discussion/who-able-access-beta-releases-and-where-are-they-located`](https://access.redhat.com/discussion/who-able-access-beta-releases-and-where-are-they-located)
`   `[`http://documentation-stage.bne.redhat.com/docs/en-US/Red_Hat_Enterprise_Virtualization/3.0/html/Administration_Guide/index.html`](http://documentation-stage.bne.redhat.com/docs/en-US/Red_Hat_Enterprise_Virtualization/3.0/html/Administration_Guide/index.html)
         The test reports and test cases for RHEV 3.0 are reported in the following location.   If you are creating any new test or new configuration, please refer the test results from QE Engineering for RHEV 3.0 to avoid duplication of tests. 

`       `[`https://tcms.lab.tlv.redhat.com`](https://tcms.lab.tlv.redhat.com)

         In case you would like to test a product with a new test case, there is a template to be used for creating test cases. Please copy this template for the test case, and update the link in this document to point to the results table below.  It is not necessary that the person who is writing the test case will also be the person executing the test case,  please  make sure the instructions are  explicit enough that anyone who may want to participate in the test day  can follow them, and execute it.
         GSS RHEV 3.0 tracking bug: #731146.

What to do as a participant

         If you already have the hardware, verify if it meets the hardware requirement, refer information detail section below
         If you do not have the hardware and would like to participate, please select the hardware available ( refer allocated hardware section below )
         Update the  Participants section in First Test Day Execution and Report document.  If you are using the lab resources, please update the IP addresses and duration to avoid overallocation.
         Accomplish the goals set in objective section ,  run the tests,  update the test matrix.
         Running into any issues - contact any participant in the list -  First Test Execution and Report maintains the list automatically when you sign up
         ping iirc channels #sbr-virt,  as an alternative - send an email to rhev-beta list.

Allocated Hardware by Site

         Raleigh - Five complete setups

<https://docspace.corp.redhat.com/docs/DOC-84598>

         Pune
             RHEV 3 Testfest in Pune
             RHEV 3 TestFest Pune : Buglist

         Farnborough, UK

         GSS Lab - EMEA RHEV 3.0 Beta 1 environment

         See Tim Walsh

         LATAM
`       `[`https://docspace.corp.redhat.com/docs/DOC-75799`](https://docspace.corp.redhat.com/docs/DOC-75799)

         All Others
             You can also reserve servers using beaker for hypervisor/host usage GSSLAB: Searching Beaker

Site based Test Days Results

         Raleigh
`       `[`https://docspace.corp.redhat.com/docs/DOC-84599`](https://docspace.corp.redhat.com/docs/DOC-84599)
         Pune
             RHEV 3 TestFest Pune : Buglist

         Farnborough, UK
             Lee Yarwood -  Please update the results
         Brisbane
             See Tim Walsh  - Please update the link with the results. 
         LATAM
`       `[`https://docspace.corp.redhat.com/docs/DOC-75799`](https://docspace.corp.redhat.com/docs/DOC-75799)

Miscellaneous

Test Days Status updates Date Status Comments and Action Items 7/29/11 Closed Hardware Readiness Meeting Minutes for Test Days. 8/8/11 WIP First Test Day Execution and Report 8/10/11 WIP Test Days Status - Weekly Meeting Minutes
