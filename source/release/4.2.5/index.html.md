---
title: oVirt 4.2.5 Release Notes
category: documentation
layout: toc
authors: sandrobonazzola
---

# oVirt 4.2.5 Release Notes

The oVirt Project is pleased to announce the availability of the 4.2.5 First Release Candidate as of July 02, 2018.

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

To learn about features introduced before 4.2.5, see the [release notes for previous versions](/documentation/#previous-release-notes).


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

## What's New in 4.2.5?

### Enhancements

#### oVirt image transfer daemon and proxy

 - [BZ 1585675](https://bugzilla.redhat.com/1585675) <b>[RFE] imageio unix socket support</b><br>Add UNIX socket support. Full documentation is available at: http://ovirt.github.io/ovirt-imageio/unix-socket.html

#### oVirt Engine

 - [BZ 1591730](https://bugzilla.redhat.com/1591730) <b>[RFE] allow a ui-plugin to set an icon on its left nav</b><br>This feature allows ui plugins to set an icon on their main menu navigation item.
 - [BZ 1136916](https://bugzilla.redhat.com/1136916) <b>[RFE] Add visual element to LUNs already in use by Storage domain in add External (Direct Lun) screen</b><br>Feature: <br>Add a visual element to LUNs already in use by storage domain in add External (Direct Lun) screen.<br><br>Reason: <br>Having the visual element will allow the user to skip such LUNs more efficiently.<br><br>Result:<br>LUNs which are already used by an external storage domain won't be able to be selected and appear as grayed out with an N/A button on the 'Actions' column.

### Rebase: Bug Fixeses and Enhancementss

#### oVirt Engine

 - [BZ 1596234](https://bugzilla.redhat.com/1596234) <b>[downstream clone - 4.2.5] Virtual machine lost its cdrom device</b><br>previously an ejected CDROM from VM could cause a problem when VM's Cluster level was updated from e.g. 4.1 to 4.2. Such CDROM device was lost and VM couldn't really use CDs anymore.<br>Now that has been fixed and CDROM devices should remain intact during upgrades regardless if they are in use or ejected.

### Bug Fixes

#### oVirt Engine

 - [BZ 1520848](https://bugzilla.redhat.com/1520848) <b>Hit Xorg Segmentation fault while installing rhel7.4 release guest in RHV 4.2 with QXL</b><br>

#### oVirt Engine Metrics

 - [BZ 1585666](https://bugzilla.redhat.com/1585666) <b>Some hosts stop reporting data to elasticsearch after a few minutes</b><br>

#### oVirt Hosted Engine Setup

 - [BZ 1588720](https://bugzilla.redhat.com/1588720) <b>A system wide proxy with no exception for the engine FQDN will cause a "Failed connect to <ManagerFQDN>:443; No route to host"</b><br>

#### cockpit-ovirt

 - [BZ 1584152](https://bugzilla.redhat.com/1584152) <b>[day2] Updated hosts are not persisted both the gdeploy config files</b><br>

### Other

#### oVirt image transfer daemon and proxy

 - [BZ 1527050](https://bugzilla.redhat.com/1527050) <b>[v2v] - ImageIO - Performance - upload disk is slow on a pure 10G environment</b><br>

#### oVirt Engine

 - [BZ 1576729](https://bugzilla.redhat.com/1576729) <b>XML based hot-(un)plug of disks and nics</b><br>
 - [BZ 1591751](https://bugzilla.redhat.com/1591751) <b>Recreate engine_cache dir during start and host deployment flows</b><br>
 - [BZ 1572250](https://bugzilla.redhat.com/1572250) <b>Disk total size is reported as 0 in disk collection if the disk does not have any snapshots</b><br>
 - [BZ 1586019](https://bugzilla.redhat.com/1586019) <b>[SR-IOV] - VF leakage when shutting down a VM from powering UP state</b><br>
 - [BZ 1447637](https://bugzilla.redhat.com/1447637) <b>[RFE] engine should report openvswitch package versions on each host</b><br>
 - [BZ 1526799](https://bugzilla.redhat.com/1526799) <b>[UI] - Add/Edit VM's vNIC dropdown: add external provider indication if relevant</b><br>
 - [BZ 1588738](https://bugzilla.redhat.com/1588738) <b>JsonMappingException in businessentities.storage.DiskImage prevents access to Engine</b><br>
 - [BZ 1595641](https://bugzilla.redhat.com/1595641) <b>Host install fail due to missing dependcy on python-netaddr</b><br>
 - [BZ 1592114](https://bugzilla.redhat.com/1592114) <b>StreamingAPI-  Download disk image & try to resume via SDK - operation should fail but succeeds</b><br>
 - [BZ 1583698](https://bugzilla.redhat.com/1583698) <b>Uninformative error message "Operation Failed" when trying to pause an image download via the API</b><br>

#### oVirt Engine Metrics

 - [BZ 1576391](https://bugzilla.redhat.com/1576391) <b>Paths in config should not include trailing /</b><br>

#### oVirt Hosted Engine Setup

 - [BZ 1574336](https://bugzilla.redhat.com/1574336) <b>Ansible logging improvements</b><br>
 - [BZ 1578144](https://bugzilla.redhat.com/1578144) <b>hosted-engine deploy asks for VM size using wrong units</b><br>
 - [BZ 1590266](https://bugzilla.redhat.com/1590266) <b>[RFE] Deployment should fail if the engine is not reachable by its FQDN</b><br>

#### cockpit-ovirt

 - [BZ 1540096](https://bugzilla.redhat.com/1540096) <b>Suggest to give the selection or hint of the glusterFS volume replica(at least 3) while deploying HE via cockpit with gluster based otopi</b><br>
 - [BZ 1558072](https://bugzilla.redhat.com/1558072) <b>Wizard exits when hitting ESC key when entering values on the wizard</b><br>
 - [BZ 1572051](https://bugzilla.redhat.com/1572051) <b>Cockpit is missing the "Getting Started" and "More Information" while using chrome</b><br>
 - [BZ 1550890](https://bugzilla.redhat.com/1550890) <b>[RFE][Text] Suggest to give a hint about the format of the "mount options" while deploying HE like the "Storage connection"</b><br>
 - [BZ 1558082](https://bugzilla.redhat.com/1558082) <b>"Are you sure?" dialog should pop when one close the wizard in the middle of the installation</b><br>
 - [BZ 1583498](https://bugzilla.redhat.com/1583498) <b>[day2] The configue ' Lv size ' text box under bricks tab in ' expand cluster ' operation is vanishing on a backspace.</b><br>
 - [BZ 1578687](https://bugzilla.redhat.com/1578687) <b>Re editing the tabs after the failure is not reflected in the congif file.(Day 2 operations)</b><br>
 - [BZ 1560405](https://bugzilla.redhat.com/1560405) <b>The UI for the brick configuration subtab is not clear.</b><br>
 - [BZ 1590891](https://bugzilla.redhat.com/1590891) <b>Accessing hosted engine page without gdeploy installed generates error</b><br>

#### imgbased

 - [BZ 1583145](https://bugzilla.redhat.com/1583145) <b>"nodectl check" failed after mount nfs storge via cockpit UI.</b><br>

#### VDSM

 - [BZ 1481022](https://bugzilla.redhat.com/1481022) <b>When blocking connection between host and NFS storage, a running VM doesn't switch to paused mode</b><br>
 - [BZ 1590063](https://bugzilla.redhat.com/1590063) <b>VM was destroyed on destination after successful migration due to missing the 'device' key on the lease device</b><br>
 - [BZ 1574631](https://bugzilla.redhat.com/1574631) <b>Problem to create snapshot</b><br>

### No Doc Update

#### oVirt Engine

 - [BZ 1551926](https://bugzilla.redhat.com/1551926) <b>[ja_JP] Text alignment correction needed on compute -> clusters -> new ->scheduling policy</b><br>

#### oVirt Hosted Engine HA

 - [BZ 1393839](https://bugzilla.redhat.com/1393839) <b>Hosted engine vm status remains paused on 1st host and starts on 2nd Host during hosted-storage disconnect and reconnect</b><br>

#### oVirt Hosted Engine Setup

 - [BZ 1573461](https://bugzilla.redhat.com/1573461) <b>[RFE] Sort Hosted-Engine answerfile's lines</b><br>

