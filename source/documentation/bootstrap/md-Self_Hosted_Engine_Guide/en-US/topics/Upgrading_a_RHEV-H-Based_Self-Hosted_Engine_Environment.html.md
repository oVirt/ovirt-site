# Upgrading a RHEV-H-Based Self-Hosted Engine Environment

Upgrading a RHEV-H-based self-hosted engine environment from RHEV 3.6 to RHV 4.0 requires that you install the latest Red Hat Virtualization Host (RHVH) 4.0 and upgrade to Red Hat Virtualization Manager (RHV-M) 4.0. An upgrade utility that is provided with Red Hat Virtualization 4.0 will install Red Hat Enterprise Linux 7 on the Manager virtual machine and restore a backup of the 3.6 Manager database on the new Manager.

**Important:** The upgrade utility builds a new Manager based on a template. Manual changes or custom configuration to the original Manager such as custom users, SSH keys, and monitoring will need to be reapplied manually on the new Manager.

During the upgrade procedure you will be asked to create a backup of the 3.6 Manager and copy it to the host machine where the upgrade is being performed.

**Important:** All data centers and clusters in the environment must have the cluster compatibility level set to version 3.6 before attempting the procedure.

The upgrade process involves the following key steps:

* Place the high-availability agents that manage the Manager virtual machine into the global maintenance mode.

* Add a new RHVH 4.0 host to your environment.

* Migrate the Manager virtual machine to the new host and set as SPM.

* Run the upgrade utility to upgrade the Manager.

* Update the hosts.

* After the Manager virtual machine and all hosts in the cluster have been updated, change the cluster compatibility version to 4.0.

**Upgrading the Self-Hosted Engine**

1. Install a new RHVH 4.0 host. See the [*Installation Guide*](https://access.redhat.com/documentation/en/red-hat-virtualization/4.0/single/installation-guide#part-Installing_Hypervisor_Hosts) for instructions to install RHVH.
d

2. Add the new host to your environment.

    **Note:** The new host must be added as an additional self-hosted engine host in order to host the Manager virtual machine. See [Installing Additional Hosts to a Self-Hosted Environment](chap-Installing_Additional_Hosts_to_a_Self-Hosted_Environment) for more information.

3. Disable the high-availability agents on all the self-hosted engine hosts. To do this run the following command on any host in the cluster.

        # hosted-engine --set-maintenance --mode=global

    **Note:** Run `hosted-engine --vm-status` to confirm that the environment is in maintenance mode.

4. Download the RHV-M Virtual Appliance from the Customer Portal and copy it to the new host:

    1. Log in to the Customer Portal at [https://access.redhat.com](https://access.redhat.com).

    2. Click **Downloads* in the menu bar.

    3. Click **Red Hat Virtualization** > **Download Latest** to access the product download page.

    4. Choose the appliance for Red Hat Virtualization 4.0 and click **Download Now**.

    Secure copy the OVA file to the Red Hat Virtualization Host: 

        scp rhvm-appliance.ova root@host.example.com:/usr/share

5. Migrate the Manager virtual machine to the RHVH 4.0 host and set the host as the Storage Pool Manager (SPM).

6. On the Manager virtual machine, enable the required repository.

        # subscription-manager repos --enable=rhel-7-server-rhv-4.0-rpms

7. Run the upgrade script to upgrade the Manager virtual machine. If not already installed, install the `screen` package.

        # yum install screen
        # screen
        # hosted-engine --upgrade-appliance

    **Note:** The script will ask for the location of the RHV-M Virtual Appliance you copied to the host. It will also prompt you to create a backup of the Manager database and provide its full location.

8. After the upgrade is complete, disable global maintenance:

        # hosted-engine --set-maintenance --mode=none

If anything went wrong during the upgrade, power off the Manager by using the `hosted-engine  --vm-poweroff` command, then rollback the upgrade by running `hosted-engine --rollback-upgrade`.

Before updating the Red Hat Enterprise Linux hosts in the environment, disable the version 3.6 repositories and enable the required 4.0 repository by running the following commands on the host you wish to update.

    # subscription-manager repos --disable=rhel-7-server-rhev-mgmt-agent-rpms
    # subscription-manager repos --enable=rhel-7-server-rhv-4-mgmt-agent-rpms

RHEV-H hosts must be reinstalled with RHVH 4.0. See [Red Hat Virtualization Hosts](https://access.redhat.com/documentation/en/red-hat-virtualization/4.0/single/installation-guide/#Red_Hat_Virtualization_Hosts) in the *Installation Guide*.

You may now update the hosts in the environment, then update the data center and cluster compatibility level to 4.0. See the [*Upgrade Guide*](https://access.redhat.com/documentation/en/red-hat-virtualization/4.0/paged/upgrade-guide/) for more information.
