# Upgrading a RHEL-Based Self-Hosted Engine Environment

A Red Hat Enterprise Virtualization 3.6 self-hosted engine environment can be upgraded to Red Hat Virtualization 4.0. An upgrade utility that is provided with Red Hat Virtualization 4.0 will install Red Hat Enterprise Linux 7 on the Manager virtual machine and restore a backup of the 3.6 Manager database on the new Manager. After the Manager is upgraded to 4.0 you can update the self-hosted engine hosts, and any standard hosts, to 4.0.

**Important:** The upgrade utility builds a new Manager based on a template. Manual changes or custom configuration to the original Manager such as custom users, SSH keys, and monitoring will need to be reapplied manually on the new Manager.

**Note:** An in-place upgrade of the Manager virtual machine to Red Hat Enterprise Linux 7 is not supported.

**Important:** The following procedure is only for upgrading a Red Hat Enterprise Virtualization 3.6 self-hosted engine environment running on Red Hat Enterprise Linux 7 hosts. All data centers and clusters in the environment must have the cluster compatibility level set to version 3.6 before attempting the procedure.

**Note:** The upgrade must occur on the host that is currently running the Manager virtual machine and is set as the SPM server. The upgrade utility will check for this. 

The upgrade process involves the following key steps:

* Place the high-availability agents that manage the Manager virtual machine into the global maintenance mode.

* Enable the required repositories on the host and update the `ovirt-hosted-engine-setup` and `rhevm-appliance` packages.

* Run `hosted-engine --upgrade-appliance` to upgrade the Manager virtual machine.

* Update the hosts.

* After the Manager virtual machine and all hosts in the cluster have been updated, change the cluster compatibility version to 4.0.

Before upgrading the Manager virtual machine, ensure the `/var/tmp` directory contains enough free space to extract the appliance files. If it does not, you can specify a different directory or mount alternate storage that does have the required space. The VDSM user and KVM group must have read, write, and execute permissions on the directory.

The upgrade procedure creates a backup disk on the self-hosted engine storage domain. You therefore need additional free space on the storage domain for the new appliance being deployed (50 GB by default). To increase the storage on iSCSI or Fibre Channel storage, you need to manually extend the LUN size on the storage and then extend the storage domain using the Manager. Refer to [Increasing iSCSI or FCP Storage](https://access.redhat.com/documentation/en/red-hat-virtualization/4.0/paged/administration-guide/85-preparing-and-adding-block-storage#Increasing_iSCSI_or_FCP_Storage) in the *Administration Guide for more information about resizing a LUN.

The backup created during the upgrade procedure is not automatically deleted. You need to manually delete it after confirming the upgrade has been successful. The backup disks are labeled with `hosted-engine-backup-*.

**Important:** During the upgrade procedure you will be asked to create a backup of the Manager and copy it to the host machine where the upgrade is being performed.

**Upgrading the Self-Hosted Engine**

1. Disable the high-availability agents on all the self-hosted engine hosts. To do this run the following command on any host in the cluster.

        # hosted-engine --set-maintenance --mode=global

    **Note:** Run `hosted-engine --vm-status` to confirm that the environment is in maintenance mode.

2. On the host that is currently set as SPM and contains the Manager virtual machine, enable the required repository.

        # subscription-manager repos --enable=rhel-7-server-rhv-4-mgmt-agent-rpms

3. Migrate all virtual machines except the Manager virtual machine to alternate hosts.

4. On the host, update the Manager virtual machine packages.

        # yum update ovirt-hosted-engine-setup rhevm-appliance

5. Run the upgrade utility to upgrade the Manager virtual machine. If not already installed, install the `screen` package, which is available in the standard Red Hat Enterprise Linux repository. 

        # yum install screen
        # screen
        # hosted-engine --upgrade-appliance

    **Note:** You will be prompted to select the appliance if more than one is detected, and to create a backup of the Manager database and provide its full location.

6. After the upgrade is complete, disable global maintenance:

        # hosted-engine --set-maintenance --mode=none

If anything went wrong during the upgrade, power off the Manager by using the `hosted-engine  --vm-poweroff` command, then rollback the upgrade by running `hosted-engine --rollback-upgrade`.

Before updating the Red Hat Enterprise Linux hosts in the environment, disable the version 3.6 repository and enable the required 4.0 repository by running the following commands on the host you wish to update.

        # subscription-manager repos --disable=rhel-7-server-rhev-mgmt-agent-rpms
        # subscription-manager repos --enable=rhel-7-server-rhv-4-mgmt-agent-rpms

RHEV-H hosts must be reinstalled with RHVH 4.0. See [Red Hat Virtualization Hosts](https://access.redhat.com/documentation/en/red-hat-virtualization/4.0/single/installation-guide/#Red_Hat_Virtualization_Hosts) in the *Installation Guide.

You may now update the hosts in the environment, then update the data center and cluster compatibility level to 4.0. See the [*Upgrade Guide*](https://access.redhat.com/documentation/en/red-hat-virtualization/4.0/paged/upgrade-guide/) for more information.
