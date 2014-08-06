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
