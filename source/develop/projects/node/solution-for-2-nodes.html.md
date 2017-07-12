---
title: solution for 2 nodes
category: node
authors: philipp reisner
---

# solution for 2 nodes

## DRBD & Pacemaker for oVirt

### Summary

To provide a highly avialable virtualization environment with oVirt we are going to use two physical machines providing a bare KVM (hosting the oVirt Manager) and an iSCSI target as storage for the virtual guests. Furthermore, the two physical nodes will be used as oVirt hypervisors. We will use to use DRBD for data replication of the KVM and the iSCSI-storage between the nodes. Pacemaker and heartbeat will serve as the cluster management system.

![](/images/wiki/drbd_pacemaker_iscsi_ovirt.png)

The full guide is available as .pdf. Download **High-Availability oVirt-Cluster with iSCSI-Storage** from [LINBIT's tech-guide page](http://www.linbit.com/en/downloads/tech-guides).

### Owner

*   Name: Philipp Reisner (philipp_reisner)
*   Email: <philipp.reisner@linbit.com>
