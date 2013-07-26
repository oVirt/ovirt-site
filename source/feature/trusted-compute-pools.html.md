---
title: Trusted compute pools
category: feature
authors: dave chen, gwei3, lhornyak
wiki_category: Feature
wiki_title: Trusted compute pools
wiki_revision_count: 56
wiki_last_updated: 2013-10-11
---

# Trusted Compute Pools

### Summary

Trusted Compute Pools provide a way for Administrator to deploy VMs on trusted hosts.

### Owner

*   Name: [ Gang Wei](User:gwei3)

<!-- -->

*   Email: <gang.wei@intel.com>

### Current status

*   Merged
    -   Engine change: <http://gerrit.ovirt.org/#/c/14605/>
    -   Webadmin change: <http://gerrit.ovirt.org/#/c/14611/>
    -   REST api change: <http://gerrit.ovirt.org/#/c/14692/>
    -   OVF change: <http://gerrit.ovirt.org/#/c/14729/>
*   Last updated date: July 26, 2013

### Detailed Description

The feature will allow data center administrator to build trusted computing pools based on H/W-based security features, such as Intel Trusted Execution Technology (TXT). Combining attestation done by a separate entity (i.e. "remote attestation"), the administrator can ensure that verified measurement of software be running in hosts, thus they can establish the foundation for the secure enterprise stack. Such remote attestation services can be developed by using SDK provided by OpenAttestation project.

Remote Attestation server performs host verification through following steps:

1. Hosts boot with Intel TXT technology enabled

2. The hosts' BIOS, hypervisor and OS are measured

3. These measured data is sent to Attestation server when challenged by attestation server

4. Attestation server verifies those measurements against good/known database to determine hosts' trustworthiness

![](figure7.jpg "fig:figure7.jpg") ![](figure10.jpg "fig:figure10.jpg")

By far, we got following implementation approach for TCP feature:

*   Approach: trust property in cluster level policy. The biggest benefits are VM migration can work without specific changes, and no performance impact for VM creation.

##### Frontend changes

Divide cluster policy side tab into two sections, "scheduling policy" and "additional properties". "Enable Trusted Service" checkbox must be selected to create a trusted cluster.

![](figure9.jpg "figure9.jpg")

##### Backend changes

1. Add attestation check logic in "InitVdsOnUpCommand.java" to initialize status of each host before active, this java file can be found in this path org.ovirt.engine.core.bll.

*   The first time when this host add into a trust cluster, call attestation server to determine the real status (untrusted , trusted) of the VDS (physical host), the host will be in "up" status if get "trusted" result from attestation server, or else, set this host as non-operational status.
*   When host is down for a different reason and up again, attestation check logic will be triggered also.
*   Call SetNonOperationalVdsCommand with a new NonOperationalReason. This command will try to migrate all VMs from the host and then set it non-operational. In the case of another trusted host existed in trust cluster, all of the VMs will try to migrate to that trusted host. For the non-migrational VMs, keep these VMs running.

2. Activate a trusted host by admin {optional}

Admin can activate an untrusted host manually after getting a positive response from attestation server manually. This is optional as host’s status changes only under the conditional of reboot, host’s reboot and invoke InitVdsOnUpCommand will call attestation server again.

In the UI there is an "Activate" option. What still needs to be added is the checking with the attestation server to make sure that whether this host is trusted and this cluster is defined as 'Trusted'. If so, only trusted host will succeed in the activate command (a proper Audit Log error in case the host failed to activate due to trust issue.) Check logic will be added in VdsManager:activate ().

Code path is “ovirt-engine/backend/manager/modules/vdsbroker/src/main/java/org/ovirt/engine/core/vdsbroker/” where the re-activation process begins.

##### OVF related changes

When the VM created in the trusted cluster was exported as OVF file, OVF file should have a new flag to indicate this VM should be running in a trusted cluster. Key relevant classes include OvfTemplateReader.java, OvfTemplateWriter.java, OvfVmReader.java and OvfVmWriter.java. We define this new property in export file as “trusted_service”. When importing a 'trusted' VM into an untrusted cluster, two cases should be considered.

*   The admin is doing a mistake and chooses the wrong cluster, alert information will be triggered.
*   The admin has a real case where he wants the VM to run in an 'untrusted' cluster.

##### Restful API

Create a trusted cluster via restful API, curl command may like this.

      curl -v -u "admin@internal:abc123" -H "Content-type: application/xml" -d '`<cluster><name>`my_trust_cluster`</name><data_center><name>`"Default"`</name></data_center>` `<version minor="2" major="3"/>` `<cpu id="Intel SandyBridge Family"/><trusted_service>`true`</trusted_service></cluster>`' '`[`http://engine`](http://engine)`.***.com:80/api/clusters'

Key relevant modification includes api.xsd and ClusterMapper.java.

##### Database change

Trust cluster need a new property named as “trusted_service” to indicate this is a trusted cluster. Relevant tables / views include vds_groups, vm_templates_view and vms.

##### High Availability

Not to implement in the first version.

### Benefit to oVirt

This is a new feature, it will bring higher security level for data center managed with oVirt.

### Dependencies / Related Features

None.

### Documentation / External references

*   [Trusted compute pools deployment](Trusted compute pools deployment)
*   <https://github.com/OpenAttestation/OpenAttestation.git>
*   <http://en.wikipedia.org/wiki/Trusted_Execution_Technology>

### Comments and Discussion

*   Refer to [Talk:Trusted compute pools](Talk:Trusted compute pools)

### Test cases

*   Create trusted cluster

1.  Login webadmin
2.  Open "cluster" page
3.  Click "New" button to open the new cluster window
4.  Check "Enable Trusted Service" checkbox and click "OK"

*   Add one trusted node

1.  Login webadmin
2.  Open the "host" page
3.  Click "New" button to open the new host page
4.  Choose a trusted cluster from the dropdown list with label "Host Cluster" and click "OK"

*   Add one untrusted node

1.  Login webadmin
2.  Open the "host" page
3.  Click "New" button to open the new host page
4.  Choose a trusted cluster from the dropdown list with label "Host Cluster" and click "OK"

*   Reboot engine host

1.  Make sure there is one trusted host with "UP" status
2.  Restart the engine service
3.  Open the Host panel, check the trusted host's status

*   Reboot node in untrusted cluster

1.  Set the untrusted host's status to maintenance
2.  Reboot the node manually
3.  After the host is started, perform "Confirm 'Host has been rebooted'" operation

*   Reboot a trusted node in trusted cluster

1.  Set the untrusted host's status to maintenance
2.  Reboot the trusted host manually
3.  After the host start, click "Confirm 'Host has been rebooted'"

*   Reboot the untrusted node in the trusted cluster

1.  Set the untrusted host's status to maintenance
2.  Reboot the node manually
3.  After the host is started, perform "Confirm 'Host has been rebooted'" operation

*   Reboot the untrusted node after fixing the issue

1.  Set the untrusted host's status to maintenance
2.  Reboot the node manually
3.  After the host is started, perform "Activate'" operation

*   Reboot the trusted node after tampering with the PCR

1.  Set the untrusted host's status to maintenance
2.  Reboot the node manually
3.  After the host is started, perform "Activate'" operation

*   Activate the untrusted node in trusted cluster

1.  Set the untrusted host's status to maintenance
2.  Reboot the untrusted host manually
3.  After the host is started, right click the host and activate the host

*   Create one truster cluster via restful API

1.  Exec command: curl -v -u "admin@internal:abc123" -H "Content-type: application/xml" -d '<cluster><name>my_trust_cluster</name><data_center><name>"Default"</name></data_center> <version minor="2" major="3"/> <cpu id="Intel SandyBridge Family"/><trusted_service>true</trusted_service></cluster>' '<http://engine>.\*\*\*.com:80/api/clusters'

*   Export VM

1.  Open "Virtual Machines" page, choose the trusted VM and click "Export"
2.  Open "Storage" page, import a new trusted VM

*   Export template

1.  Open "Template" page, choose the template and click "Export"
2.  Open "Storage" page, import a new template

*   Run the exported VM

1.  Open "Virtual Machines" page, choose the exported VM
2.  Right click the VM and run this VM

<Category:Feature>
