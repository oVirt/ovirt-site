# Adding a Host to the Red Hat Virtualization Manager

Adding a host to your Red Hat Virtualization environment can take some time, as the following steps are completed by the platform: virtualization checks, installation of packages, creation of bridge, and a reboot of the host. Use the details pane to monitor the process as the host and the Manager establish a connection.

**Adding a Host to the Red Hat Virtualization Manager**

1. From the Administration Portal, click the **Hosts** resource tab.

2. Click **New**.

3. Use the drop-down list to select the **Data Center** and **Host Cluster** for the new host.

4. Enter the **Name** and the **Address** of the new host. The standard SSH port, port 22, is auto-filled in the **SSH Port** field.

5. Select an authentication method to use for the Manager to access the host.

    * Enter the root user's password to use password authentication.

    * Alternatively, copy the key displayed in the **SSH PublicKey** field to `/root/.ssh/authorized_keys` on the host to use public key authentication.

6. Click the **Advanced Parameters** button to expand the advanced host settings.

    1. Optionally disable automatic firewall configuration.

    2. Optionally add a host SSH fingerprint to increase security. You can add it manually, or fetch it automatically.

7. Optionally configure **Power Management**, **SPM**, **Console**, **Network Provider**, and **Kernel**. See [Explanation of Settings and Controls in the New Host and Edit Host Windows](sect-Explanation_of_Settings_and_Controls_in_the_New_Host_and_Edit_Host_Windows) for more information. **Hosted Engine** is used when deploying or undeploying a host for a self-hosted engine deployment.

8. Click **OK**.

The new host displays in the list of hosts with a status of `Installing`, and you can view the progress of the installation in the details pane. After a brief delay the host status changes to **Up**.
