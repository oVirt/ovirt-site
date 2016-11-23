# Configuring Red Hat Satellite Errata Management for a Virtual Machine

In the Administration Portal, you can configure a virtual machine to display the available errata. The virtual machine needs to be associated with a Red Hat Satellite server to show available errata.

Red Hat Virtualization 4.0 supports errata management with Red Hat Satellite 6.1.

The following prerequisites apply:

* The host that the virtual machine runs on also needs to be configured to receive errata information from Satellite. See [Configuring Satellite Errata Management for a Host](https://access.redhat.com/documentation/en/red-hat-virtualization/4.0/single/administration-guide#sect-Host_Tasks) in the *Administration Guide* for more information.

* The virtual machine must have the rhevm-guest-agent package installed. This package allows the virtual machine to report its host name to the Red Hat Virtualization Manager. This allows the Red Hat Satellite server to identify the virtual machine as a content host and report the applicable errata. For more information on installing the ovirt-guest-agent package see [Installing the Guest Agents and Drivers on Red Hat Enterprise Linux](Installing_the_Guest_Agents_and_Drivers_on_Red_Hat_Enterprise_Linux) for Red Hat Enterprise Linux virtual machines and [Installing the Guest Agents and Drivers on Windows](Installing_the_Guest_Agents_and_Drivers_on_Windows) for Windows virtual machines.

**Important:** Virtual machines are identified in the Satellite server by their FQDN. This ensures that an external content host ID does not need to be maintained in Red Hat Virtualization.

**Configuring Red Hat Satellite Errata Management**

**Note:** The virtual machine must be registered to the Satellite server as a content host and have the katello-agent package installed.

For more information on how to configure a host registration see [Configuring a Host for Registration](https://access.redhat.com/documentation/en-US/Red_Hat_Satellite/6.1/html-single/User_Guide/index.html#sect-Red_Hat_Satellite-User_Guide-Configuring_Hosts-Configuring_a_Host_for_Registration) in the *Red Hat Satellite User Guide* and for more information on how to register a host and install the katello-agent package see [Registration](https://access.redhat.com/documentation/en-US/Red_Hat_Satellite/6.1/html-single/User_Guide/index.html#sect-Red_Hat_Satellite-User_Guide-Configuring_Hosts-Registration) in the *Red Hat Satellite User Guide*

1. Click the **Virtual Machines** tab and select a virtual machine.

2. Click **Edit**.

3. Click the **Foreman/Satellite** tab.

4. Select the required Satellite server from the **Provider** drop-down list.

5. Click **OK**.
