---
title: Adding a Hypervisor
---

# Chapter 8: Adding a Hypervisor

Adding a host to your oVirt environment can take some time, as the following steps are completed by the platform: virtualization checks, installation of packages, creation of bridge, and a reboot of the host. Use the details pane to monitor the process as the host and the Engine establish a connection.

**Adding a Host to the oVirt Engine**

1. From the Administration Portal, click **Compute** and then **Hosts**.

2. Click **New**.

3. Use the drop-down list to select the **Host Cluster** for the new host.

4. Enter the **Name** and the **Hostname** of the new host. The standard SSH port, port 22, is auto-filled in the **SSH Port** field.

5. Select an authentication method to use for the Engine to access the host.

    * Enter the root user's password to use password authentication.

    * Alternatively, copy the key displayed in the **SSH PublicKey** field to `/root/.ssh/authorized_keys` on the host to use public key authentication.

6. Click the **Advanced Parameters** button to expand the advanced host settings.

    a. Optionally disable automatic firewall configuration.

    b. Optionally disable use of JSON protocol.

    c. Optionally add a host SSH fingerprint to increase security. You can add it manually, or fetch it automatically.

7. Optionally configure power management, where the host has a supported power management card. For information on power management configuration, see "Host Power Management Settings Explained" in the [Administration Guide](/documentation/admin-guide/administration-guide/).

8. Click **OK**.

The new host displays in the list of hosts with a status of `Installing`, and you can view the progress of the installation in the details pane. After a brief delay the host status changes to **Up**

**Prev:** [Chapter 7: Enterprise Linux Hosts](../chap-Enterprise_Linux_Hosts) <br>
**Next:** [Chapter 9: Configuring Storage](../chap-Configuring_Storage)
