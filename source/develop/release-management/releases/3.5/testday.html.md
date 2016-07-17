---
title: oVirt 3.5 TestDay
authors: danken, didi, fkobzik, gchaplik, gshereme, lvernia, sandrobonazzola
wiki_title: OVirt 3.5 TestDay
wiki_revision_count: 29
wiki_last_updated: 2014-09-17
---

# oVirt 3.5 TestDay

## Objective

*   engage project users and stakeholders to a hands-on experiences with oVirt new release.
*   improve the quality of oVirt.
*   Introduce and validate new oVirt 3.5 features.

## What I should do

*   If you already have the hardware, verify if it meets the hardware requirement, refer to information detail section below.
*   Write down the configuration you used (HW, console, etc) and what you've tested in the [third test day report etherpad](http://etherpad.ovirt.org/p/3.5-testday-3) (previous is [first test day report etherpad; [second test day report etherpad](http://etherpad.ovirt.org/p/3.5-testday-2)](http://etherpad.ovirt.org/p/3.5-testday-1)).
*   Go ahead and [ install ovirt ](oVirt_3.5_TestDay#Installation_notes).
*   Follow the documentation to setup your environment, and test drive the new features.
*   Please remember we expect to see some issues, and anything you come up with will save you when you'll install final release.
*   Remember to try daily tasks you'd usually do in the engine, to see there are no regressions.
*   Accomplish the goals set in objective section , run the tests, update the test matrix.
*   Running into any issues?
    -   [ Try to get help from the community ](Community) on #ovirt IRC channel or
    -   [open a bugzilla](https://bugzilla.redhat.com/enter_bug.cgi?product=oVirt) ticket or
    -   Report it on the [third test day report etherpad](http://etherpad.ovirt.org/p/3.5-testday-3) (previous is [first test day report etherpad](http://etherpad.ovirt.org/p/3.5-testday-1), [second test day report etherpad](http://etherpad.ovirt.org/p/3.5-testday-2) ).

## Installation notes

*   Make sure you have one of the following distributions installed on your machine:
    -   Fedora 19
    -   Fedora 20
    -   CentOS 6.5
    -   Red Hat Enterprise Linux 6.5
    -   Any other distribution based on Red Hat Enterprise Linux 6.5
*   Follow installation instructions provided within [oVirt 3.5 Release Notes](OVirt_3.5_Release_Notes#Fedora_.2F_CentOS_.2F_RHEL)

### Known issues

*   Fedora 19 hosts: you'll need libvirt >= 1.0.1 to use cluster level 3.5 . This is provided in the virt-preview repo, enabled automatically by installing the ovirt-release35.rpm as explained in the [oVirt 3.5 Release Notes](OVirt_3.5_Release_Notes#Fedora_.2F_CentOS_.2F_RHEL)
*   DWH/Reports setup is currently broken.
*   You can't refresh iso file list after adding a host, see <https://bugzilla.redhat.com/1114499> for a workaround.
*   The beta RPM packages are not signed. Either use 'yum --nogpgcheck' or set 'gpgcheck=0' in the repo file.
*   CentOS hosts don't report RNG devices sources. Please uncheck '/dev/random' checkbox in Cluster Options for default cluster before adding any CentOS host to it.

## oVirt 3.5 New Features - Test Status Table

Please report test results on the [third test day report etherpad](http://etherpad.ovirt.org/p/3.5-testday-3) (previous is [first test day report etherpad](http://etherpad.ovirt.org/p/3.5-testday-1); [second test day report etherpad](http://etherpad.ovirt.org/p/3.5-testday-2)).or on the table below.

Following tests should be performed on all supported distributions.

|-----------------|-----------------------------------------------------------------|----------|--------------|-----------------------------------------------------------|----------------------------------------------------------------|------------------|------------------|
| Functional team | Feature                                                         | Owner    | Dev - Status | Test page                                                 | Tested By/ Distro                                              | BZs              | remarks          |
| General         | oVirt Live 3.5 (testing)                                        |          |              |                                                           |                                                                |                  |                  |
| General         | upgrade from 3.4 (testing)                                      |          |              |                                                           | [SandroBonazzola](User:SandroBonazzola) F19         |                  | works            |
| General         | All in One setup (testing)                                      |          |              |                                                           | [SandroBonazzola](User:SandroBonazzola) F19,F20,EL6 |                  | works            |
| Network         | Neutron Appliance                                               | masayag  |              | <http://www.ovirt.org/Features/NeutronVirtualAppliance>   |                                                                | 1078862          |                  |
| Network         | Network Custom Properties (bridge_opts, ethtool_opts, custom) | lvernia  | Done         | <http://www.ovirt.org/Features/Network_Custom_Properties> |                                                                | 1080984, 1080987 |                  |
| Network         | NIC errors in event log                                         | alkaplan | Done         |                                                           |                                                                | 1079719          |                  |
| Network         | Arbitrary VLAN-tagged network name                              | alkaplan | Done         |                                                           |                                                                | 1091863          | works (gshereme) |
| Network         | Warning upon display network changes                            | yzaspits | Done         |                                                           |                                                                | 1078836          |                  |
| Network         | Allow big MAC pool ranges                                       | mmucha   | Done         |                                                           |                                                                | 1063064          |                  |

## Regression testing

### General

You need at least two physical servers to install and configure a basic yet complete oVirt environment with shared storage to exercise the following:

|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------|-----|---------|
| Scenario                                                                                                                                                                                                              | Tested By/ Distro                                              | BZs | remarks |
| Setup oVirt engine using either Active Directory or Local IPA, two hosts configured as hypervisors (Fedora / Ovirt-Node / other) with power management (Storage Domains - Data Domain / ISO Domain and Export Domain) |                                                                |     |         |
| Basic Network Configuration                                                                                                                                                                                           | [SandroBonazzola](User:SandroBonazzola) F19,F20,EL6 |     | works   |
| Create virtual machines and assign them to users                                                                                                                                                                      |                                                                |     |         |
| Migrate Virtual Machines between the hypervisors                                                                                                                                                                      |                                                                |     |         |

### Hosted Engine

You need at least two physical servers to install and configure a basic yet complete oVirt environment with shared storage to exercise the following tests. You may need to read the following documents:

*   [Unify maintenance path of Hosted Engine with host maintenance](Features/Self Hosted Engine Maintenance Flows)
*   [Hosted Engine on NFS](Hosted Engine Howto)

|------------------------------------------------------------|-------------------|-----|---------|
| Scenario                                                   | Tested By/ Distro | BZs | remarks |
| Setup oVirt Hosted Engine using a NFS storage domain       |                   |     |         |
| Setup oVirt Hosted Engine using a common network interface |                   |     |         |
| Setup oVirt Hosted Engine using a tagged VLAN interface    |                   |     |         |
| Setup oVirt Hosted Engine using a bonded interface         |                   |     |         |
| Migrate Hosted Engine VM on another host                   |                   |     |         |

### Configuration

### Infra

### Storage

### Network

*   Important Note: Known Fedora 19 bug: If the ovirtmgmt bridge is not successfully installed during initial host-setup, manually click on the host, setup networks, and add the ovirtmgmt bridge.
*   Base config - single NIC, bridge on top, VMs attached to NIC
*   Advanced configurations:

![](Vlan bonding.jpg "fig:Vlan bonding.jpg") Make sure each of the configs can:

*   Survive a reboot
*   Test network at both host and VM level
*   Ping and transfer large amounts of data (2Gb size files should be enough)
*   Remain operational over time (1hr of uptime should be sufficient for the basic testing)

### Tools

*   Basic operations on iso-uploader:

`# `**`engine-iso-uploader` `list`**
`# `**`engine-iso-uploader` `upload` <iso> `-i` <iso-domain-name> `-v` `-f`**

*   Advanced operations on iso-uploader: try different arguments, see full list with

`# `**`engine-iso-uploader` `--help`**

*   Basic operations on log-collector:

`# `**`engine-log-collector` `list`**
`# `**`engine-log-collector` `collect`**

*   Advanced operations on log-collector : try different arguments, see full list with

`# `**`engine-log-collector` `--help`**

*   Basic operation on image-uploader

`# `**`engine-image-uploader` `list`**
`# `**`engine-image-uploader` `--name=`<new name here> `-e` <domain> `upload` `my.ovf`**

*   Advanced operations on image-uploader: try different arguments, see full list with

`# `**`engine-image-uploader` `--help`**

### Features from previous releases

#### New to v3.1:

#### New to v3.2:

#### New to v3.3:

#### New to v3.4:

### APIs

### Spice

### User Interface

### Node

### SLA

#### Numa support

#### Opta planner integration

#### HE on iscsi

#### Scheduling policies rest-api

## Bug Reporting

*   ovirt - <https://bugzilla.redhat.com/enter_bug.cgi?product=oVirt>
*   Spice - <https://bugs.freedesktop.org/> under Spice product
*   VDSM - <https://bugzilla.redhat.com/enter_bug.cgi?product=oVirt&component=vdsm>

Tracker bug for the release
