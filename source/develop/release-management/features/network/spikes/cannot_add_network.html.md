## Error of first failed test

Cannot add network רשת עם שם ארוך מאוד to network interface eth1. Network interface has an unmanaged network attached.

## Analysis

* 'req-net' from test_required_network.test_required_network_host_non_operational is removed from host-1 but removal not
even attempted on host-0. Then when network is removed from DC, an unmanaged network is left on host-0/eth1.
* vdsm.log and supervdsm.log terminate ~2sec before engine.log terminates



## Logs

### engine.log

* 'req-net' is reported by get-caps on 23:28:09 - long after the test_required_network and the test following it
(test_sync_across_cluster) have ended

<pre>

2019-07-30 23:26:26,312-04 INFO  [org.ovirt.engine.core.dal.dbbroker.auditloghandling.AuditLogDirector] (default task-2) [f764c94a-85f7-4aa7-b942-49e21af39ea6] EVENT_ID: EXTERNAL_EVENT_NORMAL(9,801), OST invoked: network-suite-4.3/tests/test_required_network.py::test_required_network_host_non_operational
2019-07-30 23:26:35,165-04 INFO  [org.ovirt.engine.core.vdsbroker.SetVdsStatusVDSCommand] (default task-2) [304b1a38] START, SetVdsStatusVDSCommand(HostName = lago-network-suite-4-3-host-1, SetVdsStatusVDSCommandParameters:{hostId='3553b88c-c34f-450d-ab41-423a7c2898e3', status='NonOperational', nonOperationalReason='NETWORK_UNREACHABLE', stopSpmFailureLogged='false', maintenanceReason='null'}), log id: 307e67dc
2019-07-30 23:26:35,269-04 WARN  [org.ovirt.engine.core.dal.dbbroker.auditloghandling.AuditLogDirector] (default task-2) [304b1a38] EVENT_ID: VDS_SET_NONOPERATIONAL_NETWORK(519), Host lago-network-suite-4-3-host-1 does not comply with the cluster Default networks, the following networks are missing on host: 'req-net'

2019-07-30 23:26:43,771-04 DEBUG [org.ovirt.engine.core.common.di.interceptor.DebugLoggingInterceptor] (default task-2) [5e3fc7e0-d999-492f-8f98-e3b93274eeec] method: runAction, params: [HostSetupNetworks, HostSetupNetworksParameters:{commandId='9a7bba4d-5269-4b51-ae57-3ffd9d2c2951', user='null', commandType='Unknown'}], timeElapsed: 52ms
2019-07-30 23:26:43,773-04 ERROR [org.ovirt.engine.api.restapi.resource.AbstractBackendResource] (default task-2) [] Operation Failed: [Cannot setup Networks. Another Setup Networks or Host Refresh process in progress on the host. Please try later.]
2019-07-30 23:26:44,017-04 INFO  [org.ovirt.engine.core.bll.network.host.HostSetupNetworksCommand] (default task-2) [a4c7663f-dd65-45c4-aaff-4b73f9fe5fa2] No changes were detected in setup networks for host 'lago-network-suite-4-3-host-1' (ID: '3553b88c-c34f-450d-ab41-423a7c2898e3')
2019-07-30 23:26:44,127-04 INFO  [org.ovirt.engine.core.bll.network.cluster.DetachNetworkFromClusterInternalCommand] (default task-2) [0bc4b9b3-8c76-4fcd-8937-f73c9308f389] Running command: DetachNetworkFromClusterInternalCommand(Network = Network:{id='485b8a1f-1453-4400-8b9d-496b2492c4d9', description='', comment='', vdsmName='req-net', subnet='null', gateway='null', type='null', vlanId='null', stp='false', dataCenterId='c9336034-b33e-11e9-b8d9-5452c0a8c904', mtu='0', vmNetwork='false', cluster='NetworkCluster:{id='NetworkClusterId:{clusterId='null', networkId='null'}', status='OPERATIONAL', display='false', required='false', migration='false', management='false', gluster='false', defaultRoute='false'}', providedBy='null', label='null', qosId='null', dnsResolverConfiguration='null'}, NetworkCluster = NetworkCluster:{id='NetworkClusterId:{clusterId='c935ee4e-b33e-11e9-888f-5452c0a8c904', networkId='485b8a1f-1453-4400-8b9d-496b2492c4d9'}', status='NON_OPERATIONAL', display='false', required='false', migration='false', management='false', gluster='false', defaultRoute='false'}, ClusterId = c935ee4e-b33e-11e9-888f-5452c0a8c904) internal: true. Entities affected :  ID: c935ee4e-b33e-11e9-888f-5452c0a8c904 Type: Cluster
2019-07-30 23:26:44,170-04 INFO  [org.ovirt.engine.core.dal.dbbroker.auditloghandling.AuditLogDirector] (default task-2) [0bc4b9b3-8c76-4fcd-8937-f73c9308f389] EVENT_ID: NETWORK_DETACH_NETWORK_TO_CLUSTER(948), Network <UNKNOWN> detached from Cluster Default
2019-07-30 23:26:44,172-04 DEBUG [org.ovirt.engine.core.common.di.interceptor.DebugLoggingInterceptor] (default task-2) [0bc4b9b3-8c76-4fcd-8937-f73c9308f389] method: runAction, params: [DetachNetworkToCluster, AttachNetworkToClusterParameter:{commandId='8b72f257-2837-4149-b62c-94630b2a4808', user='null', commandType='Unknown'}], timeElapsed: 118ms
2019-07-30 23:26:44,193-04 DEBUG [org.ovirt.engine.core.bll.Backend] (default task-2) [] Executing command RemoveNetwork for user admin@internal-authz.
2019-07-30 23:26:44,266-04 INFO  [org.ovirt.engine.core.bll.network.dc.RemoveNetworkCommand] (default task-2) [e942f3c4-3e3c-49c4-87e0-bbb708176354] Running command: RemoveNetworkCommand(RemoveFromNetworkProvider = false, Id = 485b8a1f-1453-4400-8b9d-496b2492c4d9) internal: false. Entities affected :  ID: 485b8a1f-1453-4400-8b9d-496b2492c4d9 Type: NetworkAction group CONFIGURE_STORAGE_POOL_NETWORK with role type ADMIN
2019-07-30 23:26:44,313-04 INFO  [org.ovirt.engine.core.dal.dbbroker.auditloghandling.AuditLogDirector] (default task-2) [e942f3c4-3e3c-49c4-87e0-bbb708176354] EVENT_ID: NETWORK_REMOVE_NETWORK(944), Network req-net was removed from Data Center: Default
2019-07-30 23:26:44,314-04 DEBUG [org.ovirt.engine.core.common.di.interceptor.DebugLoggingInterceptor] (default task-2) [e942f3c4-3e3c-49c4-87e0-bbb708176354] method: runAction, params: [RemoveNetwork, RemoveNetworkParameters:{commandId='9cef90fa-25fd-4e9e-98f0-91eaa418b962', user='null', commandType='Unknown'}], timeElapsed: 122ms

2019-07-30 23:26:49,877-04 INFO  [org.ovirt.engine.core.dal.dbbroker.auditloghandling.AuditLogDirector] (default task-2) [eeb484fa-95f3-4fbf-8e58-d5963d79c886] EVENT_ID: EXTERNAL_EVENT_NORMAL(9,801), OST invoked: network-suite-4.3/tests/test_sync_all_hosts.py::test_sync_across_cluster

2019-07-30 23:28:09,603-04 DEBUG [org.ovirt.vdsm.jsonrpc.client.internal.ResponseWorker] (ResponseWorker) [] Message received: {"jsonrpc": "2.0", "id": 
....
"req-net": {"iface": "eth1", "ipv6autoconf": false, "addr": "192.0.3.2", "dhcpv6": false, "ipv6addrs": [], "switch": "legacy", "bridged": false, "mtu": "1500", "dhcpv4": false, "netmask": "255.255.255.0", "ipv4defaultroute": false, "ipv4addrs": ["192.0.3.2/24"], "interface": "eth1", "southbound": "eth1", "ipv6gateway": "::", "gateway": ""}}
....
}

2019-07-30 23:28:19,164-04 WARN  [org.ovirt.engine.core.bll.network.host.HostSetupNetworksCommand] (default task-1) [96abdfe9-ce8c-48a3-b48c-27777662275e] Validation of action 'HostSetupNetworks' failed for user admin@internal-authz. Reasons: VAR__ACTION__SETUP,VAR__TYPE__NETWORKS,ACTION_TYPE_FAILED_HOST_NETWORK_ATTACHEMENT_ON_UNMANAGED_NETWORK,$network רשת עם שם ארוך מאוד,$nic eth1
2019-07-30 23:28:19,172-04 ERROR [org.ovirt.engine.api.restapi.resource.AbstractBackendResource] (default task-1) [] Operation Failed: [Cannot add network רשת עם שם ארוך מאוד to network interface eth1. Network interface has an unmanaged network attached.]
2019-07-30 23:28:20,512-04 INFO  [org.ovirt.engine.core.bll.network.dc.RemoveNetworkCommand] (default task-1) [6be1d9cc-f4c2-43d0-9d58-0c444bb5020d] Running command: RemoveNetworkCommand(RemoveFromNetworkProvider = false, Id = 5a3ae1e6-6075-4c5a-ad24-12ae195b4be7) internal: false. Entities affected :  ID: 5a3ae1e6-6075-4c5a-ad24-12ae195b4be7 Type: NetworkAction group CONFIGURE_STORAGE_POOL_NETWORK with role type ADMIN
2019-07-30 23:28:20,538-04 INFO  [org.ovirt.engine.core.dal.dbbroker.auditloghandling.AuditLogDirector] (default task-1) [6be1d9cc-f4c2-43d0-9d58-0c444bb5020d] EVENT_ID: NETWORK_REMOVE_NETWORK(944), Network רשת עם שם ארוך מאוד was removed from Data Center: Default
2019-07-30 23:28:20,539-04 DEBUG [org.ovirt.engine.core.common.di.interceptor.DebugLoggingInterceptor] (default task-1) [6be1d9cc-f4c2-43d0-9d58-0c444bb5020d] method: runAction, params: [RemoveNetwork, RemoveNetworkParameters:{commandId='bb44c908-8b11-4875-a988-7644d97b91a6', user='null', commandType='Unknown'}], timeElapsed: 53ms

</pre>

### vdsm.log - host-1

<pre>
2019-07-30 23:26:27,708-0400 INFO  (jsonrpc/0) [api.network] START setupNetworks(networks={u'req-net': {u'remove': u'true'}}, bondings={}, options={u'connectivityCheck': u'true', u'connectivityTimeout': 120, u'commitOnSuccess': False}) from=::ffff:192.168.201.4,55906 (api:48)
2019-07-30 23:26:31,847-0400 INFO  (jsonrpc/0) [api.network] FINISH setupNetworks return={'status': {'message': 'Done', 'code': 0}} from=::ffff:192.168.201.4,55906 (api:54)
</pre>


## Stacktrace

<pre>

-----------------
Failed Tests:
-----------------
5 tests failed.
FAILED:  network-suite-4.3.tests.test_unrestricted_display_network_name.test_run_vm_with_unrestricted_display_network_name

Error Message:
test setup failure

Stack Trace:
host_0_up = <ovirtlib.hostlib.Host object at 0x7f72fb5d8250>
display_network = <ovirtlib.netlib.Network object at 0x7f72f9f3d910>

    @pytest.fixture(scope='module')
    def display_network_attached_to_host_0(host_0_up, display_network):
        ETH1 = 'eth1'
        DISP_NET_IPv4_ADDR_1 = '192.0.3.1'
        DISP_NET_IPv4_MASK = '255.255.255.0'

        ip_assign = netattachlib.StaticIpAssignment(
            addr=DISP_NET_IPv4_ADDR_1, mask=DISP_NET_IPv4_MASK)
        disp_att_data = netattachlib.NetworkAttachmentData(
            display_network, ETH1, [ip_assign])
>       host_0_up.setup_networks([disp_att_data])

network-suite-4.3/tests/test_unrestricted_display_network_name.py:62:
_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
network-suite-4.3/ovirtlib/hostlib.py:174: in setup_networks
    check_connectivity=True
/usr/lib64/python2.7/site-packages/ovirtsdk4/services.py:39714: in setup_networks
    return self._internal_action(action, 'setupnetworks', None, headers, query, wait)
/usr/lib64/python2.7/site-packages/ovirtsdk4/service.py:299: in _internal_action
    return future.wait() if wait else future
/usr/lib64/python2.7/site-packages/ovirtsdk4/service.py:55: in wait
    return self._code(response)
/usr/lib64/python2.7/site-packages/ovirtsdk4/service.py:296: in callback
    self._check_fault(response)
/usr/lib64/python2.7/site-packages/ovirtsdk4/service.py:132: in _check_fault
    self._raise_error(response, body)
_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _

response = <ovirtsdk4.http.Response object at 0x7f72f9f33c90>
detail = <ovirtsdk4.types.Fault object at 0x7f72f9f33e10>

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
E       Error: Fault reason is "Operation Failed". Fault detail is "[Cannot add network רשת עם שם ארוך מאוד to network interface eth1. Network interface has an unmanaged network attached.]". HTTP response code is 400.

/usr/lib64/python2.7/site-packages/ovirtsdk4/service.py:118: Error

FAILED:  network-suite-4.3.tests.test_vm_operations.test_live_vm_migration_using_dedicated_network

Error Message:
test setup failure

Stack Trace:
migration_network = <ovirtlib.netlib.Network object at 0x7f72f835d710>
host_0_up = <ovirtlib.hostlib.Host object at 0x7f72fb5d8250>

    @pytest.fixture
    def host_0_with_mig_net(migration_network, host_0_up):
        ip_assign = netattachlib.StaticIpAssignment(
            addr=MIG_NET_IPv4_ADDR_1, mask=MIG_NET_IPv4_MASK)
        mig_att_data = netattachlib.NetworkAttachmentData(
            migration_network, ETH1, [ip_assign])
>       host_0_up.setup_networks([mig_att_data])

network-suite-4.3/tests/test_vm_operations.py:81:
_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
network-suite-4.3/ovirtlib/hostlib.py:174: in setup_networks
    check_connectivity=True
/usr/lib64/python2.7/site-packages/ovirtsdk4/services.py:39714: in setup_networks
    return self._internal_action(action, 'setupnetworks', None, headers, query, wait)
/usr/lib64/python2.7/site-packages/ovirtsdk4/service.py:299: in _internal_action
    return future.wait() if wait else future
/usr/lib64/python2.7/site-packages/ovirtsdk4/service.py:55: in wait
    return self._code(response)
/usr/lib64/python2.7/site-packages/ovirtsdk4/service.py:296: in callback
    self._check_fault(response)
/usr/lib64/python2.7/site-packages/ovirtsdk4/service.py:132: in _check_fault
    self._raise_error(response, body)
_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _

response = <ovirtsdk4.http.Response object at 0x7f72f9f15550>
detail = <ovirtsdk4.types.Fault object at 0x7f72f9f152d0>

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
E       Error: Fault reason is "Operation Failed". Fault detail is "[Cannot add network mig-net to network interface eth1. Network interface has an unmanaged network attached.]". HTTP response code is 400.

/usr/lib64/python2.7/site-packages/ovirtsdk4/service.py:118: Error

FAILED:  network-suite-4.3.tests.ovs.test_ovn_physnet.test_connect_vm_to_external_physnet

Error Message:
test setup failure

Stack Trace:
system = <ovirtlib.system.SDKSystemRoot object at 0x7f72fd4bc210>
ovs_cluster = <ovirtlib.clusterlib.Cluster object at 0x7f72e90f41d0>
default_cluster = <ovirtlib.clusterlib.Cluster object at 0x7f72fdb12dd0>
default_data_center = <ovirtlib.datacenterlib.DataCenter object at 0x7f72fc04a490>

    @pytest.fixture(scope='session')
    def host_in_ovs_cluster(
            system, ovs_cluster, default_cluster, default_data_center):
        host_id = default_cluster.host_ids()[0]
        host = hostlib.Host(system)
        host.import_by_id(host_id)
        host.wait_for_up_status(timeout=hostlib.HOST_TIMEOUT_LONG)
        with hostlib.change_cluster(host, ovs_cluster):
>           host.sync_all_networks()

network-suite-4.3/fixtures/host.py:64:
_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
network-suite-4.3/ovirtlib/hostlib.py:218: in sync_all_networks
    self.service.sync_all_networks()
/usr/lib64/python2.7/site-packages/ovirtsdk4/services.py:39762: in sync_all_networks
    return self._internal_action(action, 'syncallnetworks', None, headers, query, wait)
/usr/lib64/python2.7/site-packages/ovirtsdk4/service.py:299: in _internal_action
    return future.wait() if wait else future
/usr/lib64/python2.7/site-packages/ovirtsdk4/service.py:55: in wait
    return self._code(response)
/usr/lib64/python2.7/site-packages/ovirtsdk4/service.py:296: in callback
    self._check_fault(response)
/usr/lib64/python2.7/site-packages/ovirtsdk4/service.py:134: in _check_fault
    self._raise_error(response, body.fault)
_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _

response = <ovirtsdk4.http.Response object at 0x7f72e90f48d0>
detail = <ovirtsdk4.types.Fault object at 0x7f72e90f4710>

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
E       Error: Fault reason is "Operation Failed". Fault detail is "[Illegal Network parameters]". HTTP response code is 400.

/usr/lib64/python2.7/site-packages/ovirtsdk4/service.py:118: Error

FAILED:  network-suite-4.3.tests.ovs.test_ovn_physnet.test_max_mtu_size

Error Message:
test setup failure

Stack Trace:
system = <ovirtlib.system.SDKSystemRoot object at 0x7f72fd4bc210>
ovs_cluster = <ovirtlib.clusterlib.Cluster object at 0x7f72e90f41d0>
default_cluster = <ovirtlib.clusterlib.Cluster object at 0x7f72fdb12dd0>
default_data_center = <ovirtlib.datacenterlib.DataCenter object at 0x7f72fc04a490>

    @pytest.fixture(scope='session')
    def host_in_ovs_cluster(
            system, ovs_cluster, default_cluster, default_data_center):
        host_id = default_cluster.host_ids()[0]
        host = hostlib.Host(system)
        host.import_by_id(host_id)
        host.wait_for_up_status(timeout=hostlib.HOST_TIMEOUT_LONG)
        with hostlib.change_cluster(host, ovs_cluster):
>           host.sync_all_networks()

network-suite-4.3/fixtures/host.py:64:
_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
network-suite-4.3/ovirtlib/hostlib.py:218: in sync_all_networks
    self.service.sync_all_networks()
/usr/lib64/python2.7/site-packages/ovirtsdk4/services.py:39762: in sync_all_networks
    return self._internal_action(action, 'syncallnetworks', None, headers, query, wait)
/usr/lib64/python2.7/site-packages/ovirtsdk4/service.py:299: in _internal_action
    return future.wait() if wait else future
/usr/lib64/python2.7/site-packages/ovirtsdk4/service.py:55: in wait
    return self._code(response)
/usr/lib64/python2.7/site-packages/ovirtsdk4/service.py:296: in callback
    self._check_fault(response)
/usr/lib64/python2.7/site-packages/ovirtsdk4/service.py:134: in _check_fault
    self._raise_error(response, body.fault)
_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _

response = <ovirtsdk4.http.Response object at 0x7f72e90f48d0>
detail = <ovirtsdk4.types.Fault object at 0x7f72e90f4710>

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
E       Error: Fault reason is "Operation Failed". Fault detail is "[Illegal Network parameters]". HTTP response code is 400.

/usr/lib64/python2.7/site-packages/ovirtsdk4/service.py:118: Error

FAILED:  network-suite-4.3.tests.ovs.test_ovn_physnet.test_security_groups_allow_icmp

Error Message:
test setup failure

Stack Trace:
system = <ovirtlib.system.SDKSystemRoot object at 0x7f72fd4bc210>
ovs_cluster = <ovirtlib.clusterlib.Cluster object at 0x7f72e90f41d0>
default_cluster = <ovirtlib.clusterlib.Cluster object at 0x7f72fdb12dd0>
default_data_center = <ovirtlib.datacenterlib.DataCenter object at 0x7f72fc04a490>

    @pytest.fixture(scope='session')
    def host_in_ovs_cluster(
            system, ovs_cluster, default_cluster, default_data_center):
        host_id = default_cluster.host_ids()[0]
        host = hostlib.Host(system)
        host.import_by_id(host_id)
        host.wait_for_up_status(timeout=hostlib.HOST_TIMEOUT_LONG)
        with hostlib.change_cluster(host, ovs_cluster):
>           host.sync_all_networks()

network-suite-4.3/fixtures/host.py:64:
_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
network-suite-4.3/ovirtlib/hostlib.py:218: in sync_all_networks
    self.service.sync_all_networks()
/usr/lib64/python2.7/site-packages/ovirtsdk4/services.py:39762: in sync_all_networks
    return self._internal_action(action, 'syncallnetworks', None, headers, query, wait)
/usr/lib64/python2.7/site-packages/ovirtsdk4/service.py:299: in _internal_action
    return future.wait() if wait else future
/usr/lib64/python2.7/site-packages/ovirtsdk4/service.py:55: in wait
    return self._code(response)
/usr/lib64/python2.7/site-packages/ovirtsdk4/service.py:296: in callback
    self._check_fault(response)
/usr/lib64/python2.7/site-packages/ovirtsdk4/service.py:134: in _check_fault
    self._raise_error(response, body.fault)
_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _

response = <ovirtsdk4.http.Response object at 0x7f72e90f48d0>
detail = <ovirtsdk4.types.Fault object at 0x7f72e90f4710>

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
E       Error: Fault reason is "Operation Failed". Fault detail is "[Illegal Network parameters]". HTTP response code is 400.

/usr/lib64/python2.7/site-packages/ovirtsdk4/service.py:118: Error

</pre>
