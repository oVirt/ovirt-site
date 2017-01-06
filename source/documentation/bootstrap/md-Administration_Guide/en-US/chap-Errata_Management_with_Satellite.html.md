# Errata Management with Red Hat Satellite

Red Hat Virtualization can be configured to view errata from Red Hat Satellite in the Red Hat Virtualization Manager. This enables the administrator to receive updates about available errata, and their importance, for hosts, virtual machines, and the Manager once they have been associated with a Red Hat Satellite provider. Administrators can then choose to apply the updates by running an update on the required host, virtual machine, or on the Manager. For more information about Red Hat Satellite see the [Red Hat Satellite User Guide](https://access.redhat.com/site/documentation/en-US/Red_Hat_Satellite/6.1/html/User_Guide/index.html).

Red Hat Virtualization 4.0 supports errata management with Red Hat Satellite 6.1.

**Important:** The Manager, hosts, and virtual machines are identified in the Satellite server by their FQDN. This ensures that external content host IDs do not need to be maintained in Red Hat Virtualization.

The Satellite account used to manage the Manager, hosts and virtual machines must have Administrator permissions and a default organization set.

**Configuring Red Hat Virtualization Errata**

To associate a Manager, host, and virtual machine with a Red Hat Satellite provider first the Manager must be associated with a provider. Then the host is associated with the same provider and configured. Finally, the virtual machine is associated with the same provider and configured.

1. Associate the Manager by adding the required Satellite server as an external provider. See [Adding Satellite for Host Provisioning](Adding_Satellite_for_Host_Provisioning) for more information.

    **Note:** The Manager must be registered to the Satellite server as a content host and have the katello-agent package installed.

    For more information on how to configure a host registration see [Configuring a Host for Registration](https://access.redhat.com/documentation/en-US/Red_Hat_Satellite/6.1/html-single/User_Guide/index.html#sect-Red_Hat_Satellite-User_Guide-Configuring_Hosts-Configuring_a_Host_for_Registration) in the *Red Hat Satellite User Guide* and for more information on how to register a host and install the katello-agent package see [Registration](https://access.redhat.com/documentation/en-US/Red_Hat_Satellite/6.1/html-single/User_Guide/index.html#sect-Red_Hat_Satellite-User_Guide-Configuring_Hosts-Registration) in the *Red Hat Satellite User Guide*

2. Optionally, configure the required hosts to display available errata. See [Configuring Satellite Errata Management for a Host](Configuring_Satellite_Errata_Management_for_a_Host) for more information.

3. Optionally, configure the required virtual machines to display available errata. The associated host needs to be configured prior to configuring the required virtual machines. See [Configuring Red Hat Satellite Errata Management for a Virtual Machine](https://access.redhat.com/documentation/en/red-hat-virtualization/4.0/single/virtual-machine-management-guide#Configuring_Satellite_Errata) in the *Virtual Machine Management Guide* for more information.

**Viewing Red Hat Virtualization Manager Errata**

1. Select the **Errata** entry in the tree pane.

2. Click the **Security**, **Bugs**, or **Enhancements** checkboxes to view only those errata types.

For more information on viewing available errata for hosts see [Viewing Host Errata](Viewing_Host_Errata) and for virtual machines see [Viewing Red Hat Satellite Errata for a Virtual Machine](https://access.redhat.com/documentation/en/red-hat-virtualization/4.0/single/virtual-machine-management-guide#Viewing_Satellite_Errata) in the *Virtual Machine Management Guide*.
