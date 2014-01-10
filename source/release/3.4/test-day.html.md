---
title: OVirt 3.4 Test Day
authors: amureini, apuimedo, awels, bproffitt, danken, doron, ecohen, eedri, emesika,
  fabiand, fromani, gchaplik, jmoskovc, mperina, msivak, netbulae, rnori, sandrobonazzola,
  yair zaslavsky, ybronhei
wiki_title: OVirt 3.4 Test Day
wiki_revision_count: 77
wiki_last_updated: 2014-03-27
---

# OVirt 3.4 Test Day

**This page is still a DRAFT**

### Objective

*   engage project users and stakeholders to a hands-on experiences with oVirt new release.
*   improve the quality of oVirt.
*   Introduce and validating new oVirt 3.4 features

### What I should do

*   If you already have the hardware, verify if it meets the hardware requirement, refer information detail section below
*   Update the Participants section.
*   Go ahead and [ install ovirt ](oVirt_3.4_TestDay#Installation_notes)
*   Accomplish the goals set in objective section , run the tests, update the test matrix.
*   Running into any issues? [ Try to get answer ](Community) or [open a BZ](https://bugzilla.redhat.com/enter_bug.cgi?product=oVirt) ticket.

<!-- -->

*   Make sure you have either a Fedora 19 or CentOS 6.5 machine installed.
*   Install the release pkg:

`(f19) sudo yum localinstall `[`http://resources.ovirt.org/releases/ovirt-release-fedora.noarch.rpm`](http://resources.ovirt.org/releases/ovirt-release-fedora.noarch.rpm)
`(el) sudo yum localinstall `[`http://resources.ovirt.org/releases/ovirt-release-el.noarch.rpm`](http://resources.ovirt.org/releases/ovirt-release-el.noarch.rpm)

*   Make sure to enable the [ovirt-beta] & [ovirt-stable] repos and disable the [ovirt-nightly] repo.
*   If you're using CentOS, make sure you have epel repo enabled as well:

      [epel]
      name=Extra Packages for Enterprise Linux 6 - $basearch
      mirrorlist=`[`https://mirrors.fedoraproject.org/metalink?repo=epel-6&arch`](https://mirrors.fedoraproject.org/metalink?repo=epel-6&arch)`=$basearch
      enabled=1
      gpgcheck=0

*   install & run setup

      sudo yum install -y ovirt-engine
      sudo engine-setup

*   for more info, checkout [install oVirt](Download)

#### Known issues

### oVirt 3.4 New Features - Test Status Table

TBD

### Regression testing

#### General

You need at least two physical servers to install and configure a basic yet complete oVirt environment with shared storage to exercise the following:

| Scenario                                                                                                                                                                                                              | Bugs |
|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------|
| Setup oVirt engine using either Active Directory or Local IPA, two hosts configured as hypervisors (Fedora / Ovirt-Node / other) with power management (Storage Domains - Data Domain / ISO Domain and Export Domain) |      |
| Setup oVirt engine - basic AIO flow                                                                                                                                                                                   |      |
| Use ISO Uploader to populate images of OS and tools                                                                                                                                                                   |      |
| Basic Network Configuration                                                                                                                                                                                           |      |
| Create virtual machines and assign them to users                                                                                                                                                                      |      |
| Migrate Virtual Machines between the hypervisors                                                                                                                                                                      |      |
| Collect log file using the log collector tool                                                                                                                                                                         |      |
| Upgrade from 3.3 to 3.4                                                                                                                                                                                               |      |

#### Configuration

| Scenario                                                                                                                                                            | Bugs |
|---------------------------------------------------------------------------------------------------------------------------------------------------------------------|------|
| Configure high availability for virtual machines which are running mission critical workloads, so they will be restarted on another host if hardware failure occurs |      |
| Use the multi-level administration feature to assign different levels of user permissions                                                                           |      |
| Live Migration Scenarios                                                                                                                                            |      |
| Enable smartcard support for a VM and verify that the <smartcard mode="passthrough" type="spicevmc"/> is passed to libvirt                                          |      |

#### Storage

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

#### Network

*   Important Note: Known Fedora 19 bug: If the ovirtmgmt bridge is not successfully installed during initial host-setup, manually click on the host, setup networks, and add the ovirtmgmt bridge.
*   Base config - single NIC, bridge on top, VMs attached to NIC
*   Advanced configurations:

![](Vlan bonding.jpg "fig:Vlan bonding.jpg") Make sure each of the configs can:

*   Survive a reboot
*   Test network at both host and VM level
*   Ping and transfer large amounts of data (2Gb size files should be enough)
*   Remain operational over time (1hr of uptime should be sufficient for the basic testing)

#### Tools

*   Basic operations on iso-uploader:

1.  **engine-iso-uploader list**
2.  **engine-iso-uploader upload <iso> -i <iso-domain-name> -v -f**

*   Basic operations on log-collector:

1.  **engine-log-collector list**
2.  **engine-log-collector collect**

*   Basic operation on image-uploader

**engine-image-uploader --name=<new name here> -e <domain> upload my.ovf**

##### New to v3.1:

*   port mirroring: one can setup a VM that sniffs all IP traffic between VMs on a network on a host.
*   no mac spoofing: VMs cannot emit packets with spoofed mac address (unless specifically allowed to).
*   Sync network: change network MTU (or other property) on host, verify that Engine may overwrite it with Sync network
*   Jumbo packets: see if can be configured and used by storage

##### New to v3.2:

*   Network main tab operational: you can search hosts and VM based on their network connectivity
*   Guest agent reported devices: install guest agent on a VM and see it report internal information of the vNics (internal device name, IPv4 and IPv6)
*   Network Linking: allow changing network the VM is connect to while it is running

#### APIs

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

#### Spice

For details about configuration check <http://www.ovirt.org/wiki/Testing/Spice>

| Scenario                                                                                                               | Bugs |
|------------------------------------------------------------------------------------------------------------------------|------|
| Install Windows VM and a Linux VM with Guest Tools (QXL graphic driver and spice vdagent)                              |      |
| Assign user to these vms, login to a user portal, from your client machine, and connect to it using the Spice protocol |      |
| Try to watch a clip via YouTube or any other web based video (with QXL driver installed on VM)                         |      |
| Try to watch a Local movie (with QXL driver installed on VM)                                                           |      |
| Try to use client mouse mode and clipboard share between client and VM (with spice agent installed on VM)              |      |
| Install AutoCAD or any other graphic application a try to work with it (with QXL driver installed on VM)               |      |

#### User Interface

Webadmin:

#### Node

#### SLA

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

### Bug Reporting

*   ovirt - <https://bugzilla.redhat.com/enter_bug.cgi?product=oVirt>
*   Spice - <https://bugs.freedesktop.org/> under Spice product
*   VDSM - <https://bugzilla.redhat.com/enter_bug.cgi?product=oVirt> with vdsm component

Tracker bug for the release - <https://bugzilla.redhat.com/1024889>

## Test Day Summary

### Release Blockers

### Participants Table

| Name            | Tested Features         | Distro |
|-----------------|-------------------------|--------|
| jdoe@redhat.com | Watchdog engine support | EL6    |
