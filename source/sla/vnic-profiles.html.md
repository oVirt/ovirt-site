---
title: Vnic Profiles
category: sla
authors: moti, ofri, ovedo
wiki_category: SLA
wiki_title: Features/Vnic Profiles
wiki_revision_count: 37
wiki_last_updated: 2013-11-14
---

# Vnic Profiles

#### Summary

In order to define more natural coupling of the QoS to a VNIC we define a new concept called **VNIC Profile**. The VNIC profile will be introduced in oVirt 3.3 to all clusters and will wrap few of the properties currently defined directly on the VNIC

#### Owner

*   Name:
*   Email:

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
The network administrator could create several VNIC Profiles for each network. He could then grant a users with the permission to use (consume) each profile. The user will only be able to use profiles which he was granted access to.

For example: the network admin will create two VNIC profiles for network "blue":

Profile "Gold" - with better QoS and no port mirroring

Profile "Silver" with lower QoS and enabled port mirroring.

He will then define the user-group "students" as user of profile "Silver" and user-group "teachers" as user of profile "Gold". In this case the teachers will enjoy better quality of service then the students. When a teacher will add/edit a virtual NIC he could select profile "Gold" for that NIC - the VNIC will be connected to network "blue" with high QoS and no port mirroring.

##### Editing a Profile

*   A user should be able to edit the profile properties (including profile name) while VMs are attached and are using this Profile (reference should be done by id).
*   Changing the network of a vNic profile will be allowed only if no VMs are using the profile.
    -   Since we have no way to distinguish between running and current configurations, the expected behavior of such a change is unpredictable and less intuitive to the user (especially since dynamic wiring is supported).
*   The changes will seep down to all VNICs using the profile.
    -   In case VNIC using the edited profile are connected to running VMs, the change will apply only on the VM next run.

Question: What about Hibernate/Suspend VM ? will the resume VM action uses the original configuration for the vnics when the VM was started ?

##### Deleting a Profile

VNIC Profiles could not be deleted from the engine as long as one or more VM/Templates are using those profiles.

##### Reporting vNic actual configuration

*   The engine will retrieve the actual configuration of the profile properties on the VNIC from VDSM (using the network statistics mechanism) and the networked administrator will be presented with the state of each VNIC (synched/unsynched).

##### Editing a VNIC / Changing a VNIC profile

*   Changing the profile a VM is using while the VM is running should behave like dynamic wiring (changing the VM network while it is running).
*   Hot-plug of a vnic will will use will use the updated profile connected to the VNIC.

##### Adding a Network

*   When adding a network, a user can provide an option to create a vNic Profile for it.

Question: Is it s default profile ? what are its properties ? Question: What about 'Public Use' option ? Are they still relevant in the context of adding new networks or we should eliminate them and move it only to 'Add vNic Profile' dialog?

##### Updating a Network

When a network role is modified to be a 'non-VM network', all vNic profiles associated with it should be deleted.

##### Removing a Network

*   Should remove all profiles on that network

##### Adding an Empty Data-Center

*   Currently, When creating a new Data-Center, the management network is automatically created.
*   From 3.3, a default vNic profile will be created for the management network.

##### VM snapshot/import/export

*   We should handle VMs that are pointing to a network directly for backward compatibility.
*   We need to select first profile that is on that network that the user has permissions on.

Question: How would export from 3.3 and import to 3.2 will work? Question: A user can import/export a VM/Template even if he doesn't have permissions on the networks. We should save to the OVF both network name and profile name. During import, if both (network name, profile name) exist on the target DC, the vnic will get the profile id. If any of these are missing, the vnic's profile will be set with 'none' profile.

*   When a Template is created from a VM the VNIC Profile will be kept along with the VNIC. When a VM is created from template the VNIC Profiles will be taken from the template's VNICs.
*   The VNIC Profiles will be exported and imported together with the VNIC. If the user will import a VM which is using a profile not exist in the system, he will be notified and the VNIC will be connected to a default minimal profile defined in the system.

In 3.2 or lower clusters versions not all of the profile properties are supported. In those clusters only Profile name, Network and Port mirroring will be enabled.

#### Benefit to oVirt

We would like to expose to the user the ability to configure the Network Quality of Service (QoS) properties of each virtual NIC. The Network QoS feature will add this ability to the engine. The VNIC profile will improve the usability of the network configuration on the VM. On the user side - VNIC profiles will allow the user to configure a VNIC in relative ease. On the network administrator side - VNIC Profiles will help the administrator to keep control of all the VNICs connected to the network in a simpler way.
The combination of the two will allow the network admin to define, control and dispense different service levels to different users or groups (which may have different priorities).

## Design and Implementation

The Network QoS feature includes two main parts:

*   VNIC level QoS
*   VNIC Profiles

The two parts will be developed in parallel

#### Upgrade

Upgrade process will include automatic creation of two Profiles for each network, one with Port mirroring enabled and the other with port mirroring disabled. In case no VNIC are using a specific network with/without port mirroring - only the relevant profiles will be created.
A vnic connected to a network x in 3.2 will automatically be connected to the correlating profile in 3.3 (according to the port mirroring settings).
A user which had a permission to use a network in 3.2 will be granted the permission to use the correlating profile in 3.3 (according to the port mirroring settings).

#### GUI

A new sub tab will be added to the Network main tab (positioned second, after General)
The sub tab will show the available Profiles for each network. Columns will be:

*   Name - string
*   Port Mirroring - Boolean
*   Inbound QoS - formatted string
*   outbound QoS - formatted string

supported actions: add, edit, remove

The sub tab will include a right pane which will hold "Permissions"/"Consumers" tab where the user will define the user which can use the selected profile.
supported action: add / remove

In The Virtual Machine sub-tab (under the Network main tab) "Profile" column will be added to the table.
 **Profiles sub tab**
![](Network_profiles.png "fig:Network_profiles.png")

A new dialog will be created for add/edit profile. the dialog will include the following fields:

*   Name (text box)
*   Port mirroring (check box)
*   Inbound QoS (3 text boxes)
*   Outbound QoS (3 text boxes)
*   Custom properties (Selection box and +/- buttons)

* In clusters supporting version 3.2 or lower the QoS and Custom properties fields will be visible but disabled.

'''Add/Edit Profile dialog"
![](Vnic_profile.png "fig:Vnic_profile.png")

The Add/Edit VNIC dialog will be added a Profile selection box.
The network which will be available for selection in the Network selection box will only be networks which the user have a permission to use at least on of their profiles.
After selecting a network the Profile selection box will be populated with all profiles of the selected network which the user have permission to use.

**Profile Selection**
![](Profile_selection.png "fig:Profile_selection.png")

#### Permissions

In current implementation two roles are defined for networks:

*   NetworkAdmin - can create/remove/edit/assign to cluster/configure for VM/ configure for Template on **Network** entity
*   NetworkUser - can configure for VM/configure for Template on **Network** entity

In The new implementation:

*   NetworkAdmin - can create/remove/edit/assign to cluster/configure for VM/ configure for Template on **Network** entity
*   NetworkAdmin - can create/remove/edit/configure for VM/configure for Template on **VNICProfile** entity
*   NetworkUser - can configure for VM/configure for Template on **VNICProfile** entity
*   [Optional] NetworkUser - can configure for VM/configure for Template on **Network** entity - this will allow the NetworkUser to use any VNICProfile attached to this Network

NetworkAdmin permissions on **VNICProfile** entity will be added in the upgrade process.
NetworkUser permission on **Network** entity will be changed to permissions on **VNICProfile** entity in the upgrade process

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

*   VnicProfileDao.GetAllForVm(Guid NetworkId, Guid userId, boolean filtered) - will return a map of <Network, List<Profiles>>

see : [http://www.ovirt.org/Features/Design/Network_QoS_-_detailed_design Implementation details](http://www.ovirt.org/Features/Design/Network_QoS_-_detailed_design Implementation details) for detailed design

#### DB Change

Adding a new table, network_profiles see : [http://www.ovirt.org/Features/Design/Network_QoS_-_detailed_design Implementation details](http://www.ovirt.org/Features/Design/Network_QoS_-_detailed_design Implementation details) for detailed design

#### REST API

Not supported in this version

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

### Comments and Discussion

<Category:SLA> [Category: Feature](Category: Feature)
