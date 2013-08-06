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
    -   add optional fields: '\*ipv6addr', '\*ipv6netmask', '\*ipv6gateway'

<!-- -->

    {'type': 'NetworkOptions',
     'data': {'*ipaddr': 'str', '*netmask': 'str', '*gateway': 'str',
              '*ipv6addr': 'str', '*ipv6netmask': 'str', '*ipv6gateway': 'str',
              '*bootproto': 'str', '*delay': 'uint', '*onboot': 'str',
              '*bondingOptions', 'str',
              '*qosInbound': 'BandwidthParams',
              '*qosOutbound': 'BandwidthParams'}}

*   @SetupNetworkNetAttributes
    -   add optional fields: '\*ipv6addr', '\*ipv6netmask', '\*ipv6gateway'

<!-- -->

    {'type': 'SetupNetworkNetAttributes',
     'data': {'*vlan': 'str', '*bonding': 'str', '*nic': ['str'], '*ipaddr': 'str',
              '*netmask': 'str', '*gateway': 'str',  '*ipv6addr': 'str', 
              '*ipv6netmask': 'str', '*ipv6gateway': 'str',  '*bootproto': 'str',
              '*delay': 'uint', '*onboot': 'bool', '*remove': 'bool',
              '*qosInbound': 'BandwidthParams',
              '*qosOutbound': 'BandwidthParams'}}

*   @RunningVmStats
    -   @displayIp, @clientIp **should** be able to contain IPv4 or IPv6 addresses
    -   We already report guest IPv6 addresses per guest nic (within the inet6 field of netIfaces item)

<!-- -->

     {'type': 'RunningVmStats',
     'data': {'displayPort': 'uint', 'displaySecurePort': 'uint',
             ....
              'username': 'str', 'session': 'GuestSessionState',
              'appsList': ['str'], 'guestIPs': 'str', 'guestIPv6s': 'str',
              'memoryStats': 'GuestMemoryStats', 'balloonInfo': 'BalloonInfo',
              'disksUsage': ['GuestMountInfo'],
              'netIfaces': ['GuestNetworkDeviceInfo'],
              'watchdogEvent': '*WatchdogEvent', 'guestFQDN': 'str'}}

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

*   External providers - In add external provider dialog, there will be need to add IPv6 validation to:
    -   General -> Provider URL
    -   Set Network plugin to Open vSwitch or Linux Bridge -> Agent Configuration -> Host

<!-- -->

*   network address in Setup Host Network -> edit network -> boot protocol: static :
    -   IP
    -   subnet mask - in IPv4 subnet mask has form of doted decimal number, same as IPv4 address. In IPv6 subnet is made of single number from 0-128 that describes the number of bits from start that belongs to site. Mostly here will be numbers 64/56/48.
    -   gateway - regular IPv6 address

![](Ipv6 edit management network.png "Ipv6 edit management network.png")

*   address of nics in network interfaces - add column for IPv6 address

![](Ipv6 network interfaces.png "Ipv6 network interfaces.png")

*   add/import storage address

![](Ipv6 new domain storage.png "Ipv6 new domain storage.png")

There is also need to say that each nic which we address have more than one IPv6 address, therefore we should enable inserting multiple addresses.

Interesting attribute of address is its scope. The scope can be determined from the address. There stays a question if we want explicitly tell user the scope of address or it is redundant information to him.

### REST API

REST API now contains record "ip" and it already has attribute "version". Record "ip" is present in next records:

*   ips - container of "ip"
*   Network
*   HostNic

For both Network and HostNic should be used rather "ips" so it can contain multiple addresses with selected version.

Records that contains "address" as string, should be tested if works with IPv6:

*   Agent
*   PowerManagement
*   Host
*   NfsStorage
*   IscsiTarget
*   Display

Records that contains "href" as string, should be tested if works with IPv6:

*   Link
*   BaseResource
*   RSDL

### Changes in code

#### Vdsm

*   New class 'netmodels.IPv6'. Similar like netmodels.IPv4, for address validation and representation
    -   This brings changes in class netmodels.IpConfig, configNetwork.objectivizeNetwork
*   Ifcfg files have to have IPv6 capabilities as are described here <http://www.cyberciti.biz/faq/rhel-redhat-fedora-centos-ipv6-network-configuration/>
    -   ifcfg.ConfigWriter._createConfFile(),
*   Iproute2 configurator (http://gerrit.ovirt.org/#/c/15301/) looks like there shouldn't be made any changes?
*   jsonrpc: make TCPReactor IPv6 capable
    -   <http://gerrit.ovirt.org/#/c/11740>
*   jsonRpcUtils
    -   jsonRpcUtils.getFreePort() [AF_INET and 0.0.0.0],
    -   jsonRpcUtils._tcpServerConstructor() [there should be distinction of using 'localhost' and localhost6]
    -   jsonRpcUtils._protonServerConstructor()[127.0.0.1]

##### VDSM tests

There will be need to change/extend tests in tests/:

*   configNetworkTests.py - try to create only IPv6 network/nics, IPv4 and IPv6
*   guestIFTests.py - added att4ribute guestIPv6s
*   jsonRpcUtils.py - extend with IPv6 addresses, where IPv4 is used
*   netmodelsTests.py - testIsIpv6valid, testIsNetmaskIPv6valid

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

1.  Test functionality of newly added attributes to @NetworkOptions, @SetupNetworkNetAttributes, @RunningVmStats
2.  Test that every api schema that can contain IP address, can contain IPv6 address. Listed in [#Vdsm api](#Vdsm_api) Records that DOES NOT need change.
3.  Test functionality of IPv6 related fields. Listed in [#Vdsm api](#Vdsm_api) Records that already contains IPv6 fields.

#### Ovirt-Engine GUI

1.  Test that to every address field can be inserted IPv6 address. Test every form of IPv6 address: full form, omited leading zeros, changed group of zeros (https://en.wikipedia.org/wiki/IPv6_address#Presentation).
2.  Test every combination of Edit Network, every boot protocol with combination of IPv6 or IPv4 addresses. There should always be selected at least one protocol, otherwise the error should raise.

#### REST API

1.  Check that record "Network" and "HostNic" contains "ips", that every "ip" has selected proper "version" and all IPs are listed.
2.  Check that every records with "address" or "href" properly handle IPv6 format.

### Comments and Discussion

#### Open questions

*   Should we provide option to add more than one IPv6 address to Edit Network static configuration? Is it possible to use with parameter in IPV6ADDR_SECONDARIES in ifcfg <http://www.cyberciti.biz/faq/redhat-centos-rhel-fedora-linux-add-multiple-ip-samenic/>
*   What is the meaning of having both IPv4 AND IPv6 address for the same network? E.g., if this is a migration network, which of the addresses should qemu use?
*   How to handle multiple gateways with IPv6? Currently the sourceRoute.py code assumes IPv6, and our understanding of IPv6 routing is poor.

#### Discussion

On the arch@ovirt.org mailing list.

<Category:Feature>
