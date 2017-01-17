# Chapter 7: Installing Additional Hosts to a Self-Hosted Environment

Additional self-hosted engine hosts are added in the same way as a regular host, with an additional step to deploy the host as a self-hosted engine host. The shared storage domain is automatically detected and the host can be used as a failover host to host the Manager virtual machine when required. You can also attach regular hosts to a self-hosted engine environment, but they cannot be used to host the Manager virtual machine. It is highly recommended to have at least two self-hosted engine hosts to ensure the Manager virtual machine is highly available. Additional hosts can also be added using the REST API.

**Prerequisites**

* For a oVirt Node-based self-hosted engine environment, you must have prepared a freshly installed oVirt Node system on a physical host. See [Red Hat Virtualization Hosts](https://access.redhat.com/documentation/en/red-hat-virtualization/4.0/single/installation-guide/#Red_Hat_Virtualization_Hosts) in the *Installation Guide*.

* If you are reusing a self-hosted engine host, remove its existing self-hosted engine configuration. See the Removing a Host from a Self-Hosted Engine Environment section in [Chapter 5: Maintenance and Upgrading Resources](../chap-Maintenance_and_Upgrading_Resources).

**Adding an Additional Self-Hosted Engine Host**

1. In the Administration Portal, click the **Hosts** resource tab.

2. Click **New**.

    For information on additional host settings, see [Explanation of Settings and Controls in the New Host and Edit Host Windows](https://access.redhat.com/documentation/en/red-hat-virtualization/4.0/single/administration-guide#sect-Explanation_of_Settings_and_Controls_in_the_New_Host_and_Edit_Host_Windows) in the *Administration Guide*.

3. Use the drop-down list to select the **Data Center** and **Host Cluster** for the new host.

4. Enter the **Name** and the **Address** of the new host. The standard SSH port, port 22, is auto-filled in the **SSH Port** field.

5. Select an authentication method to use for the Manager to access the host.

    * Enter the root user's password to use password authentication.

    * Alternatively, copy the key displayed in the **SSH PublicKey** field to `/root/.ssh/authorized_keys` on the host to use public key authentication.

6. Optionally, configure power management, where the host has a supported power management card. For information on power management configuration, see [Host Power Management Settings Explained](https://access.redhat.com/documentation/en/red-hat-virtualization/4.0/single/administration-guide#Host_Power_Management_settings_explained) in the *Administration Guide*.

6. Click the **Hosted Engine** sub-tab.

7. Select the **Deploy** radio button.

8. Click **OK**.

**Prev:** [Chapter 6: Backing up and Restoring an EL-Based Self-Hosted Environment](../chap-Backing_up_and_Restoring_an_EL-Based_Self-Hosted_Environment) <br>
**Next:** [Chapter 8: Migrating Databases](../chap-Migrating_Databases)
