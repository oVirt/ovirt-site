## Error of first failed test

Cannot activate Host. Related operation is currently in progress. Please try again later.

## Analysis and suggested solution

The test removes a network which has been attached to a NIC on a host during the setup. This invokes a setup-network
operation which prevented the internal refresh-caps from acquiring the VDS lock. When it finally succeeded it prevented
the activate host action from acquiring the VDS lock which failed the test.

Possible solution is to make ActivateVds wait for the VDS lock with a timeout.


## Logs

### engine.log

* Internal refresh-caps invoked by VdsEventListener but failed to acquire HOST_NETWORK lock for ~2sec

<pre>
2019-08-02 23:40:43,499-04 DEBUG [org.ovirt.vdsm.jsonrpc.client.internal.ResponseWorker] (ResponseWorker) [] Event arrived from 192.168.201.2 containing {"notify_time":4297129460}
2019-08-02 23:40:43,502-04 DEBUG [org.ovirt.engine.core.common.di.interceptor.DebugLoggingInterceptor] (ForkJoinPool-1-worker-5) [] method: getEventListener, params: [], timeElapsed: 0ms
2019-08-02 23:40:43,507-04 DEBUG [org.ovirt.engine.core.bll.RefreshHostCapabilitiesCommand] (ForkJoinPool-1-worker-5) [bd6206a] Permission check skipped for internal action RefreshHostCapabilities.
2019-08-02 23:40:43,507-04 INFO  [org.ovirt.engine.core.bll.RefreshHostCapabilitiesCommand] (ForkJoinPool-1-worker-5) [bd6206a] Before acquiring and wait lock 'EngineLock:{exclusiveLocks='[0702b222-f6c9-4035-903b-3ab57cd62dd6=VDS, HOST_NETWORK0702b222-f6c9-4035-903b-3ab57cd62dd6=HOST_NETWORK]', sharedLocks=''}'
2019-08-02 23:40:43,507-04 DEBUG [org.ovirt.engine.core.bll.lock.InMemoryLockManager] (ForkJoinPool-1-worker-5) [bd6206a] Before acquiring and wait lock 'EngineLock:{exclusiveLocks='[0702b222-f6c9-4035-903b-3ab57cd62dd6=VDS, HOST_NETWORK0702b222-f6c9-4035-903b-3ab57cd62dd6=HOST_NETWORK]', sharedLocks=''}'
2019-08-02 23:40:43,507-04 DEBUG [org.ovirt.engine.core.bll.lock.InMemoryLockManager] (ForkJoinPool-1-worker-5) [bd6206a] Failed to acquire lock. Exclusive lock is taken for key 'HOST_NETWORK0702b222-f6c9-4035-903b-3ab57cd62dd6', value 'HOST_NETWORK'
</pre>

* ...then succeeded and acquired both VDS and HOST_NETWORK locks (and monitor lock) and started executing

<pre>
2019-08-02 23:40:45,009-04 INFO  [org.ovirt.engine.core.bll.RefreshHostCapabilitiesCommand] (ForkJoinPool-1-worker-5) [bd6206a] Lock-wait acquired to object 'EngineLock:{exclusiveLocks='[0702b222-f6c9-4035-903b-3ab57cd62dd6=VDS, HOST_NETWORK0702b222-f6c9-4035-903b-3ab57cd62dd6=HOST_NETWORK]', sharedLocks=''}'
2019-08-02 23:40:45,018-04 DEBUG [org.ovirt.engine.core.common.di.interceptor.DebugLoggingInterceptor] (ForkJoinPool-1-worker-5) [bd6206a] method: get, params: [0702b222-f6c9-4035-903b-3ab57cd62dd6], timeElapsed: 9ms
2019-08-02 23:40:45,022-04 INFO  [org.ovirt.engine.core.bll.RefreshHostCapabilitiesCommand] (ForkJoinPool-1-worker-5) [bd6206a] Running command: RefreshHostCapabilitiesCommand(VdsId = 0702b222-f6c9-4035-903b-3ab57cd62dd6, RunSilent = false) internal: true. Entities affected :  ID: 0702b222-f6c9-4035-903b-3ab57cd62dd6 Type: VDSAction group MANIPULATE_HOST with role type ADMIN
2019-08-02 23:40:45,022-04 INFO  [org.ovirt.engine.core.bll.RefreshHostCapabilitiesCommand] (ForkJoinPool-1-worker-5) [bd6206a] Running command: RefreshHostCapabilitiesCommand(VdsId = 0702b222-f6c9-4035-903b-3ab57cd62dd6, RunSilent = false) internal: true. Entities affected :  ID: 0702b222-f6c9-4035-903b-3ab57cd62dd6 Type: VDSAction group MANIPULATE_HOST with role type ADMIN
2019-08-02 23:40:45,022-04 INFO  [org.ovirt.engine.core.bll.RefreshHostCapabilitiesCommand] (ForkJoinPool-1-worker-5) [bd6206a] Before acquiring lock in order to prevent monitoring for host 'lago-network-suite-4-3-host-1' from data-center 'Default'
2019-08-02 23:40:45,023-04 DEBUG [org.ovirt.engine.core.bll.lock.InMemoryLockManager] (ForkJoinPool-1-worker-5) [bd6206a] Before acquiring and wait lock 'HostEngineLock:{exclusiveLocks='[0702b222-f6c9-4035-903b-3ab57cd62dd6=VDS_INIT]', sharedLocks=''}'
2019-08-02 23:40:45,023-04 DEBUG [org.ovirt.engine.core.bll.lock.InMemoryLockManager] (ForkJoinPool-1-worker-5) [bd6206a] Success acquiring lock 'HostEngineLock:{exclusiveLocks='[0702b222-f6c9-4035-903b-3ab57cd62dd6=VDS_INIT]', sharedLocks=''}'
2019-08-02 23:40:45,023-04 INFO  [org.ovirt.engine.core.bll.RefreshHostCapabilitiesCommand] (ForkJoinPool-1-worker-5) [bd6206a] Lock acquired, from now a monitoring of host will be skipped for host 'lago-network-suite-4-3-host-1' from data-center 'Default'
2019-08-02 23:40:45,023-04 DEBUG [org.ovirt.engine.core.common.di.interceptor.DebugLoggingInterceptor] (ForkJoinPool-1-worker-5) [bd6206a] method: getVdsManager, params: [0702b222-f6c9-4035-903b-3ab57cd62dd6], timeElapsed: 0ms
2019-08-02 23:40:45,026-04 DEBUG [org.ovirt.engine.core.vdsbroker.vdsbroker.GetCapabilitiesVDSCommand] (ForkJoinPool-1-worker-5) [bd6206a] START, GetCapabilitiesVDSCommand(HostName = lago-network-suite-4-3-host-1, VdsIdAndVdsVDSCommandParametersBase:{hostId='0702b222-f6c9-4035-903b-3ab57cd62dd6', vds='Host[lago-network-suite-4-3-host-1,0702b222-f6c9-4035-903b-3ab57cd62dd6]'}), log id: 184bca19
</pre>

* Activate Vds invoked from test but failed to acquire VDS lock so was revoked

<pre>
2019-08-02 23:40:45,153-04 DEBUG [org.ovirt.engine.core.bll.Backend] (default task-1) [] Executing command ActivateVds for user admin@internal-authz.
2019-08-02 23:40:45,166-04 DEBUG [org.ovirt.engine.core.bll.ActivateVdsCommand] (default task-1) [a7b956d3-3c24-4e58-a32f-b003ec8a2124] Checking whether user 'ce08b410-b59b-11e9-a994-5452c0a8c904' or one of the groups he is member of, have the following permissions:  ID: 0702b222-f6c9-4035-903b-3ab57cd62dd6 Type: VDSAction group MANIPULATE_HOST with role type ADMIN
2019-08-02 23:40:45,167-04 DEBUG [org.ovirt.engine.core.bll.ActivateVdsCommand] (default task-1) [a7b956d3-3c24-4e58-a32f-b003ec8a2124] Found permission 'ce08d3aa-b59b-11e9-a995-5452c0a8c904' for user when running 'ActivateVds', on 'Host' with id '0702b222-f6c9-4035-903b-3ab57cd62dd6'
2019-08-02 23:40:45,167-04 DEBUG [org.ovirt.engine.core.bll.lock.InMemoryLockManager] (default task-1) [a7b956d3-3c24-4e58-a32f-b003ec8a2124] Before acquiring lock 'EngineLock:{exclusiveLocks='[0702b222-f6c9-4035-903b-3ab57cd62dd6=VDS]', sharedLocks=''}'
2019-08-02 23:40:45,167-04 DEBUG [org.ovirt.engine.core.bll.lock.InMemoryLockManager] (default task-1) [a7b956d3-3c24-4e58-a32f-b003ec8a2124] Failed to acquire lock. Exclusive lock is taken for key '0702b222-f6c9-4035-903b-3ab57cd62dd6', value 'VDS'
2019-08-02 23:40:45,168-04 INFO  [org.ovirt.engine.core.bll.ActivateVdsCommand] (default task-1) [a7b956d3-3c24-4e58-a32f-b003ec8a2124] Failed to Acquire Lock to object 'EngineLock:{exclusiveLocks='[0702b222-f6c9-4035-903b-3ab57cd62dd6=VDS]', sharedLocks=''}'
2019-08-02 23:40:45,168-04 WARN  [org.ovirt.engine.core.bll.ActivateVdsCommand] (default task-1) [a7b956d3-3c24-4e58-a32f-b003ec8a2124] Validation of action 'ActivateVds' failed for user admin@internal-authz. Reasons: VAR__ACTION__ACTIVATE,VAR__TYPE__HOST,ACTION_TYPE_FAILED_OBJECT_LOCKED
2019-08-02 23:40:45,173-04 DEBUG [org.ovirt.engine.core.common.di.interceptor.DebugLoggingInterceptor] (default task-1) [a7b956d3-3c24-4e58-a32f-b003ec8a2124] method: runAction, params: [ActivateVds, VdsActionParameters:{commandId='6c69d350-bfd1-46ee-82be-fd34692c606f', user='null', commandType='Unknown'}], timeElapsed: 21ms
2019-08-02 23:40:45,174-04 ERROR [org.ovirt.engine.api.restapi.resource.AbstractBackendResource] (default task-1) [] Operation Failed: [Cannot activate Host. Related operation is currently in progress. Please try again later.]
</pre>

* External refresh-caps terminated

<pre>
2019-08-02 23:40:47,178-04 DEBUG [org.ovirt.engine.core.vdsbroker.vdsbroker.GetCapabilitiesVDSCommand] (ForkJoinPool-1-worker-5) [bd6206a] FINISH, GetCapabilitiesVDSCommand, return: Host[lago-network-suite-4-3-host-1,0702b222-f6c9-4035-903b-3ab57cd62dd6], log id: 184bca19
2019-08-02 23:40:47,178-04 DEBUG [org.ovirt.engine.core.common.di.interceptor.DebugLoggingInterceptor] (ForkJoinPool-1-worker-5) [bd6206a] method: runVdsCommand, params: [GetCapabilities, VdsIdAndVdsVDSCommandParametersBase:{hostId='0702b222-f6c9-4035-903b-3ab57cd62dd6', vds='Host[lago-network-suite-4-3-host-1,0702b222-f6c9-4035-903b-3ab57cd62dd6]'}], timeElapsed: 2155ms
2019-08-02 23:40:47,180-04 INFO  [org.ovirt.engine.core.vdsbroker.vdsbroker.GetHardwareInfoAsyncVDSCommand] (ForkJoinPool-1-worker-5) [bd6206a] START, GetHardwareInfoAsyncVDSCommand(HostName = lago-network-suite-4-3-host-1, VdsIdAndVdsVDSCommandParametersBase:{hostId='0702b222-f6c9-4035-903b-3ab57cd62dd6', vds='Host[lago-network-suite-4-3-host-1,0702b222-f6c9-4035-903b-3ab57cd62dd6]'}), log id: 20746c12
2019-08-02 23:40:47,181-04 DEBUG [org.ovirt.vdsm.jsonrpc.client.reactors.stomp.impl.Message] (ForkJoinPool-1-worker-5) [bd6206a] SEND
</pre>


## Test code: network-suite/test_required_network.test_required_network_host_non_operational

<pre>
def test_required_network_host_non_operational(req_net,
                                               cluster_net,
                                               optionally_non_spm_host):
    cluster_net.update(required=True)
    optionally_non_spm_host.remove_networks((req_net,))
    optionally_non_spm_host.wait_for_non_operational_status()
    cluster_net.update(required=False)
    optionally_non_spm_host.activate()
    optionally_non_spm_host.wait_for_up_status()
</pre>


## Stacktrace

<pre>

----------------
Failed Tests:
-----------------
1 tests failed.
FAILED:  network-suite-4.3.tests.test_required_network.test_required_network_host_non_operational

Error Message:
Error: Fault reason is "Operation Failed". Fault detail is "[Cannot activate Host. Related operation is currently in progress. Please try again later.]". HTTP response code is 409.

Stack Trace:
req_net = <ovirtlib.netlib.Network object at 0x7fb514e58450>
cluster_net = <ovirtlib.clusterlib.ClusterNetwork object at 0x7fb514e58c90>
optionally_non_spm_host = <ovirtlib.hostlib.Host object at 0x7fb5162b53d0>

    def test_required_network_host_non_operational(req_net,
                                                   cluster_net,
                                                   optionally_non_spm_host):
        cluster_net.update(required=True)
        optionally_non_spm_host.remove_networks((req_net,))
        optionally_non_spm_host.wait_for_non_operational_status()
        cluster_net.update(required=False)
>       optionally_non_spm_host.activate()

network-suite-4.3/tests/test_required_network.py:103:
_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
network-suite-4.3/ovirtlib/hostlib.py:110: in activate
    self._service.activate()
/usr/lib64/python2.7/site-packages/ovirtsdk4/services.py:38763: in activate
    return self._internal_action(action, 'activate', None, headers, query, wait)
/usr/lib64/python2.7/site-packages/ovirtsdk4/service.py:299: in _internal_action
    return future.wait() if wait else future
/usr/lib64/python2.7/site-packages/ovirtsdk4/service.py:55: in wait
    return self._code(response)
/usr/lib64/python2.7/site-packages/ovirtsdk4/service.py:296: in callback
    self._check_fault(response)
/usr/lib64/python2.7/site-packages/ovirtsdk4/service.py:134: in _check_fault
    self._raise_error(response, body.fault)
_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _

response = <ovirtsdk4.http.Response object at 0x7fb5162b5050>
detail = <ovirtsdk4.types.Fault object at 0x7fb5162b5550>

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
E       Error: Fault reason is "Operation Failed". Fault detail is "[Cannot activate Host. Related operation is currently in progress. Please try again later.]". HTTP response code is 409.

/usr/lib64/python2.7/site-packages/ovirtsdk4/service.py:118: Error

</pre>
