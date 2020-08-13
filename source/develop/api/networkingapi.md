---
title: NetworkingApi
category: api
authors: moti
---

# Networking Api

## Using oVirt Networking API

The following are request samples of the [host networking api](/develop/release-management/features/network/hostnetworkingapi.html).

### Add network to a network interface with DHCP boot protocol

POST to /api/hosts/{host:id}/nics/{nic:id}/networkattachments

` `<network_attachment>
`   `<network id="..."/>
`   `<ip_configuration>
`     `<ipv4s>
`       `<ipv4>
               `<boot_protocol>`DHCP`</boot_protocol>` 
`       `</ipv4>
`     `</ipv4s>
`   `</ip_configuration>
` `</network_attachment>

### Remove a network from a network interface

DELETE to /api/hosts/{host:id}/nics/{nic:id}/networkattachments/{networkattachment:id}

### Change boot protocol of a network configured on a network interface

PUT to /api/hosts/{host:id}/nics/{nic:id}/networkattachments/{networkattachment:id}

` `<network_attachment>
`   `<ip_configuration>
`     `<ipv4s>
`       `<boot_protocol>`static`</boot_protocol>
`       `<ipv4>
`         `<primary>`true`</primary>
               

<address>
10.0.0.15

</address>
               `<netmask>`255.255.255.0`</netmask>` 
`         `<gateway>`10.0.0.254`</gateway>
`       `</ipv4>
`     `</ipv4s>
`   `</ip_configuration>
` `</network_attachment>

### Add a vlan network to a network interface

POST to /api/hosts/{host:id}/nics/{nic:id}/networkattachments

` `<network_attachment>
`   `<network id="..."/>
` `</network_attachment>

Where nic:id represents a nic or a bond and the network id refers to a vlan network.
Many requests could be followed with a different vlan networks to the same base interface.

### Sync network on a network interface

PUT to /api/hosts/{host:id}/nics/{nic:id}/networkattachments/{networkattachment:id}

` `<network_attachment>
`   `<override_configuration>`true`</override_configuration>
` `</network_attachment>

Where networkattachment:id is associated with the out-of-sync network.
Sync network can be achieved also via the setup nics, using the same override_configuration element.

### Create a bond device

POST to /api/hosts/{host:id}/nics Where slaves can be identified either by id or by name (as long as they are nics).

` `<host_nic>
`   `<name>`bond0`</name>
`   `<link_aggregation>
`     `<options>
             
`       `<option>
`         `<name>`module`</name>
`         `<value>`bonding`</value>
`       `</option>
             
`       `<option>
`         `<name>`mode`</name>
`         `<value>`1`</value>
`         `<type>`Active-Backup`</type>
`       `</option>
`       `<option>
`         `<name>`miimon`</name>
`         `<value>`100`</value>
`       `</option>
`     `</options>
`     `<slaves>
`       `<host_nic id="833ebaeb-0988-4bd5-b860-e00bcc3f576a"/>
`       `<host_nic id="782e8199-984e-407f-b242-3d6c7dc2f7b7"/>
`     `</slaves>
`   `</link_aggregation>
` `</host_nic>

### Delete bond device

DELETE to /api/hosts/{host:id}/nics/{nic:id}
where nic:id represents the bond device. Any network attachment configured on the bond will be removed.

### Adding a slave to a bond and change bonding options

PUT to /api/hosts/{host:id}/nics/{nic:id}

` `<host_nic>
`   `<name>`bond0`</name>
`   `<bonding>
`     `<options>
`       `<option>
`         `<name>`mode`</name>
`         `<value>`2`</value>
`       `</option>
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

Shares the same semantics as setupNetorks, except instead of specifying the network element, a network attachments should be provided.
PUT to /api/hosts/{host:id}/networkattachments/{networkattachment:id}

` `<network_attachment>
         `<host_nic id="target-nic-id" />`  
` `</network_attachment>

Or by POST to /api/hosts/{host:id}/setupnetworks

` `<action>
`     `<network_attachments id="...">
`         `<host_nic id="target-nic-id" />
`     `</network_attachments>
       `</action>`  

### Create bond and configure networks

Configuration prior to the request:

       eth0 ---- network aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa
       eth1 ---- network bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb

Desired configuration after the request:

       eth0 ---|             |-- network aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa
               +--- bond0 ---+
       eth1 ---|             |-- network bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb

POST to /api/hosts/{host:id}/setupnetworks

` `<action>
`   `<bonds>
`     `<host_nic>
`       `<name>`bond0`<name>
`       `<link_aggregation>
`         `<options>
`           `<option>
`             `<name>`module`</name>
`             `<value>`bonding`</value>
`           `</option>
`           `<option>
`             `<name>`mode`</name>
`             `<value>`1`</value>
`             `<type>`Active-Backup`</type>
`           `</option>
`           `<option>
`             `<name>`miimon`</name>
`             `<value>`100`</value>
`           `</option>
`         `</options>
`         `<slaves>
`           `<host_nic>
`             `<name>`eth0`<name>
`           `</host_nic>
`           `<host_nic>
`             `<name>`eth1`<name>
`           `</host_nic>
`         `</slaves>
`       `</link_aggregation>
`     `</host_nic>
`   `</bonds>
`   `<network_attachments>
`     `<network_attachment>
`       `<network id="aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa"/>
`       `<host_nic>
`         `<name>`bond0`<name>
`       `</host_nic>
`     `</network_attachment>
`     `<network_attachment>
`       `<network id="bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb"/>
`       `<host_nic>
`         `<name>`bond0`<name>
`       `</host_nic>
`     `</network_attachment>
`   `</network_attachments>
       `</action>`  

### Break bond and configure its networks among its slaves

Configuration prior to the request:

       eth0 ---|             |-- network aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa
               +--- bond0 ---+
       eth1 ---|             |-- network bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb

Desired configuration after the request:

       eth0 ---- network aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa
       eth1 ---- network bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb

POST to /api/hosts/{host:id}/setupnetworks

` `<action>
`     `<network_attachments>
`       `<network_attachment>
`         `<network id="aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa"/>
`         `<host_nic>
`           `<name>`eth0`<name>
`         `</host_nic>
`       `</network_attachment>
`       `<network_attachment>
`         `<network id="bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb"/>
`         `<host_nic>
`           `<name>`eth1`<name>
`         `</host_nic>
`       `</network_attachment>
`     `</network_attachments>
`     `<removed_bonds>
`       `<host_nic>
`         `<name>`bond0`<name>
`       `</host_nic>
           `<removed_bonds>` 
       `</action>`  

or alternatively use the network attachment id:

` `<action>
`     `<network_attachments>
`       `<network_attachment  id="...">
`         `<host_nic>
`           `<name>`eth0`<name>
`         `</host_nic>
`       `</network_attachment>
`       `<network_attachment id="...">
`         `<host_nic>
`           `<name>`eth1`<name>
`         `</host_nic>
`       `</network_attachment>
`     `</network_attachments>
`     `<removed_bonds>
`       `<host_nic>
`         `<name>`bond0`<name>
`       `</host_nic>
           `<removed_bonds>` 
` `</action>

### Removing networks from a host

POST to /api/hosts/{host:id}/setupnetworks

` `<action>
`   `<removed_network_attachments>
`     `<network_attachment id="..."/>
`     `<network_attachment id="..."/>
`     `<network_attachment id="..."/>
`   `</removed_network_attachments>
` `</action>

