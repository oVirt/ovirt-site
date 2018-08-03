---
title: oVirt 4.2.6 Release Notes
category: documentation
layout: toc
---

# oVirt 4.2.6 Release Notes

The oVirt Project is pleased to announce the availability of the 4.2.6 First Release Candidate as of August 03, 2018.

oVirt is an open source alternative to VMware™ vSphere™, providing an
awesome KVM management interface for multi-node virtualization.
This release is available now for Red Hat Enterprise Linux 7.5,
CentOS Linux 7.5 (or similar).


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

To learn about features introduced before 4.2.6, see the [release notes for previous versions](/documentation/#previous-release-notes).


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

## What's New in 4.2.6?

### Bug Fixes

#### oVirt Engine

 - [BZ 1608828](https://bugzilla.redhat.com/1608828) <b>[downstream clone - 4.2.6] Unable to perform upgrade from 4.1 to 4.2 due to selinux related errors.</b><br>
 - [BZ 1589045](https://bugzilla.redhat.com/1589045) <b>[RHHI] Brick profile feature in RHV-M doesn't seems to be working</b><br>

### Other

#### oVirt Provider OVN

 - [BZ 1590359](https://bugzilla.redhat.com/1590359) <b>[ovn-provider] wrong message when posting a Subnet with no default gateway</b><br>
 - [BZ 1503577](https://bugzilla.redhat.com/1503577) <b>Duplicate OVN network name (with subnet) on different DCs pops unfriendly UI message</b><br>
 - [BZ 1608408](https://bugzilla.redhat.com/1608408) <b>Listing ports fails when stray subnet is present in db</b><br>

#### oVirt Engine

 - [BZ 1571563](https://bugzilla.redhat.com/1571563) <b>The VM could not be edited from HighPerformance or Server to Desktop in PPC arch (even if the new create of Desktop is allowed)</b><br>
 - [BZ 1573184](https://bugzilla.redhat.com/1573184) <b>StreamingAPI - Transfer disk Lock is freed before transfer is complete - after Finalizing phase but before Finished Success</b><br>
 - [BZ 1608716](https://bugzilla.redhat.com/1608716) <b>upload image - rounded up size value for the created disk</b><br>
 - [BZ 1609011](https://bugzilla.redhat.com/1609011) <b>Creating transient disk during backup operation is failing with error "No such file or directory"</b><br>
 - [BZ 1579303](https://bugzilla.redhat.com/1579303) <b>External VMs prevent placing host in maintenance mode</b><br>
 - [BZ 1600325](https://bugzilla.redhat.com/1600325) <b>Link to change password is broken</b><br>
 - [BZ 1591271](https://bugzilla.redhat.com/1591271) <b>Get Internal Server Error while trying to get graphic console, while VM suspending</b><br>
 - [BZ 1608265](https://bugzilla.redhat.com/1608265) <b>change GB labels to GiB</b><br>
 - [BZ 1607131](https://bugzilla.redhat.com/1607131) <b>UI exception is thrown when trying to create a VM from template with CD-ROM from ISO attached to the template</b><br>
 - [BZ 1602339](https://bugzilla.redhat.com/1602339) <b>VM with preallocated/RO disks only can run even if the storage domain that holds the disks is in maintenance</b><br>
 - [BZ 1600534](https://bugzilla.redhat.com/1600534) <b>Status code from the API for incompatible disk configuration for disk creation is 400 (bad request) instead of 409 (conflict)</b><br>

#### VDSM

 - [BZ 1560460](https://bugzilla.redhat.com/1560460) <b>getFileStats fails on NFS domain in case or recursive symbolic link (e.g., using NetApp snapshots)</b><br>

### No Doc Update

#### oVirt Engine

 - [BZ 1566112](https://bugzilla.redhat.com/1566112) <b>Exception when trying to run multiple VMs (VMs failed to run)</b><br>

