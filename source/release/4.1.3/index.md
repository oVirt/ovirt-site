---
title: oVirt 4.1.3 Release Notes
category: documentation
toc: true
page_classes: releases
---

# oVirt 4.1.3 Release Notes

The oVirt Project is pleased to announce the availability of 4.1.3
Release as
of July 06, 2017.

oVirt is a free open-source distributed virtualization solution,
designed to manage your entire enterprise infrastructure.
oVirt uses the trusted KVM hypervisor and is built upon several other community
projects, including libvirt, Gluster, PatternFly, and Ansible.

This release is available now for Red Hat Enterprise Linux 7.3,
CentOS Linux 7.3 (or similar).
Packages for Fedora 24 are also available as a Tech Preview.

If you'd like to try oVirt as quickly as possible, follow the instructions on
the [Download](/download/) page.

For complete installation, administration, and usage instructions, see
the [oVirt Documentation](/documentation/).

For a general overview of oVirt, read the [About oVirt](/community/about.html)
page.

To learn about features introduced before 4.1.3, see the [release notes for previous versions](/documentation/#previous-release-notes).


### EPEL

Don't enable all of EPEL on oVirt machines.

The ovirt-release package enables the EPEL repositories and includes several
specific packages that are required from there. It also enables and uses
the CentOS SIG repos, for other packages.

EPEL currently includes collectd 5.7.1, and the collectd package there includes
the write_http plugin.

OpsTools currently includes collectd 5.7.0, and the write_http plugin is
packaged separately.

ovirt-release does not use collectd from EPEL, so if you only use it, you
should be ok.

If you want to use other packages from EPEL, you should make sure to not
include collectd. Either use `includepkgs` and add those you need, or use
`exclude=collectd*`.


## What's New in 4.1.3?

### Deprecated Functionality

#### oVirt Engine

 - [BZ 1441632](https://bugzilla.redhat.com/show_bug.cgi?id=1441632) <b>Hide "advanced" migration option a bit better</b><br>With this update, the migration of a virtual machine to a different cluster can no longer be invoked from the UI. Regular migration within a cluster remains unchanged.

### Enhancements

#### oVirt Engine SDK 4 Python

 - [BZ 1436981](https://bugzilla.redhat.com/show_bug.cgi?id=1436981) <b>[RFE] Add support for asynchronous requests and pipe-lining</b><br>The Python SDK now support asynchronous requests and HTTP pipe-lining. Users can now send requests asynchronously and wait for the response later in code. This makes it possible to send multiple request using multiple connections or pipelined connections, and wait for the response later, which improves performance when fetching multiple objects from the API.

#### oVirt Engine

 - [BZ 1444992](https://bugzilla.redhat.com/show_bug.cgi?id=1444992) <b>[RFE] Provide hook for vGPU</b><br>This update adds a new VDSM hook called vdsm-hook-vfio-mdev that makes the host capable of working with mdev capable devices such as GPUs. The hook is automatically installed. The following prerequisites apply for a virtual machine to use a mdev instance: <br>1) The host must have a kernel that supports mediated device, have the device and the correct drivers. <br>2) The predefined property, 'mdev_type', must be set and correspond to one of the mdev types supported by the device. <br>3) The virtual machine must be pinned to the host(s) with the device(s). <br><br>The supported mdev_type values can be determined by checking the host on which the device is present (not visible in the engine) by querying vdsm (vdsm-client Host hostdevListByCaps) or running the following bash script:<br><br>for device in /sys/class/mdev_bus/*; do<br>  for mdev_type in $device/mdev_supported_types/*; do<br>    MDEV_TYPE=$(basename $mdev_type)<br>    DESCRIPTION=$(cat $mdev_type/description)<br>    echo "mdev_type: $MDEV_TYPE --- description: $DESCRIPTION";<br>  done;<br>done | sort | uniq
 - [BZ 1432912](https://bugzilla.redhat.com/show_bug.cgi?id=1432912) <b>[RFE] add search query for "next run configuration exists"</b><br>It is now possible to search for VMs that have pending configuration changes. The search query is "Vms: next_run_configuration_exists=True"
 - [BZ 1426905](https://bugzilla.redhat.com/show_bug.cgi?id=1426905) <b>[Metrics Store] Install fluent-plugin-viaq_data_model plugin on engine machine</b><br>
 - [BZ 1431545](https://bugzilla.redhat.com/show_bug.cgi?id=1431545) <b>[RFE] remove the webadmin/userportal debuginfo packages and have automatic deobfuscation</b><br>With this update, GWT symbol maps, used to clarify obfuscated client-side (GWT UI) stack traces (/var/log/ovirt-engine/ui.log), are now part of the core Red Hat Virtualization Manager UI packages. The packages are installed by default when the Red Hat Virtualization Manager is installed or upgraded.<br><br>This update means that the user now has meaningful client-side stack traces in /var/log/ovirt-engine/ui.log without having to install additional packages, which saves time when analyzing UI related issues. This update also reduces the symbol maps size by zipping them. The Administration Portal UI uncompressed GWT symbol maps previously took ~1 GB of disk space. The zipped version consumes only 50 MB. The content of the zipped GWT symbol map files is streamed by the Manager as required and the content is not physically extracted to disk. After the Manager install or upgrade, the GWT symbol maps files use the following location:<br><br>/usr/share/ovirt-engine/gwt-symbols/webadmin/symbolMaps.zip<br><br>NOTE: The webadmin-portal-debuginfo package, which previously provided the GWT symbol map files, must now be manually removed prior to engine upgrade, or the upgrade will fail. (This package is an optional install, so you only need to remove it if you've manually installed it.)
 - [BZ 1421204](https://bugzilla.redhat.com/show_bug.cgi?id=1421204) <b>Allow TLSv1.2 during protocol negotiation for external provider communication</b><br>Previous versions of Red Hat Virtualization were able to negotiate encryption protocol up to TLSv1 for external provider communication. This update adds the the ability to negotiate encryption protocol up to TLSv1.2.<br><br>Note: The exact version used for communication depends on highest version available on the external provider target.

#### VDSM

 - [BZ 1022961](https://bugzilla.redhat.com/show_bug.cgi?id=1022961) <b>Gluster: running a VM from a gluster domain should use gluster URI instead of a fuse mount</b><br>
 - [BZ 1444992](https://bugzilla.redhat.com/show_bug.cgi?id=1444992) <b>[RFE] Provide hook for vGPU</b><br>This update adds a new VDSM hook called vdsm-hook-vfio-mdev that makes the host capable of working with mdev capable devices such as GPUs. The hook is automatically installed. The following prerequisites apply for a virtual machine to use a mdev instance: <br>1) The host must have a kernel that supports mediated device, have the device and the correct drivers. <br>2) The predefined property, 'mdev_type', must be set and correspond to one of the mdev types supported by the device. <br>3) The virtual machine must be pinned to the host(s) with the device(s). <br><br>The supported mdev_type values can be determined by checking the host on which the device is present (not visible in the engine) by querying vdsm (vdsm-client Host hostdevListByCaps) or running the following bash script:<br><br>for device in /sys/class/mdev_bus/*; do<br>  for mdev_type in $device/mdev_supported_types/*; do<br>    MDEV_TYPE=$(basename $mdev_type)<br>    DESCRIPTION=$(cat $mdev_type/description)<br>    echo "mdev_type: $MDEV_TYPE --- description: $DESCRIPTION";<br>  done;<br>done | sort | uniq
 - [BZ 1450646](https://bugzilla.redhat.com/show_bug.cgi?id=1450646) <b>[downstream clone - 4.1.3] "libvirt chain" message is not displayed in the vdsm logs by default during a live merge</b><br>This update makes it easier to debug a disk snapshot's live deletion failures because the initial state of the volume chain is logged.

#### oVirt Hosted Engine Setup

 - [BZ 1439281](https://bugzilla.redhat.com/show_bug.cgi?id=1439281) <b>Upgrading procedures hardcodes  admin@internal</b><br>The self-hosted engine Manager virtual machine upgrade procedure from Red Hat Enterprise Virtualization 3.6 on Red Hat Enterprise Linux 6 to Red Hat Virtualization 4.0 on Red Hat Enterprise Linux 7 now always tries to connect to the Manager API as admin@internal, making it more flexible.
 - [BZ 1426898](https://bugzilla.redhat.com/show_bug.cgi?id=1426898) <b>[Metrics Store] Include fluent-plugin-viaq_data_model in base node image</b><br>
 - [BZ 1426897](https://bugzilla.redhat.com/show_bug.cgi?id=1426897) <b>[Metrics Store] add fluent-plugin-collectd-nest to ovirt-hosted-engine-setup dependencies</b><br>

#### imgbased

 - [BZ 1368420](https://bugzilla.redhat.com/show_bug.cgi?id=1368420) <b>[RFE] Improve update speed</b><br>

#### oVirt Log collector

 - [BZ 1455771](https://bugzilla.redhat.com/show_bug.cgi?id=1455771) <b>[downstream clone - 4.1.3] [RFE] Log collector should collect time diff for all hosts</b><br>When collecting SOS reports from hosts, chrony and systemd SOS plugins can collect information about time synchronization. In addition, a new option --time-only has been added to ovirt-log-collector allowing information about time differences to be gathered from the hosts without gathering full SOS reports, saving a considerable amount of time for the operation.

#### oVirt Engine Metrics

 - [BZ 1429861](https://bugzilla.redhat.com/show_bug.cgi?id=1429861) <b>[RFE] Pass engine database credentials for postgresql collectd plugin</b><br>With this update, ovirt-engine-metrics can now configure collectd to connect to the Red Hat Virtualization Manager's postgresql database and get information from it. Previously, making collectd connect to the postgresql database did not work and was disabled by BZ#1436001.
 - [BZ 1418659](https://bugzilla.redhat.com/show_bug.cgi?id=1418659) <b>[RFE] Add fluentd configuration for parsing engine.log</b><br>With this update, engine.log has been added to the logs collection. The records are now parsed and sent to the central metrics store. This allows the administrator to analyse the logs in a more simple and comfortable way. This means that the engine.log records are available for analysis in Kibana.
 - [BZ 1434575](https://bugzilla.redhat.com/show_bug.cgi?id=1434575) <b>[RFE] Update engine and hosts fluentd configurations to use rubygem-fluent-plugin-collectd-nest</b><br>

#### oVirt Host Deploy

 - [BZ 1426903](https://bugzilla.redhat.com/show_bug.cgi?id=1426903) <b>[Metrics Store] Install fluent-plugin-collectd-nest with Fluentd</b><br>

### Known Issue

#### imgbased

 - [BZ 1455441](https://bugzilla.redhat.com/show_bug.cgi?id=1455441) <b>[downstream clone - 4.1.3] HostedEngine setup fails if RHV-H timezone < UTC set during installation</b><br>Previously, the self-hosted engine setup failed if the system clock was set to a time zone that was behind UTC during the installation. This is due to the fact that the Red Hat Virtualization Host generates VDSM certificates at the first boot and if the clock is incorrect, the chronyd or ntpd processes resynchronized the clock. This lead to an invalid certificate if the time zone was behind UTC.<br><br>Now, Red Hat Virtualization Host generates the certificates after the chronyd or ntpd processes, and waits two seconds for the clock to synchronize.<br><br>Note that if the Red Hat Virtualization Host is configured after the installation, or if the NTP server is too slow, the self-hosted engine setup may fail.

### No Doc Update

#### oVirt Engine

 - [BZ 1432105](https://bugzilla.redhat.com/show_bug.cgi?id=1432105) <b>Can't remove vm pool because of vm deadlock</b><br>
 - [BZ 1450000](https://bugzilla.redhat.com/show_bug.cgi?id=1450000) <b>Endless error message in events: Failed to create Template [..] or its disks from VM &lt;UNKNOWN&gt;</b><br>
 - [BZ 1452218](https://bugzilla.redhat.com/show_bug.cgi?id=1452218) <b>"Creation of Template from VM &lt;UNKNOWN&gt; has been completed" when creating an instance type</b><br>
 - [BZ 1441431](https://bugzilla.redhat.com/show_bug.cgi?id=1441431) <b>Use correct Cluster Level when displaying notice about adding additional HE Host.</b><br>

#### VDSM

 - [BZ 1435218](https://bugzilla.redhat.com/show_bug.cgi?id=1435218) <b>[scale] - getAllVmIoTunePolicies hit the performance</b><br>
 - [BZ 1451226](https://bugzilla.redhat.com/show_bug.cgi?id=1451226) <b>[downstream clone - 4.1.3] Add additional logging of LVM commands in VDSM</b><br>

### Technology Preview

#### oVirt Engine

 - [BZ 1456568](https://bugzilla.redhat.com/show_bug.cgi?id=1456568) <b>[downstream clone - 4.1.3] [RFE] enable VM portal in downstream (Tech Preview)</b><br>This release introduces a new VM Portal as a Technology Preview. A "VM Portal" link is now available on the Red Hat Virtualization Welcome Page. The VM Portal provides the same functionality that is available in the Basic tab of the current User Portal (now deprecated).

### Unclassified

#### oVirt Release Package

 - [BZ 1446167](https://bugzilla.redhat.com/show_bug.cgi?id=1446167) <b>[downstream clone - 4.1.3] [Test Only] Test Ansible playbook for registration</b><br>

#### oVirt Engine Extension AAA LDAP

 - [BZ 1440656](https://bugzilla.redhat.com/show_bug.cgi?id=1440656) <b>[AAA] No validation for user specified base DN unless Login or Search flows are invoked within setup tool</b><br>

#### oVirt Engine SDK 4 Python

 - [BZ 1450986](https://bugzilla.redhat.com/show_bug.cgi?id=1450986) <b>[RFE] Could the ovirtsdk4.Error improved ?</b><br>
 - [BZ 1459254](https://bugzilla.redhat.com/show_bug.cgi?id=1459254) <b>Content-type mix prevent Kerberos authentication</b><br>
 - [BZ 1459220](https://bugzilla.redhat.com/show_bug.cgi?id=1459220) <b>pycurl.HTTPAUTH_GSSNEGOTIATE moved from pycurl.Curl() to pycurl.CurlMulti() fails</b><br>
 - [BZ 1434830](https://bugzilla.redhat.com/show_bug.cgi?id=1434830) <b>Implement automatic SSO token renew</b><br>
 - [BZ 1451042](https://bugzilla.redhat.com/show_bug.cgi?id=1451042) <b>sdk curl debug fails with UnicodeDecodeError: 'utf8' codec can't decode</b><br>
 - [BZ 1440292](https://bugzilla.redhat.com/show_bug.cgi?id=1440292) <b>Validate API URL to respond with proper error message</b><br>
 - [BZ 1444114](https://bugzilla.redhat.com/show_bug.cgi?id=1444114) <b>Missing association of writers to type in python SDK4</b><br>

#### oVirt Engine

 - [BZ 1453163](https://bugzilla.redhat.com/show_bug.cgi?id=1453163) <b>[ENGINE] Add the ability to create and remove lease while vm is up</b><br>It is now possible to remove or add a VM lease to a VM while the VM is running
 - [BZ 1404607](https://bugzilla.redhat.com/show_bug.cgi?id=1404607) <b>Force updateOVF does not update OVF store when Adding VM/Disk or removing disk (Only removing VM works)</b><br>
 - [BZ 1446640](https://bugzilla.redhat.com/show_bug.cgi?id=1446640) <b>VM - Cannot run VM. Random Number Generator device is not supported in cluster</b><br>
 - [BZ 1450951](https://bugzilla.redhat.com/show_bug.cgi?id=1450951) <b>checkboxes and reset button in Host - Kernel tab don't work properly</b><br>
 - [BZ 1450674](https://bugzilla.redhat.com/show_bug.cgi?id=1450674) <b>[downstream clone - 4.1.3] RHV-M is not verifying the storage domain free space before running live merge</b><br>
 - [BZ 1446878](https://bugzilla.redhat.com/show_bug.cgi?id=1446878) <b>Attaching storage domain with lower compatibility version to 4.1 DC fails</b><br>
 - [BZ 1411075](https://bugzilla.redhat.com/show_bug.cgi?id=1411075) <b>Host name is &lt;UNKNOWN&gt; when VM started in stateless</b><br>
 - [BZ 1431529](https://bugzilla.redhat.com/show_bug.cgi?id=1431529) <b>Reinstall host remains in Non-operational state if gluster UUID is changed</b><br>
 - [BZ 1414787](https://bugzilla.redhat.com/show_bug.cgi?id=1414787) <b>Hide tracebacks in engine.log by upgrading non responsive host</b><br>
 - [BZ 1427104](https://bugzilla.redhat.com/show_bug.cgi?id=1427104) <b>Commit old snapshot ends with 'Error while executing action Revert to Snapshot: Internal Engine Error'</b><br>
 - [BZ 1454864](https://bugzilla.redhat.com/show_bug.cgi?id=1454864) <b>Engine should block attempting to reduce a domain that with undetectable metadata device</b><br>
 - [BZ 1436397](https://bugzilla.redhat.com/show_bug.cgi?id=1436397) <b>Migration failed  while Host is in 'preparing for maintenance' state - ...Destination: &lt;UNKNOWN&gt;</b><br>
 - [BZ 1442697](https://bugzilla.redhat.com/show_bug.cgi?id=1442697) <b>[Admin Portal] Exception caught when user cancels the deletion on network -> virtual machine sub-tab.</b><br>
 - [BZ 1365237](https://bugzilla.redhat.com/show_bug.cgi?id=1365237) <b>Upload image doesn't notice that the disk image was removed, it finalizes the upload and marks it as OK</b><br>
 - [BZ 1416550](https://bugzilla.redhat.com/show_bug.cgi?id=1416550) <b>Dialog "Select fence proxy preference type to add" in power management will not close when hit cancel</b><br>
 - [BZ 1452984](https://bugzilla.redhat.com/show_bug.cgi?id=1452984) <b>Engine may block reducing a valid device from block sd if the domain was restored manually</b><br>
 - [BZ 1421417](https://bugzilla.redhat.com/show_bug.cgi?id=1421417) <b>Disk remains in 'locked' state when blocking the connection from host to storage-domain during live storage migration</b><br>
 - [BZ 1460501](https://bugzilla.redhat.com/show_bug.cgi?id=1460501) <b>Failed to extend block-based storage domain, ExtendSANStorageDomainCommand pass multiple PVs with the same name</b><br>
 - [BZ 1460953](https://bugzilla.redhat.com/show_bug.cgi?id=1460953) <b>GET request for user's permissions gives NPE</b><br>
 - [BZ 1458107](https://bugzilla.redhat.com/show_bug.cgi?id=1458107) <b>Can not change host cluster while approving the "pending approval" host on rhvm4.1</b><br>
 - [BZ 1454843](https://bugzilla.redhat.com/show_bug.cgi?id=1454843) <b>[engine-backend] VM creation from template reported false negatively in engine.log</b><br>
 - [BZ 1460512](https://bugzilla.redhat.com/show_bug.cgi?id=1460512) <b>Useless log about removed luns is printed although no luns were removed</b><br>
 - [BZ 1443641](https://bugzilla.redhat.com/show_bug.cgi?id=1443641) <b>Unregistered external VMs should not be candidates for register once storage domain is being attached</b><br>
 - [BZ 1458568](https://bugzilla.redhat.com/show_bug.cgi?id=1458568) <b>Can't create a file domain after navigating to the new block storage domain window when Discard After Delete is checked</b><br>
 - [BZ 1459484](https://bugzilla.redhat.com/show_bug.cgi?id=1459484) <b>Lost Connection After Host Deploy when 4.1.3 Host Added to 4.1.2 Engine</b><br>
 - [BZ 1444120](https://bugzilla.redhat.com/show_bug.cgi?id=1444120) <b>After upgrade DC&cluster + Engine restart Reconstruct Master Domain for Data Center fails</b><br>
 - [BZ 1448882](https://bugzilla.redhat.com/show_bug.cgi?id=1448882) <b>UI | there are alignment issues when creating a template from vm with more than 3 disks</b><br>
 - [BZ 1421771](https://bugzilla.redhat.com/show_bug.cgi?id=1421771) <b>Affinity enforcement tries to balance HE VM</b><br>
 - [BZ 1429912](https://bugzilla.redhat.com/show_bug.cgi?id=1429912) <b>Random number generator source of pool VM is disabled in webadmin although RNG source is actually enabled on the VM.</b><br>
 - [BZ 1448511](https://bugzilla.redhat.com/show_bug.cgi?id=1448511) <b>event.id type is inconsistent</b><br>
 - [BZ 1455262](https://bugzilla.redhat.com/show_bug.cgi?id=1455262) <b>Use PostgreSQL JDBC drivers 9.2 on Fedora until regression found on newer versions is fixed</b><br>
 - [BZ 1458013](https://bugzilla.redhat.com/show_bug.cgi?id=1458013) <b>[downstream clone - 4.1.3] RHV-M portal shows incorrect inherited permission for users</b><br>
 - [BZ 1440440](https://bugzilla.redhat.com/show_bug.cgi?id=1440440) <b>English review of SSO messages that are surfaced to the login screen</b><br>
 - [BZ 1455469](https://bugzilla.redhat.com/show_bug.cgi?id=1455469) <b>Live storage migration tasks polling should start right away</b><br>
 - [BZ 1112120](https://bugzilla.redhat.com/show_bug.cgi?id=1112120) <b>[RFE] JSON RPC broker should pass correlation id to VDSM</b><br>
 - [BZ 1440861](https://bugzilla.redhat.com/show_bug.cgi?id=1440861) <b>Don't fail with 404 if session user doesn't exist in the database</b><br>
 - [BZ 1421715](https://bugzilla.redhat.com/show_bug.cgi?id=1421715) <b>[UI] Add Confirm 'Host has been Rebooted' button under 'Hosts' main tab</b><br>
 - [BZ 1439692](https://bugzilla.redhat.com/show_bug.cgi?id=1439692) <b>Unable to determine the correct call signature for deleteluns</b><br>
 - [BZ 1448905](https://bugzilla.redhat.com/show_bug.cgi?id=1448905) <b>Amend is allowed when VM is up</b><br>
 - [BZ 1445297](https://bugzilla.redhat.com/show_bug.cgi?id=1445297) <b>[RFE] make db upgrade scripts update vds_type of 'Red Hat Virtualization Host X.Y (elX.Y)' to correct value during update</b><br>
 - [BZ 1451246](https://bugzilla.redhat.com/show_bug.cgi?id=1451246) <b>changing storage type with Discard After Delete causes UI error</b><br>
 - [BZ 1434937](https://bugzilla.redhat.com/show_bug.cgi?id=1434937) <b>User &lt;UNKNOWN&gt; got disconnected from VM test3.</b><br>
 - [BZ 1433445](https://bugzilla.redhat.com/show_bug.cgi?id=1433445) <b>Skipped host update check due to unsupported host status is not logged in audit_log</b><br>
 - [BZ 1448832](https://bugzilla.redhat.com/show_bug.cgi?id=1448832) <b>API | read_only attribute is being ignored when attaching a disk to VM via API</b><br>
 - [BZ 1422099](https://bugzilla.redhat.com/show_bug.cgi?id=1422099) <b>VM lease selection in webadmin is enabled when it shouldn't</b><br>
 - [BZ 1440176](https://bugzilla.redhat.com/show_bug.cgi?id=1440176) <b>A template created from a HA VM with leases doesn't keep the lease config (only HA config)</b><br>
 - [BZ 1445348](https://bugzilla.redhat.com/show_bug.cgi?id=1445348) <b>Storage domain should have sub tab showing the VM leases residing on it</b><br>
 - [BZ 1403847](https://bugzilla.redhat.com/show_bug.cgi?id=1403847) <b>[UI] - Separate lines are missing for the column headers in some dialogs</b><br>
 - [BZ 1434605](https://bugzilla.redhat.com/show_bug.cgi?id=1434605) <b>SSO token used for the API expires when running only queries</b><br>

#### VDSM

 - [BZ 1430358](https://bugzilla.redhat.com/show_bug.cgi?id=1430358) <b>Restarting the SPM vdsm process during a cold merge, after cannot preview other snapshots</b><br>
 - [BZ 1444426](https://bugzilla.redhat.com/show_bug.cgi?id=1444426) <b>[RHEL 7.4] vdsm fail to start - libvirt 3.2 changes md5 to gssapi in libvirt.conf for sasl</b><br>undefined
 - [BZ 1443654](https://bugzilla.redhat.com/show_bug.cgi?id=1443654) <b>VDSM: too many tasks error (after network outage)</b><br>
 - [BZ 1386830](https://bugzilla.redhat.com/show_bug.cgi?id=1386830) <b>When creating a storage domain fails due to ClusterLockInitError, it is ignored and action completes</b><br>
 - [BZ 1424810](https://bugzilla.redhat.com/show_bug.cgi?id=1424810) <b>Failed to update custom bond mode by name with KeyError</b><br>
 - [BZ 1454696](https://bugzilla.redhat.com/show_bug.cgi?id=1454696) <b>vdsm-client uses unsecure instead of insecure</b><br>
 - [BZ 1447454](https://bugzilla.redhat.com/show_bug.cgi?id=1447454) <b>getVdsHardwareInfo fails with IndexError</b><br>
 - [BZ 1112120](https://bugzilla.redhat.com/show_bug.cgi?id=1112120) <b>[RFE] JSON RPC broker should pass correlation id to VDSM</b><br>
 - [BZ 1433734](https://bugzilla.redhat.com/show_bug.cgi?id=1433734) <b>Strange statsd nic metrics</b><br>
 - [BZ 1450989](https://bugzilla.redhat.com/show_bug.cgi?id=1450989) <b>Vdsm client is not aware when connection is stale</b><br>
 - [BZ 1443147](https://bugzilla.redhat.com/show_bug.cgi?id=1443147) <b>Cold Merge: Improve reduce when merging internal volumes</b><br>

#### VDSM JSON-RPC Java

 - [BZ 1459484](https://bugzilla.redhat.com/show_bug.cgi?id=1459484) <b>Lost Connection After Host Deploy when 4.1.3 Host Added to 4.1.2 Engine</b><br>
 - [BZ 1112120](https://bugzilla.redhat.com/show_bug.cgi?id=1112120) <b>[RFE] JSON RPC broker should pass correlation id to VDSM</b><br>

#### oVirt Provider OVN

 - [BZ 1424782](https://bugzilla.redhat.com/show_bug.cgi?id=1424782) <b>Supply firewalld service configuration file</b><br>

#### oVirt Hosted Engine Setup

 - [BZ 1467733](https://bugzilla.redhat.com/show_bug.cgi?id=1467733) <b>hosted-engine-setup fails installing with static networking configuration for the engine VM</b><br>

#### oVirt Hosted Engine HA

 - [BZ 1448699](https://bugzilla.redhat.com/show_bug.cgi?id=1448699) <b>Migration of the HE VM via engine will drop destination host to the status 'EngineUnexpectedlyDown'.</b><br>

#### imgbased

 - [BZ 1457670](https://bugzilla.redhat.com/show_bug.cgi?id=1457670) <b>Boot entry and layer are wrong after upgrade to rhvh-4.1-0.20170531.0</b><br>

#### oVirt Log collector

 - [BZ 1447790](https://bugzilla.redhat.com/show_bug.cgi?id=1447790) <b>Collect /var/log/messages (or journal output) from Engine as well</b><br>

#### oVirt Engine SDK 4 Ruby

 - [BZ 1443420](https://bugzilla.redhat.com/show_bug.cgi?id=1443420) <b>[RFE] Add a mechanism to check the HTTP result code of errors</b><br>
 - [BZ 1434831](https://bugzilla.redhat.com/show_bug.cgi?id=1434831) <b>Implement automatic SSO token renew</b><br>

#### oVirt Engine Metrics

 - [BZ 1458735](https://bugzilla.redhat.com/show_bug.cgi?id=1458735) <b>Logs in engine.log that contain javastacktrace break log parsing</b><br>
 - [BZ 1419858](https://bugzilla.redhat.com/show_bug.cgi?id=1419858) <b>Provide ovirt_env_name and engine_fqdn to be used in the fluentd.conf on the hosts and engine machines</b><br>
 - [BZ 1459425](https://bugzilla.redhat.com/show_bug.cgi?id=1459425) <b>engine.log timestamp must be in iso8601 or the record is not saved in the central metrics store</b><br>
 - [BZ 1459015](https://bugzilla.redhat.com/show_bug.cgi?id=1459015) <b>When keep_time_key is missing in in_tail fluentd plugin the records are sent with no timestamp</b><br>
 - [BZ 1458682](https://bugzilla.redhat.com/show_bug.cgi?id=1458682) <b>If config.yml is missing , the Ansible script finishes with no error message that indicates an issue</b><br>
 - [BZ 1434315](https://bugzilla.redhat.com/show_bug.cgi?id=1434315) <b>[RFE] Update  engine and hosts fluentd configurations to use fluent-plugin-viaq_data_model</b><br>
 - [BZ 1456238](https://bugzilla.redhat.com/show_bug.cgi?id=1456238) <b>[RFE] Add ipv4 and ipv6 to metrics and logs records</b><br>

#### oVirt Cockpit Plugin

 - [BZ 1452121](https://bugzilla.redhat.com/show_bug.cgi?id=1452121) <b>Update generated gdeploy config file to add 'qemu' user to 'gluster' group</b><br>
 - [BZ 1456155](https://bugzilla.redhat.com/show_bug.cgi?id=1456155) <b>disable-multipath.sh script section should be moved before creation of bricks in the conf file.</b><br>

## Bug fixes

### oVirt Setup Lib

 - [BZ 1452243](https://bugzilla.redhat.com/show_bug.cgi?id=1452243) <b>Interface matching regular expression ignores interfaces with a '-' in the name</b><br>

### oVirt Engine

 - [BZ 1463597](https://bugzilla.redhat.com/show_bug.cgi?id=1463597) <b>[downstream clone - 4.1.3] Issues with automating the configuration of VMs (cloud-init)</b><br>
 - [BZ 1455667](https://bugzilla.redhat.com/show_bug.cgi?id=1455667) <b>Increase SSHInactivityTimeoutSeconds​ for Upgrade host action</b><br>
 - [BZ 1443078](https://bugzilla.redhat.com/show_bug.cgi?id=1443078) <b>USB legacy VM originating in 3.5 env fails to start -  Attempted double use of PCI slot 0000:00:01.0 (may need "multifunction='on'" for device on function 0)</b><br>
 - [BZ 1446055](https://bugzilla.redhat.com/show_bug.cgi?id=1446055) <b>[downstream clone - 4.1.3] HA VMs running in two hosts at a time after restoring backup of RHV-M</b><br>
 - [BZ 1453010](https://bugzilla.redhat.com/show_bug.cgi?id=1453010) <b>The template created from vm snapshot contains no vm disk</b><br>
 - [BZ 1452182](https://bugzilla.redhat.com/show_bug.cgi?id=1452182) <b>engine-backup restores pki packaged files</b><br>
 - [BZ 1444611](https://bugzilla.redhat.com/show_bug.cgi?id=1444611) <b>Start VM failed with the exception, if the score module does not respond before the timeout</b><br>
 - [BZ 1456432](https://bugzilla.redhat.com/show_bug.cgi?id=1456432) <b>New uploaded QCOW2v3 Glance images will fail to be downloaded from Glance</b><br>
 - [BZ 1449289](https://bugzilla.redhat.com/show_bug.cgi?id=1449289) <b>RESTAPI - Amend (update VM disk attachment disk qcow2_v3 field) to raw disk is allowed</b><br>
 - [BZ 1435579](https://bugzilla.redhat.com/show_bug.cgi?id=1435579) <b>Failed to restart VM vm2-test-w2k12r2-1 on Host &lt;UNKNOWN&gt;</b><br>

### VDSM

 - [BZ 1438850](https://bugzilla.redhat.com/show_bug.cgi?id=1438850) <b>LiveMerge fails with libvirtError: Block copy still active. Disk not ready for pivot</b><br>

### oVirt Hosted Engine Setup

 - [BZ 1464866](https://bugzilla.redhat.com/show_bug.cgi?id=1464866) <b>[downstream clone - 4.1.3] hosted-engine --upgrade-appliance reports unsupported upgrade path</b><br>
 - [BZ 1458655](https://bugzilla.redhat.com/show_bug.cgi?id=1458655) <b>[downstream clone - 4.1.3] ovirt-hosted-engine-setup installs an older HE appliance and then upgrade to latest HE image (currently RHV-4.1)</b><br>
 - [BZ 1458654](https://bugzilla.redhat.com/show_bug.cgi?id=1458654) <b>[downstream clone - 4.1.3] ovirt-hosted-engine-setup has leftover mounts</b><br>

### oVirt Scheduler Proxy

 - [BZ 1444611](https://bugzilla.redhat.com/show_bug.cgi?id=1444611) <b>Start VM failed with the exception, if the score module does not respond before the timeout</b><br>
