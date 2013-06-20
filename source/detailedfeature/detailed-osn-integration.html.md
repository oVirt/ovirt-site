---
title: Detailed OSN Integration
category: detailedfeature
authors: danken, lvernia, mkolesni, moti, mpavlik
wiki_category: DetailedFeature
wiki_title: Features/Detailed OSN Integration
wiki_revision_count: 72
wiki_last_updated: 2014-03-24
---

# Detailed OSN Integration

## Summary

We intend to add support for OpenStack Quantum as a network provider. Please see further details in [Features/Quantum_Integration](Features/Quantum_Integration)

## Owner

*   Name: [ Mike Kolesnik](User:Mkolesni)

<!-- -->

*   Email: <mkolesni@redhat.com>

## Current status

*   Target Release: oVirt 3.3
*   Status: Implementation
*   Last updated: ,

## Detailed Description

The integration of network providers into oVirt will be incremental. The following phases outline the general guidelines and considerations.

### Phase 1 - Tech Preview

*   Add Quantum as an external provider.
    -   Support for Linux Bridge plugin
    -   Support for OVS plugin?
*   Each quantum plugin will have a corresponding vNIC driver in VDSM, that can connect the vNIC to quantum.
    -   Current implementation will be done by hooks.
*   No support for pre-built ovirt-node (or RHEV-H).
*   Integration - with Quantum Grizzly.

#### Network provider entity

*   Introducing a 'Provider' entity that will have the following properties:
    -   Name
    -   Description
    -   Type (from a fixed list of types)
    -   URL
    -   User/Password ?
*   Possibly, different providers can have additional properties that are needed by them.

#### Changes in network entity

*   Each network can be provided **either** by oVirt or by the external provider.
*   This requires that each network has a link to the provider:
    -   If the link is set, then this network is provided by the external provider.
    -   If the link is not set, the network is not provided externally.
*   There should also be an ID property of the network on the external provider.
*   One external provider will be supported for a network.
    -   However, an external provider can provide multiple networks.

#### Effective limitations

*   All networks provided by an external provider will be VM networks.
*   Importing the same network more than once should be defined as supported for different DCs but blocked otherwise.
*   External network cannot be used as a display network.
*   If a network is externally provided, it will **not** be editable in oVirt, since the external provider is responsible for managing the actual network configuration.
*   External network will always be non required.
    -   Scheduling for the cluster the network is attached to will not take the network into host selection consideration.
    -   This effectively means that the user is responsible for quantum availability on all the hosts in a given cluster the external network is attached to.
*   Port mirroring is not available for virtual NICs connected to external networks.
*   Block deleting provider if there are VMs using the networks it provides.

#### Integration with virtual NIC lifecycle

*   Integration will be done at this phase for running virtual machine and hot plug/unplug of NICs.
    -   Rewiring will **not** be supported for externally provided networks (Will be supported in a future phase).
*   When VM is being run we need to include all hosts in the cluster for scheduling decision of available networks.
*   For each virtual NIC that is using an externally provided network, we would need to provision the NIC on the provider and receive the NIC connection details prior to running the VM.
    -   Once we have all the details available, we would need to pass those details to VDSM.
        -   This requires API change in the 'create' verb that would pass the connection details for each NIC.
*   On VM stop, we need to "un-provision" the NIC of each externally provided network from the relevant provider

### Future phases

#### REST API support

*   Providers will be added as a top-level collection.
*   A provider will have a capabilities sub collection:
    -   Currently, the only capability type will be "networking".
    -   Capability resource ID will be computed according to provider ID + capability type.
    -   Networking capability will have a "networks" sub collection:
        -   Networks sub collection will be the networks as discovered on the provider.
        -   Network resource will have an ID matching its identity on the provider (or computed from it).
*   Importing a network would be done by copying the resource XML and posting it on the top level networks resource.
    -   The imported network would have a new ID which is oVirt internal.
    -   The imported network would have a link to it's origin network (The resource in the provider/capability context).

#### Allow provisioning networks on external providers

*   It would be possible to define a network in oVirt and "push" it to external providers. This network will then be treated as is it was discovered on the provider, and will be the sole responsibility of the provider.
*   The provider will be responsible for providing the connectivity of the network.

#### Support other provider capabilities

*   Providers could be added to enable capabilities such as storage.
*   Provider type should be supported as well, to differentiate between the various providers.

#### Auto-Discovery of networks

*   An external provider would be set up as the provider of networking for a DC, such that any network defined on the provider will be discovered by oVirt and automatically set-up on the DC.

#### Leverage advanced technologies

*   IPAM could be used to manage the IP address allocation.
*   L3 routing for creating virtual routers.
*   Security groups for controlling traffic on the networks.

### User Experience

![ thumb | right](Providers.png  "fig: thumb | right") ![ thumb | right](Discovery.png  "fig: thumb | right") ![ thumb | right](Add.png  "fig: thumb | right") ![ thumb | right](Networks.png  "fig: thumb | right")

*   To represent the new Provider entity in our project, we're planning to add a new tab for Providers. At first it will only be populated with network Providers, but later on it might include Providers of other resource types as well.
*   Adding a new Provider in oVirt will comprise supplying an arbitrary name for it, and a URL address from which entities may be imported. We're planning to add a graphical indication of the connection to the supplied URL address.
*   When a specific Provider is chosen, subtabs displaying information concerning that Provider will appear (as with any other entity). To begin with, General and Networks subtabs will be implemented.
*   The main function in the Provider/Networks subtab will be to "Discover" the networks provided, which will open a popup window enabling attachment of provided networks to DC(s).
*   The user will also be able to create new networks to be attached to the Provider from within oVirt.
*   The provider entity should also be reflected in the system tree. We are currently intending to add another node between the System node and the specific DCs called "Data Centers", and on the same level a node called "Providers" (as they are not part of the DCs, but rather interfaces to external entities). Under the Providers node, will be displayed the Providers that exist in the engine's DB. We haven't thought about icons for these entities - maybe something general for Providers and something to do with Quantum for the current network providers (future providers will have other icons corresponding to their types).
*   The link between the Provider and its provided entity (in our case, a network) needs to also be reflected in the provided entity. Therefore, we'll add a Provider column to each network tab/subtab. Also, to make access to the Provider easier for the user, we're planning to have the text link to the actual Provider tab.

### Installation/Upgrade

### User work-flows

#### OpenStack Networking & Identity (Keystone) installation

All the components need to be installed, and set to run on startup.

Good documentation is available at <https://access.redhat.com/site/documentation/en-US/Red_Hat_OpenStack/2/html/Getting_Started_Guide/chap-Deploying__OpenStack_Networking_Services.html>

##### Configure Keystone

1.  Install keystone
    1.  Steps described at: <http://docs.openstack.org/developer/keystone/installing.html#installing-from-packages-fedora>
    2.  And: <http://fedoraproject.org/wiki/Getting_started_with_OpenStack_on_Fedora_17#Initial_Keystone_setup>

2.  Configure quantum in keystone
    1.  Steps described at: <http://docs.openstack.org/grizzly/openstack-network/admin/content/keystone.html>
        1.  Add quantum service
        2.  Add quantum admin user

Note: get_id function is:

      function get_id () {
      `     echo `"$@" | grep ' id ' | awk '{print $4}'` `
      }

##### Configure Quantum manager

1.  Install quantum manger
    1.  Steps described at: <http://docs.openstack.org/trunk/openstack-network/admin/content/install_fedora.html>
        1.  Install quantum plugin
        2.  Run plugin self configuration (This will create the DB)
        3.  Configure /etc/quantum/quantum.conf:
            1.  Choose rabbit / qpid by un-commenting the corresponding values
            2.  Un-comment notification_driver = quantum.openstack.common.notifier.list_notifier

        4.  Configure /etc/quantum/plugin.ini:
            1.  Fill correct IP in sql_connection
            2.  Change: tenant_network_type = vlan
            3.  Edit: network_vlan_ranges = <label>:<tag start>:<tag end>,physnet1:1000:2999

#### Agent installation on host

1.  Install quantum plugin (same plugin as in the manager)
2.  Configure the quantum manger IP (rabbit_host =)
3.  Run plugin self configuration (for creating the link of plugin.ini to the specific config)
4.  When using Linux Bridge only:
    1.  Override file for creating a tap connected to dummy bridge

#### Linuxbridge Agent installation steps

      yum install -y openstack-quantum-linuxbridge
      LB_CONF=/etc/quantum/plugins/linuxbridge/linuxbridge_conf.ini
      Q_CONF=/etc/quantum/quantum.conf
      QPID_HOST=10.35.0.192
      INTERFACE_MAPPING=default:eth0
      # configuring QPID host
      /usr/bin/openstack-config --set ${Q_CONF} DEFAULT rpc_backend quantum.openstack.common.rpc.impl_qpid
      /usr/bin/openstack-config --set ${Q_CONF} DEFAULT qpid_hostname ${QPID_HOST}
      if [[ -n "$qpid_username" ]]; then
          /usr/bin/openstack-config --set ${Q_CONF} DEFAULT qpid_username $qpid_username
      fi
      if [[ -n "$qpid_password" ]]; then
          /usr/bin/openstack-config --set ${Q_CONF} DEFAULT qpid_password $qpid_password
      fi
      if [[ -n "$qpid_port" ]]; then
          /usr/bin/openstack-config --set ${Q_CONF} DEFAULT qpid_port $qpid_port
      fi
      # edit /etc/quantum/plugin.ini physical_interface_mappings
      /usr/bin/openstack-config --set ${LB_CONF} LINUX_BRIDGE physical_interface_mappings ${INTERFACE_MAPPING}
      systemctl daemon-reload
      service quantum-linuxbridge-agent start
      chkconfig quantum-linuxbridge-agent on

#### OVS Agent installation steps

      sudo yum install -y openstack-quantum-openvswitch
      QPID_HOST=${QPID_HOST_ADDRESS}
      OVS_CONF=/etc/quantum/plugins/openvswitch/ovs_quantum_plugin.ini
      BRIDGE_MAPPINGS=physnet1:br-eth0
      sudo /usr/bin/quantum-node-setup --plugin openvswitch --qhost ${QPID_HOST} --skip-nova
      sudo /usr/bin/openstack-config --set ${OVS_CONF} OVS bridge_mappings ${BRIDGE_MAPPINGS}
      service openvswitch start
      chkconfig openvswitch on
      ovs-vsctl add-br br-int
      ovs-vsctl add-br br-ex
      sudo service quantum-openvswitch-agent start
      sudo chkconfig quantum-openvswitch-agent on

### Events

## Dependencies / Related Features and Projects

Please see the [feature page](Features/Quantum_Integration).

## Documentation / External references

*   <https://wiki.openstack.org/wiki/Quantum/APIv2-specification>
*   <http://docs.openstack.org/api/openstack-network/2.0/content/>
*   <http://docs.openstack.org/trunk/openstack-network/admin/content/>

## Comments and Discussion

<Talk:Features/Detailed_Quantum_Integration>

## Open Issues

*   Authentication - how to do it?
    -   Quantum supports only noauth/keystone auth modes.
        -   Configuring keystone adds an additional dependency for the administrator to handle.
    -   Need to decide which of these modes we will support in Phase 1 (actually, noauth is already supported, but obviously not secure).
*   Scheduling:
    -   Quantum doesn't expose an API to know which hosts will be able to provision it's networks.
    -   Perhaps Grizzly will have better support for it, still not certain.
*   [Libvirt bug](https://bugzilla.redhat.com/878481) still not solved, Linux Bridge support requires quantum hack (or push as a fix for the agent).
*   REST API support will not be available in Phase 1, how will this effect the REST API clients?

## Proof of Concept

A POC was done with the proposed ideas in "Phase 1" section, integrating [Openstack Quantum](https://wiki.openstack.org/wiki/Quantum) as an external network provider. the POC is available for review & testing.

### POC Sources

The POC sources can be found in the oVirt gerrit under a topic branch: <http://gerrit.ovirt.org/#/q/status:open+project:ovirt-engine+branch:master+topic:POC_NetworkProvider,n,z>

### Hack in Quantum linux bridge agent

Due to a bug in libvirt (https://bugzilla.redhat.com/show_bug.cgi?id=878481) we had to connect the vNIC to the ;vdsmdummy; bridge in VDSM. The Quantum agent will detect the tap device (the physical implementation of the vNIC) and attempt to connect it to it's bridge but fail because it's already connected to the dummy bridge.

To fix this, you would need to edit the installed linuxbridge_quantum_agent.py file and add this line of code:

                 utils.execute(['brctl', 'delif', ';vdsmdummy;', tap_device_name], root_helper=self.root_helper)

Inside the method **add_tap_interface**, right before:

                 if utils.execute(['brctl', 'addif', bridge_name, tap_device_name],
                                  root_helper=self.root_helper):

### Demo Videos

Demo videos of the POC in action are available on youtube.

#### The 1st part (the providers tab, discovery, etc)

<http://www.youtube.com/watch?v=yXqN17KktjE>

#### The 2nd part (VM connectivity)

<http://www.youtube.com/watch?v=uW3vrY2Y3xc>

<Category:DetailedFeature> <Category:Networking>
