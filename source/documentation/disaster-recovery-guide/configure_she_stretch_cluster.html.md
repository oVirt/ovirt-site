# Configure a Self-hosted Engine Stretch Cluster Environment

This procedure provides instructions to configure a stretch cluster using a self-hosted engine deployment. 

**Prerequisites**:

* A writable storage server in both sites with L2 network connectivity.
* Real-time storage replication service to duplicate the storage.

**Limitations**:

* Maximum 7ms latency between sites.

**Configuring the Self-hosted Engine Stretch Cluster**

1. Deploy the self-hosted engine. See [Deploying Self-Hosted Engine](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.2/html-single/self-hosted_engine_guide/#chap-Deploying_Self-Hosted_Engine) in the *Self-hosted Engine Guide*.

2. Install additional self-hosted engine nodes in each site and add them to your cluster. See [Installing Additional Self-Hosted Engine Nodes](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.2/html-single/self-hosted_engine_guide/#Installing_Additional_Self-Hosted_Engine_Nodes) in the *Self-hosted Engine Guide*.

3. Optional. Install additional standard hosts. See [Adding a Host to the Red Hat Virtualization Manager](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.2/html-single/installation_guide/#Adding_a_Hypervisor) in the *Installation Guide*.

4. Configure the SPM priority to be higher on all hosts in the primary site to ensure SPM failover to the secondary site occurs only when all hosts in the primary site are unavailable. See [SPM Priority](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.1/html-single/administration_guide/#SPM_Priority) in the *Administration Guide*.

5. Configure all virtual machines that need to failover as highly available, and ensure that the virtual machine has a lease on the target storage domain. See [Configuring a Highly Available Virtual Machine](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.1/html-single/virtual_machine_management_guide/#Configuring_a_highly_available_virtual_machine) in the *Virtual Machine Management Guide*.

6. Configure virtual machine to host soft affinity and define the behavior you expect from the affinity group. See [Affinity Groups](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.1/html-single/virtual_machine_management_guide/#sect-Affinity_Groups) in the *Virtual Machine Management Guide* and [Scheduling Policies](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.1/html-single/administration_guide/#sect-Scheduling_Policies) in the *Administration Guide*.

The active-active failover can be manually performed by placing the main site's hosts into maintenance mode.

