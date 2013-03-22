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

*   WIP (@ <http://gerrit.ovirt.org/11237>)
*   Last updated date: Feb 1, 2013

### Detailed Description

The feature will allow data center administrator to build trusted computing pools based on H/W-based security features, such as Intel Trusted Execution Technology (TXT). Combining attestation done by a separate entity (i.e. "remote attestation"), the administrator can ensure that verified measurement of software be running in hosts, thus they can establish the foundation for the secure enterprise stack. Such remote attestation services can be developed by using SDK provided by OpenAttestation project.

Remote Attestation server performs host verification through following steps:

1. Hosts boot with Intel TXT technology enabled

2. The hosts' BIOS, hypervisor and OS are measured

3. These measured data is sent to Attestation server when challenged by attestation server

4. Attestation server verifies those measurements against good/known database to determine hosts' trustworthiness

![](figure7.jpg "figure7.jpg")

#### Frontend changes

Trusted compute pools support on the UI will be found on the new/edit VM/template window, besides, this feature will also support import /export for ovf relevant function (on going efforts). The latest status for UI changes have provides end user a choice of running a VM on a trusted host, includes create a new VM, edit an exited VM.

1. Create / Edit a trusted VM based on GUI radio box.

Choose to run guest VM on a trusted node, please refer to figure 2. After guest VM is created, this VM could also be served as the VM template via import/export template function provided from GUI.

![](figure5.jpg "figure5.jpg")

2. Create a trusted VM based on the template generated from the trusted VM we created.

![](figure1.jpg "figure1.jpg")

3. Based on our current consideration, migration is not allowed for a trusted VM. If end user wants to launch a VM on a trusted host, migration options will be disabled to avoid complicated modification and logical confusion.

![](figure6.jpg "figure6.jpg")

#### Backend changes

*   Both Vm (creation and edit) and Template will support for trusted compute pools.
*   Define a hostValidator to support the physical host's attestation, only trusted physical server can be added to vds candidate list.
*   Add a cache manager module to improve system's performance in case of large concurrent requests (Details about cache will be illustrated here).

To launch guest VM on trusted host, engine server will filter all of nodes according to each host’s trustworthiness, only trusted hosts will be chosen as candidates. Open Attestation SDK will take some time to check whether a node is trusted or not, thus, cache is very important here to guarantee engine server’s performance with large concurrent requests. Here, we cache all nodes’ trustworthiness when the first guest VM try to launch on a trusted node. Node’s status is valid only in a given time and this time is configurable. In case of any node’s status becomes invalid or some new nodes add in cloud computing environment, all of nodes’ status will be updated at the same time, refer to figure 3 for flow diagram.

The decision to update all nodes in the trust status cache while one node's cache gets expired is based on three points below:

1.  the expiration time should be very close for all node statuses since they were all accessed in a very short period.
2.  we assume other nodes will be accessed soon
3.  there is a fact for Query toward attestation service: query(nodeA, nodeB) will take less time than query(nodeA) then query(nodeB). So if we can predict needs for query multiple nodes, we try our best to align them into one query request.

![](figure3.jpg "figure3.jpg")

#### Database changes

*   table of vm_static will add a new field, true value of this field implies end users want to launch a VM on a trusted physical host.
*   procedure of InsertVmStatic/ UpdateVmStatic/ DeleteVmStatic will modified accordingly to support VM's creation, modification and deletion.
*   procedure of InsertVmTemplate / UpdateVmTemplate modified accordingly to support VM template.

#### REST API changes

under consideration.

#### OVF related changes

under consideration.

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

*   Make template based on a existed trusted VM

1.  Make sure the trusted VM is in power-off status.
2.  Click "Make Template" button right up on all of the VMs.
3.  Fill all of the required value.
4.  Click "OK" button, a trusted VM template is created.
5.  Create a new VM, switch to "general" tab, a trusted VM template will be found in the "Based on Template" drop down list.

*   Support OVF-related function

1.  Make sure the trusted VM is in power-off status.
2.  Click "Export" button right up on all of the VMs.
3.  A ovf-formatted file which includes all of the VM info will be created.
4.  Copy the ovf file to another ovirt setup env and create a trusted VM based on this ovf file.

*   Restful API (under consideration)

<!-- -->

*   Launch a trusted VM, and check if this VM is spawning on a trusted physical host

1.  Prepare at least two nodes with one trusted physical host and one untrusted physical host.
2.  Right click the trusted VM and choose "Run Once" item.
3.  Fill all of the required value.
4.  Click "OK" button.
5.  Check whether the trusted VM is running on a trusted node.

<Category:Feature>
