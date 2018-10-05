# Configure a Standalone Manager Stretch Cluster Environment

This procedure provides instructions to configure a stretch cluster using a standalone Manager deployment. 

**Prerequisites**:

* A writable storage server in both sites with L2 network connectivity.
* Real-time storage replication service to duplicate the storage.

**Limitations*:*

* Maximum 100ms latency between sites.

**Important:** The Manager must be highly available for virtual machines to failover and failback between sites. If the Manager goes down with the site, the virtual machines will not failover.

The standalone Manager is only highly available when managed externally. For example: 

* Using Red Hat’s High Availability Add-On.
* As a highly available virtual machine in a separate virtualization environment.
* Using Red Hat Enterprise Linux Cluster Suite.
* In a public cloud.

**Configuring the Standalone Manager Stretch Cluster**

1. Install and configure the Red Hat Virtualization Manager. See [Installing the Red Hat Virtualization Manager](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.2/html-single/installation_guide/#part-Installing_the_Red_Hat_Virtualization_Manager) in the *Installation Guide*.

2. Install the hosts in each site and add them to the cluster. See [Installing Hosts](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.2/html-single/installation_guide/#part-Installing_Hosts) and [Adding a Host to the Red hat Virtualization Manager](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.2/html-single/installation_guide/#Adding_a_Hypervisor) in the *Installation Guide*.

3. Configure the SPM priority to be higher on all hosts in the primary site to ensure SPM failover to the secondary site occurs only when all hosts in the primary site are unavailable. See [SPM Priority](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.1/html-single/administration_guide/#SPM_Priority) in the *Administration Guide*.

4. Configure all virtual machines that need to failover as highly available, and ensure that the virtual machine has a lease on the target storage domain. See [Configuring a Highly Available Virtual Machine](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.1/html-single/virtual_machine_management_guide/#Configuring_a_highly_available_virtual_machine) in the *Virtual Machine Management Guide*.

5. Configure virtual machine to host soft affinity and define the behavior you expect from the affinity group. See [Affinity Groups](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.1/html-single/virtual_machine_management_guide/#sect-Affinity_Groups) in the *Virtual Machine Management Guide* and [Scheduling Policies](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.1/html-single/administration_guide/#sect-Scheduling_Policies) in the *Administration Guide*.

The active-active failover can be manually performed by placing the main site's hosts into maintenance mode.
