---
title: oVirt 4.2.3 Release Notes
category: documentation
toc: true
page_classes: releases
---

# oVirt 4.2.3 Release Notes

The oVirt Project is pleased to announce the availability of the 4.2.3 release as of May 04, 2018.

oVirt is a free open-source distributed virtualization solution,
designed to manage your entire enterprise infrastructure.
oVirt uses the trusted KVM hypervisor and is built upon several other community
projects, including libvirt, Gluster, PatternFly, and Ansible.

This release is available now for Red Hat Enterprise Linux 7.5,
CentOS Linux 7.5 (or similar).

If you'd like to try oVirt as quickly as possible, follow the instructions on
the [Download](/download/) page.

For complete installation, administration, and usage instructions, see
the [oVirt Documentation](/documentation/).

For a general overview of oVirt, read the [About oVirt](/community/about.html)
page.

To learn about features introduced before 4.2.3, see the [release notes for previous versions](/documentation/#previous-release-notes).

## CVE-2018-3639 - Important - oVirt - Speculative Store Bypass

As you may have already heard, an industry-wide issue was found in the way
many modern microprocessor designs have implemented speculative execution
of Load & Store instructions.
This issue is well described by CVE-2018-3639 announce available at
[https://access.redhat.com/security/cve/cve-2018-3639](https://access.redhat.com/security/cve/cve-2018-3639).

oVirt team has released on May 23th an update of ovirt-engine to version
4.2.3.7 which add support for SSBD CPUs in order to mitigate the security
issue.

If you are running oVirt on Red Hat Enterprise Linux, please apply updates
described in [https://access.redhat.com/security/cve/cve-2018-3639](https://access.redhat.com/security/cve/cve-2018-3639).

If you are running oVirt on CentOS Linux please apply updates described by:
- [CESA-2018:1629 Important CentOS 7 kernel Security Update](https://lists.centos.org/pipermail/centos-announce/2018-May/022843.html)
- [CESA-2018:1632 Important CentOS 7 libvirt Security Update](https://lists.centos.org/pipermail/centos-announce/2018-May/022840.html)
- [CESA-2018:1649 Important CentOS 7 java-1.8.0-openjdk Security Update](https://lists.centos.org/pipermail/centos-announce/2018-May/022839.html)
- [CESA-2018:1648 Important CentOS 7 java-1.7.0-openjdk Security Update](https://lists.centos.org/pipermail/centos-announce/2018-May/022838.html)

An update for qemu-kvm-ev has been also tagged for release and announced
with [CESA-2018:1655 Important: qemu-kvm-ev security update](https://lists.centos.org/pipermail/centos-virt/2018-May/005804.html)

If you're running oVirt on a different Linux distribution, please check
with your vendor for available updates.

Please note that to fully mitigate this vulnerability, system
administrators must apply both hardware “microcode” updates and software
patches that enable new functionality.
At this time, microprocessor microcode will be delivered by the individual
manufacturers.

The oVirt team recommends end users and systems administrator to apply any
available updates as soon as practical.


### No Fedora support

Regretfully, Fedora is not supported anymore, and RPMs for it are not provided.
At this point, we only try to fix problems specific to Fedora if they affect
developers. For some of the work to be done to restore support for Fedora, see
also tracker [bug 1460625](https://bugzilla.redhat.com/showdependencytree.cgi?id=1460625&hide_resolved=0).

### EPEL

Don't enable all of EPEL on oVirt machines.

The ovirt-release package enables the EPEL repositories and includes several
specific packages that are required from there. It also enables and uses
the CentOS SIG repos, for other packages.

If you want to use other packages from EPEL, you should make sure to
use `includepkgs` and add only those you need avoiding to override
packages from other repos.

## What's New in 4.2.3?

### Enhancements

#### oVirt Engine

 - [BZ 1550135](https://bugzilla.redhat.com/1550135) <b>Failed logging attempts are not audited / logged</b><br>Failed login attempts now appear in the audit log, with details and the user name that failed to log in.
 - [BZ 1540955](https://bugzilla.redhat.com/1540955) <b>The Affinity Positive/Negative Value is not updated in the UI window</b><br>The host to VM affinity can now be explicitly disabled, as described in Bug 1493149.<br><br>This change adds 4 new columns to the affinity group table in the UI:<br>- 'vm polarity' - Shows if the VM affinity is positive, negative or disabled<br>- 'vm enforcing' - Shows if the VM affinity is enforcing or not<br>- 'host polarity' - Shows if the VM to host affinity is positive, negative or disabled<br>- 'host enforcing' - Shows if the VM to host affinity is enforcing or not
 - [BZ 1555268](https://bugzilla.redhat.com/1555268) <b>[RFE] Kernel address space layout randomization [KASLR] support</b><br>Previously, Red Hat Enterprise Linux kernels had kernel address space layout randomization enabled by default. This feature prevented trouble-shooting and analysis of the guest's memory dumps. In the current feature, "vmcoreinfo" is enabled for all Linux guests. It allows a compatible kernel to export the debugging information so that the memory image can be analyzed.
 - [BZ 1554111](https://bugzilla.redhat.com/1554111) <b>[RFE] - Report MTU on iface</b><br>Please extend the LLDP note in https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.2-beta/html-single/administration_guide/#Editing_host_network_interfaces<br>to refer to the new bit of data. It is recommended to check that the MTU of the logical network is less or equal to that supported by peer switches.
 - [BZ 1552026](https://bugzilla.redhat.com/1552026) <b>The api does not return the OS architecture</b><br>Operation Systems Information returned by REST API now contains the OS architecture.
 - [BZ 1566366](https://bugzilla.redhat.com/1566366) <b>[downstream clone - 4.2.4] [RFE] [RHV] Add support to query illegal images in unlock_entity.sh</b><br>
 - [BZ 1540973](https://bugzilla.redhat.com/1540973) <b>hosts rule in affinity group is always enabled in rest response API (even if disabled in UI )</b><br>Feature: <br>The host to VM affinity can now be explicitly disabled. Previously it was always enabled, but it had no effect if no hosts were assigned to the affinity group.<br><br>Reason: <br>Having the affinity always enabled could be confusing when using the REST API.
 - [BZ 1565099](https://bugzilla.redhat.com/1565099) <b>Bump required Ansible version to 2.5</b><br>Feature: <br><br>Ansible 2.5 is now required for engine and all Ansible roles distributed with oVirt engine<br><br>Reason: <br><br>Result:

#### VDSM

 - [BZ 1551350](https://bugzilla.redhat.com/1551350) <b>[RFE] Add support for querying information from QEMU Guest Agent</b><br>It is now possible to obtain infomation like hostname, OS info, time zone and active users on VMs where ovirt-guest-agent is not installed and only QEMU Guest Agent is present.
 - [BZ 1334982](https://bugzilla.redhat.com/1334982) <b>[RFE] Gracefully shutdown Virtual Machines on Host reboot/shutdown.</b><br>Previously, in an emergency, users were required to shut down the hosts to preserve the data center. This caused running virtual machines to be killed by the systemd process without performing a graceful shutdown. As a result, the virtual machines' state became undefined, which led to problematic scenarios for virtual machines running databases such as Oracle and SAP.<br><br>In this release, virtual machines can be gracefully shut down by delaying the systemd process. After the virtual machines are shut down, the systemd process takes control and continues the shutdown. The VDSM is only shut down after the virtual machines have been gracefully shut down, after passing information to the Manager and waiting 5 seconds for the Manager to acknowledge the virtual machines have been shut down.
 - [BZ 1447300](https://bugzilla.redhat.com/1447300) <b>enable libguestfs tools on ppc64le</b><br>Sparsify and sysprep can now be run on POWER hosts.
 - [BZ 1550106](https://bugzilla.redhat.com/1550106) <b>[RFE] IOProcess thread of storage domain should be correlated to the domain id/name</b><br>Feature: <br>Log IOProcessClient's name<br><br>Reason: <br>Before this patch, IOProcessesClient name used a counter (e.g. "ioprocess-0") and it was impossible to correlate ioprocess to the storage domain.<br><br>Result:<br>This patch changes the client name in IOProcessClient to one of the following (as described in the patch):<br>- "Global"<br>- "domain-uuid"<br>- "/[GlusterSD/]server:_path"

#### oVirt Hosted Engine Setup

 - [BZ 1538934](https://bugzilla.redhat.com/1538934) <b>[RFE] hosted-engine --vm-status should provide a way to detect and warn about failed deployments</b><br>hosted-engine --vm-status should warn the user about past failed or still in progress deployment attempts.

#### oVirt Engine Metrics

 - [BZ 1563681](https://bugzilla.redhat.com/1563681) <b>Add OpenShift 3.9 ansible inventory file and copy in to metrics store machine</b><br>Feature: <br>To make OpenShift installation easier, we generate the inventory files and vars.yml file and copy them to the metrics store machine.<br> <br>Reason: <br>To make OpenShift installation easier<br><br>Result: <br>The user does not need to handle the inventory and vars.yml file and can use them when running the OpenShift ansible playbooks.
 - [BZ 1560240](https://bugzilla.redhat.com/1560240) <b>OpenShift Logging should use the partition supplied by the user for elasticsearch persistent storage</b><br>In this release, it is possible to configure a persistent storage partition other than the default partition (/var) for Elasticsearch, by setting a parameter in the OpenShift Ansible inventory files.

#### cockpit-ovirt

 - [BZ 1547464](https://bugzilla.redhat.com/1547464) <b>[RFE]Tick mark on one check box  in brick configuration should check mark  all the bricks under that device.</b><br>

### Bug Fixes

#### oVirt Engine

 - [BZ 1528868](https://bugzilla.redhat.com/1528868) <b>problems upgrading from ovirt 4.1.</b><br>
 - [BZ 1565331](https://bugzilla.redhat.com/1565331) <b>Events tab: search bar/box is missing in 4.2 beta</b><br>
 - [BZ 1547936](https://bugzilla.redhat.com/1547936) <b>[Tracker] Fill the gaps with new OVF parsing</b><br>
 - [BZ 1558054](https://bugzilla.redhat.com/1558054) <b>Adding a new external network fails during auto-sync is running</b><br>
 - [BZ 1567538](https://bugzilla.redhat.com/1567538) <b>Export to OVA fails because of exception in pack_ova.py on host</b><br>
 - [BZ 1539777](https://bugzilla.redhat.com/1539777) <b>Improve Migration summary message</b><br>

#### VDSM

 - [BZ 1544853](https://bugzilla.redhat.com/1544853) <b>Detect and fix broken volume leases</b><br>
 - [BZ 1551521](https://bugzilla.redhat.com/1551521) <b>KeyError exception in the VDSM when accessing stats['cpuUsage']</b><br>

#### oVirt Hosted Engine HA

 - [BZ 1567615](https://bugzilla.redhat.com/1567615) <b>Hosted engine - engine restarted during hosted engine VM migration -ovirt_hosted_engine_ha.agent.hosted_engine.HostedEngine::(_stop_engine_vm) Engine VM stopped on localhost</b><br>

#### oVirt Hosted Engine Setup

 - [BZ 1571467](https://bugzilla.redhat.com/1571467) <b>HE deployment fails if fiber channel is used</b><br>
 - [BZ 1571113](https://bugzilla.redhat.com/1571113) <b>Didn't use the temporary password to login to HE-VM by "hosted-engine --add-console-password"</b><br>
 - [BZ 1560610](https://bugzilla.redhat.com/1560610) <b>Storage Domain's size not being updated during deployment.</b><br>

#### imgbased

 - [BZ 1561258](https://bugzilla.redhat.com/1561258) <b>grub2-mkconfig on node produce incorrect grub2.cfg if a local VG is present</b><br>

### Other

#### oVirt Engine

 - [BZ 1581144](https://bugzilla.redhat.com/1581144) <b>add SSBD CPUs</b><br>
 - [BZ 1579268](https://bugzilla.redhat.com/1579268) <b>Upgrade of PostgreSQL during RHV 4.1 to 4.2 upgrade fails with locale mismatch</b><br>This update enables engine-setup to upgrade PostgreSQL 9.2 to 9.5, even when the locale of the 9.2 database is different from the system locale.<br><br>Doc team: Copied above from bug 1528371. Please note that bug 1528371 was accidentally not fully fixed for 4.2 - the correct fix was added only for the next version, to be 4.3 eventually. You might want to mention this, not sure how, if at all.
 - [BZ 1571039](https://bugzilla.redhat.com/1571039) <b>[DR] - Registering of a VM containing snapshots with memory from an imported domain fails with an NPE</b><br>
 - [BZ 1567858](https://bugzilla.redhat.com/1567858) <b>[Regression] -  Cannot start VM with <Empty> vNIC</b><br>
 - [BZ 1530186](https://bugzilla.redhat.com/1530186) <b>Create new Gluster Snapshots Web UI doesn't work</b><br>
 - [BZ 1570388](https://bugzilla.redhat.com/1570388) <b>Add host failed if cluster has a required network</b><br>
 - [BZ 1565681](https://bugzilla.redhat.com/1565681) <b>Engine doesn't track transfers in progress correctly</b><br>
 - [BZ 1568413](https://bugzilla.redhat.com/1568413) <b>admin account constantly gets locked after password changed</b><br>
 - [BZ 1569420](https://bugzilla.redhat.com/1569420) <b>Failed to execute Ansible host-deploy role</b><br>
 - [BZ 1546832](https://bugzilla.redhat.com/1546832) <b>[Tracker] Fill the gaps with engine XML</b><br>
 - [BZ 1559730](https://bugzilla.redhat.com/1559730) <b>Allow backward-compatible CPUs on ppc64le</b><br>
 - [BZ 1560455](https://bugzilla.redhat.com/1560455) <b>VM lease will be removed in case VM is edited while the storage domain which hold the lease is in maintenance</b><br>
 - [BZ 1514025](https://bugzilla.redhat.com/1514025) <b>DC report two master storage domain.</b><br>
 - [BZ 1552025](https://bugzilla.redhat.com/1552025) <b>Host Setup Networks Dialog: hide VFs by default</b><br>
 - [BZ 1529394](https://bugzilla.redhat.com/1529394) <b>[DR] - detaching of a storage domain with existing VM leases for VMs in down status fails which affect the failback flow</b><br>Detaching of a storage domain that contains VM leases of templates and VMs in the system is now allowed.<br>The domain will be detached without the actual leases removed from the storage, also the VMs and templates will still contain the lease association and will not run until they are manually removed (this is by design)
 - [BZ 1558500](https://bugzilla.redhat.com/1558500) <b>httpd configuration is not updated on upgrade</b><br>engine-setup now checks if apache httpd's ssl.conf file needs updates also on upgrades, prompts accordingly, and applies the updates as needed.
 - [BZ 1540624](https://bugzilla.redhat.com/1540624) <b>Cannot get administration portal after logging to IPA domain, WFLYEJB0442: Unexpected Error</b><br>
 - [BZ 1570366](https://bugzilla.redhat.com/1570366) <b>Change OVS cluster switch type label to 'Tech-Preview' instead of 'Experimental'</b><br>
 - [BZ 1551574](https://bugzilla.redhat.com/1551574) <b>failed to attach network with missing address/netmask: they are sometimes stored in DB as empty string instead of NULL</b><br>
 - [BZ 1504673](https://bugzilla.redhat.com/1504673) <b>Improve message for CLUSTER_CANNOT_UPDATE_VM_COMPATIBILITY_VERSION in UI</b><br>
 - [BZ 1512412](https://bugzilla.redhat.com/1512412) <b>missing indexes on engine db</b><br>
 - [BZ 1507434](https://bugzilla.redhat.com/1507434) <b>When importing VM, "Finished importing VM" pop-up event appears although import just started.</b><br>
 - [BZ 1541978](https://bugzilla.redhat.com/1541978) <b>[ko_KR] Text alignment correction needed on compute -> clusters -> new -> fencing policy</b><br>
 - [BZ 1539914](https://bugzilla.redhat.com/1539914) <b>Adding Storage domain with more than 50 character LUN ID succeeds but Storage domain removal fails</b><br>
 - [BZ 1566341](https://bugzilla.redhat.com/1566341) <b>[downstream clone 4.2.4] CloudInit: DNS search parameter is passed incorrectly</b><br>
 - [BZ 1542070](https://bugzilla.redhat.com/1542070) <b>[es_ES] [pt_BR] [Admin Portal] Radio button label 'User Roles' appears misaligned in Spanish google-chrome</b><br>
 - [BZ 1558525](https://bugzilla.redhat.com/1558525) <b>show proper error when authorization to api fails</b><br>
 - [BZ 1576352](https://bugzilla.redhat.com/1576352) <b>rhvm-4.2 reports "no updates found" although there is available updates</b><br>
 - [BZ 1574605](https://bugzilla.redhat.com/1574605) <b>javascript error while accessing Storage -> Volumes on a local storage datacenter with no volumes created yet</b><br>
 - [BZ 1566059](https://bugzilla.redhat.com/1566059) <b>Scoped link local IPv6 addresses break VM listing (happens when ovirt-guest-agent is not installed but qemu-guest-agent is)</b><br>
 - [BZ 1571300](https://bugzilla.redhat.com/1571300) <b>VdsNotRespondingTreatment releases VDS_FENCE lock twice</b><br>
 - [BZ 1563278](https://bugzilla.redhat.com/1563278) <b>transfer image - client inactivity timeout is too short and can't be configured from api</b><br>
 - [BZ 1489968](https://bugzilla.redhat.com/1489968) <b>[RFE] [RHV] Add support to query illegal images in unlock_entity.sh</b><br>
 - [BZ 1551517](https://bugzilla.redhat.com/1551517) <b>after renaming engine, logout takes very long time and error with engine's old fqdn appears in log</b><br>
 - [BZ 1566457](https://bugzilla.redhat.com/1566457) <b>Hot plug CPU is broken on 3.6 clusters after oVirt is upgraded  to 4.2</b><br>
 - [BZ 1541777](https://bugzilla.redhat.com/1541777) <b>PowerSaving policy does not balance VM's from host with over-utilized memory</b><br>
 - [BZ 1563426](https://bugzilla.redhat.com/1563426) <b>Unable to setup host local storage - Uncaught exception occurred -  Details: (TypeError) : Cannot read property 'b' of null</b><br>
 - [BZ 1565814](https://bugzilla.redhat.com/1565814) <b>HostMonitoring should release lock only once</b><br>
 - [BZ 1561447](https://bugzilla.redhat.com/1561447) <b>VM with a lease manage to remove while the VM lease storage domain is not active</b><br>VM with a lease on a non-active storage domain will fail to remove.<br><br>The VM will remove when the VM lease storage domain is active as similar to disks behavior.<br><br>A workaround is to remove the VM lease in "Edit VM" and then try to remove again, same as we can detach disks from VM even if the storage is down
 - [BZ 1561006](https://bugzilla.redhat.com/1561006) <b>VM activation should fail on engine validation when the VM lease domain is not active</b><br>
 - [BZ 1565109](https://bugzilla.redhat.com/1565109) <b>Provide ansible script for changing OVN Provider tunneling network</b><br>
 - [BZ 1554875](https://bugzilla.redhat.com/1554875) <b>When importing a VM with a lease using the UI, the property that indicates whether the VM has a lease ignored</b><br>
 - [BZ 1563579](https://bugzilla.redhat.com/1563579) <b>transfer image - increase default value of UploadImageXhrTimeoutInSeconds</b><br>
 - [BZ 1562013](https://bugzilla.redhat.com/1562013) <b>Use custom system SSH configuration for engine internal Ansible executions</b><br>
 - [BZ 1558034](https://bugzilla.redhat.com/1558034) <b>Creating a partial child snapshot in a VM with an existing snapshot containing a cinder snapshot breaks the snapshot</b><br>
 - [BZ 1551934](https://bugzilla.redhat.com/1551934) <b>No source storage domain identified when trying to move a VM's disk from the problematic storage</b><br>
 - [BZ 1563632](https://bugzilla.redhat.com/1563632) <b>can't switch user when accessing the engine with an active kerberos ticket</b><br>
 - [BZ 1556971](https://bugzilla.redhat.com/1556971) <b>Host stays in "connecting" state for longer time than necessary</b><br>
 - [BZ 1548496](https://bugzilla.redhat.com/1548496) <b>Wrong error message when creating disks in API</b><br>
 - [BZ 1560208](https://bugzilla.redhat.com/1560208) <b>Resize disk: IO exception while processing "PUT" request for path /vms/%vm_id%/diskattachments/%disk_id% with a number too large for the size</b><br>
 - [BZ 1552439](https://bugzilla.redhat.com/1552439) <b>[UI] - Alerts - wrong message when clearing all Alerts</b><br>
 - [BZ 1532709](https://bugzilla.redhat.com/1532709) <b>Host is set to non responsive after update when reboot takes a long time</b><br>

#### VDSM

 - [BZ 1563165](https://bugzilla.redhat.com/1563165) <b>[SR-IOV] - vdsm no longer persisting and restoring the number on VFs after reboot</b><br>
 - [BZ 1567858](https://bugzilla.redhat.com/1567858) <b>[Regression] -  Cannot start VM with <Empty> vNIC</b><br>
 - [BZ 1568268](https://bugzilla.redhat.com/1568268) <b>Executing ovs commands using ovs-vsctl causes a deadlock sporadically</b><br>
 - [BZ 1567617](https://bugzilla.redhat.com/1567617) <b>Failure to resume VM,  Error:  Wake up from hibernation failed:'type'.</b><br>
 - [BZ 1561010](https://bugzilla.redhat.com/1561010) <b>vdsm: perform only minimal changes to the domain XML received from Engine</b><br>
 - [BZ 1564146](https://bugzilla.redhat.com/1564146) <b>cpuflags hook should use sap_agent predefined property</b><br>Previously, vdsm-hook-cpuflags required new custom property to add specified cpu flags to the host. For SAP workloads, the property had to carry special keyword "SAP". The previous behavior is preserved, but the SAP portion of the hook is now additionally triggered by setting "sap_agent" predefined property to "true".
 - [BZ 1569850](https://bugzilla.redhat.com/1569850) <b>migration fails using Vdsm 4.30.z on cluster <= 4.1 for VMs with payload device</b><br>
 - [BZ 1567801](https://bugzilla.redhat.com/1567801) <b>vGPU: running VM with mdev_type hook switched to pause mode after host upgrade and cannot be run anymore.</b><br>
 - [BZ 1566948](https://bugzilla.redhat.com/1566948) <b>Preview of snapshot with memory crashes on missing `serial' attribute</b><br>
 - [BZ 1557735](https://bugzilla.redhat.com/1557735) <b>VDSM is dead after upgrade to vdsm-4.20.22-1.el7ev.x86_64</b><br>
 - [BZ 1516831](https://bugzilla.redhat.com/1516831) <b>Host fails with Heartbeat periodically</b><br>
 - [BZ 1542466](https://bugzilla.redhat.com/1542466) <b>Traceback in vdsm.log: setBalloonTarget error=Balloon operation is not available</b><br>
 - [BZ 1555248](https://bugzilla.redhat.com/1555248) <b>Report RETP kernel feature</b><br>
 - [BZ 1552713](https://bugzilla.redhat.com/1552713) <b>Unknown VMs are added on libvirt Undefined event</b><br>
 - [BZ 1548845](https://bugzilla.redhat.com/1548845) <b>HotPlug succeeds but ERROR seen in VDSM: VM metrics collection failed with KeyError: 'readOps'</b><br>

#### oVirt Engine SDK 4 Python

 - [BZ 1529509](https://bugzilla.redhat.com/1529509) <b>Trying to upgrade a host via the API fails with fault - 'no upgrades available'</b><br>

#### oVirt image transfer daemon and proxy

 - [BZ 1571994](https://bugzilla.redhat.com/1571994) <b>ovirt-image-daemon fails to start due to permissions on ovirt-image-daemon log file causing host deployment to fail</b><br>

#### oVirt Hosted Engine Setup

 - [BZ 1566162](https://bugzilla.redhat.com/1566162) <b>Cockpit plugin should never use browser's locale</b><br>
 - [BZ 1565730](https://bugzilla.redhat.com/1565730) <b>State field may be missing from virsh output</b><br>
 - [BZ 1567772](https://bugzilla.redhat.com/1567772) <b>Enable Spice + VNC graphical console on the target VM</b><br>
 - [BZ 1565060](https://bugzilla.redhat.com/1565060) <b>Fix a deprecation warning from ansible on Hosted-Engine deployment</b><br>

#### oVirt Engine Metrics

 - [BZ 1561927](https://bugzilla.redhat.com/1561927) <b>engine.log - timezone handling broken for utc</b><br>
 - [BZ 1566519](https://bugzilla.redhat.com/1566519) <b>Deprecation and other warnings on metrics playbook</b><br>
 - [BZ 1566523](https://bugzilla.redhat.com/1566523) <b>Metrics playbook is not idempotent</b><br>

#### cockpit-ovirt

 - [BZ 1574202](https://bugzilla.redhat.com/1574202) <b>"Next" button of HE wizard is disabled if gdeploy is not installed</b><br>
 - [BZ 1571117](https://bugzilla.redhat.com/1571117) <b>HE-VM appliance and admin password saved in the setup log file as clear text executing from cockpit</b><br>
 - [BZ 1565528](https://bugzilla.redhat.com/1565528) <b>[branding] "Ovirt" (upstream) is included in rhvh Hosted-engine cockpit UI</b><br>
 - [BZ 1569116](https://bugzilla.redhat.com/1569116) <b>Hyperconverged wizard is not disabled when gdeploy is not present</b><br>
 - [BZ 1568725](https://bugzilla.redhat.com/1568725) <b>Enable VDO option Only if gdeploy version is greater than or equals to gdeploy-2.0.2-25</b><br>
 - [BZ 1543486](https://bugzilla.redhat.com/1543486) <b>[ansible based] Default cluster in HC installation does not have gluster service enabled</b><br>
 - [BZ 1559793](https://bugzilla.redhat.com/1559793) <b>Deploy HE failed with static IP and empty DNS value on the [Generate static network configuration for the engine VM] task</b><br>
 - [BZ 1565591](https://bugzilla.redhat.com/1565591) <b>Ansible: Cockpit didn't retrieve the FC lun, just need the user to input the lun id manually</b><br>
 - [BZ 1568869](https://bugzilla.redhat.com/1568869) <b>HE: the user cannot enter a static IP address for the engine VM: Uncaught ReferenceError: getCidrErrorMsg is not defined</b><br>
 - [BZ 1558059](https://bugzilla.redhat.com/1558059) <b>Some icons show missing font placeholder when running hosted engine wizard</b><br>
 - [BZ 1560351](https://bugzilla.redhat.com/1560351) <b>After changing the iSCSI portal address and fetching, old results are shown</b><br>
 - [BZ 1558084](https://bugzilla.redhat.com/1558084) <b>The iSCSI storage wizard page has weird UI logic</b><br>
 - [BZ 1555368](https://bugzilla.redhat.com/1555368) <b>Network prefix length value is pre-filled but not effective if the user doesn't retype it.</b><br>

#### oVirt Engine Dashboard

 - [BZ 1571144](https://bugzilla.redhat.com/1571144) <b>Links from system dashboard not working.</b><br>
 - [BZ 1555050](https://bugzilla.redhat.com/1555050) <b>Slow Dashboard re-paint on Chrome</b><br>

#### VDSM JSON-RPC Java

 - [BZ 1565814](https://bugzilla.redhat.com/1565814) <b>HostMonitoring should release lock only once</b><br>

### No Doc Update

#### oVirt Engine

 - [BZ 1572445](https://bugzilla.redhat.com/1572445) <b>context-sensitive help URL path regression, 404</b><br>
 - [BZ 1552194](https://bugzilla.redhat.com/1552194) <b>Update name of RHEV-toolsSetup* ISO to attach in search algorithm</b><br>
 - [BZ 1565036](https://bugzilla.redhat.com/1565036) <b>PPC: CreateVDSCommand fails with NullPointerException for VM with sPAPR VSCSI disk attached</b><br>
 - [BZ 1563121](https://bugzilla.redhat.com/1563121) <b>No exception's handling on SerialChildCommandsExecutionCallback</b><br>
 - [BZ 1553305](https://bugzilla.redhat.com/1553305) <b>[PPC] - Starting VM for the 2nd time failed after snapshots created- XML error: target 'sdc' duplicated for disk sources - libvirt.py", line 3676, in defineXML</b><br>

#### VDSM

 - [BZ 1548110](https://bugzilla.redhat.com/1548110) <b>VDO rpm should be pulled in as rpm dependency</b><br>

