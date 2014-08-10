---
title: NetworkingApi
category: api
authors: moti
wiki_category: Networking
wiki_title: Features/NetworkingApi
wiki_revision_count: 17
wiki_last_updated: 2014-09-03
---

# Networking Api

## Using oVirt Networking API

The following are request samples of the [host networking api](Features/HostNetworkingApi).

### Add network to a network interface

POST to /api/hosts/{host:id}/nics/{nic:id}/networkconnections

` `<networkconnection>
`   `<network id="..."/>
`   `<boot_protocol>`dhcp`</boot_protocol>
` `</networkconnection>

### Remove a network from a network interface

DELETE to /api/hosts/{host:id}/nics/{nic:id}/networkconnections/{networkconnection:id}

### Change boot protocol of a network configured on a network interface

UPDATE to /api/hosts/{host:id}/nics/{nic:id}/networkconnections/{networkconnection:id}

` `<networkconnection>
`   `<boot_protocol>`static`</boot_protocol>
`   `<ip address="10.0.0.15" netmask="255.255.255.0" gateway="10.0.0.254"/>
` `</networkconnection>

### Add a vlan network to a network interface

POST to /api/hosts/{host:id}/nics/{nic:id}/networkconnections

` `<networkconnection>
`   `<network id="..."/>
` `</networkconnection>

Where nic:id represents a nic or a bond and the network id refers to a vlan network.
Many requests could be followed with a different vlan networks to the same base interface.

### Create a bond device

POST to /api/hosts/{host:id}/nics

` `<host_nic>
`   `<name>`bond0`</name>
`   `<bonding>
`     `<options>
`       `<option name="mode" value="1" type="Active-Backup"/>
`       `<option name="miimon" value="100"/>
`     `</options>
`     `<slaves>
`       `<host_nic id="833ebaeb-0988-4bd5-b860-e00bcc3f576a"/>
`       `<host_nic id="782e8199-984e-407f-b242-3d6c7dc2f7b7"/>
`     `</slaves>
`   `</bonding>
` `</host_nic>

Where slaves can be identified by id or by name (as long as they are nics).

### Delete bond device

DELETE to /api/hosts/{host:id}/nics/{nic:id}
where nic:id represents the bond device. Any network connection configured on the bond will be removed.

### Adding a slave to a bond and change bonding options

PUT to /api/hosts/{host:id}/nics/{nic:id}

` `<host_nic>
`   `<name>`bond0`</name>
`   `<bonding>
`     `<options>
`       `<option name="mode" value="2"/>
`     `</options>
`     `<slaves>
`       `<host_nic id="aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa"/>
`       `<host_nic id="bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb"/>
`       `<host_nic id="cccccccc-cccc-cccc-cccc-cccccccccccc"/>
`     `</slaves>
`   `</bonding>
` `</host_nic>

Where nic:id represents an existing bonding device.

### Move a network from one network interface to another

Shares the same semantics as setupNetorks, except instead of specifying the network element, a network connections should be provided.
POST to /api/hosts/{host:id}/nics/setupnics

` `<host_nics>
`   `<host_nic id="11111111-1111-1111-1111-111111111111">
`     `<networkconnections>
`       `<networkconnection>
               ...
`       `</networkconnection>
`       `<networkconnection>
               ...
`       `</networkconnection>
`     `</networkconnections>
`   `</host_nic>
`   `<host_nic id="22222222-2222-2222-2222-222222222222"/>
` `</host_nics>

Where the network is being moved from the second nic to the first.

### Break bond and configure its networks among its slaves

Configuration prior to the request:

       eth0 (22222222-2222-2222-2222-222222222222) ---|                                                    |-- network aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa
                                                      +--- bond0 (11111111-1111-1111-1111-111111111111) ---+
       eth1 (33333333-3333-3333-3333-333333333333) ---|                                                    |-- network bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb

` `<host_nics>
`   `<host_nic id="11111111-1111-1111-1111-111111111111">
`     `<name>`bond0`</name>
`     `<bonding>
`       `<options>
`         `<option name="mode" value="2"/>
`       `</options>
`     `<slaves>
`       `<host_nic id="22222222-2222-2222-2222-222222222222"/>
`       `<host_nic id="33333333-3333-3333-3333-333333333333"/>
`     `</slaves>
`     `<networkconnections>
`       `<networkconnection>
`         `<network id="aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa"/>
`       `</networkconnection>
`       `<networkconnection>
`         `<network id="bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb"/>
`       `</networkconnection>
`     `</networkconnections>
`   `</host_nic>
` `</host_nics>

Desired configuration after the request:

       eth0 (22222222-2222-2222-2222-222222222222) ---- network aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa
       eth1 (33333333-3333-3333-3333-333333333333) ---- network bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb

POST to /api/hosts/{host:id}/nics/setupnics

` `<host_nics>
`   `<host_nic id="22222222-2222-2222-2222-222222222222">
`     `<networkconnections>
`       `<networkconnection>
`         `<network id="aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa"/>
`       `</networkconnection>
`     `</networkconnections>
`   `</host_nic>
`   `<host_nic id="33333333-3333-3333-3333-333333333333"/>
`     `<networkconnections>
`       `<networkconnection>
`         `<network id="bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb"/>
`       `</networkconnection>
`     `</networkconnections>
`   `</host_nic>
` `</host_nics>

### Removing all networks from a nic

The empty network connections element *<networkconnections />* mean no network connections will be configured on the nic.
In the next example any network connection which was configured on nic 22222222-2222-2222-2222-222222222222 will be removed. POST to /api/hosts/{host:id}/nics/setupnics

` `<host_nics>
`   `<host_nic id="22222222-2222-2222-2222-222222222222">
`     `<networkconnections />
`   `</host_nic>
` `</host_nics>

### Equivalent setupnics requests

In the example below we assume to have a single nic with a single network connections configured on top of it:

sending the existing network connections:

` `<host_nics>
`   `<host_nic id="33333333-3333-3333-3333-333333333333"/>
`     `<networkconnections>
`       `<networkconnection>
`         `<network id="bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb"/>
`       `</networkconnection>
`     `</networkconnections>
`   `</host_nic>
         ...
` `</host_nics>

is equivalent to not sending the network connections element:

` `<host_nics>
`   `<host_nic id="33333333-3333-3333-3333-333333333333"/>
`   `</host_nic>
         ...
` `</host_nics>

is equivalent to not sending the interface:

` `<host_nics>
         ...
` `</host_nics>
