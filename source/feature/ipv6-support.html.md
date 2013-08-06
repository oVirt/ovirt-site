---
title: IPv6 support
category: feature
authors: amuller, danken, osvoboda, psebek
wiki_category: Feature
wiki_title: Features/IPv6 support
wiki_revision_count: 70
wiki_last_updated: 2014-11-06
---

# IPv6 support

### Summary

This feature enable to connect to vdsm and ovirt-engine via IPv6 protocol.

### Owner

*   Name: [ Petr Šebek](User:Psebek)
*   Email: <psebek@redhat.com>
*   IRC: psebek at #ovirt (irc.oftc.net)

### Current status

*   Status: Design
*   Last updated: ,

### Detailed Description

With growing importance of protocol IPv6 there is need to provide this functionality in Ovirt. This feature enable IPv6 at the Vdsm and Ovirt-engine side, so the users won't need to use IPv4 anymore.

### Vdsm api

Records that need change:

*   @NetworkOptions
    -   add optional fields: '\*ipv6addr', '\*ipv6gateway', '\*ipv6autoconf' (it has to be specified whether use stateless autoconfiguration, because it can be set together with DHCPv6 <http://www.prolixium.com/ipv6_autocfg/node8.html> 4th paragraph), '\*dhcpv6' (DHCPv6 has to be specified because we can't specify it in BOOTPROTO - it would not make sense for IPv4, also it can be used together with stateless configuration)

<!-- -->

    # @ipv6addr:       #optional Assign this static IPv6 address to the interface (in the format of '<ip>[/<prefixlen>]')
    # @ipv6gateway:    #optional IPv6 address of the network gateway
    # @ipv6autoconf:   #optional Whether use stateless autoconfiguration
    # @dhcpv6:         #optional Whether use DHCPv6

    {'type': 'NetworkOptions',
     'data': {'*ipaddr': 'str', '*netmask': 'str', '*gateway': 'str',
              '*ipv6addr': 'str', '*ipv6gateway': 'str',
              '*ipv6autoconf': 'bool', '*dhcpv6': 'bool', 
              '*bootproto': 'str', '*delay': 'uint', '*onboot': 'str',
              '*bondingOptions', 'str',
              '*qosInbound': 'BandwidthParams',
              '*qosOutbound': 'BandwidthParams'}}

*   @SetupNetworkNetAttributes
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

Records that DO NOT need to change, TESTONLY:

*   @Host.fenceNode - we need to put just one IP address of host, we can use field @addr for IPv6 also because type of @addr is str
*   @VmDefinition - same situation with fields @clientIp, @displayIp
*   @IscsiPortal - @host **should** be capable of carrying an IPv6 address.
*   @ISCSIConnection.discoverSendTargets - @host, Returns a list of discovered targets in the form: '<host>:<port>,<tpgt> <iqn>'
*   @MigrateParams - @dst, @dstqemu: both destination Vdsm and destination qemu addresses **should** accept IPv6.
*   @IscsiSessionInfo - @connection, which is the hostname of the iSCSI target, **should** accept IPv6. We should test the *createStorageDomain* and *extendStorageDomain* verbs over IPv6.
*   @NfsConnectionParameters - NFS @export should accept IPv6 too. We **must** make sure that multiple colon characters in address do not confuse us.

Records that already contains IPv6 fields, could use further testing:

*   @NetInfoBridgedNetwork
*   @NetInfoNic
*   @NetInfoBond
*   @NetInfoVlan
*   @GuestNetworkDeviceInfo

### Ovirt-Engine GUI

Fields that can contain IPv6 address:

*   Host address in adding new host will have ability to accept IPv6 address
    -   same behaviour will be in power management-> address

![](Ipv6 new host.png "Ipv6 new host.png")

*   External providers - the *Add External Provider* dialog *'should*; accept IPv6 addresses in:
    -   General -> Provider URL
    -   Set Network plugin to Open vSwitch or Linux Bridge -> Agent Configuration -> Host

<!-- -->

*   Network address in Setup Host Network -> edit network -> boot protocol: static :
    -   IP
    -   subnet mask - in IPv4 subnet mask has the form of dotted decimal number, same as IPv4 address. In IPv6 subnet is made of single number from 0-128 that describes the number of bits from start that belongs to site. Usually here will be the numbers 64/56/48.
    -   gateway - regular IPv6 address

![](Ipv6 edit management network.png "Ipv6 edit management network.png")

*   address of nics in network interfaces - add column for IPv6 address(es)

![](Ipv6 network interfaces.png "Ipv6 network interfaces.png")

*   add/import storage address

![](Ipv6 new domain storage.png "Ipv6 new domain storage.png")

Note that this dialog **should** be able to report multiple IPv6 addresses per device.

Interesting attribute of address is its scope (link-local or global). The scope can be determined from the address. There stays a question if we want explicitly tell user the scope of address or it is redundant information to him, as well as whether link-local addresses are important to report.

### REST API

REST API now contains a record called "ip" which already has the attribute "version" (4 or 6 at the moment). Record "ip" is present in following records:

*   ips - container of "ip"
*   Network
*   HostNic

Both Network and HostNic **should** use "ips" rather than a single "ip", so they can contain multiple addresses with selected version.

Records that contains "address" as string, should be tested they work with IPv6 TESTONLY:

*   Agent
*   PowerManagement
*   Host
*   NfsStorage
*   IscsiTarget
*   Display

Records that contains "href" as string, should be tested if works with IPv6:

*   Link
*   BaseResource
*   RSDL ??

### Changes in code

#### Vdsm

*   New class 'netmodels.IPv6'. Similar like netmodels.IPv4, for address validation and representation
    -   This brings changes in class netmodels.IpConfig, configNetwork.objectivizeNetwork
*   Ifcfg files have to have IPv6 capabilities as are described here <http://www.cyberciti.biz/faq/rhel-redhat-fedora-centos-ipv6-network-configuration/>
    -   ifcfg.ConfigWriter._createConfFile(),
    -   There is a change from Hunt Xu <http://gerrit.ovirt.org/#/c/11741> that seems outdated now, but that dealed with new shape of ifcfg files.
*   Iproute2 configurator (http://gerrit.ovirt.org/#/c/15301/) looks like there shouldn't be made any changes?
*   jsonrpc: make TCPReactor IPv6 capable
    -   <http://gerrit.ovirt.org/#/c/11740>
*   jsonRpcUtils
    -   jsonRpcUtils.getFreePort() [AF_INET and 0.0.0.0],
    -   jsonRpcUtils._tcpServerConstructor() [there should be distinction of using 'localhost' and localhost6]
    -   jsonRpcUtils._protonServerConstructor()[127.0.0.1]

##### VDSM tests

There should be a change/extension to tests under the tests/ directory:

*   configNetworkTests.py - try to create IPv6-only network/nics, both IPv4 and IPv6
*   jsonRpcUtils.py - extend with IPv6 addresses, where IPv4 is used
*   netmodelsTests.py - testIsIpv6valid, testIPv6Prefixlenvalid

#### Ovirt-Engine frontend

This classes validate form of ip addresses:

*   IpAddressValidation - add recognition of IPv6 address
*   HostAddressValidation - same as ip

#### Ovirt-Engine backend

We are currently using class IPAddress to represent ip, it uses class java.net.InetAddress, what is already prepared for IPv4 and IPv6 addreses <http://docs.oracle.com/javase/6/docs/api/java/net/InetAddress.html>.

#### Pending patches

On the Vdsm side there are this pending patches <http://gerrit.ovirt.org/#/q/status:open+project:vdsm+branch:master+topic:ipv6_support,n,z> .

### Benefit to oVirt

By implementing this feature oVirt will be prepared for users that are using IPv6 protocol.

### Dependencies / Related Features

*   [Features/Node ipv6 support](Features/Node ipv6 support)

### Documentation / External references

### Testing

#### Vdsm

Currently there is need to specify management_ip in config file to be in IPv6 format, so after build and installation of Vdsm update file /etc/vdsm/vdsm.conf, and change management_ip under address section to:

       management_ip = ::

After start of vdsmd service there should be record in netstat like this:

       $ netstat -tanp | grep 54321
        tcp6 0 0 :::54321 :::* LISTEN 21545/python

Now you should be able to control vdsmd with vdsClient using IPv6 addresses:

       vdsClient -s [::1] getVdsCaps
       vdsClient -s [::1]:54321 getVdsCaps
       vdsClient -s localhost6 getVdsCaps
       vdsClient -s localhost6:54321 getVdsCaps
       vdsClient -s ['IPv6 link-local addr'%ovirtmgmt] getVdsCaps
       vdsClient -s ['IPv6 link-local addr'%ovirtmgmt]:54321 getVdsCaps

Where 'IPv6 link-local addr' is address of IPv6 link local address of bridge ovirtmgmt (e.g. [fe80::5054:ff:fe05:25f3%ovirtmgmt]). Each of this command should work as in normal manner.

#### VDSM API

*   Test functionality of newly added attributes to @NetworkOptions, @SetupNetworkNetAttributes
    -   Create Network with both with static IPv4 and IPv6 addresses.
    -   Create Network where IPv6 will be using Stateless autoconfiguration and DHCPv6 at the same time.
*   Test that every api schema that can contain IP address, can contain IPv6 address. Listed in [#Vdsm api](#Vdsm_api) Records that DO NOT need to change.
    -   Try to fence node addressed with IPv6 address.
    -   Create IP on IPv6 network only, reported IPv6 address should be IPv6.
*   Test functionality of IPv6 related fields. Listed in [#Vdsm api](#Vdsm_api) Records that already contains IPv6 fields.

#### Ovirt-Engine GUI

*   Test that to every address field can be inserted IPv6 address. Test every form of IPv6 address: full form, omited leading zeros, changed group of zeros (https://en.wikipedia.org/wiki/IPv6_address#Presentation).
    -   Add host addressed by IPv6 address.
    -   Add external provider using IPv6 address.
    -   Add storage using IPv6 address.
*   Test every combination of Edit Network, every boot protocol with combination of IPv6 or IPv4 addresses. There should always be selected at least one protocol, otherwise the error should raise.
    -   Edit network to use static configuration and fill in IPv4 and IPv6 addresses.
    -   Use DHCP configuration for IPv4 and stateless configuration for IPv6.

#### REST API

*   Check that record "Network" and "HostNic" contains "ips", that every "ip" has selected proper "version" and all IPs are listed.
*   Check that every records with "address" or "href" properly handle IPv6 format.

### Comments and Discussion

#### Open questions

*   Should we provide option to add more than one IPv6 address to Edit Network static configuration? Is it possible to use with parameter in IPV6ADDR_SECONDARIES in ifcfg <http://www.cyberciti.biz/faq/redhat-centos-rhel-fedora-linux-add-multiple-ip-samenic/>
*   What is the meaning of having both IPv4 AND IPv6 address for the same network? E.g., if this is a migration network, which of the addresses should qemu use?
*   How to handle multiple gateways with IPv6? Currently the sourceRoute.py code assumes IPv6, and our understanding of IPv6 routing is poor.
*   Should we allow DHCPv6 and stateless autoconfiguration at same time?

#### Discussion

On the arch@ovirt.org mailing list.

<Category:Feature>
