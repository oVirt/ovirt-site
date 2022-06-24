---
title: oVirt 3.1 to 3.2 upgrade
authors: alourie
---

# oVirt 3.1 to 3.2 upgrade

## General Information

oVirt 3.1 was released as Fedora 17 package while 3.2 is targeted Fedora 18. Due to the nature of this upgrade, we DO NOT recommend it, users are advised to do a 3.2 clean installation, and to import all VM's and template into the new installation.

## Upgrade Instructions

*   Make sure to backup the DB and the /etc/pki/ovirt-engine folders before the upgrade.

<!-- -->

*   Upgrade the system the oVirt Engine was installed on to Fedora 18:
    -   <http://fedoraproject.org/wiki/PreUpgrade>
    -   Or set

      exclude=ovirt* in /etc/yum.conf

and then:

      yum distro-sync
      fedup --disablerepo=ovirt* --network 18

Once you have a running Fedora 18:

*   Upgrade postgres server package:

      systemctl stop postgresql.service
      tar cJvf pgsql-backup.tar.xz /var/lib/pgsql/data/
      yum install postgresql-upgrade

*   Backup postgres configuration:

      cp /var/lib/pgsql/data/pg_hba.conf /root/pg_hba.conf.ovirt

*   Edit the configuration /var/lib/pgsql/data/pg_hba.conf changing md5 to trust on the local line:

      # diff -u pg_hba.conf.ovirt pg_hba.conf
      --- pg_hba.conf.ovirt  2013-01-30 20:58:49.404000000 +0100
      +++ pg_hba.conf    2013-01-30 20:59:06.709000000 +0100
      @@ -77,7 +77,7 @@
      # TYPE  DATABASE        USER            ADDRESS                 METHOD
      # "local" is for Unix domain socket connections only
      -local   all             all                                     md5
      +local   all             all                                     trust
      # IPv4 local connections:
      host    all             all             127.0.0.1/32            md5
      # IPv6 local connections:
      ...

*   Upgrade existing DB:

      postgresql-setup upgrade
      Redirecting to /bin/systemctl stop  postgresql.service
      Upgrading database: OK

      cp /root/pg_hba.conf.ovirt /var/lib/pgsql/data/pg_hba.conf
      systemctl postgrsql.service restart

      See /var/lib/pgsql/pgupgrade.log for details.

*   Update /root/.pgpass file - to include \* as the DB name instead of 'engine':

      localhost:5432:*:engine:dbpass                                                                                                          

*   Update SSL configuration of the apache; edit /etc/httpd/conf.d/ssl.conf:

      # diff -u ssl.conf.ovirt ssl.conf
      --- ssl.conf.ovirt 2013-01-30 21:21:06.906000000 +0100
      +++ ssl.conf   2013-01-30 21:22:02.757000000 +0100
      @@ -9,7 +9,7 @@
      # consult the online docs. You have been warned.  
      #
      -LoadModule ssl_module modules/mod_ssl.so
      +#LoadModule ssl_module modules/mod_ssl.so
      #
      # When we also provide SSL we have to listen to the 
      @@ -40,7 +40,7 @@
      #   Semaphore:
      #   Configure the path to the mutual exclusion semaphore the
      #   SSL engine uses internally for inter-process synchronization. 
      -SSLMutex default
      +#SSLMutex default
      #   Pseudo Random Number Generator (PRNG):
      #   Configure one or more sources to seed the PRNG of the

      /bin/systemctl restart  httpd.service

*   Upgrade engine:

      Remove the line exclude=ovirt* from /etc/yum.conf

      yum update ovirt-engine-setup
      engine-upgrade

## Updating oVirt Node

*   Download the latest stable [oVirt Node release](http://resources.ovirt.org/releases/3.2/iso/)
*   Use one of the supported (PXE, USB, ...) medias to boot the to be updated machine running Node
*   The update is non destructive, that means all your configurations will be kept

<!-- -->

*   Select "Start Ovirt Node" in the boot menu
*   In the TUI you should be prompted to "`Upgrade <current version> to <new version>`"
    -   Press ENTER to continue
*   Select the keyboard layout
*   Enter - at least - the current admin password. This is a security check to ensure that not someone else overrides your installation.
    -   You can also enter a new admin password in the additional fields
*   (oVirt Node is beeing updated)
*   Press ENTER to reboot
*   The updated oVirt Node is started by default
    -   A backup entry was added to the bootmenu, select this backup if the new version can not be booted or leads to problems
