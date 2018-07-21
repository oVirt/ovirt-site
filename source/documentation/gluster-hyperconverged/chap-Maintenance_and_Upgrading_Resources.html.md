---
title: Maintenance and Upgrading Resources
---

# Chapter: Maintenance and Upgrading Resources

## Maintaining the Self-Hosted Engine

Refer [Maintaing the Self-hosted Engine](../self-hosted/chap-Maintenance_and_Upgrading_Resources)

## Maintaining Gluster storage

* Hosts can be moved to maintenance in the oVirt Engine UI to perform maintenance tasks. Ensure that gluster services are stopped while moving host to maintenance by enabling this option in UI

* If upgrading gluster version on the hosts, rolling upgrades are supported. Refer to [gluster documentation](https://gluster.readthedocs.io/en/latest/Upgrade-Guide/README/) for rolling upgrades for version specific information
    * Move host to maintenance with glusterd service stopped
    * Upgrade the gluster packages
    * Activate the host 
    * Ensure heal is complete. This can be monitored from UI or from cli using `gluster volume heal info`
    * Repeat this for other hosts in cluster

NOTE: If geo-replication is setup on the gluster volumes, the geo-replication needs to be stopped on volume before performing the upgrade.

## Removing a host from hyperconverged setup

* Hosts that have a brick cannot be removed - can only be replaced. You will need to first replace the bricks on host with another brick. 
    * Add a new host to the cluster
    * Create bricks on the newly added host - the `Create Brick` UI option from the Storage Devices sub-tab can be used to prepare and mount bricks.
    * Replace bricks from the host to be removed using the `Replace Brick` option
    * Once all bricks are replaces, the host can be moved to maintenance and removed.

## Graceful shutdown and startup
Currently there is no scirpt or single command available to shutdown a whole cluster. However, the following steps can be executed to manually shutdown and start a cluster again.

### Shutdown
1. Shutdown all VMs
2. Enable global maintenance mode:
    * In the Administration Portal, right-click the engine virtual machine, and select **Enable Global HA Maintenance**.
    * You can also set the maintenance mode from the command line:
    
            # hosted-engine --set-maintenance --mode=global

3. Wait for all VMs to be down
4. If the cluster is running a hosted engine:
   1. Logon to the node running hosted-engine
   2. Shutdown hosted-engine
   
            # hosted-engine --vm-shutdown
   
   3. Wait for stopped hosted engine using
   
            # hosted-engine --vm-status

5. Shutdown all nodes

### Startup
1. Switch on all nodes
2. Start glusterd on all nodes since it does not start by default

         # systemctl start glusterd

3. Check peer and volume status on one of the nodes

         # gluster peer status
         # gluster volume status all
   
4. Wait for ovrt-ha-agent until 

         # hosted-engine --vm-status
   
   does not fail anymore printing `The hosted engine configuration has not been retrieved from shared storage. Please ensure that ovirt-ha-agent is running and the storage server is reachable.`
5. Start hosted engine on one of the nodes

         # hosted-engine --vm-start

6. Check status repeatably and wait until health reports to be good
   
         # hosted-engine --vm-status 

7. In the Administration Portal's host list, wait until a node got the SPM role

8. Disable global maintenance mode in the Administration Portal or using the command line

         # hosted-engine --set-maintenance --mode=none

9. Start VMs

**Prev:** [Chapter: Troubleshooting](../chap-Troubleshooting) <br>
**Next:** [Chapter: Single Node Hyperconverged](../chap-Single_node_hyperconverged)
