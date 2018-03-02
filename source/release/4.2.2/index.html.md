---
title: oVirt 4.2.2 Release Notes
category: documentation
layout: toc
---

# oVirt 4.2.2 Release Notes

The oVirt Project is pleased to announce the availability of the 4.2.2
Third Release Candidate as of March 02, 2018.

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

To learn about features introduced before 4.2.2, see the [release notes for previous versions](/documentation/#previous-release-notes).


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

## What's New in 4.2.2?

### Enhancements

#### oVirt Log Collector

 - [BZ 1540219](https://bugzilla.redhat.com/1540219) <b>detect last backup in analyzer report</b><br>

#### oVirt Hosted Engine Setup

 - [BZ 1542604](https://bugzilla.redhat.com/1542604) <b>[RFE] HE setup: Ansible Flow: Show only active network interfaces for setting ovirtmgmt bridge</b><br>Ansible Flow: Show only active network interfaces for setting ovirtmgmt bridge

#### oVirt Engine

 - [BZ 1528371](https://bugzilla.redhat.com/1528371) <b>engine-setup fails to upgrade postgres from 9.2 to 9.5 if the system wide locale differs from system wide locale at first installation time</b><br>engine-setup can now successfully upgrade PostgreSQL from 9.2 to 9.5 also when the locale of the 9.2 database is different from the system locale.
 - [BZ 1150245](https://bugzilla.redhat.com/1150245) <b>[RFE] Add facility to move a memory volume</b><br>Moving memory disks (disks that are part from a live snapshot with memory or hibernation) can now be moved to other storage domains within the same data center
 - [BZ 1542118](https://bugzilla.redhat.com/1542118) <b>[downstream clone - 4.2.2] [RFE] Add facility to move a memory volume</b><br>
 - [BZ 1540289](https://bugzilla.redhat.com/1540289) <b>Very slow login to and very slow execution in the RHV Manager</b><br>We are now exposing ENGINE_JBOSS_BLOCKING_TIMEOUT option, which can be used to change default value of jboss.as.management.blocking.timeout JBoss option.<br><br>To change the default administrators need to create /etc/ovirt-engine/engine.conf.d/99-jboss-blocking-timeout.conf with following content:<br><br> ENGINE_JBOSS_BLOCKING_TIMEOUT=NNN<br><br>where NNN is the number of seconds for this JBoss timeout.
 - [BZ 1379309](https://bugzilla.redhat.com/1379309) <b>[RFE] Integrate with gluster eventing</b><br>Feature: Integrate oVirt with gluster events framework<br><br>Reason: Push based monitoring rathen than frequent polling from engine to determine status of gluster volume entities
 - [BZ 1546668](https://bugzilla.redhat.com/1546668) <b>[UI] Option to disable auto-sync per provider</b><br>Feature: Option to enable and disable auto-sync per provider<br><br>Reason: Was requested by users.<br><br>Result: The property 'autoSync' of a network provider can be set on creating a new provider and read and set during editing an existing provider.
 - [BZ 1539363](https://bugzilla.redhat.com/1539363) <b>[RFE] Add a mechanism for canceling an image download automatically when there's no activity after a configurable timeout is reached</b><br>A new configuration value was introduced, TransferImageClientInactivityTimeoutInSeconds (default = 60 seconds).<br>When there's no activity with an image transfer, the engine keeps monitoring the transfer for a period of time that equals to this configuration value, and then it stops the transfer.<br>In upload flows - the transfer is paused as it can be resumed. In download flows - the transfer is canceled as it cannot be resumed anyway.<br><br>Note that this configuration value is relevant for both transfer types (upload and download) and both clients (REST-API and webadmin).<br>Also, note that the old configuration value, UploadImageUiInactivityTimeoutInSeconds, was removed, as the new configuration value includes this specific case (upload via webadmin).
 - [BZ 1520424](https://bugzilla.redhat.com/1520424) <b>[RFE] Fence hosts which became NonResponsive right after engine startup</b><br>After starting up, the Manager will automatically attempt to fence unresponsive hosts that have power management enabled after the configurable quiet time (5 minutes by default) has elapsed. Previously the user needed to fence them manually.

#### VDSM

 - [BZ 1150245](https://bugzilla.redhat.com/1150245) <b>[RFE] Add facility to move a memory volume</b><br>Moving memory disks (disks that are part from a live snapshot with memory or hibernation) can now be moved to other storage domains within the same data center
 - [BZ 1207992](https://bugzilla.redhat.com/1207992) <b>[RFE] Report IO errors to guests if the device is a CDROM</b><br>Virtual machines now stay operational when connectivity with CD-ROM images breaks. The error is reported to the guest operating system. Note that the configuration of the storage device may affect the time it takes to detect the error. In that period of time, the virtual machine is non-operational.

#### oVirt Engine Metrics

 - [BZ 1545559](https://bugzilla.redhat.com/1545559) <b>[RFE] Assign externalIP  to the Elasticsearch Service</b><br>Feature: <br>Assign externalIP to the Elasticsearch Service.<br><br>Reason: <br>To automate this for the user so he will not need to do this manually.<br><br>Result: <br>Now this is configure during the ovirt metrics configuration script.
 - [BZ 1520126](https://bugzilla.redhat.com/1520126) <b>[RFE] Set curator configmap on metrics store machine</b><br>Feature: <br>Set curator configmap on metrics store machine<br><br>Reason: <br>To automate this for the user so he will not need to do this manually.<br><br>Result: <br>When running the configure metrics script, it configures the curator on the metrics store machine, for metrics index, the curation parameter and make it configurable.
 - [BZ 1542973](https://bugzilla.redhat.com/1542973) <b>[RFE] Add Viaq installation files to ovirt-engine-metrics repo</b><br>Feature: <br>Added a playbook that generates the vars.yaml file with the openshift_logging_mux_namespaces according to the ovirt_env_name the user configured and copies both vars.yaml and the relevant ansible-inventory to the metrics machine.<br><br>Reason:<br>This places the files required for the viaq logging installation on the metrics machine and already includes the openshift_logging_mux_namespaces. <br><br>Result: <br>This should simplify the oVirt metrics store installation.<br><br>Additional parameters that user needs to update in the config.yml:<br>viaq_metrics_store: (required - Default: true)<br><br>Use ViaQ Logging metrics store<br><br>openshift_deployment_type: (required - no default value)<br><br>Reguired if viaq_metrics_store is true. This repository supports OpenShift Origin and OpenShift Container Platform. If you want to install ViaQ Logging you should choose the deployment type. Available options: origin, openshift-enterprise.
 - [BZ 1530919](https://bugzilla.redhat.com/1530919) <b>[RFE]Include a vars directory instead of only single config.yml file and not hard code the path</b><br>Feature: <br>Include a vars directory instead of only single config.yml file and not hard code the path.<br><br>Reason: <br>Allow adding variable to a directory to be used in the for the ansible script.<br><br>Result: <br>User can now add variable file to /etc/config.yml.d/ and the will be used in the ansible playbook.

### Bug Fixes

#### oVirt Log Collector

 - [BZ 1519541](https://bugzilla.redhat.com/1519541) <b>log-collector-analyzer: ERROR:  column v.agent_ip does not exist</b><br>

#### ovirt-engine-dwh

 - [BZ 1529489](https://bugzilla.redhat.com/1529489) <b>engine-cleanup fails if history database is inaccessible</b><br>
 - [BZ 1541924](https://bugzilla.redhat.com/1541924) <b>Ovirt-engine-dwh fails to collect statistics due to high number in database sequences.</b><br>

#### oVirt Engine

 - [BZ 1547936](https://bugzilla.redhat.com/1547936) <b>Fill the gaps with new OVF parsing</b><br>
 - [BZ 1532674](https://bugzilla.redhat.com/1532674) <b>Engine should update neutron that binding host has been changed after VM migration with neutron network</b><br>
 - [BZ 1492138](https://bugzilla.redhat.com/1492138) <b>Rollback after failed upgrade from 4.1 to 4.2 does not reconfigure original postgresql service</b><br>
 - [BZ 1537343](https://bugzilla.redhat.com/1537343) <b>engine tries to balance vms that are down.</b><br>
 - [BZ 1430876](https://bugzilla.redhat.com/1430876) <b>[RFE] Increase supported per-manager host limit</b><br>
 - [BZ 1539717](https://bugzilla.redhat.com/1539717) <b>High Performance VM could not be started in PPC env - Can't add USB input device</b><br>
 - [BZ 1545193](https://bugzilla.redhat.com/1545193) <b>Snapshot remains in locked status if one of the disk was inactive while doing live merge</b><br>
 - [BZ 1517540](https://bugzilla.redhat.com/1517540) <b>Uncleaned leftovers after live storage migration failure during VmReplicateDiskFinish</b><br>
 - [BZ 1535256](https://bugzilla.redhat.com/1535256) <b>MaxBlockDiskSize is honoured only on AddDiskCommand and not on Extend</b><br>

#### VDSM

 - [BZ 1543103](https://bugzilla.redhat.com/1543103) <b>Call vdsm 'after_vm_pause' hooks when the VM has been paused because an I/O Error</b><br>
 - [BZ 1335176](https://bugzilla.redhat.com/1335176) <b>VMs do not auto-resume after short storage outage</b><br>

#### oVirt Engine Metrics

 - [BZ 1529271](https://bugzilla.redhat.com/1529271) <b>[RFE] report VM statistics by collectd virt-plugin</b><br>
 - [BZ 1540261](https://bugzilla.redhat.com/1540261) <b>metrics host deployment playbooks logs private key</b><br>

#### oVirt Host Dependencies

 - [BZ 1529271](https://bugzilla.redhat.com/1529271) <b>[RFE] report VM statistics by collectd virt-plugin</b><br>

#### oVirt Provider OVN

 - [BZ 1531998](https://bugzilla.redhat.com/1531998) <b>routing: port's fixed_ips, device_owner and device_id should report valid values</b><br>
 - [BZ 1530531](https://bugzilla.redhat.com/1530531) <b>When removing router interface the provider doesn't remove the attachment to the subnet</b><br>

### Other

#### oVirt ISO Uploader

 - [BZ 1513481](https://bugzilla.redhat.com/1513481) <b>uploading iso to glusterfs via ssh fails</b><br>

#### oVirt Log Collector

 - [BZ 1491302](https://bugzilla.redhat.com/1491302) <b>Missing manual for ovirt-log-collector-analyzer</b><br>
 - [BZ 1518950](https://bugzilla.redhat.com/1518950) <b>ovirt-log-collector-analyzer: sosreport-foobar-Logcollector-9175126/dev/null: Cannot mknod: Operation not permitted\ntar: Exiting with failure status due to previous errors</b><br>
 - [BZ 1493099](https://bugzilla.redhat.com/1493099) <b>[RFE] - Add iSCSI initiator name to hosts table for analyzer report</b><br>
 - [BZ 1491253](https://bugzilla.redhat.com/1491253) <b>[RFE] - /usr/share/ovirt-log-collector/analyzer/inventory-profile has hardcoded /tmp</b><br>
 - [BZ 1478139](https://bugzilla.redhat.com/1478139) <b>Command "ovirt-log-collector --quiet" is verbose</b><br>
 - [BZ 1532927](https://bugzilla.redhat.com/1532927) <b>[RFE] Add host SELinux check to analyzer</b><br>
 - [BZ 1529341](https://bugzilla.redhat.com/1529341) <b>ovirt-log-collector-analyzer: warn if the number of hosts is > 200 (in 4.1 and below)</b><br>

#### oVirt Ansible cluster upgrade role

 - [BZ 1539776](https://bugzilla.redhat.com/1539776) <b>Role should fail after one failed host</b><br>
 - [BZ 1539761](https://bugzilla.redhat.com/1539761) <b>[RFE] changing cluster into maintenance only with special parameter</b><br>
 - [BZ 1539774](https://bugzilla.redhat.com/1539774) <b>[RFE] Add variable about not rebooting the host after upgrade</b><br>

#### oVirt Ansible infrastructure role

 - [BZ 1539715](https://bugzilla.redhat.com/1539715) <b>Make hosts variable optional (for example to be able to add additional storage domains to existing setup)</b><br>

#### oVirt Ansible virtual machine infrastructure role

 - [BZ 1539722](https://bugzilla.redhat.com/1539722) <b>[RFE] variable status should be within specific VM too and it should take precedence before status in profile</b><br>
 - [BZ 1491010](https://bugzilla.redhat.com/1491010) <b>[ovirt-ansible-roles] ovirt-vm-infra: When VM already exists in environment, role should left that VM in the same running state</b><br>

#### oVirt Engine SDK 4 Ruby

 - [BZ 1542879](https://bugzilla.redhat.com/1542879) <b>rubygem(json) < 2 is not available on Fedora >= 27</b><br>

#### ovirt-engine-dwh

 - [BZ 1547018](https://bugzilla.redhat.com/1547018) <b>engine-setup clears dwh database on rollback if failure is at/after schema update</b><br>
 - [BZ 1546487](https://bugzilla.redhat.com/1546487) <b>Rollback after failed upgrade from 4.1 to 4.2 does not reconfigure original postgresql service</b><br>
 - [BZ 1540627](https://bugzilla.redhat.com/1540627) <b>logs are world-readable</b><br>
 - [BZ 1546969](https://bugzilla.redhat.com/1546969) <b>cannot install dwh on separate machine - problem with OVESETUP_PROVISIONING/postgresProvisioningEnabled</b><br>

#### oVirt Hosted Engine HA

 - [BZ 1525859](https://bugzilla.redhat.com/1525859) <b>Clean metadata command raises Traceback</b><br>
 - [BZ 1543424](https://bugzilla.redhat.com/1543424) <b>[vintage][iscsi][multipath] With answerfile (or from cockpit) the setup fails if just one of the paths to the storage server is down</b><br>
 - [BZ 1443819](https://bugzilla.redhat.com/1443819) <b>Stale Active LVs in Hosted-Engine Storage Domain</b><br>

#### oVirt Hosted Engine Setup

 - [BZ 1543486](https://bugzilla.redhat.com/1543486) <b>[ansible based] Default cluster in HC installation does not have gluster service enabled</b><br>
 - [BZ 1548508](https://bugzilla.redhat.com/1548508) <b>ansible based setup fails if 'hosted-engine --status --json' produces an incomplete response during ovirt-ha-agent start</b><br>
 - [BZ 1533500](https://bugzilla.redhat.com/1533500) <b>Node Zero flow incorrectly handling of unicode chars in error messages.</b><br>
 - [BZ 1522737](https://bugzilla.redhat.com/1522737) <b>Warn admin during hosted engine deploy not to use all the space from hosted SD and leave something for OVFs</b><br>
 - [BZ 1546652](https://bugzilla.redhat.com/1546652) <b>HE setup: Ansible: detect the interface used on an existing management bridge and propose just that one</b><br>
 - [BZ 1541412](https://bugzilla.redhat.com/1541412) <b>Ansible deployment should clean up files in /var once finished</b><br>
 - [BZ 1540463](https://bugzilla.redhat.com/1540463) <b>New IPv4 validator handles interfaces with no gateway incorrectly</b><br>
 - [BZ 1543218](https://bugzilla.redhat.com/1543218) <b>Engine allows importing HE specific volumes and then deleting them.</b><br>
 - [BZ 1540107](https://bugzilla.redhat.com/1540107) <b>The engine fails to delete a existing external VM (via REST APIs) with 'Operation Failed: [Desktop does not exist]'</b><br>
 - [BZ 1545931](https://bugzilla.redhat.com/1545931) <b>hosted-engine deploy fails  when ovirtmgmt is defined on vlan subinterface (ansible version)</b><br>
 - [BZ 1543424](https://bugzilla.redhat.com/1543424) <b>[vintage][iscsi][multipath] With answerfile (or from cockpit) the setup fails if just one of the paths to the storage server is down</b><br>
 - [BZ 1443819](https://bugzilla.redhat.com/1443819) <b>Stale Active LVs in Hosted-Engine Storage Domain</b><br>
 - [BZ 1541328](https://bugzilla.redhat.com/1541328) <b>[ansible] deployment fails on Opteron CPUs due to bad cpu type in vm.conf at the end</b><br>

#### oVirt Engine Extension AAA-JDBC

 - [BZ 1540909](https://bugzilla.redhat.com/1540909) <b>Use native SecureRandom implementation instead of SHA1PRNG</b><br>

#### ovirt-engine-extension-aaa-ldap

 - [BZ 1538217](https://bugzilla.redhat.com/1538217) <b>AAA - setup script errors out solely on the exit status of dig command.</b><br>
 - [BZ 1524120](https://bugzilla.redhat.com/1524120) <b>Fix language in ovirt-engine-extension-aaa-ldap/examples/README.md</b><br>
 - [BZ 1530642](https://bugzilla.redhat.com/1530642) <b>Sample file simple/aaa/profile1.properties misses line pool.default.auth.type = simple</b><br>

#### oVirt Engine

 - [BZ 1545229](https://bugzilla.redhat.com/1545229) <b>Starting a VM with Direct LUN fail with libvirtError</b><br>
 - [BZ 1549098](https://bugzilla.redhat.com/1549098) <b>Disks from main tab are selected by name and not by ID</b><br>
 - [BZ 1534607](https://bugzilla.redhat.com/1534607) <b>Unable to use paging when searching for VMs available for specific user sorted by name</b><br>
 - [BZ 1546747](https://bugzilla.redhat.com/1546747) <b>Fix ImportVmFromConfiguration for upload OVA</b><br>
 - [BZ 1515933](https://bugzilla.redhat.com/1515933) <b>The engine fails to start VM with 1Gb hugepages and NUMA pinning</b><br>
 - [BZ 1535329](https://bugzilla.redhat.com/1535329) <b>engine-setup fails due to: ERROR:  check constraint "vm_static_max_memory_size_lower_bound" is violated by some row</b><br>
 - [BZ 1544721](https://bugzilla.redhat.com/1544721) <b>Generalize the correlation logic within VM devices monitoring</b><br>
 - [BZ 1529460](https://bugzilla.redhat.com/1529460) <b>Failed to run a VM after adding new non-bootable disk with custom alias</b><br>
 - [BZ 1540539](https://bugzilla.redhat.com/1540539) <b>ImageIO - Cancel download disk cause VDSM exception Cannot deactivate Logical Volume as lv is in use</b><br>
 - [BZ 1547016](https://bugzilla.redhat.com/1547016) <b>engine-setup clears engine database on rollback if failure is at/after schema update</b><br>
 - [BZ 1509588](https://bugzilla.redhat.com/1509588) <b>[RFE][UI] - Allow import of VMs from storage domain with partial disks (UI only, API already exists).</b><br>until now, partial import of a VM done via REST-API only.<br>After this fix, there will be an option to partial import a VM from data domain by selecting the 'allow partial' checkbox in the VM import window.
 - [BZ 1546907](https://bugzilla.redhat.com/1546907) <b>External LUN disks mapping for register VM should be mapped using logical unit id instead of disk id</b><br>
 - [BZ 1544056](https://bugzilla.redhat.com/1544056) <b>[PPC] Failed to start VM with snapshot with "MissingDevice()MissingDevice: Base class for vdsm errors"</b><br>
 - [BZ 1540624](https://bugzilla.redhat.com/1540624) <b>Cannot get administration portal after logging to IPA domain, WFLYEJB0442: Unexpected Error</b><br>
 - [BZ 1540605](https://bugzilla.redhat.com/1540605) <b>OVA logs are not logged because /var/log/ovirt-engine/ova/ folder is not created during engine-setup.</b><br>
 - [BZ 1539356](https://bugzilla.redhat.com/1539356) <b>Can not add new VNIC to hosted-engine VM</b><br>
 - [BZ 1538840](https://bugzilla.redhat.com/1538840) <b>Disk move between storage domain's result's in source image being removed.</b><br>
 - [BZ 1542034](https://bugzilla.redhat.com/1542034) <b>"Failed to determine the metadata devices of Storage Domain" error is shown for every storage domains in 4.1 environment with 4.0 hosts</b><br>
 - [BZ 1537534](https://bugzilla.redhat.com/1537534) <b>UpdateVmCommand fails with NullPointerException after failed Hot-plug of a VM lease due to VM power off</b><br>
 - [BZ 1535574](https://bugzilla.redhat.com/1535574) <b>Webadmin importing VM event is stuck in importing state although the import failed.</b><br>
 - [BZ 1535006](https://bugzilla.redhat.com/1535006) <b>ovn localnet: attachment of ovn network to Custom data center network is not passed to provider</b><br>
 - [BZ 1511488](https://bugzilla.redhat.com/1511488) <b>vNUMA pinning not automatically pin all vCPUs as required in case of odd number of vCPUs</b><br>
 - [BZ 1542348](https://bugzilla.redhat.com/1542348) <b>[ALL_LANG except zh, kr] The UI alignment needs to be adjusted on tags page.</b><br>
 - [BZ 1541902](https://bugzilla.redhat.com/1541902) <b>[ALL_LANG] The text alignment correction needed on compute -> virtual machines-> new -> resource allocation window.</b><br>
 - [BZ 1549100](https://bugzilla.redhat.com/1549100) <b>Authentication inputs on adding an external provider should be disabled by default</b><br>
 - [BZ 1519320](https://bugzilla.redhat.com/1519320) <b>[UI] login screen renders poorly on mobile, especially using ja-JP, ko-KR, and zh-CN locales</b><br>
 - [BZ 1545074](https://bugzilla.redhat.com/1545074) <b>right click in grid deselects the selected VM</b><br>
 - [BZ 1530961](https://bugzilla.redhat.com/1530961) <b>request to remove a pool selects other one in the list</b><br>
 - [BZ 1542097](https://bugzilla.redhat.com/1542097) <b>[ALL_LANG]  Text "Reboot host after upgrade" is misaligned with checkbox at compute > hosts > installation > Upgrade</b><br>
 - [BZ 1534439](https://bugzilla.redhat.com/1534439) <b>StreamingAPI - 'Transfer was paused by system' event/error is not informative enough</b><br>
 - [BZ 1538170](https://bugzilla.redhat.com/1538170) <b>Network interface of the hosted engine VM is unplugged after fresh deploy</b><br>
 - [BZ 1540166](https://bugzilla.redhat.com/1540166) <b>Unable to remove multiple OVN networks</b><br>
 - [BZ 1544230](https://bugzilla.redhat.com/1544230) <b>StreamingAPI -  Moving host to maintenance while Upload/Download disk via UI/SDK is allowed</b><br>
 - [BZ 1534644](https://bugzilla.redhat.com/1534644) <b>New way of parsing OVF from OVA that was created by VMware fails.</b><br>
 - [BZ 1459865](https://bugzilla.redhat.com/1459865) <b>Created external vm after vm was migrated to a new host and later removed (or the original is paused)</b><br>
 - [BZ 1419964](https://bugzilla.redhat.com/1419964) <b>When there are v6 IPs only, 'IP Address' column shows no IP address at all</b><br>
 - [BZ 1540622](https://bugzilla.redhat.com/1540622) <b>logs are world-readable</b><br>
 - [BZ 1530944](https://bugzilla.redhat.com/1530944) <b>Add host failed with PSQLException if host has the same name server entry written twice in the resolv.conf</b><br>
 - [BZ 1540907](https://bugzilla.redhat.com/1540907) <b>Use native SecureRandom implementation instead of SHA1PRNG</b><br>
 - [BZ 1375678](https://bugzilla.redhat.com/1375678) <b>Template/InstanceType migration mode (placement policy affinity) value has inconsistencies between webadmin/api/DB</b><br>
 - [BZ 1532700](https://bugzilla.redhat.com/1532700) <b>WebAdmin: "Finished Deactivating Storage Domain..." message while deactivation fails</b><br>
 - [BZ 1348143](https://bugzilla.redhat.com/1348143) <b>[de_DE] The UI alignment needs to be corrected on clusters->new->console page.</b><br>
 - [BZ 1512554](https://bugzilla.redhat.com/1512554) <b>template edit button not shown on the details page</b><br>
 - [BZ 1535573](https://bugzilla.redhat.com/1535573) <b>[REST API] External network creation response body returns invalid external provider ID</b><br>
 - [BZ 1549461](https://bugzilla.redhat.com/1549461) <b>ovn localnet: Disable ovn localnet by default</b><br>
 - [BZ 1544326](https://bugzilla.redhat.com/1544326) <b>[OVN] - "Default" cluster always returns to default network provider on engine-setup although was set with No default provider</b><br>
 - [BZ 1541990](https://bugzilla.redhat.com/1541990) <b>[ALL_LANG] Text truncation observed on compute->data centers->logical networks->new->clusters page.</b><br>
 - [BZ 1542900](https://bugzilla.redhat.com/1542900) <b>[fr, zh_CN, ko] UI alignment needs to be corrected on compute -> data centers -> logical networks -> new -> vNIC profiles page.</b><br>
 - [BZ 1542010](https://bugzilla.redhat.com/1542010) <b>[ja_JP] UI distortion observed on Administration -> configure -> MAC address pool -> add page.</b><br>
 - [BZ 1542070](https://bugzilla.redhat.com/1542070) <b>[es_ES] [pt_BR] [Admin Portal] Radio button label 'User Roles' appears misaligned in Spanish google-chrome</b><br>
 - [BZ 1535859](https://bugzilla.redhat.com/1535859) <b>Webadmin- Events & alerts notifications clear all events -> USER_CLEAR_ALL_AUDIT_LOG' is not translated in 'bundles/AuditLogMessages'</b><br>
 - [BZ 1528853](https://bugzilla.redhat.com/1528853) <b>[TEXT] Host becomes non-operational if it has an un-synced network with vm<>non-VM difference</b><br>
 - [BZ 1539778](https://bugzilla.redhat.com/1539778) <b>Under Instance Images: Selected LUN is unmarked while editing an added direct LUN in new VM prompt</b><br>
 - [BZ 1546771](https://bugzilla.redhat.com/1546771) <b>on failure to upgrade postgresql to 9.5, engine-setup unconditionally removes the 9.5 data directory</b><br>
 - [BZ 1537495](https://bugzilla.redhat.com/1537495) <b>dialogs - 'undefined' warning message headline and '&#39;' instead of apostrophe in the description</b><br>
 - [BZ 1535864](https://bugzilla.redhat.com/1535864) <b>Webadmin- Events - notification drawer- clear all alarms clear also all events</b><br>
 - [BZ 1547907](https://bugzilla.redhat.com/1547907) <b>VM with invalid disks fails to be registered with 'allow_partial' flag as true</b><br>
 - [BZ 1547050](https://bugzilla.redhat.com/1547050) <b>NPE while asking for host statistics</b><br>
 - [BZ 1545849](https://bugzilla.redhat.com/1545849) <b>no floppy in RunOnce flow</b><br>
 - [BZ 1543805](https://bugzilla.redhat.com/1543805) <b>Empty backup-volfile-servers option passed for distribute volume</b><br>
 - [BZ 1546824](https://bugzilla.redhat.com/1546824) <b>Enable caching for disks with non-native IO</b><br>
 - [BZ 1548349](https://bugzilla.redhat.com/1548349) <b>Read-Only Attribute of OpenStackNetworkProvider is not reported via REST-API</b><br>
 - [BZ 1548348](https://bugzilla.redhat.com/1548348) <b>Updating OpenStackNetworkProvider uses overwrites additionalProperties with default values</b><br>
 - [BZ 1540114](https://bugzilla.redhat.com/1540114) <b>[UI] - Storage Domain > VMs and Templates sub tabs > No items to display grid is missing</b><br>
 - [BZ 1545596](https://bugzilla.redhat.com/1545596) <b>engine-setup should configure versionlock yum plugin to follow Obsoletes</b><br>
 - [BZ 1547097](https://bugzilla.redhat.com/1547097) <b>vds_dynamic.kernel_features type migration</b><br>
 - [BZ 1532577](https://bugzilla.redhat.com/1532577) <b>[RFE] allow lease selection in custom preview of a snapshot</b><br>Until this fix, there was no way to select specific lease to use while previewing a snapshot.<br>After this fix, the user can select whether he wants to preview the snapshot with a lease and to specify the specific lease.<br>The user can perform the custom preview of a snapshot and select the specific lease via REST-API or via the UI.
 - [BZ 1537735](https://bugzilla.redhat.com/1537735) <b>Unable to use paging when searching for VM pools available for specific user sorted by name</b><br>
 - [BZ 1484863](https://bugzilla.redhat.com/1484863) <b>Cannot start HA VM (lease) after snapshot preview / preview+commit</b><br>until this fix, when a snapshot was previewed the VM lease was ignored.<br>Now if the snapshot or the VM contains a lease, it will be ignored.<br><br>1.VM snapshot and the active snapshot has a lease<br>  on the same/different domain:<br>  - while previewing:<br>      use the active snapshot lease<br>  - while undoing the preview:<br>      revert to use the active snapshot lease<br>  - while committing the preview:<br>      use the lease that used in the preview<br><br>2.VM has a lease on the active snapshot but doesn't have a<br>  lease on the snapshot:<br>  - while previewing:<br>      no lease will be used in the preview<br>  - while undoing the preview:<br>      revert to use the active snapshot lease<br>  - while committing the preview:<br>      the active snapshot lease will be removed and the VM <br>      will use the lease that used in the preview<br><br>4.VM doesn't have a lease on the active snapshot but<br>  does has a lease on the snapshot:<br>  - while previewing:<br>      new VM lease will create on the snapshot lease<br>      domain<br>  - while undoing the preview:<br>      the created lease will be removed<br>  - while committing the preview:<br>      the VM will use the lease that used in the preview
 - [BZ 1537474](https://bugzilla.redhat.com/1537474) <b>WebAdmin - Alerts list is in ascending order</b><br>
 - [BZ 1539773](https://bugzilla.redhat.com/1539773) <b>Slow upload image throughput times out and is paused by system without informational message</b><br>
 - [BZ 1542531](https://bugzilla.redhat.com/1542531) <b>Allow ServerCPUList and ClusterEmulatedMachines options to be visible over RESTAPI</b><br>
 - [BZ 1532884](https://bugzilla.redhat.com/1532884) <b>NullPointerException after failure to refresh VDS</b><br>
 - [BZ 1534913](https://bugzilla.redhat.com/1534913) <b>Missing uuid-ossp extension on remote db causes engine-setup to die in the middle</b><br>
 - [BZ 1525596](https://bugzilla.redhat.com/1525596) <b>[REST] entrypoint for events returns Blank template element without href nor id</b><br>
 - [BZ 1532802](https://bugzilla.redhat.com/1532802) <b>Webadmin: Listings of VMs, that depend on a template, are multiplied by the number of the template disk copies</b><br>
 - [BZ 1406766](https://bugzilla.redhat.com/1406766) <b>ovirt-engine dependencies module fetch java artifacts which jboss wildfly already provides</b><br>
 - [BZ 1540101](https://bugzilla.redhat.com/1540101) <b>Add vintage rhevh7.3 to compatibility 3.6 datacenter on rhvm4.2 failed</b><br>
 - [BZ 1540814](https://bugzilla.redhat.com/1540814) <b>upgrade dbscript fails if multiplication overflows</b><br>
 - [BZ 1541769](https://bugzilla.redhat.com/1541769) <b>Live storage migration, with the target domain configured to be backup, is allowed</b><br>
 - [BZ 1537176](https://bugzilla.redhat.com/1537176) <b>links in the bottom of Events dialog disappear</b><br>
 - [BZ 1513987](https://bugzilla.redhat.com/1513987) <b>Move disk option missing in the VM disk attachments action menu</b><br>
 - [BZ 1539361](https://bugzilla.redhat.com/1539361) <b>Reinitialize data-center will generate multiple OVF_STORE disks when deactivating single master storage domain</b><br>
 - [BZ 1503269](https://bugzilla.redhat.com/1503269) <b>User without permissions on destination SD can move disk</b><br>
 - [BZ 1540071](https://bugzilla.redhat.com/1540071) <b>An attempt to get the snapshot creation status with JSON request results in 406 response code from server.</b><br>
 - [BZ 1538814](https://bugzilla.redhat.com/1538814) <b>Imageio-Proxy: Failed to verify proxy ticket: Ticket life time expired</b><br>

#### VDSM

 - [BZ 1544721](https://bugzilla.redhat.com/1544721) <b>Generalize the correlation logic within VM devices monitoring</b><br>
 - [BZ 1542117](https://bugzilla.redhat.com/1542117) <b>Disk is down after migration of vm from 4.1 to 4.2</b><br>
 - [BZ 1549145](https://bugzilla.redhat.com/1549145) <b>Network actions fail due to VDSM NM driver async operations</b><br>
 - [BZ 1447300](https://bugzilla.redhat.com/1447300) <b>enable libguestfs tools on ppc64le</b><br>
 - [BZ 1531066](https://bugzilla.redhat.com/1531066) <b>vdsm: use INFO log level for all operation that change system state</b><br>
 - [BZ 1536826](https://bugzilla.redhat.com/1536826) <b>Start VM with uploaded ISO fails with libvirtError: unsupported configuration: native I/O needs either no disk cache or directsync cache mode, QEMU will fallback to aio=threads.</b><br>
 - [BZ 1511608](https://bugzilla.redhat.com/1511608) <b>host crash during vdsm-netupgrade leaves corrupted persisted networks</b><br>
 - [BZ 1545862](https://bugzilla.redhat.com/1545862) <b>org.ovirt.engine.core.bll.AddUnmanagedVmsCommand raises Exception: java.lang.NumberFormatException: null importing a libvirt VM</b><br>
 - [BZ 1546824](https://bugzilla.redhat.com/1546824) <b>Enable caching for disks with non-native IO</b><br>
 - [BZ 1547369](https://bugzilla.redhat.com/1547369) <b>VDSM: Mark VM.getDiskAlignment as deprecated for 4.2</b><br>
 - [BZ 1533155](https://bugzilla.redhat.com/1533155) <b>Failed to create live snapshots after preview and commit of snapshots</b><br>
 - [BZ 1528367](https://bugzilla.redhat.com/1528367) <b>stderr is not logged in the vdsm if the lvremove fails for some reason</b><br>
 - [BZ 1525171](https://bugzilla.redhat.com/1525171) <b>Ensure that only one VDSM instance is running</b><br>
 - [BZ 1469235](https://bugzilla.redhat.com/1469235) <b>[Blocked on platform bug 1532183] Hotplug failed because libvirtError: internal error: unable to execute QEMU command '__com.redhat_drive_add': Device 'drive-virtio-disk7' could not be initialized</b><br>
 - [BZ 1533410](https://bugzilla.redhat.com/1533410) <b>Save full qemu core dump to provide maximum information about the crash (since RHEL 7.4 core dump doesn't contain guest memory dump)</b><br>
 - [BZ 1542423](https://bugzilla.redhat.com/1542423) <b>Distinguish between replication errors</b><br>
 - [BZ 1466461](https://bugzilla.redhat.com/1466461) <b>vdsm-client takes at least X4 more than vdsClient</b><br>
 - [BZ 1410283](https://bugzilla.redhat.com/1410283) <b>gluster cli: Exception when brick resides on  a btrfs subvolume</b><br>
 - [BZ 1533035](https://bugzilla.redhat.com/1533035) <b>[Scale] getDeviceList slowdown when passing big list of guids</b><br>
 - [BZ 1539108](https://bugzilla.redhat.com/1539108) <b>Silence bogus error when trying to check clean LUN status in getDeviceList</b><br>

#### oVirt Engine Dashboard

 - [BZ 1465795](https://bugzilla.redhat.com/1465795) <b>Top utilized Resources (Storage) - VMs should be sorted by actual use, not over-allocation percentage</b><br>
 - [BZ 1523004](https://bugzilla.redhat.com/1523004) <b>[CodeChange][i18n] oVirt 4.2 translation cycle 2</b><br>

#### oVirt Engine Metrics

 - [BZ 1547711](https://bugzilla.redhat.com/1547711) <b>Metrics is being configured even if validations failed</b><br>

#### oVirt Provider OVN

 - [BZ 1536791](https://bugzilla.redhat.com/1536791) <b>Provider should support using fixed_ips with PORT entities</b><br>
 - [BZ 1531112](https://bugzilla.redhat.com/1531112) <b>Remove router interface should remove the port from the switch</b><br>
 - [BZ 1537084](https://bugzilla.redhat.com/1537084) <b>Crash and restart on irrecoverable ovsdbapp error</b><br>

#### cockpit-ovirt

 - [BZ 1540621](https://bugzilla.redhat.com/1540621) <b>Hosted-engine with ansible is marked as failed although all the tasks were successful</b><br>
 - [BZ 1538613](https://bugzilla.redhat.com/1538613) <b>Gdeploy conf file missing firewalld configuration and other setting when lvmcache chose</b><br>
 - [BZ 1540926](https://bugzilla.redhat.com/1540926) <b>cockpit wizard fails to parse the output of the json callback</b><br>
 - [BZ 1548958](https://bugzilla.redhat.com/1548958) <b>Don't start HE deployment on cockpit-ovirt-dashboard-0.11.12</b><br>
 - [BZ 1542426](https://bugzilla.redhat.com/1542426) <b>[cockpit][otopi][iscsi] cockpit over vintage otopi flow should not let the user enter an iSCSI lun uuid</b><br>
 - [BZ 1528818](https://bugzilla.redhat.com/1528818) <b>If libvirtd is down, we allow only AMD CPUs</b><br>
 - [BZ 1541273](https://bugzilla.redhat.com/1541273) <b>Generating answer file with the incorrect cpu while redeploying the HE based otopi deployment</b><br>
 - [BZ 1538927](https://bugzilla.redhat.com/1538927) <b>Inappropriate default vcpus for VM while  deploying HE via cockpit based otopi.</b><br>
 - [BZ 1538947](https://bugzilla.redhat.com/1538947) <b>[RFE] Suggest that the generating he setup answer file by cockpit don't contain HE password as clear text.</b><br>
 - [BZ 1540616](https://bugzilla.redhat.com/1540616) <b>On redeployment attempts on the ansible flow the logs entries got multiplied</b><br>
 - [BZ 1538941](https://bugzilla.redhat.com/1538941) <b>[ansible based] Click "Deploy" button with no effect while deploying HE via cockpit based ansible deployment.</b><br>

#### IOProcess

 - [BZ 1541389](https://bugzilla.redhat.com/1541389) <b>wrong packaging of ioprocess rpm</b><br>

### No Doc Update

#### oVirt Hosted Engine HA

 - [BZ 1545105](https://bugzilla.redhat.com/1545105) <b>OVF parsing fails if the HE VM is in an affinity group</b><br>
 - [BZ 1504606](https://bugzilla.redhat.com/1504606) <b>Use the Domain XML to create the HE VM</b><br>

#### oVirt Hosted Engine Setup

 - [BZ 1546764](https://bugzilla.redhat.com/1546764) <b>Typo in "[ INFO  ] TASK [Set FDQN] ", it should be "[ INFO  ] TASK [Set FQDN]" instead.</b><br>
 - [BZ 1504606](https://bugzilla.redhat.com/1504606) <b>Use the Domain XML to create the HE VM</b><br>
 - [BZ 1540150](https://bugzilla.redhat.com/1540150) <b>Disable IPv6 on network configuration at the engine on the ansible deployment flow</b><br>

#### oVirt Engine

 - [BZ 1341177](https://bugzilla.redhat.com/1341177) <b>[RFE] Log "Cannot migrate VM" and "Cannot run VM" failures to "Events" tab (audit_log)</b><br>
 - [BZ 1354427](https://bugzilla.redhat.com/1354427) <b>[ja_JP] Need to properly align some text on the admin portal login page.</b><br>
 - [BZ 1534544](https://bugzilla.redhat.com/1534544) <b>engine log 404 Error message for lang.css when viewing documentation</b><br>
 - [BZ 1511926](https://bugzilla.redhat.com/1511926) <b>in small window action dropdown menu is not visible when it is on new line</b><br>
 - [BZ 1537594](https://bugzilla.redhat.com/1537594) <b>engine-setup --reconfigure-optional-components not covered by man-page</b><br>
 - [BZ 1518074](https://bugzilla.redhat.com/1518074) <b>Choosing multiple LUNs instead of exactly one when creating a new direct LUN disk for a new VM via Targets > LUNs table</b><br>
 - [BZ 1537603](https://bugzilla.redhat.com/1537603) <b>ovirt-engine-setup-plugin-vmconsole-proxy-helper is not re-asking to be enabled if once set to False</b><br>

