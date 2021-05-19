---
title: Hosted-engine migration to 4.0
category: feature
authors: stirabos
---

Hosted-engine migration to 4.0

# Hosted-engine migration to 4.0

### Summary

In 3.6 the engine rpms were released also for el6 so user could deply the hosted-engine on el6.
In 4.0 we are releasing oVirt engine for el7 but not for el6 so we should provide an upgrade path for who deployed hosted-engine using an el6 based VM.

### Owner

*   Name: Simone Tiraboschi (stirabos)

<!-- -->

*   Email: <stirabos@redhat.com>

### Detailed Description
The upgrade procedure is long and pretty error prone so we are extending ovirt-hosted-engine-setup to support also this flow and not just only fresh deployments. 
The upgrade flow supports:
- el6 appliance based hosted-engine -> el7 appliance based hosted-engine
- custom el6 hosted-engine VM -> el7 appliance based hosted-engine
The upgrade flow will not support creating a custom el7 VM.

### Flow:
- check global maintenance mode and that VM is locally running
- enforce that we are running on the host where the engine VM is running
- enforce that we are running on the SPM host, if not exit and ask the user to run there
- ask the user to take a backup on the engine VM with engine-backup and copy it back to the host (we are just asking to the user since by default ssh was closed on our old appliances and the effort to open it is not that different than taking the backup).
- check the backup content
- ask all the missing information (the exact list depend on how 3.6 was deployed and so what is on the answer file on the shared storage)
- use the 3.6 engine to create a new floating disk for backup pourposes on the hosted-engine storage domain (the use has to resize the hosted-engine storage domain from the engien if we don't have enough free space for the additional disk)
- shutdown the engine VM
- backup the old engine VM disk to the new backup disk
- transfer the 4.0/el7 appliance over the engine VM disk (the procedure can also extend the volume if required)
- inject the engine backup to the engine VM disk with guestfish
- generate a new cloud-init image to configure the el7 appliance
- tweak vm.conf on the fly to attach the cloud-init image
- boot the engine VM, this will:
- - configure the appliance via cloud-init
- - not interactively (from cloud-init and checking the output over a virtio channel) run engine-backup to restore the 3.6 backup
- - not interactively  (from cloud-init and checking the output over a virtio channel) run engine-setup to configure the 4.0 engine
- check the engine status
- via REST api, scan external disks and add the floating backup disk to the engine since it was created after the backup was taken
 
### Rollback
At the end of the procedure, the backup disk will contain a copy of the engine VM disk before the upgrade.
The backup can be rolled back at any time with the --rollback-upgrade option.
Deleting backup images if not needed is up to the user.

### Benefit to oVirt

The user will be able to upgrade

### Testing

- Set the global maintenance mode
- Put the host where the engin VM is running into maintenance
- Add the 4.0 repo and upgrade the host

Run hosted-engine-setup --upgrade-appliance

    [root@foobar ~]# hosted-engine --upgrade-appliance
    [ INFO  ] Stage: Initializing
    [ INFO  ] Stage: Environment setup
              During customization use CTRL-D to abort.
              Continuing will upgrade the engine VM running on this hosts deploying and configuring a new appliance.
              If your engine VM is already based on el7 you can also simply upgrade the engine there.
              This procedure will create a new disk on the hosted-engine storage domain and it will backup there the content of your current engine VM disk.
              The new el7 based appliance will be deployed over the existing disk destroying its content; at any time you will be able to rollback using the content of the backup disk.
              You will be asked to take a backup of the running engine and copy it to this host.
              The engine backup will be automatically injected and recovered on the new appliance.
              Are you sure you want to continue? (Yes, No)[Yes]:
              Configuration files: []
              Log file: /var/log/ovirt-hosted-engine-setup/ovirt-hosted-engine-setup-20160805104533-m59a0l.log
              Version: otopi-1.5.1 (otopi-1.5.1-1.el7.centos)
    [ INFO  ] Bridge ovirtmgmt already created
    [ INFO  ] Stage: Environment packages setup
    [ INFO  ] Stage: Programs detection
    [ INFO  ] Stage: Environment setup
    [ INFO  ] Checking maintenance mode
    [ INFO  ] The engine VM is running on this host
    [ INFO  ] Stage: Environment customization
    [ INFO  ] Answer file successfully loaded

The script will enforce that the engine VM is running on this host and this host is the SPM one:

              Enter engine admin password:
              Confirm engine admin password:
    [ INFO  ] Acquiring internal CA cert from the engine
    [ INFO  ] The following CA certificate is going to be used, please immediately interrupt if not correct:
    [ INFO  ] Issuer: C=US, O=localdomain, CN=enginevm.localdomain.55389, Subject: C=US, O=localdomain, CN=enginevm.localdomain.55389, Fingerprint (SHA-1): AC9D50191E837B948AB5019CD87D9914B3274242
    [ INFO  ] Checking SPM status on this host
    [ INFO  ] Connecting to the Engine
    [ INFO  ] This upgrade tool is running on the SPM host
  
Add the missing information, it depends on how the 3.6 engine was deployed.
  
    [ INFO  ] Detecting available oVirt engine appliances
              The following appliance have been found on your system:
                    [1] - The oVirt Engine Appliance image (OVA) - 4.0-20160727.1.el7.centos
                    [2] - Directly select an OVA file
              Please select an appliance (1, 2) [1]:
  
Select the 4.0 appliance
  
    [ INFO  ] Verifying its sha1sum
    [ INFO  ] Checking OVF archive content (could take a few minutes depending on archive size)
    [ INFO  ] Checking OVF XML content (could take a few minutes depending on archive size)
    [WARNING] OVF does not contain a valid image description, using default.
    [ INFO  ] Connecting to the Engine
    [ INFO  ] The hosted-engine storage domain has enough free space to contain a new backup disk.
              Please take a backup of the current engine running this command on the engine VM:
               engine-backup --mode=backup --file=engine_backup.tar.gz --log=engine_backup.log
              Then copy the backup archive to this host and input here its path when ready.
              Please specify path to engine backup archive you would like to restore on the new appliance: /root/engine_backup.tar.gz
 
Connect to the host and run engine-backup, copy the archive to the host.

    [ INFO  ] Validating backup file '/root/engine_backup.tar.gz'
    [ INFO  ] The provided file contains also a DWH DB backup: it will be restored as well
    [ INFO  ] '/root/engine_backup.tar.gz' is a sane backup file
    [ INFO  ] Checking version requirements
    [ INFO  ] Connecting to the Engine
    
The script will do the preliminary checks.
    
    [ INFO  ] All the datacenters and clusters are at a compatible level
              Enter root password that will be used for the engine appliance (leave it empty to skip):
              Confirm appliance root password:
    [ INFO  ] The engine VM will be configured to use 192.168.1.222/24
    [WARNING] Please take care that this will simply add an entry for this host under /etc/hosts on the engine VM. If in the past you added other entries there, recovering them is up to you.
    [ INFO  ] Stage: Setup validation
    [ INFO  ] Stage: Transaction setup
    [ INFO  ] Stage: Misc configuration
    [ INFO  ] Stage: Package installation

and it will create the backup disk trough the engine

    [ INFO  ] Stage: Misc configuration
    [ INFO  ] Connecting to the Engine
    [ INFO  ] Waiting for the engine to complete disk creation. This may take several minutes...
    [ INFO  ] Still waiting for engine VM backup disk to be created. This may take several minutes...
    [ INFO  ] Still waiting for engine VM backup disk to be created. This may take several minutes...
    [ INFO  ] Still waiting for engine VM backup disk to be created. This may take several minutes...
    [ INFO  ] The engine VM backup disk is now ready
    
It will shutdown the engine VM and it will copy the VM over the backup disk

    [ INFO  ] Shutting down the current engine VM
    [ INFO  ] Creating a backup of the engine VM disk (could take a few minutes depending on archive size)
    [ INFO  ] Successfully created

The it will copy the el7 appliance over the engine VM disk

    [ INFO  ] Extracting disk image from OVF archive (could take a few minutes depending on archive size)
    [ INFO  ] Validating pre-allocated volume size
    [ INFO  ] Uploading volume to data domain (could take a few minutes depending on archive size)
    
It will inject there the engine backup
    
    [ INFO  ] Injecting engine backup
    [ INFO  ] Backup successfully injected
    [ INFO  ] Image successfully imported from OVF
    [ INFO  ] Stage: Transaction commit
    [ INFO  ] Stage: Closing up

It will run the VM and it will restore the engine-backup

    [ INFO  ] Trying to get a fresher copy of vm configuration from the OVF_STORE
    [ INFO  ] Found an OVF for HE VM, trying to convert
    [ INFO  ] Got vm.conf from OVF_STORE
    [ INFO  ] Running engine-setup on the appliance
              |- Preparing to restore:
              |- - Unpacking file '/root/engine_backup.tar.gz'
              |- Restoring:
              |- - Files
              |- Provisioning PostgreSQL users/databases:
              |- - user 'engine', database 'engine'
              |- - user 'ovirt_engine_history', database 'ovirt_engine_history'
              |- Restoring:
              |- - Engine database 'engine'
              |-   - Cleaning up temporary tables in engine database 'engine'
              |-   - Resetting DwhCurrentlyRunning in dwh_history_timekeeping in engine database
              |- ------------------------------------------------------------------------------
              |- Please note:
              |- The engine database was backed up at 2016-08-04 16:27:00.000000000 +0000 .
              |- Objects that were added, removed or changed after this date, such as virtual
              |- machines, disks, etc., are missing in the engine, and will probably require
              |- recovery or recreation.
              |- ------------------------------------------------------------------------------
              |- - DWH database 'ovirt_engine_history'
              |- You should now run engine-setup.
              |- Done.
              |- HE_APPLIANCE_ENGINE_RESTORE_SUCCESS
    [ INFO  ] Engine backup successfully restored

If everything went fine, it will autonomously execute engine-setup

              |- [ INFO  ] Stage: Initializing
              |- [ INFO  ] Stage: Environment setup
              |-           Configuration files: ['/etc/ovirt-engine-setup.conf.d/10-packaging-jboss.conf', '/etc/ovirt-engine-setup.conf.d/10-packaging.conf', '/etc/ovirt-engine-setup.conf.d/20-setup-ovirt-post.conf
    ', '/root/ovirt-engine-answers', '/root/heanswers.conf']
              |-           Log file: /var/log/ovirt-engine/setup/ovirt-engine-setup-20160805085557-bnxrgm.log
              |-           Version: otopi-1.5.1 (otopi-1.5.1-1.el7.centos)
              |- [ INFO  ] Stage: Environment packages setup
              |- [ INFO  ] Stage: Programs detection
              |- [ INFO  ] Stage: Environment setup
              |- [ INFO  ] Stage: Environment customization
              |-
              |-           --== PRODUCT OPTIONS ==--
              |-
              |-
              |-           --== PACKAGES ==--
              |-
              |-
              |-           --== NETWORK CONFIGURATION ==--
              |-
              |- [ INFO  ] firewalld will be configured as firewall manager.
              |-
              |-           --== DATABASE CONFIGURATION ==--
              |-
              |-           The detected DWH database size is 26 MB.
              |-           Setup can backup the existing database. The time and space required for the database backup depend on its size. This process takes time, and in some cases (for instance, when the size is f
    ew GBs) may take several hours to complete.
              |-           If you choose to not back up the database, and Setup later fails for some reason, it will not be able to restore the database and all DWH data will be lost.
              |-           Would you like to backup the existing database before upgrading it? (Yes, No) [Yes]:
              |-
              |-           --== OVIRT ENGINE CONFIGURATION ==--
              |-
              |-
              |-           --== STORAGE CONFIGURATION ==--
              |-
              |-
              |-           --== PKI CONFIGURATION ==--
              |-
              |-
              |-           --== APACHE CONFIGURATION ==--
              |-
              |-
              |-           --== SYSTEM CONFIGURATION ==--
              |-
              |-
              |-           --== MISC CONFIGURATION ==--
              |-
              |-
              |-           --== END OF CONFIGURATION ==--
              |-
              |- [ INFO  ] Stage: Setup validation
              |- [WARNING] Cannot validate host name settings, reason: cannot resolve own name 'enginevm'
              |- [ INFO  ] Hosted Engine HA is in Global Maintenance mode.
              |- [WARNING] Less than 16384MB of memory is available
              |- [ INFO  ] Cleaning stale zombie tasks and commands
              |-
              |-           --== CONFIGURATION PREVIEW ==--
              |-
              |-           Application mode                        : both
              |-           Default SAN wipe after delete           : False
              |-           Firewall manager                        : firewalld
              |-           Update Firewall                         : True
              |-           Host FQDN                               : enginevm.localdomain
              |-           Engine database secured connection      : False
              |-           Engine database host                    : localhost
              |-           Engine database user name               : engine
              |-           Engine database name                    : engine
              |-           Engine database port                    : 5432
              |-           Engine database host name validation    : False
              |-           DWH database secured connection         : False
              |-           DWH database host                       : localhost
              |-           DWH database user name                  : ovirt_engine_history
              |-           DWH database name                       : ovirt_engine_history
              |-           DWH database port                       : 5432
              |-           DWH database host name validation       : False
              |-           Engine installation                     : True
              |-           PKI organization                        : localdomain
              |-           Configure local Engine database         : True
              |-           Set application as default page         : True
              |-           Configure Apache SSL                    : True
              |-           DWH installation                        : True
              |-           Backup DWH database                     : True
              |-           Engine Host FQDN                        : enginevm.localdomain
              |-           Configure VMConsole Proxy               : True
              |-           Configure WebSocket Proxy               : True
              |- [ INFO  ] Cleaning async tasks and compensations
              |- [ INFO  ] Unlocking existing entities
              |- [ INFO  ] Checking the Engine database consistency
              |- [ INFO  ] Stage: Transaction setup
              |- [ INFO  ] Stopping engine service
              |- [ INFO  ] Stopping ovirt-fence-kdump-listener service
              |- [ INFO  ] Stopping dwh service
              |- [ INFO  ] Stopping websocket-proxy service
              |- [ INFO  ] Stage: Misc configuration
              |- [ INFO  ] Stage: Package installation
              |- [ INFO  ] Stage: Misc configuration
              |- [ INFO  ] Upgrading CA
              |- [ INFO  ] Backing up database localhost:engine to '/var/lib/ovirt-engine/backups/engine-20160805085559.QRxmdo.dump'.
              |- [ INFO  ] Creating/refreshing Engine database schema
              |- [ INFO  ] Backing up database localhost:ovirt_engine_history to '/var/lib/ovirt-engine-dwh/backups/dwh-20160805085610.oGIC77.dump'.
              |- [ INFO  ] Creating/refreshing DWH database schema
              |- [ INFO  ] Configuring WebSocket Proxy
              |- [ INFO  ] Creating/refreshing Engine 'internal' domain database schema
              |- [ INFO  ] Generating post install configuration file '/etc/ovirt-engine-setup.conf.d/20-setup-ovirt-post.conf'
              |- [ INFO  ] Stage: Transaction commit
              |- [ INFO  ] Stage: Closing up
              |- [ INFO  ] Starting engine service
              |- [ INFO  ] Starting dwh service
              |- [ INFO  ] Restarting ovirt-vmconsole proxy service
              |-
              |-           --== SUMMARY ==--
              |-
              |- [ INFO  ] Restarting httpd
              |-           Web access is enabled at:
              |-               http://enginevm.localdomain:80/ovirt-engine
              |-               https://enginevm.localdomain:443/ovirt-engine
              |-           Internal CA AC:9D:50:19:1E:83:7B:94:8A:B5:01:9C:D8:7D:99:14:B3:27:42:42
              |-           SSH fingerprint: 6d:22:95:1e:f9:5f:6e:cb:66:0b:ed:29:94:54:ca:39
              |- [WARNING] Less than 16384MB of memory is available
              |-
              |-           --== END OF SUMMARY ==--
              |-
              |- [ INFO  ] Stage: Clean up
              |-           Log file is located at /var/log/ovirt-engine/setup/ovirt-engine-setup-20160805085557-bnxrgm.log
              |- [ INFO  ] Generating answer file '/var/lib/ovirt-engine/setup/answers/20160805085625-setup.conf'
              |- [ INFO  ] Stage: Pre-termination
              |- [ INFO  ] Stage: Termination
              |- [ INFO  ] Execution of setup completed successfully
              |- HE_APPLIANCE_ENGINE_SETUP_SUCCESS
    [ INFO  ] Engine-setup successfully completed
    
It will wait for the new engine to come and it will check that everything is fine

    [ INFO  ] Engine-setup successfully completed
    [ INFO  ] Engine is still unreachable
    [ INFO  ] Engine is still not reachable, waiting...
    [ INFO  ] Engine is still unreachable
    [ INFO  ] Engine is still not reachable, waiting...
    [ INFO  ] Engine replied: DB Up!Welcome to Health Status!
    [ INFO  ] Connecting to the Engine

It will register the backup disk into the engine

    [ INFO  ] Registering the hosted-engine backup disk in the DB
    [ INFO  ] Waiting for the engine to complete disk registration. This may take several minutes...
    [ INFO  ] The engine VM backup disk is now ready
    [ INFO  ] Shutting down the engine VM
    [ INFO  ] Stage: Clean up
    [ INFO  ] Stage: Pre-termination
    [ INFO  ] Stage: Termination
    [ INFO  ] Hosted Engine successfully upgraded
    [ INFO  ] Please exit global maintenance mode to restart the new engine VM.

When ready the user has just to exit from global maintenance mode to start the upgraded VM with 4.0 engine.

    [root@foobar ~]# hosted-engine --set-maintenance --mode=none

Rolling back.
At any time the user can roll back to the backup of the engine VM disk taken during the upgrade flow.
In order to rollback:

    [root@foobar ovirt-hosted-engine-setup]# hosted-engine --rollback-upgrade
    [ INFO  ] Stage: Initializing
    [ INFO  ] Stage: Environment setup
              During customization use CTRL-D to abort.
              Continuing will rollback the engine VM from a previous upgrade attempt.
              This procedure will restore an engine VM image from a backup taken during an upgrade attempt.
              The result of any action occurred after the backup creation instant could be definitively lost.
              Are you sure you want to continue? (Yes, No)[Yes]: 
              Configuration files: []
              Log file: /var/log/ovirt-hosted-engine-setup/ovirt-hosted-engine-setup-20160805154705-arsb4n.log
              Version: otopi-1.5.1 (otopi-1.5.1-1.el7.centos)
    [ INFO  ] Bridge ovirtmgmt already created
    [ INFO  ] Stage: Environment packages setup
    [ INFO  ] Stage: Programs detection
    [ INFO  ] Stage: Environment setup

After initial checks (engine VM is down, global maintenance mode), 

    [ INFO  ] Checking maintenance mode
    [ INFO  ] The engine VM is down.
    
The script will let the user choose a backup source from the available backup disks.
The backup disk label will indicate when the backup was taken:

    [ INFO  ] Stage: Environment customization
    [ INFO  ] Answer file successfully loaded
              The following backup disk have been found on your system:
                    [1] - hosted-engine-backup-20160804184813
                    [2] - hosted-engine-backup-20160804182748
                    [3] - hosted-engine-backup-20160805104739
              Please select one of them  (1, 2, 3) [1]: 3

Once the user selects a backup image, the procedure will replace the engine VM disk with the one from the selected backup.

    [ INFO  ] Stage: Setup validation
    [ INFO  ] Stage: Transaction setup
    [ INFO  ] Stage: Misc configuration
    [ INFO  ] Stage: Package installation
    [ INFO  ] Stage: Misc configuration
    [ INFO  ] Restoring a backup of the engine VM disk (could take a few minutes depending on archive size)
    [ INFO  ] Successfully restored
    [ INFO  ] Stage: Transaction commit
    [ INFO  ] Stage: Closing up
    [ INFO  ] Stage: Clean up
    [ INFO  ] Stage: Pre-termination
    [ INFO  ] Stage: Termination
    [ INFO  ] Hosted Engine successfully rolled back
    [ INFO  ] Please exit global maintenance mode to restart the engine VM.

