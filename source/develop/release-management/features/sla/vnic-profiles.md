---
title: Vnic Profiles
category: feature
authors:
  - moti
  - ofri
  - ovedo
---

# Vnic Profiles

#### Summary

In order to define more natural coupling of the QoS to a VNIC we define a new concept called **VNIC Profile**. The VNIC profile will be introduced in oVirt 3.3 to all clusters and will wrap few of the properties currently defined directly on the VNIC

#### Owner

*   Name: Moti Asayag
*   Email: masayag@redhat.com

#### Current status

*   Status: design
*   Last updated: ,
*   patchset

#### Detailed Description

The VNIC Profile concept embodies a predefined package of network setting which will define the network service a VNIC will get.
VNIC Profile include:
\* Profile name

*   Network
*   Quality of Service
*   Port mirroring
*   Custom properties

When creating a new VNIC or editing an existing one the user will select a VNIC Profile (instead of the current implementation in which the user selects a network and sets port mirroring and custom properties).

##### Adding a Profile

The network administrator could create several VNIC Profiles for each network. He could then grant a users with the permission to use (consume) each profile. The user will only be able to use profiles which he was granted access to.

For example: the network admin will create two VNIC profiles for network "blue":

Profile "teacher-blue" - with better QoS and with port mirroring

Profile "student-blue" with lower QoS and without port mirroring.

He will then define the user-group "students" as user of profile "student-blue" and user-group "teachers" as user of profile "teacher-blue". In this case the teachers will enjoy better quality of service (e.g. Gold) than the students (e.g Silver). When a teacher will add/edit a virtual NIC he could select profile "teacher-blue" for that NIC - the VNIC will be connected to network "blue" with high QoS and with port mirroring.

*   An option to select 'Allow all users to use this profile' will be added to the dialog. If selected, a permission on the the vnic profile will be granted to 'everyone'.

##### Editing a Profile

*   A user should be able to edit the profile properties (including profile name) while VMs are attached and are using this Profile (reference should be done by id), except of the port mirroring.
*   Changing the network of a vNic profile will be blocked.
    -   Since we have no way to distinguish between running and current configurations, the expected behavior of such a change is unpredictable and less intuitive to the user (especially since dynamic wiring is supported).
*   The changes will seep down to all VNICs using the profile.
    -   In case VNIC using the edited profile are connected to running VMs, the change will apply only on the VM next run.

##### Deleting a Profile

VNIC Profiles could not be deleted from the engine as long as one or more VM/Templates are using those profiles.

##### Editing a VNIC / Changing a VNIC profile

*   Changing the profile a VM is using while the VM is running should behave like dynamic wiring (changing the VM network while it is running).
*   Hot plug will be fully supported: the user can choose any permitted profile while plugging a new device or when activating an existing one.

##### Adding a Network

*   When adding a network, a user can provide an option to create a vNic Profile for it.
*   Vnic profiles are allowed for VM networks only.
*   All VNIC-QoS-objects will be displayed and the users could tick next to the QoS they are interested in, for each QoS that was chosen a profile would be created,

and for each vnic profile there will be an option for 'public use'.

*   The vNic profile name will be NetworkNamePolicyName, e.g. blueGold. The user will be able to rename the profile and its properties from the vnic profile sub-tab.

<!-- -->

*   A default vnic profile will be created implicitly by the engine when creating a new network, unless specifically asked not create it.

The option to check the network for a public use will be removed from the 'Add network' dialog.

##### Updating a Network

When a network role is modified to be a 'non-VM network', all vNic profiles associated with it should be deleted and permissions associated with these profiles.
When a non-vm network is modified to be a 'VM network', a default vnic profile will be created if the action is done in the webadmin. Performing the update network operation via the api will not create a default vnic profile and the user will have to create one himself so the network could be used by VMs.

##### Removing a Network

*   Should remove all profiles on that network and associated permissions.

##### Adding an Empty Data-Center

*   Currently, When creating a new Data-Center, the management network is automatically created.
*   A default vNic profile will be created for the management network.

##### Removing Data-Center

Should remove all data center's networks and their associated permissions.

##### VM snapshot/import/export

*   We should handle VMs that are pointing to a network directly for backward compatibility.
*   We need to select first profile that is on that network that the user has permissions on.

<!-- -->

*   The profile name should be saved in the OVF, in OtherResourceType element (in addition to the network name which is saved today).

The import of a VM/Template will be performed according to the following logic:

*   If the network name and vnic profile are provided, the vnic profile will be resolved.
    -   If no matching vnic profile, an attempt to obtain a different vnic profile by permission for the user of that network.
        -   Vnic profile with port-mirroring will not be allowed to be created implicitly.
        -   If no profile found, 'none' value will be set for it and an event will be written to the events log.
*   When a Template is created from a VM the VNIC Profile will be kept along with the VNIC. When a VM is created from template the VNIC Profiles will be taken from the template's VNICs.

##### Backward Compatibility

In 3.2 or lower clusters versions not all of the profile properties are supported. In those clusters only Profile name, Network and Port mirroring will be enabled. For time been, we'll keep the networkName in the vmNetworkInterface, however when rest support will be added, the field will be removed.

#### Benefit to oVirt

We would like to expose to the user the ability to configure the Network Quality of Service (QoS) properties of each virtual NIC. The Network QoS feature will add this ability to the engine. The VNIC profile will improve the usability of the network configuration on the VM. On the user side - VNIC profiles will allow the user to configure a VNIC in relative ease. On the network administrator side - VNIC Profiles will help the administrator to keep control of all the VNICs connected to the network in a simpler way.
The combination of the two will allow the network admin to define, control and dispense different service levels to different users or groups (which may have different priorities).

## Design and Implementation

The Network QoS feature includes two main parts:

*   VNIC level QoS
*   VNIC Profiles

The two parts will be developed in parallel

#### Upgrade

In the upgrade process we will do the following:

*   Create a VNIC profile for each network, without port mirroring
*   Create a VNIC profile with port mirroring for every network which has a VNIC with port mirroring
*   A VNIC connected to a network x in 3.2 will automatically be connected to the correlating profile in 3.3 (according to the port mirroring settings).
*   Comment: when we say VNIC we mean either a VM VNIC or a Template VNIC
*   A user which had a permission to use a network in 3.2 will be granted the permission to use the correlating profile in 3.3 (according to the port mirroring settings).

#### Permissions

The following action groups will be added:

*   CONFIGURE_NETWORK_VNIC_PROFILE - will be part of roles that have the CONFIGURE_STORAGE_POOL_NETWORK action group
*   CREATE_NETWORK_VNIC_PROFILE - will be part of roles that have the CREATE_STORAGE_POOL_NETWORK action group
*   DELETE_NETWORK_VNIC_PROFILE - will be part of roles that have the DELETE_STORAGE_POOL_NETWORK action group

A VNICProfileUser role will be added, instead of the NetworkUser role. This role will contain the exact same action groups:

*   CONFIGURE_VM_NETWORK
*   CONFIGURE_TEMPLATE_NETWORK
*   LOGIN

When upgrading the permissions table, we will do the following:

*   Remove each NetworkUser role on network objects, replacing it with a VNICProfileUser on the created network profiles.
*   Replacing each NetworkUser role on other types of objects with a VNICProfileUser

We will also remove the PORT_MIRRORING action group, replacing it with proper logic in the different backend commands.

##### Permission Views

User (as opposed to an administrator), will be limited to the networks and VNIC profiles he can see.
===== VNIC Profiles ===== NOTE: the permissions used below besides the direct one, and the VM/Template one, must allow the user to view the child objects

*   The user has direct user permissions on the VNIC profile
*   The user has user permissions on the VNIC profile's network
*   The user has user permissions on the Profile-Network's Data-Center
*   The user has user permissions on a Profile-Network's Cluster
*   The user has user permissions on a VM with a VNIC using the VNIC Profile
*   The user has user permissions on a Template with a VNIC using the VNIC Profile
*   The user has user permissions on the System object

###### Networks

*   The user has permission on a VNIC profile that's part of this network

#### GUI

A new sub tab will be added to the Network main tab (positioned second, after General)
The sub tab will show the available Profiles for each network. Columns will be:

*   Name - string
*   Port Mirroring - Boolean
*   Inbound QoS - formatted string
*   outbound QoS - formatted string

The inbound/outbound units will appear in Mb and Mbps, however, they will be converted to Kb and Kbs on the engine side when sent to VDSM. supported actions: add, edit, remove

The vNIC Profiles is implemented as a main-tab in context of network or data-center when those selected on the system tree.
The vNIC Profiles permissions are managed in a sub tab of that vNIC Profile main tab.
supported action: add / remove

**Profiles main tab**
![](/images/wiki/Network_profiles.png)

In The Virtual Machine sub-tab (under the Network main tab) "Profile" column will be added to the table.
 A new dialog will be created for add/edit profile. the dialog will include the following fields:

*   Name (text box)
*   Port mirroring (check box)
*   Inbound QoS (3 text boxes)
*   Outbound QoS (3 text boxes)
*   Custom properties (Selection box and +/- buttons)

* In clusters supporting version 3.2 or lower the QoS and Custom properties fields will be visible but disabled.

'''Add/Edit Profile dialog"
![](/images/wiki/Vnic_profile.png)

The Add/Edit VNIC dialog will be added a Profile selection box.
The network which will be available for selection in the Network selection box will only be networks which the user have a permission to use at least on of their profiles.
After selecting a network the Profile selection box will be populated with all profiles of the selected network which the user have permission to use.

**Profile Selection**
![](/images/wiki/Profile_selection.png)

**Add New Logical Network dialog**
![](/images/wiki/New_netwrok_profiles.png)

#### Backend

We define a new entity: NetworkProfile.
The NetworkProfile will be added as a property of NetworkInterface.

Affected flows:

*   AddVmNetworkInterface
*   UpdateVmNetworkInterface
*   AddVmTemplateNetworkInterface
*   UpdateVmTemplateNetworkInterface
*   AddNetworkCommand
*   UpdateNetworkCommand
*   RemoveNetworkCommand
*   ExportVmCommand
*   ImportVmCommand
*   ExportVmTemplateCommand
*   ImportVmTemplateCommand

New flows:

*   AddVnicProfile
*   UpdateVnicProfile
*   RemoveVnicProfile

DB Queries:

*   VnicProfileDao.GetAll()
*   VnicProfileDao.GetAllForNetwork(Guid NetworkId, Guid userId, boolean filtered)

At the convenience of the UI:

*   VnicProfileDao.GetAllForVm(Guid NetworkId, Guid userId, boolean filtered) - will return a map of `<Network, List<Profiles>>`

see : [Implementation details](/develop/release-management/features/network/network-qos-detailed-design.html) for detailed design

#### DB Change

Adding a new table, network_profiles see [implementation details](/develop/release-management/features/network/network-qos-detailed-design.html) for detailed design

*   Add new view - vnic_profile_network_view, contains all vnic_profiles fields and network_name, data_center_name and compatibility_version.

The new view will be mapped into **VnicProfileView** entity which extends the VnicProfile with the aforementioned fields.
The **VnicProfileView** will serve the UI.

#### REST API

The vnic profiles will be modeled as a top collection:

      /api/vnicprofiles

The vnic profiles will be available as a sub collection of the networks top collection:

      api/networks/{network:id}/vnicprofiles/{profile:id}

The POST'ed elemet should look like:

```xml
 <vnic_profile>
     <name>profile1</name>
     <network id="00000000-0000-0000-0000-000000000009"/>
     <port_mirroring>true</port_mirroring>
 </vnic_profile>
```

However the vnic profile will not be update-able via the sub-collection.
 The user will be able to create a network without a default vnic profile by providing the following element in the network

      POSTed element for /api/networks:
```xml
 <network>
           ...
     <profile_required>false</profile_required>
 </network>
```

For REST backward compatibility, a new parameter set will be added to a vm network interface Add and Update actions.
The current parameter set includes either network name and port mirroring as today.
The new parameter set will include the vnic profile id.
\* Add VM nic:

      /api/vms/{vm:id}/nics|rel=add

*   Update VM nic:

      /api/vms/{vm:id}/nics/{nic:id}|rel=update

*   Add template nic:

      /api/template/{template:id}/nics|rel=add

*   Update template nic:

      /api/template/{template:id}/nics/{nic:id}|rel=update

With the following element:

```xml
 <nic>
           ...
     <vnic_profile id="fa5d0471-f83b-44ec-8715-7fe1a53ab7a6"/>
 </nic>
```

The returned entity will include the the vnic profile id as well.

#### VDSM

VDSM will not be affected by the VNIC Profiles. The engine will encapsulate this abstraction and will keep

### Tests

#### Expected unit-tests

* Unit test handling network selection and VNIC settings are expected to change

### Special considerations

### Dependencies / Related Features

Affected ovirt projects:

*   API
*   backend
*   Webadmin
*   User Portal

Others projects:

*   vdsm

Affected features:

*   Custom properties

### Documentation / External references

*   See: <http://libvirt.org/formatdomain.html#elementQoS> for documentation of the VM level network QoS XML.


