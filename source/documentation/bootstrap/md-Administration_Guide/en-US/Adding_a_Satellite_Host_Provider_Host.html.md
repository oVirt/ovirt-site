# Adding a Satellite Host Provider Host

The process for adding a Satellite host provider host is almost identical to that of adding a Red Hat Enterprise Linux host except for the method by which the host is identified in the Manager. The following procedure outlines how to add a host provided by a Satellite host provider.

**Adding a Satellite Host Provider Host**

1. Click the **Hosts** resource tab to list the hosts in the results list.

2. Click **New** to open the **New Host** window.

3. Use the drop-down menu to select the **Host Cluster** for the new host.

4. Select the **Foreman/Satellite** check box to display the options for adding a Satellite host provider host and select the provider from which the host is to be added.

5. Select either **Discovered Hosts** or **Provisioned Hosts**.

    * **Discovered Hosts** (default option): Select the host, host group, and compute resources from the drop-down lists.

    * **Provisioned Hosts**: Select a host from the **Providers Hosts** drop-down list.

    Any details regarding the host that can be retrieved from the external provider are automatically set, and can be edited as desired.

6. Enter the **Name**, **Address**, and **SSH Port** (Provisioned Hosts only) of the new host.

7. Select an authentication method to use with the host.

    * Enter the root user's password to use password authentication.

    * Copy the key displayed in the **SSH PublicKey** field to `/root/.ssh/authorized_hosts` on the host to use public key authentication (Provisioned Hosts only).

8. You have now completed the mandatory steps to add a Red Hat Enterprise Linux host. Click the **Advanced Parameters** drop-down button to show the advanced host settings.

    1. Optionally disable automatic firewall configuration.

    2. Optionally disable the use of JSON protocol.

    3. Optionally add a host SSH fingerprint to increase security. You can add it manually, or fetch it automatically.

9. You can configure the **Power Management**, **SPM**, **Console**, and **Network Provider** using the applicable tabs now; however, as these are not fundamental to adding a Red Hat Enterprise Linux host, they are not covered in this procedure.

10. Click **OK** to add the host and close the window.

The new host displays in the list of hosts with a status of `Installing`, and you can view the progress of the installation in the details pane. After installation is complete, the status will update to `Reboot`. The host must be activated for the status to change to `Up`.
