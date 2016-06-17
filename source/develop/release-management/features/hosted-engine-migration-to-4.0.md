---
title: Hosted-engine migration to 4.0
category: feature
authors: stirabos
wiki_category: Hosted-engine migration to 4.0
wiki_title: Hosted-engine migration to 4.0
wiki_revision_count: 1
wiki_last_updated: 2016-06-17
feature_name: Hosted-engine migration to 4.0
feature_modules: ovirt-hosted-engine-setup
feature_status: On QA
---

Hosted-engine migration to 4.0

# Hosted-engine migration to 4.0

### Summary

In 3.6 the engine rpms were released also for el6 so user could deply the hosted-engine on el6.
In 4.0 we are going to release the oVirt engine for el7 but not for el6 so we should provide an upgrade path for who deployed hosted-engine using an el6 based VM.

### Owner

*   Name: [ Simone Tiraboschi](User:stirabos)

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
- ask the user to take a backup on the engine VM with engine-backup and copy it back to the host (we are just asking to the user since by default ssh was closed on our old appliances and the effort to open it is not that different than taking the backup).
- check the backup content
- ask all the missing information (the exact list depend on how 3.6 was deployed and so what is on the answer file on the shared storage)
- use the 3.6 engine to create a new floating disk on the hosted-engine storage domain (the use has to resize the hosted-engine storage domain from the engien if we don't have enough free space for the additional disk)
- shutdown the engine VM
- transfer the 4.0/el7 appliance over the new disk
- inject the backup to the new disk with guestfish
- generate a new cloud-init image to configure the el7 appliance
- tweak vm.conf on the fly to replace the 3.6/el6 disk with the 4.0/el7 disk and attach the cloud-init image
- boot the engine VM this will:
- - configure the appliance via cloud-init
- - not interactively (from cloud-init and checking the output over a virtio channel) run engine-backup to restore the 3.6 backup
- - not interactively  (from cloud-init and checking the output over a virtio channel) run engine-setup to configure the 4.0 engine
- check the engine status and ask to the user that everything is fine and he wants to definitvely switch the disks
- via REST api, scan external disks and add the floating disk to the engine since it was created after the backup was taken
- via REST api, edit the engine VM to replace the 3.6/el6 disk with the 4.0/el7 one and wait for OVF_STORE update
Till the latest step, the OVF_STORE still point to the original 3.6/el6 disk so that any failure will result in an automatic and almost instant rollback.

### Benefit to oVirt

The user will be able to upgrade

### Dependencies / Related Features

- the capability to edit the engine VM via REST API
- the capability to force OVF_STORE updates or have it in sync with engine VM editing

### Testing

- Set the global maintenance mode
- Put the host where the engin VM is running into maintenance
- Add the 4.0 repo and upgrade the host

Run hosted-engine-setup --upgrade-appliance

    [root@c72he20160606h1 ~]# hosted-engine --upgrade-appliance
    [ INFO  ] Stage: Initializing
    [ INFO  ] Stage: Environment setup
              During customization use CTRL-D to abort.
              Continuing will upgrade the engine VM running on one of the hosts of this cluster deploying and configuring a new appliance.
              If your engine VM is already based on el7 you can also simply upgrade the engine there.
              The disk of your engine VM will be replaced with a new one that contains an up-to-date appliance;
              the current engine VM disk will be left on the hosted-engine shared domain as a floating disk for recovery purposes.
              You will be asked to take a backup of the running engine and copy it to this host.
              The engine backup will be automatically injected and recovered on the new appliance.
              Are you sure you want to continue? (Yes, No)[Yes]: 
              Configuration files: []
              Log file: /var/log/ovirt-hosted-engine-setup/ovirt-hosted-engine-setup-20160610145124-249nwp.log
              Version: otopi-1.5.0 (otopi-1.5.0-1.el7.centos)
    [ INFO  ] Bridge ovirtmgmt already created
    [ INFO  ] Stage: Environment packages setup
    [ INFO  ] Stage: Programs detection
    [ INFO  ] Stage: Environment setup
    [ INFO  ] Checking maintenance mode
    [ INFO  ] Stage: Environment customization
    [ INFO  ] Answer file successfully loaded
  
  Add the missing information, it depends on how the 3.6 engine was deployed.
  
              Enter engine admin password: 
              Confirm engine admin password: 
    [ INFO  ] Detecting available oVirt engine appliances
              The following appliance have been found on your system:
              	[1] - The oVirt Engine Appliance image (OVA) - 4.0-20160603.1.el7.centos
              	[2] - Directly select an OVA file
              Please select an appliance (1, 2) [1]: 
  
  Select the 4.0 appliance
  
    [ INFO  ] Verifying its sha1sum
    [ INFO  ] Checking OVF archive content (could take a few minutes depending on archive size)
    [ INFO  ] Checking OVF XML content (could take a few minutes depending on archive size)
    [WARNING] OVF does not contain a valid image description, using default.
              Please provide the FQDN you would like to use for the engine appliance.
              Note: This will be the FQDN of the engine VM you are now going to launch,
              it should not point to the base host or to any other existing machine.
              Engine VM FQDN: (leave it empty to skip):  []: enginevm.localdomain
              Please provide the domain name you would like to use for the engine appliance.
              Engine VM domain: [localdomain]
              Enter root password that will be used for the engine appliance (leave it empty to skip): 
              Confirm appliance root password: 
              Please take a backup of the current engine running this command on the engine VM:
               engine-backup --mode=backup --file=engine_backup.tar.gz --log=engine_backup.log
              Then copy the backup archive to this host and input here its path when ready.
              Please specify path to engine backup archive you would like to restore on the new appliance: /root/engine_backup.tar.gz
 
Connect to the host and run engine-backup, copy the archive to the host.

    [ INFO  ] Validating backup file '/root/engine_backup.tar.gz'
    [ INFO  ] '/root/engine_backup.tar.gz' is a sane backup file
              How should the engine VM network be configured (DHCP, Static)[DHCP]? static
              Please enter the IP address to be used for the engine VM [192.168.1.2]: 192.168.1.206
    [ INFO  ] The engine VM will be configured to use 192.168.1.206/24
              Please provide a comma-separated list (max 3) of IP addresses of domain name servers for the engine VM
              Engine VM DNS (leave it empty to skip) [192.168.1.1]: 192.168.1.1
              Add lines for the appliance itself and for this host to /etc/hosts on the engine VM?
              Note: ensuring that this host could resolve the engine VM hostname is still up to you
              (Yes, No)[No] yes
    [ INFO  ] Stage: Setup validation
    [ INFO  ] Acquiring internal CA cert from the engine
    [ INFO  ] The following CA certificate is going to be used, please immediately interrupt if not correct:
    [ INFO  ] Issuer: C=US, O=localdomain, CN=enginevm.localdomain.98502, Subject: C=US, O=localdomain, CN=enginevm.localdomain.98502, Fingerprint (SHA-1): 71E848DB4487128CF461F50F371C1ABF5065BA61
    [ INFO  ] Connecting to the Engine
    [ INFO  ] Stage: Transaction setup
    [ INFO  ] Stage: Misc configuration
    [ INFO  ] Stage: Package installation
    [ INFO  ] Stage: Misc configuration
    [ INFO  ] Connecting to the Engine
    [ INFO  ] Waiting for the engine to complete disk creation. This may take several minutes...
    [ INFO  ] Still waiting for new engine VM disk to be created. This may take several minutes...
    [ INFO  ] Still waiting for new engine VM disk to be created. This may take several minutes...
    [ INFO  ] Still waiting for new engine VM disk to be created. This may take several minutes...
    [ INFO  ] The new engine VM disk is now ready

The tool will create the new disk

    [ INFO  ] Shutting down the current engine VM
    [ INFO  ] Extracting disk image from OVF archive (could take a few minutes depending on archive size)
    [ INFO  ] Validating pre-allocated volume size
    [ INFO  ] Uploading volume to data domain (could take a few minutes depending on archive size)
    [ INFO  ] Injecting engine backup
    [ INFO  ] Backup successfully injected

The tool will inject the backup

    [ INFO  ] Image successfully imported from OVF
    [ INFO  ] Stage: Transaction commit
    [ INFO  ] Stage: Closing up
    [ INFO  ] Trying to get a fresher copy of vm configuration from the OVF_STORE

And it will run the VM with the new disk

    [ INFO  ] Running engine-setup on the appliance
              |- Preparing to restore:
              |- - Unpacking file '/root/engine_backup.tar.gz'
              |- Restoring:
              |- - Files
              |- Provisioning PostgreSQL users/databases:
              |- - user 'engine', database 'engine'
              |- Restoring:
              |- - Engine database 'engine'
              |-   - Cleaning up temporary tables in engine database 'engine'
              |- ------------------------------------------------------------------------------
              |- Please note:
              |- The engine database was backed up at 2016-06-10 12:44:56.000000000 +0000 .
              |- Objects that were added, removed or changed after this date, such as virtual
              |- machines, disks, etc., are missing in the engine, and will probably require
              |- recovery or recreation.
              |- ------------------------------------------------------------------------------
              |- You should now run engine-setup.
              |- Done.
              |- HE_APPLIANCE_ENGINE_RESTORE_SUCCESS

The engine VM will try to restore the backup and if fine it will execute engine-setup

    [ INFO  ] Engine backup successfully restored
              |- [ INFO  ] Stage: Initializing
              |- [ INFO  ] Stage: Environment setup
              |-           Configuration files: ['/etc/ovirt-engine-setup.conf.d/10-packaging-jboss.conf', '/etc/ovirt-engine-setup.conf.d/10-packaging.conf', '/etc/ovirt-engine-setup.conf.d/20-setup-ovirt-post.conf', '/root/ovirt-engine-answers', '/root/heanswers.conf']
              |-           Log file: /var/log/ovirt-engine/setup/ovirt-engine-setup-20160610125928-xkn6kg.log
              |-           Version: otopi-1.5.0 (otopi-1.5.0-1.el7.centos)
              |- [ INFO  ] Stage: Environment packages setup
              |- [ INFO  ] Stage: Programs detection
              |- [ INFO  ] Stage: Environment setup
              |- [ INFO  ] Stage: Environment customization
              |-          
              |-           --== PRODUCT OPTIONS ==--
              |-          
              |-           Please note: Data Warehouse is required for the engine. If you choose to not configure it on this host, you have to configure it on a remote host, and then configure the engine on this host so that it can access the database of the remote Data Warehouse host.
              |-           Configure Data Warehouse on this host (Yes, No) [Yes]: 
              |-          
              |-           --== PACKAGES ==--
              |-          
              |-          
              |-           --== NETWORK CONFIGURATION ==--
              |-          
              |- [WARNING] Failed to resolve enginevm.localdomain using DNS, it can be resolved only locally
              |- [ INFO  ] firewalld will be configured as firewall manager.
              |-          
              |-           --== DATABASE CONFIGURATION ==--
              |-          
              |-           Where is the DWH database located? (Local, Remote) [Local]: 
              |-           Setup can configure the local postgresql server automatically for the DWH to run. This may conflict with existing applications.
              |-           Would you like Setup to automatically configure postgresql and create DWH database, or prefer to perform that manually? (Automatic, Manual) [Automatic]: 
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
              |-           Please choose Data Warehouse sampling scale:
              |-           (1) Basic
              |-           (2) Full
              |-           (1, 2)[1]: 
              |-          
              |-           --== END OF CONFIGURATION ==--
              |-          
              |- [ INFO  ] Stage: Setup validation
              |- [WARNING] Cannot validate host name settings, reason: cannot resolve own name 'enginevm'
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
              |-           Configure local DWH database            : True
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
              |- [ INFO  ] Creating PostgreSQL 'ovirt_engine_history' database
              |- [ INFO  ] Configuring PostgreSQL
              |- [ INFO  ] Backing up database localhost:engine to '/var/lib/ovirt-engine/backups/engine-20160610125936.n3ISiZ.dump'.
              |- [ INFO  ] Creating/refreshing Engine database schema
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
              |-           Internal CA 71:E8:48:DB:44:87:12:8C:F4:61:F5:0F:37:1C:1A:BF:50:65:BA:61
              |-           SSH fingerprint: 37:f0:29:6e:3d:1e:30:7c:1d:ec:32:81:c5:8e:c4:ba
              |- [WARNING] Less than 16384MB of memory is available
              |-          
              |-           --== END OF SUMMARY ==--
              |-          
              |- [ INFO  ] Stage: Clean up
              |-           Log file is located at /var/log/ovirt-engine/setup/ovirt-engine-setup-20160610125928-xkn6kg.log
              |- [ INFO  ] Generating answer file '/var/lib/ovirt-engine/setup/answers/20160610130244-setup.conf'
              |- [ INFO  ] Stage: Pre-termination
              |- [ INFO  ] Stage: Termination
              |- [ INFO  ] Execution of setup completed successfully
              |- HE_APPLIANCE_ENGINE_SETUP_SUCCESS
    [ INFO  ] Engine-setup successfully completed 
    [ INFO  ] Engine is still unreachable
    [ INFO  ] Engine is still not reachable, waiting...
    [ INFO  ] Engine is still unreachable
    [ INFO  ] Engine is still not reachable, waiting...
    [ INFO  ] Engine replied: DB Up!Welcome to Health Status!
    [ INFO  ] Connecting to the Engine
              The engine VM is currently running with the new disk but the hosted-engine configuration is still point to the old one.
              Please make sure that everything is fine on the engine VM side before definitively switching the disks.
              Are you sure you want to continue? (Yes, No)[Yes]: 

Some automatic checks here and then last confirmation from the user.
Till now the OVF_STORE will still point to the 3.6 disk and so the engine VM will restart as it was.

    [ INFO  ] Connecting to the Engine
    [ INFO  ] Registering the new hosted-engine disk in the DB
    [ INFO  ] Waiting for the engine to complete disk registration. This may take several minutes...
    [ INFO  ] The new engine VM disk is now ready
    [WARNING] FIXME: please reduce the OVF_STORE update timeout with 'engine-config -s OvfUpdateIntervalInMinutes=1', this script will wait 5 minutes.
    [ INFO  ] Shutting down the engine VM
    [ INFO  ] Stage: Clean up
    [ INFO  ] Stage: Pre-termination
    [ INFO  ] Stage: Termination
    [ INFO  ] Hosted Engine successfully upgraded
    [ INFO  ] Please exit global maintenance mode to restart the new engine VM.

When ready the user has just to exit from global maintenance mode to start the upgraded VM with 4.0 engine.

    [root@c72he20160606h1 ~]# hosted-engine --set-maintenance --mode=none
