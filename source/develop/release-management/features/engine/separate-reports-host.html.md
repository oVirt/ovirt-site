---
title: Separate-Reports-Host
category: feature
authors: didi, sandrobonazzola, sradco
feature_name: Separate Reports Host
feature_modules: engine
feature_status: QE
---

# Separate Reports Host

# Summary

Allow ovirt-engine-reports to be installed and configured by engine-setup on a separate machine, without requiring ovirt-engine or DWH to be on the same host.

# Owner

*   Name: Didi (Didi)

<!-- -->

*   Email: <didi@redhat.com>

# Current status

Implemented, should be available in 3.5.

# Detailed Description

We assume that engine is already setup and running on machine A.

If dwh is already installed and setup on machine B (can be same as A), and user wants to install reports on machine C, we need access to the engine's database and to dwh's database. If on separate host, user will be prompted for them.

If dwh is to be setup on machine B and user wants to install reports on the same machine B, we already have the credentials.

If dwh and reports are to be setup together on machine B, we need to make sure that setup recognizes that somehow, so that the reports plugin has access to needed info. Perhaps we'll decide to postpone that option - if we do, user will have to first setup dwh then reports.

# Migrating an existing DWH and Reports local installation

For migration of an existing local installation of DWH and Report to a different server please refer to [Migration_of_local_DWH_Reports_to_remote](/develop/release-management/features/engine/migration-of-local-dwh-reports-to-remote/)

# Example setup

Three VMs were created with fedora 19 installed. They are named 'f19-2' (for the engine), 'f19-2-dwh' (for DWH) and 'f19-2-reports' (for Reports).

## Engine

Let's start by setting up the engine on the engine machine:

      [root@didi-f19-2 ~]# engine-setup
      [ INFO  ] Stage: Initializing
      [ INFO  ] Stage: Environment setup
                Configuration files: ['/etc/ovirt-engine-setup.conf.d/10-packaging.conf']
                Log file: /var/log/ovirt-engine/setup/ovirt-engine-setup-20140804123130-0uuwlt.log
                Version: otopi-1.3.0_master (otopi-1.3.0-0.0.master.20140715.git336a22e.fc19)
      [ INFO  ] Stage: Environment packages setup
      [ INFO  ] Stage: Programs detection
      [ INFO  ] Stage: Environment setup
      [ INFO  ] Stage: Environment customization
                --== PRODUCT OPTIONS ==--
                Configure Engine on this host (Yes, No) [Yes]:
                Configure Data Warehouse on this host (Yes, No) [Yes]: no
                Configure Reports on this host (Yes, No) [Yes]: no
                Configure WebSocket Proxy on this host (Yes, No) [Yes]:

All components were installed with yum, so we can choose which to enable. If we do not install dwh/reports we'll not be asked about them.

                --== PACKAGES ==--
      [ INFO  ] Checking for product updates...
      [ INFO  ] No product updates found
                --== ALL IN ONE CONFIGURATION ==--
                --== NETWORK CONFIGURATION ==--
                Setup can automatically configure the firewall on this system.
                Note: automatic configuration of the firewall may overwrite current settings.
                Do you want Setup to configure the firewall? (Yes, No) [Yes]:
      [ INFO  ] firewalld will be configured as firewall manager.
                Host fully qualified DNS name of this server [didi-f19-2.ci.lab.tlv.redhat.com]:
      [WARNING] Failed to resolve didi-f19-2.ci.lab.tlv.redhat.com using DNS, it can be resolved only locally
                --== DATABASE CONFIGURATION ==--
                Where is the Engine database located? (Local, Remote) [Local]:
                Setup can configure the local postgresql server automatically for the engine to run. This may conflict with existing applications.
                Would you like Setup to automatically configure postgresql and create Engine database, or prefer to perform that manually? (Automatic, Manual) [Automatic]:
                --== OVIRT ENGINE CONFIGURATION ==--
                Engine admin password:
                Confirm engine admin password:
                Application mode (Both, Virt, Gluster) [Both]:
                Default storage type: (NFS, FC, ISCSI, POSIXFS, GLUSTERFS) [NFS]:
                --== PKI CONFIGURATION ==--
                --== APACHE CONFIGURATION ==--
                Setup can configure the default page of the web server to present the application home page. This may conflict with existing applications.
                Do you wish to set the application as the default page of the web server? (Yes, No) [Yes]:
                Setup can configure apache to use SSL using a certificate issued from the internal CA.
                Do you wish Setup to configure that, or prefer to perform that manually? (Automatic, Manual) [Automatic]:
                --== SYSTEM CONFIGURATION ==--
                Configure an NFS share on this server to be used as an ISO Domain? (Yes, No) [Yes]:
                Local ISO domain path [/var/lib/exports/iso-20140804093208]:
                Local ISO domain ACL - note that the default will restrict access to didi-f19-2.ci.lab.tlv.redhat.com only, for security reasons [didi-f19-2.ci.lab.tlv.redhat.com(rw)]:
                Local ISO domain name [ISO_DOMAIN]:
                --== MISC CONFIGURATION ==--
                --== END OF CONFIGURATION ==--
      [ INFO  ] Stage: Setup validation
      [WARNING] Warning: Not enough memory is available on the host. Minimum requirement is 4096MB, and 16384MB is recommended.
                Do you want Setup to continue, with amount of memory less than recommended? (Yes, No) [No]: yes
                --== CONFIGURATION PREVIEW ==--
                Application mode                        : both
                Update Firewall                         : True
                Host FQDN                               : didi-f19-2.ci.lab.tlv.redhat.com
                Datacenter storage type                 : nfs
                Firewall manager                        : firewalld
                Engine database name                    : engine
                Engine database secured connection      : False
                Engine database host                    : localhost
                Engine database user name               : engine
                Engine database host name validation    : False
                Engine database port                    : 5432
                Engine installation                     : True
                NFS setup                               : True
                NFS mount point                         : /var/lib/exports/iso-20140804093208
                NFS export ACL                          : didi-f19-2.ci.lab.tlv.redhat.com(rw)
                Configure local Engine database         : True
                Set application as default page         : True
                Configure Apache SSL                    : True
                DWH installation                        : False
                Configure local DWH database            : False
                Reports installation                    : False
                Configure local Reports database        : False
                Configure WebSocket Proxy               : True
                Please confirm installation settings (OK, Cancel) [OK]:
      [ INFO  ] Stage: Transaction setup
      [ INFO  ] Stopping dwh service
      [ INFO  ] Stopping reports service
      [ INFO  ] Stopping engine service
      [ INFO  ] Stopping ovirt-fence-kdump-listener service
      [ INFO  ] Stopping websocket-proxy service
      [ INFO  ] Stage: Misc configuration
      [ INFO  ] Stage: Package installation
      [ INFO  ] Stage: Misc configuration
      [ INFO  ] Creating PostgreSQL 'engine' database
      [ INFO  ] Configuring PostgreSQL
      [ INFO  ] Creating/refreshing Engine database schema
      [ INFO  ] Configuring WebSocket Proxy
      [ INFO  ] Generating post install configuration file '/etc/ovirt-engine-setup.conf.d/20-setup-ovirt-post.conf'
      [ INFO  ] Stage: Transaction commit
      [ INFO  ] Stage: Closing up
                --== SUMMARY ==--
      [WARNING] Warning: Not enough memory is available on the host. Minimum requirement is 4096MB, and 16384MB is recommended.
                SSH fingerprint: 09:3F:4A:D5:6D:7D:8D:59:77:4A:32:79:FC:23:57:1F
                Internal CA E7:20:D1:0C:23:5C:7C:1E:96:3E:70:66:01:00:91:89:FC:2F:52:7B
                Web access is enabled at:
`              `[`http://didi-f19-2.ci.lab.tlv.redhat.com:80/ovirt-engine`](http://didi-f19-2.ci.lab.tlv.redhat.com:80/ovirt-engine)
`              `[`https://didi-f19-2.ci.lab.tlv.redhat.com:443/ovirt-engine`](https://didi-f19-2.ci.lab.tlv.redhat.com:443/ovirt-engine)
                Please use the user "admin" and password specified in order to login
                --== END OF SUMMARY ==--
      [ INFO  ] Starting engine service
      [ INFO  ] Restarting httpd
      [ INFO  ] Restarting nfs services
      [ INFO  ] Stage: Clean up
                Log file is located at /var/log/ovirt-engine/setup/ovirt-engine-setup-20140804123130-0uuwlt.log
      [ INFO  ] Generating answer file '/var/lib/ovirt-engine/setup/answers/20140804123309-setup.conf'
      [ INFO  ] Stage: Pre-termination
      [ INFO  ] Stage: Termination
      [ INFO  ] Execution of setup completed successfully
      [root@didi-f19-2 ~]# 

## DWH

Let's continue by setting up DWH on the dwh machine:

      [root@didi-f19-2-dwh ~]# engine-setup
      [ INFO  ] Stage: Initializing
      [ INFO  ] Stage: Environment setup
                Configuration files: ['/etc/ovirt-engine-setup.conf.d/10-packaging.conf']
                Log file: /var/log/ovirt-engine/setup/ovirt-engine-setup-20140804123406-cmyl14.log
                Version: otopi-1.3.0_master (otopi-1.3.0-0.0.master.20140715.git336a22e.fc19)
      [ INFO  ] Stage: Environment packages setup
      [ INFO  ] Stage: Programs detection
      [ INFO  ] Stage: Environment setup
      [ INFO  ] Stage: Environment customization
                --== PRODUCT OPTIONS ==--
                Configure Engine on this host (Yes, No) [Yes]: no
                Configure Data Warehouse on this host (Yes, No) [Yes]:
                Configure Reports on this host (Yes, No) [Yes]: no
                Configure WebSocket Proxy on this host (Yes, No) [Yes]: no

Same here - we installed all, but choose to configure only DWH.

                --== PACKAGES ==--
      [ INFO  ] Checking for product updates...
      [ INFO  ] No product updates found
                --== ALL IN ONE CONFIGURATION ==--
                --== NETWORK CONFIGURATION ==--
                Setup can automatically configure the firewall on this system.
                Note: automatic configuration of the firewall may overwrite current settings.
                Do you want Setup to configure the firewall? (Yes, No) [Yes]:
      [ INFO  ] firewalld will be configured as firewall manager.
                Host fully qualified DNS name of this server [didi-f19-2-dwh.ci.lab.tlv.redhat.com]:
      [WARNING] Failed to resolve didi-f19-2-dwh.ci.lab.tlv.redhat.com using DNS, it can be resolved only locally
                --== DATABASE CONFIGURATION ==--
                Where is the DWH database located? (Local, Remote) [Local]:
                Setup can configure the local postgresql server automatically for the DWH to run. This may conflict with existing applications.
                Would you like Setup to automatically configure postgresql and create DWH database, or prefer to perform that manually? (Automatic, Manual) [Automatic]:

Since on the engine side we chose "automatic provisioning" of postgres, we'll have to look up the randomly-generated **Engine database password** in /etc/ovirt-engine/engine.conf.d/10-setup-database.conf . We also need to make sure that the host name is resolvable - in this case I simply added 'f19-2' with the engine's VM address to /etc/hosts here.

                Engine database host []: f19-2
                Engine database port [5432]:
                Engine database secured connection (Yes, No) [No]:
                Engine database name [engine]:
                Engine database user [engine]:
                Engine database password:
                --== OVIRT ENGINE CONFIGURATION ==--
                --== PKI CONFIGURATION ==--
                --== APACHE CONFIGURATION ==--
                --== SYSTEM CONFIGURATION ==--
                --== MISC CONFIGURATION ==--
                --== END OF CONFIGURATION ==--
      [ INFO  ] Stage: Setup validation
                --== CONFIGURATION PREVIEW ==--
                Update Firewall                         : True
                Host FQDN                               : didi-f19-2-dwh.ci.lab.tlv.redhat.com
                Firewall manager                        : firewalld
                Engine database name                    : engine
                Engine database secured connection      : False
                Engine database host                    : f19-2
                Engine database user name               : engine
                Engine database host name validation    : False
                Engine database port                    : 5432
                Engine installation                     : False
                DWH installation                        : True
                DWH database name                       : ovirt_engine_history
                DWH database secured connection         : False
                DWH database host                       : localhost
                DWH database user name                  : ovirt_engine_history
                DWH database host name validation       : False
                DWH database port                       : 5432
                Configure local DWH database            : True
                Reports installation                    : False
                Configure local Reports database        : False
                Configure WebSocket Proxy               : False
                Please confirm installation settings (OK, Cancel) [OK]:
      [ INFO  ] Stage: Transaction setup
      [ INFO  ] Stopping dwh service
      [ INFO  ] Stopping reports service
      [ INFO  ] Stopping engine service
      [ INFO  ] Stopping ovirt-fence-kdump-listener service
      [ INFO  ] Stopping websocket-proxy service
      [ INFO  ] Stage: Misc configuration
      [ INFO  ] Stage: Package installation
      [ INFO  ] Stage: Misc configuration
      [ INFO  ] Creating PostgreSQL 'ovirt_engine_history' database
      [ INFO  ] Configuring PostgreSQL
      [ INFO  ] Creating/refreshing DWH database schema
      [ INFO  ] Generating post install configuration file '/etc/ovirt-engine-setup.conf.d/20-setup-ovirt-post.conf'
      [ INFO  ] Stage: Transaction commit
      [ INFO  ] Stage: Closing up
                --== SUMMARY ==--
                --== END OF SUMMARY ==--
      [ INFO  ] Starting dwh service
      [ INFO  ] Stage: Clean up
                Log file is located at /var/log/ovirt-engine/setup/ovirt-engine-setup-20140804123406-cmyl14.log
      [ INFO  ] Generating answer file '/var/lib/ovirt-engine/setup/answers/20140804123502-setup.conf'
      [ INFO  ] Stage: Pre-termination
      [ INFO  ] Stage: Termination
      [ INFO  ] Execution of setup completed successfully
      [root@didi-f19-2-dwh ~]# 

## Reports

On the reports machine:

      [root@didi-f19-2-reports ~]# engine-setup
      [ INFO  ] Stage: Initializing
      [ INFO  ] Stage: Environment setup
                Configuration files: []
                Log file: /var/log/ovirt-engine/setup/ovirt-engine-setup-20141008122615-jeri2i.log
                Version: otopi-1.3.0_master (otopi-1.3.0-0.0.master.20140928.git86e4470.fc19)
      [ INFO  ] Stage: Environment packages setup
      [ INFO  ] Stage: Programs detection
      [ INFO  ] Stage: Environment setup
      [ INFO  ] Stage: Environment customization
                --== PRODUCT OPTIONS ==--
                Configure Reports on this host (Yes, No) [Yes]:
                Configure WebSocket Proxy on this host (Yes, No) [Yes]: no

Here we did not have engine and DWH installed so we are not asked about them.

                --== PACKAGES ==--
      [ INFO  ] Checking for product updates...
      [ INFO  ] No product updates found
                --== ALL IN ONE CONFIGURATION ==--
                --== NETWORK CONFIGURATION ==--
                Setup can automatically configure the firewall on this system.
                Note: automatic configuration of the firewall may overwrite current settings.
                Do you want Setup to configure the firewall? (Yes, No) [Yes]:
      [ INFO  ] firewalld will be configured as firewall manager.
                Host fully qualified DNS name of this server [didi-f19-2-reports.ci.lab.tlv.redhat.com]:
      [WARNING] Failed to resolve didi-f19-2-reports.ci.lab.tlv.redhat.com using DNS, it can be resolved only locally
                Host fully qualified DNS name of the engine server []: f19-2
      [WARNING] Host name f19-2 has no domain suffix
      [WARNING] Failed to resolve f19-2 using DNS, it can be resolved only locally
                --== DATABASE CONFIGURATION ==--
                Where is the Reports database located? (Local, Remote) [Local]:
                Setup can configure the local postgresql server automatically for the Reports to run. This may conflict with existing applications.
                Would you like Setup to automatically configure postgresql and create Reports database, or prefer to perform that manually? (Automatic, Manual) [Automatic]:

We can see the DWH DB credentials on the DWH machine in /etc/ovirt-engine-dwh/ovirt-engine-dwhd.conf.d/10-setup-database.conf :

                DWH database host []: f19-2-dwh
                DWH database port [5432]:
                DWH database secured connection (Yes, No) [No]:
                DWH database name [ovirt_engine_history]:
                DWH database user [ovirt_engine_history]:
                DWH database password:
                --== OVIRT ENGINE CONFIGURATION ==--

### PKI

*   For this feature we separated the engine web application and the Reports one to two independent jboss instances, each with its own pki.
*   engine plugin of setup always generates pki for the reports jboss instance.
*   If this is not found during reports plugin setup (as is the case here), we are asked about it.
*   For apache - if running on the engine machine, we use the same instance, and just add a bit of configuration to point at the new reports jboss instance. If we do not find pki for apache, which is the case here, we ask for it.
*   This can be done either manually, copying files around, or automatically, by supplying the root password on the engine server and using ssh.
*   Also note that all of this interaction happens only if the key and cert files are not found. This means that on upgrade we (obviously) do not need to repeat this, and also that it's possible to do this beforehand - to manually generate keys, sign them with a CA and put in the expected locations.

                --== PKI CONFIGURATION ==--
                Setup will need to do some actions on the remote engine server. Either automatically, using ssh as root to access it, or you will be prompted to manually perform each such action.
                Please choose one of the following:
                1 - Access remote engine server using ssh as root
                2 - Perform each action manually, use files to copy content around
                (1, 2) [1]:
                ssh port on remote engine server [22]:
                root password on remote engine server f19-2:
      [ INFO  ] Signing the Reports certificate on the engine server
      [ INFO  ] Reports certificate signed successfully
      [ INFO  ] Signing the Apache certificate on the engine server
      [ INFO  ] Apache certificate signed successfully
                --== APACHE CONFIGURATION ==--
                Setup can configure apache to use SSL using a certificate issued from the internal CA.
                Do you wish Setup to configure that, or prefer to perform that manually? (Automatic, Manual) [Automatic]:
                --== SYSTEM CONFIGURATION ==--
                --== MISC CONFIGURATION ==--
                Reports power users password:
                Confirm Reports power users password:
                --== END OF CONFIGURATION ==--
      [ INFO  ] Stage: Setup validation
                --== CONFIGURATION PREVIEW ==--
                Firewall manager                        : firewalld
                Update Firewall                         : True
                Host FQDN                               : didi-f19-2-reports.ci.lab.tlv.redhat.com
                Configure Apache SSL                    : True
                Reports installation                    : True
                Reports database name                   : ovirt_engine_reports
                Reports database secured connection     : False
                Reports database host                   : localhost
                Reports database user name              : ovirt_engine_reports
                Reports database host name validation   : False
                Reports database port                   : 5432
                Configure local Reports database        : True
                DWH database name                       : ovirt_engine_history
                DWH database secured connection         : False
                DWH database host                       : f19-2-dwh
                DWH database user name                  : ovirt_engine_history
                DWH database host name validation       : False
                DWH database port                       : 5432
                Engine Host FQDN                        : f19-2
                Configure WebSocket Proxy               : False

                Please confirm installation settings (OK, Cancel) [OK]:
      [ INFO  ] Stage: Transaction setup
      [ INFO  ] Stopping reports service
      [ INFO  ] Stopping websocket-proxy service
      [ INFO  ] Stage: Misc configuration
      [ INFO  ] Stage: Package installation
      [ INFO  ] Stage: Misc configuration               
      [ INFO  ] Creating PostgreSQL 'ovirt_engine_reports' database
      [ INFO  ] Configuring PostgreSQL                  
      [ INFO  ] Deploying Jasper 
      [ INFO  ] Importing data into Jasper              
      [ INFO  ] Configuring Jasper Java resources       
      [ INFO  ] Configuring Jasper Database resources   
      [ INFO  ] Customizing Jasper
      [ INFO  ] Customizing Jasper metadata             
      [ INFO  ] Generating post install configuration file '/etc/ovirt-engine-setup.conf.d/20-setup-ovirt-post.conf'
      [ INFO  ] Stage: Transaction commit               
      [ INFO  ] Stage: Closing up
                --== SUMMARY ==--
                --== END OF SUMMARY ==--
      [ INFO  ] Restarting httpd
      [ INFO  ] Starting reports service                
      [ INFO  ] Stage: Clean up
                Log file is located at /var/log/ovirt-engine/setup/ovirt-engine-setup-20141008122615-jeri2i.log
      [ INFO  ] Generating answer file '/var/lib/ovirt-engine/setup/answers/20141008123458-setup.conf'
      [ INFO  ] Stage: Pre-termination
      [ INFO  ] Stage: Termination
      [ INFO  ] Execution of setup completed successfully 
      [root@didi-f19-2-reports ~]# 

The generated keys/certs:

      [root@didi-f19-2-reports ~]# ls -lR /etc/pki/ovirt-engine
      /etc/pki/ovirt-engine:
      total 12
      lrwxrwxrwx 1 root  root    43 Oct  8 12:34 apache-ca.pem -> /etc/pki/ovirt-engine/apache-reports-ca.pem
      -rw------- 1 ovirt ovirt 1461 Oct  8 12:34 apache-reports-ca.pem
      drwxr-xr-x 2 ovirt ovirt 4096 Oct  8 12:34 certs
      drwxr-xr-x 2 root  root  4096 Oct  8 12:34 keys
      /etc/pki/ovirt-engine/certs:
      total 16
      lrwxrwxrwx 1 root  root    46 Oct  8 12:34 apache.cer -> /etc/pki/ovirt-engine/certs/apache-reports.cer
      -rw------- 1 ovirt ovirt 5318 Oct  8 12:34 apache-reports.cer
      -rw------- 1 ovirt ovirt 5318 Oct  8 12:34 reports.cer
      /etc/pki/ovirt-engine/keys:
      total 8
      lrwxrwxrwx 1 root  root    52 Oct  8 12:34 apache.key.nopass -> /etc/pki/ovirt-engine/keys/apache-reports.key.nopass
      -rw------- 1 ovirt ovirt 1679 Oct  8 12:34 apache-reports.key.nopass
      -rw------- 1 ovirt ovirt 1675 Oct  8 12:34 reports.key.nopass
      [root@didi-f19-2-reports ~]# 

# Benefit to oVirt

Reports might cause significant load on the engine machine. Installing it on a separate machine will allow distributing the load.

Some installations might want to separate for security reasons, e.g. to give some users access only to Reports and not to the engine web admin.

# Dependencies / Related Features

# Documentation / External references

## Bugs

<https://bugzilla.redhat.com/1080998>

## Presentation

[ZIP](http://resources.ovirt.org/old-site-files/wiki/Engine-dwh-reports-on-separate-hosts-presentation.zip) pandoc source and the generated html included.

# Testing

Install and setup ovirt-engine on machine A, ovirt-engine-dwh on machine B (A and B might be the same machine), ovirt-engine-reports on machine C, see that the reports application on C shows data from the engine on machine A collected by DWH on machine B.

On A:

      yum install ovirt-engine-setup
      engine-setup

On B:

      yum install ovirt-engine-dwh-setup
      engine-setup

On C:

      yum install ovirt-engine-reports-setup
      engine-setup



[Separate Reports Host](/develop/release-management/features/) [Separate Reports Host](/develop/release-management/releases/3.5/feature/) [Separate Reports Host](Category:Integration)
