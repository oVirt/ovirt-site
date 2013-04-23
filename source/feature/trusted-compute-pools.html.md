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

*   Finished POC in approach 1(@ <http://gerrit.ovirt.org/11237>)
*   WIP for approach 2 (@ TBD )
*   Last updated date: Apr 23, 2013

### Detailed Description

The feature will allow data center administrator to build trusted computing pools based on H/W-based security features, such as Intel Trusted Execution Technology (TXT). Combining attestation done by a separate entity (i.e. "remote attestation"), the administrator can ensure that verified measurement of software be running in hosts, thus they can establish the foundation for the secure enterprise stack. Such remote attestation services can be developed by using SDK provided by OpenAttestation project.

Remote Attestation server performs host verification through following steps:

1. Hosts boot with Intel TXT technology enabled

2. The hosts' BIOS, hypervisor and OS are measured

3. These measured data is sent to Attestation server when challenged by attestation server

4. Attestation server verifies those measurements against good/known database to determine hosts' trustworthiness

![](figure7.jpg "figure7.jpg")

By far, we got two implementation approaches for TCP feature:

*   Approach 1: trust property in VM level policy, POC done, Pending for VM migration implementation & performance optimization.
*   Approach 2: trust property in cluster level policy, WIP. The biggest benefits are VM migration can work without specific changes, and no performance impact for VM creation.

#### Approach 1: trust property in VM level policy (Pending)

##### Frontend changes

Trusted compute pools support on the UI will be found on the new/edit VM/template window, besides, this feature will also support import /export for ovf relevant function (ongoing efforts). The latest status for UI changes have provides end user a choice of running a VM on a trusted host, includes create a new VM, edit an exited VM.

1. Create / Edit a trusted VM based on GUI radio box.

Choose to run guest VM on a trusted node, please refer to figure 2. After guest VM is created, this VM could also be served as the VM template via import/export template function provided from GUI.

![](figure5.jpg "figure5.jpg")

2. Create a trusted VM based on the template generated from the trusted VM we created.

![](figure1.jpg "figure1.jpg")

3. Based on our current consideration, migration is not allowed for a trusted VM. If end user wants to launch a VM on a trusted host, migration options will be disabled to avoid complicated modification and logical confusion.

![](figure6.jpg "figure6.jpg")

##### Backend changes

*   Both Vm (creation and edit) and Template will support for trusted compute pools.
*   Define a hostValidator to support the physical host's attestation, only trusted physical server can be added to vds candidate list.
*   Add a cache manager module to improve system's performance in case of large concurrent requests (Details about cache will be illustrated here).

To launch guest VM on trusted host, engine server will filter all of nodes according to each host’s trustworthiness, only trusted hosts will be chosen as candidates. Open Attestation SDK will take some time to check whether a node is trusted or not, thus, cache is very important here to guarantee engine server’s performance with large concurrent requests. Here, we cache all nodes’ trustworthiness when the first guest VM try to launch on a trusted node. Node’s status is valid only in a given time and this time is configurable. In case of any node’s status becomes invalid or some new nodes add in cloud computing environment, all of nodes’ status will be updated at the same time, refer to figure 3 for flow diagram.

The decision to update all nodes in the trust status cache while one node's cache gets expired is based on three points below:

1.  the expiration time should be very close for all node statuses since they were all accessed in a very short period.
2.  we assume other nodes will be accessed soon
3.  there is a fact for Query toward attestation service: query(nodeA, nodeB) will take less time than query(nodeA) then query(nodeB). So if we can predict needs for query multiple nodes, we try our best to align them into one query request.

![](figure3.jpg "figure3.jpg")

##### Database changes

*   table of vm_static will add a new field, true value of this field implies end users want to launch a VM on a trusted physical host.
*   procedure of InsertVmStatic/ UpdateVmStatic/ DeleteVmStatic will modified accordingly to support VM's creation, modification and deletion.
*   procedure of InsertVmTemplate / UpdateVmTemplate modified accordingly to support VM template.

##### REST API changes

Create a trusted VM via restful API, curl command may like this.

      curl -v -u "admin@internal:abc123" -H "Content-type: application/xml" -d '`<vm><name>`my_new_vm`</name><cluster><name>`Default`</name></cluster><template><name>`Blank`</name></template><trusted_host_flag>`true`</trusted_host_flag></vm>`' '`[`http://`](http://)`***:80/api/vms'

Key relevant modification includes api.xsd and VmMapper.java.

##### OVF related changes

When the VM created in the trusted cluster was exported as OVF file, OVF file should have a new flag to indicate this is a trusted VM running in a trusted host. Key relevant classes include OvfTemplateReader.java, OvfTemplateWriter.java, OvfVmReader.java and OvfVmWriter.java. We define this new property in export file as “TrustedHostFlag”.

#### Approach 2: trust property in cluster level policy (WIP)

##### Frontend changes

Divide cluster policy side tab into two sections "scheduling policy" and "additional properties". "Enable Trusted Service" checkbox must be selected to create a trusted cluster.

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

3. Import / Export support (OVF)

When the VM created in the trusted cluster was exported as OVF file, OVF file should have a new flag to indicate this VM should be running in a trusted cluster. Key relevant classes include OvfTemplateReader.java, OvfTemplateWriter.java, OvfVmReader.java and OvfVmWriter.java. We define this new property in export file as “trusted_cluster_flag”. When importing a 'trusted' VM into an untrusted cluster, two cases should be considered.

*   The admin is doing a mistake and chooses the wrong cluster, alert information will be triggered.
*   The admin has a real case where he wants the VM to run in an 'untrusted' cluster.

##### Restful API

Create a trusted cluster via restful API, curl command may like this.

      curl -v -u "admin@internal:abc123" -H "Content-type: application/xml" -d '`<cluster><name>`my_cluster `</name><trusted_cluster_flag >`true` `' '`[`http://engine`](http://engine)`.***.com:80/api/cluster'

Key relevant modification includes api.xsd and VmMapper.java.

##### Database change

Trust cluster need a new property named as “trusted_cluster_flag” to indicate this is a trusted cluster. Relevant tables / views include dwh_cluster_configuration_history_view, vds_groups, we may need modify insert_data.sql to modify the property of the default cluster.

##### High Availability

Not to implement in the first version.

### Benefit to oVirt

This is a new feature, it will bring higher security level for data center managed with oVirt.

### Dependencies / Related Features

None.

### Documentation / External references

*   <https://github.com/OpenAttestation/OpenAttestation.git>
*   <http://en.wikipedia.org/wiki/Trusted_Execution_Technology>

### Comments and Discussion

*   Refer to [Talk:Trusted compute pools](Talk:Trusted compute pools)

### Test cases

#### For Approach 1

*   Create a trusted VM from GUI

1.  Create a new server.
2.  In the popup window, select "Host" tab and then select "Run on Trusted Host" radiobox for the "Run on" options.
3.  Fill other required value.
4.  Click "OK" button, a VM with trusted flag enabled is created.

*   View/eidt VM to set or unset "Run on Trusted Host"

1.  Choose a VM with "Run On" options set as "Any Host in Cluster".
2.  Reset "Run On" options with "Run on Trusted Host".
3.  Right click the VM to edit this VM.
4.  Check whether "Run On" options is configured as "Run on Trusted Host".

*   Make template based on an existed trusted VM

1.  Make sure the trusted VM is in power-off status.
2.  Click "Make Template" button right up on all of the VMs.
3.  Fill all of the required value.
4.  Click "OK" button, a trusted VM template is created.
5.  Create a new VM, switch to "general" tab, a trusted VM template will be found in the "Based on Template" drop down list.

*   Support OVF-related function

1.  Make sure the trusted VM is in power-off status.
2.  Click "Export" button right up on all of the VMs.
3.  An ovf-formatted file which includes all of the VM info will be created.
4.  Copy the ovf file to another ovirt setup env and create a trusted VM based on this ovf file.

*   Restful API (under consideration)

<!-- -->

*   Launch a trusted VM, and check if this VM is spawning on a trusted physical host

1.  Prepare at least two nodes with one trusted physical host and one untrusted physical host.
2.  Right click the trusted VM and choose "Run Once" item.
3.  Fill all of the required value.
4.  Click "OK" button.
5.  Check whether the trusted VM is running on a trusted node.

#### For Approach 2

Define later

<Category:Feature>
