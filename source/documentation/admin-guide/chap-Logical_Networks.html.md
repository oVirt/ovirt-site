---
title: Logical Networks
---

# Chapter 6: Logical Networks

## Logical Network Tasks

### Performing Networking Tasks

**Network** &rarr; **Networks** provides a central location for users to perform logical network-related operations and search for logical networks based on each network’s property or association with other resources.The **New**, **Edit** and **Remove** buttons allow you to create, change the properties of, and delete logical networks within data centers.

Click on each network name and use the tabs in the details view to perform functions including:

* Attaching or detaching the networks to clusters and hosts

* Removing network interfaces from virtual machines and templates

* Adding and removing permissions for users to access and manage networks

These functions are also accessible through each individual resource tab.

   **Warning:** Do not change networking in a data center or a cluster if any hosts are running as this risks making the host unreachable.

   **Important:** If you plan to use oVirt nodes to provide any services, remember that the services will stop if the oVirt environment stops operating.

   This applies to all services, but you should be especially aware of the hazards of running the following on oVirt:

   * Directory Services
   * DNS
   * Storage

### Creating a New Logical Network in a Data Center or Cluster

Create a logical network and define its use in a data center, or in clusters in a data center.

**Creating a New Logical Network in a Data Center or Cluster**

1. Click **Compute** &rarr; **Data Centers** or **Compute** &rarr; **Clusters**.

2. Click the data center or cluster name to open the details view.

3. Click the **Logical Networks** tab.

4. Open the **New Logical Network** window:

    * From the **Data Centers** details pane, click **New**.

    * From the **Clusters** details pane, click **Add Network**.

5. Enter a **Name**, **Description**, and **Comment** for the logical network.

6. Optionally enable **Enable VLAN tagging**.

7. Optionally disable **VM Network**.

8. Optionally select the **Create on external provider** check box. This disables the **Network Label**, **VM Network**, and **MTU** options.

9. Select the **External Provider**. The **External Provider** list does not include external providers that are in read-only mode.

You can create an internal, isolated network, by selecting **ovirt-provider-ovn** on the **External Provider** list and leaving **Connect to physical network** unselected.

10. Enter a new label or select an existing label for the logical network in the **Network Label** text field.

11. Set the **MTU** value to **Default (1500)** or **Custom**.

12. From the **Cluster** tab, select the clusters to which the network will be assigned. You can also specify whether the logical network will be a required network.

13. If **Create on external provider** is selected, the **Subnet** tab will be visible. From the **Subnet** tab, select the **Create subnet** and enter a **Name**, **CIDR**, and **Gateway** address, and select an **IP Version** for the subnet that the logical network will provide. You can also add DNS servers as required.

14. From the **vNIC Profiles** tab, add vNIC profiles to the logical network as required.

15. Click **OK**.

If you entered a label for the logical network, it is automatically added to all host network interfaces with that label.

   **Note:** When creating a new logical network or making changes to an existing logical network that is used as a display network, any running virtual machines that use that network must be rebooted before the network becomes available or the changes are applied.

### Editing a Logical Network

Edit the settings of a logical network.

   **Important:** A logical network cannot be edited or moved to another interface if it is not synchronized with the network configuration on the host. See [Editing host network interfaces](Editing_host_network_interfaces) on how to synchronize your networks.

**Editing a Logical Network**

1. Click **Compute** &rarr; **Data Centers**.

2. Click the data center’s name to open the details view.

3. Click the **Logical Networks** tab and select a logical network.

4. Click **Edit**.

5. Edit the necessary settings.

    **Note:** You can edit the name of a new or existing network, with the exception of the default network, without having to stop the virtual machines.

6. Click **OK**.

    **Note:** Multi-host network configuration automatically applies updated network settings to all of the hosts within the data center to which the network is assigned. Changes can only be applied when virtual machines using the network are down. You cannot rename a logical network that is already configured on a host. You cannot disable the **VM Network** option while virtual machines or templates using that network are running.

### Removing a Logical Network

You can remove a logical network from **Network** &rarr; **Networks** or **Compute** &rarr; **Data Centers**.  The following procedure shows you how to remove logical networks associated to a data center. For a working oVirt environment, you must have at least one logical network used as the `ovirtmgmt` management network.

**Removing Logical Networks**

1. Click **Compute** &rarr; **Data Centers**.

2. Click the data center’s name to open the details view.

3. Click the **Logical Networks** tab to list the logical networks in the data center.

4. Select a logical network and click **Remove**.

5. Optionally, select the **Remove external network(s) from the provider(s) as well** check box to remove the logical network both from the Manager and from the external provider if the network is provided by an external provider. The check box is grayed out if the external provider is in read-only mode.

6. Click **OK**.

The logical network is removed from the Engine and is no longer available.

### Configuring a Non-Management Logical Network as the Default Route

The default route used by hosts in a cluster is through the management network (ovirtmgmt). The following procedure provides instructions to configure a non-management logical network as the default route.

**Prerequisite:**

* If you are using the default_route custom property, you need to clear the custom property from all attached hosts and then follow this procedure.

**Configuring the Default Route Role**

1. Click **Network** &rarr; **Networks**.

2. Click the name of the non-management logical network to configure as the default route to access its details.

3. Click the **Clusters** tab.

4. Click **Manage Network** to open the **Manage Network** window.

5. Select the **Default Route** checkbox for the appropriate cluster(s).

6. Click **OK**.

When networks are attached to a host, the default route of the host will be set on the network of your choice. It is recommended to configure the default route role before any host is added to your cluster. If your cluster already contains hosts, they may become out-of-sync until you sync your change to them.

### Viewing or Editing the Gateway for a Logical Network

Users can define the gateway, along with the IP address and subnet mask, for a logical network. This is necessary when multiple networks exist on a host and traffic should be routed through the specified network, rather than the default gateway.

If multiple networks exist on a host and the gateways are not defined, return traffic will be routed through the default gateway, which may not reach the intended destination. This would result in users being unable to ping the host.
[Multiple Gateways](/develop/release-management/features/network/multiple-gateways/).

oVirt handles multiple gateways automatically whenever an interface goes up or down.

**Viewing or Editing the Gateway for a Logical Network**

1. Click **Compute** &rarr; **Hosts**.

2. Click the host’s name to open the details view.

3. Click the **Network Interfaces** tab to list the network interfaces attached to the host and their configurations.

4. Click the **Setup Host Networks**.

5. Hover your cursor over an assigned logical network and click the pencil icon to open the **Edit Management Network** window.

The **Edit Management Network** window displays the network name, the boot protocol, and the IP, subnet mask, and gateway addresses. The address information can be manually edited by selecting a **Static** boot protocol.

### Logical Network General Settings Explained

The table below describes the settings for the **General** tab of the **New Logical Network** and **Edit Logical Network** window.

**New Logical Network and Edit Logical Network Settings**

<table>
 <thead>
  <tr>
   <td>Field Name</td>
   <td>Description</td>
  </tr>
 </thead>
 <tbody>
  <tr>
   <td><b>Name</b></td>
   <td>The name of the logical network. This text field has a 15-character limit and must be a unique name with any combination of uppercase and lowercase letters, numbers, hyphens, and underscores.</td>
  </tr>
  <tr>
   <td><b>Description</b></td>
   <td>The description of the logical network. This text field has a 40-character limit.</td>
  </tr>
  <tr>
   <td><b>Comment</b></td>
   <td>A field for adding plain text, human-readable comments regarding the logical network.</td>
  </tr>
  <tr>
   <td><b>Create on external provider</b></td>
   <td>
    <p>Allows you to create the logical network to an OpenStack Networking instance that has been added to the Manager as an external provider.</p>
    <p><b>External Provider</b> - Allows you to select the external provider on which the logical network will be created.</p>
   </td>
  </tr>
  <tr>
   <td><b>Enable VLAN tagging</b></td>
   <td>VLAN tagging is a security feature that gives all network traffic carried on the logical network a special characteristic. VLAN-tagged traffic cannot be read by interfaces that do not also have that characteristic. Use of VLANs on logical networks also allows a single network interface to be associated with multiple, differently VLAN-tagged logical networks. Enter a numeric value in the text entry field if VLAN tagging is enabled.</td>
  </tr>
  <tr>
   <td><b>VM Network</b></td>
   <td>Select this option if only virtual machines use this network. If the network is used for traffic that does not involve virtual machines, such as storage communications, do not select this check box.</td>
  </tr>
  <tr>
   <td><b>MTU</b></td>
   <td>Choose either <b>Default</b>, which sets the maximum transmission unit (MTU) to the value given in the parenthesis (), or <b>Custom</b> to set a custom MTU for the logical network. You can use this to match the MTU supported by your new logical network to the MTU supported by the hardware it interfaces with. Enter a numeric value in the text entry field if <b>Custom</b> is selected.</td>
  </tr>
  <tr>
   <td><b>Network Label</b></td>
   <td>Allows you to specify a new label for the network or select from existing labels already attached to host network interfaces. If you select an existing label, the logical network will be automatically assigned to all host network interfaces with that label.</td>
  </tr>
 </tbody>
</table>

### Logical Network Cluster Settings Explained

The table below describes the settings for the **Cluster** tab of the **New Logical Network** window.

**New Logical Network Settings**

<table>
 <thead>
  <tr>
   <td>Field Name</td>
   <td>Description</td>
  </tr>
 </thead>
 <tbody>
  <tr>
   <td><b>Attach/Detach Network to/from Cluster(s)</b></td>
   <td>
    <p>Allows you to attach or detach the logical network from clusters in the data center and specify whether the logical network will be a required network for individual clusters.</p>
    <p><b>Name</b> - the name of the cluster to which the settings will apply. This value cannot be edited.</p>
    <p><b>Attach All</b> - Allows you to attach or detach the logical network to or from all clusters in the data center. Alternatively, select or clear the <b>Attach</b> check box next to the name of each cluster to attach or detach the logical network to or from a given cluster.</p>
    <p><b>Required All</b> - Allows you to specify whether the logical network is a required network on all clusters. Alternatively, select or clear the <b>Required</b> check box next to the name of each cluster to specify whether the logical network is a required network for a given cluster.</p>
   </td>
  </tr>
 </tbody>
</table>

### Logical Network vNIC Profiles Settings Explained

The table below describes the settings for the **vNIC Profiles** tab of the **New Logical Network** window.

**New Logical Network Settings**

<table>
 <thead>
  <tr>
   <td>Field Name</td>
   <td>Description</td>
  </tr>
 </thead>
 <tbody>
  <tr>
   <td><b>vNIC Profiles</b></td>
   <td>
    <p>Allows you to specify one or more vNIC profiles for the logical network. You can add or remove a vNIC profile to or from the logical network by clicking the plus or minus button next to the vNIC profile. The first field is for entering a name for the vNIC profile.</p>
    <p><b>Public</b> - Allows you to specify whether the profile is available to all users.</p>
    <p><b>QoS</b> - Allows you to specify a network quality of service (QoS) profile to the vNIC profile.</p>
   </td>
  </tr>
 </tbody>
</table>

### Designate a Specific Traffic Type for a Logical Network with the Manage Networks Window

Specify the traffic type for the logical network to optimize the network traffic flow.

**Specifying Traffic Types for Logical Networks**

1. Click **Compute** &rarr; **Clusters**.

2. Click the cluster’s name to open the details view.

3. Select the **Logical Networks** tab.

4. Click **Manage Networks**.

5. Select appropriate check boxes and radio buttons.

6. Click **OK**.

**Note:** Logical networks offered by external providers must be used as virtual machine networks; they cannot be assigned special cluster roles such as display or migration.

### Explanation of Settings in the Manage Networks Window

The table below describes the settings for the **Manage Networks** window.

**Manage Networks Settings**

<table>
 <thead>
  <tr>
   <td>Field</td>
   <td>Description/Action</td>
  </tr>
 </thead>
 <tbody>
  <tr>
   <td><b>Assign</b></td>
   <td>Assigns the logical network to all hosts in the cluster</td>
  </tr>
  <tr>
   <td><b>Required</b></td>
   <td>A Network marked "required" must remain operational in order for the hosts associated with it to function properly.
   If a required network ceases to function, any hosts associated with it become non-operational.</td>
  </tr>
  <tr>
   <td><b>VM Network</b></td>
   <td>A logical network marked "VM Network" carries network traffic relevant to the virtual machine network.</td>
  </tr>
  <tr>
   <td><b>Display Network</b></td>
   <td>A logical network marked "Display Network" carries network traffic relevant to SPICE and to the virtual network controller.</td>
  </tr>
  <tr>
   <td><b>Migration Network</b></td>
   <td>A logical network marked "Migration Network" carries virtual machine and storage migration traffic.
   If an outage occurs on this network, the management network (<b>ovirtmgmt</b> by default) will be used instead.</td>
  </tr>
 </tbody>
</table>

### Editing the Virtual Function Configuration on a NIC

Single Root I/O Virtualization (SR-IOV) enables a single PCIe endpoint to be used as multiple separate devices. This is achieved through the introduction of two PCIe functions: physical functions (PFs) and virtual functions (VFs). A PCIe card can have between one and eight PFs, but each PF can support many more VFs (dependent on the device).

You can edit the configuration of SR-IOV-capable Network Interface Controllers (NICs) through the oVirt Engine, including the number of VFs on each NIC and to specify the virtual networks allowed to access the VFs.

Once VFs have been created, each can be treated as a standalone NIC. This includes having one or more logical networks assigned to them, creating bonded interfaces with them, and to directly assign vNICs to them for direct device passthrough.

A vNIC must have the passthrough property enabled in order to be directly attached to a VF. See [Marking vNIC as Passthrough](Marking_vNIC_as_Passthrough).

**Editing the Virtual Function Configuration on a NIC**

1. Click **Compute** &rarr; **Hosts**.

2. Click the name of an SR-IOV-capable host to open the details view.

3. Click the **Network Interfaces** tab.

4. Click **Setup Host Networks**.

5. Select an SR-IOV-capable NIC, marked with a ![](/images/admin-guide/SR-IOV-icon.png), and click the pencil icon.

6. To edit the number of virtual functions, click the **Number of VFs setting** drop-down button and edit the **Number of VFs** text field.

    **Important:** Changing the number of VFs will delete all previous VFs on the network interface before creating new VFs. This includes any VFs that have virtual machines directly attached.

7. The **All Networks** check box is selected by default, allowing all networks to access the virtual functions. To specify the virtual networks allowed to access the virtual functions, select the **Specific networks** radio button to list all networks. You can then either select the check box for desired networks, or you can use the **Labels** text field to automatically select networks based on one or more network labels.

8. Click **OK**.

9. In the **Setup Host Networks** window, click **OK**.

## Virtual Network Interface Cards

### vNIC Profile Overview

A Virtual Network Interface Card (vNIC) profile is a collection of settings that can be applied to individual virtual network interface cards in the Manager. A vNIC profile allows you to apply Network QoS profiles to a vNIC, enable or disable port mirroring, and add or remove custom properties. A vNIC profile also offers an added layer of administrative flexibility in that permission to use (consume) these profiles can be granted to specific users. In this way, you can control the quality of service that different users receive from a given network.

### Creating or Editing a vNIC Profile

Create or edit a Virtual Network Interface Controller (vNIC) profile to regulate network bandwidth for users and groups.

   **Note:** If you are enabling or disabling port mirroring, all virtual machines using the associated profile must be in a down state before editing.

**Creating or editing a vNIC Profile**

1. Click **Network** &rarr; **Networks**.

2. Click the logical network’s name to open the details view.

3. Click the **vNIC Profiles** tab.

4. Click **New** or **Edit**.

5. Enter the **Name** and **Description** of the profile.

6. Select the relevant Quality of Service policy from the **QoS** list.

7. Select a **Network Filter** from the drop-down list to manage the traffic of network packets to and from virtual machines.

8. Select the **Passthrough** check box to enable passthrough of the vNIC and allow direct device assignment of a virtual function. Enabling the passthrough property will disable QoS and port mirroring as these are not compatible. For more information on passthrough, see [Marking vNIC as Passthrough](Marking_vNIC_as_Passthrough).

9. If **Passthrough** is selected, optionally deselect the **Migratable** check box to disable migration for vNICs using this profile.

10. Use the **Port Mirroring** and **Allow all users to use this Profile** check boxes to toggle these options.

11. Select a custom property from the custom properties list, which displays **Please select a key...** by default. Use the **+** and **-** buttons to add or remove custom properties.

12. Click **OK**.

Apply this profile to users and groups to regulate their network bandwidth. Note that if you edited a vNIC profile, you must either restart the virtual machine or hot unplug and then hot plug the vNIC.

### Explanation of Settings in the VM Interface Profile Window


**VM Interface Profile Window**

<table>
 <thead>
  <tr>
   <td>Field Name</td>
   <td>Description</td>
  </tr>
 </thead>
 <tbody>
  <tr>
   <td><b>Network</b></td>
   <td>A drop-down menu of the available networks to apply the vNIC profile.</td>
  </tr>
  <tr>
   <td><b>Name</b></td>
   <td>The name of the vNIC profile. This must be a unique name with any combination of uppercase and lowercase letters, numbers, hyphens, and underscores between 1 and 50 characters.</td>
  </tr>
  <tr>
   <td><b>Description</b></td>
   <td>The description of the vNIC profile. This field is recommended but not mandatory.</td>
  </tr>
  <tr>
   <td><b>QoS</b></td>
   <td>A drop-down menu of the available Network Quality of Service policies to apply to the vNIC profile. QoS policies regulate inbound and outbound network traffic of the vNIC.</td>
  </tr>
  <tr>
   <td><b>Network Filter</b></td>
   <td>A drop-down list of the available network filters to apply to the vNIC profile. Network filters improve network security by filtering the type of packets that can be sent to and from virtual machines. The default filter is <tt>vdsm-no-mac-spoofing</tt>, which is a combination of <tt>no-mac-spoofing</tt> and <tt>no-arp-mac-spoofing</tt>.</td>
  </tr>
  <tr>
   <td><b>Passthrough</b></td>
   <td>
    <p>A check box to toggle the passthrough property. Passthrough allows a vNIC to connect directly to a virtual function of a host NIC. The passthrough property cannot be edited if the vNIC profile is attached to a virtual machine.</p>
    <p>Both QoS and port mirroring are disabled in the vNIC profile if passthrough is enabled.</p>
   </td>
  </tr>
  <tr>
   <td><b>Migratable</b></td>
   <td>A check box to toggle whether or not vNICs using this profile can be migrated. Migration is enabled by default on regular vNIC profiles; the check box is selected and cannot be changed. When the <b>Passthrough</b> check box is selected, <b>Migratable</b> becomes available and can be deselected, if required, to disable migration of passthrough vNICs.</td>
  </tr>
  <tr>
   <td><b>Port Mirroring</b></td>
   <td>A check box to toggle port mirroring. Port mirroring copies layer 3 network traffic on the logical network to a virtual interface on a virtual machine. It it not selected by default.</td>
  </tr>
  <tr>
   <td><b>Device Custom Properties</b></td>
   <td>A drop-down menu to select available custom properties to apply to the vNIC profile. Use the <b>+</b> and <b>-</b> buttons to add and remove properties respectively.</td>
  </tr>
  <tr>
   <td><b>Allow all users to use this Profile</b></td>
   <td>A check box to toggle the availability of the profile to all users in the environment. It is selected by default.</td>
  </tr>
 </tbody>
</table>

.


### Enabling Passthrough on a vNIC Profile

The passthrough property of a vNIC profile enables a vNIC to be directly connected to a virtual function (VF) of an SR-IOV-enabled NIC. The vNIC will then bypass the software network virtualization and connect directly to the VF for direct device assignment.

The passthrough property cannot be enabled if the vNIC profile is already attached to a vNIC; this procedure creates a new profile to avoid this. If a vNIC profile has passthrough enabled, QoS and port mirroring are disabled for the profile.

**Enabling Passthrough**

1. Click **Network** &rarr; **Networks**.

2. Click the logical network’s name to open the details view.

3. Click the **vNIC Profiles** tab to list all vNIC profiles for that logical network.

4. Click **New**.

5. Enter the **Name** and **Description** of the profile.

6. Select the **Passthrough** check box.

7. Optionally deselect the **Migratable** check box to disable migration for vNICs using this profile.

8. If necessary, select a custom property from the custom properties list, which displays **Please select a key...** by default. Use the **+** and **-** buttons to add or remove custom properties.

9. Click **OK**.

The vNIC profile is now passthrough-capable. To use this profile to directly attach a virtual machine to a NIC or PCI VF, attach the logical network to the NIC and create a new vNIC on the desired virtual machine that uses the passthrough vNIC profile. For more information on these procedures respectively, see "Editing host network interfaces" and "Adding a New Network Interface" in the [Virtual Machine Management Guide](/documentation/vmm-guide/Virtual_Machine_Management_Guide/).

### Removing a vNIC Profile

Remove a vNIC profile to delete it from your virtualized environment.

**Removing a vNIC Profile**

1. Click **Network** &rarr; **Networks**.

2. Click the logical network’s name to open the details view.

3. Click the **vNIC Profiles** tab to display available vNIC profiles.

4. Select one or more profiles and click **Remove**.

5. Click **OK**.

### Assigning Security Groups to vNIC Profiles

   **Note:** This feature is only available for users who are integrating with OpenStack Neutron. Security groups cannot be created with oVirt Engine. You must create security groups within OpenStack.

You can assign security groups to the vNIC profile of networks that have been imported from an OpenStack Networking instance and that use the Open vSwitch plug-in. A security group is a collection of strictly enforced rules that allow you to filter inbound and outbound traffic over a network interface. The following procedure outlines how to attach a security group to a vNIC profile.

   **Note:** A security group is identified using the ID of that security group as registered in the OpenStack Networking instance. You can find the IDs of security groups for a given tenant by running the following command on the system on which OpenStack Networking is installed:

        # neutron security-group-list

**Assigning Security Groups to vNIC Profiles**

1. Click **Network** &rarr; **Networks**.

2. Click the logical network’s name to open the details view.

3. Click the **vNIC Profiles** tab.

4. Click **New**, or select an existing vNIC profile and click **Edit**.

5. From the custom properties drop-down list, select **SecurityGroups**. Leaving the custom property drop-down blank applies the default security settings, which permit all outbound traffic and intercommunication but deny all inbound traffic from outside of the default security group. Note that removing the **SecurityGroups** property later will not affect the applied security group.

6. In the text field, enter the ID of the security group to attach to the vNIC profile.

7. Click **OK**.

You have attached a security group to the vNIC profile. All traffic through the logical network to which that profile is attached will be filtered in accordance with the rules defined for that security group.

### User Permissions for vNIC Profiles

Configure user permissions to assign users to certain vNIC profiles. Assign the **VnicProfileUser** role to a user to enable them to use the profile. Restrict users from certain profiles by removing their permission for that profile.

**User Permissions for vNIC Profiles**

1. Click **Network** &rarr; **vNIC Profile**.

2. Click the vNIC profile’s name to open the details view.

3. Click the **Permissions** tab to show the current user permissions for the profile.

4. Click **Add** or **Remove** to change user permissions for the vNIC profile.

5. In the **Add Permissions to User** window, click **My Groups** to display your user groups. You can use this option to grant permissions to other users in your groups.

You have configured user permissions for a vNIC profile.

### Configuring vNIC Profiles for UCS Integration

Cisco's Unified Computing System (UCS) is used to manage datacenter aspects such as computing, networking and storage resources.

The `vdsm-hook-vmfex-dev` hook allows virtual machines to connect to Cisco's UCS-defined port profiles by configuring the vNIC profile. The UCS-defined port profiles contain the properties and settings used to configure virtual interfaces in UCS. The `vdsm-hook-vmfex-dev` hook is installed by default with VDSM. See [VDSM and Hooks](appe-VDSM_and_Hooks) for more information.

When a virtual machine that uses the vNIC profile is created, it will use the Cisco vNIC.

The procedure to configure the vNIC profile for UCS integration involves first configuring a custom device property. When configuring the custom device property, any existing value it contained is overwritten. When combining new and existing custom properties, include all of the custom properties in the command used to set the key's value. Multiple custom properties are separated by a semi-colon.

**Note:** A UCS port profile must be configured in Cisco UCS before configuring the vNIC profile.

**Configuring the Custom Device Property**

1. On the oVirt Engine, configure the `vmfex` custom property and set the cluster compatibility level using `--cver`.

        # engine-config -s CustomDeviceProperties='{type=interface;prop={vmfex=^[a-zA-Z0-9_.-]{2,32}$}}' --cver=3.6

2. Verify that the `vmfex` custom device property was added.

        # engine-config -g CustomDeviceProperties

3. Restart the engine.

        # systemctl restart ovirt-engine.service

The vNIC profile to configure can belong to a new or existing logical network. See [Creating a new logical network in a data center or cluster](Creating_a_new_logical_network_in_a_data_center_or_cluster) for instructions to configure a new logical network.

**Configuring a vNIC Profile for UCS Integration**

1. Click **Network** &rarr; **Networks**.

2. Click the logical network’s name to open the details view.

3. Select the **vNIC Profiles** tab.

4. Click **New** or select a vNIC profile and click **Edit**.

5. Enter the **Name** and **Description** of the profile.

6. Select the `vmfex` custom property from the custom properties list and enter the UCS port profile name.

7. Click **OK**.

## External Provider Networks

### Importing Networks From External Providers

To use networks from an external network provider (OpenStack Networking or any third-party provider that implements the OpenStack Neutron REST API), register the provider with the Manager. See [Adding an OpenStack Network Service Neutron for Network Provisioning](Adding_an_OpenStack_Network_Service_Neutron_for_Network_Provisioning) or [Adding an External Network Provider](Adding_an_External_Network_Provider) for more information. Then, use the following procedure to import the networks provided by that provider into the Manager so the networks can be used by virtual machines.

**Importing a Network From an External Provider**

1. Click **Network** &rarr; **Networks**.

2. Click **Import**.

3. From the **Network Provider** drop-down list, select an external provider. The networks offered by that provider are automatically discovered and listed in the **Provider Networks** list.

4. Using the check boxes, select the networks to import in the **Provider Networks** list and click the down arrow to move those networks into the **Networks to Import** list.

5. It is possible to customize the name of the network that you are importing. To customize the name, click on the network's name in the **Name** column, and change the text.

6. From the **Data Center** drop-down list, select the data center into which the networks will be imported.

7. Optionally, clear the **Allow All** check box for a network in the **Networks to Import** list to prevent that network from being available to all users.

8. Click **Import**.

The selected networks are imported into the target data center and can be attached to virtual machines. See "Adding a New Network Interface" in the [Virtual Machine Management Guide](/documentation/vmm-guide/Virtual_Machine_Management_Guide/) for more information.

### Limitations to Using External Provider Networks

The following limitations apply to using logical networks imported from an external provider in an oVirt environment.

* Logical networks offered by external providers must be used as virtual machine networks, and cannot be used as display networks.

* The same logical network can be imported more than once, but only to different data centers.

* You cannot edit logical networks offered by external providers in the Manager. To edit the details of a logical network offered by an external provider, you must edit the logical network directly from the external provider that provides that logical network.

* Port mirroring is not available for virtual network interface cards connected to logical networks offered by external providers.

* If a virtual machine uses a logical network offered by an external provider, that provider cannot be deleted from the Manager while the logical network is still in use by the virtual machine.

* Networks offered by external providers are non-required. As such, scheduling for clusters in which such logical networks have been imported will not take those logical networks into account during host selection. Moreover, it is the responsibility of the user to ensure the availability of the logical network on hosts in clusters in which such logical networks have been imported.

### Configuring Subnets on External Provider Logical Networks

A logical network provided by an external provider can only assign IP addresses to virtual machines if one or more subnets have been defined on that logical network. If no subnets are defined, virtual machines will not be assigned IP addresses. If there is one subnet, virtual machines will be assigned an IP address from that subnet, and if there are multiple subnets, virtual machines will be assigned an IP address from any of the available subnets. The DHCP service provided by the external network provider on which the logical network is hosted is responsible for assigning these IP addresses.

While the oVirt Engine automatically discovers predefined subnets on imported logical networks, you can also add or remove subnets to or from logical networks from within the Manager.

### Adding Subnets to External Provider Logical Networks

Create a subnet on a logical network provided by an external provider.

**Adding Subnets to External Provider Logical Networks**

1. Click **Network** &rarr; **Networks**.

2. Click the logical network’s name to open the details view.

3. Click the **Subnets** tab.

4. Click **New**.

5. Enter a **Name** and **CIDR** for the new subnet.

6. From the **IP Version** drop-down menu, select either **IPv4** or **IPv6**.

7. Click **OK**.

### Removing Subnets from External Provider Logical Networks

Remove a subnet from a logical network provided by an external provider.

**Removing Subnets from External Provider Logical Networks**

1. Click **Network** &rarr; **Networks**.

2. Click the logical network’s name to open the details view.

3. Click the **Subnets** tab.

4. Select a subnet and click **Remove**.

5. Click **OK**

## Hosts and Networking

### Refreshing Host Capabilities

When a network interface card is added to a host, the capabilities of the host must be refreshed to display that network interface card in the Engine.

**To Refresh Host Capabilities**

1. Click **Compute** &rarr; **Hosts** and select a host.

2. Click **Management** &rarr; **Refresh Capabilities** button.

The list of network interface cards in the **Network Interfaces** tab of the details pane for the selected host is updated. Any new network interface cards can now be used in the Manager.

### Editing Host Network Interfaces and Assigning Logical Networks to Hosts

You can change the settings of physical host network interfaces, move the management network from one physical host network interface to another, and assign logical networks to physical host network interfaces. Bridge and ethtool custom properties are also supported.

   **Warning:** The only way to change the IP address of a host in Red Hat Virtualization is to remove the host and then to add it again.

   **Important:** You cannot assign logical networks offered by external providers to physical host network interfaces; such networks are dynamically assigned to hosts as they are required by virtual machines.

   **Note:** If the switch has been configured to provide Link Layer Discovery Protocol (LLDP) information, you can hover your cursor over a physical network interface to view the switch port’s current configuration. This can help to prevent incorrect configuration. Red Hat recommends checking the following information prior to assigning logical networks:

   * **Port Description (TLV type 4)** and **System Name (TLV type 5)** help to detect to which ports and on which switch the host’s interfaces are patched.

   * **Port VLAN ID** shows the native VLAN ID configured on the switch port for untagged ethernet frames. All VLANs configured on the switch port are shown as **VLAN Name** and **VLAN ID** combinations.

**Editing Host Network Interfaces and Assigning Logical Networks to Hosts**

1. Click **Compute** &rarr; **Hosts**.

2. Click the host’s name to open the details view.

3. Click the **Network Interfaces** tab.

4. Click **Setup Host Networks**.

5. Optionally, hover your cursor over host network interface to view configuration information provided by the switch.

6. Attach a logical network to a physical host network interface by selecting and dragging the logical network into the **Assigned Logical Networks** area next to the physical host network interface.

  Alternatively, right-click the logical network and select a network interface from the drop-down menu.

7. Configure the logical network:

    i. Hover your cursor over an assigned logical network and click the pencil icon to open the **Edit Management Network** window.

    ii. From the **IPv4** tab, select a **Boot Protocol** from **None**, **DHCP**, or **Static**. If you selected **Static**, enter the **IP**, **Netmask / Routing Prefix**, and the **Gateway**.

      **Note:** Each logical network can have a separate gateway defined from the management network gateway. This ensures traffic that arrives on the logical network will be forwarded using the logical network's gateway instead of the default gateway used by the management network.

      **Note:** The **IPv6** tab should not be used as it is currently not supported.

    iii. Use the **QoS** tab to override the default host network quality of service. Select **Override QoS** and enter the desired values in the following fields:

      * **Weighted Share**: Signifies how much of the logical link's capacity a specific network should be allocated, relative to the other networks attached to the same logical link. The exact share depends on the sum of shares of all networks on that link. By default this is a number in the range 1-100.

      * **Rate Limit [Mbps]**: The maximum bandwidth to be used by a network.

      * **Committed Rate [Mbps]**: The minimum bandwidth required by a network. The Committed Rate requested is not guaranteed and will vary depending on the network infrastructure and the Committed Rate requested by other networks on the same logical link.

        For more information on configuring host network quality of service see [Host Network Quality of Service](sect-Host_Network_Quality_of_Service)

    iv. To configure a network bridge, click the **Custom Properties** tab and select **bridge_opts** from the drop-down list. Enter a valid key and value with the following syntax: `key=value`. Separate multiple entries with a whitespace character. The following keys are valid, with the values provided as examples. For more information on these parameters, see [Explanation of bridge opts Parameters](Explanation_of_bridge_opts_Parameters).

            forward_delay=1500
            gc_timer=3765
            group_addr=1:80:c2:0:0:0
            group_fwd_mask=0x0
            hash_elasticity=4
            hash_max=512
            hello_time=200
            hello_timer=70
            max_age=2000
            multicast_last_member_count=2
            multicast_last_member_interval=100
            multicast_membership_interval=26000
            multicast_querier=0
            multicast_querier_interval=25500
            multicast_query_interval=13000
            multicast_query_response_interval=1000
            multicast_query_use_ifaddr=0
            multicast_router=1
            multicast_snooping=1
            multicast_startup_query_count=2
            multicast_startup_query_interval=3125

    v. To configure ethtool properties, click the **Custom Properties** tab and select **ethtool_opts** from the drop-down list. Enter a valid value using the format of the command-line arguments of ethtool. For example:

            --coalesce em1 rx-usecs 14 sample-interval 3 --offload em2 rx on lro on tso off --change em1 speed 1000 duplex half

    This field can accept wildcards. For example, to apply the same option to all of this network’s interfaces, use:

            --coalesce * rx-usecs 14 sample-interval 3

    The **ethtool_opts** option is not available by default; you need to add it using the engine configuration tool. See the “How to Set Up oVirt Engine to Use Ethtool” in Appendix B for more information. For more information on ethtool properties, see the manual page by typing `man ethtool` in the command line.

    vi. To configure Fibre Channel over Ethernet (FCoE), click the **Custom Properties** tab and select **fcoe** from the drop-down list. Enter a valid key and value with the following syntax: `key=value`. At least `enable=yes` is required. You can also add `dcb=[yes|no]` and `auto_vlan=[yes|no]`. Separate multiple entries with a whitespace character. The **fcoe** option is not available by default; you need to add it using the engine configuration tool. See [How to Set Up RHVM to Use FCoE](How_to_Set_Up_RHVM_to_Use_FCoE) for more information.

      **Note:** A separate, dedicated logical network is recommended for use with FCoE.

    vii. To change the default network used by the host from the management network (ovirtmgmt) to a non-management network, configure the non-management network’s default route.

    viii. If your logical network definition is not synchronized with the network configuration on the host, select the **Sync network** check box.

8. Select the **Verify connectivity between Host and Engine** check box to check network connectivity; this action will only work if the host is in maintenance mode.

9. Select the **Save network configuration** check box to make the changes persistent when the environment is rebooted.

10. Click **OK**.

    **Note:** If not all network interface cards for the host are displayed, click **Management** &rarr; **Refresh Capabilities** button to update the list of network interface cards available for that host.

### Synchronizing Host Networks

The Manager defines a network interface as out-of-sync when the definition of the interface on the host differs from the definitions stored by the Manager. Out-of-sync networks appear with an Out-of-sync icon ![](/images/admin-guide/out-of-sync.png) out of sync in the host’s **Network Interfaces** tab and with this icon ![](/images/admin-guide/out-of-sync-setup.png) out of sync setup in the **Setup Host Networks** window.

When a host’s network is out of sync, the only activities that you can perform on the unsynchronized network in the **Setup Host Networks** window are detaching the logical network from the network interface or synchronizing the network.

**Understanding How a Host Becomes out-of-sync**

A host will become out of sync if:

* You make configuration changes on the host rather than using the **Edit Logical Networks** window, for example:

  * Changing the VLAN identifier on the physical host.

  * Changing the **Custom MTU** on the physical host.

* You move a host to a different data center with the same network name, but with different values/parameters.

* You change a network’s **VM Network** property by manually removing the bridge from the host.

* You update definitions using the **Edit Logical Networks** window, without selecting the **Save network configuration** check box when saving your changes. After rebooting the host, it may become unsynchronized.

**Preventing Hosts from Becoming Unsynchronized**

Following these best practices will prevent your host from becoming unsynchronized:

* Ensure that the **Save network configuration** check box is selected when saving your changes in the **Edit Logical Networks** window (it is selected by default).

* Use the Administration Portal to make changes rather than making changes locally on the host.

* Edit VLAN settings according to the instructions in the “Editing a Host’s VLAN Settings” section.

**Synchronizing Hosts**

Synchronizing a host’s network interface definitions involves using the definitions from the Manager and applying them to the host. If these are not the definitions that you require, after synchronizing your hosts update their definitions from the Administration Portal. You can synchronize a host’s networks on three levels:

* Per logical network
* Per host
* Per cluster

**Synchronizing Host Networks on the Logical Network Level**

1. Click **Compute** &rarr; **Hosts**.

2. Click the host’s name to open the details view.

3. Click the **Network Interfaces** tab.

4. Click **Setup Host Networks**.

5. Hover your cursor over the unsynchronized network and click the pencil icon to open the **Edit Network** window.

6. Select the **Sync network** check box.

7. Click **OK**.

8. Select the **Save network configuration** check box in the **Setup Host Networks** window to make the changes persistent when the environment is rebooted.

9. Click **OK**.

**Synchronizing a Host’s Networks on the Host level**

* Click the **Sync All Networks** button in the host’s **Network Interfaces** tab to synchronize all of the host’s unsynchronized network interfaces.

**Synchronizing a Host’s Networks on the Cluster level**

* Click the **Sync All Networks** button in the cluster’s **Logical Networks** tab to synchronize all unsynchronized logical network definitions for the entire cluster.

    **Note:** You can also synchronize a host’s networks via the REST API

### Editing a Host’s VLAN Settings

To change the VLAN settings of a host, the host must be removed from the Manager, reconfigured, and re-added to the engine.

To keep networking synchronized, do the following:

1. Put the host in maintenance mode.

2. Manually remove the management network from the host. This will make the host reachable over the new VLAN.

3. Add the host to the cluster. Virtual machines that are not connected directly to the management network can be migrated between hosts safely.

The following warning message appears when the VLAN ID of the management network is changed:

        Changing certain properties (e.g. VLAN, MTU) of the management network could lead to loss of connectivity to hosts in the data center, if its underlying network infrastructure isn't configured to accommodate the changes. Are you sure you want to proceed?

Proceeding causes all of the hosts in the data center to lose connectivity to the Manager and causes the migration of hosts to the new management network to fail. The management network will be reported as "out-of-sync".

### Adding Multiple VLANs to a Single Network Interface Using Logical Networks

Multiple VLANs can be added to a single network interface to separate traffic on the one host.

   **Important:** You must have created more than one logical network, all with the **Enable VLAN tagging** check box selected in the **New Logical Network** or **Edit Logical Network** windows.

**Adding Multiple VLANs to a Network Interface using Logical Networks**

1. Click **Compute** → **Hosts**.

2. Click the host’s name to open the details view.

3. Click the **Network Interfaces** tab.

4. Click **Setup Host Networks**.

5. Drag your VLAN-tagged logical networks into the **Assigned Logical Networks** area next to the physical network interface. The physical network interface can have multiple logical networks assigned due to the VLAN tagging.

6. Edit the logical networks:

  i. Hover your cursor over an assigned logical network and click the pencil icon.

  ii. If your logical network definition is not synchronized with the network configuration on the host, select the **Sync network** check box.

  iii. Select a **Boot Protocol**:

   * **None**

   * **DHCP**

   * **Static**

  iv. Provide the **IP** and **Subnet Mask**.

  v. Click **OK**.

7. Select the **Verify connectivity between Host and Engine** check box to run a network check; this will only work if the host is in maintenance mode.

8. Select the **Save network configuration** check box.

9. Click **OK**.

Add the logical network to each host in the cluster by editing a NIC on each host in the cluster. After this is done, the network will become operational.

You have added multiple VLAN-tagged logical networks to a single interface. This process can be repeated multiple times, selecting and editing the same network interface each time on each host to add logical networks with different VLAN tags to a single network interface.

### Assigning Additional IPv4 Addresses to a Host Network

A host network, such as the **ovirtmgmt** management network, is created with only one IP address when initially set up. This means that if a NIC’s configuration file (for example, **/etc/sysconfig/network-scripts/ifcfg-eth01**) is configured with multiple IP addresses, only the first listed IP address will be assigned to the host network. Additional IP addresses may be required if connecting to storage, or to a server on a separate private subnet using the same NIC.

The `vdsm-hook-extra-ipv4-addrs` hook allows you to configure additional IPv4 addresses for host networks. For more information about hooks, see Appendix A, VDSM and Hooks.

In the following procedure, the host-specific tasks must be performed on each host for which you want to configure additional IP addresses.

**Assigning Additional IPv4 Addresses to a Host Network**

1. On the host that you want to configure additional IPv4 addresses for, install the VDSM hook package. The package is available by default on oVirt Nodes but needs to be installed on Enterprise Linux hosts.

       # yum install vdsm-hook-extra-ipv4-addrs

2. On the Engine, run the following command to add the key:

       # engine-config -s 'UserDefinedNetworkCustomProperties=ipv4_addrs=.\*'

3. Restart the ovirt-engine service:

       # systemctl restart ovirt-engine.service

4. In the Administration Portal, click **Compute** &rarr; **Hosts**.

5. Click the host’s name to open the details view.

6. Click the **Network Interfaces** tab and click **Setup Host Networks**.

7. Edit the host network interface by hovering the cursor over the assigned logical network and clicking the pencil icon.

8. Select **ipv4_addr** from the **Custom Properties** drop-down list and add the additional IP address and prefix (for example 5.5.5.5/24). Multiple IP addresses must be comma-separated.

9. Click **OK**.

10. Select the **Save network configuration** check box.

11. Click **OK**.

The additional IP addresses will not be displayed in the Engine, but you can run the command `ip addr show` on the host to confirm that they have been added.

### Adding Network Labels to Host Network Interfaces

Using network labels allows you to greatly simplify the administrative workload associated with assigning logical networks to host network interfaces.

   **Note:** Setting a label on a role network (for instance, a migration network or a display network) causes a mass deployment of that network on all hosts. Such mass additions of networks are achieved through the use of DHCP. This method of mass deployment was chosen over a method of typing in static addresses, because of the unscalable nature of the task of typing in many static IP addresses.

**Adding Network Labels to Host Network Interfaces**

1. Click **Compute** &rarr; **Hosts**.

2. Click the host’s name to open the details view.

3. Click the **Network Interfaces** tab.

4. Click **Setup Host Networks**.

5. Click **Labels**, and right-click **[New Label]**. Select a physical network interface to label.

6. Enter a name for the network label in the **Label** text field.

7. Click **OK**.

You have added a network label to a host network interface. Any newly created logical networks with the same label will be automatically assigned to all host network interfaces with that label. Also, removing a label from a logical network will automatically remove that logical network from all host network interfaces with that label.

### Bonding Logic in oVirt

The oVirt Engine Administration Portal allows you to create bond devices using a graphical interface. There are several distinct bond creation scenarios, each with its own logic.

Two factors that affect bonding logic are:

* Are either of the devices already carrying logical networks?

* Are the devices carrying compatible logical networks?

**Bonding Scenarios and Their Results**

<table>
 <thead>
  <tr>
   <td>Bonding Scenario</td>
   <td>Result</td>
  </tr>
 </thead>
 <tbody>
  <tr>
   <td>NIC + NIC</td>
   <td>
    <p>The <b>Create New Bond</b> window is displayed, and you can configure a new bond device.</p>
    <p>If the network interfaces carry incompatible logical networks, the bonding operation fails until you detach incompatible logical networks from the devices forming your new bond.</p>
   </td>
  </tr>
  <tr>
   <td>NIC + Bond</td>
   <td>
    <p>The NIC is added to the bond device. Logical networks carried by the NIC and the bond are all added to the resultant bond device if they are compatible.</p>
    <p>If the bond devices carry incompatible logical networks, the bonding operation fails until you detach incompatible logical networks from the devices forming your new bond.</p>
   </td>
  </tr>
  <tr>
   <td>Bond + Bond</td>
   <td>
    <p>If the bond devices are not attached to logical networks, or are attached to compatible logical networks, a new bond device is created. It contains all of the network interfaces, and carries all logical networks, of the component bond devices. The <b>Create New Bond</b> window is displayed, allowing you to configure your new bond.</p>
    <p>If the bond devices carry incompatible logical networks, the bonding operation fails until you detach incompatible logical networks from the devices forming your new bond.</p>
   </td>
  </tr>
 </tbody>
</table>

### Bonding Modes

A bond is an aggregation of multiple network interface cards into a single software-defined device. Because bonded network interfaces combine the transmission capability of the network interface cards included in the bond to act as a single network interface, they can provide greater transmission speed than that of a single network interface card. Also, because all network interface cards in the bond must fail for the bond itself to fail, bonding provides increased fault tolerance. However, one limitation is that the network interface cards that form a bonded network interface must be of the same make and model to ensure that all network interface cards in the bond support the same options and modes.

The packet dispersal algorithm for a bond is determined by the bonding mode used.

   **Important:** Modes 1, 2, 3, and 4 support both virtual machine (bridged) and non-virtual machine (bridgeless) network types. Modes 0, 5 and 6 support non-virtual machine (bridgeless) networks only.

oVirt uses Mode 4 by default, but supports the following common bonding modes:

**Mode 0 (round-robin policy)**
: Transmits packets through network interface cards in sequential order. Packets are transmitted in a loop that begins with the first available network interface card in the bond and end with the last available network interface card in the bond. All subsequent loops then start with the first available network interface card. Mode 0 offers fault tolerance and balances the load across all network interface cards in the bond. However, Mode 0 cannot be used in conjunction with bridges, and is therefore not compatible with virtual machine logical networks.

**Mode 1 (active-backup policy)**
: Sets all network interface cards to a backup state while one network interface card remains active. In the event of failure in the active network interface card, one of the backup network interface cards replaces that network interface card as the only active network interface card in the bond. The MAC address of the bond in Mode 1 is visible on only one port to prevent any confusion that might otherwise be caused if the MAC address of the bond changed to reflect that of the active network interface card. Mode 1 provides fault tolerance and is supported in oVirt.

**Mode 2 (XOR policy)**
: Selects the network interface card through which to transmit packets based on the result of an XOR operation on the source and destination MAC addresses modulo network interface card slave count. This calculation ensures that the same network interface card is selected for each destination MAC address used. Mode 2 provides fault tolerance and load balancing and is supported in oVirt.

**Mode 3 (broadcast policy)**
: Transmits all packets to all network interface cards. Mode 3 provides fault tolerance and is supported in oVirt.

**Mode 4 (IEEE 802.3ad policy)**
: Creates aggregation groups in which the interfaces share the same speed and duplex settings. Mode 4 uses all network interface cards in the active aggregation group in accordance with the IEEE 802.3ad specification and is supported in oVirt.

**Mode 5 (adaptive transmit load balancing policy)**
: Ensures the distribution of outgoing traffic accounts for the load on each network interface card in the bond and that the current network interface card receives all incoming traffic. If the network interface card assigned to receive traffic fails, another network interface card is assigned to the role of receiving incoming traffic. Mode 5 cannot be used in conjunction with bridges, therefore it is not compatible with virtual machine logical networks.

**Mode 6 (adaptive load balancing policy)**
: Combines Mode 5 (adaptive transmit load balancing policy) with receive load balancing for IPv4 traffic without any special switch requirements. ARP negotiation is used for balancing the receive load. Mode 6 cannot be used in conjunction with bridges, therefore it is not compatible with virtual machine logical networks.

### Creating a Bond Device Using the Administration Portal

You can bond compatible network devices together. This type of configuration can increase available bandwidth and reliability. You can bond multiple network interfaces, pre-existing bond devices, and combinations of the two. A bond can carry both VLAN tagged and non-VLAN traffic.

**Creating a Bond Device using the Administration Portal**

1. Click **Compute** &rarr; **Hosts**.

2. Click the host’s name to open the details view.

3. Click the **Network Interfaces** tab to list the physical network interfaces attached to the host.

4. Click **Setup Host Networks**.

5. Optionally, hover your cursor over host network interface to view configuration information provided by the switch.

6. Select and drag one of the devices over the top of another device and drop it to open the **Create New Bond** window. Alternatively, right-click the device and select another device from the drop-down menu.

   If the devices are incompatible, the bond operation fails and suggests how to correct the compatibility issue.

7. Select the **Bond Name** and **Bonding Mode** from the drop-down menus.

   Bonding modes 1, 2, 4, and 5 can be selected. Any other mode can be configured using the **Custom** option.

8. Click **OK** to create the bond and close the **Create New Bond** window.

9. Assign a logical network to the newly created bond device.

10. Optionally choose to **Verify connectivity between Host and Engine** and **Save network configuration**.

11. Click **OK**.

Your network devices are linked into a bond device and can be edited as a single interface. The bond device is listed in the **Network Interfaces** tab of the details pane for the selected host.

Bonding must be enabled for the ports of the switch used by the host. The process by which bonding is enabled is slightly different for each switch; consult the manual provided by your switch vendor for detailed information on how to enable bonding.

   **Note:** For a bond in Mode 4, all slaves must be configured properly on the switch. If none of them is configured properly on the switch, the `ad_partner_mac` is reported as 00:00:00:00:00:00. The Manager will display a warning in the form of an exclamation mark icon on the bond in the **Network Interfaces** tab. No warning is provided if any of the slaves are up and running.

### Example Uses of Custom Bonding Options with Host Interfaces

You can create customized bond devices by selecting **Custom** from the **Bonding Mode** of the **Create New Bond** window. The following examples should be adapted for your needs. For a comprehensive list of bonding options and their descriptions, see the [Linux Ethernet Bonding Driver HOWTO](https://www.kernel.org/doc/Documentation/networking/bonding.txt) on Kernel.org.

**xmit_hash_policy**

This option defines the transmit load balancing policy for bonding modes 2 and 4. For example, if the majority of your traffic is between many different IP addresses, you may want to set a policy to balance by IP address. You can set this load-balancing policy by selecting a **Custom** bonding mode, and entering the following into the text field:

    mode=4 xmit_hash_policy=layer2+3

**ARP Monitoring**

ARP monitor is useful for systems which can't or don't report link-state properly via ethtool. Set an `arp_interval` on the bond device of the host by selecting a **Custom** bonding mode, and entering the following into the text field:

    mode=1 arp_interval=1 arp_ip_target=192.168.0.2

**Primary**

You may want to designate a NIC with higher throughput as the primary interface in a bond device. Designate which NIC is primary by selecting a **Custom** bonding mode, and entering the following into the text field:

    mode=1 primary=eth0

### Changing the FQDN of a Host

Use the following procedure to change the fully qualified domain name of hosts.

**Updating the FQDN of a Host**

1. Place the host into maintenance mode so the virtual machines are live migrated to another host. See [Moving a host to maintenance mode1](Moving_a_host_to_maintenance_mode1) for more information. Alternatively, manually shut down or migrate all the virtual machines to another host. See "Manually Migrating Virtual Machines" in the [Virtual Machine Management Guide](/documentation/vmm-guide/Virtual_Machine_Management_Guide/) for more information.

2. Click **Remove**, and click **OK** to remove the host from the Administration Portal.

3. Use the `hostnamectl` tool to update the host name.

        # hostnamectl set-hostname NEW_FQDN

4. Reboot the host.

5. Re-register the host with the Manager. See [Adding a Host](Adding_a_Host) for more information.

**Prev:** [Chapter 5: Clusters](chap-Clusters)<br>
**Next:** [Chapter 7: Hosts](chap-Hosts)

[Adapted from RHV 4.2 documentation - CC-BY-SA](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.2/html/administration_guide/chap-logical_networks)
