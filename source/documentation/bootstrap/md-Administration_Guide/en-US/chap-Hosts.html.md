# Hosts

* [Introduction to Hosts](Introduction_to_Hosts)
* [Red Hat Virtualization Hosts](Red_Hat_Virtualization_Hosts)
* [Adding Red Hat Enterprise Linux Hosts](Adding_Red_Hat_Enterprise_Linux_Hosts)
* [Satellite Host Provider Hosts](Satellite_Host_Provider_Hosts)

## Host Tasks

* [Adding a Host](Adding_a_Host)
* [Adding a Satellite Host Provider Host](Adding_a_Satellite_Host_Provider_Host)
* [Configuring Satellite Errata Management for a Host](Configuring_Satellite_Errata_Management_for_a_Host)

### Explanation of Settings and Controls in the New Host and Edit Host Windows

* [Host General Settings](Host_General_Settings)
* [Host Power Management settings explained](Host_Power_Management_settings_explained)
* [SPM priority settings explained](SPM_priority_settings_explained)
* [Host Console Settings Explained](Host_Console_Settings_Explained)
* [Network Provider Settings Explained](Network_Provider_Settings_Explained)
* [Kernel Settings Explained](Kernel_Settings_Explained)
* [Hosted Engine Settings Explained](Hosted_Engine_Settings_Explained)

<!-- end ### section -->

* [Configuring Host Power Management Settings](Configuring_Host_Power_Management_Settings)
* [Assigning a user to a virtual machine](Assigning_a_user_to_a_virtual_machine)
* [Moving a host to maintenance mode](Moving_a_host_to_maintenance_mode1)
* [Activating a host from maintenance mode](Activating_a_host_from_maintenance_mode)
* [Deleting a host](Deleting_a_host)
* [Updating a host between minor releases](Updating_a_host_between_minor_releases)
* [Reinstalling Virtualization Hosts](Reinstalling_Virtualization_Hosts)
* [Customizing hosts with tags](Customizing_hosts_with_tags)
* [Viewing Host Errata](Viewing_Host_Errata)
* [Viewing the Health Status of a Host](Viewing_the_Health_Status_of_a_Host)
* [Viewing Host Devices](Viewing_Host_Devices)
* [Preparing GPU Passthrough](Preparing_GPU_Passthrough)
* [Accessing Cockpit from the Admin Portal](Accessing_Cockpit_from_the_Admin_Portal)

## Host Resilience

* [Host high availability](Host_high_availability)
* [Power Management by Proxy in Red Hat Enterprise Virtualization](Power_Management_by_Proxy_in_Red_Hat_Enterprise_Virtualization)
* [Setting fencing parameters on a host](Setting_fencing_parameters_on_a_host)

### fence_kdump Advanced Configuration

**kdump**

Select a host to view the status of the kdump service in the**General** tab of the details pane:

* **Enabled**: kdump is configured properly and the kdump service is running.

* **Disabled**: the kdump service is not running (in this case kdump integration will not work properly).

* **Unknown**: happens only for hosts with an older VDSM version that does not report kdump status.

For more information on installing and using kdump, see the [Red Hat Enterprise Linux 7 Kernel Crash Dump Guide](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/Kernel_Crash_Dump_Guide/index.html).](Red Hat Enterprise Linux 7 Kernel Crash Dump Guide](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/Kernel_Crash_Dump_Guide/index.html).)

**fence_kdump**

Enabling**Kdump integration** in the**Power Management** tab of the**New Host** or**Edit Host** window configures a standard fence_kdump setup. If the environment's network configuration is simple and the Manager's FQDN is resolvable on all hosts, the default fence_kdump settings are sufficient for use.

However, there are some cases where advanced configuration of fence_kdump is necessary. Environments with more complex networking may require manual changes to the configuration of the Manager, fence_kdump listener, or both. For example, if the Manager's FQDN is not resolvable on all hosts with**Kdump integration** enabled, you can set a proper host name or IP address using `engine-config`:

    engine-config -s FenceKdumpDestinationAddress=A.B.C.D

The following example cases may also require configuration changes:

* The Manager has two NICs, where one of these is public-facing, and the second is the preferred destination for fence_kdump messages.

* You need to execute the fence_kdump listener on a different IP or port.

* You need to set a custom interval for fence_kdump notification messages, to prevent possible packet loss.

Customized fence_kdump detection settings are recommended for advanced users only, as changes to the default configuration are only necessary in more complex networking setups. For configuration options for the fence_kdump listener see [fence_kdump listener Configuration](fence_kdump_listener_Configuration). For configuration of kdump on the Manager see [Configuring fence_kdump on the Manager](Configuring_fence_kdump_on_the_Manager).

* [fence_kdump listener Configuration](fence_kdump_listener_Configuration)
* [Configuring fence_kdump on the Manager](Configuring_fence_kdump_on_the_Manager)

<!-- end ### section -->

* [Soft-Fencing Hosts](Soft-Fencing_Hosts)
* [Using power host power management functions](Using_power_host_power_management_functions)
* [Manually fencing or isolating a nonresponsive host](Manually_fencing_or_isolating_a_nonresponsive_host)

## Hosts and Permissions

* [To view hosts in a cluster](To_view_hosts_in_a_cluster)
* [To view virtual machines in a cluster](To_view_virtual_machines_in_a_cluster)
* [Assigning an Administrator or User Role to a Resource](Assigning_an_Administrator_or_User_Role_to_a_Resource4)
* [Removing an Administrator or User Role from a Resource](Removing_an_Administrator_or_User_Role_from_a_Resource5)
