# Inconsistent but repeated failures are happening on OST 4.3 and master


### Discussion

Until now the policy for handling network requests in engine was:
1. REST API requests are handled async unless the underlying commands report their Vdsm Tasks.
2. <code>PersistentHostSetupNetworksCommand</code> flows are run async internally in the server.
3. an external network action is revoked if the server is busy (lock taken)
4. an internal refresh host action waits for a lock forever

Policy (3) guarantees execution of requests in the order that they were issued - whether from a single client or from
multiple clients. It also did not fail the 'human admin' usage model where a person can retry the request and check for
its successful completion.
However it does not perform well in a testing environment where revocations of requests due to 'busy server' fail the
suite frequently.


An alternate server policy for test suites must fulfill the following requirements:
1. execution of requests in the same order that they were requested by a single client
2. the server cannot be respond as 'busy' - it must queue external requests if it cannot serve them

To fulfill requirement (1) it is necessary to make the REST API requests return synchronously with the completion of their
operations.

To fulfill requirement (2) a timed-wait for setup-networks was introduced to master. It helped reduce the failures on master
considerably.
The current failures on master all are around a similar situation with an external refresh-caps being revoked on 'server
busy'. This situation might be resolved with a timed-wait for refresh-caps (https://gerrit.ovirt.org/#/c/98257).


### OST Failures on branch 4.3

  * 145 Fault detail is "[]"
  * 162 Fault detail is "[]"
  * 150 another setup in progress
  * 151
    * Cannot add network רשת עם שם ארוך מאוד to network interface eth1. Network interface has an unmanaged network attached.
    * Cannot add network mig-net to network interface eth1. Network interface has an unmanaged network attached.
    * Illegal Network parameters
    * Illegal Network parameters
    * Illegal Network parameters
  * 152 another setup in progress
  * 159 another setup in progress
  * 161 another setup in progress
  * 154 cannot activate host. related op in progress
  * 157
    * Cannot edit Interface. Updating some of the properties is not supported while the interface is plugged into a running
      virtual machine.
    * another setup in progress
  * 169, 172
    * setup networks in progress 
    * 3 tests (ovn) failed with Illegal Network parameters
  * 173
    * test teardown failure (change_cluster)
    * test setup failure (setup_networks)
    * general command validation failure (setup_networks)


### OST Failures on branch master

  * 1067 Fault detail is "[]"
  * 1071 Fault detail is "[]"
  * 1080 Fault detail is "[]"
  * 1092 cannot activate host. related op in progress
  * 1095 
  

### QE test suite failures

 * colliding setup-networks with commit-network-changes on vdsm
 

### Explained Failures

 * another setup in progress
   * reason: timed wait for setup networks not backported to 4.3
 * test_sync_across_cluster: Fault detail is "[]"
   * reason: refresh host failed because refresh caps could not get lock
 * test_required_network: cannot activate host. related op in progress
   * reason: refresh caps in progress
 * colliding setup-networks with commit-network-changes on vdsm
   * reason: different lock policy in engine and in vdsm for these actions


### Unexplained Failures (TODO)

 * test_unrestricted_display_network_name: cannot add network. Network interface has an unmanaged network attached
   * reason: a remove network attachment was not executed on one of the hosts
 * test_move_mac_to_new_vm: test teardown failure.
   * reason: change_cluster failed during teardown
   
   

