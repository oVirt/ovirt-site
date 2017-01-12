# Enabling Passthrough on a vNIC Profile

The passthrough property of a vNIC profile enables a vNIC to be directly connected to a virtual function (VF) of an SR-IOV-enabled NIC. The vNIC will then bypass the software network virtualization and connect directly to the VF for direct device assignment.

The passthrough property cannot be enabled if the vNIC profile is already attached to a vNIC; this procedure creates a new profile to avoid this. If a vNIC profile has passthrough enabled, QoS and port mirroring are disabled for the profile.

For more information on SR-IOV, direct device assignment, and the hardware considerations for implementing these in Red Hat Virtualization, see [Hardware Considerations for Implementing SR-IOV](https://access.redhat.com/documentation/en/red-hat-virtualization/4.0/paged/Hardware_Considerations_for_Implementing_SR-IOV/).

**Enabling Passthrough**

1. Select a logical network from the **Networks** results list and click the **vNIC Profiles** tab in the details pane to list all vNIC profiles for that logical network. 

2. Click **New** to open the **VM Interface Profile** window.

3. Enter the **Name** and **Description** of the profile.

4. Select the **Passthrough** check box. This will disable **QoS** and **Port Mirroring**.

5. If necessary, select a custom property from the custom properties list, which displays **Please select a key...** by default. Use the **+** and **-** buttons to add or remove custom properties.

6. Click **OK** to save the profile and close the window.

The vNIC profile is now passthrough-capable. To use this profile to directly attach a virtual machine to a NIC or PCI VF, attach the logical network to the NIC and create a new vNIC on the desired virtual machine that uses the passthrough vNIC profile. For more information on these procedures respectively, see [Editing host network interfaces](Editing_host_network_interfaces), and [Adding a New Network Interface](https://access.redhat.com/documentation/en/red-hat-virtualization/4.0/single/virtual-machine-management-guide/#Adding_a_Network_Interface) in the *Virtual Machine Management Guide*.





