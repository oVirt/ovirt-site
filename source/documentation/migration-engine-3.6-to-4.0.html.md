---
title: ovirt-engine migration from 3.6 to 4.0
authors: rafaelmartins
---

# ovirt-engine migration from 3.6 to 4.0

ovirt-engine 4.0 removed support for Fedora 22 and Centos/RHEL 6, then some migration work is required for people running these versions, as the operating system will also need to be upgraded.

## Backing up ovirt-engine 3.6

First thing to do is create a backup of the 3.6 setup, using `engine-backup`. This script is provided by the `ovirt-engine-tools-backup` package, and installed by default with `ovirt-engine`.

    # engine-backup --mode=backup --file=engine-backup.tar.gz --log=engine-backup.log

This command will generate your backup as GZIP-compressed tarball `engine-backup.tar.gz`.

With backup done, the operating system must be upgraded, and a clean installation of ovirt-engine 4.0 must be done.


## Migrating to ovirt-engine 4.0

After a fresh instalation of Fedora 23 or Centos/RHEL 7, ovirt-engine 4.0 can be installed and the 3.6 backup can be restored.

To make things easier to handle, the new operating system setup should use the same IP address that was used by the old system. This will allow the new ovirt-engine instance to work without configuration changes.

With the new operating system running, install 4.0 RPM repositories:

    # yum install http://resources.ovirt.org/pub/yum-repo/ovirt-release-master.rpm  # FIXME: this should point to ovirt-release40.rpm after release!

Install `ovirt-engine` package and dependencies:

    # yum install ovirt-engine

Copy your backup to the new system, and restore it with following command:

    # engine-backup --mode=restore --no-restore-permissions --provision-db --file=engine-backup.tar.gz --log=engine-backup-restore.log

or with the following command if dwh was set up in the 3.6 machine

    # engine-backup --mode=restore --no-restore-permissions --provision-db --provision-dwh-db --file=engine-backup.tar.gz --log=engine-backup-restore.log

Run engine-setup:

    # engine-setup

After that, ovirt-engine 4.0 should be up and running.
