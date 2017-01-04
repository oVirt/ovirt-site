# Adding a Trusted Host

Red Hat Enterprise Linux hosts can be added to trusted clusters and measured against a White List database by the OpenAttestation server. Hosts must meet the following requirements to be trusted by the OpenAttestation server:

* Intel TXT is enabled in the BIOS.

* The OpenAttestation agent is installed and running.

* Software running on the host matches the OpenAttestation server's White List database.

**Adding a Trusted Host**

1. Select the **Hosts** tab.

2. Click **New**.

3. Select a trusted cluster from the **Host Cluster** drop-down list.

4. Enter a **Name** for the host.

5. Enter the **Address** of the host.

6. Enter the host's root **Password**.

7. Click **OK**.

After the host is added to the trusted cluster, it is assessed by the OpenAttestation server. If a host is not trusted by the OpenAttestation server, it will move to a `Non Operational` state and should be removed from the trusted cluster.
