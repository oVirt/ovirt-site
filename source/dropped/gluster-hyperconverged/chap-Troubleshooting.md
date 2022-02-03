---
title: Troubleshooting
---

# Chapter: Troubleshooting

## Troubleshooting issues with gluster storage

* Check if the gluster volume is online and available by running `gluster volume status <volumename>`

```
# gluster volume status engine

Status of volume: engine
Gluster process                             TCP Port  RDMA Port  Online  Pid
------------------------------------------------------------------------------
Brick host1:/rhgs/engine/brick1             49152     0          Y       32216
Brick host2:/rhgs/engine/brick1             49152     0          Y       22750
Brick host3:/rhgs/engine/brick1             49152     0          Y       34750
Self-heal Daemon on localhost               N/A       N/A        Y       32231
Self-heal Daemon on host2                   N/A       N/A        Y       22766
Self-heal Daemon on host3                   N/A       N/A        Y       24766

Task Status of Volume engine
------------------------------------------------------------------------------
There are no active volume tasks
```

The volume is read-only or offline if only 1 brick is online or no bricks are listed in the aboveoutput.


* If one or more bricks are shown as down, check if the glusterd peers are connected by checking `gluster peer status`

```
 # gluster peer status

  gluster peer status
  Number of Peers: 2

  Hostname: host2
  Uuid: 9cdba428-a435-4841-a8dc-82ecce8a5cbd
  State: Peer in Cluster (Connected)

  Hostname: host3
  Uuid: d7fbc1cb-1a9e-4d53-b1cf-97fae9ceb0d0
  State: Peer in Cluster (Connected)
```

If the state is other than `Peer in Cluster (Connected)` then there is an issue.

   * You can check that the `glusterd` service is running on all the nodes. If not, try restarting the service using `systemctl restart glusterd`

   * Check that the ports required by Gluster are open for communication between the nodes of the cluster

   * If none of the above works, check the glusterd logs in /var/log/glusterfs/glusterd.log

* If the peers are connected, but not all the brick processes are running, you can try and start the processes using `gluster volume start <volumename> force` from any one of the nodes. This can also be done from the engine UI if ovirt-engine is running

## Troubleshooting the Self-Hosted Engine

* Hosted-engine does not failover to other hosts

    * Check the Hosted engine score on three host. If NA or 0, check if ovirt-ha-agent and ovirt-ha-broker service is running.
    * Hosted-engine --vm-status - are the other hosts listed?
    * Check if while deploying the additional hosts from engine, hosted-engine deploy was chosen

* Hosted-engine tab not available while adding additional hosts

    * After adding the first host to the engine, a master Storage Domain needs to be configured. This is needed to initialize the Data Center. Engine will then import the Hosted-Engine storage domain and the Hosted-Engine VM. Engine needs to be aware of the Hosted-Engine storage domain to deploy Hosted Engine on additional hosts.
    * If the previous step was missed while installing additional hosts, an option is to
        * Create a Master storage domain
        * Move host to maintenance
        * Reinstall the host choosing the "Hosted Engine deploy" option from the Hosted Engine tab.


**Prev:** [Chapter: Additional Steps ](chap-Additional_Steps.html) <br/>
**Next:** [Chapter: Maintenance and Upgrading Resources ](chap-Maintenance_and_Upgrading_Resources.html)
