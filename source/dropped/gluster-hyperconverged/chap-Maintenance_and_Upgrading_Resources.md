---
title: Maintenance and Upgrading Resources
---

# Chapter: Maintenance and Upgrading Resources

## Maintaining the Self-Hosted Engine

Refer [Maintaing the Self-hosted Engine](chap-Maintenance_and_Upgrading_Resources.html)

## Maintaining Gluster storage

* Hosts can be moved to maintenance in the oVirt Engine UI to perform maintenance tasks. Ensure that gluster services are stopped while moving host to maintenance by enabling this option in UI

* If upgrading gluster version on the hosts, rolling upgrades are supported. Refer to [gluster documentation](https://docs.gluster.org/en/latest/Upgrade-Guide) for rolling upgrades for version specific information
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

## Expanding a hyperconverged setup

* You can add new hosts to your hyperconverged setup from the oVirt Engine UI. 
* To use storage from the newly added hosts, you need to ensure that storage is added either in increments of 1 bricks (for non-HA usecase) or 3 bricks (either replica 3 or replica 2 + arbiter)
* The bricks can be provisioned from the oVirt Engine UI using the `Storage Devices` sub-tab under `Hosts` or using the `Create Volume` from the Cockpit Gluster dashboard.

**Prev:** [Chapter: Troubleshooting](chap-Troubleshooting.html) <br>
**Next:** [Chapter: Single Node Hyperconverged](chap-Single_node_hyperconverged.html)
