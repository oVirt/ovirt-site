---
title: oVirt Hosted Engine Backup and Restore
authors: doron, sandrobonazzola
wiki_title: OVirt Hosted Engine Backup and Restore
wiki_revision_count: 9
wiki_last_updated: 2015-06-22
---

# oVirt Hosted Engine Backup and Restore

### Test environment

*   2 hosts with EL 6.6 and HE from 3.5.3 GA
*   1 VM with EL 6.6 and engine from 3.5.3 GA
*   NFSv3 storage on a different server

      # hosted-engine --vm-status
      --== Host 1 status ==--
      Status up-to-date                  : True
      Hostname                           : mididell.home
      Host ID                            : 1
      Engine status                      : {"health": "good", "vm": "up", "detail": "up"}
      Score                              : 2400
      Local maintenance                  : False
      Host timestamp                     : 17106
      Extra metadata (valid at timestamp):
          metadata_parse_version=1
          metadata_feature_version=1
          timestamp=17106 (Thu Jun 18 14:09:00 2015)
          host-id=1
          score=2400
          maintenance=False
          state=EngineUp
      --== Host 2 status ==--
      Status up-to-date                  : True
      Hostname                           : minidell.home
      Host ID                            : 2
      Engine status                      : {"reason": "vm not running on this host", "health": "bad", "vm": "down", "detail": "unknown"}
      Score                              : 2400
      Local maintenance                  : False
      Host timestamp                     : 15235
      Extra metadata (valid at timestamp):
          metadata_parse_version=1
          metadata_feature_version=1
          timestamp=15235 (Thu Jun 18 14:09:00 2015)
          host-id=2
          score=2400
          maintenance=False
          state=EngineDown

### Application backup / restore

#### Backup

*   1.  hosted-engine --set-maintenance --mode=global
*   within the HE vm:
    -   1.  service ovirt-engine stop
    -   1.  engine-backup --mode=backup --file=backup1 --log=backup1.log
    -   1.  service ovirt-engine start

*   1.  hosted-engine --set-maintenance --mode=none

#### Restore

##### Preconditions

*   the vm is not available anymore due to storage corruption
*   an empty shared storage is available
*   engine backup exists

##### Restore procedure

*   on all the hosts (if they are still available):
    -   1.  service ovirt-ha-broker stop
    -   1.  service ovirt-ha-agent stop
    -   1.  chkconfig --del ovirt-ha-broker
    -   1.  chkconfig --del ovirt-ha-agent

<!-- -->

*   on first host:
    -   if the original host is not available anymore, provision a new host from scratch and proceed on this new host
    -   1.  hosted-engine --deploy

        -   use same fqdn you had previously in the HE VM.
        -   point to the new shared storage
        -   provide the same admin password you used in previous setup
        -   install the OS on the vm
        -   confirm it has been installed
        -   install the ovirt-engine rpms on the vm but don't run engine-setup
        -   follow <http://www.ovirt.org/Ovirt-engine-backup> . Basic steps:
            -   Open the backup in some temporary directory (it's a tar file)
            -   look at the file "files/etc/ovirt-engine/engine.conf.d/10-setup-database.conf" and find the password used when doing backup
            -   1.  service postgresql initdb
            -   1.  service postgresql start
            -   1.  su - postgres -c "psql -d template1"
            -   create role engine ENCRYPTED PASSWORD 'MYPASSWORD';
            -   create database engine owner engine template template0 encoding 'UTF8' lc_collate 'en_US.UTF-8' lc_ctype 'en_US.UTF-8';
            -   note: replace MYPASSWORD with the password you found inside the backup file.
            -   edit /var/lib/pgsql/data/pg_hba.conf for allowing connections using password
            -   1.  service postgresql restart
            -   restore the backup
            -   1.  engine-backup --mode=restore --file=backup1 --log=backup1-restore.log --change-db-credentials --db-host=localhost --db-user=engine --db-password --db-name=engine
            -   1.  engine-setup

        -   remove the hosts used for Hosted Engine from the engine
        -   confirm that the engine has been installed
        -   first host should be a added cleanly to the engine
        -   finish the deploy
        -   wait for the engine to be started by the HA daemons

<!-- -->

*   on additional hosts run:
    -   1.  hosted-engine --deploy as if the host was clean.

### Full storage domain backup

<big>**DRAFT - This procedure is still under testing**</big>

#### Backup

*   1.  hosted-engine --set-maintenance --mode=global
*   1.  hosted-engine --vm-shutdown
*   backup the data domain. hints:
    -   block: dd if=<iscsi lun containing the he domain> |xz >he_domain.xz
    -   nfs: tar cJf he_domain.tar.xz . -C <path to sd directory>
*   1.  hosted-engine --set-maintenance --mode=none

In order to simulate storage corruption you can destroy the content of the sd

#### Restore

##### Preconditions

*   hosts are still working
*   the vm is not available anymore due to storage corruption
*   an empty shared storage is available
*   storage domain backup exists

##### Restore procedure

*   1.  service ovirt-ha-broker stop
*   1.  service ovirt-ha-agent stop
*   restore the data domain. hints:
    -   block: xz -d -c he_domain.xz dd of=<iscsi lun containing the he domain> |xz >he_domain.xz
    -   nfs: tar xJf he_domain.tar.xz -C <path to sd directory>
*   1.  service ovirt-ha-broker start
*   1.  service ovirt-ha-agent start
*   1.  hosted-engine --set-maintenance --mode=none
