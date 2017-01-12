# Configuring Satellite Errata Management for a Host

Red Hat Virtualization can be configured to view errata from Red Hat Satellite. This enables the host administrator to receive updates about available errata, and their importance, in the same dashboard used to manage host configuration. For more information about Red Hat Satellite see the [Red Hat Satellite User Guide](https://access.redhat.com/site/documentation/en-US/Red_Hat_Satellite/6.1/html/User_Guide/index.html).

Red Hat Virtualization 4.0 supports errata management with Red Hat Satellite 6.1.

**Important:** Hosts are identified in the Satellite server by their FQDN. Hosts added using an IP address will not be able to report errata. This ensures that an external content host ID does not need to be maintained in Red Hat Virtualization.

The Satellite account used to manage the host must have Administrator permissions and a default organization set.

**Configuring Satellite Errata Management for a Host**

1. Add the Satellite server as an external provider. See [Adding Satellite for Host Provisioning](Adding_Satellite_for_Host_Provisioning) for more information.

2. Associate the required host with the Satellite server. 

    **Note:** The host must be registered to the Satellite server and have the katello-agent package installed.

    For more information on how to configure a host registration see [Configuring a Host for Registration](https://access.redhat.com/documentation/en-US/Red_Hat_Satellite/6.1/html-single/User_Guide/index.html#sect-Red_Hat_Satellite-User_Guide-Configuring_Hosts-Configuring_a_Host_for_Registration) in the *Red Hat Satellite User Guide* and for more information on how to register a host and install the katello-agent package see [Registration](https://access.redhat.com/documentation/en-US/Red_Hat_Satellite/6.1/html-single/User_Guide/index.html#sect-Red_Hat_Satellite-User_Guide-Configuring_Hosts-Registration) in the *Red Hat Satellite User Guide*

    1. In the **Hosts** tab, select the host in the results list.

    2. Click **Edit** to open the **Edit Host** window.

    3. Check the **Use Foreman/Satellite** checkbox.

    4. Select the required Satellite server from the drop-down list. 

    5. Click **OK**.

The host is now configured to show the available errata, and their importance, in the same dashboard used to manage host configuration.
