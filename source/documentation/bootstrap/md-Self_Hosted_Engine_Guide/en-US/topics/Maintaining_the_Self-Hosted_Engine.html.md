# Maintaining the Self-Hosted Engine

The maintenance modes enable you to start, stop, and modify the engine virtual machine without interference from the high-availability agents, and to restart and modify the hosts in the environment without interfering with the engine.

There are three maintenance modes that can be enforced:

* `global` - All high-availability agents in the cluster are disabled from monitoring the state of the engine virtual machine. The global maintenance mode must be applied for any setup or upgrade operations that require the engine to be stopped, such as upgrading to a later version of Red Hat Virtualization.

* `local` - The high-availability agent on the host issuing the command is disabled from monitoring the state of the engine virtual machine. The host is exempt from hosting the engine virtual machine while in local maintenance mode; if hosting the engine virtual machine when placed into this mode, the engine will be migrated to another host, provided there is a suitable contender. The local maintenance mode is recommended when applying system changes or updates to the host.

* `none` - Disables maintenance mode, ensuring that the high-availability agents are operating.

**Maintaining a RHEL-Based Self-Hosted Engine (Local Maintenance)**

1. Place a self-hosted engine host into the local maintenance mode:

    * In the Administration Portal, place the host into maintenance, and the local maintenance mode is automatically triggered for that host.

    * You can also set the maintenance mode from the command line:

            # hosted-engine --set-maintenance --mode=local

2. After you have completed any maintenance tasks, disable the maintenance mode:

        # hosted-engine --set-maintenance --mode=none

**Maintaining a RHEL-Based Self-Hosted Engine (Global Maintenance)**

1. Place a self-hosted engine host into the global maintenance mode:

    * In the Administration Portal, right-click the engine virtual machine, and select **Enable Global HA Maintenance*.

    * You can also set the maintenance mode from the command line:

            # hosted-engine --set-maintenance --mode=global

2. After you have completed any maintenance tasks, disable the maintenance mode:

        # hosted-engine --set-maintenance --mode=none

