---
title: Using oVirt Engine with a PostgreSQL container.
authors: jbrooks, leni1
---

The base environment used here is CentOS 7.

1. Install ovirt-engine:

```
yum install -y http://resources.ovirt.org/pub/yum-repo/ovirt-release41.rpm
yum install ovirt-engine -y
```

2. Start postgres container:

```
docker run --name=postgresql -d -p 5432:5432 registry.centos.org/centos/postgres:latest 
```

3. Prepare the PostgreSQL database according to the guide below:
[Preparing_a_Remote_PostgreSQL_Database_for_Use_with_the_oVirt_Engine](/documentation/install-guide/appe-Preparing_a_Remote_PostgreSQL_Database_for_Use_with_the_oVirt_Engine/)


```
docker exec -ti postgresql bash
su - postgres
psql

postgres=# create role engine with login encrypted password 'password';
postgres=# create database engine owner engine template template0 encoding 'UTF8' lc_collate 'en_US.UTF-8' lc_ctype 'en_US.UTF-8';
postgres=# \q

vi /var/lib/pgsql/data/pg_hba.conf
```

Ensure the database can be accessed remotely by enabling md5 client authentication. Edit the /var/lib/pgsql/data/pg_hba.conf file, and add the following line immediately underneath the line starting with local at the bottom of the file, replacing X.X.X.X with the IP address of the Engine:

```
 host    database_name    user_name    X.X.X.X/32   md5
```

Edit `postgresql.conf` and add following lines:

```
vi /var/lib/pgsql/data/postgresql.conf

autovacuum_vacuum_scale_factor = 0.01
autovacuum_analyze_scale_factor = 0.075
autovacuum_max_workers = 6
maintenance_work_mem = 65536
max_connections = 150
lc_messages = 'en_US.UTF-8'
```

4. Restart the database within the container:

```
-bash-4.2$ pg_ctl restart
exit
exit
```

5. Setup ovirt-engine:

```
engine-setup

# engine-setup 
[ INFO  ] Stage: Initializing
[ INFO  ] Stage: Environment setup
          Configuration files: ['/etc/ovirt-engine-setup.conf.d/10-packaging-jboss.conf', '/etc/ovirt-engine-setup.conf.d/10-packaging.conf']
          Log file: /var/log/ovirt-engine/setup/ovirt-engine-setup-20170803144341-soqdsk.log
          Version: otopi-1.6.2 (otopi-1.6.2-1.el7.centos)
[ INFO  ] Stage: Environment packages setup
[ INFO  ] Stage: Programs detection
[ INFO  ] Stage: Environment setup
[ INFO  ] Stage: Environment customization
         
          --== PRODUCT OPTIONS ==--
         
          Configure Engine on this host (Yes, No) [Yes]: 
          Configure Image I/O Proxy on this host? (Yes, No) [Yes]: 
          Configure WebSocket Proxy on this host (Yes, No) [Yes]: 
          Please note: Data Warehouse is required for the engine. If you choose to not configure it on this host, you have to configure it on a remote host, and then configure the engine on this host so that it can access the database of the remote Data Warehouse host.
          Configure Data Warehouse on this host (Yes, No) [Yes]: No
          Configure VM Console Proxy on this host (Yes, No) [Yes]: 
         
          --== PACKAGES ==--
         
[ INFO  ] Checking for product updates...
[ INFO  ] No product updates found
         
          --== NETWORK CONFIGURATION ==--
         
          Host fully qualified DNS name of this server [centos-1.osas.lab]: 
          Setup can automatically configure the firewall on this system.
          Note: automatic configuration of the firewall may overwrite current settings.
          Do you want Setup to configure the firewall? (Yes, No) [Yes]: 
[ INFO  ] firewalld will be configured as firewall manager.
         
          --== DATABASE CONFIGURATION ==--
         
          Where is the Engine database located? (Local, Remote) [Local]: Remote
         
          ATTENTION
         
          Manual action required.
          Please create database for ovirt-engine use. Use the following commands as an example:
         
          create role engine with login encrypted password '<password>';
          create database engine owner engine
           template template0
           encoding 'UTF8' lc_collate 'en_US.UTF-8'
           lc_ctype 'en_US.UTF-8';
         
          Make sure that database can be accessed remotely.
         
          Engine database host [localhost]: centos-1.osas.lab
          Engine database port [5432]: 
          Engine database secured connection (Yes, No) [No]: 
          Engine database name [engine]: 
          Engine database user [engine]: 
          Engine database password: 
         
          --== OVIRT ENGINE CONFIGURATION ==--
         
          Engine admin password: 
          Confirm engine admin password: 
          Application mode (Virt, Gluster, Both) [Both]: 
         
          --== STORAGE CONFIGURATION ==--
         
          Default SAN wipe after delete (Yes, No) [No]: 
         
          --== PKI CONFIGURATION ==--
         
          Organization name for certificate [osas.lab]: 
         
          --== APACHE CONFIGURATION ==--
         
          Setup can configure the default page of the web server to present the application home page. This may conflict with existing applications.
          Do you wish to set the application as the default page of the web server? (Yes, No) [Yes]: 
          Setup can configure apache to use SSL using a certificate issued from the internal CA.
          Do you wish Setup to configure that, or prefer to perform that manually? (Automatic, Manual) [Automatic]: 
         
          --== SYSTEM CONFIGURATION ==--
         
          Configure an NFS share on this server to be used as an ISO Domain? (Yes, No) [No]: 
         
          --== MISC CONFIGURATION ==--
         
         
          --== END OF CONFIGURATION ==--
         
[ INFO  ] Stage: Setup validation
[WARNING] Less than 16384MB of memory is available
         
          --== CONFIGURATION PREVIEW ==--
         
          Application mode                        : both
          Default SAN wipe after delete           : False
          Firewall manager                        : firewalld
          Update Firewall                         : True
          Host FQDN                               : centos-1.osas.lab
          Configure local Engine database         : False
          Set application as default page         : True
          Configure Apache SSL                    : True
          Engine database secured connection      : False
          Engine database user name               : engine
          Engine database name                    : engine
          Engine database host                    : centos-1.osas.lab
          Engine database port                    : 5432
          Engine database host name validation    : False
          Engine installation                     : True
          PKI organization                        : osas.lab
          DWH installation                        : False
          Configure local DWH database            : False
          Configure Image I/O Proxy               : True
          Configure VMConsole Proxy               : True
          Configure WebSocket Proxy               : True
         
          Please confirm installation settings (OK, Cancel) [OK]: 
[ INFO  ] Stage: Transaction setup
[ INFO  ] Stopping engine service
[ INFO  ] Stopping ovirt-fence-kdump-listener service
[ INFO  ] Stopping Image I/O Proxy service
[ INFO  ] Stopping vmconsole-proxy service
[ INFO  ] Stopping websocket-proxy service
[ INFO  ] Stage: Misc configuration
[ INFO  ] Stage: Package installation
[ INFO  ] Stage: Misc configuration
[ INFO  ] Upgrading CA
[ INFO  ] Creating CA
[ INFO  ] Creating/refreshing Engine database schema
[ INFO  ] Configuring Image I/O Proxy
[ INFO  ] Setting up ovirt-vmconsole proxy helper PKI artifacts
[ INFO  ] Setting up ovirt-vmconsole SSH PKI artifacts
[ INFO  ] Configuring WebSocket Proxy
[ INFO  ] Creating/refreshing Engine 'internal' domain database schema
[ INFO  ] Generating post install configuration file '/etc/ovirt-engine-setup.conf.d/20-setup-ovirt-post.conf'
[ INFO  ] Stage: Transaction commit
[ INFO  ] Stage: Closing up
[ INFO  ] Starting engine service
[ INFO  ] Restarting ovirt-vmconsole proxy service
         
          --== SUMMARY ==--
         
[ INFO  ] Restarting httpd
          Please use the user 'admin@internal' and password specified in order to login
          The engine requires access to the Data Warehouse database.
          Data Warehouse was not set up. Please set it up on some other machine and configure access to it on the engine.
          Web access is enabled at:
              http://myexample.domain.org:80/ovirt-engine
              https://myexample.domain.org:443/ovirt-engine
          Internal CA 8F:C8:A6:B6:D0:6E:34:92:D2:65:21:63:9C:35:64:4D:EE:09:59:72
          SSH fingerprint: 0d:54:5c:7e:63:6f:fb:85:47:f7:00:8d:4f:95:cc:c1
[WARNING] Less than 16384MB of memory is available
         
          --== END OF SUMMARY ==--
         
[ INFO  ] Stage: Clean up
          Log file is located at /var/log/ovirt-engine/setup/ovirt-engine-setup-20170803144341-soqdsk.log
[ INFO  ] Generating answer file '/var/lib/ovirt-engine/setup/answers/20170803144525-setup.conf'
[ INFO  ] Stage: Pre-termination
[ INFO  ] Stage: Termination
[ INFO  ] Execution of setup completed successfully
```
You should be able to access oVirt's web portal at the address mentioned above. 

Notes: When you first start your machine, be sure to start the Docker container that has your database. 
After this, restart the `ovirt-engine` service using the following command:
  `systemctl restart ovirt-engine`

Do use the image pulled from registry.centos.org/centos/postgres:latest. 
The one provided by PostgreSQL is difficult to configure since it seems intended to use as is. Your mileage on this may vary. 
The 404 error that appears initially should disappear and you should get the web login page for oVirt, after a few seconds or so.
