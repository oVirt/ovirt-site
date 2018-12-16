---
title: Updating an Offline oVirt Engine
---

# Appendix B: Upgrading to oVirt Engine 4.2 with ovirt-fast-forward-upgrade

If you have oVirt 4.0 or later installed, you can upgrade the Engine to the latest version with the `ovirt-fast-forward-upgrade` tool. `ovirt-fast-forward-upgrade` detects the current version of the Engine and checks for available upgrades. If an upgrade is available, the tool upgrades the Manager to the next major version, and continues to upgrade the Manager until the latest version is installed.

    **Note:** ovirt-fast-forward-upgrade upgrades the Manager. See [Appendix C: Manually Updating Hosts](appe-Manually_Updating_Hosts) to upgrade the hosts.

**Upgrading with `ovirt-fast-forward-upgrade`**

1. Install the `ovirt-fast-forward-upgrade` tool:

        # yum install ovirt-fast-forward-upgrade

2. Run the following command to upgrade the Engine, while creating a backup of the current version:

        # ovirt-fast-forward-upgrade --backup --backup-dir=/backup

    **Note:** The oVirt Project recommends using the `--backup` and `--backup-dir` options to create a backup of the current Manager. If a backup directory is not specified, the backup is saved in `/tmp`.

    The `--backup` option is a wrapper for the `engine-backup` tool and is equivalent to running the following command:

        # engine-backup --scope=all --mode=backup --file=file_name --log=log_file_name

    To restore your backup, run `engine-backup` in restore mode:

        # engine-backup --mode=restore

  Alternatively, to upgrade without creating a backup, run the following command:

        # ovirt-fast-forward-upgrade

3. If there are errors, check the log: `/var/log/ovirt-engine/ovirt-fast-forward-upgrade.log`.

**Prev:** [Appendix B: Upgrading to oVirt Engine 4.2 with ovirt-fast-forward-upgrade](appe-Upgrading_to_oVirt_Engine_4.2_with_ovirt-fast-forward-upgrade.html.md)<br>
**Next:** [Appendix C: Manually Updating Hosts](appe-Manually_Updating_Hosts)

[Adapted from RHV 4.2 documentation - CC-BY-SA](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.2/html/upgrade_guide/upgrading_with_ovirt-fast-forward-upgrade)
