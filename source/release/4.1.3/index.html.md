---
title: oVirt 4.1.3 Release Notes
category: documentation
layout: toc
authors: sandrobonazzola
---

# oVirt 4.1.3 Release Notes

The oVirt Project is pleased to announce the availability of 4.1.3
Second Release Candidate as
of June 16, 2017.

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

#### oVirt Engine SDK 4 Python

 - [BZ 1436981](https://bugzilla.redhat.com/1436981) <b>[RFE] Add support for asynchronous requests and pipe-lining</b><br>Feature: <br>Add support for asynchronous requests and HTTP pipe-lining.<br><br>Reason: <br>higher performance of the Python SDK.<br><br>Result: <br>Python SDK now support asynchronous requests and HTTP pipe-lining. Users can now send a request asynchronously and wait for a response later in code, so it's possible to send multiple request using multiple connections or pipelined connections and wait for the response later, which improves performance when fetching multiple objects from API for example.

#### oVirt Engine

 - [BZ 1444992](https://bugzilla.redhat.com/1444992) <b>[RFE] Provide hook for vGPU</b><br>This feature adds a new VDSM hook called vdsm-hook-vfio-mdev that makes the host capable of working with mdev capable devices such as GPUs. The hook should be installed automatically.<br><br>There are few requirements for a VM to use mdev instance:<br><br>1) the host must have kernel that supports mediated devices, have the device and correct drivers,<br>2) predefined property 'mdev_type' must be set and correspond to one of the mdev types supported by the device and<br>3) the VM must be pinned to the host(s) with the device(s).<br><br>The supported mdev_type values can be determined by checking the host where the device is present (not visible in the engine) by querying vdsm (vdsm-client Host hostdevListByCaps) or running the following bash script:<br><br>for device in /sys/class/mdev_bus/*; do<br>  for mdev_type in $device/mdev_supported_types/*; do<br>    MDEV_TYPE=$(basename $mdev_type)<br>    DESCRIPTION=$(cat $mdev_type/description)<br>    echo "mdev_type: $MDEV_TYPE --- description: $DESCRIPTION";<br>  done;<br>done | sort | uniq
 - [BZ 1426905](https://bugzilla.redhat.com/1426905) <b>[Metrics Store] Install fluent-plugin-viaq_data_model plugin on engine machine</b><br>
 - [BZ 1431545](https://bugzilla.redhat.com/1431545) <b>[RFE] make the webadmin/userportal debuginfo packages required</b><br>Feature:<br><br>GWT symbol maps, used to de-obfuscate client-side (GWT UI) stack traces [1], are now part of the core UI packages [2] and therefore available right upon Engine installation.<br><br>[1] /var/log/ovirt-engine/ui.log<br>[2] webadmin-portal + userportal<br><br>The complementary "debuginfo" packages [3], which were used to provide those GWT symbol map files, are now removed.<br><br>[3] webadmin-portal-debuginfo + userportal-debuginfo<br><br>Before upgrading Engine, old "debuginfo" packages must be manually removed first. (Otherwise, Engine setup will fail.)<br><br>Reason:<br><br>1, have meaningful (de-obfuscated) client-side stack traces right from the start, without having to install any additional packages (saves us time when analyzing UI related issues)<br><br>2, reduce disk size by having GWT symbol maps zipped (for example, WebAdmin UI specific uncompressed symbol maps take ~1 G of disk space)<br><br>Result:<br><br>After Engine install/upgrade, GWT symbol maps use the following layout:<br><br>/usr/share/ovirt-engine/gwt-symbols/webadmin/symbolMaps.zip<br>/usr/share/ovirt-engine/gwt-symbols/userportal/symbolMaps.zip<br><br>Additional info:<br><br>The content of above mentioned zip files is streamed by Engine as necessary; the content isn't physically extracted to disk.
 - [BZ 1421204](https://bugzilla.redhat.com/1421204) <b>Allow TLSv1.2 during protocol negotiation for external provider communication</b><br>Feature: <br><br>Prior RHV versions were able to negotiate encryption protocol up to TLSv1 for external provider communication. This change adds ability to negotiate encryption protocol up to TLSv1.2 (exact version used for communication depends on highest version available on external provider target).<br><br>Reason: <br><br>Result:

#### VDSM

 - [BZ 917062](https://bugzilla.redhat.com/917062) <b>[RFE] add abrt integration</b><br>Feature: <br>Integrate ABRT service to oVirt: oVirt now installs abrt as part of initializing hypervisors. Abrt is configured by vdsm and exposes crash reports about internal processes errors.<br><br>Reason: <br>We used to configured Hypervisors to save core-dumps files after VM qemu process crashes. ABRT allows to save meaningful information for debugging without keeping full core-dump reports which consume a lot of memory space.<br><br>Result: <br>ABRT service is now running on each Hypervisor and exposes crash report as part of vdsm sos output.
 - [BZ 1444992](https://bugzilla.redhat.com/1444992) <b>[RFE] Provide hook for vGPU</b><br>This feature adds a new VDSM hook called vdsm-hook-vfio-mdev that makes the host capable of working with mdev capable devices such as GPUs. The hook should be installed automatically.<br><br>There are few requirements for a VM to use mdev instance:<br><br>1) the host must have kernel that supports mediated devices, have the device and correct drivers,<br>2) predefined property 'mdev_type' must be set and correspond to one of the mdev types supported by the device and<br>3) the VM must be pinned to the host(s) with the device(s).<br><br>The supported mdev_type values can be determined by checking the host where the device is present (not visible in the engine) by querying vdsm (vdsm-client Host hostdevListByCaps) or running the following bash script:<br><br>for device in /sys/class/mdev_bus/*; do<br>  for mdev_type in $device/mdev_supported_types/*; do<br>    MDEV_TYPE=$(basename $mdev_type)<br>    DESCRIPTION=$(cat $mdev_type/description)<br>    echo "mdev_type: $MDEV_TYPE --- description: $DESCRIPTION";<br>  done;<br>done | sort | uniq
 - [BZ 1450646](https://bugzilla.redhat.com/1450646) <b>[downstream clone - 4.1.3] "libvirt chain" message is not displayed in the vdsm logs by default during a live merge</b><br>Feature: When removing a disk snapshot while a VM is running, information about the initial state of the volume chain is logged.<br><br>Reason: Having this information available in the logs makes it easier to debug failures.<br><br>Result: It is now easier to debug snapshot live deletion failures.

#### oVirt Hosted Engine Setup

 - [BZ 1439281](https://bugzilla.redhat.com/1439281) <b>Upgrading procedures hardcodes  admin@internal</b><br>3.6/el6 -> 4.0/el7 upgrade procedure form hosted-engine-setup was always trying to connect to the engine API as admin@internal, making it more flexible.
 - [BZ 1426898](https://bugzilla.redhat.com/1426898) <b>[Metrics Store] Include fluent-plugin-viaq_data_model in base node image</b><br>
 - [BZ 1426897](https://bugzilla.redhat.com/1426897) <b>[Metrics Store] add fluent-plugin-collectd-nest to ovirt-hosted-engine-setup dependencies</b><br>

#### imgbased

 - [BZ 1368420](https://bugzilla.redhat.com/1368420) <b>[RFE] Improve update speed</b><br>

#### oVirt Log collector

 - [BZ 1455771](https://bugzilla.redhat.com/1455771) <b>[downstream clone - 4.1.3] [RFE] Log collector should collect time diff for all hosts</b><br>When collecting sos reports from hosts, chrony and systemd sos plugins are now enabled collecting information about time synchronization. In addition, a new option --time-only has been added to ovirt-log-collector allowing to gather only information about time differences from the hosts without gathering full sos reports, saving a considerable amount of time for the operation.

#### oVirt Engine Metrics

 - [BZ 1429861](https://bugzilla.redhat.com/1429861) <b>[RFE] Pass engine database credentials for postgresql collectd plugin</b><br>Not sure this bug needs doc text. We should have proper documentation for this feature, see bug 1451625.<br><br>For current bug:<br><br>ovirt-engine-metrics can now configure collectd to connect to the engine's postgresql database and get information from it.<br><br>This (making collectd connect to the db) didn't work and was disabled by bug 1436001. Current bug makes it work and enables it.
 - [BZ 1418659](https://bugzilla.redhat.com/1418659) <b>[RFE] Add fluentd configuration for parsing engine.log</b><br>Feature: <br>Added engine.log to the logs collection.<br>Records are now parsed and sent to the central metrics store.<br><br>Reason: <br>This allows the admin to analyse hes logs in a more simple and comfortable way.<br><br>Result:<br>engine.log records are available for analysis in Kibana.
 - [BZ 1434575](https://bugzilla.redhat.com/1434575) <b>[RFE] Update engine and hosts fluentd configurations to use rubygem-fluent-plugin-collectd-nest</b><br>

#### oVirt Host Deploy

 - [BZ 1426903](https://bugzilla.redhat.com/1426903) <b>[Metrics Store] Install fluent-plugin-collectd-nest with Fluentd</b><br>

### Known Issue

#### imgbased

 - [BZ 1455441](https://bugzilla.redhat.com/1455441) <b>[downstream clone - 4.1.3] HostedEngine setup fails if RHV-H timezone < UTC set during installation</b><br>Cause: RHV-H generates vdsm certificates at the time of first boot.<br><br>Consequence: If the system clock is not set correctly at install time, chrony or ntpd may resynchronize the clock after the vdsm certificate is generated, leading to a certificate which is not valid yet if the appropriate timezone is behind UTC.<br><br>Workaround (if any): Set the system clock appropriately at install time. imgbased-configure-vdsm will now start after chronyd/ntpd and wait 2 seconds for the clock to sync, but this is not a guarantee.

### No Doc Update

#### oVirt Engine

 - [BZ 1432105](https://bugzilla.redhat.com/1432105) <b>Can't remove vm pool because of vm deadlock</b><br>
 - [BZ 1441431](https://bugzilla.redhat.com/1441431) <b>Use correct Cluster Level when displaying notice about adding additional HE Host.</b><br>

#### VDSM

 - [BZ 1435218](https://bugzilla.redhat.com/1435218) <b>[scale] - getAllVmIoTunePolicies hit the performance</b><br>
 - [BZ 1451226](https://bugzilla.redhat.com/1451226) <b>[downstream clone - 4.1.3] Add additional logging of LVM commands in VDSM</b><br>

### Unclassified

#### oVirt Engine Extension AAA LDAP

 - [BZ 1440656](https://bugzilla.redhat.com/1440656) <b>[AAA] No validation for user specified base DN unless Login or Search flows are invoked within setup tool</b><br>

#### oVirt Engine SDK 4 Python

 - [BZ 1450986](https://bugzilla.redhat.com/1450986) <b>[RFE] Could the ovirtsdk4.Error improved ?</b><br>
 - [BZ 1459254](https://bugzilla.redhat.com/1459254) <b>Content-type mix prevent Kerberos authentication</b><br>
 - [BZ 1459220](https://bugzilla.redhat.com/1459220) <b>pycurl.HTTPAUTH_GSSNEGOTIATE moved from pycurl.Curl() to pycurl.CurlMulti() fails</b><br>
 - [BZ 1434830](https://bugzilla.redhat.com/1434830) <b>Implement automatic SSO token renew</b><br>
 - [BZ 1451042](https://bugzilla.redhat.com/1451042) <b>sdk curl debug fails with UnicodeDecodeError: 'utf8' codec can't decode</b><br>
 - [BZ 1440292](https://bugzilla.redhat.com/1440292) <b>Validate API URL to respond with proper error message</b><br>
 - [BZ 1444114](https://bugzilla.redhat.com/1444114) <b>Missing association of writers to type in python SDK4</b><br>

#### oVirt Engine

 - [BZ 1446640](https://bugzilla.redhat.com/1446640) <b>VM - Cannot run VM. Random Number Generator device is not supported in cluster</b><br>
 - [BZ 1432912](https://bugzilla.redhat.com/1432912) <b>[RFE] add search query for "next run configuration exists"</b><br>
 - [BZ 1450951](https://bugzilla.redhat.com/1450951) <b>checkboxes and reset button in Host - Kernel tab don't work properly</b><br>
 - [BZ 1450674](https://bugzilla.redhat.com/1450674) <b>[downstream clone - 4.1.3] RHV-M is not verifying the storage domain free space before running live merge</b><br>
 - [BZ 1446878](https://bugzilla.redhat.com/1446878) <b>Attaching storage domain with lower compatibility version to 4.1 DC fails</b><br>
 - [BZ 1450000](https://bugzilla.redhat.com/1450000) <b>Endless error message in events: Failed to create Template [..] or its disks from VM <UNKNOWN></b><br>
 - [BZ 1452218](https://bugzilla.redhat.com/1452218) <b>"Creation of Template from VM <UNKNOWN> has been completed" when creating an instance type</b><br>
 - [BZ 1411075](https://bugzilla.redhat.com/1411075) <b>Host name is <UNKNOWN> when VM started in stateless</b><br>
 - [BZ 1431529](https://bugzilla.redhat.com/1431529) <b>Reinstall host remains in Non-operational state if gluster UUID is changed</b><br>
 - [BZ 1414787](https://bugzilla.redhat.com/1414787) <b>Hide tracebacks in engine.log by upgrading non responsive host</b><br>
 - [BZ 1427104](https://bugzilla.redhat.com/1427104) <b>Commit old snapshot ends with 'Error while executing action Revert to Snapshot: Internal Engine Error'</b><br>
 - [BZ 1454864](https://bugzilla.redhat.com/1454864) <b>Engine should block attempting to reduce a domain that with undetectable metadata device</b><br>
 - [BZ 1436397](https://bugzilla.redhat.com/1436397) <b>Migration failed  while Host is in 'preparing for maintenance' state - ...Destination: <UNKNOWN></b><br>
 - [BZ 1442697](https://bugzilla.redhat.com/1442697) <b>[Admin Portal] Exception caught when user cancels the deletion on network -> virtual machine sub-tab.</b><br>
 - [BZ 1365237](https://bugzilla.redhat.com/1365237) <b>Upload image doesn't notice that the disk image was removed, it finalizes the upload and marks it as OK</b><br>
 - [BZ 1416550](https://bugzilla.redhat.com/1416550) <b>Dialog "Select fence proxy preference type to add" in power management will not close when hit cancel</b><br>
 - [BZ 1452984](https://bugzilla.redhat.com/1452984) <b>Engine may block reducing a valid device from block sd if the domain was restored manually</b><br>
 - [BZ 1460501](https://bugzilla.redhat.com/1460501) <b>Failed to extend block-based storage domain, ExtendSANStorageDomainCommand pass multiple PVs with the same name</b><br>
 - [BZ 1460953](https://bugzilla.redhat.com/1460953) <b>GET request for user's permissions gives NPE</b><br>
 - [BZ 1458107](https://bugzilla.redhat.com/1458107) <b>Can not change host cluster while approving the "pending approval" host on rhvm4.1</b><br>
 - [BZ 1454843](https://bugzilla.redhat.com/1454843) <b>[engine-backend] VM creation from template reported false negatively in engine.log</b><br>
 - [BZ 1456432](https://bugzilla.redhat.com/1456432) <b>New uploaded QCOW2v3 Glance images will fail to be downloaded from Glance</b><br>
 - [BZ 1458568](https://bugzilla.redhat.com/1458568) <b>Can't create a file domain after navigating to the new block storage domain window when Discard After Delete is checked</b><br>
 - [BZ 1459484](https://bugzilla.redhat.com/1459484) <b>Lost Connection After Host Deploy when 4.1.3 Host Added to 4.1.2 Engine</b><br>
 - [BZ 1448882](https://bugzilla.redhat.com/1448882) <b>UI | there are alignment issues when creating a template from vm with more than 3 disks</b><br>
 - [BZ 1421771](https://bugzilla.redhat.com/1421771) <b>Affinity enforcement tries to balance HE VM</b><br>
 - [BZ 1429912](https://bugzilla.redhat.com/1429912) <b>Random number generator source of pool VM is disabled in webadmin although RNG source is actually enabled on the VM.</b><br>
 - [BZ 1448511](https://bugzilla.redhat.com/1448511) <b>event.id type is inconsistent</b><br>
 - [BZ 1455262](https://bugzilla.redhat.com/1455262) <b>Use PostgreSQL JDBC drivers 9.2 on Fedora until regression found on newer versions is fixed</b><br>
 - [BZ 1458013](https://bugzilla.redhat.com/1458013) <b>[downstream clone - 4.1.3] RHV-M portal shows incorrect inherited permission for users</b><br>
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

 - [BZ 1430358](https://bugzilla.redhat.com/1430358) <b>Restarting the SPM vdsm process during a cold merge, after cannot preview other snapshots</b><br>
 - [BZ 1444426](https://bugzilla.redhat.com/1444426) <b>[RHEL 7.4] vdsm fail to start - libvirt 3.2 changes md5 to gssapi in libvirt.conf for sasl</b><br>undefined
 - [BZ 1443654](https://bugzilla.redhat.com/1443654) <b>VDSM: too many tasks error (after network outage)</b><br>
 - [BZ 1386830](https://bugzilla.redhat.com/1386830) <b>When creating a storage domain fails due to ClusterLockInitError, it is ignored and action completes</b><br>
 - [BZ 1424810](https://bugzilla.redhat.com/1424810) <b>Failed to update custom bond mode by name with KeyError</b><br>
 - [BZ 1454696](https://bugzilla.redhat.com/1454696) <b>vdsm-client uses unsecure instead of insecure</b><br>
 - [BZ 1447454](https://bugzilla.redhat.com/1447454) <b>getVdsHardwareInfo fails with IndexError</b><br>
 - [BZ 1112120](https://bugzilla.redhat.com/1112120) <b>[RFE] JSON RPC broker should pass correlation id to VDSM</b><br>
 - [BZ 1433734](https://bugzilla.redhat.com/1433734) <b>Strange statsd nic metrics</b><br>
 - [BZ 1450989](https://bugzilla.redhat.com/1450989) <b>Vdsm client is not aware when connection is stale</b><br>
 - [BZ 1443147](https://bugzilla.redhat.com/1443147) <b>Cold Merge: Improve reduce when merging internal volumes</b><br>

#### VDSM JSON-RPC Java

 - [BZ 1459484](https://bugzilla.redhat.com/1459484) <b>Lost Connection After Host Deploy when 4.1.3 Host Added to 4.1.2 Engine</b><br>
 - [BZ 1112120](https://bugzilla.redhat.com/1112120) <b>[RFE] JSON RPC broker should pass correlation id to VDSM</b><br>

#### oVirt Provider OVN

 - [BZ 1424782](https://bugzilla.redhat.com/1424782) <b>Supply firewalld service configuration file</b><br>

#### oVirt Hosted Engine Setup

 - [BZ 1460982](https://bugzilla.redhat.com/1460982) <b>[downstream clone - 4.1.3] [TEXT] Error message is confusing when hosted-engine Storage Domain can't be mounted</b><br>
 - [BZ 1459229](https://bugzilla.redhat.com/1459229) <b>Interface matching regular expression ignores interfaces with a '-' in the name</b><br>

#### imgbased

 - [BZ 1457670](https://bugzilla.redhat.com/1457670) <b>Boot entry and layer are wrong after upgrade to rhvh-4.1-0.20170531.0</b><br>

#### oVirt Log collector

 - [BZ 1447790](https://bugzilla.redhat.com/1447790) <b>Collect /var/log/messages (or journal output) from Engine as well</b><br>

#### oVirt Engine SDK 4 Ruby

 - [BZ 1443420](https://bugzilla.redhat.com/1443420) <b>[RFE] Add a mechanism to check the HTTP result code of errors</b><br>
 - [BZ 1434831](https://bugzilla.redhat.com/1434831) <b>Implement automatic SSO token renew</b><br>

#### oVirt Engine Metrics

 - [BZ 1459425](https://bugzilla.redhat.com/1459425) <b>engine.log timestamp must be in iso8601 or the record is not saved in the central metrics store</b><br>
 - [BZ 1459015](https://bugzilla.redhat.com/1459015) <b>When keep_time_key is missing in in_tail fluentd plugin the records are sent with no timestamp</b><br>
 - [BZ 1458682](https://bugzilla.redhat.com/1458682) <b>If config.yml is missing , the Ansible script finishes with no error message that indicates an issue</b><br>
 - [BZ 1434315](https://bugzilla.redhat.com/1434315) <b>[RFE] Update  engine and hosts fluentd configurations to use fluent-plugin-viaq_data_model</b><br>

#### oVirt Cockpit Plugin

 - [BZ 1456155](https://bugzilla.redhat.com/1456155) <b>disable-multipath.sh script section should be moved before creation of bricks in the conf file.</b><br>
 - [BZ 1460614](https://bugzilla.redhat.com/1460614) <b>The page "Virtual Machines" has no response on Cockpit</b><br>

## Bug fixes

### oVirt Setup Lib

 - [BZ 1452243](https://bugzilla.redhat.com/1452243) <b>Interface matching regular expression ignores interfaces with a '-' in the name</b><br>

### oVirt Engine

 - [BZ 1455667](https://bugzilla.redhat.com/1455667) <b>Increase SSHInactivityTimeoutSeconds​ for Upgrade host action</b><br>
 - [BZ 1443078](https://bugzilla.redhat.com/1443078) <b>USB legacy VM originating in 3.5 env fails to start -  Attempted double use of PCI slot 0000:00:01.0 (may need "multifunction='on'" for device on function 0)</b><br>
 - [BZ 1446055](https://bugzilla.redhat.com/1446055) <b>[downstream clone - 4.1.3] HA VMs running in two hosts at a time after restoring backup of RHV-M</b><br>
 - [BZ 1453010](https://bugzilla.redhat.com/1453010) <b>The template created from vm snapshot contains no vm disk</b><br>
 - [BZ 1452182](https://bugzilla.redhat.com/1452182) <b>engine-backup restores pki packaged files</b><br>
 - [BZ 1413845](https://bugzilla.redhat.com/1413845) <b>HE vm does not get migrated to another node when the nic associated with ovirtmgmt is down.</b><br>
 - [BZ 1444611](https://bugzilla.redhat.com/1444611) <b>Start VM failed with the exception, if the score module does not respond before the timeout</b><br>
 - [BZ 1435579](https://bugzilla.redhat.com/1435579) <b>Failed to restart VM vm2-test-w2k12r2-1 on Host <UNKNOWN></b><br>

### VDSM

 - [BZ 1438850](https://bugzilla.redhat.com/1438850) <b>LiveMerge fails with libvirtError: Block copy still active. Disk not ready for pivot</b><br>

### oVirt Hosted Engine Setup

 - [BZ 1458655](https://bugzilla.redhat.com/1458655) <b>[downstream clone - 4.1.3] ovirt-hosted-engine-setup installs an older HE appliance and then upgrade to latest HE image (currently RHV-4.1)</b><br>
 - [BZ 1458654](https://bugzilla.redhat.com/1458654) <b>[downstream clone - 4.1.3] ovirt-hosted-engine-setup has leftover mounts</b><br>

### oVirt Scheduler Proxy

 - [BZ 1444611](https://bugzilla.redhat.com/1444611) <b>Start VM failed with the exception, if the score module does not respond before the timeout</b><br>

