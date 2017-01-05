# Pools

* [Pools](Pools)

## Virtual Machine Pool Tasks

* [Creating a desktop pool](Creating_a_desktop_pool)

### Explanation of Settings and Controls in the New Pool and Edit Pool Windows

* [New Pool General Settings Explained](New_Pool_General_Settings_Explained)
* [New Pool Pool Settings Explained](New_Pool_Pool_Settings_Explained)
* [New Pool and Edit Pool Console Settings Explained](New_Pool_and_Edit_Pool_Console_Settings_Explained)
* [Virtual Machine Pool Host settings explained](Virtual_Machine_Pool_Host_settings_explained)

### Editing a Virtual Machine Pool

* [Editing a Virtual Machine Pool](Editing_a_Virtual_Machine_Pool)
* [Prestarting Virtual Machines in a Pool](Prestarting_Virtual_Machines_in_a_Pool)
* [Adding virtual machines to a desktop pool](Adding_virtual_machines_to_a_desktop_pool)
* [Detaching desktops from a desktop pool](Detaching_desktops_from_a_desktop_pool)

<!-- end ### section -->

* [Removing a desktop pool](Removing_a_desktop_pool)

## Pools and Permissions

* [Data center logical network entities](Data_center_logical_network_entities)
* [Cluster logical network entities](Cluster_logical_network_entities)
* [Assigning an Administrator or User Role to a Resource](Assigning_an_Administrator_or_User_Role_to_a_Resource1)
* [To remove a system administrator role to a data center](To_remove_a_system_administrator_role_to_a_data_center)

## Trusted Compute Pools

Trusted compute pools are secure clusters based on Intel Trusted Execution Technology (Intel TXT). Trusted clusters only allow hosts that are verified by Intel's OpenAttestation, which measures the integrity of the host's hardware and software against a White List database. Trusted hosts and the virtual machines running on them can be assigned tasks that require higher security. For more information on Intel TXT, trusted systems, and attestation, see [https://software.intel.com/en-us/articles/intel-trusted-execution-technology-intel-txt-enabling-guide](https://software.intel.com/en-us/articles/intel-trusted-execution-technology-intel-txt-enabling-guide).](https://software.intel.com/en-us/articles/intel-trusted-execution-technology-intel-txt-enabling-guide](https://software.intel.com/en-us/articles/intel-trusted-execution-technology-intel-txt-enabling-guide).)

Creating a trusted compute pool involves the following steps:

* Configuring the Manager to communicate with an OpenAttestation server.

* Creating a trusted cluster that can only run trusted hosts.

* Adding trusted hosts to the trusted cluster. Hosts must be running the OpenAttestation agent to be verified as trusted by the OpenAttestation sever.

For information on installing an OpenAttestation server, installing the OpenAttestation agent on hosts, and creating a White List database, see [https://github.com/OpenAttestation/OpenAttestation/wiki](https://github.com/OpenAttestation/OpenAttestation/wiki).](https://github.com/OpenAttestation/OpenAttestation/wiki](https://github.com/OpenAttestation/OpenAttestation/wiki).)

* [Connecting OAT Server to Manager](Connecting_OAT_Server_to_Manager)
* [Creating a Trusted Cluster](Creating_a_Trusted_Cluster)
* [Adding a Trusted Host](Adding_a_Trusted_Host)
