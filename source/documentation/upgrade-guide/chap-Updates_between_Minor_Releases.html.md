---
title: Updates Between Minor Releases
---

# Chapter 2: Updates Between Minor Releases

## Updating the oVirt Engine

Updates to the oVirt Engine are released via the oVirt Project.


**Updating oVirt Engine**

Note: If you are using a [Self-Hosted Engine](/self-hosted/Self-Hosted_Engine_Guide/) this does not apply.

1. On the oVirt Engine machine, check if updated packages are available:

        # engine-upgrade-check

2. * If there are no updates are available, the command will output the text `No upgrade`:

            # engine-upgrade-check
            VERB: queue package ovirt-engine-setup for update
            VERB: package ovirt-engine-setup queued
            VERB: Building transaction
            VERB: Empty transaction
            VERB: Transaction Summary:
            No upgrade

        **Note:** If updates are expected, but not available, ensure that the required repositories are enabled.

    * If updates are available, the command will list the packages to be updated:

            # engine-upgrade-check
            VERB: queue package ovirt-engine-setup for update
            VERB: package ovirt-engine-setup queued
            VERB: Building transaction
            VERB: Transaction built
            VERB: Transaction Summary:
            VERB:     updated    - ovirt-engine-lib-3.3.2-0.50.el6ev.noarch
            VERB:     update     - ovirt-engine-lib-3.4.0-0.13.el6ev.noarch
            VERB:     updated    - ovirt-engine-setup-3.3.2-0.50.el6ev.noarch
            VERB:     update     - ovirt-engine-setup-3.4.0-0.13.el6ev.noarch
            VERB:     install    - ovirt-engine-setup-base-3.4.0-0.13.el6ev.noarch
            VERB:     install    - ovirt-engine-setup-plugin-ovirt-engine-3.4.0-0.13.el6ev.noarch
            VERB:     updated    - ovirt-engine-setup-plugins-3.3.1-1.el6ev.noarch
            VERB:     update     - ovirt-engine-setup-plugins-3.4.0-0.5.el6ev.noarch
            Upgrade available

            Upgrade available

3. Update the `ovirt-engine-setup` package:

        # yum update ovirt\*setup\*

4. Update the oVirt Engine. By running `engine-setup`, the script will prompt you with some configuration questions like updating the firewall rules, updating PKI certificates, and backing up the Data Warehouse database. The script will then go through the process of stopping the `ovirt-engine` service, downloading and installing the updated packages, backing up and updating the database, performing post-installation configuration, and starting the `ovirt-engine` service.

    **Note:** The `engine-setup` script is also used during the oVirt Engine installation process, and it stores the configuration values that were supplied. During an update, the stored values are displayed when previewing the configuration, and may not be up to date if `engine-config` was used to update configuration after installation. For example, if `engine-config` was used to update `SANWipeAfterDelete` to `true` after installation, `engine-setup` will output "Default SAN wipe after delete: False" in the configuration preview. However, the updated values will not be overwritten by `engine-setup`.

        # engine-setup

**Important:** The update process may take some time; allow time for the update process to complete and do not stop the process once initiated.

## Updating the oVirt Self-Hosted Engine and Underlying Virtualization Host(s)

The process for upgrading a [Self-Hosted Engine](/self-hosted/Self-Hosted_Engine_Guide/) is slightly different as the engine is running as a VM.

The following assumes that you have already deployed the Hosted Engine on your hosts and the Hosted Engine VM is running the same oVirt version as the host(s).

1.  Virtualization Host: Update packages (you may need to changes repository to latest version or install the latest versions metapackage e.g. ovirt-release42-4.2.1 after ensuring the the host is in maintenance mode.)

    **Note:** If you are updating packages on a host, it's important to ensure the host is in maintenance mode first, which can be done from the command line or from the web UI.

```
host ~ # yum update
```

2.  Virtualization Host: Restart vdsmd
```
host ~ # systemctl restart vdsmd
```

3.  Virtualization Host: Restart ha-agent and broker services
```
host ~ # systemctl restart ovirt-ha-broker && systemctl restart ovirt-ha-agent
```

4.  Hosted-Engine-VM: Update packages
```
hosted-engine ~ # yum update ovirt\*setup\*
```

5.  Hosted-Engine-VM: Run engine-setup and follow the prompts
```
hosted-engine ~ # engine-setup
```

6.  Host: Exit the global maintenance mode, after a few minutes the engine VM should migrate to the fresh upgraded host cause it will get an higher score.
```
host ~ #  hosted-engine --set-maintenance --mode=none
```

7. Host: When the engine VM migration has been completed re-enter global maintenance mode
8. Repeat step 3-6 for all the other hosted-engine hosts
9. Via the web UI update the cluster compatibility version to current version (for example from 4.1 to 4.2) and activate your hosts
10. Exit global maintenance mode

Note: You can enter and exit maintenance mode it via the web UI (right click on engine vm, and 'Enable/Disable Global HA Maintenance Mode')

## Updating Virtualization Hosts

Use the host upgrade manager to update individual hosts directly from the oVirt Engine. The upgrade manager checks for and notifies you of available host updates, and reduces the time required by automating the process of putting the host into maintenance mode, updating packages, and bringing the host back up. On large deployments with many hosts, this automated process can save a significant amount of time.

On Enterprise Linux hosts, the upgrade manager checks for updates to oVirt packages by default. You can specify additional packages for the upgrade manager to monitor for updates using the system configuration value `UserPackageNamesForCheckUpdate`. This value accepts wildcards. Run the `engine-config` command on the Engine machine. For example:

    # engine-config -m UserPackageNamesForCheckUpdate=vdsm-hook-ethtool-options

**Warning:** For other updates, such as security fixes for the operating system, you must manually update Enterprise Linux hosts with `yum update` as shown in the Manually Updating Virtualization Hosts section below.

On oVirt Node, the upgrade manager checks for updates to the oVirt Node image. Because the oVirt Node image as a whole is updated, rather than individual packages, manually running `yum update` for other packages is not necessary. Modified content in only the `/etc` and `/var` directories is preserved during an update. Modified data in other paths is completely replaced during an update.

The upgrade manager checks for updates every 24 hours by default. You can change this setting using the `HostPackagesUpdateTimeInHours` configuration value. Run the `engine-config` command on the Engine machine. For example:

    # engine-config -s HostPackagesUpdateTimeInHours=48

If migration is enabled at cluster level, virtual machines are automatically migrated to another host in the cluster; as a result, it is recommended that host updates are performed at a time when the host's usage is relatively low.

Ensure that the cluster to which the host belongs has sufficient memory reserve in order for its hosts to perform maintenance. If a cluster lacks sufficient memory, the virtual machine migration operation will hang and then fail. You can reduce the memory usage of this operation by shutting down some or all virtual machines before updating the host.

**Important:** Ensure that the cluster contains more than one host before performing an update. Do not attempt to update all the hosts at the same time, as one host must remain available to perform Storage Pool Engine (SPM) tasks.

**Updating Enterprise Linux hosts and oVirt Node**

1. Click the **Hosts** tab and select the host to be updated.

    * If the host requires updating, an alert message under **Action Items** and an icon next to the host's name indicate that a new version is available.

    * If the host does not require updating, no alert message or icon is displayed and no further action is required.

2. Click **Upgrade** to open the **Upgrade Host** confirmation window.

3. Click **OK** to update the host. The details of the host are updated in the **Hosts** tab, and the status will transition through these stages:

    * **Maintenance**

    * **Installing**

    *  **Up**

Once successfully updated, the host displays a status of **Up**. Any virtual machines that were migrated off the host are, at this point, able to be migrated back to it. Repeat the update procedure for each host in the oVirt environment.

**Note:** If the update fails, the host's status changes to **Install Failed**. From **Install Failed** you can click **Upgrade** again.

## Manually Updating Hosts

Enterprise Linux hosts use the `yum` command in the same way as regular Enterprise Linux systems. oVirt Node can use the `yum` command for updates; however, installing additional packages is not currently supported. It is highly recommended that you use `yum` to update your systems regularly, to ensure timely application of security and bug fixes. Updating a host includes stopping and restarting the host. If migration is enabled at cluster level, virtual machines are automatically migrated to another host in the cluster; as a result, it is recommended that host updates are performed at a time when the host's usage is relatively low.

The cluster to which the host belongs must have sufficient memory reserve in order for its hosts to perform maintenance. Moving a host with live virtual machines to maintenance in a cluster that lacks sufficient memory causes any virtual machine migration operations to hang and then fail. You can reduce the memory usage of this operation by shutting down some or all virtual machines before moving the host to maintenance.

**Important:** Ensure that the cluster contains more than one host before performing an update. Do not attempt to update all the hosts at the same time, as one host must remain available to perform Storage Pool Manager (SPM) tasks.

**Manually Updating Hosts**

1. From the Administration Portal, click the **Hosts** tab and select the host to be updated.

2. Click **Maintenance** to place the host into maintenance mode.

    * On an Enterprise Linux host, log in to the host machine and run the following command:

            # yum update

    * On an oVirt Node, log in to the Cockpit user interface, click **Tools** &gt; **Terminal**, and run the following command:

            # yum update

3. Restart the host to ensure all updates are correctly applied.

Repeat this process for each host in the oVirt environment.

**Prev:** [Chapter 1: Updating the oVirt Environment](../chap-Updating_the_oVirt_Environment) <br>
**Next:** [Chapter 3: Upgrading to oVirt 4.0](../chap-Upgrading_to_oVirt_4.0)
