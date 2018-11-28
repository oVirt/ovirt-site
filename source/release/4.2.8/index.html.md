---
title: oVirt 4.2.8 Release Notes
category: documentation
layout: toc
---

# oVirt 4.2.8 Release Notes

The oVirt Project is pleased to announce the availability of the 4.2.8 First Release Candidate as of November 28, 2018.

oVirt is an open source alternative to VMware™ vSphere™, providing an
awesome KVM management interface for multi-node virtualization.
This release is available now for Red Hat Enterprise Linux 7.5,
CentOS Linux 7.5 (or similar).



For a general overview of oVirt, read the [Quick Start Guide](/documentation/quickstart/quickstart-guide/)
and visit the [About oVirt](/documentation/introduction/about-ovirt/) page.

For detailed installation instructions, read the [Installation Guide](/documentation/install-guide/Installation_Guide/).

To learn about features introduced before 4.2.8, see the [release notes for previous versions](/documentation/#previous-release-notes).


## Install / Upgrade from previous versions

### CentOS / RHEL





In order to install it on a clean system, you need to install


`# yum install `[`http://resources.ovirt.org/pub/yum-repo/ovirt-release42-pre.rpm`](http://resources.ovirt.org/pub/yum-repo/ovirt-release42-pre.rpm)


and then follow our
[Installation Guide](http://www.ovirt.org/documentation/install-guide/Installation_Guide/).


If you're upgrading from a previous release on Enterprise Linux 7 you just need
to execute:

      # yum install http://resources.ovirt.org/pub/yum-repo/ovirt-release42-pre.rpm
      # yum update "ovirt-*-setup*"
      # engine-setup



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

Don't enable all of EPEL on oVirt machines.

The ovirt-release package enables the EPEL repositories and includes several
specific packages that are required from there. It also enables and uses
the CentOS SIG repos, for other packages.

If you want to use other packages from EPEL, you should make sure to
use `includepkgs` and add only those you need avoiding to override
packages from other repos.

## What's New in 4.2.8?

### Enhancements

#### oVirt Engine

 - [BZ 1639460](https://bugzilla.redhat.com/1639460) <b>[RFE] inter-mac-pool or intra-mac-pool overlapping ranges: warn if found</b><br>
 - [BZ 1598447](https://bugzilla.redhat.com/1598447) <b>Provide a tool to find changed config values</b><br>Feature: <br><br>In previous versions there was no easy way how administrators could found out, which changes they have made to options exposed via engine-config tool, which could cause them issues after performing y-stream upgrades (for example 4.1 -> 4.2).<br><br>Reason: <br><br>Result: <br><br>We have added option -d/--diff to engine-config tool which will display administrators all differences between their current option values and default value provided by engine.<br>The differences are displayed using following format:<br><br> $ engine-config --diff<br> Name: vdsConnectionTimeout<br> Version: general<br> Current: 40<br> Default: 20
 - [BZ 1592990](https://bugzilla.redhat.com/1592990) <b>Cannot set number of IO threads via the UI</b><br>Feature: <br>The number of IO threads can be set in the web UI in the new/edit VM dialog.<br><br>Reason: <br>Some users may need to set the number of IO threads and using web UI can be easier than REST API.

#### oVirt Engine Metrics

 - [BZ 1645515](https://bugzilla.redhat.com/1645515) <b>[RFE] Add ansible-inventory file required for OCP/Origin 3.11 to metrics store machine</b><br>

### Other

#### oVirt Engine Metrics

 - [BZ 1620595](https://bugzilla.redhat.com/1620595) <b>Update README files to use etc/ovirt-engine-metrics/config.yml.d/ to update variables</b><br>

#### oVirt Provider OVN

 - [BZ 1648992](https://bugzilla.redhat.com/1648992) <b>Security group rules with remote_ip_prefix not working when ether type is not provided</b><br>

#### VDSM

 - [BZ 1637549](https://bugzilla.redhat.com/1637549) <b>[downstream clone - 4.2.8] Exception on unsetPortMirroring makes vmDestroy fail.</b><br>
 - [BZ 1612917](https://bugzilla.redhat.com/1612917) <b>Adding an IP address to a logical network wipes IP on other logical network</b><br>

#### oVirt Hosted Engine HA

 - [BZ 1643663](https://bugzilla.redhat.com/1643663) <b>Hosted-Engine VM failed to start mixing ovirt-hosted-engine-setup from 4.1 with ovirt-hosted-engine-ha from 4.2</b><br>
 - [BZ 1636469](https://bugzilla.redhat.com/1636469) <b>Removing a non-HE Host recommends user to undeploy HostedEngine on it first</b><br>

#### oVirt Engine

 - [BZ 1647384](https://bugzilla.redhat.com/1647384) <b>[downstream clone - 4.2.8] During cold reboot treatment, RunVm did not run for some VMs</b><br>
 - [BZ 1585950](https://bugzilla.redhat.com/1585950) <b>[downstream clone - 4.2.8] Live Merge failed on engine with "still in volume chain", but merge on host was successful</b><br>
 - [BZ 1649267](https://bugzilla.redhat.com/1649267) <b>[downstream clone - 4.2.8] [RHEL76] libvirt is unable to start after upgrade due to malformed UTCTIME values in cacert.pem, because properly renewed CA certificate was not passed to hosts by executing "Enroll certificate" or "Reinstall"</b><br>
 - [BZ 1637846](https://bugzilla.redhat.com/1637846) <b>RemoveVmCommand doesn't log the user</b><br>
 - [BZ 1638540](https://bugzilla.redhat.com/1638540) <b>LSM encountered WELD-000049 exception and never issued live merge</b><br>
 - [BZ 1477599](https://bugzilla.redhat.com/1477599) <b>[RFE] [UI+REST][Hosts>Network Interfaces] - Add indication that setup network operation is currently running on the host and not finished yet</b><br>
 - [BZ 1647025](https://bugzilla.redhat.com/1647025) <b>[downstream clone - 4.2.8] RESTAPI listing diskprofiles only shows 1 href for the same QoS even if there are more domains with the same QoS</b><br>
 - [BZ 1641622](https://bugzilla.redhat.com/1641622) <b>link for cluster's networkfilters returns 404</b><br>
 - [BZ 1635844](https://bugzilla.redhat.com/1635844) <b>Initialization does overwrite host sshkeys</b><br>
 - [BZ 1649615](https://bugzilla.redhat.com/1649615) <b>[downstream clone] engine fails to imports external VMs</b><br>
 - [BZ 1639650](https://bugzilla.redhat.com/1639650) <b>Hosted Engine VM is selected for balancing even though the BalanceVM command is not enabled for HE</b><br>
 - [BZ 1643826](https://bugzilla.redhat.com/1643826) <b>Updating template of VM Pool leaves tasks stuck after VMs shutdown</b><br>
 - [BZ 1651132](https://bugzilla.redhat.com/1651132) <b>[downstream clone - 4.2.8] Managing tags fails with ConcurrentModificationException</b><br>
 - [BZ 1506547](https://bugzilla.redhat.com/1506547) <b>Provisioning discovered host from oVirt via Foreman doesn't work</b><br>
 - [BZ 1646992](https://bugzilla.redhat.com/1646992) <b>[downstream clone - 4.2.8] Move Disk dialog keeps spinning - API method works</b><br>
 - [BZ 1641326](https://bugzilla.redhat.com/1641326) <b>NPE while querying for an ancestor image with no entry on 'images' table</b><br>
 - [BZ 1631215](https://bugzilla.redhat.com/1631215) <b>Upgrade of hosts causes no warning/error/change of status when running VMs are pinned to hosts</b><br>
 - [BZ 1637818](https://bugzilla.redhat.com/1637818) <b>[downstream clone - 4.2.8] engine-vacuum fails with 'vacuumdb: command not found'</b><br>
 - [BZ 1635196](https://bugzilla.redhat.com/1635196) <b>[downstream clone - 4.2.8] Pool does not appear for user in group until refresh</b><br>
 - [BZ 1639742](https://bugzilla.redhat.com/1639742) <b>After importing KVM VM, removing the VM and re-importing, the re-importing fails</b><br>
 - [BZ 1635942](https://bugzilla.redhat.com/1635942) <b>Clone VM with Direct LUN fails on UI but succeeds on backend.</b><br>

### No Doc Update

#### oVirt Engine

 - [BZ 1651521](https://bugzilla.redhat.com/1651521) <b>[downstream clone - 4.2.8] [RFE] provide a sorted list of available boot-iso in "run once" dialog for virtual machines</b><br>

