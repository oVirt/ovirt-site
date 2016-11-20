# Removing a Host from a Self-Hosted Engine Environment

If you wish to remove a self-hosted engine host from your environment, you will need to place the host into maintenance, disable the HA services, and remove the self-hosted engine configuration file.

**Removing a Host from a Self-Hosted Engine Environment**

1. In the Administration Portal, click the **Hosts** tab. Select the host and click **Maintenance** to set the host to the local maintenance mode. This action stops the `ovirt-ha-agent` and `ovirt-ha-broker` services.

2. Log in to the host and disable the HA services so the services are not started upon a reboot:

        # systemctl disable ovirt-ha-agent
        # systemctl disable ovirt-ha-broker

3. Remove the self-hosted engine configuration file:

        # rm /etc/ovirt-hosted-engine/hosted-engine.conf

4. In the Administration Portal, select the same host, and click **Remove** to open the **Remove Host(s)** confirmation window. Click **OK**.
