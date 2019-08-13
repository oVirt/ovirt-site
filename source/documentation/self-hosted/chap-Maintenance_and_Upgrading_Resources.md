---
title: Administering the Self-Hosted Engine
---

# Chapter 5: Administering the Self-Hosted Engine

## Maintaining the Self-Hosted Engine

The maintenance modes enable you to start, stop, and modify the engine virtual machine without interference from the high-availability agents, and to restart and modify the hosts in the environment without interfering with the engine.

There are three maintenance modes that can be enforced:

* `global` - All high-availability agents in the cluster are disabled from monitoring the state of the engine virtual machine. The global maintenance mode must be applied for any setup or upgrade operations that require the engine to be stopped, such as upgrading to a later version of oVirt.

* `local` - The high-availability agent on the host issuing the command is disabled from monitoring the state of the engine virtual machine. The host is exempt from hosting the engine virtual machine while in local maintenance mode; if hosting the engine virtual machine when placed into this mode, the engine will be migrated to another host, provided there is a suitable contender. The local maintenance mode is recommended when applying system changes or updates to the host.

* `none` - Disables maintenance mode, ensuring that the high-availability agents are operating.

**Maintaining an EL-Based Self-Hosted Engine (Local Maintenance)**

1. Place a self-hosted engine host into the local maintenance mode:

    * In the Administration Portal, click **Compute** &rarr; **Hosts** and select a self-hosted engine node.

    * Click **Management** &rarr; **Maintenance**. The local maintenance mode is automatically triggered for that node.

    * You can also set the maintenance mode from the command line:

            # hosted-engine --set-maintenance --mode=local

2. After you have completed any maintenance tasks, disable the maintenance mode:

        # hosted-engine --set-maintenance --mode=none

**Maintaining an EL-Based Self-Hosted Engine (Global Maintenance)**

1. Place a self-hosted engine host into the global maintenance mode:

    * In the Administration Portal, click **Compute** &rarr; **Hosts** select any self-hosted engine node, and click **More Actions** &rarr; **Enable Global HA Maintenance**.

    * You can also set the maintenance mode from the command line:

            # hosted-engine --set-maintenance --mode=global

2. After you have completed any maintenance tasks, disable the maintenance mode:

        # hosted-engine --set-maintenance --mode=none

## Administering the Engine Virtual engine

The `hosted-engine` utility is provided to assist with administering the Engine virtual machine. It can be run on any self-hosted engine nodes in the environment. For all the options, run `hosted-engine --help`. For additional information on a specific command, run `hosted-engine --command --help`.

The following procedure shows you how to update the self-hosted engine configuration file (**/var/lib/ovirt-hosted-engine-ha/broker.conf**) on the shared storage domain after the initial deployment. Currently, you can configure email notifications using SMTP for any HA state transitions on the self-hosted engine nodes. The keys that can be updated include: `smtp-server`, `smtp-port`, `source-email`, `destination-emails`, and `state_transition`.

**Updating the Self-Hosted Engine Configuration on the Shared Storage Domain**

1. On a self-hosted engine node, set the `smtp-server` key to the desired SMTP server address:

        # hosted-engine --set-shared-config smtp-server smtp.example.com --type=broker

  **Note:** To verify that the self-hosted engine configuration file has been updated, run:

          # hosted-engine --get-shared-config smtp-server --type=broker
          broker : smtp.example.com, type : broker

2. Check that the default SMTP port (port 25) has been configured:

        # hosted-engine --get-shared-config smtp-port --type=broker
        broker : 25, type : broker

3. Specify an email address you want the SMTP server to use to send out email notifications. Only one address can be specified.

        # hosted-engine --set-shared-config source-email source@example.com --type=broker

4. Specify the destination email address to receive email notifications. To specify multiple email addresses, separate each address by a comma.

        # hosted-engine --set-shared-config destination-emails destination1@example.com,destination2@example.com --type=broker

To verify that SMTP has been properly configured for your self-hosted engine environment, change the HA state on a self-hosted engine node and check if email notifications were sent. For example, you can change the HA state by placing HA agents into maintenance mode.

## Configuring Memory Slot Reserved for the Self-Hosted Engine on Additional hosts

If the Engine virtual machine shuts down or needs to be migrated, there must be enough memory on a self-hosted engine node for the Engine virtual machine to restart on or migrate to it. This memory can be reserved on multiple self-hosted engine nodes by using a scheduling policy. The scheduling policy checks if enough memory to start the Engine virtual machine will remain on the specified number of additional self-hosted engine nodes before starting or migrating any virtual machines. See Creating a Scheduling Policy in the Administration Guide for more information about scheduling policies.

**Configuring Memory Slots Reserved for the Self-Hosted Engine on Additional Hosts**

1. Click **Compute** &rarr; **Clusters** and select the cluster containing the self-hosted engine nodes.

2. Click **Edit**.

3. Click the **Scheduling Policy** tab.

4. Click **+** and select **HeSparesCount**.

5. Enter the number of additional self-hosted engine nodes that will reserve enough free memory to start the Engine virtual machine.

6. Click **OK**.

## Installing Additional Self-Hosted Engine nodes

Additional self-hosted engine nodes are added in the same way as a regular host, with an additional step to deploy the host as a self-hosted engine node. The shared storage domain is automatically detected and the node can be used as a failover host to host the Engine virtual machine when required. You can also attach regular hosts to a self-hosted engine environment, but they cannot host the Engine virtual machine. Red Hat highly recommends having at least two self-hosted engine nodes to ensure the Engine virtual machine is highly available. Additional hosts can also be added using the REST API.

**Prerequisites**

* For an EL-based self-hosted engine environment, you must have prepared a freshly installed Enterprise Linux system on a physical host, and attached the required subscriptions.

* For a oVirt Engine-based self-hosted engine environment, you must have prepared a freshly installed oVirt Node system on a physical host.

* If you are reusing a self-hosted engine node, remove its existing self-hosted engine configuration.

**Adding an Additional Self-Hosted Engine Node**

1. In the Administration Portal, click **Compute** &rarr; **Hosts**.

2. Click **New**.

3. Use the drop-down list to select the **Data Center** and **Host Cluster** for the new host.

4. Enter the **Name** and the **Address** of the new host. The standard SSH port, port 22, is auto-filled in the **SSH Port** field.

5. Select an authentication method to use for the Engine to access the host.

  * Enter the root user’s password to use password authentication.

  * Alternatively, copy the key displayed in the **SSH PublicKey** field to **/root/.ssh/authorized_keys** on the host to use public key authentication.

6. Optionally, configure power management, where the host has a supported power management card.

7. Click the **Hosted Engine** tab.

8. Select **Deploy**.

9. Click **OK**.

## Reinstalling an Existing Host as a Self-Hosted Engine Nodes

You can convert an existing, regular host in a self-hosted engine environment to a self-hosted engine node capable of hosting the Engine virtual machine.

**Reinstalling an Existing Host as a Self-Hosted Engine Node**

1. Click **Compute** &rarr; **Hosts** and select the host.

2. Click **Management** &rarr; **Maintenance** and click **OK**.

3. Click **Installation** &rarr; **Reinstall**.

4. Click the **Hosted Engine** tab and select **DEPLOY** from the drop-down list.

5. Click **OK**.

The host is reinstalled with self-hosted engine configuration, and is flagged with a crown icon in the Administration Portal.

## Removing a Host from a Self-Hosted Engine Environment

If you wish to remove a self-hosted engine host from your environment, you will need to place the host into maintenance, disable the HA services, and remove the self-hosted engine configuration file.

**Removing a Host from a Self-Hosted Engine Environment**

1. In the Administration Portal, **Compute** &rarr; **Hosts** and select the self-hosted engine node.

2. Click **Management** &rarr; **Maintenance** and click **OK**.

3. Click **Installation** &rarr; **Reinstall**.

4. Click the **Hosted Engine** tab and select **UNDEPLOY** from the drop-down list. This action stops the `ovirt-ha-agent` and `ovirt-ha-broker` services and removes the self-hosted engine configuration file.

5. Click **OK**.

6. Optionally, click **Remove** to open the **Remove Host(s)** confirmation window and click **OK**.

**Prev:** [Chapter 4: Migrating from Bare Metal to an EL-Based Self-Hosted Environment](chap-Migrating_from_Bare_Metal_to_an_EL-Based_Self-Hosted_Environment) <br>
**Next:** [Chapter 6: Upgrading the Self-Hosted Engine](chap-upgrading_the_self-hosted_engine)

[Adapted from RHV 4.2 documentation - CC-BY-SA](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.2/html/self-hosted_engine_guide/chap-administering_the_self-hosted_engine)
