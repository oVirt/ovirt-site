---
title: ovirt-engine migration from 3.6 to 4.0
authors: rafaelmartins
---

# ovirt-engine migration from 3.6 to 4.0

ovirt-engine 4.0 removed support for Fedora 22 and Centos/RHEL 6, then some migration work is required for people running these versions, as the operating system will also need to be upgraded.
**NOTE: This is procedure is needed only if you are serving ovirt engine from an f22 or el6 server. If you are already on el7 or Fedora 23 you can simply run:**

      # yum install http://resources.ovirt.org/pub/yum-repo/ovirt-release40.rpm
      # yum update "ovirt-engine-setup*"
      # engine-setup


## Backing up ovirt-engine 3.6

First thing to do is create a backup of the 3.6 setup, using `engine-backup`. This script is provided by the `ovirt-engine-tools-backup` package, and installed by default with `ovirt-engine`.

    # engine-backup --mode=backup --file=engine-backup.tar.gz --log=engine-backup.log

This command will generate your backup as GZIP-compressed tarball `engine-backup.tar.gz`.

With backup done, the operating system must be upgraded, and a clean installation of ovirt-engine 4.0 must be done.


## Migrating to ovirt-engine 4.0

After a fresh instalation of Fedora 23 or Centos/RHEL 7, ovirt-engine 4.0 can be installed and the 3.6 backup can be restored.

To make things easier to handle, the new operating system setup should use the same IP address that was used by the old system. This will allow the new ovirt-engine instance to work without configuration changes.

With the new operating system running, install 4.0 RPM repositories:

    # yum install http://resources.ovirt.org/pub/yum-repo/ovirt-release40.rpm

Install `ovirt-engine` package and dependencies:

    # yum install ovirt-engine

Copy your backup to the new system, and restore it with following command:

    # engine-backup --mode=restore --no-restore-permissions --provision-db --file=engine-backup.tar.gz --log=engine-backup-restore.log

Run engine-setup:

    # engine-setup

After that, ovirt-engine 4.0 should be up and running.
