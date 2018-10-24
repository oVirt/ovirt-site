---
title: Active-Active Disaster Recovery
---

# Chapter 2: Active-Active Disaster Recovery

##Active-Active Overview

oVirt supports an active-active disaster recovery failover configuration that can span two sites. Both sites are active, and if the primary site becomes unavailable, the oVirt environment will continue to operate in the secondary site to ensure business continuity.

The active-active failover is achieved by configuring a stretch cluster where hosts capable of running the virtual machines are located in the primary and secondary site. All the hosts belong to the same oVirt cluster.

You require replicated storage that is writeable on both sites to allow virtual machines to migrate between sites and continue running on the site’s storage.

**Stretch Cluster Configuration**
![](/images/disaster-recovery/StretchCluster.png)

Virtual machines will migrate to the secondary site if the primary site becomes unavailable. The virtual machines will automatically failback to the primary site when the site becomes available and the storage is replicated in both sites.

**Failed Over Stretch Cluster**
![](/images/disaster-recovery/StretchClusterFailover.png)

    **Important:** To ensure virtual machine failover and failback works:

* Virtual machines must be configured to be highly available, and each virtual machine must have a lease on a target storage domain to ensure the virtual machine can start even without power management.

* Soft enforced virtual machine to host affinity must be configured to ensure the virtual machines only start on the selected hosts.

The stretched cluster configuration can be implemented using a self-hosted engine environment, or a standalone Engine environment.

### Network Considerations

All hosts in the cluster must be on the same broadcast domain over an L2 network. This means that connectivity between the two sites needs to be L2.

The maximum latency requirements between the sites across the L2 network differs for the two setups. The standalone Engine environment requires a maximum latency of 100ms, while the self-hosted engine environment requires a maximum latency of 7ms.

### Storage Considerations

The storage domain for oVirt can be made of either block devices (SAN - iSCSI or FCP) or a file system (NAS - NFS, GlusterFS, or other POSIX compliant file systems).

The sites require synchronously replicated storage that is writeable on both sites with shared layer 2 (L2) network connectivity. The replicated storage is required to allow virtual machines to migrate between sites and continue running on the site’s storage. All storage replication options supported by Enterprise Linux 7 and later can be used in the stretch cluster.

    **Important:** If you have a custom multipath configuration that is recommended by the storage vendor, copy the .conf file to the `/etc/multipath/conf.d/` directory. The custom settings will override settings in the VDSMs `multipath.conf` file.  Do not modify the VDSM file directly.

## Configure a Self-hosted Engine Stretch Cluster Environment

This procedure provides instructions to configure a stretch cluster using a self-hosted engine deployment.

**Prerequisites**:

* A writable storage server in both sites with L2 network connectivity.

* Real-time storage replication service to duplicate the storage.

**Limitations**:

* Maximum 7ms latency between sites.

**Configuring the Self-hosted Engine Stretch Cluster**

1. Deploy the self-hosted engine.

2. Install additional self-hosted engine nodes in each site and add them to your cluster.

3. Optional. Install additional standard hosts.

4. Configure the SPM priority to be higher on all hosts in the primary site to ensure SPM failover to the secondary site occurs only when all hosts in the primary site are unavailable.

5. Configure all virtual machines that need to failover as highly available, and ensure that the virtual machine has a lease on the target storage domain.

6. Configure virtual machine to host soft affinity and define the behavior you expect from the affinity group.

The active-active failover can be manually performed by placing the main site's hosts into maintenance mode.

## Configure a Standalone Engine Stretch Cluster Environment

This procedure provides instructions to configure a stretch cluster using a standalone Engine deployment.

**Prerequisites:**

* A writable storage server in both sites with L2 network connectivity.

* Real-time storage replication service to duplicate the storage.

**Limitations:**

* Maximum 100ms latency between sites.

**Important:** The Engine must be highly available for virtual machines to failover and failback between sites. If the Engine goes down with the site, the virtual machines will not failover.

The standalone Engine is only highly available when managed externally. For example:

* Using oVirt’s High Availability Add-On.

* As a highly available virtual machine in a separate virtualization environment.

* Using Enterprise Linux Cluster Suite.

* In a public cloud.

**Configuring the Standalone Engine Stretch Cluster**

1. Install and configure the oVirt Engine.

2. Install the hosts in each site and add them to the cluster.

3. Configure the SPM priority to be higher on all hosts in the primary site to ensure SPM failover to the secondary site occurs only when all hosts in the primary site are unavailable.

4. Configure all virtual machines that need to failover as highly available, and ensure that the virtual machine has a lease on the target storage domain.

5. Configure virtual machine to host soft affinity and define the behavior you expect from the affinity group.

The active-active failover can be manually performed by placing the main site's hosts into maintenance mode.

**Prev:** [Chapter 1: Disaster Recovery Solutions](../disaster_recovery_solutions)<br>
**Next:** [Chapter 3: Active-Passive Disaster Recovery](../active_passive_overview)

[Adapted from oVirt 4.2 documentation - CC-BY-SA](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.2/html/disaster_recovery_guide/active_active)
