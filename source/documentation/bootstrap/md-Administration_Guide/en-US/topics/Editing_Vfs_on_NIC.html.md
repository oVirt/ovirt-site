# Editing the Virtual Function Configuration on a NIC

Single Root I/O Virtualization (SR-IOV) enables a single PCIe endpoint to be used as multiple separate devices. This is achieved through the introduction of two PCIe functions: physical functions (PFs) and virtual functions (VFs). A PCIe card can have between one and eight PFs, but each PF can support many more VFs (dependent on the device).

You can edit the configuration of SR-IOV-capable Network Interface Controllers (NICs) through the Red Hat Virtualization Manager, including the number of VFs on each NIC and to specify the virtual networks allowed to access the VFs.

Once VFs have been created, each can be treated as a standalone NIC. This includes having one or more logical networks assigned to them, creating bonded interfaces with them, and to directly assign vNICs to them for direct device passthrough.

A vNIC must have the passthrough property enabled in order to be directly attached to a VF. See [Marking vNIC as Passthrough](Marking_vNIC_as_Passthrough).

**Editing the Virtual Function Configuration on a NIC**

1. Select an SR-IOV-capable host and click the **Network Interfaces** tab in the details pane. 

2. Click **Setup Host Networks** to open the **Setup Host Networks** window.

3. Select an SR-IOV-capable NIC, marked with a ![](images/SR-IOV-icon.png), and click the pencil icon to open the **Edit Virtual Functions (SR-IOV) configuration of *NIC*** window.

4. To edit the number of virtual functions, click the **Number of VFs setting** drop-down button and edit the **Number of VFs** text field.

    **Important:** Changing the number of VFs will delete all previous VFs on the network interface before creating new VFs. This includes any VFs that have virtual machines directly attached. 

5. The **All Networks** check box is selected by default, allowing all networks to access the virtual functions. To specify the virtual networks allowed to access the virtual functions, select the **Specific networks** radio button to list all networks. You can then either select the check box for desired networks, or you can use the **Labels** text field to automatically select networks based on one or more network labels.

6. Click **OK** to close the window. Note that the configuration changes will not take effect until you click the **OK** button in the **Setup Host Networks** window.


