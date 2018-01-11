---
title: oVirt 4.1.9 Release Notes
category: documentation
layout: toc
---

# oVirt 4.1.9 Release Notes

The oVirt Project is pleased to announce the availability of the 4.1.9
First Release Candidate
 as of January 10, 2018.

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

To learn about features introduced before 4.1.9, see the [release notes for previous versions](/documentation/#previous-release-notes).


## Install / Upgrade from previous versions

### CentOS / RHEL


## RELEASE CANDIDATE

In order to install this Release Candidate you will need to enable pre-release repository.




In order to install it on a clean system, you need to install


`# yum install `[`http://resources.ovirt.org/pub/yum-repo/ovirt-release41-pre.rpm`](http://resources.ovirt.org/pub/yum-repo/ovirt-release41-pre.rpm)


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

## What's New in 4.1.9?

### Enhancements

#### oVirt Host Dependencies

 - [BZ 1525933](https://bugzilla.redhat.com/1525933) <b>[downstream clone - 4.1.9] [RFE] Include katello agent in RHV-H NG</b><br>Feature: Katello Agent is now installed on RHV hosts during deployment and is included in RHV-H image<br><br>Reason: to better integrate with Satellite. Katello Agent provides the list of the installed rpms.<br><br>Result: katello-agent is installed and working on RHV / RHV-H Hosts

#### OTOPI

 - [BZ 1528290](https://bugzilla.redhat.com/1528290) <b>[RFE] otopi should run with rpmverbosity "debug"</b><br>otopi's yum plugin is now more verbose, logging also all rpm scriptlets's output. This can help debug failures caused by errors from such scriptlets.
 - [BZ 1518545](https://bugzilla.redhat.com/1518545) <b>[RFE] otopi should log on failure list of network connections</b><br>otopi now optionally logs the list of network connections on the machine after failures. Enable this by installing the optional package otopi-debug-plugins. This can help debug failures to start network services due to "Address already in use" errors.

### Other

#### VDSM

 - [BZ 1527827](https://bugzilla.redhat.com/1527827) <b>[downstream clone - 4.1.9] Entire vdsm process hang during when formatting xlease volume on NFS storage domain</b><br>
 - [BZ 1530630](https://bugzilla.redhat.com/1530630) <b>[downstream clone - 4.1.9] vdsm-tool remove-config does not revert changes</b><br>
 - [BZ 1523232](https://bugzilla.redhat.com/1523232) <b>localdisk cannot access the ovirt-local VG if a strict LVM filter is configured</b><br>

#### oVirt Engine

 - [BZ 1509629](https://bugzilla.redhat.com/1509629) <b>Cold merge failed to remove all volumes</b><br>
 - [BZ 1531016](https://bugzilla.redhat.com/1531016) <b>add IBRS CPUs</b><br>
 - [BZ 1529927](https://bugzilla.redhat.com/1529927) <b>[downstream clone - 4.1.9] On upgrade from RHEV-3.6 to RHV-4, max_memory_size_mb seems hardly set to 1TB</b><br>
 - [BZ 1529073](https://bugzilla.redhat.com/1529073) <b>[downstream clone - 4.1.9] Previewing snapshot for VM A actually snapshots disks of VM B, both get broken.</b><br>
 - [BZ 1367700](https://bugzilla.redhat.com/1367700) <b>Display a warning if user tries to create multiple bricks on the same server during replace-brick.</b><br>
 - [BZ 1510859](https://bugzilla.redhat.com/1510859) <b>Possible duplicate bridge names due VDSM name.</b><br>
 - [BZ 1528812](https://bugzilla.redhat.com/1528812) <b>SQL Deadlock ERROR on DisplayAllAuditLogEventsCommand -under scaled topology</b><br>
 - [BZ 1528950](https://bugzilla.redhat.com/1528950) <b>[downstream clone - 4.1.9] Editing VM properties task hangs forever. The only way out is remove job_id from postgres and engine restart</b><br>
 - [BZ 1492473](https://bugzilla.redhat.com/1492473) <b>Editing VM properties task hangs forever. The only way out is remove job_id from postgres and engine restart</b><br>
 - [BZ 1507214](https://bugzilla.redhat.com/1507214) <b>VM lease creation doesn't occur properly during VM shutdown</b><br>
 - [BZ 1516712](https://bugzilla.redhat.com/1516712) <b>HA VM with lease could not be started because the lease does not created properly (EngineLock)</b><br>
 - [BZ 1522832](https://bugzilla.redhat.com/1522832) <b>Hot-plug of a VM lease task hang forever when power-off the VM before lease creation finished</b><br>
 - [BZ 1506547](https://bugzilla.redhat.com/1506547) <b>Provisioning discovered host from oVirt via Foreman doesn't work</b><br>
 - [BZ 1516494](https://bugzilla.redhat.com/1516494) <b>VDSM command GetVmsInfoVDS failed: Missing OVF file from VM</b><br>
 - [BZ 1524172](https://bugzilla.redhat.com/1524172) <b>ProcessDownVmCommand fails with NullPointerException upon trying to rename VM</b><br>
 - [BZ 1505399](https://bugzilla.redhat.com/1505399) <b>Poweroff the migrating VM will leave VM with migrating state under the engine</b><br>
 - [BZ 1524347](https://bugzilla.redhat.com/1524347) <b>Fails in vdsbroker.jar () while RunOnce for HA VM with lease</b><br>
 - [BZ 1524424](https://bugzilla.redhat.com/1524424) <b>[downstream clone - 4.1.9] Localdisk hook must prevent VM from being snapshot.</b><br>
 - [BZ 1518598](https://bugzilla.redhat.com/1518598) <b>Cannot synchronize a storage domain's LUN if its storage domain contains a shared disk between two VMs</b><br>
 - [BZ 1517707](https://bugzilla.redhat.com/1517707) <b>[downstream clone - 4.1.9] Don't allow hosts in Maintenance to be selected as fence proxies</b><br>
 - [BZ 1508869](https://bugzilla.redhat.com/1508869) <b>HA VM hotplug lease double meaning message</b><br>
