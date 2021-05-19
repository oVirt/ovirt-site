---
title: VM lifecycle in Kubevirt
category: feature
authors: arik
---

This page proposes a gradual way to integrate the virtualization management platform oVirt and containers management platform Kubernetes.


# Motivation

The virtualization management platform oVirt and the containers management platform Kubernetes share common capabilities. For example, both platforms need to determine on which node to run their managed entity (VM/container), run and then monitor it.  

It is thus tempting to reuse the common parts of these platforms instead of developing and maintaining a dedicated infratructure in each of them.  

However, it is not as easy as it may sound. The differences between virtual machines and containers require different capabilities and decision making by the management platform. Moreover, these two platforms are written in different technology and designed differently.  

Therefore, it only makes sense to consider a gradual integration between the two platforms by delegating stuff from oVirt into Kubevirt, an extended form of Kubernetes that includes components that are specific to virtual machines. A natural choice would be to start with delegating the scheduling and virtual machine creation from oVirt to Kubernetes.  

# The Current Process in oVirt

In this section I elaborates on the process of running a virtual machine in oVirt. The creation of the virtual machine is done as a separate operation before it is being run so we can assume that the VM already exists in the database at this stage.  

The process looks as follow:  
0. Optional: a request is sent from client (UI/REST-API).  
1. Instance of RunVmCommand is created.  
2. The input is being verified. Specifically, the scheduler validates that there is a host capable of running the VM.  
3. The engine retrieves all the properties of the VM to run.  
4. The scheduler chooses a host to run the VM on.  
5. The engine locks host devices, plug lun disks and update cinder disks.  
6. The engine locks the monitoring thread.  
7. The engine sends a request to VDSM on the chosen host to run the VM.  
8. If the response if positive, the engine set the VM to WaitForLaunch state (and few other fields).  
9. The monitoring lock is released.  
10. The monitoring receives the VM as running (positive flow) or down (negative flow). If the VM fails to run, the engine tries to run it few more time (by default 2 additional attempts).

# Proposed Approach

So this proposal split the integration between oVirt and Kubernetes in regards to VM lifecycle into several phases. Note that some of them can be done in parallel.   

## Milestone 1: Basic integration

### Goal
1. Initial notion of Kubevirt in oVirt.  
2. Kubevirt sends the run-request to the relevant node.  

### Design
We aim to have Kubevirt as a configuration of a cluster so eventually we would be able to have a Data-center with cluster with lower compatibility version that works as it used to work before and cluster with the up-to-date compatibility version that works with Kubevirt. That way, we enable the user to upgrade existing system without having to stop the VMs.  

So a cluster would have a property called "type". Initially the type will have two values: legacy, kubevirt. If 'kubvirt' is chosen, the user will need to provide the URL and authentication details of Kubevirt.  

Note that we may use the same mechanism used in external provider to hold the authentication info. Another alternative is to use a full blown external provider for this, as we did for the integration with virt-v2v (where external provider is used only to contain pre-defined configuration of the remote system). Anyway, we do not have to decide this at this stage.  

Then, the mentioned run-VM flow will be modified. The only change would be that in Kubvirt-cluster, CreateBrokerVDSCommand will generate a bit different configuration of the VM and will send it to Kubevirt (using the Kubernetes API) that would send it to VDSM (VDSM is expected to run on each node in the cluster at the beginning) rather than sending it directly to VDSM. Note that the scheduling is still done in oVirt.  

The represenation of the VM will be as follow (in JSON):  
1. Domxml (Kubevirt passes it as-is to the node at this stage, later on Kubervirt will replace placeholders within the XML).  
2. The scheduled host (Kubvirt uses this as the destination node).

### Benefits
1. First notion of Kubernetes in oVirt + start getting feedback on running real-world virtual machines with Kubevirt.    
2. We bypass the 'create' verb in the engine<->vdsm API.  
3. We do not depend on having a full blown scheduler in Kubervirt.

### Limitations & Challenges
1. At this stage the engine does not do the operations that it used to do after the detination host was chosen and before sending the request to VDSM.  
2. The engine cannot lock the monitoring until VDSM acknowlege that the request arrives. So we need to set a timeout so if the VM is still down afterwards, we'll conclude that the run operation failed.
3. oVirt (engine) still schedules the nodes.
4. oVirt (engine + VDSM) still monitors the nodes as it used before.  
5. Most of the VM related operations are still done directly with VDSM (rather than through Kubervirt).

## Milestone 2: Scheduling

### Goal
Basic VM schedluing in Kubevirt.

### Design
1. Extend the VM representation with cluster-related data, e.g., host-pinning. This will be represented as properties in JSON. VM-related data needs to be retrieved from the VM configuration (see VM Represenation section).  
2. Adjust VMs monitoring as described above. That is, to add a timeout for run-vm so the monitoring will end the run-vm operation if the VM is down after some time.  
3. Some basic mointoring should be done in Kubevirt in order to rerun a virtual machine (oVirt cannot do this at this phase since the engine doesn't know which nodes were previously chosen). Kubevirt is reponsible to detecting failures to run the VM on the node and to attempt to reschedule the VM on another node.

### Benefits
1. We start to extract the scheduling part from oVirt.  
2. We add basic monitoring capability to Kubevirt (to examine the state of the VM on the scheduled node and retrieve information that is needed for scheduling).  
3. We extract the rerun mechanism for run-VM from oVirt.  

### Limitations & Challenges
1. Either use the 'stop-the-world' approach of the current scheduler in oVirt or invent an alternative approach.  
2. The scheduling does not take into consideration host-devices.  
3. We still do not do the post-scheduling and pre-interaction with VDSM operations that we used to do (e.g., connect lun disks).  
4. Most of the VMs monitoring remains the same.  
5. Most of the VM related operations are still done directly with VDSM (rather than through Kubervirt).
6. If we fail to run a VM on a node several times in a short-period of time, the node should be non-operational (and thus not be scheduled until fixed).

## Milestone 3: Dynamic Cluster State Managed by Kubevirt

### Goal
At this point we have basic monitoring of VMs. This milestone is about detecting more changes in running VMs in Kubevirt and report them to oVirt. Ideally, most of VmDynamic would be managed in Kubevirt and will be in oVirt only for display purpose. This allows us to switch VM management operations (shutdown, migrate, suspend, ..) to be done via Kubervirt.

### Design
1. Receive the VMs state from the node and updating the dynamic part in the VM representation.  
2. Starting highly-available VMs in Kubevirt.
3. Change VM management operations: hot-plug/unplug, hibernate, restore, resume, migrate, shutdown, reboot, cancel-migration, power-off.

### Benefits
1. Kubevirt becomes the owner of the runtime state of the cluster while oVirt manages its static state (host-deployments, VM templates, import VMs from external providers, and so on).  
2. Many VM operations are delegated to Kubevirt.

## Future Changes

Future changes depend on having the knowledge of storage and network resources in Kubevirt and thus harder to predict.  

## VM Representation

I believe that the best way to represent the VM is in JSON as follow:  
1. Scheduling data: the cluster-related data mentioned before, in the form of properties in JSON.  
2. VM dynamic data: things like status of the VM, run_on_vds, console ip, and so on. Initially they should be set with default values. Once the monitoring in Kubevirt receives them from the node, it should update the VM representation and some component needs to listen to these changes and report them to the engine in oVirt. Note that we may want to report some of the dynamic data that exist today, like the applications list, in a different way.   
3. VM configuration: the static configuration of the VM, including its devices.  

In oVirt we are in the process of representing the VM configuration in XML (domxml) to eliminate the duplicate conversion of the data (once in the engine, converting the internal representation into a dictionary, and once in VDSM, converting the dictionary into domxml). We would prefer to keep this approach and minimize data conversions. In light of this approach, there are few options of how to represent the VM configuration:  
1. To generate the VM representation in JSON. There is a proposal (on-going work?) to implement another binding for libvirt that will enable to pass the VM definition in JSON. With this, we would still have only one conversion of the VM configuration. That seems like the best approach since Kubernetes works with Yaml formats.  
2. To have the VM configuration as XML blob inside JSON. This would mean that Kubevirt will have to parse VM-level data that it needs (for example, amount of memory for scheduling) by parsing the XML. The XML could be extended and place-holders can be replaced in Kubevirt but Kubevirt must not change other existing values in the XML.  
3. To have the VM configuration as XML blob inside JSON but also to include some of the VM configuration, the ones that Kubevirt is interested in, as properties in JSON. The downside would be that the engine will need to provide higher amount of data. However, this way will simplify data retrieval in Kubevirt.  
