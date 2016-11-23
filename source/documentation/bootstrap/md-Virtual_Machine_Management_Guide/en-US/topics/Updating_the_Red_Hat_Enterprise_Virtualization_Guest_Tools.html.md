# Updating the Guest Agents and Drivers on Windows

The guest tools comprise software that allows Red Hat Virtualization Manager to communicate with the virtual machines it manages, providing information such as the IP addresses, memory usage, and applications installed on those virtual machines. The guest tools are distributed as an ISO file that can be attached to guests. This ISO file is packaged as an RPM file that can be installed and upgraded from the machine on which the Red Hat Virtualization Manager is installed.

**Updating the Guest Agents and Drivers on Windows**

1. On the Red Hat Virtualization Manager, update the Red Hat Virtualization Guest Tools to the latest version: 

        # yum update -y rhev-guest-tools-iso*

2. Upload the ISO file to your ISO domain, replacing `[ISODomain]` with the name of your ISO domain: 

        engine-iso-uploader --iso-domain=[ISODomain] upload /usr/share/rhev-guest-tools-iso/rhev-tools-setup.iso

    **Note:** The `rhev-tools-setup.iso` file is a symbolic link to the most recently updated ISO file. The link is automatically changed to point to the newest ISO file every time you update the `rhev-guest-tools-iso` package.

3. In the Administration or User Portal, if the virtual machine is running, use the **Change CD** button to attach the latest `rhev-tools-setup.iso` file to each of your virtual machines. If the virtual machine is powered off, click the *Run Once** button and attach the ISO as a CD.

4. Select the CD Drive containing the updated ISO and execute the `RHEV-ToolsSetup.exe` file.
