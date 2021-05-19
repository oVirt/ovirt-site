---
title: HostNetworkingApi
category: feature
authors: danken, mmucha, moti, sandrobonazzola
---

# Host Networking Api

### Owner

*   Name: Moti Asayag (masayag)
*   Email: masayag@redhat.com

## Current Status

The current host networking api (up to ovirt-engine-3.6) suffers from various limitations:

*   A mix of the physical and the logical network configuration
    -   Exposing vlan device implementation to the user
    -   Using 'Sync Network' feature requires to find the specific interface which carries the network
*   A Cumbersome request format for 'setup networks':
    -   creating vlan devices
    -   a complex input structure to represent the expected configuration
*   The attach/detach network isn't the RESTFul way to modify the interface
*   Cannot support a host only network (a network without a nic)
    -   Cannot support a dynamic (external) networks

## Proposed Solution

Introduce **`<network_attachment>`** element which describes how the network is configured on the host:

```xml
 <network_attachment>
   <network/>
   <host_nic/>
   <ip_address_assignments/>
   <properties/>
    <reported_configurations>
     <in_sync>false</in_sync>
     <reported_configuration>
       <name>mtu</name>
       <value>9000</value>
       <in_sync>false</in_sync>
     </reported_configuration>
     <reported_configuration>
       <name>bridged</name>
       <value>false</value>
       <in_sync>false</in_sync>
     </reported_configuration>
     <reported_configuration>
       <name>200</name>
       <value>false</value>
       <in_sync>false</in_sync>
     </reported_configuration>
   </reported_configurations>
 </network_attachment>
```

*   network - which logical network is connected to the host
*   host_nic - an optional sub-element which described the underlying interface
    -   When not provided, implies the network is a nic-less network (not supported in 3.6)
    -   Can specify an unused nic or a bond (either existing bond or bond to create from unused nics).
*   ip_address_assignments - the ip configuration (ipv4/ipv6, boot protocol and addresses)
*   properties - network custom properties
*   reported_configuration - read-only element, returned *only* when the network is out-of-sync with the logical network definition, listing the specific out-of-sync properties.

The **`ip_address_assignments`** representation is:

```xml
 <ip_address_assignments>
   <ip_address_assignment>
           <assignment_method>STATIC</assignment_method> 
             
     <ip address="…" netmask="…" gateway ="…"/>
   </ip_address_assignment>
   <ip_address_assignment>
           <assignment_method>STATIC</assignment_method> 
     <ip address="…" netmask="…" gateway ="…"/>
     <ip>
   </ip_address_assignment>
       
         
   <ip_address_assignment>
           <assignment_method>STATIC</assignment_method> 
     <ip address="…" netmask="…" gateway ="…" version="6"/>
   </ip_address_assignment>
 <ip_address_assignments>
```

A new **`link_aggregation`** element is added to abstract the implementation:

```xml
   <link_aggregation>
     <options>
             
       <option>
         <name>module</name>
         <value>bonding</value>
       </option>
       <option>
         <name>mode</name>
         <value>1</value>
         <type>Active-Backup</type>
       </option>
       <option>
         <name>miimon</name>
         <value>100</value>
       </option>
     </options>
     <slaves>
       <host_nic id="833ebaeb-0988-4bd5-b860-e00bcc3f576a"/>
       <host_nic id="782e8199-984e-407f-b242-3d6c7dc2f7b7"/>
     </slaves>
   </link_aggregation>
```

The link_aggregation element will be used from within the host_nic element for bonding devices.

#### Network attachments sub-collection of the nic resource

*   A collection of network attachments that are attached to a specific physical interface or a bond:

       `/api/hosts/{host:id}/nics/{nic:id}/networkattachments`

*   Supported actions:
    1.  **GET** returns a list of networks attached to the nic
    2.  **POST** attaches a network to the nic

#### Setupnetworks API of the host resource

*   A multi-network configuration action to support complex network settings (i.e. cross nics actions: move network from one nic to another or create network on bond)

       `/api/hosts/{host:id}/setupnetworks`

*   Supported actions:
    -   **POST** - expects a relative change to be applied on the host, using *PATCH* behaviour.
*   Request structure:

```xml
 <action>
   <modified_bonds />
         <removed_bonds />
   <modified_network_attachments />
   <synchronized_network_attachments/>
   <removed_network_attachments />
   <check_connectivity />
   <connectivity_timeout />
 </action>
```

*   modified_bonds - describes bonds to create or to update, those bonds could be referred by name from the network_attachment element
*   removed_bonds - id list of bonds to be removed
*   modified_network_attachments - describes which networks should be configured (added or updated) on the host.
    -   When host nic is provided, the network will be configured on it
    -   When host nic is omitted, the network will be configured as a nicless network (not supported in 3.6)
    -   When a nic is changed, the network will be reconfigured on the new nic (move network from nic to nic). Network id cannot be changed from one to another as a part of update. Network can be identified by id or name just like bond.
*   removed_network_attachments - id list of network attachments to remove
*   synchronized_network_attachments - network attachment list to be synchronized with nic

#### Network attachment resource under nic

  `/api/hosts/{host:id}/nics/{nic:id}/networkattachments/{networkattachment:id}`

*   Supported actions:
    1.  **GET** - returns a specific network attachment; attaches network to the nic, when nic id is provided.
    2.  **DELETE** - deletes network attachment; detaches a network from the nic
    3.  **PUT** - updates the network network attachment

#### Network statistics sub-collection (optional)

  `/api/hosts/{host:id}/nics/{nic:id}/networkattachments/{networkattachments:id}/statistics`

*   Supported actions:
    1.  **GET** returns a specific statistics for a network attachment(if reported) which is attached to the nic

<!-- -->

*   We can implement a new API in this context to reflect the total rx/tx instead of a processed measurements.

#### Host Network attachments sub-collection

Introducing new sub-collections to reflect the host network configuration:

*   A collection of network attachments which represent how the network is provisioned on the host

  `/api/hosts/{host:id}/networkattachments`

*   Supported actions:
    1.  **GET** returns a list of networks attachments configured on the host
    2.  **POST** provision a network on the host

Where the networkattachment element will omit the host_nic element from the request. If provided, must be in sync with one provided on URL path

#### Host Network attachment resource

  `/api/hosts/{host:id}/networkattachments/{networkattachment:id}`

*   Supported actions:
    1.  **GET** returns a specific network configured on the host
    2.  **PUT** Update a network configured on the host, where modifying the nic indicates network will be configured on the new network device.
    3.  **DELETE** removes a network from the host

## Current Host Networking API (up to ovirt-engine-3.5)

  `/api/hosts/{host:id}/nics`

*   **GET** - list of network interfaces (GetVdsInterfacesByVdsId)
*   **POST** - creates a bond (AddBond)

  `/api/hosts/{host:id}/nics/setupnetworks`

*   **POST** - performs setup networks action (SetupNetworks)

  `/api/hosts/{host:id}/nics/{nic:id}`

*   **GET** - gets a specific network interface (GetVdsInterfacesByVdsId)
*   **DELETE** - removes a bond (RemoveBond)
*   **PUT** - updates a network which is attached to the specific network interface, aka mini-setup networks (UpdateNetworkToVdsInterface)

  `/api/hosts/{host:id}/nics/{nic:id}/attach`

*   **POST** - adds a network to a nic (AttachNetworkToVdsInterface)

  `/api/hosts/{host:id}/nics/{nic:id}/detach`

*   **POST** - removes a network from a nic (DetachNetworkFromVdsInterface)

  `/api/hosts/{host:id}/nics/{nic:id}/statistics`

*   **GET** - list the statistics of the specific network interface

Network labels related actions are listed at [Features/NetworkLabels#REST](/develop/release-management/features/network/networklabels.html#rest).

## What should be deprecated?

*   The *network* element in host_nic is replaced by *networkattachments* subcollection:

  `/api/hosts/{host:id}/nics/{nic:id}`

```xml
 <host_nic>
   <network />
 </host_nic>
```

is replaced by:

  `/api/hosts/{host:id}/nics/{nic:id}/networkattachments`

```xml
<network_attachments/>
```

The vlan devices will be hidden from the list of /api/hosts/{host:id}/nics and will be represented as a *networkattachment* element of the underlying nic.

*   Deprecated: `/api/hosts/{host:id}/nics/setupnetworks`

```xml
 <host_nics>
   <host_nic>
     <network id="..."/>
   </host_nic>
 </host_nics>
```

*   Is replaced by: `/api/hosts/{host:id}/hostsetupnetworks`

{% highlight xml %}
     <modified_network_attachments>
           ...
     </modified_network_attachments>
{% endhighlight %}

Request should contain only nics or bonds (no vlans).

*   Deprecated Host nics actions:

    `/api/hosts/{host:id}/nics/{nic:id}/attach`
    is replaced by **POST** request to 
    `/api/hosts/{host:id}/nics/{nic:id}/networkattachments`

and:

   `/api/hosts/{host:id}/nics/{nic:id}/detach`
   is replaced by **DELETE** request to:
   `/api/hosts/{host:id}/nics/{nic:id}/networkattachments/{networkattachment:id}`

*   Updating network interface

   **PUT** on `/api/hosts/{host:id}/nics/{nic:id}/`
   the action semantics is changed to edit bond only

is replaced by

   **PUT** on `/api/hosts/{host:id}/nics/{nic:id}/networkattachments/{networkattachment:id}`

## Behaviour Change

Since the Network Attachment is the entity for describing a network attachment to the host, and it requires to be associated to an existing network on the data-center, unmanaged networks handling will be done differently than <= ovirt-engine 3.5.
 Unmanaged networks are networks which are reported by vdsm (hence those networks are reported by libvirt and have the expected prefix of "vdsm-"), but are not identified as networks on the cluster on which the host resides.

