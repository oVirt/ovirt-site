---
title: oVirt 4.2.3 Release Notes
category: documentation
layout: toc
---

# oVirt 4.2.3 Release Notes

The oVirt Project is pleased to announce the availability of the 4.2.3 First Release Candidate as of April 12, 2018.

oVirt is an open source alternative to VMware™ vSphere™, providing an
awesome KVM management interface for multi-node virtualization.
This release is available now for Red Hat Enterprise Linux 7.4,
CentOS Linux 7.4 (or similar).


To find out how to interact with oVirt developers and users and ask questions,
visit our [community page]"(/community/).
All issues or bugs should be reported via
[Red Hat Bugzilla](https://bugzilla.redhat.com/enter_bug.cgi?classification=oVirt).
The oVirt Project makes no guarantees as to its suitability or usefulness.
This pre-release should not to be used in production, and it is not feature
complete.


For a general overview of oVirt, read the [Quick Start Guide](/documentation/quickstart/quickstart-guide/)
and visit the [About oVirt](/documentation/introduction/about-ovirt/) page.

For detailed installation instructions, read the [Installation Guide](/documentation/install-guide/Installation_Guide/).

To learn about features introduced before 4.2.3, see the [release notes for previous versions](/documentation/#previous-release-notes).


## Install / Upgrade from previous versions

### CentOS / RHEL


## RELEASE CANDIDATE

In order to install this Release Candidate you will need to enable pre-release repository.




In order to install it on a clean system, you need to install


`# yum install `[`http://resources.ovirt.org/pub/yum-repo/ovirt-release42-pre.rpm`](http://resources.ovirt.org/pub/yum-repo/ovirt-release42-pre.rpm)


and then follow our
[Installation Guide](http://www.ovirt.org/documentation/install-guide/Installation_Guide/).



### No Fedora support

Regretfully, Fedora is not supported anymore, and RPMs for it are not provided.
These are still built for the master branch, so users that want to test them,
can use the [nightly snapshot](/develop/dev-process/install-nightly-snapshot/).
At this point, we only try to fix problems specific to Fedora if they affect
developers. For some of the work to be done to restore support for Fedora, see
also tracker [bug 1460625](https://bugzilla.redhat.com/showdependencytree.cgi?id=1460625&hide_resolved=0).

### oVirt Hosted Engine

If you're going to install oVirt as a Hosted Engine on a clean system please
follow [Hosted_Engine_Howto#Fresh_Install](/documentation/how-to/hosted-engine/#fresh-install)
guide or the corresponding section in
[Self Hosted Engine Guide](/documentation/self-hosted/Self-Hosted_Engine_Guide/).

If you're upgrading an existing Hosted Engine setup, please follow
[Hosted_Engine_Howto#Upgrade_Hosted_Engine](/documentation/how-to/hosted-engine/#upgrade-hosted-engine)
guide or the corresponding section within the
[Upgrade Guide](/documentation/upgrade-guide/upgrade-guide/).

### EPEL

TL;DR Don't enable all of EPEL on oVirt machines.

The ovirt-release package enables the EPEL repositories and includes several
specific packages that are required from there. It also enables and uses
the CentOS SIG repos, for other packages.

If you want to use other packages from EPEL, you should make sure to
use `includepkgs` and add only those you need avoiding to override
packages from other repos.

## What's New in 4.2.3?

### Enhancements

#### oVirt Engine

 - [BZ 1518541](https://bugzilla.redhat.com/1518541) <b>[RFE] Monitor capacity of vdo-enabled brick devices and gluster volumes</b><br>Feature: Added monitoring of thin storage devices (thin provisioned, compressed or deduplicated)<br><br>Reason: With thin devices number of available 'free bytes' on storage domain may not be relevant. Storage domain may report that you have a lot of space, while actually you are quite limited. Because of that we need to monitor actually available space and report it.<br><br>Result: Now we report guaranteed free space (meaning, that you will be able to write at least as much data and may be more) for gluster bricks, bluster volumes and for gluster based storage domains.
 - [BZ 1554111](https://bugzilla.redhat.com/1554111) <b>[RFE] - Report MTU on iface</b><br>Please extend the LLDP note in https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.2-beta/html-single/administration_guide/#Editing_host_network_interfaces<br>to refer to the new bit of data. It is recommended to check that the MTU of the logical network is less or equal to that supported by peer switches.
 - [BZ 1565099](https://bugzilla.redhat.com/1565099) <b>Bump required Ansible version to 2.5</b><br>Feature: <br><br>Ansible 2.5 is now required for engine and all Ansible roles distributed with oVirt engine<br><br>Reason: <br><br>Result:

#### VDSM

 - [BZ 1551350](https://bugzilla.redhat.com/1551350) <b>[RFE] Add support for querying information from QEMU Guest Agent</b><br>It is now possible to obtain infomation like hostname, OS info, time zone and active users on VMs where ovirt-guest-agent is not installed and only QEMU Guest Agent is present.
 - [BZ 1518541](https://bugzilla.redhat.com/1518541) <b>[RFE] Monitor capacity of vdo-enabled brick devices and gluster volumes</b><br>Feature: Added monitoring of thin storage devices (thin provisioned, compressed or deduplicated)<br><br>Reason: With thin devices number of available 'free bytes' on storage domain may not be relevant. Storage domain may report that you have a lot of space, while actually you are quite limited. Because of that we need to monitor actually available space and report it.<br><br>Result: Now we report guaranteed free space (meaning, that you will be able to write at least as much data and may be more) for gluster bricks, bluster volumes and for gluster based storage domains.
 - [BZ 1334982](https://bugzilla.redhat.com/1334982) <b>[RFE] Gracefully shutdown Virtual Machines on Host reboot/shutdown.</b><br>Previously, in cases of emergency,  users were required to shut down the hosts to preserve the data center. This caused running virtual machines to be killed by the systemd process without performing a graceful shutdown. As a result, the virtual machine's state became undefined which led to problematic scenarios for virtual machines running databases such as Oracle and SAP.<br>In this release, virtual machines can be gracefully shut down by delaying the systemd process. Only after the virtual machines are shut down, does the systemd process take control and continue the shut down. The VDSM is only shut down after the virtual machines have been gracefully shut down, after passing information to the Manager and waiting 5 seconds for the Manager to acknowledge the virtual machines have been shut down.
 - [BZ 1447300](https://bugzilla.redhat.com/1447300) <b>enable libguestfs tools on ppc64le</b><br>Sparsify and sysprep can now be run on POWER hosts.

#### cockpit-ovirt

 - [BZ 1547464](https://bugzilla.redhat.com/1547464) <b>[RFE]Tick mark on one check box  in brick configuration should check mark  all the bricks under that device.</b><br>

### Bug Fixes

#### oVirt Engine

 - [BZ 1558054](https://bugzilla.redhat.com/1558054) <b>Adding a new external network fails during auto-sync is running</b><br>

### Other

#### oVirt Engine

 - [BZ 1552025](https://bugzilla.redhat.com/1552025) <b>Host Setup Networks Dialog: hide VFs by default</b><br>
 - [BZ 1540955](https://bugzilla.redhat.com/1540955) <b>The Affinity Positive/Negative Value is not updated in the UI window</b><br>
 - [BZ 1529394](https://bugzilla.redhat.com/1529394) <b>[DR] - detaching of a storage domain with existing VM leases for VMs in down status fails which affect the failback flow</b><br>Detaching of a storage domain that contains VM leases of templates and VMs in the system is now allowed.<br>The domain will be detached without the actual leases removed from the storage, also the VMs and templates will still contain the lease association and will not run until they are manually removed (this is by design)
 - [BZ 1558500](https://bugzilla.redhat.com/1558500) <b>httpd configuration is not updated on upgrade</b><br>engine-setup now checks if apache httpd's ssl.conf file needs updates also on upgrades, prompts accordingly, and applies the updates as needed.
 - [BZ 1540624](https://bugzilla.redhat.com/1540624) <b>Cannot get administration portal after logging to IPA domain, WFLYEJB0442: Unexpected Error</b><br>
 - [BZ 1539914](https://bugzilla.redhat.com/1539914) <b>Adding Storage domain with more than 50 character LUN ID succeeds but Storage domain removal fails</b><br>
 - [BZ 1542070](https://bugzilla.redhat.com/1542070) <b>[es_ES] [pt_BR] [Admin Portal] Radio button label 'User Roles' appears misaligned in Spanish google-chrome</b><br>
 - [BZ 1558525](https://bugzilla.redhat.com/1558525) <b>show proper error when authorization to api fails</b><br>
 - [BZ 1539777](https://bugzilla.redhat.com/1539777) <b>Improve Migration summary message</b><br>
 - [BZ 1565109](https://bugzilla.redhat.com/1565109) <b>Provide ansible script for changing OVN Provider tunneling network</b><br>
 - [BZ 1554875](https://bugzilla.redhat.com/1554875) <b>When importing a VM with a lease using the UI, the property that indicates whether the VM has a lease ignored</b><br>
 - [BZ 1540973](https://bugzilla.redhat.com/1540973) <b>hosts rule in affinity group is always enabled in rest response API (even if disabled in UI )</b><br>
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

 - [BZ 1544853](https://bugzilla.redhat.com/1544853) <b>Detect and fix broken volume leases</b><br>
 - [BZ 1561010](https://bugzilla.redhat.com/1561010) <b>vdsm: perform only minimal changes to the domain XML received from Engine</b><br>
 - [BZ 1557735](https://bugzilla.redhat.com/1557735) <b>VDSM is dead after upgrade to vdsm-4.20.22-1.el7ev.x86_64</b><br>
 - [BZ 1516831](https://bugzilla.redhat.com/1516831) <b>Host fails with Heartbeat periodically</b><br>
 - [BZ 1542466](https://bugzilla.redhat.com/1542466) <b>Traceback in vdsm.log: setBalloonTarget error=Balloon operation is not available</b><br>
 - [BZ 1555248](https://bugzilla.redhat.com/1555248) <b>Report RETP kernel feature</b><br>
 - [BZ 1552713](https://bugzilla.redhat.com/1552713) <b>Unknown VMs are added on libvirt Undefined event</b><br>
 - [BZ 1548845](https://bugzilla.redhat.com/1548845) <b>HotPlug succeeds but ERROR seen in VDSM: VM metrics collection failed with KeyError: 'readOps'</b><br>

#### oVirt Engine SDK 4 Python

 - [BZ 1529509](https://bugzilla.redhat.com/1529509) <b>Trying to upgrade a host via the API fails with fault - 'no upgrades available'</b><br>

#### oVirt image transfer daemon and proxy

 - [BZ 1560242](https://bugzilla.redhat.com/1560242) <b>[RFE] virt-v2v integration improvements</b><br>

#### oVirt Engine Metrics

 - [BZ 1563681](https://bugzilla.redhat.com/1563681) <b>Add OpenShift 3.9 ansible inventory file and copy in to metrics store machine</b><br>
 - [BZ 1561927](https://bugzilla.redhat.com/1561927) <b>engine.log - timezone handling broken for utc</b><br>

#### cockpit-ovirt

 - [BZ 1560351](https://bugzilla.redhat.com/1560351) <b>After changing the iSCSI portal address and fetching, old results are shown</b><br>
 - [BZ 1558084](https://bugzilla.redhat.com/1558084) <b>The iSCSI storage wizard page has weird UI logic</b><br>
 - [BZ 1555368](https://bugzilla.redhat.com/1555368) <b>Network prefix length value is pre-filled but not effective if the user doesn't retype it.</b><br>

### No Doc Update

#### oVirt Engine

 - [BZ 1553305](https://bugzilla.redhat.com/1553305) <b>[PPC] - Starting VM for the 2nd time failed after snapshots created- XML error: target 'sdc' duplicated for disk sources - libvirt.py", line 3676, in defineXML</b><br>

#### VDSM

 - [BZ 1548110](https://bugzilla.redhat.com/1548110) <b>VDO rpm should be pulled in as rpm dependency</b><br>
