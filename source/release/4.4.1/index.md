---
title: oVirt 4.4.1.1 Release Notes
category: documentation
authors: sandrobonazzola lveyde
toc: true
page_classes: releases
---

# oVirt 4.4.1.1 Release Notes

The oVirt Project is pleased to announce the availability of the 4.4.1.1 release as of July 13, 2020.

oVirt is a free open-source distributed virtualization solution,
designed to manage your entire enterprise infrastructure.
oVirt uses the trusted KVM hypervisor and is built upon several other community
projects, including libvirt, Gluster, PatternFly, and Ansible.

This release is available now for Red Hat Enterprise Linux 8.2 and
CentOS Linux 8.2 (or similar).

To find out how to interact with oVirt developers and users and ask questions,
visit our [community page]"(/community/).
All issues or bugs should be reported via
[Red Hat Bugzilla](https://bugzilla.redhat.com/enter_bug.cgi?classification=oVirt).

If you'd like to try oVirt as quickly as possible, follow the instructions on
the [Download](/download/) page.

For complete installation, administration, and usage instructions, see
the [oVirt Documentation](/documentation/).

For a general overview of oVirt, read the [About oVirt](/community/about.html)
page.

To learn about features introduced before 4.4.1, see the
[release notes for previous versions](/documentation/#previous-release-notes).



## What's New in 4.4.1?

### Release Note

#### oVirt Release Package

 - [BZ 1844389](https://bugzilla.redhat.com/1844389) **CentOS Stream release rpm**

   CentOS Stream can now be used as an alternative to CentOS Linux on non production systems.


#### oVirt Engine

 - [BZ 1838159](https://bugzilla.redhat.com/1838159) **[RFE] Upgrade apache-sshd to 2.5.0 to allow RSA-SHA256 and RSA-SHA512 public keys**

   It's possible to add hosts, which don't provide classic rsa-sha-1 SSH public keys, but provide only rsa-sha256/rsa-sha-512 SSH public keys (for example CentOS 8 hosts with FIPS hardening enabled), to oVirt Engine.


#### oVirt Engine WildFly

 - [BZ 1830951](https://bugzilla.redhat.com/1830951) **Rebase on Wildfly 19.1**

   oVirt Engine is now running on WildFly 19.1.0.FINAL


### Enhancements

#### oVirt Engine

 - [BZ 1477049](https://bugzilla.redhat.com/1477049) **[RFE] [New UI - New setup networks dialog] - Add 'Unmanaged' network icon to the front NIC panel**

   Feature: In the NIC list dialog of the host, indicate on each NIC whether one of its networks is unmanaged by oVirt engine.



Reason: To view this indication the user had to open the setup dialog which is cumbersome.



Result: unmanaged networks are viewable by the user on the host NICs page at a glance.

 - [BZ 1806339](https://bugzilla.redhat.com/1806339) **In Admin Portal, "Huge Pages (size: amount)" needs to be clarified**

   Feature: Changed the Huge Pages label to say Free Huge Pages



Reason: For more clarity so that the user can understand the values.



Result: The functionality is more user friendly.

 - [BZ 1763812](https://bugzilla.redhat.com/1763812) **[RFE] Move the Remove VM button to the drop down menu when viewing details such as snapshots**

   Feature: Moved the VM remove button to the more button's drop down menu.



Reason: For usability. Many users would press the remove VM in a details tab view thinking that it would just remove the detailed item. Instead it deleted the VM itself.



Result: The user now has to press the more drop down button to delete the VM, but it should be less confusing as to which button to use when attempting to remove a detail such as a snapshot.

 - [BZ 1768937](https://bugzilla.redhat.com/1768937) **[RFE] [UI] Copy host networking from one host to another**

   Feature: Provide a means of invoking the copy host networks functionality from the web-admin portal. A button to invoke the action was added to the all hosts and single host pages.



Reason: This functionality should be available from the web-admin as all othe oVirt-engine functionality.



Result: User can invoke a copy host networks action from the web-admin.

 - [BZ 1841083](https://bugzilla.redhat.com/1841083) **bump up max memory limit to 6TB**

   In 4.4 the maximum memory size for 64bit x86_64 and ppc64/ppc64le VMs is now 6TB. For x86_64 this limit is applied also to VMs in 4.2 and 4.3 Cluster Levels.

 - [BZ 1679730](https://bugzilla.redhat.com/1679730) **Warn about host IP addresses outside range**

   Feature: 

Add audit log warning on an out of range IPv4 gateway static configuration for a host NIC. The validity of the gateway is assessed compared to the configured IP address and netmask.



Reason: A bad configuration is sometimes difficult to detect and may go unnoticed.



Result: Better feedback to the user


#### oVirt Engine Data Warehouse

 - [BZ 1848381](https://bugzilla.redhat.com/1848381) **[RFE] Add description panel to all oVirt dashboards**

   Feature: Description panels 



Reason: Explain to the user what reports are presented and what their purpose is.



Result: Text that explains the reports, on each dashboard and at the beginning of the page


#### oVirt Ansible hosted-engine setup role

 - [BZ 1828888](https://bugzilla.redhat.com/1828888) **Copy disk task risky and not optimal**

   

 - [BZ 1828892](https://bugzilla.redhat.com/1828892) **Add qemu-img compare task to verify disk copy**

   Feature: Add compare task in debug mode to verify that image copied successfully to the storage domain



Reason: To verify the image copied successfully 



Result: Task should succeed if the copy of the image succeeds


#### oVirt Engine UI Extensions

 - [BZ 1768937](https://bugzilla.redhat.com/1768937) **[RFE] [UI] Copy host networking from one host to another**

   Feature: Provide a means of invoking the copy host networks functionality from the web-admin portal. A button to invoke the action was added to the all hosts and single host pages.



Reason: This functionality should be available from the web-admin as all othe oVirt-engine functionality.



Result: User can invoke a copy host networks action from the web-admin.


### Known Issue

#### oVirt Engine Data Warehouse

 - [BZ 1846256](https://bugzilla.redhat.com/1846256) **SSO allows all engine users to login to grafana**

   Doc team: Please check the "Additional Info" part of the description and decide what's the best way to publish this. Perhaps a new doc bug to include this in the documentation, or a release notes item (for current bug?), or something else.


### Bug Fixes

#### oVirt Engine

 - [BZ 1820140](https://bugzilla.redhat.com/1820140) **Hosted Engine VM can get memory hotplug to more than the physically available RAM**

 - [BZ 1783337](https://bugzilla.redhat.com/1783337) **Rename tools does not renew certificates and engine config for websocket**

 - [BZ 1501798](https://bugzilla.redhat.com/1501798) **Provide solution to make OVN provider working after ovirt-engine-rename**

 - [BZ 1807937](https://bugzilla.redhat.com/1807937) **[4.4] run-once with wrong configuration failed to start VM but then starts the VM with its persistent configuration**

 - [BZ 1834523](https://bugzilla.redhat.com/1834523) **Edit VM -> Enable Smartcard sharing does not stick when VM is running**

 - [BZ 1819299](https://bugzilla.redhat.com/1819299) **Cannot access VM console after previewing and committing a snapshot**

 - [BZ 1850220](https://bugzilla.redhat.com/1850220) **Backward compatibility of vm devices monitoring**

 - [BZ 1573600](https://bugzilla.redhat.com/1573600) **Handle registering of a VM with snapshots containing memory disks correctly**

 - [BZ 1847513](https://bugzilla.redhat.com/1847513) **[UPGRADE] failed to change the cluster compatibility version from 4.3 > 4.4 while VMs running on the cluster.**

 - [BZ 1819960](https://bugzilla.redhat.com/1819960) **NPE on ImportVmTemplateFromConfigurationCommand when creating VM from ovf_data**

 - [BZ 1845473](https://bugzilla.redhat.com/1845473) **Exporting an OVA file from a VM results in its ovf file having a format of RAW when the disk is COW**

 - [BZ 1838493](https://bugzilla.redhat.com/1838493) **Live snapshot made with freeze in the engine will cause the FS to be frozen**

 - [BZ 1839967](https://bugzilla.redhat.com/1839967) **Error encountered when running ovirt-engine-rename**

 - [BZ 1838439](https://bugzilla.redhat.com/1838439) **After editing 4.2 cluster properties it isn't possible to create 4.2 VM in the cluster**

 - [BZ 1837460](https://bugzilla.redhat.com/1837460) **grafana is not backed up**

 - [BZ 1832905](https://bugzilla.redhat.com/1832905) **engine-backup --mode=verify is broken**


#### VDSM

 - [BZ 1849275](https://bugzilla.redhat.com/1849275) **[SR-IOV] [i40e] SR-IOV information is missing because of 'block_path is None'**

 - [BZ 1612152](https://bugzilla.redhat.com/1612152) **[GSS] Crashes in glusterVdoVolumeList seen in messages file.**

 - [BZ 1835096](https://bugzilla.redhat.com/1835096) **Snapshot reports as 'done' even though it failed (due to I/O error)**


#### oVirt Hosted Engine Setup

 - [BZ 1634742](https://bugzilla.redhat.com/1634742) **HE cleanup code is not cleaning libvirt.qemu.conf correctly and HE can't be redeployed**


#### oVirt Ansible hosted-engine setup role

 - [BZ 1843089](https://bugzilla.redhat.com/1843089) **virsh storage pools from HE deployments are not cleaned up**


### Other

#### oVirt Release Package

 - [BZ 1845670](https://bugzilla.redhat.com/1845670) **Cannot use any element on oVirt Node cockpit login page**

   


#### oVirt Engine

 - [BZ 1853894](https://bugzilla.redhat.com/1853894) **Dashboard is broken and not visible on latest rhvm-4.4.1.7-0.3.el8ev.noarch**

   

 - [BZ 1834698](https://bugzilla.redhat.com/1834698) **SCSI Hostdev Passthrough: SCSI SD moved to inactive when running VM with bootable scsi_hostdev**

   

 - [BZ 1770893](https://bugzilla.redhat.com/1770893) **Manager shows successful upgrade even when upgrade failed in imgbased**

   

 - [BZ 1820208](https://bugzilla.redhat.com/1820208) **Integer field stays in incorrect value state after correcting the value**

   

 - [BZ 1850103](https://bugzilla.redhat.com/1850103) **OVA exported from oVirt contains InstanceId instead of InstanceID tags**

   

 - [BZ 1846954](https://bugzilla.redhat.com/1846954) **Can't power on guest on rhv4.4 after v2v conversion because of unmatched machine type**

   

 - [BZ 1846375](https://bugzilla.redhat.com/1846375) **[RFE] Include a link to grafana on front page**

   

 - [BZ 1842253](https://bugzilla.redhat.com/1842253) **[ALL_LANG] Compute - Virtual Machines - Console - Console Options : no margin on left side of Dialog box**

   

 - [BZ 1852040](https://bugzilla.redhat.com/1852040) **After 4.3 to 4.4 upgrade it's impossible to create new VMs in existing clusters**

   

 - [BZ 1830872](https://bugzilla.redhat.com/1830872) **In UI HE reports for pending CPU type changes after restart, but they never happen.**

   

 - [BZ 1851708](https://bugzilla.redhat.com/1851708) **Download template disk with format="raw" fails**

   

 - [BZ 1522926](https://bugzilla.redhat.com/1522926) **[RFE] Integrate lvm filter configuration in vdsm-tool configure step**

   

 - [BZ 1850909](https://bugzilla.redhat.com/1850909) **[HE] Update migration-encryption option to be editable for HE-VM**

   

 - [BZ 1839511](https://bugzilla.redhat.com/1839511) **WebAdmin UI - remove unregistered entities from attached storage domain - entities list not refreshed after removal**

   

 - [BZ 1830705](https://bugzilla.redhat.com/1830705) **Last modified value is 'Jan 1, 1970' for disks other then OVF**

   

 - [BZ 1843842](https://bugzilla.redhat.com/1843842) **Error getting info for CPU ' ', not in expected format. during engine start**

   

 - [BZ 1845458](https://bugzilla.redhat.com/1845458) **Write effective bios type to exported vms/templates**

   

 - [BZ 1826316](https://bugzilla.redhat.com/1826316) **Memory Balloon optimization is not enable by default on new created clusters.**

   

 - [BZ 1835520](https://bugzilla.redhat.com/1835520) **Right-click menu offset too far**

   

 - [BZ 1846331](https://bugzilla.redhat.com/1846331) **[scale] DataCenter become 'Non responsive'  and host have no SPM**

   

 - [BZ 1642469](https://bugzilla.redhat.com/1642469) **Grammar and spelling bugs in Admin Portal**

   

 - [BZ 1828282](https://bugzilla.redhat.com/1828282) **Inconsistent terms for login, log out, sign out, etc.**

   

 - [BZ 1832181](https://bugzilla.redhat.com/1832181) **vNIC is added to a running VM while the network is not attached on the host if specifying network filters**

   

 - [BZ 1844797](https://bugzilla.redhat.com/1844797) **Can't extend a managed block disk**

   

 - [BZ 1575542](https://bugzilla.redhat.com/1575542) **date/time selectors in volume snapshot's schedule doesn't work**

   

 - [BZ 1839398](https://bugzilla.redhat.com/1839398) **Configuring HP type by Rest API doesn't set headless mode. In PPC arch such VM fails on start**

   

 - [BZ 1780910](https://bugzilla.redhat.com/1780910) **Using "Ignore OVF update failure" on maintenance puts SD into Inactive state**

   

 - [BZ 1704349](https://bugzilla.redhat.com/1704349) **glance integration with recent RDO is not working**

   

 - [BZ 1842004](https://bugzilla.redhat.com/1842004) **Addition of IPV6 hosts to hyperconverged cluster fails**

   

 - [BZ 1624732](https://bugzilla.redhat.com/1624732) **Installing a Websocket Proxy on a Separate Machine fails on el8**

   

 - [BZ 1837911](https://bugzilla.redhat.com/1837911) **Can't edit a LUN disk attached to a VM from the VM->Disks screen**

   

 - [BZ 1826454](https://bugzilla.redhat.com/1826454) **When accessing any type of console error "Sorry, VM Portal is currently having some issues"**

   

 - [BZ 1827065](https://bugzilla.redhat.com/1827065) **Export VM to data domain with low space on source domain to different dest domain is not possible when it should.**

   

 - [BZ 1662733](https://bugzilla.redhat.com/1662733) **Webadmin- Download 2 disks on a running VM fails but only 1 disk is shown in the error message**

   

 - [BZ 1828299](https://bugzilla.redhat.com/1828299) **Export VM to a data domain with illegal disks succeeded when it should fail**

   

 - [BZ 1707707](https://bugzilla.redhat.com/1707707) **Ovirt: Can't upload Disk Snapshots with size >1G to iSCSI storage using Java/Python SDK**

   

 - [BZ 1826348](https://bugzilla.redhat.com/1826348) **[Incremental backup] Full backup during live disk migration should not be allowed**

   

 - [BZ 1832828](https://bugzilla.redhat.com/1832828) **Serial number provided is ignored**

   


#### VDSM

 - [BZ 1841076](https://bugzilla.redhat.com/1841076) **vdsm should use the switch '--inet6' for querying gluster volume info with '--remote-host'**

   

 - [BZ 1522926](https://bugzilla.redhat.com/1522926) **[RFE] Integrate lvm filter configuration in vdsm-tool configure step**

   

 - [BZ 1840609](https://bugzilla.redhat.com/1840609) **Wake up from hibernation failed:internal error: unable to execute QEMU command 'cont': Failed to get "write" lock.**

   

 - [BZ 1842894](https://bugzilla.redhat.com/1842894) **[4.4] Can't delete snapshot with memory (after review & commit) in case of multiple snapshots**

   

 - [BZ 1837199](https://bugzilla.redhat.com/1837199) **[scale] LVM metadata reload failures are breaking volume creation and deletion**

   

 - [BZ 1694972](https://bugzilla.redhat.com/1694972) **Reading same image on block storage concurrently using vdsm HTTP server may fail one of the requests**

   

 - [BZ 1846331](https://bugzilla.redhat.com/1846331) **[scale] DataCenter become 'Non responsive'  and host have no SPM**

   

 - [BZ 1842767](https://bugzilla.redhat.com/1842767) **Unable to call volumeEmptyCheck in vdsm-gluster due to errors in vdsm-gluster**

   

 - [BZ 1841030](https://bugzilla.redhat.com/1841030) **RHV upgrade for 4.3 to 4.4 fails for IBRS CPU type**

   

 - [BZ 1557147](https://bugzilla.redhat.com/1557147) **No efficient api method to collect metadata of all volumes from sd**

   

 - [BZ 1814022](https://bugzilla.redhat.com/1814022) **Suppress safe LVM warnings on RHEL 8.2**

   

 - [BZ 1704349](https://bugzilla.redhat.com/1704349) **glance integration with recent RDO is not working**

   

 - [BZ 1810974](https://bugzilla.redhat.com/1810974) **ipmilan fencing fails with JSON-RPC error when password contains space**

   

 - [BZ 1690485](https://bugzilla.redhat.com/1690485) **vdsm should send events on dhcpv4 and dhcpv6 success to engine**

   

 - [BZ 1832967](https://bugzilla.redhat.com/1832967) **Uploading images from glance may delay sanlock I/O and cause sanlock operations to fail**

   


#### cockpit-ovirt

 - [BZ 1848588](https://bugzilla.redhat.com/1848588) **Error while attaching the lvmcache to LUKS device thinpool**

   

 - [BZ 1676582](https://bugzilla.redhat.com/1676582) **hosted-engine --deploy uses inconsistent storage units (uses both GiB and GB)**

   

 - [BZ 1847504](https://bugzilla.redhat.com/1847504) **Error when expanding the volume from Web Console**

   

 - [BZ 1847607](https://bugzilla.redhat.com/1847607) **Unable to input values into deployment wizard for cluster expansion from cockpit**

   

 - [BZ 1848052](https://bugzilla.redhat.com/1848052) **Wizard closes with error when attempting for create volume from cockpit**

   

 - [BZ 1688245](https://bugzilla.redhat.com/1688245) **Gluster IPV6 storage domain requires additional mount options**

   

 - [BZ 1832822](https://bugzilla.redhat.com/1832822) **Cockpit: Blacklist list in inventory file entering empty fields**

   

 - [BZ 1833879](https://bugzilla.redhat.com/1833879) **"Installation Guide" and "RHV Documents" didn't jump to the correct pages.**

   


#### oVirt Host Dependencies

 - [BZ 1836026](https://bugzilla.redhat.com/1836026) **Add pkgs required by STIG**

   


#### oVirt imageio

 - [BZ 1851707](https://bugzilla.redhat.com/1851707) **Failed to add image ticket to ovirt-imageio-proxy: Connection refused**

   

 - [BZ 1591439](https://bugzilla.redhat.com/1591439) **[RFE] [v2v] - imageio performance - concurrent I/O**

   

 - [BZ 1839400](https://bugzilla.redhat.com/1839400) **[RFE] Support fallback to proxy_url if transfer_url is not accessible**

   

 - [BZ 1836858](https://bugzilla.redhat.com/1836858) **[v2v] Improve performance when using small requests**

   

 - [BZ 1835719](https://bugzilla.redhat.com/1835719) **[RFE] support showing parsed configuration**

   


#### oVirt Setup Lib

 - [BZ 1854324](https://bugzilla.redhat.com/1854324) **Add 'Abort' option after warning messages during installation**

   

 - [BZ 1840756](https://bugzilla.redhat.com/1840756) **An endless loop occurs when using autoAcceptDefault=True**

   


#### oVirt Hosted Engine Setup

 - [BZ 1840756](https://bugzilla.redhat.com/1840756) **An endless loop occurs when using autoAcceptDefault=True**

   


#### oVirt Engine Data Warehouse

 - [BZ 1852405](https://bugzilla.redhat.com/1852405) **[RFE] Update trend dashboard to use hourly and daily tables**

   

 - [BZ 1852390](https://bugzilla.redhat.com/1852390) **[RFE] Bug in Trend Dashboard queries**

   

 - [BZ 1849965](https://bugzilla.redhat.com/1849965) **Update inventory dashboard descriptions and indentation**

   

 - [BZ 1848613](https://bugzilla.redhat.com/1848613) **Update service level dashboard descriptions and indentation**

   

 - [BZ 1849423](https://bugzilla.redhat.com/1849423) **Update trend dashboard descriptions and indentation**

   

 - [BZ 1848435](https://bugzilla.redhat.com/1848435) **Update executive dashboard descriptions and indentation**

   

 - [BZ 1845049](https://bugzilla.redhat.com/1845049) **configure engine for showing  link to grafana instance in ovirt landing page**

   


#### oVirt Node NG Image

 - [BZ 1838926](https://bugzilla.redhat.com/1838926) **ovirt-node-ng-image CI broken due to c, network is not active**

   


#### oVirt Hosted Engine HA

 - [BZ 1850117](https://bugzilla.redhat.com/1850117) **Python error - a bytes-like object is required, not 'str' -  seen when trying to set hosted-engine shared config for storage**

   

 - [BZ 1832732](https://bugzilla.redhat.com/1832732) **unneeded  sudoers configuration for  vdsm  and sanlock  service control**

   


#### oVirt Engine UI Extensions

 - [BZ 1853894](https://bugzilla.redhat.com/1853894) **Dashboard is broken and not visible on latest rhvm-4.4.1.7-0.3.el8ev.noarch**

   


### No Doc Update

#### oVirt Engine

 - [BZ 1853495](https://bugzilla.redhat.com/1853495) **[CodeChange][i18n] oVirt 4.4 webadmin - translation update (July-2020)**

   

 - [BZ 1827179](https://bugzilla.redhat.com/1827179) **Missing "Enable VNC Encryption" in cluster API**

   

 - [BZ 1801709](https://bugzilla.redhat.com/1801709) **Disable activation of the host while Enroll certificate flow is still in progress**

   

 - [BZ 1764959](https://bugzilla.redhat.com/1764959) **Apache is configured to offer TRACE method (security)**

   

 - [BZ 1847880](https://bugzilla.redhat.com/1847880) **The PCI controller with index='0' must be model='pci-root' for this machine type, but model='pcie-root' was found instead**

   

 - [BZ 1057575](https://bugzilla.redhat.com/1057575) **From GuideMe link, adding Host using SSH PublicKey Authentication fails with "Error while executing action: Cannot install Host with empty password."**

   

 - [BZ 1849409](https://bugzilla.redhat.com/1849409) **video device is missing**

   

 - [BZ 1844911](https://bugzilla.redhat.com/1844911) **[CinderLib] - The creation of MBD with 3PAR-ISCSI driver fails with several errors in CinderLib log**

   

 - [BZ 1843933](https://bugzilla.redhat.com/1843933) **Block updates of Kubevirt VMs from oVirt edit VM dialog**

   

 - [BZ 1844270](https://bugzilla.redhat.com/1844270) **[vGPU] nodisplay option for mdev broken since mdev scheduling unit**

   

 - [BZ 1814212](https://bugzilla.redhat.com/1814212) **Convert existing oVirt engine extensions configuration files to the new content required by oVirt engine 4.4**

   

 - [BZ 1839076](https://bugzilla.redhat.com/1839076) **engine-vacuum on nonexistent table returns 0**

   

 - [BZ 1842495](https://bugzilla.redhat.com/1842495) **high cpu usage after entering wrong search pattern in RHVM**

   

 - [BZ 1846212](https://bugzilla.redhat.com/1846212) **After grafana setup, if next engine-setup fails, rollback fails**

   

 - [BZ 1828669](https://bugzilla.redhat.com/1828669) **After SPM select the engine lost communication to all hosts until restarted [improved logging]**

   

 - [BZ 1844822](https://bugzilla.redhat.com/1844822) **DiskCopy: IllegalStateException: No default constructor for collection type**

   

 - [BZ 1833770](https://bugzilla.redhat.com/1833770) **Getting "WebSocket Proxy certificate signed successfully" log message when it actually fails**

   

 - [BZ 1835586](https://bugzilla.redhat.com/1835586) **ansible-runner-service.log is in /var/lib**

   

 - [BZ 1839676](https://bugzilla.redhat.com/1839676) **Run engine-setup with answerfile fails on "rollback failed: cannot use a string pattern on a bytes-like object"**

   

 - [BZ 1538649](https://bugzilla.redhat.com/1538649) **[RFE] [UI] - Add right click menu to VM's vNIC panel**

   

 - [BZ 1782279](https://bugzilla.redhat.com/1782279) **Warning message for low space is not received on Imported Storage domain**

   

 - [BZ 1828931](https://bugzilla.redhat.com/1828931) **engine-vacuum fails with permission denied for schema pg_temp_23**

   


#### VDSM

 - [BZ 1821627](https://bugzilla.redhat.com/1821627) **Creation of live snapshot of VM wirh RO disk fails - external snapshot for readonly disk sda is not supported**

   


#### cockpit-ovirt

 - [BZ 1786556](https://bugzilla.redhat.com/1786556) **cockpit hosted-engine log files' timestamp is misleading**

   

 - [BZ 1833412](https://bugzilla.redhat.com/1833412) **cockpit-ovirt page has some branding glitches**

   


#### imgbased

 - [BZ 1827232](https://bugzilla.redhat.com/1827232) **[RHVH 4.4] sometimes when defining 2 sizes of huge pages the parameters order changed and all memory occupied by the huge pages.**

   


#### oVirt Engine Data Warehouse

 - [BZ 1846870](https://bugzilla.redhat.com/1846870) **SSO after setup of grafana on separate machine fails**

   

 - [BZ 1814643](https://bugzilla.redhat.com/1814643) **[RFE] Configure Grafana for oVirt DWH**

   


#### oVirt Engine Appliance

 - [BZ 1718873](https://bugzilla.redhat.com/1718873) **Hosted Engine install removes rhvm-appliance, therefore purges system of RHV at end of hosted-engine install**

   

 - [BZ 1822535](https://bugzilla.redhat.com/1822535) **Hosted-engine restore from file fails when there are VM's having snapshots with old compatibility levels.**

   


#### oVirt Engine UI Extensions

 - [BZ 1853427](https://bugzilla.redhat.com/1853427) **[CodeChange][i18n] oVirt 4.4 ui-extensions - translation update (July-2020)**

   

 - [BZ 1843933](https://bugzilla.redhat.com/1843933) **Block updates of Kubevirt VMs from oVirt edit VM dialog**

   


#### Contributors

64 people contributed to this release:

	Ahmad Khiet
	Ales Musil
	Amit Bawer
	Andrej Cernek
	Arik Hadas
	Artur Socha
	Asaf Rachmani
	Aviv Litman
	Aviv Turgeman
	Bell Levin
	Bella Khizgiyev
	Benny Zlotnik
	Dana Elfassy
	Daniel Erez
	Denis Chaplygin
	Dominik Holler
	Douglas Schilling Landgraf
	Eitan Raviv
	Eli Mesika
	Evgeny Slutsky
	Eyal Shenitzky
	Fedor Gavrilov
	Gal Zaidman
	Gal-Zaidman
	Germano Veit Michel
	Gobinda Das
	Hilda Stastna
	Kaustav Majumder
	Lev Veyde
	Liran Rotenberg
	Lucia Jelinkova
	Marcin Sobczyk
	Martin Necas
	Martin Perina
	Martin Peřina
	Michal Skrivanek
	Milan Zamazal
	Nijin Ashok
	Nir Levy
	Nir Soffer
	Ondra Machacek
	Ori Liel
	Pavel Bar
	Prajith Kesava Prasad
	Radoslaw Szwajkowski
	Ritesh Chikatwar
	Sandro Bonazzola
	Scott Dickerson
	Scott J Dickerson
	Shani Leviim
	Sharon Gratch
	Shirly Radco
	Shmuel Melamud
	Steve Goodman
	Steven Rosenberg
	Tal Nisan
	Tomáš Golembiovský
	Vojtech Juranek
	Yedidyah Bar David
	Yotam Fromm
	Yuval Turgeman
	bamsalem
	eslutsky
	parthdhanjal
