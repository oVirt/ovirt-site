# Configuring vNIC Profiles for UCS Integration

Cisco's Unified Computing System (UCS) is used to manage datacenter aspects such as computing, networking and storage resources.

The `vdsm-hook-vmfex-dev` hook allows virtual machines to connect to Cisco's UCS-defined port profiles by configuring the vNIC profile. The UCS-defined port profiles contain the properties and settings used to configure virtual interfaces in UCS. The `vdsm-hook-vmfex-dev` hook is installed by default with VDSM. See [VDSM and Hooks](appe-VDSM_and_Hooks) for more information.

When a virtual machine that uses the vNIC profile is created, it will use the Cisco vNIC.

The procedure to configure the vNIC profile for UCS integration involves first configuring a custom device property. When configuring the custom device property, any existing value it contained is overwritten. When combining new and existing custom properties, include all of the custom properties in the command used to set the key's value. Multiple custom properties are separated by a semi-colon.

**Note:** A UCS port profile must be configured in Cisco UCS before configuring the vNIC profile.

**Configuring the Custom Device Property**

1. On the Red Hat Virtualization Manager, configure the `vmfex` custom property and set the cluster compatibility level using `--cver`.

        # engine-config -s CustomDeviceProperties='{type=interface;prop={vmfex=^[a-zA-Z0-9_.-]{2,32}$}}' --cver=3.6

2. Verify that the `vmfex` custom device property was added.

        # engine-config -g CustomDeviceProperties   

3. Restart the engine.

        # systemctl restart ovirt-engine.service

The vNIC profile to configure can belong to a new or existing logical network. See [Creating a new logical network in a data center or cluster](Creating_a_new_logical_network_in_a_data_center_or_cluster) for instructions to configure a new logical network.

**Configuring a vNIC Profile for UCS Integration**

1. Click the **Networks** resource tab, and select a logical network in the results list.

2. Select the **vNIC Profiles** tab in the details pane. If you selected the logical network in tree mode, you can select the **vNIC Profiles** tab in the results list.

3. Click **New** or **Edit** to open the **VM Interface Profile** window.

4. Enter the **Name** and **Description** of the profile.

5. Select the `vmfex` custom property from the custom properties list and enter the UCS port profile name.

6. Click **OK**.
