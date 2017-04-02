---
title: Maintenance and Upgrading Resources
---

# Chapter 5: Maintenance and Upgrading Resources

## Maintaining the Self-Hosted Engine

The maintenance modes enable you to start, stop, and modify the engine virtual machine without interference from the high-availability agents, and to restart and modify the hosts in the environment without interfering with the engine.

There are three maintenance modes that can be enforced:

* `global` - All high-availability agents in the cluster are disabled from monitoring the state of the engine virtual machine. The global maintenance mode must be applied for any setup or upgrade operations that require the engine to be stopped, such as upgrading to a later version of oVirt.

* `local` - The high-availability agent on the host issuing the command is disabled from monitoring the state of the engine virtual machine. The host is exempt from hosting the engine virtual machine while in local maintenance mode; if hosting the engine virtual machine when placed into this mode, the engine will be migrated to another host, provided there is a suitable contender. The local maintenance mode is recommended when applying system changes or updates to the host.

* `none` - Disables maintenance mode, ensuring that the high-availability agents are operating.

**Maintaining an EL-Based Self-Hosted Engine (Local Maintenance)**

1. Place a self-hosted engine host into the local maintenance mode:

    * In the Administration Portal, place the host into maintenance, and the local maintenance mode is automatically triggered for that host.

    * You can also set the maintenance mode from the command line:

            # hosted-engine --set-maintenance --mode=local

2. After you have completed any maintenance tasks, disable the maintenance mode:

        # hosted-engine --set-maintenance --mode=none

**Maintaining an EL-Based Self-Hosted Engine (Global Maintenance)**

1. Place a self-hosted engine host into the global maintenance mode:

    * In the Administration Portal, right-click the engine virtual machine, and select **Enable Global HA Maintenance**.

    * You can also set the maintenance mode from the command line:

            # hosted-engine --set-maintenance --mode=global

2. After you have completed any maintenance tasks, disable the maintenance mode:

        # hosted-engine --set-maintenance --mode=none

## Removing a Host from a Self-Hosted Engine Environment

If you wish to remove a self-hosted engine host from your environment, you will need to place the host into maintenance, disable the HA services, and remove the self-hosted engine configuration file.

**Removing a Host from a Self-Hosted Engine Environment**

1. In the Administration Portal, click the **Hosts** tab. Select the host and click **Maintenance** to set the host to the local maintenance mode. This action stops the `ovirt-ha-agent` and `ovirt-ha-broker` services.

2. Log in to the host and disable the HA services so the services are not started upon a reboot:

        # systemctl disable ovirt-ha-agent
        # systemctl disable ovirt-ha-broker

3. Remove the self-hosted engine configuration file:

        # rm /etc/ovirt-hosted-engine/hosted-engine.conf

4. In the Administration Portal, select the same host, and click **Remove** to open the **Remove Host(s)** confirmation window. Click **OK**.

## Upgrading an EL-Based Self-Hosted Engine Environment

An oVirt 3.6 self-hosted engine environment can be upgraded to oVirt 4.0. An upgrade utility that is provided with oVirt 4.0 will install Enterprise Linux 7 on the Engine virtual machine and restore a backup of the 3.6 Engine database on the new Engine. After the Engine is upgraded to 4.0 you can update the self-hosted engine hosts, and any standard hosts, to 4.0.

**Important:** The upgrade utility builds a new Engine based on a template. Manual changes or custom configuration to the original Engine such as custom users, SSH keys, and monitoring will need to be reapplied manually on the new Engine.

**Note:** An in-place upgrade of the Engine virtual machine to Enterprise Linux 7 is not supported.

**Important:** The following procedure is only for upgrading an oVirt 3.6 self-hosted engine environment running on Enterprise Linux 7 hosts. All data centers and clusters in the environment must have the cluster compatibility level set to version 3.6 before attempting the procedure.

**Note:** The upgrade must occur on the host that is currently running the Engine virtual machine and is set as the SPM server. The upgrade utility will check for this.

The upgrade process involves the following key steps:

* Place the high-availability agents that manage the Engine virtual machine into the global maintenance mode.

* Enable the required repositories on the host and update the `ovirt-hosted-engine-setup` and `ovirt-engine-appliance` packages.

* Run `hosted-engine --upgrade-appliance` to upgrade the Engine virtual machine.

* Update the hosts.

* After the Engine virtual machine and all hosts in the cluster have been updated, change the cluster compatibility version to 4.0.

Before upgrading the Engine virtual machine, ensure the `/var/tmp` directory contains enough free space to extract the appliance files. If it does not, you can specify a different directory or mount alternate storage that does have the required space. The VDSM user and KVM group must have read, write, and execute permissions on the directory.

The upgrade procedure creates a backup disk on the self-hosted engine storage domain. You therefore need additional free space on the storage domain for the new appliance being deployed (50 GB by default). To increase the storage on iSCSI or Fibre Channel storage, you need to manually extend the LUN size on the storage and then extend the storage domain using the Engine. Refer to "Increasing iSCSI or FCP Storage" in the [Administration Guide](/documentation/admin-guide/administration-guide/) for more information about resizing a LUN.

The backup created during the upgrade procedure is not automatically deleted. You need to manually delete it after confirming the upgrade has been successful. The backup disks are labeled with `hosted-engine-backup-*`.

**Important:** During the upgrade procedure you will be asked to create a backup of the Engine and copy it to the host machine where the upgrade is being performed.

**Upgrading the Self-Hosted Engine**

1. Disable the high-availability agents on all the self-hosted engine hosts. To do this run the following command on any host in the cluster.

        # hosted-engine --set-maintenance --mode=global

    **Note:** Run `hosted-engine --vm-status` to confirm that the environment is in maintenance mode.

2. On the host that is currently set as SPM and contains the Engine virtual machine, enable the required repository.

3. Migrate all virtual machines except the Engine virtual machine to alternate hosts.

4. On the host, update the Engine virtual machine packages.

        # yum update ovirt-hosted-engine-setup ovirt-engine-appliance

5. Run the upgrade utility to upgrade the Engine virtual machine. If not already installed, install the `screen` package, which is available in the standard Enterprise Linux repository.

        # yum install screen
        # screen
        # hosted-engine --upgrade-appliance

    **Note:** You will be prompted to select the appliance if more than one is detected, and to create a backup of the Engine database and provide its full location.

6. After the upgrade is complete, disable global maintenance:

        # hosted-engine --set-maintenance --mode=none

If anything went wrong during the upgrade, power off the Engine by using the `hosted-engine  --vm-poweroff` command, then rollback the upgrade by running `hosted-engine --rollback-upgrade`.

Before updating the Enterprise Linux hosts in the environment, disable the version 3.6 repository and enable the required 4.0 repository.

oVirt Node hosts must be reinstalled with oVirt Node 4.0. See "oVirt Nodes" in the [Installation Guide](/documentation/install-guide/Installation_Guide/).

You may now update the hosts in the environment, then update the data center and cluster compatibility level to 4.0. See the [Upgrade Guide](/documentation/upgrade-guide/upgrade-guide/) for more information.

## Upgrading a oVirt Node-Based Self-Hosted Engine Environment

Upgrading a oVirt Node-based self-hosted engine environment from oVirt 3.6 to oVirt 4.0 requires that you install the latest oVirt Node 4.0 and upgrade to oVirt Engine 4.0. An upgrade utility that is provided with oVirt 4.0 will install Enterprise Linux 7 on the Engine virtual machine and restore a backup of the 3.6 Engine database on the new Engine.

**Important:** The upgrade utility builds a new Engine based on a template. Manual changes or custom configuration to the original Engine such as custom users, SSH keys, and monitoring will need to be reapplied manually on the new Engine.

During the upgrade procedure you will be asked to create a backup of the 3.6 Engine and copy it to the host machine where the upgrade is being performed.

**Important:** All data centers and clusters in the environment must have the cluster compatibility level set to version 3.6 before attempting the procedure.

The upgrade process involves the following key steps:

* Place the high-availability agents that manage the Engine virtual machine into the global maintenance mode.

* Add a new oVirt Node 4.0 host to your environment.

* Migrate the Engine virtual machine to the new host and set as SPM.

* Run the upgrade utility to upgrade the Engine.

* Update the hosts.

* After the Engine virtual machine and all hosts in the cluster have been updated, change the cluster compatibility version to 4.0.

**Upgrading the Self-Hosted Engine**

1. Install a new oVirt Node 4.0 host. See the [Installation Guide](/documentation/install-guide/Installation_Guide/) for instructions to install oVirt Node.
d

2. Add the new host to your environment.

    **Note:** The new host must be added as an additional self-hosted engine host in order to host the Engine virtual machine. See [Chapter 7: Installing Additional Hosts to a Self-Hosted Environment](../chap-Installing_Additional_Hosts_to_a_Self-Hosted_Environment) for more information.

3. Disable the high-availability agents on all the self-hosted engine hosts. To do this run the following command on any host in the cluster.

        # hosted-engine --set-maintenance --mode=global

    **Note:** Run `hosted-engine --vm-status` to confirm that the environment is in maintenance mode.

4. Download the oVirt Engine Virtual Appliance from the oVirt web site and copy it to the new host:

    a. Visit the Jenkins.oVirt.org site at [http://jenkins.ovirt.org/view/All/job/ovirt-appliance_master_build-artifacts-el7-x86_64/](http://jenkins.ovirt.org/view/All/job/ovirt-appliance_master_build-artifacts-el7-x86_64/).

    b. Click the latest release.

    Secure copy the OVA file to the oVirt Host:

        scp oVirt-Engine-Appliance-CentOS-\*.ova root@host.example.com:/usr/share

5. Migrate the Engine virtual machine to the oVirt Node 4.0 host and set the host as the Storage Pool Engine (SPM).

6. On the Engine virtual machine, enable the required repository.

7. Run the upgrade script to upgrade the Engine virtual machine. If not already installed, install the `screen` package.

        # yum install screen
        # screen
        # hosted-engine --upgrade-appliance

    **Note:** The script will ask for the location of the oVirt Engine Virtual Appliance you copied to the host. It will also prompt you to create a backup of the Engine database and provide its full location.

8. After the upgrade is complete, disable global maintenance:

        # hosted-engine --set-maintenance --mode=none

If anything went wrong during the upgrade, power off the Engine by using the `hosted-engine  --vm-poweroff` command, then rollback the upgrade by running `hosted-engine --rollback-upgrade`.

Before updating the Enterprise Linux hosts in the environment, disable the version 3.6 repositories and enable the required 4.0 repository.

oVirt Node hosts must be reinstalled with oVirt Node 4.0. See "oVirt Nodes" in the [Installation Guide](/documentation/install-guide/Installation_Guide/).

You may now update the hosts in the environment, then update the data center and cluster compatibility level to 4.0. See the [Upgrade Guide](/documentation/upgrade-guide/upgrade-guide/) for more information.

**Prev:** [Chapter 4: Migrating from Bare Metal to an EL-Based Self-Hosted Environment](../chap-Migrating_from_Bare_Metal_to_an_EL-Based_Self-Hosted_Environment) <br>
**Next:** [Chapter 6: Backing up and Restoring an EL-Based Self-Hosted Environment](../chap-Backing_up_and_Restoring_an_EL-Based_Self-Hosted_Environment)
