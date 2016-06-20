---
title: oVirt 3.3 TestDay
authors: abonas, amuller, amureini, apuimedo, arik, awels, dcaroest, dneary, dougsland,
  ecohen, eedri, emesika, fkobzik, laravot, mgoldboi, mkolesni, mlipchuk, moolit,
  mpavlik, mperina, ofrenkel, ofri, pstehlik, rnori, sahina, sandrobonazzola, stirabos,
  vszocs, yair zaslavsky
wiki_title: OVirt 3.3 TestDay
wiki_revision_count: 91
wiki_last_updated: 2014-04-04
wiki_warnings: table-style
---

# OVirt 3.3 TestDay

### Objective

*   engage project users and stakeholders to a hands-on experiences with oVirt new release.
*   improve the quality of oVirt.
*   Introduce and validating new oVirt 3.3 features

### What I should do

*   If you already have the hardware, verify if it meets the hardware requirement, refer information detail section below
*   Update the Participants section.
*   Go a head and [ install ovirt ](OVirt_3.3_TestDay#Installation_notes)
*   Accomplish the goals set in objective section , run the tests, update the test matrix.
*   Running into any issues - [ Try to get answer ](Community) or [open a BZ](https://bugzilla.redhat.com/enter_bug.cgi?product=oVirt)

### Installation notes

*   make sure you have either a fedora 19 or centos 6.4 machine installed.
*   install the release pkg:

`sudo yum localinstall `[`http://ovirt.org/releases/ovirt-release.noarch.rpm`](http://ovirt.org/releases/ovirt-release.noarch.rpm)

*   make sure to enable the [ovirt-beta] & [ovirt-stable] repos and disable the [ovirt-nightly] repo.
*   if you're using centos, make sure you have epel repo enabled as well:

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

##### host installation

Fedora 19: If the ovirtmgmt bridge is not successfully installed during initial host-setup, manually click on the host, setup networks, and add the ovirtmgmt bridge. It is recommended to disable NetworkManager as well.

### oVirt 3.3 New Features - Test Status Table

| Functional team | Feature                                                                                                                                | Owner                                                                                                | Dev - Status              | Test page                                                                                                                  | Tested By/ Distro                                                        | BZs                                                                                                                                                                                      | remarks                                                                                                |
|-----------------|----------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------|---------------------------|----------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------|
| General         | General regressions                                                                                                                    |                                                                                                      |                           |                                                                                                                            |                                                                          |                                                                                                                                                                                          |                                                                                                        |
| Virt            | [RAM Snapshots](Features/RAM Snapshots)                                                                                     | [ Arik Hadas](User:ahadas)                                                                | Green                     | <http://www.ovirt.org/Features/RAM_Snapshots#Testing>                                                                      |                                                                          |                                                                                                                                                                                          |                                                                                                        |
| Virt            | [noVNC console](Features/noVNC console)                                                                                     | [ Frantisek Kobzik](User:FKobzik)                                                         | Green                     | <http://www.ovirt.org/Features/noVNC_console#Testing>                                                                      | [Einav Cohen](User:Ecohen) / Fedora 19                        |                                                                                                                                                                                          | tested only test case 2; encountered problems; notes were sent to feature owner.                       |
| Virt            | VNC keyboard layout per VM                                                                                                             | [ Martin Betak](User:mbetak)                                                              | Green                     |                                                                                                                            | [ Yair Zaslavsky](User:Yair Zaslavsky)                        |                                                                                                                                                                                          |                                                                                                        |
| Virt            | multiple VMs from pool to user                                                                                                         | [ Martin Betak](User:mbetak)                                                              | Green                     |                                                                                                                            | [ Maor Lipchuk](User:Maor Lipchuk)                            |                                                                                                                                                                                          
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       (Not related to this feature) -                                                                                                                                                           |                                                                                                        |
| Virt            | [Non Plugin RDP Invocation](Features/Non_plugin_console_invocation)                                                         | [ Frantisek Kobzik](User:FKobzik)                                                         | Green                     | <http://www.ovirt.org/Features/Non_plugin_console_invocation#RDP>                                                          |                                                                          |                                                                                                                                                                                          |                                                                                                        |
| Virt            | [Instance Types - VM Dialog Redesing](Features/Instance Types)                                                              | [ Tomas Jelinek](User:tjelinek) [ Omer Frenkel](User:ofrenkel)                 | Green                     | <http://www.ovirt.org/Features/Instance_Types#Testing>                                                                     | [Alissa Bonas](User:abonas)                                   |                                                                                                                                                                                          |                                                                                                        |
| Virt            | [Instance Types - change server/desktop behavior to 'optimize for'](Features/Instance Types)                                | [ Tomas Jelinek](User:tjelinek) [ Omer Frenkel](User:ofrenkel)                 | Green                     | <http://www.ovirt.org/Features/Instance_Types#Testing>                                                                     | Alexander Wels                                                           |                                                                                                                                                                                          | Ran all the tests and couldn't find any problems not mentioned above (Fedora 19 engine/Fedora 19 host) |
| Virt            | [OS Info](OS_info)                                                                                                          | [ Roy Golan](User:rgolan)                                                                 | Green                     | <http://wiki.ovirt.org/OS_info#Testing>                                                                                    |                                                                          |                                                                                                                                                                                          |                                                                                                        |
| Virt            | [Redesigned Display Options dialog](Features/Console_connection_settings_dialog_in_portals)                                 | [ Frantisek Kobzik](User:fkobzik)                                                         | Green                     | <http://www.ovirt.org/Features/Console_connection_settings_dialog_in_portals#Testing>                                      |                                                                          |                                                                                                                                                                                          |                                                                                                        |
| Virt            | [EmulatedMachine](Features/EmulatedMachine)                                                                                 | [ Roy Golan](User:rgolan)                                                                 | Green                     | <http://www.ovirt.org/Cluster_emulation_modes#Testing>                                                                     |                                                                          |                                                                                                                                                                                          |                                                                                                        |
| Virt            | [SPICE HTML5 client integration](Features/SpiceHTML5)                                                                       | [ Frantisek Kobzik](User:fkobzik)                                                         | Green                     | <http://www.ovirt.org/Features/SpiceHTML5#Testing>                                                                         | Greg Sheremeta                                                           |                                                                                                                                                                                          |                                                                                                        |
| Virt            | [Cloud-Init Integration](Features/Cloud-Init_Integration)                                                                   | [Greg Padgett](User:Gpadgett) [Omer Frenkel](User:Ofrenkel)                    | Green                     | <http://www.ovirt.org/Features/Cloud-Init_Integration#Testing>                                                             | pstehlik (F19)                                                           |  didn't reach test itself                                                                                                                                                                | Only available with UI, no REST implementation yet.                                                    |
| Virt            | [GlusterFS Storage Domain](Features/GlusterFS_Storage_Domain)                                                               | Deepak C Shetty (vdsm) & Sharad Mishra (engine)                                                      | Green                     | <http://www.ovirt.org/Features/GlusterFS_Storage_Domain#Testing>                                                           |                                                                          |                                                                                                                                                                                          |                                                                                                        |
| Infra           | Predictable host timeouts for ha/fencing                                                                                               | [ Juan Hernandez](User:juan)                                                              | Green                     |                                                                                                                            | [ laravot](User:laravot)                                      |                                                                                                                                                                                          |                                                                                                        |
| Infra           | [Device Custom Properties](Features/Device Custom Properties)                                                               | [ Martin Perina](User:mperina) - infra [ Assaf Muller](User:amuller) - network | Green                     |                                                                                                                            |                                                                          |                                                                                                                                                                                          |
| Infra           | [Foreman Integration](Features/Foreman Integration)                                                                         | [ Over Orvalli](User:ovedo) - Projects                                                    | Red                       | <http://www.ovirt.org/Features/ForemanIntegration>                                                                         | |[ Eyal Edri](User:eedri)                                     | |                                                                                                                                                                                        | Tested on fedora19                                                                                     |
| Infra           | [Async task manager changes](Features/AsyncTaskManagerChanges_3.3)                                                          | [ Yair Zaslavsky](User:Yair Zaslavsky)                                                    | Green - Merged            | <http://www.ovirt.org/Features/AsyncTaskManagerChanges_3.3#Testing>                                                        | <User:Amureini>                                                          | (reopened)                                                                                                                                                                               |                                                                                                        |
| Infra           | [ExternalTasks](Features/ExternalTasks)                                                                                     | [ Eli Mesika](User:emesika)                                                               | Green                     | [Features/ExternalTasks#Testing](Features/ExternalTasks#Testing)                                               | Vojtech Szocs / Fedora 19                                                |                                                                                                                                                                                          |                                                                                                        |
| Infra           | [Supervdsm service](Features/Supervdsm_service)                                                                             | [ Yaniv Bronhaim](User:ybronhei)                                                          | Green                     | <http://www.ovirt.org/Features/Supervdsm_service>                                                                          |                                                                          |                                                                                                                                                                                          |                                                                                                        |
| Infra           | [SSH Soft Fencing](Automatic_Fencing#Automatic_Fencing_in_oVirt_3.3)                                                        | [ Martin Perina](User:mperina)                                                            | Green                     | <http://www.ovirt.org/Automatic_Fencing#Testing>                                                                           |                                                                          |                                                                                                                                                                                          |                                                                                                        |
| Infra           | [Java SDK](Features/Java_SDK)                                                                                               | [ Michael Pasternak](User:Michael pasternak)                                              | Green - Merged            | <http://www.ovirt.org/Features/Java_SDK_3.3#Testing>                                                                       |                                                                          |                                                                                                                                                                                          |                                                                                                        |
| Infra           | [SSH Abilities](Features/Ssh_Abilities)                                                                                     | [ Yaniv Bronhaim](User:ybronhei)                                                          | Green                     | <http://www.ovirt.org/Features/Ssh_Abilities#Testing>                                                                      |                                                                          |                                                                                                                                                                                          |                                                                                                        |
| Networking      | [Normalized ovirtmgmt Initialization](Features/Normalized ovirtmgmt Initialization)                                         | [ Moti Asayag](User:masayag)                                                              | Green                     | [Features/Normalized_ovirtmgmt_Initialization#Testing](Features/Normalized_ovirtmgmt_Initialization#Testing) | [Sandro Bonazzola](User:SandroBonazzola)/Fedora 19,oVirt Node 
                                                                                                                                                                                                                                                                                                                                                                                                                            |[Martin Pavlik](User:Mpavlik)/Fedora 19                       | [987813](https://bugzilla.redhat.com/show_bug.cgi?id=987813), [987832](https://bugzilla.redhat.com/show_bug.cgi?id=987832), [987950](https://bugzilla.redhat.com/show_bug.cgi?id=987950) |                                                                                                        |
| Networking      | [Migration Network](Features/Migration Network)                                                                             | [ Alona Kaplan](User:alkaplan)                                                            | Green                     | [Features/Migration_Network#Testing](Features/Migration_Network#Testing)                                      | [ Antoni Segura Puimedon](User:APuimedo)/Fedora 19            |                                                                                                                                                                                          |                                                                                                        |
| Networking      | [Multiple Gateways](Features/Multiple Gateways)                                                                             | [ Assaf Muller](User:amuller)                                                             | Green                     | [Features/Multiple_Gateways#Testing](Features/Multiple_Gateways#Testing)                                      | [ David Caro Estévez](User:Dcaroest)/Fedora 19                |                                                                                                                                                                                          | Tested only on Fedora 19 with two nics on different vlans                                              |
| Networking      | [Quantum Integration](Features/Quantum_Integration)                                                                         | [ Mike Kolesnik](User:mkolesni)                                                           | Green                     | [Features/Quantum_Integration#Testing](Features/Quantum_Integration#Testing)                                  |                                                                          |                                                                                                                                                                                          |                                                                                                        |
| Storage         | [Virtio-SCSI support](Features/Virtio-SCSI)                                                                                 | [Daniel Erez](User:derez)                                                                 | Green                     | [Features/Virtio-SCSI#Testing](Features/Virtio-SCSI#Testing)                                                   |                                                                          |                                                                                                                                                                                          |                                                                                                        |
| Storage         | [Manage Storage Connections](Features/Manage_Storage_Connections)                                                           | [Alissa Bonas](User:abonas)                                                               | orange - Work in Progress | [Features/Manage_Storage_Connections#Testing](Features/Manage_Storage_Connections#Testing)                   |                                                                          |                                                                                                                                                                                          |                                                                                                        |
| Storage         | [Adding VDSM hooks for hotplugging/unplugging a disk](Features/Disk_Hooks)                                                  | [Vered Volansky](User:vvolansk)                                                           | Green                     |                                                                                                                            |                                                                          |                                                                                                                                                                                          |                                                                                                        |
| Storage         | [Separating "Move" vm operation to "Copy" and "Delete" operations to improve VM availability](Features/MoveAsCopyAndDelete) | [Liron Aravot](User:laravot)                                                              | Green                     |                                                                                                                            |                                                                          |                                                                                                                                                                                          |                                                                                                        |
| SLA             | [Watchdog engine support](Features/Watchdog_engine_support)                                                                 | [lhornyak@redhat.com](User:LHornyak)                                                      |                           | [Test cases](Features/Watchdog engine support#Test_cases)                                                       | [Douglas](User:dougsland)                                     |                                                                                                                                                                                          |                                                                                                        |
| SLA             | [Trusted compute pools](Trusted_compute_pools)                                                                              | <User:OMasad>                                                                                        |                           | [Trusted_compute_pools#Test_cases](Trusted_compute_pools#Test_cases)                                        | [Ravi Nori](User:Rnori)                                       |                                                                                                                                                                                          |                                                                                                        |
| Gluster         | [Gluster Hooks Management](Features/Gluster Hooks Management)                                                               | [Sahina Bose](User:Sahina)                                                                | Green                     | [Gluster Hooks Management Testing](Features/Gluster Hooks Management#Test_Cases)                                |                                                                          |                                                                                                                                                                                          | Available in UI. No REST API yet                                                                       |
| Gluster         | [Gluster Swift Management](Features/Gluster Swift Management)                                                               | [Sahina Bose](User:Sahina), avishwan@redhat.com (vdsm)                                    | Green                     | [Features/Gluster Swift Management#Test_Cases](Features/Gluster Swift Management#Test_Cases)                  |                                                                          |                                                                                                                                                                                          | Available in UI. No REST API yet                                                                       |
| Node            | [Universal Node Image](Features/Universal Image)                                                                            | mburns@redhat.com                                                                                    | Green                     |                                                                                                                            |                                                                          |                                                                                                                                                                                          |                                                                                                        |
| Node            | [Node VDSM Plugin](Features/Node vdsm plugin)                                                                               | mburns                                                                                               | Green                     | [Features/Node_vdsm_plugin#Testing](Features/Node_vdsm_plugin#Testing)                                       |                                                                          |                                                                                                                                                                                          |                                                                                                        |
| Integration     | [Otopi Infra Migration](Features/Otopi_Infra_Migration)                                                                     | [ Sandro Bonazzola](User:SandroBonazzola)                                                 | Green                     | [Test cases](Features/Otopi_Infra_Migration#Basic_Testing)                                                      |                                                                          |                                                                                                                                                                                          |                                                                                                        |
| UX              | User Portal performance improvements for IE8                                                                                           | vszocs@redhat.com, awels@redhat.com                                                                  | Green                     |                                                                                                                            |                                                                          |                                                                                                                                                                                          |                                                                                                        |
| UX              | [Branding Support](Feature/Branding)                                                                                        | awels@redhat.com                                                                                     | Green                     |                                                                                                                            |                                                                          |                                                                                                                                                                                          |                                                                                                        |

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
| Upgrade from 3.2 to 3.3 including Fedora upgrade                                                                                                                                                                      |      |

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

![](Vlan bonding.jpg "fig:Vlan bonding.jpg") make sure each of the configs can:

*   survive a reboot
*   test network at both host and VM level
*   ping and transfer large amounts of data (2Gb size files should be enough)
*   remain operational over time (1hr of uptime should be sufficient for the basic testing)

Bugs found:

*   Bug 906289 - [oVirt-webadmin] [network] Non-VM networks shown as VM networks on cluster attachment dialog
*   Bug 906291 - [oVirt-webadmin] [network] Non-VM networks not being detached from cluster
*   Bug 906313 - [oVirt-webadmin] [setupNetworks] "No valid Operation for <network_name> and Unassigned Logical Networks panel"
*   Bug 906383 - [vdsm] [setupNetworks] Error while attaching non-VM network to interface on Fedora 18
*   Bug 906393 - [oVirt] [network] Audit log message for unmanaged network
*   Bug 906394 - [oVirt-webadmin] [network] Loading animation in network main tab 'hosts' and 'vms' subtab is stuck on first view of the sub tab
*   Bug 906405 - Bad Error Message when Removing vNic from Running VM
*   Bug 906434 - Editing vnic's type and mac are blocked when the vnic was unplugged and updated to plugged
*   Bug 906440 - Updating type of a plugged nic should be blocked on the ui side

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

oVirt Node image is not currently available for the Test Day. The image should be available within the next day or two.

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
*   VDSM - <https://bugzilla.redhat.com/show_bug.cgi?id=831998>

Tracker bug for the release - <https://bugzilla.redhat.com/881006>

## Test Day Summary

### Release Blockers

### Participants Table

| Name                                               | Tested Features                                                                                                       | Distro                |
|----------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------|-----------------------|
| jdoe@redhat.com                                    | Watchdog engine support                                                                                               | EL6                   |
| [SandroBonazzola](User:SandroBonazzola) | [Normalized_ovirtmgmt_Initialization](Features/Normalized_ovirtmgmt_Initialization), Network Base config | Fedora 19, oVirt Node |
| [Amureini](User:Amureini)               | [Features/AsyncTaskManagerChanges 3.3](Features/AsyncTaskManagerChanges 3.3)                               | EL6                   |
| [omasad](User:Omasad)                   | [bz#892260](bz#892260)                                                                                    | Fedora 19             |
| [ahadas](User:ahadas)                   | [Online_Virtual_Drive_Resize](Features/Online_Virtual_Drive_Resize)                                     | Fedora 19             |
| [mtayer](User:mtayer)                   | [bz#866319](bz#866319), [bz#854369](bz#854369) - both are small cli features                  | Fedora 19             |
| [emsika](User:mtayer)                   | Compressing DWH DB backup                                                                                             | Fedora 19             |
| [ofrenkel](User:Ofrenkel)               | Select host as SPM                                                                                                    | Fedora 19             |
