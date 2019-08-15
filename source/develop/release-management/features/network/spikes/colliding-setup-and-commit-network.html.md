---
title: Colliding 'setup networks' and 'commit network changes'
category: investigation
authors: erav
---

# Colliding 'setup networks' and 'commit network changes' operations

## Problem description

Vdsm does not allow <code>Host.setupNetworks</code> and <code>Host.setSafeNetworkConfig</code> to run in parallel but 
engine does not enforce this constraint. Engine executes a persistent-setup-networks operation 
(<code>PersistentHostSetupNetworksCommand</code>) in two phases:
* executes setup-networks (<code>HostSetupNeworkCommand</code>) and then get-caps (<code>RefreshHostCapabilitiesCommand</code>)
  as a sinlge atomic operation
* once the first phase completes successfully it runs commit-network-changes (<code>CommitNetworkChangesCommand</code>)
  non-atomically.

The sequential synced execution guarantees no collision will occur on vdsm between the two phases of a single invocation,
but it does not guarantee collision avoidance with another similar action in the following cases:

* another similar action is instantiated from a different client for the same host.
* another similar action is instantiated from the same client for the same host, before the first action has terminated.
  So a first invocation might still be busy with a <code>Host.setSafeNetworkConfig</code> when a second invocation invokes
  <code>Host.setupNetworks</code>. The latter <code>Host.setupNetworks</code> would then be revoked by vdsm. 
  This behaviour is documented in [1] where the collision occurred during sync host networks with the following scenario:

	01. request A: client issues setup networks
	02. request A: restapi accepts request, forwards it to bll and returns response to client
	03. request A: bll acquires setup networks lock
	04. request A: bll issues setup networks request to vdsm
	05. request A: vdsm acquires semaphore, executes setup networks, releases semaphore and returns response to engine
	06. request A: bll releases setup networks lock
	07. request B: same as step 01
	08. request B: same as step 02
	09. request B: same as step 03
	10. request A: bll issues commit-network-changes request to vdsm
	11. request A: vdsm acquires semaphore and executes commit-network-changes
	12. request B: same as step 04
	13. request B: ==> vdsm revokes the setup networks request because the semaphore is busy (step 11)
  
  Sync-host-networks invokes a single setup-networks and a single commit-network-changes wrapped by a single persistent-
  setup-networks operation. This means that the only way the collision could have happened is if another rest-api call was
  executing at the same time.
  This is possible because of the asynchronous logic invoked in the restapi code [2]: a REST API request
  which involves persistent-setup-networks is returned to the caller without waiting for bll commands to execute. 
  This is true even if the rest-api call specifies the action should be performed <code>async=false </code> because the
  internal bll commands do not carry any vdsm tasks and are run async themselves.

  [1] https://bugzilla.redhat.com/show_bug.cgi?id=1723804
  [2] https://github.com/oVirt/ovirt-engine/blob/master/.../AbstractBackendActionableResource.java#L84


## Requirements for solutions

Any proposed solution must guarantee the following requirements:
  1. a happens-before relation between a setup and its related commit: a commit can only happen after its related setup
     completed
  2. a happens-before relation between a setup+commit and any other setup+commit
  3. no collision on vdsm between a setup and a commit (guaranteed because of the above two requirements)
  4. no collision on vdsm between two setups (already guaranteed by engine-side setup-networks locking)
  5. no collision on vdsm between two commits
  6. execution of setup+commit requests in the same order that they were requested by a single client
  7. execution of setup+commit requests in the same order that they were requested by a different clients


## Selected solution - mute commit-network-config invocations for cluster level >=4.4

* Benefits:
  * satisfies all the requirements 1-7
  * low risk
  * easy to implement
* Drawbacks:
  * will not affect cluster-level < 4.4

### Planned behaviour 

* Do not invoke commit-network-changes phase of persistent-setup-networks for cluster level >=4.4
* Set commit-on-success to true inside engine for add\update\install host flows (see below)
  * need to check that the setup-networks is done after cluster-level has been verified.
* https://bugzilla.redhat.com/show_bug.cgi?id=1657647 must be fixed in same version?

### Analysis

* current commit-network-changes usages:

  01. add\update\install host
  02. directly from save-network functionality (web-admin button or rest-api call)
  03. all persistent-setup-networks flows (these flows invoke setup-networks and get-caps under the same lock, 
      and then commit-network-changes):
      * change host cluster
      * update\remove host network QoS
      * add\update\remove host network
      * sync all host networks
      * attach\detach network to cluster
      * manage logical networks
      
* commit-on-success usage (when supported):
  * set to true in all persistent-setup-networks flows - so net-config-dirty returns false and commit-network-changes is
    redundant
  * cannot be relied on for initial vds install because vdsm version is not yet known. 
  * is ignored when not supported (no error)
  
* Flow analysis for all persistent-setup-networks flows:

   * Flow identified in the bug [1]:
     01. persistent-setup-networks is triggered
     02. first phase of setup-networks + get-caps runs and completes. on version >=4.3 the net-config-dirty flag is now
         false because engine requested commit-on-success
     03. another similar request from same or other client triggers (on a separate thread in engine)
	     another persistent-setup-networks
	 04. the first persistent-setup-networks triggers its second phase of commit-network-changes at the same time the
	     second one triggers its first phase setup-networks on vdsm and they collide.
	      
   * Another possible flow:
     01. persistent-setup-networks is triggered
     02. first phase of setup-networks + get-caps runs and completes. on version >=4.3 the net-config-dirty flag is now
         false because engine requested commit-on-success
     03. another network config change happens on the host
     04. an internal periodic get-caps or get-stats is triggered in engine, identifies the above change and sets net-config
         -dirty to true
     05. commit-network-changes is triggered by initial persistent-setup-networks because net-config-dirty is now true
     If the last step is removed, the state of the host will remain unpersisted on both the host and engine DB.
    
* Regression analysis and conclusion: 
  * it is safe to assume that each commit-network-change should commit the changes of its related operation and not the
    changes of other operations. 
  * when commit-on-success is set to true, it is possible to forgo the commit-network-changes phase in all flows without
    any anticipated regression.
  * in versions where commit-on-success is not supported, the flow will remain as is, so no anticipated regression.
  * if the internal periodic get-caps\get-stats finds an unpersisted config state on vdsm for some state, this will be
    reflected in the 'save-network-config' becoming available so this situation can be remedied manually.
    
    
## Other possible solutions that have been suggested but not pursued

01. Make <code>HostSetupNeworkCommand</code> pass its lock to <code>CommitNetworkChangesCommand</code> once it completes.
  * Benefits:
    * Satisfies requirements: 1-5
    * Operations remain independent and don't require a single atomic wrapper
    * The 'save network changes' action from UI\REST can continue to exist as a separate action
  * Drawbacks:
    * Does not satisfy requirements 6, 7
    * Requires adding a 'pass lock' functionality to the network commands, <code>CommandBase</code> and the locking infra-
      structure
    * The 'pass lock' functionality needs to be available both to the setup lock and the monitoring lock.


02. Wrap <code>HostSetupNeworkCommand</code> and <code>CommitNetworkChangesCommand</code> inside a single lock acquisition,
    making their execution a single atomic operation. This is similar conceptually to (1) but differs in the implementation
    details.
  * Benefits:
    * Satisfies requirements: 1-5
  * Drawbacks:
    * Does not satisfy requirements 6, 7
    * This change involves deep modification of the code in the setup-networks and refresh-caps flows and in 
      <code>CommandBase</code> because acquiring the setup networks lock and the monitor lock would have to be moved from
      individual commands to their parent commands so that multiple commands can be executed under the same lock.
  
  
03. Make the REST API calls behave synchronously and wait on the actual completion of all sub tasks on the server before 
   returning to the caller.
  * Benefits:
    * Satisfies requirements: 1-6
    * Satisfies requirement 7 for same-client invocation
    * REST API calls specify async=false by default but actually do behave async in above flows. This would rectify this
      misleading contradiction which is actually a bug.
    * If solution is implemented just in <code>PersistentHostSetupNetworksCommand</code> flows, it does not affect other
      engine flows.
  * Drawbacks:
    * Does not satisfy requirement 7 for multi-client invocations
    * If solution is implemented in the REST API infra code it influences all engine flows which is a risk and might break
      existing usages. According to engine Infra team, there was once an RFE to accomplish this but it was not implemented
      because of a technical issue. An email thread is under way now to find out about it.
    * If solution is implemented just in <code>PersistentHostSetupNetworksCommand</code> flows, its scope and effort is
      currently not known (need to register and report VDS tasks). 

## Preferred Solution

The selected solution of muting commit-network-changes is the easiest and least risky to implement. From the others only
the last satisfies the most amount of requirements for OST usage so it is the next best favorite.
