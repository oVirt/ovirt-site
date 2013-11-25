---
title: Detailed Host Network QoS
category: feature
authors: amuller, apuimedo, danken, lvernia
wiki_category: Feature
wiki_title: Features/Detailed Host Network QoS
wiki_revision_count: 52
wiki_last_updated: 2015-02-01
---

# Detailed Host Network QoS

## Host Network QoS - Detailed

#### Summary

This feature provides means by which to control the traffic of a specific network through a host's physical interface. It is a natural extension of the [VM Network QoS](Features/Network_QoS) feature, which provided the same functionality for a VM network through a VM's virtual interface.

You may also refer to the [simple feature page](Features/Host_Network_QoS).

#### Owner

*   Name: Lior Vernia (previously owned by Giuseppe Vallarelli)
*   E-mail: lvernia@redhat.com
*   IRC: lvernia at #ovirt (irc.oftc.net)

#### Current Status

*   Target Release: 3.4
*   Status: design
*   Last updated: November 24th, 2013.

#### Detailed Description

Generally speaking, network QoS (Quality of Service) in oVirt could be applied on a variety of different levels:

*   VM - control the traffic passing through a virtual NIC (virtual Network Interface Controller).
*   Host - control the traffic from a specific network passing through a physical NIC.
*   DC (Data Center) - control the traffic related to a specific logical network throughout the entire DC, including through its infrastructure (e.g. L2 switches).

The VM level was taken care of as part of the [VM Network QoS](Features/Network_QoS) feature in oVirt 3.3, whereas this feature aims to take care of the host level in a similar manner; it will be possible to cap bandwidth usage of a specific network on a specific network interface of a host, both for average usage and peak usage for a short period of time ("burst"), so that no single network could "clog" an entire physical interface.

DC-wide QoS remains to be handled in the future.

Implementation-wise, we could take one of two different approaches:

*   Proceed with the VM Network QoS paradigm, that is creating Network QoS entities that can be shared between different networks - let's refer to this as "named" QoS. The advantages here are that the administrator is accustomed to the same QoS usage flow across VM and host networking, and that a few QoS configurations could be easily shared by many instances of networks on host interfaces. This also requires very little changes to the existing code, rendering it easier to implement. However, this leads to a non-trivial relationship between host network entities and QoS entities, giving rise to inconvenient questions such as what happens when a QoS entity, that had been attached to any host networks, is updated. A further disadvantage is the awkwardness of the process of defining QoS on a host network when a fitting QoS entity doesn't yet exist, which would force the user to change context to create a new QoS entity first; this could however be relieved in several different ways, discussed below.
*   Define QoS parameters directly on the host's interfaces when networks are attached to them (similarly to boot protocol, for example) - let's refer to this as "anonymous" QoS. The advantage in this approach is when there's a low amount of hosts and host NICs, and their QoS configurations differ (i.e. there's not much value in sharing the configurations), configuring the NICs directly will save the extra step of defining the QoS entities. This also greatly simplifies the relation between host network entities and QoS entities, but at the cost of not being able to share the same QoS configuration between different instances of networks attached to host interfaces. This last disadvantage could be offset by either a Host Template feature (if that is introduced in the near future), or by enabling to configure QoS on the DC-wide network entity which will be applied by default to any host interface the network is attached to (although it might not be clear that that's the significance of defining QoS on the DC-wide network entity, and it could be easily confused with the VM-related QoS defined on the same network's vNIC Profile).

It is also possible to take on a hybrid approach, where users could EITHER configure an "anonymous" QoS on a host network OR attach a pre-existing QoS entity.

##### Entity Description

No new entities need to be implemented, but some entities will have to be changed, depending on the general approach taken. VdsNetworkInterface (persisted in the vds_interface table) should be changed to include at least a NetworkQoS GUID member (foreign key to the network_qos table), that states what QoS configuration is attached to that interface (null would mean unlimited). It might be preferable though to also hold the QoS parameters retrieved from VDSM; these could then be compared with the definition of the attached QoS, thereby checking if the QoS configuration is "in sync" (similarly to what is done with networks). If the QoS configuration is out-of-sync, the host network itself would also be marked as out-of-sync.

If the "anonymous" QoS approach is taken, then it is not clear that the QoS configuration should be saved in the network_qos table and referenced by an ID foreign key - it might be preferable to add the six relevant columns to the vds_interface table. However, that would greatly increase the size of the table, especially if an additional six columns are to be added to hold the QoS reported by VDSM. It would also require to maintain these additional columns in parallel to the network_qos table, as the NetworkQoS evolves in the future. All things considered, it might be better to persist all NetworkQoS entity in their own table, with "anonymous" QoS entities being created with a null name whenever users QoS on host networks; these would not be accessible directly to the user (i.e. from the DC context), they could only be edited or dropped through updating the QoS configuration on the corresponding host network.

NetworkQoS could either be changed to include a type (i.e. VM QoS or Host QoS) or not. The question is whether these two types could actually be different or not, and therefore if there's good reason to not enable one NetworkQoS configuration to be shared by both VMs and hosts. Even if in the future some features would be implemented first for, say, VM QoS and not for host QoS, it would probably be okay to just not apply the feature-specific parameters when the NetworkQoS entity is attached to a host's network. Either way we go, if we change our mind in the future the upgrade script would be reasonably straightforward:

*   Going from typeless to typed, each typeless NetworkQoS entity could be copied to a new typed one with an identical name according to the entities using it. If both types use it, two copies will made, one for each type. If no entity uses it, any behavior would be fine (but removing it would probably be cleanest).
*   Going from typed to typeless, each typed NetworkQoS entity would be duplicated as typeless by the same name. Here a problem would arise if a NetworkQoS by the same name existed for each type, in which case we would need some name generating algorithm.

Since at the moment there's no apparent reason to differentiate between VM and host QoS, and seeing as the upgrade script is simpler moving from typeless to typed (the price of an error is lower), the preference should probably be to stick with typeless NetworkQoS entities that may be shared by VM and host networks.

##### VDSM

Proposed [vdsm api](http://gerrit.ovirt.org/#/c/15724/) allows to provide traffic shaping parameters as part of NetworkOptions or setupNetworkNetAttributes used respectively by the addNetwork and setupNetworks verbs. In order to apply the configuration on the host network the Engine should convert attributes' values from Mb to kb (Megabit to Kilobit). VDSM generates a similar libvirt xml definition.

        `<network>`                                          
`    `<name>`vdsm-FinalAnswer`</name>
          ...
`    `<bandwidth>
`      `<inbound average='30000' burst='200000'  peak='40000'/>
`      `<outbound average='30000' burst='200000'  peak='40000' />
`    `</bandwidth>
`  `</network>

Example vdscli:

    from vdsm import vdscli
    connection = vdscli.connect()
    connection.addNetwork('whatever', '', '', ['p1p4'], {'qosInbound':{'average': '10000', 'burst': '48000', 'peak':'12000' }})

It's possible to retrieve the QoS defined for an host's network with the following code:

    from vdsm import vdscli
    connection = vdscli.connect()
    connection.getVdsCapabilities()['info']['networks']['whatever']

the expected result should be something similar to:

    {'addr': '',
     'bridged': True,
     'cfg': {'DELAY': '0',
             'DEVICE': 'goofy',
             'NM_CONTROLLED': 'no',
             'ONBOOT': 'yes',
             'TYPE': 'Bridge'},
     'gateway': '0.0.0.0',
     'iface': 'goofy',
     'ipv6addrs': ['fe80::210:18ff:fee1:6d2a/64'],
     'ipv6gateway': '::',
     'mtu': '1500',
     'netmask': '',
     'ports': ['p1p2'],
     'qosInbound': {'average': '10000' , 'burst': '48000', 'peak': '12000'},
     'qosOutbound': '',
     'stp': 'off'}

##### RESTful API

As part of the VM Network QoS feature, no API was defined for the DC-level QoS entities, for various reasons. If the "named" QoS entity paradigm is preserved in this feature, I do not see any reason to hurry the process and force the definition of that API. However, if the "anonymous" QoS approach is taken, the values that define the QoS entity could be passed in the Setup Networks command as part of the NIC properties.

##### User Experience

Since the Host Network QoS is only relevant in the context of a specific host interface (i.e. it could have completely different a QoS setup on each host interface), the most natural place to configure it would be when editing a network attached to a host interface, similarly to boot protocol configuration. This is accessible through the "Setup Host Networks" dialog, and clicking the "Edit" icon that appears when hovering over a specific network attached to an interface. Following is a short discussion of how QoS would be configured in that dialog; screenshots will be added soon...

If the "named" QoS approach is taken, the straightforward thing to do would be to add a list box to the dialog, where users could choose one of the pre-configured Network QoS entities in the DC. However, we would like to enable users to also create a new Network QoS entity from this dialog, in case they had neglected to create a fitting QoS configuration beforehand (through the DC/QoS subtab). To this end, I suggest two alternatives: ![ thumb | Overlaid "Add Network QoS" dialog.](New_qos.jpg  "fig: thumb | Overlaid "Add Network QoS" dialog.")

*   Couple to the list box a Network QoS widget similar to the one that appears in the "Add/Edit Network QoS" dialog (where the parameters of the QoS configuration are input). When one of the pre-existing, suggested QoS names is selected, the QoS widget will be filled with the details of that QoS configuration, but will appear disabled. The list box would also hold a "Custom" option, and whenever that is chosen the widget will become enabled and users will be able to change its values. Another UI field will be required to input the name of the new QoS entity. Upon pressing "OK" in the underlying "Setup Host Networks" dialog, the new QoS entity/entities will be created and attached to the proper network(s) on the host.
*   We could add a button that would allow users to create a new QoS entity. Pressing on this button will open the same "Add Network QoS" dialog as in the DC/QoS subtab, and upon creation of a new QoS entity through it, it will be added to the list box.

The disadvantage of the first alternative is that the Network QoS widget is quite big and might not fit well in that small dialog, while the disadvantage of the second alternative is that we would end up with 3 dialogs layered on top of another (which as I recall is unprecedented in oVirt). The best solution might be to go with the first alternative, and place the entire QoS configuration in a dedicated tab in the dialog. The widget could also be redesigned in a "fancier" manner, to appear less intimidating.

If the "anonymous" approach is taken, then it is only required to somehow incorporate the QoS widget into the "Edit Host Network" dialog, for example like this (again, fancier possibilities exist):

![](Ledit_network.png "Ledit_network.png")

##### User Work-flows

If the "named" QoS approach is taken, the standard work-flow for an administrator to configure QoS on a host network would be as follows:

*   Create a new Network QoS entity in the DC/QoS subtab.
*   Head to the Host/Interfaces subtab and click on the "Setup Host Networks" button.
*   Edit the desired network, by clicking the "Edit" icon when hovering over the network (which has to be attached to an interface).
*   In the dialog that opens, choose the pre-configured Network QoS entity by its name.

If the "anonymous" QoS approach is taken (or the "named" approach is implemented to allow this), the flow would be as follows:

*   Start from the "Setup Host Networks" dialog.
*   Edit the desired network.
*   Create a new Network QoS entity from the dialog that opens (in whatever way is agreed-upon, among the alternatives discussed above).

#### Comments and Discussion

On the arch@ovirt.org and users@ovirt.org mailing lists.

#### Open Issues

The following are what seem to be the talking points arising from the above description:

*   Should Host Network QoS be configured similarly to VM Network QoS by creating shareable entities, or should "anonymous" QoS be configured on networks attached to host interfaces? Keep in mind that "anonoymous" QoS could possibly be shared by multiple hosts in the future using a Host Template.
    -   If the VM Network QoS paradigm is preserved:
        -   What is the proper behavior when a QoS entity, that had been attached to host networks, is updated?
        -   Should Network QoS entities have a type associated with them (VM/host)?
    -   If the "anonymous" approach is taken (or a hybrid approach), where should QoS configuration be persisted? In the network_qos table without a name, or as part of the vds_interface table?
*   Should the QoS configuration on the host be reported by VDSM and compared to the configuration in the engine, as part of the "out-of-sync" mechanism?
*   The UX design of the feature:
    -   If we allow configuring a new "named" QoS entity from the "Edit Host Network" dialog, should it be in a new dialog or an integrated widget?
    -   Should a QoS widget be incorporated in the "Edit Host Network" dialog in any case, to allow viewing pre-defined QoS values?
    -   How should the QoS widget be designed to not be intimidating and to fit within the dialog? Should it be put in a different tab?

<Category:Feature>
