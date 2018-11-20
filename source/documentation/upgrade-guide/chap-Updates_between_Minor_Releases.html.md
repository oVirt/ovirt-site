---
title: Updates Between Minor Releases
---

# Chapter 9: Updates Between Minor Releases

To upgrade from your current version of 4.2 to the latest version, for example, from 4.2.3 to 4.2.4, update the Engine and then update the hosts.

## Analyzing the Environment

The oVirt Project recommends running the Log Collection Analysis tool prior to performing updates and for troubleshooting. The tool analyses your environment and displays any known issues that may prevent you from performing an update and suggests how to resolve the issue.

The tool gathers detailed information about your system and presents it as an HTML file.

    **Note:** The Log Collection Analysis tool is available from oVirt 4.2.5.

**Procedure**

1. Install the Log Collection Analysis tool on the Engine:

        # yum install rhv-log-collector-analyzer

2. Run the tool:

        # rhv-log-collector-analyzer --live

   A detailed report is displayed.

   By default, the report is saved to a file called **analyzer_report.html**.

   To save the file to a specific location, use the -`-html` flag and specify the location:

        # rhv-log-collector-analyzer --live --html=/directory/filename.html

## Update the oVirt Engine

Updates to the oVirt Engine are released through the oVirt repositories.

**Procedure**

1. On the oVirt Engine machine, check if updated packages are available:

        # engine-upgrade-check

    **Note:** If updates are expected, but not available, enable the required repositories. See Enabling the oVirt Engine Repositories in the Installation Guide.

2. Update the setup packages:

    # yum update ovirt\*setup\*

    # yum update rhevm-setup

3. Update the oVirt Engine. The `engine-setup` script prompts you with some configuration questions, then stops the **ovirt-engine** service, downloads and installs the updated packages, backs up and updates the database, performs post-installation configuration, and starts the **ovirt-engine** service.

        # engine-setup

    **Note:** The `engine-setup` script is also used during the oVirt Engine installation process, and it stores the configuration values supplied. During an update, the stored values are displayed when previewing the configuration, and may not be up to date if `engine-config` was used to update configuration after installation. For example, if `engine-config` was used to update `SANWipeAfterDelete` to `true` after installation, `engine-setup` will output "Default SAN wipe after delete: False" in the configuration preview. However, the updated values will not be overwritten by `engine-setup`.

    **Important:** The update process may take some time; allow time for the update process to complete and do not stop the process once initiated.

4. Update the base operating system and any optional packages installed on the Engine:

        # yum update

    **Important:** If the update upgraded any kernel packages, reboot the system to complete the changes.

## Update the Hosts

Use the host upgrade manager to update individual hosts directly from the oVirt Engine.

oVirt 3.6 supported three types of host. If you are using Enterprise Linux hosts or oVirt Nodes 3.6, use this procedure to update them. However, if you are using oVirt Node 4.0+, you must reinstall them with oVirt Node 4.2.

If you are not sure if you are using oVirt Node 3.6 or oVirt Node 4.0+, run:

    # imgbase check

If the command fails, the host is oVirt Node 3.6. If the command succeeds, the host is oVirt Node.

    **Note:** The upgrade manager only checks host with a status of `Up` or `Non-operational`, but not `Maintenance`.

    **Important:** On oVirt Node 4.0+, the update only preserves modified content in the /etc and /var directories. Modified data in other paths is overwritten during an update.

**Prerequisites**

* If migration is enabled at cluster level, virtual machines are automatically migrated to another host in the cluster; as a result, it is recommended that host updates are performed at a time when the host’s usage is relatively low.

* Ensure that the cluster contains more than one host before performing an update. Do not attempt to update all the hosts at the same time, as one host must remain available to perform Storage Pool Manager (SPM) tasks.

* Ensure that the cluster to which the host belongs has sufficient memory reserve in order for its hosts to perform maintenance. If a cluster lacks sufficient memory, the virtual machine migration operation will hang and then fail. You can reduce the memory usage of this operation by shutting down some or all virtual machines before updating the host.
* You cannot migrate a virtual machine using a vGPU to a different host. Virtual machines with vGPUs installed must be shut down before updating the host.

**Procedure**

1. Ensure the correct repositories are enabled. You can check which repositories are currently enabled by running yum repolist.

  * For oVirt Nodes:

        # subscription-manager repos --enable=rhel-7-server-oVirt Node-4-rpms

  * For Enterprise Linux hosts:

        # subscription-manager repos --enable=rhel-7-server-rpms
        # subscription-manager repos --enable=rhel-7-server-rhv-4-mgmt-agent-rpms
        # subscription-manager repos --enable=rhel-7-server-ansible-2-rpms

2. Click **Compute** &rarr; **Hosts** and select the host to be updated.

3. Click **Installation** &rarr; **Check** for Upgrade.

4. Click **OK** to begin the upgrade check.

5. Click **Installation** &rarr; **Upgrade**.

6. Click **OK** to update the host. The details of the host are updated in Compute → Hosts and the status will transition through these stages:

  * **Maintenance**

  * **Installing**

  * **Up**

   After the update, the host is rebooted. Once successfully updated, the host displays a status of `Up`. If any virtual machines were migrated off the host, they are now migrated back.

    **Note:** If the update fails, the host’s status changes to Install Failed. From Install Failed you can click **Installation** &rarr; **Upgrade** again.

Repeat this procedure for each host in the oVirt environment.

The oVirt Project recommends updating the hosts from the Engine; however, you can also update the hosts using `yum update`. See [Appendix C: Manually Updating Hosts](../appe-Manually_Updating_Hosts) for more information.

**Prev:** [Chapter 8: Post-Upgrade Tasks](../chap-Post-Upgrade_Tasks/)<br>
**Next:** [Appendix A: Updating an Offline oVirt Engine](../appe-Updating_an_Offline_oVirt_Engine/)

[Adapted from RHV 4.2 documentation - CC-BY-SA](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.2/html/upgrade_guide/updates_between_minor_releases)
