# Updating the Red Hat Virtualization Manager

Updates to the Red Hat Virtualization Manager are released via the Content Delivery Network. Before installing an update from the Content Delivery Network, ensure you read the advisory text associated with it and the latest version of the *Red Hat Virtualization Manager Release Notes* and *Red Hat Virtualization Technical Notes* on the [Customer Portal](https://access.redhat.com/documentation/en/red-hat-virtualization/). 

**Updating Red Hat Virtualization Manager**


1. On the Red Hat Virtualization Manager machine, check if updated packages are available:

        # engine-upgrade-check

2. * If there are no updates are available, the command will output the text `No upgrade`:

            # engine-upgrade-check
            VERB: queue package ovirt-engine-setup for update
            VERB: package ovirt-engine-setup queued
            VERB: Building transaction
            VERB: Empty transaction
            VERB: Transaction Summary:
            No upgrade

        **Note:** If updates are expected, but not available, ensure that the required repositories are enabled. See [Subscribing to the Required Entitlements](https://access.redhat.com/documentation/en/red-hat-virtualization/4.0/single/installation-guide/#Subscribing_to_the_Red_Hat_Enterprise_Virtualization_Manager_Channels_using_Subscription_Manager) in the *Installation Guide*.

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

        # yum update ovirt-engine-setup

4. Update the Red Hat Virtualization Manager. By running `engine-setup`, the script will prompt you with some configuration questions like updating the firewall rules, updating PKI certificates, and backing up the Data Warehouse database. The script will then go through the process of stopping the `ovirt-engine` service, downloading and installing the updated packages, backing up and updating the database, performing post-installation configuration, and starting the `ovirt-engine` service.

    **Note:** The `engine-setup` script is also used during the Red Hat Virtualization Manager installation process, and it stores the configuration values that were supplied. During an update, the stored values are displayed when previewing the configuration, and may not be up to date if `engine-config` was used to update configuration after installation. For example, if `engine-config` was used to update `SANWipeAfterDelete` to `true` after installation, `engine-setup` will output "Default SAN wipe after delete: False" in the configuration preview. However, the updated values will not be overwritten by `engine-setup`.

        # engine-setup

**Important:** The update process may take some time; allow time for the update process to complete and do not stop the process once initiated.

