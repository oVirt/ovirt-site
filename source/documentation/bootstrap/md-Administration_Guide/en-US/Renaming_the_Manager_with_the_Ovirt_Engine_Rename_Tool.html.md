# Using the oVirt Engine Rename Tool

**Summary**

You can use the `ovirt-engine-rename` command to update records of the fully qualified domain name of the Manager.

The tool checks whether the Manager provides a local ISO or Data storage domain. If it does, the tool prompts the user to eject, shut down, or place into maintenance mode any virtual machine or storage domain connected to the storage before continuing with the operation. This ensures that virtual machines do not lose connectivity with their virtual disks, and prevents ISO storage domains from losing connectivity during the renaming process.

**Renaming the Red Hat Virtualization Manager**

1. Prepare all DNS and other relevant records for the new fully qualified domain name.

2. Update the DHCP server configuration if DHCP is used.

3. Update the host name on the Manager.

4. Run the following command:

        # /usr/share/ovirt-engine/setup/bin/ovirt-engine-rename

5. When prompted, press **Enter** to stop the engine service:

        During execution engine service will be stopped (OK, Cancel) [OK]:

6. When prompted, enter the new fully qualified domain name for the Manager:

        New fully qualified server name:[new name]

**Result**

The `ovirt-engine-rename` command updates records of the fully qualified domain name of the Manager.

