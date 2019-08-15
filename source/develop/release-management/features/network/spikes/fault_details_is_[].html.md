## Error of first failed test

Fault detail is "[]".


## Analysis and suggested solution

The test invokes setup-networks and immediately afterwards refresh-caps but this refresh caps hits the internal refresh-
caps invoked by engine's VdsEventListener service. This is the only test that invokes refresh_caps so this issue only 
manifests in this test.

Currently:
* for an internal invocation of refresh-caps acquire lock is tried with wait-forever
* for an external invocation of refresh-caps acquire lock is tried with no wait

A patch for moving both to a timed-wait was posted in the past but not merged (https://gerrit.ovirt.org/#/c/98257/)


## Logs

Alternating according to timestamp:

### engine.log 

VdsEventListener invokes internal refresh_caps ("Before acquiring and wait lock" -> with wait forever, see RefreshHostCommand#L20)

<pre>
2019-08-04 22:14:26,300-04 DEBUG [org.ovirt.engine.core.bll.RefreshHostCapabilitiesCommand] (ForkJoinPool-1-worker-7) [4039c3cd] Permission check skipped for internal action RefreshHostCapabilities.
2019-08-04 22:14:26,300-04 INFO  [org.ovirt.engine.core.bll.RefreshHostCapabilitiesCommand] (ForkJoinPool-1-worker-7) [4039c3cd] Before acquiring and wait lock 'EngineLock:{exclusiveLocks='[HOST_NETWORKba68128a-31b9-4305-bb3d-2dd6b96b227f=HOST_NETWORK, ba68128a-31b9-4305-bb3d-2dd6b96b227f=VDS]', sharedLocks=''}'
2019-08-04 22:14:26,300-04 DEBUG [org.ovirt.engine.core.bll.lock.InMemoryLockManager] (ForkJoinPool-1-worker-7) [4039c3cd] Before acquiring and wait lock 'EngineLock:{exclusiveLocks='[HOST_NETWORKba68128a-31b9-4305-bb3d-2dd6b96b227f=HOST_NETWORK, ba68128a-31b9-4305-bb3d-2dd6b96b227f=VDS]', sharedLocks=''}'
2019-08-04 22:14:26,300-04 DEBUG [org.ovirt.engine.core.bll.lock.InMemoryLockManager] (ForkJoinPool-1-worker-7) [4039c3cd] Success acquiring lock 'EngineLock:{exclusiveLocks='[HOST_NETWORKba68128a-31b9-4305-bb3d-2dd6b96b227f=HOST_NETWORK, ba68128a-31b9-4305-bb3d-2dd6b96b227f=VDS]', sharedLocks=''}'
2019-08-04 22:14:26,300-04 INFO  [org.ovirt.engine.core.bll.RefreshHostCapabilitiesCommand] (ForkJoinPool-1-worker-7) [4039c3cd] Lock-wait acquired to object 'EngineLock:{exclusiveLocks='[HOST_NETWORKba68128a-31b9-4305-bb3d-2dd6b96b227f=HOST_NETWORK, ba68128a-31b9-4305-bb3d-2dd6b96b227f=VDS]', sharedLocks=''}'
2019-08-04 22:14:26,308-04 DEBUG [org.ovirt.engine.core.common.di.interceptor.DebugLoggingInterceptor] (ForkJoinPool-1-worker-7) [4039c3cd] method: get, params: [ba68128a-31b9-4305-bb3d-2dd6b96b227f], timeElapsed: 7ms
2019-08-04 22:14:26,310-04 INFO  [org.ovirt.engine.core.bll.RefreshHostCapabilitiesCommand] (ForkJoinPool-1-worker-7) [4039c3cd] Running command: RefreshHostCapabilitiesCommand(RunSilent = false, VdsId = ba68128a-31b9-4305-bb3d-2dd6b96b227f) internal: true. Entities affected :  ID: ba68128a-31b9-4305-bb3d-2dd6b96b227f Type: VDSAction group MANIPULATE_HOST with role type ADMIN
2019-08-04 22:14:26,310-04 INFO  [org.ovirt.engine.core.bll.RefreshHostCapabilitiesCommand] (ForkJoinPool-1-worker-7) [4039c3cd] Before acquiring lock in order to prevent monitoring for host 'lago-network-suite-master-host-1' from data-center 'Default'
2019-08-04 22:14:26,310-04 DEBUG [org.ovirt.engine.core.bll.lock.InMemoryLockManager] (ForkJoinPool-1-worker-7) [4039c3cd] Before acquiring and wait lock 'HostEngineLock:{exclusiveLocks='[ba68128a-31b9-4305-bb3d-2dd6b96b227f=VDS_INIT]', sharedLocks=''}'
2019-08-04 22:14:26,310-04 DEBUG [org.ovirt.engine.core.bll.lock.InMemoryLockManager] (ForkJoinPool-1-worker-7) [4039c3cd] Success acquiring lock 'HostEngineLock:{exclusiveLocks='[ba68128a-31b9-4305-bb3d-2dd6b96b227f=VDS_INIT]', sharedLocks=''}'
2019-08-04 22:14:26,311-04 INFO  [org.ovirt.engine.core.bll.RefreshHostCapabilitiesCommand] (ForkJoinPool-1-worker-7) [4039c3cd] Lock acquired, from now a monitoring of host will be skipped for host 'lago-network-suite-master-host-1' from data-center 'Default'
2019-08-04 22:14:26,311-04 DEBUG [org.ovirt.engine.core.common.di.interceptor.DebugLoggingInterceptor] (ForkJoinPool-1-worker-7) [4039c3cd] method: getVdsManager, params: [ba68128a-31b9-4305-bb3d-2dd6b96b227f], timeElapsed: 0ms
2019-08-04 22:14:26,313-04 DEBUG [org.ovirt.engine.core.vdsbroker.vdsbroker.GetCapabilitiesVDSCommand] (ForkJoinPool-1-worker-7) [4039c3cd] START, GetCapabilitiesVDSCommand(HostName = lago-network-suite-master-host-1, VdsIdAndVdsVDSCommandParametersBase:{hostId='ba68128a-31b9-4305-bb3d-2dd6b96b227f', vds='Host[lago-network-suite-master-host-1,ba68128a-31b9-4305-bb3d-2dd6b96b227f]'}), log id: 1d417421
</pre>

### vdsm.log

Internal refresh-caps starts on vdsm

<pre>
2019-08-04 22:14:26,313-0400 INFO  (jsonrpc/7) [api.host] START getCapabilities() from=::ffff:192.168.201.2,47182, flow_id=4039c3cd (api:48)
</pre>

### engine.log

Test invokes external refresh-caps ("Before acquiring lock" -> with no wait, see RefreshHostCommand#L20) but fails because lock is taken

<pre>
2019-08-04 22:14:26,897-04 DEBUG [org.ovirt.engine.core.bll.lock.InMemoryLockManager] (default task-2) [5b93a451] Before acquiring lock 'EngineLock:{exclusiveLocks='[HOST_NETWORKba68128a-31b9-4305-bb3d-2dd6b96b227f=HOST_NETWORK, ba68128a-31b9-4305-bb3d-2dd6b96b227f=VDS]', sharedLocks=''}'
2019-08-04 22:14:26,897-04 DEBUG [org.ovirt.engine.core.bll.lock.InMemoryLockManager] (default task-2) [5b93a451] Failed to acquire lock. Exclusive lock is taken for key 'HOST_NETWORKba68128a-31b9-4305-bb3d-2dd6b96b227f', value 'HOST_NETWORK'
2019-08-04 22:14:26,898-04 INFO  [org.ovirt.engine.core.bll.RefreshHostCapabilitiesCommand] (default task-2) [5b93a451] Failed to Acquire Lock to object 'EngineLock:{exclusiveLocks='[HOST_NETWORKba68128a-31b9-4305-bb3d-2dd6b96b227f=HOST_NETWORK, ba68128a-31b9-4305-bb3d-2dd6b96b227f=VDS]', sharedLocks=''}'
2019-08-04 22:14:26,898-04 WARN  [org.ovirt.engine.core.bll.RefreshHostCapabilitiesCommand] (default task-2) [5b93a451] Validation of action 'RefreshHostCapabilities' failed for user admin@internal-authz. Reasons: VAR__ACTION__REFRESH,VAR__TYPE__HOST_CAPABILITIES,ACTION_TYPE_FAILED_SETUP_NETWORKS_OR_REFRESH_IN_PROGRESS
2019-08-04 22:14:26,910-04 DEBUG [org.ovirt.engine.core.bll.CommandCompensator] (default task-2) [5b93a451] Command [id=9ae3b04c-e6bc-4641-ba6b-93ae64393fba]: No compensation data.
2019-08-04 22:14:26,957-04 ERROR [org.ovirt.engine.core.bll.network.host.RefreshHostCommand] (default task-2) [5b93a451] Transaction rolled-back for command 'org.ovirt.engine.core.bll.network.host.RefreshHostCommand'.
2019-08-04 22:14:26,960-04 DEBUG [org.ovirt.engine.core.common.di.interceptor.DebugLoggingInterceptor] (default task-2) [5b93a451] method: runAction, params: [RefreshHost, VdsActionParameters:{commandId='9ae3b04c-e6bc-4641-ba6b-93ae64393fba', user='null', commandType='Unknown'}], timeElapsed: 89ms
2019-08-04 22:14:26,961-04 ERROR [org.ovirt.engine.api.restapi.resource.AbstractBackendResource] (default task-2) [] Operation Failed: []
</pre>

### vdsm.log

Internal refresh-caps terminates on vdsm

<pre>
2019-08-04 22:14:28,852-0400 INFO  (jsonrpc/7) [api.host] FINISH getCapabilities return={'status': {'message': 'Done', 'code': 0}, 'info': {u'HBAInventory': {u'iSCSI': 
2019-08-04 22:14:28,861-0400 INFO  (jsonrpc/7) [jsonrpc.JsonRpcServer] RPC call Host.getCapabilities succeeded in 2.55 seconds (__init__:312)

2019-08-04 22:14:28,889-0400 INFO  (jsonrpc/3) [api.host] START getHardwareInfo() from=::ffff:192.168.201.2,47182, flow_id=4039c3cd (api:48)
2019-08-04 22:14:28,890-0400 INFO  (jsonrpc/3) [api.host] FINISH getHardwareInfo return={'status': {'message': 'Done', 'code': 0}, 'info': {'systemProductName': u'KVM', 'systemUUID': u'FF9718A0-5B56-4705-8C2A-62B6D95BA1DE', 'systemFamily': u'Red Hat Enterprise Linux', 'systemVersion': u'RHEL 7.6.0 PC (i440FX + PIIX, 1996)', 'systemManufacturer': u'Red Hat'}} from=::ffff:192.168.201.2,47182, flow_id=4039c3cd (api:54)
2019-08-04 22:14:28,890-0400 INFO  (jsonrpc/3) [jsonrpc.JsonRpcServer] RPC call Host.getHardwareInfo succeeded in 0.00 seconds (__init__:312)

2019-08-04 22:14:29,167-0400 INFO  (jsonrpc/4) [api.network] START setupNetworks(networks={u'sync-net': {u'remove': u'true'}}, bondings={}, options={u'connectivityCheck': u'true', 
2019-08-04 22:14:34,390-0400 INFO  (jsonrpc/4) [api.network] FINISH setupNetworks return={'status': {'message': 'Done', 'code': 0}} from=::ffff:192.168.201.2,47182, flow_id=3427f12b (api:54)
2019-08-04 22:14:34,391-0400 INFO  (jsonrpc/4) [jsonrpc.JsonRpcServer] RPC call Host.setupNetworks succeeded in 5.23 seconds (__init__:312)
</pre>


 
## Test code: network-suite/test_sync_all_hosts.test_sync_across_cluster

<pre>

def test_sync_across_cluster(...):

    cluster_hosts_up = (host_0_up, host_1_up)
    with netlib.new_network('sync-net', default_data_center) as sync_net:
        with clusterlib.network_assignment(default_cluster, sync_net):
            with contextlib2.ExitStack() as stack:
                for i, host in enumerate(cluster_hosts_up):
                    att_datum = create_attachment(sync_net, i)
                    stack.enter_context(
                        hostlib.setup_networks(host, (att_datum,))
                    )
                    stack.enter_context(unsynced_host_network(host))
                default_cluster.sync_all_networks()
                for host in cluster_hosts_up:
                    host.wait_for_networks_in_sync()
       
def unsynced_host_network(host_up):
    ...
    host_up.refresh_capabilities()

</pre>


## Stack trace

<pre>

-----------------
Failed Tests:
-----------------
1 tests failed.
FAILED:  network-suite-master.tests.test_sync_all_hosts.test_sync_across_cluster

Error Message:
Error: Fault reason is "Operation Failed". Fault detail is "[]". HTTP response code is 400.

Stack Trace:
default_data_center = <ovirtlib.datacenterlib.DataCenter object at 0x7fa5eab6b3d0>
default_cluster = <ovirtlib.clusterlib.Cluster object at 0x7fa5ec632d50>
host_0_up = <ovirtlib.hostlib.Host object at 0x7fa5e8aa3690>
host_1_up = <ovirtlib.hostlib.Host object at 0x7fa5ea0fc0d0>

    def test_sync_across_cluster(default_data_center, default_cluster,
                                 host_0_up, host_1_up):

        cluster_hosts_up = (host_0_up, host_1_up)
        with netlib.new_network('sync-net', default_data_center) as sync_net:
            with clusterlib.network_assignment(default_cluster, sync_net):
                with contextlib2.ExitStack() as stack:
                    for i, host in enumerate(cluster_hosts_up):
                        att_datum = create_attachment(sync_net, i)
                        stack.enter_context(
                            hostlib.setup_networks(host, (att_datum,))
                        )
>                       stack.enter_context(unsynced_host_network(host))

network-suite-master/tests/test_sync_all_hosts.py:45:
_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
/usr/lib/python2.7/site-packages/contextlib2.py:380: in enter_context
    result = _cm_type.__enter__(cm)
/usr/lib64/python2.7/contextlib.py:17: in __enter__
    return self.gen.next()
network-suite-master/tests/test_sync_all_hosts.py:64: in unsynced_host_network
    host_up.refresh_capabilities()
network-suite-master/ovirtlib/hostlib.py:321: in refresh_capabilities
    self.service.refresh()
/usr/lib64/python2.7/site-packages/ovirtsdk4/services.py:39403: in refresh
    return self._internal_action(action, 'refresh', None, headers, query, wait)
/usr/lib64/python2.7/site-packages/ovirtsdk4/service.py:299: in _internal_action
    return future.wait() if wait else future
/usr/lib64/python2.7/site-packages/ovirtsdk4/service.py:55: in wait
    return self._code(response)
/usr/lib64/python2.7/site-packages/ovirtsdk4/service.py:296: in callback
    self._check_fault(response)
/usr/lib64/python2.7/site-packages/ovirtsdk4/service.py:134: in _check_fault
    self._raise_error(response, body.fault)
_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _

response = <ovirtsdk4.http.Response object at 0x7fa5e2dc3290>
detail = <ovirtsdk4.types.Fault object at 0x7fa5e2dc3050>

    @staticmethod
    def _raise_error(response, detail=None):
        """
            Creates and raises an error containing the details of the given HTTP
            response and fault.

            This method is intended for internal use by other components of the
            SDK. Refrain from using it directly, as backwards compatibility isn't
            guaranteed.
            """
        fault = detail if isinstance(detail, types.Fault) else None

        msg = ''
        if fault:
            if fault.reason:
                if msg:
                    msg += ' '
                msg = msg + 'Fault reason is "%s".' % fault.reason
            if fault.detail:
                if msg:
                    msg += ' '
                msg = msg + 'Fault detail is "%s".' % fault.detail
        if response:
            if response.code:
                if msg:
                    msg += ' '
                msg = msg + 'HTTP response code is %s.' % response.code
            if response.message:
                if msg:
                    msg += ' '
                msg = msg + 'HTTP response message is "%s".' % response.message

        if isinstance(detail, six.string_types):
            if msg:
                msg += ' '
            msg = msg + detail + '.'

        class_ = Error
        if response is not None:
            if response.code in [401, 403]:
                class_ = AuthError
            elif response.code == 404:
                class_ = NotFoundError

        error = class_(msg)
        error.code = response.code if response else None
        error.fault = fault
>       raise error
E       Error: Fault reason is "Operation Failed". Fault detail is "[]". HTTP response code is 400.

/usr/lib64/python2.7/site-packages/ovirtsdk4/service.py:118: Error
</pre>
