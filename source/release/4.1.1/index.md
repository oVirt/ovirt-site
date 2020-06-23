---
title: oVirt 4.1.1 Release Notes
category: documentation
toc: true
authors: sandrobonazzola
page_classes: releases
---

# oVirt 4.1.1 Release Notes

The oVirt Project is pleased to announce the availability of 4.1.1
release as of March 22, 2017.

oVirt is an open source alternative to VMware™ vSphere™, providing an
awesome KVM management interface for multi-node virtualization.
This release is available now for Red Hat Enterprise Linux 7.3,
CentOS Linux 7.3 (or similar).

For detailed installation instructions, read the [Installation Guide](/documentation/install-guide/Installation_Guide/).

To learn about features introduced before 4.1.1, see the [release notes for previous versions](/documentation/#previous-release-notes).


## Install / Upgrade from previous versions


### Fedora / CentOS / RHEL



In order to install it on a clean system, you need to install


`# yum install `[`http://resources.ovirt.org/pub/yum-repo/ovirt-release41.rpm`](http://resources.ovirt.org/pub/yum-repo/ovirt-release41.rpm)


and then follow our
[Installation guide](http://www.ovirt.org/documentation/install-guide/Installation_Guide/)


If you're upgrading from a previous release on Enterprise Linux 7 you just need
to execute:

      # yum install http://resources.ovirt.org/pub/yum-repo/ovirt-release41.rpm
      # yum update "ovirt-*-setup*"
      # engine-setup



### oVirt Hosted Engine

If you're going to install oVirt as Hosted Engine on a clean system please
follow [Hosted_Engine_Howto#Fresh_Install](Hosted_Engine_Howto#Fresh_Install)
guide or the corresponding section in
[Self Hosted Engine Guide](/documentation/self-hosted/Self-Hosted_Engine_Guide/)

If you're upgrading an existing Hosted Engine setup, please follow
[Hosted_Engine_Howto#Upgrade_Hosted_Engine](Hosted_Engine_Howto#Upgrade_Hosted_Engine)
guide or the corresponding section within the
[Upgrade Guide](/documentation/upgrade_guide/)

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

## What's New in 4.1.1 Async release?
On April 6th 2017 the oVirt team issued an async release including the following fixes:

#### oVirt Engine
 - [BZ 1429534](https://bugzilla.redhat.com/1429534) <b>[scale] - tasks rejection, causing to corrupted monitoring.</b><br>
 - [BZ 1434941](https://bugzilla.redhat.com/1434941) <b>Previewing 3.5 snapshot with memory on 4.1 setup should not be allowed</b><br>
 - [BZ 1438260](https://bugzilla.redhat.com/1438260) <b>Failed to create VM from template with block-based raw disk as server</b><br>
 - [BZ 1419562](https://bugzilla.redhat.com/1419562) <b>[Sysprep] windows 2012 R2 and windows 2016 - failed to load sysprep file</b><br>
 - [BZ 1417518](https://bugzilla.redhat.com/1417518) <b>[HE] high availability compromised due to duplicate spm id</b><br>
 - [BZ 1417217](https://bugzilla.redhat.com/1417217) <b>SR-IOV vNIC unplugged after migration completed</b><br>

#### VDSM

 - [BZ 1426440](https://bugzilla.redhat.com/1426440) <b>During Live Merge, clear information about top/base/active volumes is not provided by INFO level logging</b><br>

#### oVirt Engine Metrics

 - [BZ 1434573](https://bugzilla.redhat.com/1434573) <b>Add apache collectd plugin on engine machine</b><br>Feature: <br>The Apache collectd plugin configurations were updated to the fluentd configuration file.<br>It will for now require updating the Apache instance name, url, user and password manually.<br><br>In the next version we plan to populate this automatically.<br><br>Reason: <br>To enable the user to monitor the Apache performance metrics in the remote metrics store.<br><br>Result:
 - [BZ 1434570](https://bugzilla.redhat.com/1434570) <b>Add postgresql collectd plugin on engine machine</b><br>Feature: <br>The Postgresql collectd plugin configurations were updated to the fluentd configuration file.<br>It will, for now, require updating the Postgresql database name, host, user and password manually.<br><br>In the next version we plan to populate this automatically.<br><br>Reason: <br>To enable the user to monitor the Postgresql performance metrics in the remote metrics store.<br><br>Result:

#### imgbased

 - [BZ 1433668](https://bugzilla.redhat.com/1433668) <b>The file modification in /etc of middle layer can not be updated to latest layer after upgrade multiple times</b><br>
 - [BZ 1434816](https://bugzilla.redhat.com/1434816) <b>Selinux issue blocks running VMs on 4.1 ngn after update from 4.0 ngn as virtlogd fails to start</b><br>
 - [BZ 1435887](https://bugzilla.redhat.com/1435887) <b>Failed to run cockpit after upgrade from NGN-3.6 to 4.1 node</b><br>
 - [BZ 1432385](https://bugzilla.redhat.com/1432385) <b>'imgbase layout' takes very long time to complete on rhv-h hypervisor with a large number of LUNs attached</b><br>
 - [BZ 1432359](https://bugzilla.redhat.com/1432359) <b>Default thin pool metadata size in RHV-H is less and utilization can reach 100%</b><br>

#### oVirt Engine DWH
 - [BZ 1404812](https://bugzilla.redhat.com/1404812) <b>dwhd sometimes does not update the engine db before stopping</b><br>

### oVirt Cockpit Plugin

 - [BZ 1434781](https://bugzilla.redhat.com/1434781) <b>Update brick_dirs of volume section to have absolute brick path from all the hosts</b><br>


## What's New in 4.1.1?

### Enhancements

#### oVirt Engine

 - [BZ 1413150](https://bugzilla.redhat.com/1413150) <b>[RFE] Add warning to change CL to the match the installed engine version</b><br>The Red Hat Virtualization Manager now provides warnings for all data centers and clusters that have not been upgraded to latest installed version. The compatibility version of all data centers is checked once a week, and on Manager startup. If it is not the latest version, an alert is raised and stored in the audit log. The Data Centers and Clusters main tabs now also show an exclamation mark icon for each data center or cluster that is not at the latest version. Hovering over this icon displays a recommendation to upgrade the compatibility version.
 - [BZ 1379074](https://bugzilla.redhat.com/1379074) <b>[storage] Improve logging for ExportVM flow</b><br>Previously, the ExportVmCommand appeared in the Engine log without the ID of the virtual machine being exported. This information has now been added to the log.<br><br>Note: After this change, users must have export permissions for the virtual machine and its disks to export a virtual machine. Previously, permissions to export virtual machine disks were sufficient.
 - [BZ 1408193](https://bugzilla.redhat.com/1408193) <b>[RFE] Update timestamp format in engine log to timestamp with timezone</b><br>From now on, all timestamp records for the engine and engine tools logs will contain a time zone to ease correlation between logs on the Manager and hosts. Previously engine.log contained a timestamp without a time zone, for example:<br><br>2017-02-27 13:35:06,720 INFO  [org.ovirt.engine.core.dal.dbbroker.DbFacade] (ServerService Thread Pool -- 51) [] Initializing the DbFacade<br><br>From now on there will always be a timezone identifier at the end of the timestamp part, for example:<br><br>2017-02-27 13:35:06,720+01 INFO  [org.ovirt.engine.core.dal.dbbroker.DbFacade] (ServerService Thread Pool -- 51) [] Initializing the DbFacade
 - [BZ 1424787](https://bugzilla.redhat.com/1424787) <b>'Available swap memory' warning should appear once a day, not every 30 minutes</b><br>
 - [BZ 1388430](https://bugzilla.redhat.com/1388430) <b>[RFE]  Provide a tool to execute vacuum full on engine database</b><br>This release adds a maintenance tool to run vacuum actions on the engine database (or specific tables). This tool optimizes table stats and compacts the internals of tables, resulting in less disk space usage, more efficient future maintenance work, and updated table stats for better query planning. Also provided is an engine-setup dialog that offers to perform vacuum during upgrades. This can be automated by the answer file.
 - [BZ 1369175](https://bugzilla.redhat.com/1369175) <b>VM Console options: hide "Enable USB Auto-Share" entry when USB is disabled.</b><br>The "Enable USB Auto-Share" option in the "Console options" dialog is now only available if "USB Support" is enabled on the virtual machine.
 - [BZ 1427987](https://bugzilla.redhat.com/1427987) <b>[downstream clone - 4.1.1] Provide a configuration to enable that user actions should succeed regardless of 'filter' parameter</b><br>The API supports the 'filter' parameter to indicate if results should be filtered according to the permissions of the user. Due to the way this is implemented, non admin users need to set this parameter for almost all operations, as the default value is 'false'. To simplify things for non admin users, this patch adds a configuration option ENGINE_API_FILTER_BY_DEFAULT which allows to change the default value to 'true', but only for non admin users. If the value is explicitly given in a request it will be honored.<br>    <br>If you change the value of ENGINE_API_FILTER_BY_DEFAULT to true, please be aware that this is a backwards compatibility breaking change, as clients that used non admin users and did *not* provide explicitly the 'filter' parameter will start to behave differently. However, this is unlikely, as calls from non admin users without the 'filter=true' is almost useless.<br><br>Here is the description of a new 'ENGINE_API_FILTER_BY_DEFAULT' configuration parameter:<br>    <br>  #<br>  # This flags indicates if 'filtering' should be enabled by default for<br>  # users that aren't administrators.<br>  #<br>  ENGINE_API_FILTER_BY_DEFAULT="false"<br>    <br>If it is necessary to change the default behaviour, it can be achieved by changing this parameter in a configuration file inside the '/etc/ovirt-engine/engine.conf.d' directory. For<br>example:<br>    <br>  # echo 'ENGINE_API_FILTER_BY_DEFAULT="true"' > \<br>  /etc/ovirt-engine/engine.conf.d/99-filter-by-default.conf<br>    <br>  # systemctl restart ovirt-engine
 - [BZ 1424821](https://bugzilla.redhat.com/1424821) <b>Add NFS V4.2 via RESTAPI</b><br>It is now possible to create NFS storage domains with NFS version 4.2 via the REST API.
 - [BZ 1412547](https://bugzilla.redhat.com/1412547) <b>Allow negotiation of highest available TLS version for engine <-> VDSM communication</b><br>Previously, when the Manager attempted to connect to VDSM it tried to negotiate the highest available version of TLS but due to previous issues there was a limitation to try TLSv1.0 as the highest version and to not try any higher version. Now, the limit has been removed so that TLSv1.1 and TLSv1.2 can be negotiated if they are available on the VDSM side. Removing this limit will allow TLSv1.0 to be dropped from future versions of VDSM.

#### VDSM

 - [BZ 1403839](https://bugzilla.redhat.com/1403839) <b>[RFE] Add ability to remove a single LUN from a data domain</b><br>With this update, the ability to remove LUNs from a block data domain has been added. This means that LUNs can be removed from a block data domain provided that there is enough free space on the other domain devices to contain the data stored on the LUNs being removed.

#### oVirt Hosted Engine Setup

 - [BZ 1330138](https://bugzilla.redhat.com/1330138) <b>ovirt-hosted-engine-setup needs to work with Networkmanager being enabled</b><br>ovirt-hosted-engine-setup should work with Networkmanager being enabled

#### oVirt Hosted Engine HA

 - [BZ 1101554](https://bugzilla.redhat.com/1101554) <b>[RFE] HE-ha: use vdsm api instead of vdsClient</b><br>With this update, the code interfacing with VDSM now uses the VDSM API directly instead of using vdsClient and xmlrpc.

#### oVirt Cockpit Plugin

 - [BZ 1358716](https://bugzilla.redhat.com/1358716) <b>Disable Hosted Engine Setup page after register RHVH to engine</b><br>The self-hosted engine setup wizard now warns users if the host is already registered to Red Hat Virtualization Manager. Previously, a host that was registered to the Manager but not running a self-hosted engine would present the option to set up a self-hosted engine, which ran the risk of unregistering the host. Now, hosts that are registered to the Manager present a "Redeploy" button in the Hosted Engine wizard in Cockpit, which must be selected in order to continue.
 - [BZ 1423542](https://bugzilla.redhat.com/1423542) <b>Include gdeploy preflight check</b><br>Gdeploy has a script to validate basic network setup and storage configuration before deploying Gluster. This script is now included in the generated gdeploy configuration for HyperConverged deployment so that users can deploy a cleaner HyperConverged environment.

#### oVirt Engine Metrics

 - [BZ 1424997](https://bugzilla.redhat.com/1424997) <b>[RFE]  Update fluentd configuration to fit the common data model</b><br>Feature: <br>Updated the fluentd configuration so the collectd record will be transformed to fit the common data model.<br><br>Reason: <br>The common data model is required so that data coming from multiple environments can co-exists without merging together and having different meaning to the same field name.<br>  <br>Result: <br>The data sent to the remote metrics store is now if the common data model format.

### No Doc Update

#### oVirt Engine

 - [BZ 1418537](https://bugzilla.redhat.com/1418537) <b>[Admin Portal] Exception while adding new host network QoS from cluster->logical networks->add network</b><br>

#### VDSM

 - [BZ 1215039](https://bugzilla.redhat.com/1215039) <b>[HC] - API schema for StorageDomainType is missing glusterfs type</b><br>

#### MOM

 - [BZ 1370081](https://bugzilla.redhat.com/1370081) <b>Deprecation warning about BaseException.message in a log</b><br>

#### oVirt Cockpit Plugin

 - [BZ 1427450](https://bugzilla.redhat.com/1427450) <b>drop the UI plugin check for cockpit on hosts</b><br>

#### imgbased

 - [BZ 1394259](https://bugzilla.redhat.com/1394259) <b>RHV-H 4.0 grub2-mkconfig fails</b><br>

### Unclassified

#### oVirt Engine

 - [BZ 1432081](https://bugzilla.redhat.com/1432081) <b>[ENGINE] Support HSM jobs on local storage</b><br>
 - [BZ 1421174](https://bugzilla.redhat.com/1421174) <b>Migration scheduler should work with per-VM cluster compatibility level</b><br>
 - [BZ 1426136](https://bugzilla.redhat.com/1426136) <b>Restarting vdsmd service on HSM host that copies data for cloning VM from template will cause that the LV container is not removed</b><br>
 - [BZ 1410506](https://bugzilla.redhat.com/1410506) <b>hotplug - Attaching a virtio-blk direct lun disk to VM that is up fails (only virtio-scsi is now supported with virtio-1.0 - machine type -7.3)</b><br>
 - [BZ 1414320](https://bugzilla.redhat.com/1414320) <b>oVirt reporting low disk space on template copy when there's still a plenty</b><br>
 - [BZ 1418247](https://bugzilla.redhat.com/1418247) <b>UI showing active geo-rep session, when the session was already removed from CLI</b><br>
 - [BZ 1414818](https://bugzilla.redhat.com/1414818) <b>Update affinity group drop general positive flag and moves VM to VM affinity to disabled state</b><br>
 - [BZ 1401010](https://bugzilla.redhat.com/1401010) <b>Memory and CPU donut shows nonsense value</b><br>
 - [BZ 1418757](https://bugzilla.redhat.com/1418757) <b>Package list for upgrade checks has to contain only valid packages per version</b><br>
 - [BZ 1415471](https://bugzilla.redhat.com/1415471) <b>Adding host to engine failed at first time but host was auto recovered after several mins</b><br>
 - [BZ 1414455](https://bugzilla.redhat.com/1414455) <b>removing disk in VM edit dialog causes UI error</b><br>
 - [BZ 1410606](https://bugzilla.redhat.com/1410606) <b>Imported VMs has max memory 0</b><br>
 - [BZ 1388456](https://bugzilla.redhat.com/1388456) <b>Disable TLSv1.0 in Apache SSL configuration</b><br>
 - [BZ 1406005](https://bugzilla.redhat.com/1406005) <b>[RFE][Metrics Store] Install Collectd and fluentd with relevant plugins on engine machine</b><br>
 - [BZ 1380356](https://bugzilla.redhat.com/1380356) <b>Engine confused by external network provider not responding to create-port command</b><br>
 - [BZ 1417554](https://bugzilla.redhat.com/1417554) <b>Mount options are not explicitly made visible, when the new storage domain is associated with gluster volume</b><br>
 - [BZ 1417571](https://bugzilla.redhat.com/1417571) <b>'Remote data sync setup' should throw helpful message, if there are no gluster geo-rep is setup for the volume</b><br>
 - [BZ 1417816](https://bugzilla.redhat.com/1417816) <b>Remote data sync setup should show up the scheduled time with 2 digit precision for hours and minutes</b><br>
 - [BZ 1418567](https://bugzilla.redhat.com/1418567) <b>Throw proper error/warning message, when removing the gluster geo-rep session associated with remote sync setup gluster data domain</b><br>
 - [BZ 1415759](https://bugzilla.redhat.com/1415759) <b>Trying to sparsify a direct lun via the REST API gives a NullPointerException</b><br>
 - [BZ 1408982](https://bugzilla.redhat.com/1408982) <b>Lease related tasks remain on SPM</b><br>
 - [BZ 1419529](https://bugzilla.redhat.com/1419529) <b>radio buttons overflow in Network Interface form</b><br>
 - [BZ 1418002](https://bugzilla.redhat.com/1418002) <b>[BUG] RHV cisco_ucs power management restart displays misleading message.</b><br>
 - [BZ 1413377](https://bugzilla.redhat.com/1413377) <b>Break bond and create new bond at the same time fail to get applied correctly</b><br>
 - [BZ 1410405](https://bugzilla.redhat.com/1410405) <b>unexpected TAB order in the external network subnet window</b><br>
 - [BZ 1368487](https://bugzilla.redhat.com/1368487) <b>RHGS/Gluster node is still in non-operational state, even after restarting the glusterd service from UI</b><br>
 - [BZ 1364137](https://bugzilla.redhat.com/1364137) <b>make VM template should be blocked while importing this VM.</b><br>
 - [BZ 1390575](https://bugzilla.redhat.com/1390575) <b>Import VM from data domain failed when trying to import a VM without re-assign MACs, but there is no MACs left in the destination pool</b><br>
 - [BZ 1406572](https://bugzilla.redhat.com/1406572) <b>Uncaught exception is received when trying to create a vm from User portal without power user role assigned</b><br>
 - [BZ 1421973](https://bugzilla.redhat.com/1421973) <b>[UI] Uncaught exception when dragging the whole interface panel on top of other interface panel in the Setup Networks dialog</b><br>
 - [BZ 1374589](https://bugzilla.redhat.com/1374589) <b>remove virtio-win drivers drop down for KVM imports</b><br>
 - [BZ 1429170](https://bugzilla.redhat.com/1429170) <b>Cold move of file based (nfs) disk failed when the VM is cloned from template as thin provision</b><br>
 - [BZ 1427104](https://bugzilla.redhat.com/1427104) <b>Commit old snapshot ends with 'Error while executing action Revert to Snapshot: Internal Engine Error'</b><br>
 - [BZ 1426265](https://bugzilla.redhat.com/1426265) <b>Sparsify should work on local storage</b><br>
 - [BZ 1430754](https://bugzilla.redhat.com/1430754) <b>Exception selecting Direct LUN radio button on new VM</b><br>
 - [BZ 1422779](https://bugzilla.redhat.com/1422779) <b>[UI] - 'Cloud-init' sub tab in the edit VM dialog - Network Interface disappeared from drop down list after adding new interface</b><br>
 - [BZ 1422505](https://bugzilla.redhat.com/1422505) <b>metrics stuff should be in own repo</b><br>
 - [BZ 1419327](https://bugzilla.redhat.com/1419327) <b>Discard data is not supported after upgrading the DC to 4.1</b><br>
 - [BZ 1419352](https://bugzilla.redhat.com/1419352) <b>After upgrading from 4.0.6 to 4.1 the GUI dialog for moving the disks from one Storage to another is not rendered correctly (when multiple disks(>8) are selected for move.)</b><br>
 - [BZ 1408134](https://bugzilla.redhat.com/1408134) <b>BUG: "interface" field empty in "attach disk" windows Ovirt 4.0.5</b><br>
 - [BZ 1420265](https://bugzilla.redhat.com/1420265) <b>Attempting to remove disk from storage domain in template's storage sub-tab results in exception</b><br>
 - [BZ 1415806](https://bugzilla.redhat.com/1415806) <b>oVirt 4.1 translation cycle 2</b><br>
 - [BZ 1425705](https://bugzilla.redhat.com/1425705) <b>taskcleaner.sh fails on non existing columns in command_entities table</b><br>
 - [BZ 1379225](https://bugzilla.redhat.com/1379225) <b>cannot assign gluster network role using api</b><br>
 - [BZ 1412626](https://bugzilla.redhat.com/1412626) <b>[scale] High Database Load after updating to oVirt 4.0.4 (select * from  getdisksvmguid)</b><br>
 - [BZ 1419520](https://bugzilla.redhat.com/1419520) <b>Detaching all vms from a pool via REST API doesn't remove the pool</b><br>
 - [BZ 1420302](https://bugzilla.redhat.com/1420302) <b>Adding fence agent with type "invalid_type" succeeds</b><br>
 - [BZ 1422562](https://bugzilla.redhat.com/1422562) <b>Return value of engine-vacuum on successful should be always 0</b><br>
 - [BZ 1421942](https://bugzilla.redhat.com/1421942) <b>Update dashboards DWH views version and dashboards queries</b><br>
 - [BZ 1421962](https://bugzilla.redhat.com/1421962) <b>[RFE] Add JMX support for jconsole</b><br>
 - [BZ 1416830](https://bugzilla.redhat.com/1416830) <b>Search by tags generates wrong filter string in Users tab</b><br>
 - [BZ 1414430](https://bugzilla.redhat.com/1414430) <b>Disable sparsify option for pre allocated disk</b><br>
 - [BZ 1422089](https://bugzilla.redhat.com/1422089) <b>Missing exit code for post-copy migration failure</b><br>
 - [BZ 1399603](https://bugzilla.redhat.com/1399603) <b>Import template from glance and export it to export domain will cause that it is impossible to import it</b><br>
 - [BZ 1417439](https://bugzilla.redhat.com/1417439) <b>When adding lease using REST high availability should be enabled first</b><br>
 - [BZ 1421285](https://bugzilla.redhat.com/1421285) <b>oVirt 4.1 update it_IT community translation</b><br>
 - [BZ 1421619](https://bugzilla.redhat.com/1421619) <b>Command proceed to perform the next execution phase although execute() failed</b><br>
 - [BZ 1417903](https://bugzilla.redhat.com/1417903) <b>Trying to download an image when it's storage domain is in maintenance locks the image for good</b><br>
 - [BZ 1420821](https://bugzilla.redhat.com/1420821) <b>style issues in block storage dialog</b><br>
 - [BZ 1420816](https://bugzilla.redhat.com/1420816) <b>missing Interface column on Storage and Disks sub-tabs under Templates main-tab</b><br>
 - [BZ 1420812](https://bugzilla.redhat.com/1420812) <b>DirectLUN dialog - missing label for 'Use Host' select-box</b><br>
 - [BZ 1419886](https://bugzilla.redhat.com/1419886) <b>Upload image operations are available using the GUI when there is an active download of the image using the python sdk (for the image that is downloaded)</b><br>
 - [BZ 1412687](https://bugzilla.redhat.com/1412687) <b>Awkward attempted login error</b><br>
 - [BZ 1419337](https://bugzilla.redhat.com/1419337) <b>Random Generator setting did not saved after reboot</b><br>Previously, if the RNG configuration was changed on a running VM, after restart of the VM the configuration was not properly restored.<br><br>Please note that the fix takes effect only on VMs which have been restarted on the fixed version of the engine.
 - [BZ 1414126](https://bugzilla.redhat.com/1414126) <b>UI error on 'wipe' and 'discard' being mutually exclusive is unclear and appears too late</b><br>
 - [BZ 1416845](https://bugzilla.redhat.com/1416845) <b>Can not add power management to the host, when the host has state 'UP'</b><br>
 - [BZ 1379130](https://bugzilla.redhat.com/1379130) <b>Unexpected client exception when glance server is not reachable</b><br>
 - [BZ 1419364](https://bugzilla.redhat.com/1419364) <b>Fail to register an unregistered Template through REST due to an NPE when calling updateMaxMemorySize</b><br>
 - [BZ 1414083](https://bugzilla.redhat.com/1414083) <b>User Name required for login on behalf</b><br>
 - [BZ 1414086](https://bugzilla.redhat.com/1414086) <b>Remove redundant video cards when no graphics available for a VM and also add video cards if one graphics device exists</b><br>
 - [BZ 1347356](https://bugzilla.redhat.com/1347356) <b>Pending Virtual Machine Changes -> minAllocatedMem issues</b><br>
 - [BZ 1416340](https://bugzilla.redhat.com/1416340) <b>Change name of check box in Edit Virtual Disks window from Pass Discard to Enable Discard</b><br>
 - [BZ 1400500](https://bugzilla.redhat.com/1400500) <b>If AvailableUpdatesFinder finds already running process it should not be ERROR level</b><br>
 - [BZ 1416837](https://bugzilla.redhat.com/1416837) <b>Order VMs by Uptime doesn't work</b><br>
 - [BZ 1416809](https://bugzilla.redhat.com/1416809) <b>New HSM infrastructure - No QCow version displayed for images created with 4.0</b><br>
 - [BZ 1416147](https://bugzilla.redhat.com/1416147) <b>Version 3 of the API doesn't implement the 'testconnectivity' action of external providers</b><br>
 - [BZ 1415639](https://bugzilla.redhat.com/1415639) <b>Some of the values are not considered as numbers by elasticsearch</b><br>
 - [BZ 1414084](https://bugzilla.redhat.com/1414084) <b>uploaded images using the GUI have actual_size=0</b><br>

#### VDSM

 - [BZ 1434304](https://bugzilla.redhat.com/1434304) <b>[VDSM] Support HSM jobs on local storage</b><br>
 - [BZ 1425161](https://bugzilla.redhat.com/1425161) <b>Vm disk corrupted after virt-sparsify fails due to connection failure</b><br>
 - [BZ 1426727](https://bugzilla.redhat.com/1426727) <b>VM dies during live migration with CPU quotas enabled</b><br>
 - [BZ 1374545](https://bugzilla.redhat.com/1374545) <b>Guest LVs created in ovirt raw volumes are auto activated on the hypervisor in RHEL 7</b><br>
 - [BZ 1418145](https://bugzilla.redhat.com/1418145) <b>[RFE] VDSM Hook for use of local storage of host</b><br>
 - [BZ 1414323](https://bugzilla.redhat.com/1414323) <b>Failed to add host to engine via bond+vlan configured by NM during anaconda</b><br>
 - [BZ 1368364](https://bugzilla.redhat.com/1368364) <b>Reported Node version and release are incorrect - RHEL version should be reported</b><br>
 - [BZ 1419931](https://bugzilla.redhat.com/1419931) <b>Failed to destroy partially-initialized VM with port mirroring</b><br>
 - [BZ 1408190](https://bugzilla.redhat.com/1408190) <b>[RFE] Update timestamp format in vdsm log to timestamp with timezone</b><br>
 - [BZ 1412563](https://bugzilla.redhat.com/1412563) <b>parse arp_ip_target with multiple ip properly</b><br>
 - [BZ 1410076](https://bugzilla.redhat.com/1410076) <b>[SR-IOV] - in-guest bond with virtio+passthrough slave lose connectivity after hotunplug/hotplug of passthrough slave</b><br>
 - [BZ 1427444](https://bugzilla.redhat.com/1427444) <b>post copy event handling triggered by any libvirt event</b><br>
 - [BZ 1412583](https://bugzilla.redhat.com/1412583) <b>Multiple disconnect messages in VDSM log</b><br>
 - [BZ 1376116](https://bugzilla.redhat.com/1376116) <b>Vdsm install "api" package in the python global namespace</b><br>
 - [BZ 1422087](https://bugzilla.redhat.com/1422087) <b>wrong VMware OVA import capacity</b><br>
 - [BZ 1412550](https://bugzilla.redhat.com/1412550) <b>Fix certificate validation for engine <-> VDSM encrypted connection when IPv6 is configured</b><br>
 - [BZ 1414626](https://bugzilla.redhat.com/1414626) <b>Crash VM during migrating with error "Failed in MigrateBrokerVDS"</b><br>
 - [BZ 1419557](https://bugzilla.redhat.com/1419557) <b>Switching to post-copy should catch exceptions</b><br>
 - [BZ 1417460](https://bugzilla.redhat.com/1417460) <b>Failed to Amend Qcow volume on block SD due failure on Qemu-image</b><br>
 - [BZ 1417737](https://bugzilla.redhat.com/1417737) <b>Cold Merge: Deprecate mergeSnapshots verb</b><br>
 - [BZ 1415803](https://bugzilla.redhat.com/1415803) <b>Improve logging during live merge</b><br>

#### oVirt Engine Extension AAA JDBC

 - [BZ 1415704](https://bugzilla.redhat.com/1415704) <b>Casting exception during group show by ovirt-aaa-jdbc tool</b><br>

#### oVirt Hosted Engine Setup

 - [BZ 1420283](https://bugzilla.redhat.com/1420283) <b>Ensure that upgrading the engine vm from 3.6/el6 to 4.0/el7 is properly working once we release 4.1</b><br>
 - [BZ 1421654](https://bugzilla.redhat.com/1421654) <b>hosted-engine --upgrade-appliance does not show correct the engine version</b><br>
 - [BZ 1411640](https://bugzilla.redhat.com/1411640) <b>[HC] - Include gdeploy package in oVirt Node</b><br>

#### oVirt Release Package

 - [BZ 1418630](https://bugzilla.redhat.com/1418630) <b>gluster firewalld service should be added to the default firewall zone</b><br>
 - [BZ 1419105](https://bugzilla.redhat.com/1419105) <b>oVirt Node NG does not include vdsm-hook-vhostmd</b><br>
 - [BZ 1411640](https://bugzilla.redhat.com/1411640) <b>[HC] - Include gdeploy package in oVirt Node</b><br>

#### oVirt Cockpit Plugin

 - [BZ 1415655](https://bugzilla.redhat.com/1415655) <b>Arbiter flag should not be enabled by default in gdeploy wizard</b><br>
 - [BZ 1415657](https://bugzilla.redhat.com/1415657) <b>Do not allow the user to proceed further if he does not fill mandatory fields required for deployment.</b><br>
 - [BZ 1421249](https://bugzilla.redhat.com/1421249) <b>Cannot use cockpit for hosted-engine setup if gpg keys have not already been accepted</b><br>
 - [BZ 1363971](https://bugzilla.redhat.com/1363971) <b>Appliance root password prompt popup in browser when entering the appliance password in cockpit</b><br>
 - [BZ 1416175](https://bugzilla.redhat.com/1416175) <b>Remove the NTP server configuration from gdeploy</b><br>
 - [BZ 1416168](https://bugzilla.redhat.com/1416168) <b>NetworkManager need not be stopped and disabled</b><br>
 - [BZ 1429287](https://bugzilla.redhat.com/1429287) <b>Hint the user that the third node will be the Arbiter node, in case of arbiter volume creation</b><br>
 - [BZ 1430370](https://bugzilla.redhat.com/1430370) <b>add 'poolmetadatasize' to thinpool in gdeploy config file</b><br>
 - [BZ 1430188](https://bugzilla.redhat.com/1430188) <b>Remove step of installing appliance from generated gdeploy config file</b><br>
 - [BZ 1426527](https://bugzilla.redhat.com/1426527) <b>Update the gluster volume options set via generated gdeploy config file</b><br>
 - [BZ 1415615](https://bugzilla.redhat.com/1415615) <b>conditional flag for pool id is required  in cockpit-ovirt gdeploy plugin.</b><br>
 - [BZ 1422935](https://bugzilla.redhat.com/1422935) <b>Packages text should be left blank and update host should be left unchecked by default</b><br>
 - [BZ 1424766](https://bugzilla.redhat.com/1424766) <b>Remove nrpe related configuration from gdeploy configuration</b><br>
 - [BZ 1421089](https://bugzilla.redhat.com/1421089) <b>cockpit-ovirt fails to build due to missing webpack</b><br>
 - [BZ 1411315](https://bugzilla.redhat.com/1411315) <b>Oops message displayed with an exclamation mark once user logs into cockpit UI</b><br>
 - [BZ 1416299](https://bugzilla.redhat.com/1416299) <b>remove vdsm configuration from gdeploy config</b><br>
 - [BZ 1416435](https://bugzilla.redhat.com/1416435) <b>Add  units to represent size of disks and add a text near no.of disks for RAID to indicate what disks they are</b><br>
 - [BZ 1416428](https://bugzilla.redhat.com/1416428) <b>Remove distribute and distribute-replicate  from volume types combo box or replace the combo box with a label called 'Replicate'</b><br>

#### oVirt Engine Extension AAA LDAP

 - [BZ 1420281](https://bugzilla.redhat.com/1420281) <b>Ignore groups which can't be resolved from non-working domain inside Active Directory multi-domain forrest</b><br>
 - [BZ 1420745](https://bugzilla.redhat.com/1420745) <b>[aaa-ldap-setup] No validation on profile names when using config file</b><br>
 - [BZ 1408678](https://bugzilla.redhat.com/1408678) <b>[aaa-ldap-setup] Duplicate profile names definitions on availableProfiles</b><br>

#### imgbased

 - [BZ 1421699](https://bugzilla.redhat.com/1421699) <b>imgbase base --of-layer fails with exception when base is provided.</b><br>
 - [BZ 1415026](https://bugzilla.redhat.com/1415026) <b>Both imgbase status and node status are shown on the screen after upgrade</b><br>
 - [BZ 1417100](https://bugzilla.redhat.com/1417100) <b>imgbased make distcheck fails</b><br>
 - [BZ 1427468](https://bugzilla.redhat.com/1427468) <b>Upgrade from wrapper to wrapper failed (ConfigMigrationError)</b><br>
 - [BZ 1426151](https://bugzilla.redhat.com/1426151) <b>Sshd.service could not work normally after upgrade</b><br>
 - [BZ 1426172](https://bugzilla.redhat.com/1426172) <b>RHVH new build boot entry miss when upgrade from wrapper to wrapper</b><br>

#### oVirt Host Deploy

 - [BZ 1414265](https://bugzilla.redhat.com/1414265) <b>config.py:_validation has two decorations</b><br>

#### oVirt Engine SDK 4 Java

 - [BZ 1434334](https://bugzilla.redhat.com/1434334) <b>[Java-SDK] VmsService.list doesn't provide collection of VMs</b><br>
 - [BZ 1432423](https://bugzilla.redhat.com/1432423) <b>Remove Update API for DiskService</b><br>

#### oVirt Engine Dashboard

 - [BZ 1421095](https://bugzilla.redhat.com/1421095) <b>[fr_FR] [Admin Portal] Need to change a string on Dashboard tab (corrected in zanata)</b><br>
 - [BZ 1365929](https://bugzilla.redhat.com/1365929) <b>tooltips in dashboard Utilization boxes move on page scroll</b><br>
 - [BZ 1369550](https://bugzilla.redhat.com/1369550) <b>ovirt-engine dashboard - set status cards to same height when lines wrap</b><br>
 - [BZ 1362402](https://bugzilla.redhat.com/1362402) <b>dashboard: make the date format of time-series graph in locale specific formats in the UTC time zone</b><br>
 - [BZ 1420400](https://bugzilla.redhat.com/1420400) <b>Dashboard time zone should display current timezone instead of GMT</b><br>
 - [BZ 1392984](https://bugzilla.redhat.com/1392984) <b>Status card content should not wrap</b><br>
 - [BZ 1415241](https://bugzilla.redhat.com/1415241) <b>oVirt 4.1 translation cycle 1</b><br>

#### oVirt Engine SDK 4 Python

 - [BZ 1425731](https://bugzilla.redhat.com/1425731) <b>APIv4: StorageDomainVmService.register should have reassign_bad_macs, not import_</b><br>
 - [BZ 1432416](https://bugzilla.redhat.com/1432416) <b>Remove Update API for DiskService</b><br>
 - [BZ 1422979](https://bugzilla.redhat.com/1422979) <b>tarball packaging issues -> pypi different data</b><br>

#### oVirt Engine SDK 4 Ruby

 - [BZ 1428642](https://bugzilla.redhat.com/1428642) <b>version 4.1.3 - uninitialized constant OvirtSDK4::MigrationOptionsReader::AutoConverge</b><br>

#### OTOPI

 - [BZ 1404253](https://bugzilla.redhat.com/1404253) <b>Get rid of dnf module import error in the logs</b><br>

## Bug fixes

### oVirt Engine

 - [BZ 1430009](https://bugzilla.redhat.com/1430009) <b>VM based on a template fails to start with changed Video.</b><br>
 - [BZ 1430795](https://bugzilla.redhat.com/1430795) <b>Automatically increase max memory if necessary in REST</b><br>
 - [BZ 1417582](https://bugzilla.redhat.com/1417582) <b>Provide a warning dialog for add brick operation for the volume which backs gluster data domain</b><br>
 - [BZ 1424813](https://bugzilla.redhat.com/1424813) <b>[UI] - Can't make any changes in custom mode field after pressed on 'OK' button one time</b><br>
 - [BZ 1416459](https://bugzilla.redhat.com/1416459) <b>Restore HE backup will fail if the HE SD has disks of non-HE VM's</b><br>
 - [BZ 1382807](https://bugzilla.redhat.com/1382807) <b>[UX] NUMA pinning dialog should prevent unsupported layout</b><br>
 - [BZ 1419924](https://bugzilla.redhat.com/1419924) <b>cluster level 4.1 adds Random Generator to all VMs while it may not be presented by cluster</b><br>
 - [BZ 1421713](https://bugzilla.redhat.com/1421713) <b>VM pinned to host is started on another host</b><br>
 - [BZ 1406243](https://bugzilla.redhat.com/1406243) <b>Out of range CPU APIC ID</b><br>
 - [BZ 1388963](https://bugzilla.redhat.com/1388963) <b>Unable to change vm Pool Configuration. Receive "Uncaught exception occurred. Please try reloading the page".</b><br>
 - [BZ 1416893](https://bugzilla.redhat.com/1416893) <b>Unable to undeploy hosted-engine host via UI.</b><br>
 - [BZ 1361223](https://bugzilla.redhat.com/1361223) <b>[AAA] Missing principal name option for keytab usage on kerberos</b><br>
 - [BZ 1364132](https://bugzilla.redhat.com/1364132) <b>Once the engine imports the hosted-engine VM we loose the console device</b><br>
 - [BZ 1425108](https://bugzilla.redhat.com/1425108) <b>Hosted engine vm devices are not imported until engine restart</b><br>
 - [BZ 1317490](https://bugzilla.redhat.com/1317490) <b>[engine-backend] Disks are alphabetically ordered instead of numerically, which causes the guest to see them this way (1,10,2..) instead of (1,2,10)</b><br>
 - [BZ 1401963](https://bugzilla.redhat.com/1401963) <b>installed webadmin-portal-debuginfo is not updated by engine-setup and brokes the engine</b><br>
 - [BZ 1416748](https://bugzilla.redhat.com/1416748) <b>punch iptables holes on OVN hosts during installation</b><br>
 - [BZ 1276670](https://bugzilla.redhat.com/1276670) <b>[engine-clean] engine-cleanup doesn't stop ovirt-vmconsole-proxy-sshd</b><br>
 - [BZ 1329893](https://bugzilla.redhat.com/1329893) <b>UI: explain why we cannot change the logical network settings in the "Manage Networks" window</b><br>
 - [BZ 1416846](https://bugzilla.redhat.com/1416846) <b>OVF of the hosted engine vm is not updated when there is a change in vm devices</b><br>
 - [BZ 1429437](https://bugzilla.redhat.com/1429437) <b>REST API - qcow version does not update via path: / ovirt-engine/api/vms/<VM-ID>/diskattachments/<disk-attachment-id>/</b><br>
 - [BZ 1416466](https://bugzilla.redhat.com/1416466) <b>Restore HE backup will fail if the HE host has running non-HE VM's</b><br>
 - [BZ 1422374](https://bugzilla.redhat.com/1422374) <b>The 'VirtIO-SCSI Enabled' isn't enabled by default for new templates</b><br>
 - [BZ 1417935](https://bugzilla.redhat.com/1417935) <b>VM to host affinity :  conflict detection mechanism</b><br>
 - [BZ 1411844](https://bugzilla.redhat.com/1411844) <b>Imported VMs have maxMemory too large</b><br>
 - [BZ 1273825](https://bugzilla.redhat.com/1273825) <b>Template sorting by version is broken</b><br>
 - [BZ 1394687](https://bugzilla.redhat.com/1394687) <b>DC gets non-responding when detaching inactive ISO domain</b><br>
 - [BZ 1323663](https://bugzilla.redhat.com/1323663) <b>the path of storage domain is not trimmed/missing warning about invalid path</b><br>
 - [BZ 1417458](https://bugzilla.redhat.com/1417458) <b>Cold Merge: Use volume generation</b><br>

### VDSM

 - [BZ 1341106](https://bugzilla.redhat.com/1341106) <b>HA vms do not start after successful power-management.</b><br>
 - [BZ 1302020](https://bugzilla.redhat.com/1302020) <b>[Host QoS] - Set maximum link share('ls') value for all classes on the default class</b><br>
 - [BZ 1425233](https://bugzilla.redhat.com/1425233) <b>Ensure that the HE 3.5 -> 3.6 upgrade procedure is still working if executed on 4.1 host with jsonrpc</b><br>
 - [BZ 1223538](https://bugzilla.redhat.com/1223538) <b>VDSM reports "lvm vgs failed" warning when DC contains ISO domain</b><br>
 - [BZ 1403846](https://bugzilla.redhat.com/1403846) <b>keep 3.6 in the supportedEngines reported by VDSM</b><br>
 - [BZ 1302358](https://bugzilla.redhat.com/1302358) <b>File Storage domain export path does not support [IPv6]:/path input</b><br>

### oVirt Hosted Engine Setup

 - [BZ 1401359](https://bugzilla.redhat.com/1401359) <b>[Hosted-Engine] 3.5 HE SD upgrade fails if done on initial host</b><br>
 - [BZ 1288979](https://bugzilla.redhat.com/1288979) <b>[HC] glusterd port was not opened, when automatically configuring firewall in hosted-engine setup</b><br>
 - [BZ 1400800](https://bugzilla.redhat.com/1400800) <b>During upgrade to HE 4.0, check that HE storage domain is at 3.6 level</b><br>
 - [BZ 1417583](https://bugzilla.redhat.com/1417583) <b>hosted-engine --get-shared-config should report a nice error not traceback when nonexistent key is used</b><br>

### oVirt Hosted Engine HA

 - [BZ 1425233](https://bugzilla.redhat.com/1425233) <b>Ensure that the HE 3.5 -> 3.6 upgrade procedure is still working if executed on 4.1 host with jsonrpc</b><br>

### oVirt Release Package

 - [BZ 1429288](https://bugzilla.redhat.com/1429288) <b>RHVH 4.0.7 cannot be up again in the side of RHEVM 4.0 after upgrade</b><br>

### oVirt Cockpit Plugin

 - [BZ 1415651](https://bugzilla.redhat.com/1415651) <b>provide an easy way for the user to redeploy in case deployment fails</b><br>
 - [BZ 1415195](https://bugzilla.redhat.com/1415195) <b>change 'yum update' label to 'Update Host' and remove gpgcheck checkbox</b><br>
 - [BZ 1415665](https://bugzilla.redhat.com/1415665) <b>Gdeploy setup window closes if focus outside modal dialog</b><br>
 - [BZ 1415989](https://bugzilla.redhat.com/1415989) <b>engine volume brick should be created with thick LV</b><br>
 - [BZ 1415189](https://bugzilla.redhat.com/1415189) <b>Give a valid message to the user when gdeploy is not installed in the system.</b><br>
 - [BZ 1428694](https://bugzilla.redhat.com/1428694) <b>Create arbiter brick with recommended sufficient disk space</b><br>
 - [BZ 1426494](https://bugzilla.redhat.com/1426494) <b>Remove 'poolmetadatasize' from gdeploy config file, so that gdeploy can manipulate the same</b><br>
 - [BZ 1427103](https://bugzilla.redhat.com/1427103) <b>Registering to CDN credentials are missing with cockpit UI</b><br>

### oVirt Engine Extension AAA LDAP

 - [BZ 1409827](https://bugzilla.redhat.com/1409827) <b>[RFE] Add documentation how to remove LDAP provider configuration</b><br>

### imgbased

 - [BZ 1417534](https://bugzilla.redhat.com/1417534) <b>unmodified configuration files should be updated during update.</b><br>
 - [BZ 1366549](https://bugzilla.redhat.com/1366549) <b>imgbase rollback does not result in a rollback (no default boot entry change)</b><br>
 - [BZ 1333742](https://bugzilla.redhat.com/1333742) <b>imgbased --version info is not consistent with imgbased rpm version</b><br>
 - [BZ 1429288](https://bugzilla.redhat.com/1429288) <b>RHVH 4.0.7 cannot be up again in the side of RHEVM 4.0 after upgrade</b><br>
 - [BZ 1419535](https://bugzilla.redhat.com/1419535) <b>Garbage collection of layers doesn't work</b><br>

### oVirt Host Deploy

 - [BZ 1412906](https://bugzilla.redhat.com/1412906) <b>ovirt-engine can't install legacy RHV-H in 3.6 Compatibility Mode</b><br>
 - [BZ 1381219](https://bugzilla.redhat.com/1381219) <b>Remove udev rule for deadline elevator (from host deploy) - not needed in EL7 hosts.</b><br>

### oVirt Provider OVN

 - [BZ 1416748](https://bugzilla.redhat.com/1416748) <b>punch iptables holes on OVN hosts during installation</b><br>

### oVirt Engine DWH

 - [BZ 1371111](https://bugzilla.redhat.com/1371111) <b>update dwh heartbeat error message to alert only after it did not update for a minute</b><br>
