---
title: IPv6 support
category: feature
authors: amuller, danken, osvoboda, psebek
---

# IPv6 support

## Summary

This feature enables using IPv6 protocol by vdsm and ovirt-engine.

## Owner

*   Name: Yevgeny Zaspitsky (YevgenyZ)
*   Email: <yzaspits@redhat.com>

## Current status

*   Status:
    -   VDSM - still missing:
        -   multiple gateways; sourceRoute
    -   Engine - still misssing:
        -   Configuring Ipv6 properties in Setup Networks dialog in oVirt GUI.
        -   Sending IPv6 address to VDSM for migration destination. Optionally send all available (IPv4 and IPv6) address.
        -   Verify that engine could be accessed over IPv6 (GUI and REST-API).
        -   Allow IPv6 address for power management (fencing)

<!-- -->

*   Last updated: ,

## Detailed Description

With growing importance of protocol IPv6 there is need to provide this functionality in oVirt. This feature enables IPv6 at the Vdsm and Ovirt-engine sides, so the users won't need to use IPv4 anymore.

## Vdsm api

Records that have been changed:

*   @NetworkOptions (reported in getVdsCaps)
    -   add optional fields: '\*ipv6addr', '\*ipv6gateway', '\*ipv6autoconf' (it has to be specified whether use stateless auto-configuration, so it can be set together with DHCPv6 [4th paragraph](http://www.prolixium.com/ipv6_autocfg/node8.html)), '\*dhcpv6' (a boolean that is independent of IPv4 "bootproto")

<!-- -->

    # @ipv6addr:       #optional Assign this static IPv6 address to the interface (in the format of '<ip>[/<prefixlen>]')
    # @ipv6gateway:    #optional IPv6 address of the network gateway
    # @ipv6autoconf:   #optional Whether use stateless autoconfiguration
    # @dhcpv6:         #optional Whether use DHCPv6

    {'type': 'NetworkOptions',
     'data': {'*ipaddr': 'str', '*netmask': 'str', '*gateway': 'str',
              '*ipv6addr': 'str', '*ipv6gateway': 'str',
              '*ipv6autoconf': 'bool', '*dhcpv6': 'bool', 
              '*bootproto': 'str', '*delay': 'uint',
              '*bondingOptions', 'str',
              '*qosInbound': 'BandwidthParams',
              '*qosOutbound': 'BandwidthParams'}}

*   @SetupNetworkNetAttributes (set in setupNetworks)
    -   add optional fields: '\*ipv6addr', '\*ipv6gateway', '\*ipv6autoconf', '\*dhcpv6'

<!-- -->

    # @ipv6addr:       #optional Assign this static IPv6 address to the interface (in the format of '<ip>[/<prefixlen>]')
    # @ipv6gateway:    #optional IPv6 address of the network gateway
    # @ipv6autoconf:   #optional Whether use stateless autoconfiguration
    # @dhcpv6:         #optional Whether use DHCPv6

    {'type': 'SetupNetworkNetAttributes',
     'data': {'*vlan': 'str', '*bonding': 'str', '*nic': ['str'], '*ipaddr': 'str',
              '*netmask': 'str', '*gateway': 'str', '*ipv6addr': 'str',
              '*ipv6gateway': 'str', '*ipv6autoconf': 'bool',
              '*dhcpv6': 'bool', '*bootproto': 'str',
              '*delay': 'uint', '*onboot': 'bool', '*remove': 'bool',
              '*qosInbound': 'BandwidthParams',
              '*qosOutbound': 'BandwidthParams'}}

*   @RunningVmStats
    -   @displayIp, @clientIp **should** be able to contain IPv4 or IPv6 addresses
    -   We already report guest IPv6 addresses per guest nic (within the inet6 field of netIfaces item)

Records that DO NOT need to change (already work):

*   @Host.fenceNode - we need to put just one IP address of host, we can use field @addr for IPv6 also because type of @addr is str

      # vdsClient -s 0 fenceNode '2620:52::1040:221:5eff:fe11:a22d' 23 rsa fencetest fencetest status
      on
      # works!

*   @VmDefinition - same situation with fields @clientIp, @displayIp
*   @IscsiPortal - @host **should** be capable of carrying an IPv6 address.
*   @ISCSIConnection.discoverSendTargets - @host, Returns a list of discovered targets in the form: '<host>:<port>,<tpgt> <iqn>' (tested, working!)
*   @MigrateParams - @dst, @dstqemu: both destination Vdsm and destination qemu addresses **should** accept IPv6.
*   @IscsiSessionInfo - @connection, which is the hostname of the iSCSI target, **should** accept IPv6. We should test the *createStorageDomain* and *extendStorageDomain* verbs over IPv6.
*   @NfsConnectionParameters - NFS @export should accept IPv6 too. We **must** make sure that multiple colon characters in address do not confuse us.

Records that already contain IPv6 fields, could use further testing:

*   @NetInfoBridgedNetwork
*   @NetInfoNic
*   @NetInfoBond
*   @NetInfoVlan
*   @GuestNetworkDeviceInfo

## oVirt-Engine GUI

Fields that can contain IPv6 address:

*   Host address in adding new host will have ability to accept IPv6 address
    -   same behavior will be in power management-> address

![](/images/wiki/Ipv6_new_host.png)

*   External providers - the *Add External Provider* dialog **should** accept IPv6 addresses in:
    -   General -> Provider URL
    -   Set Network plugin to Open vSwitch or Linux Bridge -> Agent Configuration -> Host

<!-- -->

*   Network address in Setup Host Network -> edit network -> boot protocol: static :
    -   IP
    -   subnet mask - in IPv4 subnet mask has the form of dotted decimal number, same as IPv4 address. In IPv6 only `prefix` (an integer in the range 0-128) acceptable. Usually here will be the numbers 64/56/48.
    -   gateway - regular IPv6 address

*   address of nics in network interfaces - add column for IPv6 address(es)

![](/images/wiki/Ipv6_network_interfaces.png)

**TODO**: There stays a question if we want explicitly tell user the scope of address or it is redundant information to him, as well as whether link-local addresses are important to report.

*   add/import storage address

![](/images/wiki/Ipv6_new_domain_storage.png)

An interesting attribute of address is its scope (link-local or global). The scope can be determined from the address.

## REST API

REST API model contains the type called "ip", which already has the attribute "version" (4 or 6 at the moment). The type "ip" is referenced by the following types (according to [ovirt-engine-api-model project](https://gerrit.ovirt.org/gitweb?p=ovirt-engine-api-model.git;a=tree)):

*   HostNic - currently contains a single ip field. Additional one should be added for ipv6 or alternatively to be replaced by a collection of ip's.
*   IpAddressAssignment
*   ReportedDevice
*   Session (VM session)
*   NicConfiguration (cloud-init)
*   Network (To be removed)

Actions that will be affected (where IP is optional or mandatory argument) with change of records (from the file ovirt-engine/backend/manager/modules/restapi/interface/definition/src/main/resources/rsdl_metadata.yaml):

*   Setup networks - /hosts/{host:id}/[nics/]setupnetworks|rel=setupnetworks
*   NetworkAttachment
    -   Add - /hosts/{host:id}/[nics/{nic:id}/]networkattachments|rel=add
    -   Update - /hosts/{host:id}/[nics/{nic:id}/]networkattachments/{networkattachment:id}|rel=update
*   Ancient API that is to be obliterated:
    -   HostNic update - /hosts/{host:id}/nics/{nic:id}|rel=update
    -   Network
        -   Add - [/datacenters/{datacenter:id}]/networks|rel=add
        -   Update - [/datacenters/{datacenter:id}]/networks/{network:id}|rel=update

API types that contain an IP address as string, should be tested they also work with IPv6 (TESTONLY):

*   Agent
*   PowerManagement
*   Host
*   NfsStorage
*   IscsiTarget
*   Display
*   VM start (when vNics are defined through cloud-init configuration) - /vms/{vm:id}/start|rel=start
    -   should oVirt support supplying both (IPv4 and IPv6) addresses?

Records that contain "href" as string, should be tested if they work with IPv6 addresses. We should make sure that IPv6 addresses are properly quoted and hrefs do not break:

*   Link
*   BaseResource
*   RSDL

## Changes in code

### Vdsm

*   New class 'netmodels.IPv6'. Similar like netmodels.IPv4, for address validation and representation
    -   This brings changes in class netmodels.IpConfig, configNetwork.objectivizeNetwork
*   Ifcfg files have to have IPv6 capabilities as are described here <http://www.cyberciti.biz/faq/rhel-redhat-fedora-centos-ipv6-network-configuration/> . More information about IPv6 initscripts are here: <http://www.deepspace6.net/projects/initscripts-ipv6.html> .
    -   ifcfg.ConfigWriter._createConfFile(),
    -   There is a change from Hunt Xu <http://gerrit.ovirt.org/#/c/11741> that seems outdated now, but that dealed with new shape of ifcfg files.
*   Iproute2 configurator (http://gerrit.ovirt.org/#/c/15301/) looks like there shouldn't be made any changes?
*   jsonrpc: make TCPReactor IPv6 capable
    -   <http://gerrit.ovirt.org/#/c/11740>
*   jsonRpcUtils - done as well.
*   The [multiple gateways](/develop/release-management/features/network/multiple-gateways/) implementation is incompatible with IPv6.
    -   New class handling source route in vdsm/sourceRoute.py
*   Minor changes to lib/vdsm/ipwrapper.py to be ipv6 aware

#### VDSM tests

There should be a change/extension to tests under the tests/ directory:

*   configNetworkTests.py - try to create IPv6-only network/nics, both IPv4 and IPv6
*   jsonRpcUtils.py - extend with IPv6 addresses, where IPv4 is used
*   netmodelsTests.py - testIsIpv6valid, testIPv6Prefixlenvalid

### oVirt-Engine frontend

This classes validate form of ip addresses:

*   IpAddressValidation - add recognition of IPv6 address
*   HostAddressValidation - same as ip

### oVirt-Engine backend

We are currently using class IPAddress to represent ip, it uses class java.net.InetAddress, what is already prepared for IPv4 and IPv6 addreses <http://docs.oracle.com/javase/6/docs/api/java/net/InetAddress.html>.

### Pending patches

*   [Vdsm](https://gerrit.ovirt.org/#/q/status:open+project:vdsm+branch:master+topic:ipv6_support,n,z)
*   [Engine](https://gerrit.ovirt.org/#/q/topic:ipv6)

### Merged patches

*   Add IPv6 support to configNetwork <http://gerrit.ovirt.org/#/c/18284/>
*   jsonrpc: make TCPReactor IPv6 capable <http://gerrit.ovirt.org/#/c/11740/>
*   vdscli: update cannonize helper function for IPv6 environment <http://gerrit.ovirt.org/#/c/16225/>
*   XMLRPCServer: make XMLRPCServer able to listen on IPv6 addresses <http://gerrit.ovirt.org/#/c/11520/>
*   netinfo: report IPv6 information <http://gerrit.ovirt.org/#/c/9382/>
*   netinfo: implement functions gathering IPv6 information <http://gerrit.ovirt.org/#/c/9381/>

## Benefit to oVirt

By implementing this feature oVirt will be prepared for users that are using IPv6 protocol.

## Dependencies / Related Features

*   [Features/Node ipv6 support](/develop/projects/node/ipv6-support/)
*   We need to define requirements for customers, who want to use IPv6 in Ovirt. RIPE NCC already make a list of requirements for IPv6 support so we can use it <http://www.ripe.net/ripe/docs/ripe-554>

## Documentation / External references

*   Presentation for Ovirt networking team [ODP](http://resources.ovirt.org/old-site-files/wiki/Ipv6-session.odp)
*   <https://lists.ovirt.org/pipermail/users/2014-December/030135.html>

## Testing

### Vdsm

By default Vdsm now listens on both IPv6 and IPv4:

       $ netstat -tanp | grep 54321
        tcp6 0 0 :::54321 :::* LISTEN 21545/python

You should be able to control vdsmd with vdsClient using IPv6 addresses:

       vdsClient -s [::1] getVdsCaps
       vdsClient -s [::1]:54321 getVdsCaps
       vdsClient -s localhost6 getVdsCaps
       vdsClient -s localhost6:54321 getVdsCaps
       vdsClient -s ['IPv6 link-local addr'%ovirtmgmt] getVdsCaps
       vdsClient -s ['IPv6 link-local addr'%ovirtmgmt]:54321 getVdsCaps

Where 'IPv6 link-local addr' is address of IPv6 link local address of bridge ovirtmgmt (e.g. [fe80::5054:ff:fe05:25f3%ovirtmgmt]). Each of this command should work as in normal manner.

*   Test functionality of newly-added attributes to @NetworkOptions, @SetupNetworkNetAttributes
    -   Create Network with both static IPv4 and IPv6 addresses.
    -   Create Network where IPv6 will be using Stateless autoconfiguration and DHCPv6 at the same time.
*   Test that every api schema that can contain IP address, can contain IPv6 address. Listed in [#Vdsm api](#Vdsm_api) Records that DO NOT need to change.
    -   Create IP on IPv6 network only, reported IPv6 address should be IPv6.
*   Test functionality of IPv6 related fields. Listed in [#Vdsm api](#Vdsm_api) Records that already contains IPv6 fields.

### oVirt-Engine GUI

*   Test that to every address field can be inserted IPv6 address. Test every [form of IPv6 address](https://en.wikipedia.org/wiki/IPv6_address#Presentation), e.g.: full form, omitted leading zeros, changed group of zeros.
    -   Add host addressed by IPv6 address.
    -   Add external provider using IPv6 address.
    -   Add storage (NFS/iSCSI) using IPv6 address.
*   Test every combination of Edit Network, every boot protocol with combination of IPv6 or IPv4 addresses. There should always be selected at least one protocol, otherwise the error should raise.
    -   Edit network to use static configuration and fill in IPv4 and IPv6 addresses.
*   define a VM with a display network that has only an IPv6 address, run the VM, and connect to it via vnc and spice.
*   migrate a VM over a migration network with an IPv6 address
*   fence a host over IPv6.

### REST API

Use REST API for:

*   Check that record "Network", "HostNic" and "NetworkAttachment" contain "ips", that every "ip" has selected proper "version" and all IPs are listed.
    -   Update Network with IPv6 address.
    -   Create new Network with IPv6 address.
    -   Use setupnetworks verb to add network with IPv6 address.
    -   Update HostNic with IPv6 address.
*   Check that every records with "address" or "href" properly handle IPv6 format.
    -   Add host with IPv6 address in field address.


### Open questions

*   Should we provide option to add more than one IPv6 address to Edit Network static configuration? Is it possible to use with parameter in IPV6ADDR_SECONDARIES in ifcfg <http://www.cyberciti.biz/faq/redhat-centos-rhel-fedora-linux-add-multiple-ip-samenic/>
*   What is the meaning of having both IPv4 AND IPv6 address for the same network? E.g., if this is a migration network, which of the addresses should qemu use?
*   How to handle multiple gateways with IPv6? Currently the sourceRoute.py code assumes IPv6, and our understanding of IPv6 routing is poor.
*   What's the benefit of allowing stateless autoconfiguration in oVirt?
*   Should we allow multiple IPv6 addresses? With different scopes?
*   Should address scope be reported? If yes, should VDSM report that or the engine should guess that from the address?

### Discussion

On the devel@ovirt.org mailing list.

