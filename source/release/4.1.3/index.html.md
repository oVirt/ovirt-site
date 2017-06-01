---
title: oVirt 4.1.3 Release Notes
category: documentation
layout: toc
authors: sandrobonazzola
---

# oVirt 4.1.3 Release Notes

The oVirt Project is pleased to announce the availability of 4.1.3
Second Test Compose as
of June 01, 2017.

oVirt is an open source alternative to VMware™ vSphere™, and provides an
awesome KVM management interface for multi-node virtualization.
This release is available now for Red Hat Enterprise Linux 7.3,
CentOS Linux 7.3 (or similar).
Packages for Fedora 24 are also available as a Tech Preview.


This is pre-release software.
Please take a look at our [community page](/community/) to know how to
ask questions and interact with developers and users.
All issues or bugs should be reported via the
[Red Hat Bugzilla](https://bugzilla.redhat.com/enter_bug.cgi?classification=oVirt).
The oVirt Project makes no guarantees as to its suitability or usefulness.
This pre-release should not to be used in production, and it is not feature
complete.


To find out more about features which were added in previous oVirt releases,
check out the
[previous versions release notes](/develop/release-management/releases/).
For a general overview of oVirt, read
[the Quick Start Guide](Quick_Start_Guide)
and the [about oVirt](about oVirt) page.

[Installation guide](http://www.ovirt.org/documentation/install-guide/Installation_Guide/)
is available for updated and detailed installation instructions.

### Fedora / CentOS / RHEL


## RELEASE CANDIDATE

In order to install this Release Candidate you will need to enable pre-release repository.


In order to install it on a clean system, you need to install


`# yum install `[`http://resources.ovirt.org/pub/yum-repo/ovirt-release41-pre.rpm`](http://resources.ovirt.org/pub/yum-repo/ovirt-release41-pre.rpm)


and then follow our
[Installation guide](http://www.ovirt.org/documentation/install-guide/Installation_Guide/)



### oVirt Hosted Engine

If you're going to install oVirt as Hosted Engine on a clean system please
follow [Hosted_Engine_Howto#Fresh_Install](Hosted_Engine_Howto#Fresh_Install)
guide or the corresponding section in
[Self Hosted Engine Guide](/documentation/self-hosted/Self-Hosted_Engine_Guide/)

If you're upgrading an existing Hosted Engine setup, please follow
[Hosted_Engine_Howto#Upgrade_Hosted_Engine](Hosted_Engine_Howto#Upgrade_Hosted_Engine)
guide or the corresponding section within the
[Upgrade Guide](/documentation/upgrade-guide/upgrade-guide/)

### EPEL

TL;DR Don't enable all of EPEL on oVirt machines.

The ovirt-release package enables the epel repositories and includes several
specific packages that are required from there. It also enables and uses
the CentOS OpsTools SIG repos, for other packages.

EPEL currently includes collectd 5.7.1, and the collectd package there includes
the write_http plugin.

OpsTools currently includes collectd 5.7.0, and the write_http plugin is
packaged separately.

ovirt-release does not use collectd from epel, so if you only use it, you
should be ok.

If you want to use other packages from EPEL, you should make sure to not
include collectd. Either use `includepkgs` and add those you need, or use
`exclude=collectd*`.


## What's New in 4.1.3?

### Deprecated Functionality

#### oVirt Engine

 - [BZ 1441632](https://bugzilla.redhat.com/1441632) <b>Hide "advanced" migration option a bit better</b><br>Migration of VM to different cluster can't be invoked from UI any more. Regular migration withing a cluster remained untouched.

### Enhancements

#### oVirt Engine Extension AAA JDBC

 - [BZ 1452668](https://bugzilla.redhat.com/1452668) <b>[downstream clone - 4.1.3] [RFE] possibility to enter encrypted passwords in --password option</b><br>Feature: <br><br>In previous versions administrators had to enter unencrypted password during 'ovirt-aaa-jdbc-tool user password-reset' invocation. Then the password was encrypted inside ovirt-aaa-jdbc-tool and stored into database.<br><br>Now administrators can use new option --encrypted, which allows to enter already encrypted password during 'ovirt-aaa-jdbc-tool user password-reset' invocation.<br><br>However there are some caveats when providing encrypted passwords:<br><br>1. Entering encrypted password means, that password validity tests cannot be performed, so they are skipped and password is accepted even though it doesn't comply with password validation policy.<br><br>2. Password has to be encrypted using the same algorithm as configured, otherwise user will not be able to login (we cannot perform any tests that correct encryption algorithm was used). To encrypt password administrators can use '/usr/share/ovirt-engine/bin/ovirt-engine-crypto-tool.sh' tool, which provides 'pbe-encode' command to encrypt password using the default PBKDF2WithHmacSHA1 algorithm.<br><br><br>Reason: <br><br>Result:

#### oVirt Engine SDK 4 Python

 - [BZ 1436981](https://bugzilla.redhat.com/1436981) <b>[RFE] Add support for asynchronous requests and pipe-lining</b><br>Feature: <br>Add support for asynchronous requests and HTTP pipe-lining.<br><br>Reason: <br>higher performance of the Python SDK.<br><br>Result: <br>Python SDK now support asynchronous requests and HTTP pipe-lining. Users can now send a request asynchronously and wait for a response later in code, so it's possible to send multiple request using multiple connections or pipelined connections and wait for the response later, which improves performance when fetching multiple objects from API for example.

#### oVirt Engine

 - [BZ 1421204](https://bugzilla.redhat.com/1421204) <b>Allow TLSv1.2 during protocol negotiation for external provider communication</b><br>Feature: <br><br>Prior RHV versions were able to negotiate encryption protocol up to TLSv1 for external provider communication. This change adds ability to negotiate encryption protocol up to TLSv1.2 (exact version used for communication depends on highest version available on external provider target).<br><br>Reason: <br><br>Result:

#### VDSM

 - [BZ 917062](https://bugzilla.redhat.com/917062) <b>[RFE] add abrt integration</b><br>Feature: <br>Integrate ABRT service to oVirt: oVirt now installs abrt as part of initializing hypervisors. Abrt is configured by vdsm and exposes crash reports about internal processes errors.<br><br>Reason: <br>We used to configured Hypervisors to save core-dumps files after VM qemu process crashes. ABRT allows to save meaningful information for debugging without keeping full core-dump reports which consume a lot of memory space.<br><br>Result: <br>ABRT service is now running on each Hypervisor and exposes crash report as part of vdsm sos output.
 - [BZ 1444992](https://bugzilla.redhat.com/1444992) <b>[RFE] Provide hook for vGPU</b><br>
 - [BZ 1450646](https://bugzilla.redhat.com/1450646) <b>[downstream clone - 4.1.3] "libvirt chain" message is not displayed in the vdsm logs by default during a live merge</b><br>Feature: When removing a disk snapshot while a VM is running, information about the initial state of the volume chain is logged.<br><br>Reason: Having this information available in the logs makes it easier to debug failures.<br><br>Result: It is now easier to debug snapshot live deletion failures.

#### oVirt Hosted Engine Setup

 - [BZ 1426897](https://bugzilla.redhat.com/1426897) <b>[Metrics Store] add fluent-plugin-collectd-nest to ovirt-hosted-engine-setup dependencies</b><br>

#### imgbased

 - [BZ 1368420](https://bugzilla.redhat.com/1368420) <b>[RFE] Improve update speed</b><br>

#### oVirt Log collector

 - [BZ 1455771](https://bugzilla.redhat.com/1455771) <b>[downstream clone - 4.1.3] [RFE] Log collector should collect time diff for all hosts</b><br>When collecting sos reports from hosts, chrony and systemd sos plugins are now enabled collecting information about time synchronization. In addition, a new option --time-only has been added to ovirt-log-collector allowing to gather only information about time differences from the hosts without gathering full sos reports, saving a considerable amount of time for the operation.

### No Doc Update

#### oVirt Engine

 - [BZ 1441431](https://bugzilla.redhat.com/1441431) <b>Use correct Cluster Level when displaying notice about adding additional HE Host.</b><br>

#### VDSM

 - [BZ 1435218](https://bugzilla.redhat.com/1435218) <b>[scale] - getAllVmIoTunePolicies hit the performance</b><br>
 - [BZ 1451226](https://bugzilla.redhat.com/1451226) <b>[downstream clone - 4.1.3] Add additional logging of LVM commands in VDSM</b><br>

### Unclassified

#### oVirt Engine Extension AAA LDAP

 - [BZ 1440656](https://bugzilla.redhat.com/1440656) <b>[AAA] No validation for user specified base DN unless Login or Search flows are invoked within setup tool</b><br>

#### oVirt Engine SDK 4 Python

 - [BZ 1450986](https://bugzilla.redhat.com/1450986) <b>[RFE] Could the ovirtsdk4.Error improved ?</b><br>
 - [BZ 1451042](https://bugzilla.redhat.com/1451042) <b>sdk curl debug fails with UnicodeDecodeError: 'utf8' codec can't decode</b><br>
 - [BZ 1434830](https://bugzilla.redhat.com/1434830) <b>Implement automatic SSO token renew</b><br>
 - [BZ 1440292](https://bugzilla.redhat.com/1440292) <b>Validate API URL to respond with proper error message</b><br>
 - [BZ 1444114](https://bugzilla.redhat.com/1444114) <b>Missing association of writers to type in python SDK4</b><br>

#### oVirt Engine

 - [BZ 1450951](https://bugzilla.redhat.com/1450951) <b>checkboxes and reset button in Host - Kernel tab don't work properly</b><br>
 - [BZ 1450674](https://bugzilla.redhat.com/1450674) <b>[downstream clone - 4.1.3] RHV-M is not verifying the storage domain free space before running live merge</b><br>
 - [BZ 1446878](https://bugzilla.redhat.com/1446878) <b>Attaching storage domain with lower compatibility version to 4.1 DC fails</b><br>
 - [BZ 1450000](https://bugzilla.redhat.com/1450000) <b>Endless error message in events: Failed to create Template [..] or its disks from VM <UNKNOWN></b><br>
 - [BZ 1427104](https://bugzilla.redhat.com/1427104) <b>Commit old snapshot ends with 'Error while executing action Revert to Snapshot: Internal Engine Error'</b><br>
 - [BZ 1454864](https://bugzilla.redhat.com/1454864) <b>Engine should block attempting to reduce a domain that with undetectable metadata device</b><br>
 - [BZ 1436397](https://bugzilla.redhat.com/1436397) <b>Migration failed  while Host is in 'preparing for maintenance' state - ...Destination: <UNKNOWN></b><br>
 - [BZ 1442697](https://bugzilla.redhat.com/1442697) <b>[Admin Portal] Exception caught when user cancels the deletion on network -> virtual machine sub-tab.</b><br>
 - [BZ 1365237](https://bugzilla.redhat.com/1365237) <b>Upload image doesn't notice that the disk image was removed, it finalizes the upload and marks it as OK</b><br>
 - [BZ 1416550](https://bugzilla.redhat.com/1416550) <b>Dialog "Select fence proxy preference type to add" in power management will not close when hit cancel</b><br>
 - [BZ 1452984](https://bugzilla.redhat.com/1452984) <b>Engine may block reducing a valid device from block sd if the domain was restored manually</b><br>
 - [BZ 1455262](https://bugzilla.redhat.com/1455262) <b>Use PostgreSQL JDBC drivers 9.2 on Fedora until regression found on newer versions is fixed</b><br>
 - [BZ 1455011](https://bugzilla.redhat.com/1455011) <b>RHV-M portal shows incorrect inherited permission for users</b><br>
 - [BZ 1440440](https://bugzilla.redhat.com/1440440) <b>English review of SSO messages that are surfaced to the login screen</b><br>
 - [BZ 1455469](https://bugzilla.redhat.com/1455469) <b>Live storage migration tasks polling should start right away</b><br>
 - [BZ 1112120](https://bugzilla.redhat.com/1112120) <b>[RFE] JSON RPC broker should pass correlation id to VDSM</b><br>
 - [BZ 1440861](https://bugzilla.redhat.com/1440861) <b>Don't fail with 404 if session user doesn't exist in the database</b><br>
 - [BZ 1421715](https://bugzilla.redhat.com/1421715) <b>[UI] Add Confirm 'Host has been Rebooted' button under 'Hosts' main tab</b><br>
 - [BZ 1439692](https://bugzilla.redhat.com/1439692) <b>Unable to determine the correct call signature for deleteluns</b><br>
 - [BZ 1448905](https://bugzilla.redhat.com/1448905) <b>Amend is allowed when VM is up</b><br>
 - [BZ 1445297](https://bugzilla.redhat.com/1445297) <b>[RFE] make db upgrade scripts update vds_type of 'Red Hat Virtualization Host X.Y (elX.Y)' to correct value during update</b><br>
 - [BZ 1451246](https://bugzilla.redhat.com/1451246) <b>changing storage type with Discard After Delete causes UI error</b><br>
 - [BZ 1434937](https://bugzilla.redhat.com/1434937) <b>User <UNKNOWN> got disconnected from VM test3.</b><br>
 - [BZ 1433445](https://bugzilla.redhat.com/1433445) <b>Skipped host update check due to unsupported host status is not logged in audit_log</b><br>
 - [BZ 1448832](https://bugzilla.redhat.com/1448832) <b>API | read_only attribute is being ignored when attaching a disk to VM via API</b><br>
 - [BZ 1422099](https://bugzilla.redhat.com/1422099) <b>VM lease selection in webadmin is enabled when it shouldn't</b><br>
 - [BZ 1440176](https://bugzilla.redhat.com/1440176) <b>A template created from a HA VM with leases doesn't keep the lease config (only HA config)</b><br>
 - [BZ 1445348](https://bugzilla.redhat.com/1445348) <b>Storage domain should have sub tab showing the VM leases residing on it</b><br>
 - [BZ 1403847](https://bugzilla.redhat.com/1403847) <b>[UI] - Separate lines are missing for the column headers in some dialogs</b><br>
 - [BZ 1434605](https://bugzilla.redhat.com/1434605) <b>SSO token used for the API expires when running only queries</b><br>

#### VDSM

 - [BZ 1443654](https://bugzilla.redhat.com/1443654) <b>VDSM: too many tasks error (after network outage)</b><br>
 - [BZ 1424810](https://bugzilla.redhat.com/1424810) <b>Failed to update custom bond mode by name with KeyError</b><br>
 - [BZ 1447454](https://bugzilla.redhat.com/1447454) <b>getVdsHardwareInfo fails with IndexError</b><br>
 - [BZ 1112120](https://bugzilla.redhat.com/1112120) <b>[RFE] JSON RPC broker should pass correlation id to VDSM</b><br>
 - [BZ 1433734](https://bugzilla.redhat.com/1433734) <b>Strange statsd nic metrics</b><br>
 - [BZ 1450989](https://bugzilla.redhat.com/1450989) <b>Vdsm client is not aware when connection is stale</b><br>
 - [BZ 1443147](https://bugzilla.redhat.com/1443147) <b>Cold Merge: Improve reduce when merging internal volumes</b><br>

#### VDSM JSON-RPC Java

 - [BZ 1112120](https://bugzilla.redhat.com/1112120) <b>[RFE] JSON RPC broker should pass correlation id to VDSM</b><br>

#### oVirt Provider OVN

 - [BZ 1424782](https://bugzilla.redhat.com/1424782) <b>Supply firewalld service configuration file</b><br>

#### oVirt Hosted Engine Setup

 - [BZ 1449557](https://bugzilla.redhat.com/1449557) <b>ovirt-hosted-engine-setup installs an older HE appliance and then upgrade to latest HE image (currently RHV-4.1)</b><br>
 - [BZ 1439281](https://bugzilla.redhat.com/1439281) <b>Upgrading procedures hardcodes  admin@internal</b><br>
 - [BZ 1449565](https://bugzilla.redhat.com/1449565) <b>ovirt-hosted-engine-setup has leftover mounts</b><br>

#### oVirt Hosted Engine HA

 - [BZ 1448699](https://bugzilla.redhat.com/1448699) <b>Migration of the HE VM via engine will drop destination host to the status 'EngineUnexpectedlyDown'.</b><br>

#### oVirt Engine SDK 4 Ruby

 - [BZ 1443420](https://bugzilla.redhat.com/1443420) <b>[RFE] Add a mechanism to check the HTTP result code of errors</b><br>
 - [BZ 1434831](https://bugzilla.redhat.com/1434831) <b>Implement automatic SSO token renew</b><br>

## Bug fixes

### oVirt Setup Lib

 - [BZ 1452243](https://bugzilla.redhat.com/1452243) <b>Interface matching regular expression ignores interfaces with a '-' in the name</b><br>

### oVirt Engine

 - [BZ 1446055](https://bugzilla.redhat.com/1446055) <b>[downstream clone - 4.1.3] HA VMs running in two hosts at a time after restoring backup of RHV-M</b><br>
 - [BZ 1453010](https://bugzilla.redhat.com/1453010) <b>The template created from vm snapshot contains no vm disk</b><br>
 - [BZ 1452182](https://bugzilla.redhat.com/1452182) <b>engine-backup restores pki packaged files</b><br>
 - [BZ 1444611](https://bugzilla.redhat.com/1444611) <b>Start VM failed with the exception, if the score module does not respond before the timeout</b><br>
 - [BZ 1449289](https://bugzilla.redhat.com/1449289) <b>RESTAPI - Amend (update VM disk attachment disk qcow2_v3 field) to raw disk is allowed</b><br>
 - [BZ 1435579](https://bugzilla.redhat.com/1435579) <b>Failed to restart VM vm2-test-w2k12r2-1 on Host <UNKNOWN></b><br>

### VDSM

 - [BZ 1438850](https://bugzilla.redhat.com/1438850) <b>LiveMerge fails with libvirtError: Block copy still active. Disk not ready for pivot</b><br>
