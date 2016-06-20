---
title: oVirt 3.4 Test Day
authors: amureini, apuimedo, awels, bproffitt, danken, doron, ecohen, eedri, emesika,
  fabiand, fromani, gchaplik, jmoskovc, mperina, msivak, netbulae, rnori, sandrobonazzola,
  yair zaslavsky, ybronhei
wiki_title: OVirt 3.4 Test Day
wiki_revision_count: 77
wiki_last_updated: 2014-03-27
---

# oVirt 3.4 Test Day

## Objective

*   engage project users and stakeholders to a hands-on experiences with oVirt new release.
*   improve the quality of oVirt.
*   Introduce and validating new oVirt 3.4 features
*   3rd test day will focus on complete installations and GA readiness using the RC release.

## What I should do

*   Specific tasks can be found in the 3_4-testday-3 tab of the [Google Doc](https://docs.google.com/spreadsheet/ccc?key=0AuAtmJW_VMCRdHJ6N1M3d1F1UTJTS1dSMnZwMF9XWVE&usp=sharing)
*   If you already have the hardware, verify if it meets the hardware requirement, refer information detail section below
*   Write down the configuration you used (HW, console, etc) and what you've tested in the [report etherpad](http://etherpad.ovirt.org/p/3.4-testday-3) ([first test day report etherpad](http://etherpad.ovirt.org/p/3.4-testday-1), [second test day report etherpad](http://etherpad.ovirt.org/p/3.4-testday-2))
*   Go ahead and [ install ovirt ](oVirt_3.4_Test_Day#Installation_notes)
*   Follow the documentation to setup your environment, and test drive the new features.
*   Please remember we expect to see some issues, and anything you come up with will save a you when you'll install final release
*   Remember to try daily tasks you'd usually do in the engine, to see there are no regressions.
*   Accomplish the goals set in objective section , run the tests, update the test matrix.
*   Running into any issues?
    -   [ Try to get help from the community ](Community) on #ovirt IRC channel or
    -   [open a bugzilla](https://bugzilla.redhat.com/enter_bug.cgi?product=oVirt) ticket or
    -   Report it on the [report etherpad](http://etherpad.ovirt.org/p/3.4-testday-3) ([first test day report etherpad](http://etherpad.ovirt.org/p/3.4-testday-1), [second test day report etherpad](http://etherpad.ovirt.org/p/3.4-testday-2))

## Installation notes

*   Make sure you have either a Fedora 19 or CentOS 6.5 machine installed.
*   Install the release pkg:

`sudo yum localinstall `[`http://resources.ovirt.org/releases/ovirt-release.noarch.rpm`](http://resources.ovirt.org/releases/ovirt-release.noarch.rpm)
      sudo yum install yum-utils
      sudo yum-config-manager --enable ovirt-3.4.0-prerelease

(f19) you need to enable also fedora-virt-preview repo repository.

      sudo yum-config-manager --enable fedora-virt-preview

(el) you need to enable epel too

       sudo yum-config-manager --enable ovirt-epel
       sudo yum install epel-release
       if the above commands doesn't work you can install it manually:
` sudo yum install `[`http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm`](http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm)

*   follow [ Install instructions in release notes](OVirt_3.4_Release_Notes)
*   guest agent rpms are available on <http://evilissimo.fedorapeople.org/repos/ovirt-guest-agent/ovirt-3.4/beta1/>
*   the following oVirt Node ISO (based on CentOS 6.5 and oVirt 3.4 components) can be used for the Test Day. **Important: If you run into problem first try to boot into SELinux permissive mode by appending enforcing=0 to the kernel when booting the ISO to prevent denials**

[`http://fedorapeople.org/~fabiand/node/3.0.4/ovirt-node-iso-3.0.4-1.0.201401291204.vdsm34.el6.iso`](http://fedorapeople.org/~fabiand/node/3.0.4/ovirt-node-iso-3.0.4-1.0.201401291204.vdsm34.el6.iso)

### Known issues

*   A Fedora 19 node goes to "non operational" state with the error "Host IPADDRESS is compatible with versions (3.0,3.1,3.2,3.3) and cannot join Cluster Default which is set to version 3.4.". The recommended fix is to enable the fedora-virt-preview repo, delivered with the ovirt-release , and to update libvirt from it. ()
*   Node
    -   Should work in enforcing mode, but might be booted into permissive mode to debug denials. Permissive: Append `enforcing=0` to the kernel on boot
*   Upgrade will fail if event_subscriber table is not empty Bug ()

## oVirt 3.4 New Features - Test Status Table

Please report test results on the [report etherpad](http://etherpad.ovirt.org/p/3.4-testday-3) ([first test day report etherpad](http://etherpad.ovirt.org/p/3.4-testday-1), [second test day report etherpad](http://etherpad.ovirt.org/p/3.4-testday-2)) or on the table below.

|-----------------|------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------|-----------------------------|--------------------------------------------------------------------------|----------------------------------------------------------------------|-----------------------|-----------------------------------|
| Functional team | Feature                                                                                                                                  | Owner                                                      | Dev - Status                | Test page                                                                | Tested By/ Distro                                                    | BZs                   | remarks                           |
| General         | ovirt-live 3.4 (testing)                                                                                                                 |                                                            |                             |                                                                          |                                                                      |                       |                                   |
| General         | upgrade from 3.3 (testing)                                                                                                               |                                                            |                             |                                                                          |                                                                      |                       |                                   |
| General         | ovirt-all-in-one (testing)                                                                                                               |                                                            |                             |                                                                          |                                                                      |                       |                                   |
| Gluster         | [Volume Asynchronous Tasks Management](Features/Gluster Volume Asynchronous Tasks Management)                                 | [ Sahina Bose](User:Sahina)                     | Green                       |                                                                          |                                                                      |                       |                                   |
| Infra           | [snmp & snmp trap monitoring (will do only snmp trap as notification)](Features/engine-snmp)                                  | [Mooli Tayer](User:mtayer)                      | Orange - Work in Progress   | <http://www.ovirt.org/Features/engine-snmp#Testing>                      |                                                                      |                       |                                   |
| Infra           | Authentication Refactoring                                                                                                               | [ Juan Hernandez](User:juan)                    | Green                       |                                                                          | [ Allon Mureinik](User:amureini) / EL6                    | , , , , , , , , , , , |                                   |
| Infra           | Add fence_hpblade as a Fence Agent                                                                                                      | [ Eli Mesika](User:emesika)                     | Green                       |                                                                          |                                                                      |                       |                                   |
| Infra           | Allow to provide a password change URL on login failure when password expires                                                            | [ Juan Hernandez](User:juan)                    | Orange - Work in Progress   |                                                                          |                                                                      |                       |                                   |
| Infra           | DWH: Add trigger to stop ETL connection via engine dB value                                                                              | [ Yaniv Dary](User:ydary)                       | Green                       |                                                                          |                                                                      |                       |                                   |
| Infra           | Read only Admin role in AP                                                                                                               | [ Oved Ourfalli](User:ovedo)                    | Green                       |                                                                          |                                                                      |                       |                                   |
| Infra           | [RFE] Add new event notifiers for VM_DOWN_ERROR and VDS_INITIATED_RUN_VM_FAIL                                                      | [ Adam Litke](User:Aglitke)                     | Green                       |                                                                          |                                                                      |                       |                                   |
| Infra           | Add JSON support to REST API                                                                                                             | [ Juan Hernandez](User:juan)                    | Green                       |                                                                          |                                                                      |                       |                                   |
| Infra           | Add drac7 fence agent support                                                                                                            | [ Eli Mesika](User:emesika)                     | Green                       |                                                                          |                                                                      |                       |                                   |
| Infra           | collect the "created_by" field of a VM into it's configuration history                                                                  | [ Yaniv Dary](User:ydary)                       | Green                       |                                                                          |                                                                      |                       |                                   |
| Infra           | engine-notifier to support STARTTLS                                                                                                      | [ Martin Perina](User:mperina)                  | Green                       |                                                                          |                                                                      |                       |                                   |
| integration     | ovirt-engine URI rework                                                                                                                  | [Alon Bar-Lev](User:Alonbl)                     | Green                       |                                                                          | [ Ravi Nori](User:rnori) / F19                            |                       | Works for me                      |
| integration     | [virtual appliance image/rpm for ovirt](Feature/oVirtAppliance)                                                               | [ Ohad Basan ](User:obasan)                     | Orange - Work in Progress   |                                                                          |                                                                      |                       |                                   |
| integration     | DWH - migrate setup to otopi                                                                                                             | [ Sandro Bonazzola](User:SandroBonazzola)       | Green                       |                                                                          |                                                                      |                       |                                   |
| integration     | [REQUESTING EXCEPTION] reports - migrate setup to otopi                                                                                  | [ Sandro Bonazzola](User:SandroBonazzola)       | Orange - Work in Progress   |                                                                          |                                                                      |                       |                                   |
| integration     | [REQUESTING EXCEPTION] reports - add support for Centos el6 arch                                                                         | [ Sandro Bonazzola](User:SandroBonazzola)       | Orange - Work in Progress   |                                                                          |                                                                      |                       |                                   |
| network         | [nic ordering](Feature/Predictable vNIC Order)                                                                                | [ Oved Ourfalli](User:ovedo)                    | Green                       |                                                                          |                                                                      |                       |                                   |
| network         | [Neutron integration - security group support](Features/Detailed OSN Integration)                                             | [ Mike Kolesnik](User:Mkolesni)                 | Partial (migration missing) |                                                                          |                                                                      |                       |                                   |
| network         | [Neutron integration - security group support](Features/Detailed OSN Integration)                                             | [ Mike Kolesnik](User:Mkolesni)                 | Green                       |                                                                          |                                                                      |                       |                                   |
| network         | [Neutron integration - remove external networks](Features/Detailed OSN Integration)                                           | [ Mike Kolesnik](User:Mkolesni)                 | Green                       |                                                                          |                                                                      |                       |                                   |
| network         | [Network level QoS](Features/Detailed Host Network QoS)                                                                       | [ Lior Vernia](User:lvernia)                    | Green                       |                                                                          |                                                                      |                       |                                   |
| network         | [stabilize iproute2 configurator](Feature/NetworkReloaded)                                                                    | [ Antoni Segura Puimedon](User:APuimedo)        | Partial implementation      |                                                                          |                                                                      |                       |                                   |
| network         | [Multi-Host Network Configuration](Features/MultiHostNetworkConfiguration)                                                    | [ Moti Asayag](User:masayag)                    | Green                       | <http://www.ovirt.org/Features/MultiHostNetworkConfiguration#Testing>    |                                                                      |                       |                                   |
| network         | [Network Labels](Features/NetworkLabels)                                                                                      | [ Moti Asayag](User:masayag)                    | Green                       | <http://www.ovirt.org/Features/NetworkLabels#Testing>                    |                                                                      |                       |                                   |
| ppc             | [Architecture support when importing/exporting VM and Templates](Features/Engine support for PPC64)                           | [ Leonardo Bianconi](User:lbianco)              | Green                       |                                                                          |                                                                      |                       |                                   |
| ppc             | [Ability to specify architecture in the OSInfo file](Features/Engine support for PPC64)                                       | [ Leonardo Bianconi](User:lbianco)              | Green                       |                                                                          |                                                                      |                       |                                   |
| ppc             | [Ability to specify supported video cards and display protocols in the OSInfo file](Features/Engine support for PPC64)        | [ Leonardo Bianconi](User:lbianco)              | Green                       |                                                                          |                                                                      |                       |                                   |
| ppc             | [Ability to specify watch dog in the OSInfo file](Features/Engine support for PPC64)                                          | [ Gustavo Pedrosa](User:gpedrosa)               | Green                       |                                                                          |                                                                      |                       |                                   |
| ppc             | [Ability to specify hotplug of nic and disk in the OSInfo file](Features/Engine support for PPC64)                            | [ Gustavo Pedrosa](User:gpedrosa)               | Green                       |                                                                          |                                                                      |                       |                                   |
| ppc             | [Ability to search by architecture](Features/Engine support for PPC64)                                                        | [ Vitor de Lima](User:vdelima)                  | Green                       |                                                                          |                                                                      |                       |                                   |
| ppc             | [Create Cluster, VM and Templates for PPC64](Features/Engine support for PPC64)                                               | [ Leonardo Bianconi](User:lbianco)              | Green                       |                                                                          |                                                                      |                       |                                   |
| ppc             | [Add PPC64 Hosts](Features/Engine support for PPC64)                                                                          | [ Vitor de Lima](User:vdelima)                  | Green                       |                                                                          |                                                                      |                       |                                   |
| ppc             | [Support for sPAPR VLAN and sPAPR VSCSI](Features/Engine support for PPC64)                                                   | [ Vitor de Lima](User:vdelima)                  | Green                       |                                                                          |                                                                      |                       |                                   |
| ppc             | [Run fake power hosts](Features/Vdsm for PPC64)                                                                               | [ Vitor de Lima](User:vdelima)                  | Green                       | <http://www.ovirt.org/Features/Vdsm_for_PPC64#Testing_the_PPC64_support> |                                                                      |                       |                                   |
| ppc             | [Ability to run power machines on x86 hosts](Features/Vdsm for PPC64)                                                         | [ Vitor de Lima](User:vdelima)                  | Green                       | <http://www.ovirt.org/Features/Vdsm_for_PPC64#Testing_the_PPC64_support> |                                                                      |                       |                                   |
| ppc             | [Obtain capabilities of PPC64 hosts](Features/Vdsm for PPC64)                                                                 | [ Vitor de Lima](User:vdelima)                  | Green                       | <http://www.ovirt.org/Features/Vdsm_for_PPC64#Testing_the_PPC64_support> |                                                                      |                       |                                   |
| ppc             | [Obtain the CPU topology of PPC64 hosts](Features/Vdsm for PPC64)                                                             | [ Leonardo Bianconi](User:lbianco)              | Green                       | <http://www.ovirt.org/Features/Vdsm_for_PPC64#Testing_the_PPC64_support> |                                                                      |                       |                                   |
| ppc             | [Block migration in ppc64 Vms](Features/Engine support for PPC64)                                                             | [ Vitor de Lima](User:vdelima)                  | Under review                |                                                                          |                                                                      |                       |                                   |
| ppc             | [Block memory snapshots in ppc64 Vms](Features/Engine support for PPC64)                                                      | [ Leonardo Bianconi](User:lbianco)              | Under review                |                                                                          |                                                                      |                       |                                   |
| sla             | [positive/negative affinity between group of Vms](Features/VM-Affinity)                                                       | [ Gilad Chaplik](User:gchaplik)                 | Green                       |                                                                          | [ Antoni Segura Puimedon](User:apuimedo)                  |                       |                                   |
| sla             | [power saving policy powering off machines](Features/HostPowerManagementPolicy)                                               | [ Martin Sivák](User:msivak)                    | Green                       |                                                                          |                                                                      |                       |                                   |
| sla             | High Availability flag should be included when exporting/importing from Export Domain                                                    | [ Jiri Moskovcak](User:jmoskovc)                | Green                       |                                                                          |                                                                      |                       |                                   |
| sla             | [Even Distribution Policy by number of Vms](Features/Even VM Count Distribution)                                              | [ Jiri Moskovcak](User:jmoskovc)                | Green                       | <http://www.ovirt.org/Features/Even_VM_Count_Distribution#Testing>       |                                                                      |                       |                                   |
| sla             | [Make reservations for HA VMs to make sure there's enough capacity to start them if N hosts fail](Features/HA VM reservation) | [Kobi Ianko](User:kianku)                       | Green                       |                                                                          |                                                                      |                       |                                   |
| sla             | ovirt node support for hosted engine nodes                                                                                               |                                                            | Best effort, may slip       |                                                                          |                                                                      |                       |                                   |
| sla             | hosted engine on san                                                                                                                     | [ Greg Padgette](User:gpadgett)                 | Best effort, may slip       |                                                                          |                                                                      |                       |                                   |
| sla             | [Unify maintenance path of hosted engine with host maintenance](Features/Self Hosted Engine Maintenance Flows)                | [ Greg Padgette](User:gpadgett)                 | code                        |                                                                          |                                                                      |                       |                                   |
| sla             | [hosted engine on nfs](Hosted Engine Howto)                                                                                   | [ Greg Padgette](User:gpadgett)                 | Green                       |                                                                          |                                                                      |                       |                                   |
| storage         | [read only disks](Features/Read Only Disk)                                                                                    | [ Sergey Gotliv](User:sgotliv)                  | Green                       |                                                                          | [ Martin Perina](User:mperina) / F19                      | ,                     | Works for me                      |
| storage         | [single disk snapshots](Features/Single Disk Snapshot)                                                                        | [ Daniel Erez](User:Derez)                      | Green                       | <http://www.ovirt.org/Features/Single_Disk_Snapshot#Testing>             |                                                                      | , , , , , , ,         |                                   |
| storage         | Adding Disk to a VM which is not down adds a Disk that is not activated                                                                  | [Tal Nisan](User:tal)                           | Green                       |                                                                          |                                                                      |                       |                                   |
| storage         | [RFE] Handle iSCSI storage domain lun resize                                                                                             | [ Daniel Erez](User:Derez)                      | Green                       |                                                                          |                                                                      |                       |                                   |
| storage         | viable, ever-working vdsm functional tests                                                                                               | [Vered Volansky](User:vvolansk)                 | coding (90% complete)       |                                                                          |                                                                      |                       |                                   |
| storage         | [REQUESTING EXCEPTION] [stretch] multiple storage domains (local/shared)                                                                 | [Tal Nisan](User:tal)                           | merged upstream             |                                                                          |                                                                      |                       |                                   |
| storage         | [backup and restore api](Features/Backup-Restore API Integration)                                                             | [Liron Aravot](User:laravot)                    | Green (3.3.2)               |                                                                          |                                                                      |                       |                                   |
| storage         | iSCSI EqualLogic SAN support or use standard iscsi tools/configuration                                                                   | [ Sergey Gotliv](User:sgotliv)                  | Green                       |                                                                          |                                                                      |                       |                                   |
| storage         | Store OVF on any domains                                                                                                                 | [Liron Aravot](User:laravot)                    | code review (90% complete)  |                                                                          |                                                                      |                       |                                   |
| storage         | [Get rid of storage pool metadata on master storage domain](Features/StoragePool Metadata Removal)                            | [ Federico Simoncelli](User:Fsimonce)           | code review (90% complete)  | <http://www.ovirt.org/Features/StoragePool_Metadata_Removal#Testing>     |                                                                      |                       |                                   |
| storage         | allow importing glance image as a template                                                                                               | [ Oved Ourfalli](User:ovedo)                    | Green                       |                                                                          |                                                                      |                       |                                   |
| ux              | [centralizing refresh logic](Features/Design/UIRefreshSynchronization)                                                        | [Alexander Wels](User:awels)                    | Green                       |                                                                          |                                                                      |                       |                                   |
| ux              | case insensitive search                                                                                                                  | [ Oved Ourfalli](User:ovedo) (?)                | Green                       |                                                                          |                                                                      |                       |                                   |
| ux              | [webadmin's layout is broken when using resolution 1024 by 768](Features/Design/LowerResolutionSupport)                       | [Alexander Wels](User:awels)                    | Green                       | <http://www.ovirt.org/Features/Design/LowerResolutionSupport#Testing>    |                                                                      |                       |                                   |
| ux              | easily collapsible left-pane                                                                                                             | [Alexander Wels](User:awels)                    | Green                       |                                                                          |                                                                      |                       |                                   |
| virt            | [RFE] Allow searching by the description field                                                                                           | [ Adam Litke](User:Aglitke)                     | Green                       |                                                                          |                                                                      |                       |                                   |
| virt            | viable, ever-working vdsm functional tests                                                                                               | [ Martin Polednik](User:Martin Polednik)        | Partially                   |                                                                          |                                                                      |                       |                                   |
| virt            | [spice proxy at cluster/pool level](Features/Spice Proxy)                                                                     | [ Tomas Jelinek](User:tjelinek)                 | Green                       |                                                                          |                                                                      |                       |                                   |
| virt            | Save user's console setting per pool - enhancements in Display Console Dialog (persistence per pool)                                     | [Frank Kobzik](User:Fkobzik)                    | Green                       |                                                                          |                                                                      |                       |                                   |
| virt            | Make default VNC console mode configurable                                                                                               | [Frank Kobzik](User:Fkobzik)                    | Green                       |                                                                          |                                                                      |                       |                                   |
| virt            | [hotplug CPU](Hot plug cpu)                                                                                                   | [ Roy Golan](User:rgolan)                       | Green, backport in progress | <http://www.ovirt.org/Hot_plug_cpu#Testing>                              |                                                                      |                       |                                   |
| virt            | [cloud-init/sysprep customization, more options exposed, persistence](Features/vm-init-persistent)                            | [ Shahar Havivi](User:Shaharh)                  | Green, backport in progress |                                                                          |                                                                      |                       |                                   |
| virt            | Features/Guest Reboot | "reboot VM" functionality]]                                                                                      | [Martin Betak](User:Mbetak)                     | Green                       |                                                                          | [Alexander Wels](User:awels) / F19                        |                       |                                   |
| virt            | [template versions (ability to update template of a pool)](Features/Template Versions)                                        | [ Omer Frenkel](User:ofrenkel)                  | Orange - Work in Progress   | <http://www.ovirt.org/Features/Template_Versions#Testing>                |                                                                      |                       |                                   |
| virt            | [oVirt guest agent for Ubuntu](Feature/GuestAgentUbuntu)                                                                      | [ Vinzenz 'evilissimo' Feenstra](User:Vfeenstr) | Green                       | <http://www.ovirt.org/Feature/GuestAgentUbuntu#Testing>                  |                                                                      |                       |                                   |
| virt            | [oVirt guest agent for openSUSE](Feature/GuestAgentOpenSUSE)                                                                  | [ Vinzenz 'evilissimo' Feenstra](User:Vfeenstr) | Green                       | <http://www.ovirt.org/Feature/GuestAgentOpenSUSE#Testing>                |                                                                      |                       |                                   |
| virt            | [Allow to disable SSO per VM](Features/SSO Method Control)                                                                    | [Frank Kobzik](User:Fkobzik)                    | Green                       |                                                                          | [ Einav Cohen](User:ecohen) / F19                         |                       | works for me. more details in BZ. |
| virt            | qemu-ga installed by default on Linux                                                                                                    | [ Vinzenz 'evilissimo' Feenstra](User:Vfeenstr) | Green                       |                                                                          | [ Sandro Bonazzola](User:SandroBonazzola) / F19, F20, EL6 |                       | Works for me                      |
| virt            | add events for remote console connection                                                                                                 | [ Oved Ourfalli](User:ovedo)                    | Green                       |                                                                          | [Einav Cohen](User:ecohen) / F19                          |                       | works for me. more details in BZ. |
| virt            | Fix Control-Alt-Delete functionality in console options                                                                                  | [Frank Kobzik](User:Fkobzik)                    | Green                       |                                                                          | [Alexander Wels](User:awels) / F19                        |                       |                                   |
| virt            | Show name of the template in General tab for a vm if the vm is deployed from template via clone allocation                               | [ Tomas Jelinek](User:tjelinek)                 | Green                       |                                                                          | [Alexander Wels](User:awels) / F19                        |                       |                                   |
| virt            | [RFE] Track downtime for inactive VMs                                                                                                    | [ Adam Litke](User:Aglitke)                     | Green                       |                                                                          |                                                                      |                       |                                   |
| virt            | Set NIC boot order according to NIC names                                                                                                | [ Arik Hadas](User:Arik)                        | Green                       |                                                                          |                                                                      |                       |                                   |
| virt            | [RFE] RunOnce dialog can not set a vnc keymap itself                                                                                     | [Kobi Ianku](User:kianku)                       | Green                       |                                                                          |                                                                      |                       |                                   |
| virt            | [RFE] Enable configuration of maximum allowed downtime during live migration per guest                                                   | [Martin Betak](User:Mbetak)                     | Green                       |                                                                          |                                                                      |                       |                                   |

## Regression testing

### General

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

### Configuration

| Scenario                                                                                                                                                            | Bugs |
|---------------------------------------------------------------------------------------------------------------------------------------------------------------------|------|
| Configure high availability for virtual machines which are running mission critical workloads, so they will be restarted on another host if hardware failure occurs |      |
| Use the multi-level administration feature to assign different levels of user permissions                                                                           |      |
| Live Migration Scenarios                                                                                                                                            |      |
| Enable smartcard support for a VM and verify that the <smartcard mode="passthrough" type="spicevmc"/> is passed to libvirt                                          |      |

### Infra

| Scenario                                                                                                                                                                                   | Bugs |
|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------|
| Start vdsm-3.4 after fresh install over rhel 6.5\\rhel6.4\\fedora 19\\fedora 20 - check clear outputs and clear start - report in any misunderstanding of the startup process              |      |
| Upgrade from vdsm-3.3 to vdsm-3.4 after running with vdsm 3.3, same for downgrade from 3.4 to 3.3 - verify that libvirtd configured and started properly                                   |      |
| Check each vdsm-tool verbs of configurator module and its outputs - for misunderstanding of the output or the help instructions please report                                              |      |
| Add more that one domain using manage-domains. Check that login , search for users and groups is working. Check that a a user belonging to a group can login if the group has permissions. |      |

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

1.  **engine-iso-uploader list**
2.  **engine-iso-uploader upload <iso> -i <iso-domain-name> -v -f**

*   Basic operations on log-collector:

1.  **engine-log-collector list**
2.  **engine-log-collector collect**

*   Basic operation on image-uploader

**engine-image-uploader --name=<new name here> -e <domain> upload my.ovf**

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

### SLA

| Scenario                                                                                        | Steps                                                                                                                                                                  | Bugs |
|-------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------|
| power saving policy powering off machines                                                       | Step 1: Setup a cluster with at least two hosts including power management for both of them                                                                            |      |
|                                                                                                 | Step 2: Edit cluster and set Power saving as the cluster policy                                                                                                        |      |
|                                                                                                 | Step 3: Add hosts_in_reserve and enable_autopm parameters to the policy and set them to 1 and true                                                                  |      |
|                                                                                                 | Step 4: Wait for some time and you should see one of the hosts go to maintenance and after another minute or so move to Down                                           |      |
|                                                                                                 | Step 5: Start a VM                                                                                                                                                     |      |
|                                                                                                 | Step 6: The host from step 4 should move to Unresponsive and and then to Up state. Both transitions take at least a minute so be patient.                              |      |
|                                                                                                 | Verify: Repeat steps 4-6 but do not let the host shut down, start the VM when the host is in Maintenance, it should come up again                                      |      |
|                                                                                                 | Verify: a) The SPM won't shut down b) there is always hosts_in_reserve hosts with no VMs or the cluster is using all the hosts                                       |      |
|                                                                                                 | Verify: With the auto_pm set to false in cluster policy, no host is shut down                                                                                         |      |
|                                                                                                 | Verify: Disabling the automatic PM in the Host's power management tab keeps the host Up, but still counts it into the number of free hosts if there are no VMs running |      |
|                                                                                                 | Verify: Host that was put to maintenance manually won't come up when the policy needs to wake up additional host                                                       |      |
| High Availability flag should be included when exporting/importing from Export Domain           | Step 1:Have a VM marked as highly available.                                                                                                                           |      |
|                                                                                                 | Step 2: export the VM                                                                                                                                                  |      |
|                                                                                                 | Step 3: rename the original VM                                                                                                                                         |      |
|                                                                                                 | Step 4: import the VM from step (2)                                                                                                                                    |      |
|                                                                                                 | Step 5: Verify the imported VM is defined as highly available                                                                                                          |      |
| Even Distribution Policy by number of VMs                                                       | Step 1: Create a cluster with at least 1 host                                                                                                                          |      |
|                                                                                                 | Step 2: Set the VM_Evenly_Distributed as a cluster policy                                                                                                            |      |
|                                                                                                 | Step 3: Add another host to the cluster                                                                                                                                |      |
|                                                                                                 | Step 4: After a while check if the VMs are evenly distributed to all hosts in the cluster (please note that one host is SPM and should have less VMs)                  |      |
| Make reservations for HA VMs to make sure there's enough capacity to start them if N hosts fail | Step 1: have 2 hosts and 2 running VMs on one of them.                                                                                                                 |      |
|                                                                                                 | Step 2: Edit cluster policy and set HA reservations to "on"                                                                                                            |      |
|                                                                                                 | Step 3: turn off the empty host. This should trigger an alert within ~3 minutes about HA capacity.                                                                     |      |

#### Affinity Groups

<http://www.ovirt.org/Features/VM-Affinity>

| Scenario                                   | Steps                                    | Bugs |
|--------------------------------------------|------------------------------------------|------|
| affinity group CRUD commands               | CRUD via webadmin                        |      |
|                                            | CRUD via REST API                        |      |
| implicitly remove VM from affinity group   | delete VM                                |      |
|                                            | change VM cluster                        |      |
| run/migrate VM                             | hard enforcing, positive affinity        |      |
|                                            | soft enforcing, positive affinity        |      |
|                                            | hard enforcing, negative affinity        |      |
|                                            | soft enforcing, negative affinity        |      |
| VM in several affinity groups (transitive) | all positive - hard enforcing            |      |
|                                            | all negative - hard enforcing            |      |
|                                            | mixed positive negative - hard enforcing |      |
|                                            | mixed hard/soft enforcing                |      |

## Bug Reporting

*   ovirt - <https://bugzilla.redhat.com/enter_bug.cgi?product=oVirt>
*   Spice - <https://bugs.freedesktop.org/> under Spice product
*   VDSM - <https://bugzilla.redhat.com/enter_bug.cgi?product=oVirt> with vdsm component

Tracker bug for the release - <https://bugzilla.redhat.com/1024889>
