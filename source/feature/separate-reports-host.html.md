---
title: Separate-Reports-Host
category: feature
authors: didi, sandrobonazzola, sradco
wiki_category: Feature|Separate Reports Host
wiki_title: Features/Separate-Reports-Host
wiki_revision_count: 20
wiki_last_updated: 2015-01-16
feature_name: Separate Reports Host
feature_modules: engine
feature_status: QE
---

# Separate Reports Host

### Summary

Allow ovirt-engine-reports to be installed and configured by engine-setup on a separate machine, without requiring ovirt-engine or DWH to be on the same host.

### Owner

*   Name: [ Didi](User:Didi)

<!-- -->

*   Email: <didi@redhat.com>

### Current status

Implemented, should be available in 3.5.

### Detailed Description

We assume that engine is already setup and running on machine A.

If dwh is already installed and setup on machine B (can be same as A), and user wants to install reports on machine C, we need access to the engine's database and to dwh's database. If on separate host, user will be prompted for them.

If dwh is to be setup on machine B and user wants to install reports on the same machine B, we already have the credentials.

If dwh and reports are to be setup together on machine B, we need to make sure that setup recognizes that somehow, so that the reports plugin has access to needed info. Perhaps we'll decide to postpone that option - if we do, user will have to first setup dwh then reports.

### Example setup

Three VMs were created with fedora 19 installed. They are named 'f19-2' (for the engine), 'f19-2-dwh' (for DWH) and 'f19-2-reports' (for Reports).

#### Engine

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

#### DWH

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

Since on the engine side we chose "automatic provisioning" of postgres, we'll have to look up the randomly-generated password in /etc/ovirt-engine/engine.conf.d/10-setup-database.conf . We also need to make sure that the host name is resolvable - in this case I simply added 'f19-2' with the engine's VM address to /etc/hosts here.

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

Was quite a snap, wasn't it?

#### Reports

The last part is a bit more complicated - setting up Reports. On the reports machine:

      [root@didi-f19-2-reports ~]# engine-setup
      [ INFO  ] Stage: Initializing
      [ INFO  ] Stage: Environment setup
                Configuration files: []
                Log file: /var/log/ovirt-engine/setup/ovirt-engine-setup-20140804123507-4dccqt.log
                Version: otopi-1.3.0_master (otopi-1.3.0-0.0.master.20140715.git336a22e.fc19)
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
                --== DATABASE CONFIGURATION ==--
                Where is the Reports database located? (Local, Remote) [Local]:
                Setup can configure the local postgresql server automatically for the Reports to run. This may conflict with existing applications.
                Would you like Setup to automatically configure postgresql and create Reports database, or prefer to perform that manually? (Automatic, Manual) [Automatic]:

Similarly to DWH above, we have to provide both engine and DWH db credentials. We can see all of them in the DWH machine in /etc/ovirt-engine-dwh/ovirt-engine-dwhd.conf.d/10-setup-database.conf .

                Engine database host []: f19-2
                Engine database port [5432]:
                Engine database secured connection (Yes, No) [No]:
                Engine database name [engine]:
                Engine database user [engine]:
                Engine database password:
                DWH database host []: f19-2-dwh
                DWH database port [5432]:
                DWH database secured connection (Yes, No) [No]:
                DWH database name [ovirt_engine_history]:
                DWH database user [ovirt_engine_history]:
                DWH database password:
                --== OVIRT ENGINE CONFIGURATION ==--
                --== PKI CONFIGURATION ==--
                --== APACHE CONFIGURATION ==--
                Setup can configure apache to use SSL using a certificate issued from the internal CA.
                Do you wish Setup to configure that, or prefer to perform that manually? (Automatic, Manual) [Automatic]:
                --== SYSTEM CONFIGURATION ==--
                --== MISC CONFIGURATION ==--
                Reports power users password:
                Confirm Reports power users password:
                --== END OF CONFIGURATION ==--

Last part of the interaction is about pki:

*   For this feature we separated the engine web application and the Reports one to two independent jboss instances, each with its own pki.
*   engine plugin of setup always generates pki for the reports jboss instance.
*   If this is not found during reports plugin setup (as is the case here), we are asked about it.
*   For apache - if running on the engine machine, we use the same instance, and just add a bit of configuration to point at the new reports jboss instance. If we do not find pki for apache, which is the case here, we ask for it.
*   Note that as of writing this, the only way to do this interaction is by copying/pasting requests/certificates data. We intend to allow also doing this by copying files around, which is required if your consoles do not support copy/paste (e.g. if you use spice console and not ssh from a terminal application).
*   Also note that all of this interaction happens only if the key and cert files are not found. This means that on upgrade we (obviously) do not need to repeat this, and also that it's possible to do this beforehand - to manually generate keys, sign them with a CA and put in the expected locations.

First we are asked about pki for apache:

                Please issue Reports certificate based on this certificate request
      D:MULTI-STRING REPORTS_APACHE_CERTIFICATE_REQUEST --=451b80dc-996f-432e-9e4f-2b29ef6d1141=--
      -----BEGIN CERTIFICATE REQUEST-----
      MIICRDCCASwCADAAMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAsTUl
      gXeWaft2XK0Zwy6jwAIY/9KwMONwaFWSs3WjaKt/xOTUWZf8RGIpSnCBDlOwgwJt
      0VnR7gBnOgllU4ZvIEVsCOnmAfswNgjouEWvQ2ECRZdcTYDZX3QTou0Wq5JYnqZd
      CZz9TzSwu5saj0Htfcrt+HeqhWnKxIaXxmllPGlzKzGtclEs88Oxw38Tuf0GC8Km
      NPKKNOdraTuBiUqOCADkMJasTDuZGi+0HEZ+V3xal2/3YkIXe7lmNUArMhSKKT3K
      23Pi3mhvnmc+nS5/zFVc8rFEXRl4fl2fl6bwdKoVub4WMYLfcFxbM387voSujzm1
      FF8Vn0YXM3IuSHVSEwIDAQABoAAwDQYJKoZIhvcNAQEFBQADggEBAI6Gdgd3bhGc
      pctqfGneUctfJkSHKG2R7xEl4wkKayafz802kr+zzclkJQ9hstSS+SfhN7di2HrO
      XX/F/JTuuJYAKehLALSZBt1mbR0UOaTTg3ONTIfp3O7wRWog8fYN7HzuQNvdxU2V
      mQ2Xh0yH06kE4OdstodnnRvQjyoKEKdSdzr/AP9zfjhIeK4TIMzpI2MAE6Y4Av6c
      dV/f1GOC0l1nPBAbk0WXGCXGLXI3/P8cip0xs+reeJOGuyJFHhcaCJHnY0hc3tTt
      tfPtP7o9Xdn5lzed645z3uVROqnFnPoeMIx/iGySZrhukBh+A8RLxZbdlAkjVfCd
      Kb4CHP8J22g=
      -----END CERTIFICATE REQUEST-----
      --=451b80dc-996f-432e-9e4f-2b29ef6d1141=--
                Please enroll SSL certificate for apache.
                It can be done using engine internal CA, if no 3rd party CA is available, with this sequence:
                1. Copy and save certificate request at
                    /etc/pki/ovirt-engine/requests/apache-reports.req
                on the engine host
                2. execute, on the engine host, this command to enroll the cert:
                 /usr/share/ovirt-engine/bin/pki-enroll-request.sh \
                     --name=apache-reports \
                     --subject="/C=`<country>`/O=`<organization>`/CN=didi-f19-2-reports.ci.lab.tlv.redhat.com"
                Substitute `<country>`, `<organization>` to suite your environment
                (i.e. the values must match values in the certificate authority of your engine)
                3. Certificate will be available at
                    /etc/pki/ovirt-engine/certs/apache-reports.cer
                on the engine host, please copy that content here when required
                Please input Reports certificate chain that matches certificate request, (issuer is not mandatory, from intermediate and upper)
                type '--=451b80dc-996f-432e-9e4f-2b29ef6d1141=--' in own line to mark end.

Now we go back to the engine VM, and there do:

      [root@didi-f19-2 ~]# cat > /etc/pki/ovirt-engine/requests/apache-reports.req
      -----BEGIN CERTIFICATE REQUEST-----
      MIICRDCCASwCADAAMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAsTUl
      gXeWaft2XK0Zwy6jwAIY/9KwMONwaFWSs3WjaKt/xOTUWZf8RGIpSnCBDlOwgwJt
      0VnR7gBnOgllU4ZvIEVsCOnmAfswNgjouEWvQ2ECRZdcTYDZX3QTou0Wq5JYnqZd
      CZz9TzSwu5saj0Htfcrt+HeqhWnKxIaXxmllPGlzKzGtclEs88Oxw38Tuf0GC8Km
      NPKKNOdraTuBiUqOCADkMJasTDuZGi+0HEZ+V3xal2/3YkIXe7lmNUArMhSKKT3K
      23Pi3mhvnmc+nS5/zFVc8rFEXRl4fl2fl6bwdKoVub4WMYLfcFxbM387voSujzm1
      FF8Vn0YXM3IuSHVSEwIDAQABoAAwDQYJKoZIhvcNAQEFBQADggEBAI6Gdgd3bhGc
      pctqfGneUctfJkSHKG2R7xEl4wkKayafz802kr+zzclkJQ9hstSS+SfhN7di2HrO
      XX/F/JTuuJYAKehLALSZBt1mbR0UOaTTg3ONTIfp3O7wRWog8fYN7HzuQNvdxU2V
      mQ2Xh0yH06kE4OdstodnnRvQjyoKEKdSdzr/AP9zfjhIeK4TIMzpI2MAE6Y4Av6c
      dV/f1GOC0l1nPBAbk0WXGCXGLXI3/P8cip0xs+reeJOGuyJFHhcaCJHnY0hc3tTt
      tfPtP7o9Xdn5lzed645z3uVROqnFnPoeMIx/iGySZrhukBh+A8RLxZbdlAkjVfCd
      Kb4CHP8J22g=
      -----END CERTIFICATE REQUEST-----

We also need to know the Country and Organization used for the CA:

      [root@didi-f19-2 ~]# openssl x509 -in /etc/pki/ovirt-engine/certs/ca.der -noout -subject
      subject= /C=US/O=ci.lab.tlv.redhat.com/CN=didi-f19-2.ci.lab.tlv.redhat.com.46532

Now we can sign and generate a certificate:

      [root@didi-f19-2 ~]# /usr/share/ovirt-engine/bin/pki-enroll-request.sh --name=apache-reports --subject="/C=US/O=ci.lab.tlv.redhat.com/CN=didi-f19-2-reports.ci.lab.tlv.redhat.com"
      Using configuration from openssl.conf
      Check that the request matches the signature
      Signature ok
      The Subject's Distinguished Name is as follows
      countryName           :PRINTABLE:'US'
      organizationName      :PRINTABLE:'ci.lab.tlv.redhat.com'
      commonName            :PRINTABLE:'didi-f19-2-reports.ci.lab.tlv.redhat.com'
      Certificate is to be certified until Jul  9 09:36:30 2019 GMT (1800 days)
      Write out database with 1 new entries
      Data Base Updated
      [root@didi-f19-2 ~]# cat /etc/pki/ovirt-engine/certs/apache-reports.cer
      Certificate:
          Data:
              Version: 3 (0x2)
              Serial Number: 4102 (0x1006)
          Signature Algorithm: sha1WithRSAEncryption
              Issuer: C=US, O=ci.lab.tlv.redhat.com, CN=didi-f19-2.ci.lab.tlv.redhat.com.12011
              Validity
                  Not Before: Aug  3 09:36:30 2014
                  Not After : Jul  9 09:36:30 2019 GMT
              Subject: C=US, O=ci.lab.tlv.redhat.com, CN=didi-f19-2-reports.ci.lab.tlv.redhat.com
              Subject Public Key Info:
                  Public Key Algorithm: rsaEncryption
                      Public-Key: (2048 bit)
                      Modulus:
                          00:b1:35:25:81:77:96:69:fb:76:5c:ad:19:c3:2e:
                          a3:c0:02:18:ff:d2:b0:30:e3:70:68:55:92:b3:75:
                          a3:68:ab:7f:c4:e4:d4:59:97:fc:44:62:29:4a:70:
                          81:0e:53:b0:83:02:6d:d1:59:d1:ee:00:67:3a:09:
                          65:53:86:6f:20:45:6c:08:e9:e6:01:fb:30:36:08:
                          e8:b8:45:af:43:61:02:45:97:5c:4d:80:d9:5f:74:
                          13:a2:ed:16:ab:92:58:9e:a6:5d:09:9c:fd:4f:34:
                          b0:bb:9b:1a:8f:41:ed:7d:ca:ed:f8:77:aa:85:69:
                          ca:c4:86:97:c6:69:65:3c:69:73:2b:31:ad:72:51:
                          2c:f3:c3:b1:c3:7f:13:b9:fd:06:0b:c2:a6:34:f2:
                          8a:34:e7:6b:69:3b:81:89:4a:8e:08:00:e4:30:96:
                          ac:4c:3b:99:1a:2f:b4:1c:46:7e:57:7c:5a:97:6f:
                          f7:62:42:17:7b:b9:66:35:40:2b:32:14:8a:29:3d:
                          ca:db:73:e2:de:68:6f:9e:67:3e:9d:2e:7f:cc:55:
                          5c:f2:b1:44:5d:19:78:7e:5d:9f:97:a6:f0:74:aa:
                          15:b9:be:16:31:82:df:70:5c:5b:33:7f:3b:be:84:
                          ae:8f:39:b5:14:5f:15:9f:46:17:33:72:2e:48:75:
                          52:13
                      Exponent: 65537 (0x10001)
              X509v3 extensions:
                  X509v3 Subject Key Identifier:
                      5E:8D:06:F1:24:D2:47:D6:99:C6:2B:C1:D5:35:7C:07:3D:7A:D7:3D
                  Authority Information Access:
`                CA Issuers - URI:`[`http://didi-f19-2.ci.lab.tlv.redhat.com:80/ovirt-engine/services/pki-resource?resource=ca-certificate&format=X509-PEM-CA`](http://didi-f19-2.ci.lab.tlv.redhat.com:80/ovirt-engine/services/pki-resource?resource=ca-certificate&format=X509-PEM-CA)
                  X509v3 Authority Key Identifier:
                      keyid:D3:77:D1:AA:82:18:2E:FF:43:5B:F2:50:6E:A0:A5:CA:15:78:A8:C8
                      DirName:/C=US/O=ci.lab.tlv.redhat.com/CN=didi-f19-2.ci.lab.tlv.redhat.com.12011
                      serial:10:00
                  X509v3 Basic Constraints:
                      CA:FALSE
                  X509v3 Key Usage: critical
                      Digital Signature, Key Encipherment
                  X509v3 Extended Key Usage: critical
                      TLS Web Server Authentication, TLS Web Client Authentication
          Signature Algorithm: sha1WithRSAEncryption
               43:e4:f7:bf:b2:87:0a:0d:cb:ce:f5:3e:9d:8b:a8:e7:63:8a:
               cf:19:f2:71:05:92:ca:b4:da:46:86:8b:1c:39:a9:b7:9a:d7:
               db:6a:2c:9f:1c:ba:59:0a:d8:bc:21:1b:b9:ab:e2:3b:6f:64:
               b1:4e:81:40:e6:fc:75:02:d1:9d:66:1e:23:58:ec:0e:f9:fc:
               3b:3f:c4:a1:58:5b:c1:71:e0:c3:53:d1:4c:79:1a:50:a4:7b:
               10:21:b7:01:4c:ae:a7:40:fc:1d:7a:49:df:4e:45:ca:21:2d:
               a8:ec:ee:11:67:0a:03:d9:a1:77:6f:18:aa:a1:fa:6c:8b:af:
               08:b0:f1:ce:61:c7:19:0a:be:cb:4d:74:f1:88:ae:f8:d6:01:
               42:48:7b:6d:d1:ba:ab:4d:40:2d:cf:61:fc:04:51:df:b8:3d:
               e0:3d:75:b8:f6:74:10:4e:dd:9c:65:6c:de:da:2e:8a:98:4f:
               f4:38:3e:4a:de:99:d0:ac:f6:28:a6:8e:b0:da:00:66:6a:98:
               27:cb:14:2e:93:50:6d:06:62:7c:85:13:67:f9:ef:9e:e0:a5:
               b4:52:1c:d1:2c:f8:40:9a:16:44:85:2b:e3:45:ae:de:62:b3:
               f5:82:5c:3b:fd:e9:a4:e7:ae:86:9e:c7:29:91:b0:c6:19:50:
               71:7e:5c:6d 
      -----BEGIN CERTIFICATE-----
      MIIExTCCA62gAwIBAgICEAYwDQYJKoZIhvcNAQEFBQAwXjELMAkGA1UEBhMCVVMx
      HjAcBgNVBAoTFWNpLmxhYi50bHYucmVkaGF0LmNvbTEvMC0GA1UEAxMmZGlkaS1m
      MTktMi5jaS5sYWIudGx2LnJlZGhhdC5jb20uMTIwMTEwIhcRMTQwODAzMDkzNjMw
      KzAwMDAXDTE5MDcwOTA5MzYzMFowYDELMAkGA1UEBhMCVVMxHjAcBgNVBAoTFWNp
      LmxhYi50bHYucmVkaGF0LmNvbTExMC8GA1UEAxMoZGlkaS1mMTktMi1yZXBvcnRz
      LmNpLmxhYi50bHYucmVkaGF0LmNvbTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCC
      AQoCggEBALE1JYF3lmn7dlytGcMuo8ACGP/SsDDjcGhVkrN1o2irf8Tk1FmX/ERi
      KUpwgQ5TsIMCbdFZ0e4AZzoJZVOGbyBFbAjp5gH7MDYI6LhFr0NhAkWXXE2A2V90
      E6LtFquSWJ6mXQmc/U80sLubGo9B7X3K7fh3qoVpysSGl8ZpZTxpcysxrXJRLPPD
      scN/E7n9BgvCpjTyijTna2k7gYlKjggA5DCWrEw7mRovtBxGfld8Wpdv92JCF3u5
      ZjVAKzIUiik9yttz4t5ob55nPp0uf8xVXPKxRF0ZeH5dn5em8HSqFbm+FjGC33Bc
      WzN/O76Ero85tRRfFZ9GFzNyLkh1UhMCAwEAAaOCAYUwggGBMB0GA1UdDgQWBBRe
      jQbxJNJH1pnGK8HVNXwHPXrXPTCBlwYIKwYBBQUHAQEEgYowgYcwgYQGCCsGAQUF
      BzAChnhodHRwOi8vZGlkaS1mMTktMi5jaS5sYWIudGx2LnJlZGhhdC5jb206ODAv
      b3ZpcnQtZW5naW5lL3NlcnZpY2VzL3BraS1yZXNvdXJjZT9yZXNvdXJjZT1jYS1j
      ZXJ0aWZpY2F0ZSZmb3JtYXQ9WDUwOS1QRU0tQ0EwgYgGA1UdIwSBgDB+gBTTd9Gq
      ghgu/0Nb8lBuoKXKFXioyKFipGAwXjELMAkGA1UEBhMCVVMxHjAcBgNVBAoTFWNp
      LmxhYi50bHYucmVkaGF0LmNvbTEvMC0GA1UEAxMmZGlkaS1mMTktMi5jaS5sYWIu
      dGx2LnJlZGhhdC5jb20uMTIwMTGCAhAAMAkGA1UdEwQCMAAwDgYDVR0PAQH/BAQD
      AgWgMCAGA1UdJQEB/wQWMBQGCCsGAQUFBwMBBggrBgEFBQcDAjANBgkqhkiG9w0B
      AQUFAAOCAQEAQ+T3v7KHCg3LzvU+nYuo52OKzxnycQWSyrTaRoaLHDmpt5rX22os
      nxy6WQrYvCEbuaviO29ksU6BQOb8dQLRnWYeI1jsDvn8Oz/EoVhbwXHgw1PRTHka
      UKR7ECG3AUyup0D8HXpJ305FyiEtqOzuEWcKA9mhd28YqqH6bIuvCLDxzmHHGQq+
      y0108Yiu+NYBQkh7bdG6q01ALc9h/ARR37g94D11uPZ0EE7dnGVs3touiphP9Dg+
      St6Z0Kz2KKaOsNoAZmqYJ8sULpNQbQZifIUTZ/nvnuCltFIc0Sz4QJoWRIUr40Wu
      3mKz9YJcO/3ppOeuhp7HKZGwxhlQcX5cbQ==
      -----END CERTIFICATE-----
      [root@didi-f19-2 ~]# 

And now we go back to the reports VM and copy/paste this certificate. Note that it's enough to copy/paste the part between 'BEGIN/END CERTIFICATE' markers.

                type '--=451b80dc-996f-432e-9e4f-2b29ef6d1141=--' in own line to mark end.
      -----BEGIN CERTIFICATE-----
      MIIExTCCA62gAwIBAgICEAYwDQYJKoZIhvcNAQEFBQAwXjELMAkGA1UEBhMCVVMx
      HjAcBgNVBAoTFWNpLmxhYi50bHYucmVkaGF0LmNvbTEvMC0GA1UEAxMmZGlkaS1m
      MTktMi5jaS5sYWIudGx2LnJlZGhhdC5jb20uMTIwMTEwIhcRMTQwODAzMDkzNjMw
      KzAwMDAXDTE5MDcwOTA5MzYzMFowYDELMAkGA1UEBhMCVVMxHjAcBgNVBAoTFWNp
      LmxhYi50bHYucmVkaGF0LmNvbTExMC8GA1UEAxMoZGlkaS1mMTktMi1yZXBvcnRz
      LmNpLmxhYi50bHYucmVkaGF0LmNvbTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCC
      AQoCggEBALE1JYF3lmn7dlytGcMuo8ACGP/SsDDjcGhVkrN1o2irf8Tk1FmX/ERi
      KUpwgQ5TsIMCbdFZ0e4AZzoJZVOGbyBFbAjp5gH7MDYI6LhFr0NhAkWXXE2A2V90
      E6LtFquSWJ6mXQmc/U80sLubGo9B7X3K7fh3qoVpysSGl8ZpZTxpcysxrXJRLPPD
      scN/E7n9BgvCpjTyijTna2k7gYlKjggA5DCWrEw7mRovtBxGfld8Wpdv92JCF3u5
      ZjVAKzIUiik9yttz4t5ob55nPp0uf8xVXPKxRF0ZeH5dn5em8HSqFbm+FjGC33Bc
      WzN/O76Ero85tRRfFZ9GFzNyLkh1UhMCAwEAAaOCAYUwggGBMB0GA1UdDgQWBBRe
      jQbxJNJH1pnGK8HVNXwHPXrXPTCBlwYIKwYBBQUHAQEEgYowgYcwgYQGCCsGAQUF
      BzAChnhodHRwOi8vZGlkaS1mMTktMi5jaS5sYWIudGx2LnJlZGhhdC5jb206ODAv
      b3ZpcnQtZW5naW5lL3NlcnZpY2VzL3BraS1yZXNvdXJjZT9yZXNvdXJjZT1jYS1j
      ZXJ0aWZpY2F0ZSZmb3JtYXQ9WDUwOS1QRU0tQ0EwgYgGA1UdIwSBgDB+gBTTd9Gq
      ghgu/0Nb8lBuoKXKFXioyKFipGAwXjELMAkGA1UEBhMCVVMxHjAcBgNVBAoTFWNp
      LmxhYi50bHYucmVkaGF0LmNvbTEvMC0GA1UEAxMmZGlkaS1mMTktMi5jaS5sYWIu
      dGx2LnJlZGhhdC5jb20uMTIwMTGCAhAAMAkGA1UdEwQCMAAwDgYDVR0PAQH/BAQD
      AgWgMCAGA1UdJQEB/wQWMBQGCCsGAQUFBwMBBggrBgEFBQcDAjANBgkqhkiG9w0B
      AQUFAAOCAQEAQ+T3v7KHCg3LzvU+nYuo52OKzxnycQWSyrTaRoaLHDmpt5rX22os
      nxy6WQrYvCEbuaviO29ksU6BQOb8dQLRnWYeI1jsDvn8Oz/EoVhbwXHgw1PRTHka
      UKR7ECG3AUyup0D8HXpJ305FyiEtqOzuEWcKA9mhd28YqqH6bIuvCLDxzmHHGQq+
      y0108Yiu+NYBQkh7bdG6q01ALc9h/ARR37g94D11uPZ0EE7dnGVs3touiphP9Dg+
      St6Z0Kz2KKaOsNoAZmqYJ8sULpNQbQZifIUTZ/nvnuCltFIc0Sz4QJoWRIUr40Wu
      3mKz9YJcO/3ppOeuhp7HKZGwxhlQcX5cbQ==
      -----END CERTIFICATE-----
      --=451b80dc-996f-432e-9e4f-2b29ef6d1141=--

Now we are asked about apache.

                Please provide PEM-encoded CA Cert bundle for apache.
                If using the engine CA, please copy and paste the contents of the file /etc/pki/ovirt-engine/apache-ca.pem on the engine host.
                type '--=451b80dc-996f-432e-9e4f-2b29ef6d1141=--' in own line to mark end.

We go back to the engine VM to get the ca cert:

      [root@didi-f19-2 ~]# cat /etc/pki/ovirt-engine/apache-ca.pem
      Certificate:
          Data:
              Version: 3 (0x2)
              Serial Number: 4096 (0x1000)
          Signature Algorithm: sha1WithRSAEncryption
              Issuer: C=US, O=ci.lab.tlv.redhat.com, CN=didi-f19-2.ci.lab.tlv.redhat.com.12011
              Validity
                  Not Before: Aug  3 09:05:58 2014
                  Not After : Aug  1 09:05:58 2024 GMT
              Subject: C=US, O=ci.lab.tlv.redhat.com, CN=didi-f19-2.ci.lab.tlv.redhat.com.12011
              Subject Public Key Info:
                  Public Key Algorithm: rsaEncryption
                      Public-Key: (2048 bit)
                      Modulus:
                          00:c7:74:02:53:49:7b:34:a4:56:1f:57:1b:12:8a:
                          16:97:2e:26:95:5b:58:f6:a2:97:fc:20:9f:08:9a:
                          1b:14:08:c7:56:d3:2b:f0:5b:1b:01:2a:c5:13:22:
                          07:c7:84:5e:5d:4c:8c:2d:57:c8:d0:83:32:20:b7:
                          86:03:32:02:2a:c6:c3:a9:43:ee:d2:89:1d:b7:fc:
                          d7:c0:e7:3e:3e:b2:92:e8:db:b0:0f:40:40:08:5b:
                          c8:78:a0:78:a9:85:2f:0d:5b:7d:11:9a:c4:6a:d3:
                          1d:ff:3b:b0:e4:10:c8:b6:40:17:bc:cb:fa:8e:7b:
                          16:70:0e:7f:93:25:3b:60:89:2f:17:81:2a:4b:bf:
                          fc:f8:a8:81:0f:a2:43:09:40:2d:5a:16:44:b9:72:
                          bb:95:8d:86:de:e3:93:26:91:ed:f4:7b:cb:a0:cb:
                          4c:05:ef:64:df:57:76:54:2e:b2:2a:ce:c0:96:ea:
                          25:8d:d3:3a:3c:e3:fc:8a:36:fd:e6:d3:a1:e7:d8:
                          d4:91:e9:6b:b7:b3:fc:e7:8e:7b:ef:9f:8e:21:1b:
                          4b:9c:27:36:a2:51:5f:b4:aa:ad:14:4c:55:61:6f:
                          9b:ea:43:90:d3:ea:1d:e3:ce:b4:5c:22:e8:1c:96:
                          b1:47:ac:8f:84:c0:0b:d5:5f:cb:dd:d0:1d:1a:71:
                          53:35
                      Exponent: 65537 (0x10001)
              X509v3 extensions:
                  X509v3 Subject Key Identifier:
                      D3:77:D1:AA:82:18:2E:FF:43:5B:F2:50:6E:A0:A5:CA:15:78:A8:C8
                  X509v3 Authority Key Identifier:
                      keyid:D3:77:D1:AA:82:18:2E:FF:43:5B:F2:50:6E:A0:A5:CA:15:78:A8:C8
                      DirName:/C=US/O=ci.lab.tlv.redhat.com/CN=didi-f19-2.ci.lab.tlv.redhat.com.12011
                      serial:10:00
                  X509v3 Basic Constraints: critical
                      CA:TRUE
                  X509v3 Key Usage: critical
                      Certificate Sign, CRL Sign
          Signature Algorithm: sha1WithRSAEncryption
               c6:31:a4:cf:ef:67:c8:b7:f9:0f:c3:6e:6f:a2:66:65:5f:cc:
               94:03:e4:e3:44:f8:7e:3f:51:40:29:c2:f7:12:b8:3d:43:7d:
               5a:8f:ed:df:9f:28:ef:8a:4b:ed:d3:c1:a1:95:c4:68:29:7f:
               8e:71:8a:32:fb:23:c4:96:f3:e9:3c:11:c0:42:5a:6b:95:c9:
               ae:c0:59:9d:ce:9c:e2:dc:61:6a:27:af:b0:2f:3e:f4:b0:2e:
               6a:e7:0a:99:48:6e:2d:3e:e3:f3:8d:c1:d4:13:1f:c1:51:b8:
               84:75:12:ca:d0:88:50:06:5c:a8:f7:8e:0a:38:46:36:29:b8:
               08:1a:30:96:40:b7:43:0a:d6:4d:e6:0f:82:3e:fc:dd:f9:e6:
               a4:59:5a:db:14:5c:81:c3:fa:ec:38:c2:b5:6f:f0:2c:c9:7a:
               f1:51:42:05:6e:4e:ec:ef:38:8b:24:e4:18:bd:ff:66:83:6a:
               31:f6:9b:42:45:de:69:b4:dc:f2:33:bb:45:5a:74:70:af:42:
               b4:9a:88:33:19:df:de:08:b2:54:c9:48:57:ad:a7:d7:4d:49:
               2c:cf:ff:fb:16:1b:09:5d:aa:bd:a2:b3:c6:b0:cb:86:d0:26:
               a2:75:d1:8c:2e:26:08:d2:45:0b:b1:eb:ca:f6:35:93:38:50:
               8d:c5:5b:da 
      -----BEGIN CERTIFICATE-----
      MIIECzCCAvOgAwIBAgICEAAwDQYJKoZIhvcNAQEFBQAwXjELMAkGA1UEBhMCVVMx
      HjAcBgNVBAoTFWNpLmxhYi50bHYucmVkaGF0LmNvbTEvMC0GA1UEAxMmZGlkaS1m
      MTktMi5jaS5sYWIudGx2LnJlZGhhdC5jb20uMTIwMTEwIhcRMTQwODAzMDkwNTU4
      KzAwMDAXDTI0MDgwMTA5MDU1OFowXjELMAkGA1UEBhMCVVMxHjAcBgNVBAoTFWNp
      LmxhYi50bHYucmVkaGF0LmNvbTEvMC0GA1UEAxMmZGlkaS1mMTktMi5jaS5sYWIu
      dGx2LnJlZGhhdC5jb20uMTIwMTEwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEK
      AoIBAQDHdAJTSXs0pFYfVxsSihaXLiaVW1j2opf8IJ8ImhsUCMdW0yvwWxsBKsUT
      IgfHhF5dTIwtV8jQgzIgt4YDMgIqxsOpQ+7SiR23/NfA5z4+spLo27APQEAIW8h4
      oHiphS8NW30RmsRq0x3/O7DkEMi2QBe8y/qOexZwDn+TJTtgiS8XgSpLv/z4qIEP
      okMJQC1aFkS5cruVjYbe45Mmke30e8ugy0wF72TfV3ZULrIqzsCW6iWN0zo84/yK
      Nv3m06Hn2NSR6Wu3s/znjnvvn44hG0ucJzaiUV+0qq0UTFVhb5vqQ5DT6h3jzrRc
      IugclrFHrI+EwAvVX8vd0B0acVM1AgMBAAGjgc4wgcswHQYDVR0OBBYEFNN30aqC
      GC7/Q1vyUG6gpcoVeKjIMIGIBgNVHSMEgYAwfoAU03fRqoIYLv9DW/JQbqClyhV4
      qMihYqRgMF4xCzAJBgNVBAYTAlVTMR4wHAYDVQQKExVjaS5sYWIudGx2LnJlZGhh
      dC5jb20xLzAtBgNVBAMTJmRpZGktZjE5LTIuY2kubGFiLnRsdi5yZWRoYXQuY29t
      LjEyMDExggIQADAPBgNVHRMBAf8EBTADAQH/MA4GA1UdDwEB/wQEAwIBBjANBgkq
      hkiG9w0BAQUFAAOCAQEAxjGkz+9nyLf5D8Nub6JmZV/MlAPk40T4fj9RQCnC9xK4
      PUN9Wo/t358o74pL7dPBoZXEaCl/jnGKMvsjxJbz6TwRwEJaa5XJrsBZnc6c4txh
      aievsC8+9LAuaucKmUhuLT7j843B1BMfwVG4hHUSytCIUAZcqPeOCjhGNim4CBow
      lkC3QwrWTeYPgj783fnmpFla2xRcgcP67DjCtW/wLMl68VFCBW5O7O84iyTkGL3/
      ZoNqMfabQkXeabTc8jO7RVp0cK9CtJqIMxnf3giyVMlIV62n101JLM//+xYbCV2q
      vaKzxrDLhtAmonXRjC4mCNJFC7HryvY1kzhQjcVb2g==
      -----END CERTIFICATE-----
      [root@didi-f19-2 ~]# 

Then go back to the Reports machine and copy/paste. Again, the part between 'BEGIN/END CERTIFICATE' markers is enough:

                type '--=451b80dc-996f-432e-9e4f-2b29ef6d1141=--' in own line to mark end.
      -----BEGIN CERTIFICATE-----  
      MIIECzCCAvOgAwIBAgICEAAwDQYJKoZIhvcNAQEFBQAwXjELMAkGA1UEBhMCVVMx
      HjAcBgNVBAoTFWNpLmxhYi50bHYucmVkaGF0LmNvbTEvMC0GA1UEAxMmZGlkaS1m
      MTktMi5jaS5sYWIudGx2LnJlZGhhdC5jb20uMTIwMTEwIhcRMTQwODAzMDkwNTU4
      KzAwMDAXDTI0MDgwMTA5MDU1OFowXjELMAkGA1UEBhMCVVMxHjAcBgNVBAoTFWNp
      LmxhYi50bHYucmVkaGF0LmNvbTEvMC0GA1UEAxMmZGlkaS1mMTktMi5jaS5sYWIu
      dGx2LnJlZGhhdC5jb20uMTIwMTEwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEK
      AoIBAQDHdAJTSXs0pFYfVxsSihaXLiaVW1j2opf8IJ8ImhsUCMdW0yvwWxsBKsUT
      IgfHhF5dTIwtV8jQgzIgt4YDMgIqxsOpQ+7SiR23/NfA5z4+spLo27APQEAIW8h4
      oHiphS8NW30RmsRq0x3/O7DkEMi2QBe8y/qOexZwDn+TJTtgiS8XgSpLv/z4qIEP
      okMJQC1aFkS5cruVjYbe45Mmke30e8ugy0wF72TfV3ZULrIqzsCW6iWN0zo84/yK
      Nv3m06Hn2NSR6Wu3s/znjnvvn44hG0ucJzaiUV+0qq0UTFVhb5vqQ5DT6h3jzrRc
      IugclrFHrI+EwAvVX8vd0B0acVM1AgMBAAGjgc4wgcswHQYDVR0OBBYEFNN30aqC
      GC7/Q1vyUG6gpcoVeKjIMIGIBgNVHSMEgYAwfoAU03fRqoIYLv9DW/JQbqClyhV4
      qMihYqRgMF4xCzAJBgNVBAYTAlVTMR4wHAYDVQQKExVjaS5sYWIudGx2LnJlZGhh
      dC5jb20xLzAtBgNVBAMTJmRpZGktZjE5LTIuY2kubGFiLnRsdi5yZWRoYXQuY29t
      LjEyMDExggIQADAPBgNVHRMBAf8EBTADAQH/MA4GA1UdDwEB/wQEAwIBBjANBgkq
      hkiG9w0BAQUFAAOCAQEAxjGkz+9nyLf5D8Nub6JmZV/MlAPk40T4fj9RQCnC9xK4
      PUN9Wo/t358o74pL7dPBoZXEaCl/jnGKMvsjxJbz6TwRwEJaa5XJrsBZnc6c4txh
      aievsC8+9LAuaucKmUhuLT7j843B1BMfwVG4hHUSytCIUAZcqPeOCjhGNim4CBow
      lkC3QwrWTeYPgj783fnmpFla2xRcgcP67DjCtW/wLMl68VFCBW5O7O84iyTkGL3/
      ZoNqMfabQkXeabTc8jO7RVp0cK9CtJqIMxnf3giyVMlIV62n101JLM//+xYbCV2q
      vaKzxrDLhtAmonXRjC4mCNJFC7HryvY1kzhQjcVb2g==
      -----END CERTIFICATE-----
      --=451b80dc-996f-432e-9e4f-2b29ef6d1141=--

Then we are asked about pki for the Reports jboss instance.

                Please issue Reports certificate based on this certificate request
      D:MULTI-STRING REPORTS_JBOSS_CERTIFICATE_REQUEST --=451b80dc-996f-432e-9e4f-2b29ef6d1141=--
      -----BEGIN CERTIFICATE REQUEST-----
      MIICRDCCASwCADAAMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAt2xL
      Cn3cyr8ZyA0XuepG2YhEnoG2tK/RiriwIF+ivW4rKutoMo8ejtusYLL8oDX568+a
      L7hN020uvk9Blj3/Y/QB2QTvOoSb9OnoYAezc9hpPH1DEJrT8L6XdIKTU7FFgPZn
      sucTDa/1SGrxMVaQ5ZDsjRL4IfBgu2VKU5sAsFzSiAhbupcwaDfNi3I94c178JFp
      PEAsWPdbNHvKWWEyycovCVW0vd6FNlng2CckYMMKxJUGwe4xb1zWaYjL/ijl2c/u
      gCrhnpxO2zI/V2vN62lpCRszXvli2FkNsOhnFWHwHo3aCKQgCGZLtEN9h6fxVOpt
      cfnq4cNZZga9BmDvVQIDAQABoAAwDQYJKoZIhvcNAQEFBQADggEBAEsEXPtdEnDa
      2I+0OBkSQfipgtD8a8Wg6jBS84g/LmCOorF2CaL3HOhwK+Vhmqgfh6C8918DWqUa
      3fYGpcDL3SQN/FRD0B5NYrzkXOOJVZAY+JtzrqRODamut35QO+/6RO6w7HzCxZZt
      jXmbsE+s8UWJE3c4ygehxfiMUBbp4im1PmY27Mhi9wdASEBfeHxWt1YospA+Lcul
      5dI6H3EDVHBfjXMN2CEoZQ6/S0T/p8NqEha7WgCqw9hdf6PV/HICxZxISqJL6Cpc
      MTfaIv2//7WqsLjsO5jyFds97sKzT5YrwVpFE6CLTdfaaUWVVA9zfs1tOLNBqenX
      5e1iOW9B4TM=
      -----END CERTIFICATE REQUEST-----
      --=451b80dc-996f-432e-9e4f-2b29ef6d1141=--
                Enroll SSL certificate for the Reports service.
                It can be done using engine internal CA, if no 3rd party CA is available, with this sequence:
                1. Copy and save certificate request at
                    /etc/pki/ovirt-engine/requests/reports.req
                on the engine server
                2. execute, on the engine host, this command to enroll the cert:
                 /usr/share/ovirt-engine/bin/pki-enroll-request.sh \
                     --name=reports \
                     --subject="/C=`<country>`/O=`<organization>`/CN=didi-f19-2-reports.ci.lab.tlv.redhat.com"
                Substitute `<country>`, `<organization>` to suite your environment
                (i.e. the values must match values in the certificate authority of your engine)
                3. Certificate will be available at
                    /etc/pki/ovirt-engine/certs/reports.cer
                on the engine host, please copy that content here when required
                Please input Reports certificate chain that matches certificate request, (issuer is not mandatory, from intermediate and upper)
                type '--=451b80dc-996f-432e-9e4f-2b29ef6d1141=--' in own line to mark end.

Similarly to apache above, we copy/paste this to the engine VM, sign, and copy/paste back the cert here.

On engine machine:

      [root@didi-f19-2 ~]# cat > /etc/pki/ovirt-engine/requests/reports.req
      -----BEGIN CERTIFICATE REQUEST-----
      MIICRDCCASwCADAAMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAt2xL
      Cn3cyr8ZyA0XuepG2YhEnoG2tK/RiriwIF+ivW4rKutoMo8ejtusYLL8oDX568+a
      L7hN020uvk9Blj3/Y/QB2QTvOoSb9OnoYAezc9hpPH1DEJrT8L6XdIKTU7FFgPZn
      sucTDa/1SGrxMVaQ5ZDsjRL4IfBgu2VKU5sAsFzSiAhbupcwaDfNi3I94c178JFp
      PEAsWPdbNHvKWWEyycovCVW0vd6FNlng2CckYMMKxJUGwe4xb1zWaYjL/ijl2c/u
      gCrhnpxO2zI/V2vN62lpCRszXvli2FkNsOhnFWHwHo3aCKQgCGZLtEN9h6fxVOpt
      cfnq4cNZZga9BmDvVQIDAQABoAAwDQYJKoZIhvcNAQEFBQADggEBAEsEXPtdEnDa
      2I+0OBkSQfipgtD8a8Wg6jBS84g/LmCOorF2CaL3HOhwK+Vhmqgfh6C8918DWqUa
      3fYGpcDL3SQN/FRD0B5NYrzkXOOJVZAY+JtzrqRODamut35QO+/6RO6w7HzCxZZt
      jXmbsE+s8UWJE3c4ygehxfiMUBbp4im1PmY27Mhi9wdASEBfeHxWt1YospA+Lcul
      5dI6H3EDVHBfjXMN2CEoZQ6/S0T/p8NqEha7WgCqw9hdf6PV/HICxZxISqJL6Cpc
      MTfaIv2//7WqsLjsO5jyFds97sKzT5YrwVpFE6CLTdfaaUWVVA9zfs1tOLNBqenX
      5e1iOW9B4TM=
      -----END CERTIFICATE REQUEST-----
      [root@didi-f19-2 ~]# /usr/share/ovirt-engine/bin/pki-enroll-request.sh --name=reports --subject="/C=US/O=ci.lab.tlv.redhat.com/CN=didi-f19-2-reports.ci.lab.tlv.redhat.com"
      Using configuration from openssl.conf
      Check that the request matches the signature
      Signature ok
      The Subject's Distinguished Name is as follows
      countryName           :PRINTABLE:'US'
      organizationName      :PRINTABLE:'ci.lab.tlv.redhat.com'
      commonName            :PRINTABLE:'didi-f19-2-reports.ci.lab.tlv.redhat.com'
      Certificate is to be certified until Jul  9 09:37:49 2019 GMT (1800 days)
      Write out database with 1 new entries
      Data Base Updated
      [root@didi-f19-2 ~]# cat /etc/pki/ovirt-engine/certs/reports.cer
      Certificate:
          Data:
              Version: 3 (0x2)
              Serial Number: 4103 (0x1007)
          Signature Algorithm: sha1WithRSAEncryption
              Issuer: C=US, O=ci.lab.tlv.redhat.com, CN=didi-f19-2.ci.lab.tlv.redhat.com.12011
              Validity
                  Not Before: Aug  3 09:37:49 2014
                  Not After : Jul  9 09:37:49 2019 GMT
              Subject: C=US, O=ci.lab.tlv.redhat.com, CN=didi-f19-2-reports.ci.lab.tlv.redhat.com
              Subject Public Key Info:
                  Public Key Algorithm: rsaEncryption
                      Public-Key: (2048 bit)
                      Modulus:
                          00:b7:6c:4b:0a:7d:dc:ca:bf:19:c8:0d:17:b9:ea:
                          46:d9:88:44:9e:81:b6:b4:af:d1:8a:b8:b0:20:5f:
                          a2:bd:6e:2b:2a:eb:68:32:8f:1e:8e:db:ac:60:b2:
                          fc:a0:35:f9:eb:cf:9a:2f:b8:4d:d3:6d:2e:be:4f:
                          41:96:3d:ff:63:f4:01:d9:04:ef:3a:84:9b:f4:e9:
                          e8:60:07:b3:73:d8:69:3c:7d:43:10:9a:d3:f0:be:
                          97:74:82:93:53:b1:45:80:f6:67:b2:e7:13:0d:af:
                          f5:48:6a:f1:31:56:90:e5:90:ec:8d:12:f8:21:f0:
                          60:bb:65:4a:53:9b:00:b0:5c:d2:88:08:5b:ba:97:
                          30:68:37:cd:8b:72:3d:e1:cd:7b:f0:91:69:3c:40:
                          2c:58:f7:5b:34:7b:ca:59:61:32:c9:ca:2f:09:55:
                          b4:bd:de:85:36:59:e0:d8:27:24:60:c3:0a:c4:95:
                          06:c1:ee:31:6f:5c:d6:69:88:cb:fe:28:e5:d9:cf:
                          ee:80:2a:e1:9e:9c:4e:db:32:3f:57:6b:cd:eb:69:
                          69:09:1b:33:5e:f9:62:d8:59:0d:b0:e8:67:15:61:
                          f0:1e:8d:da:08:a4:20:08:66:4b:b4:43:7d:87:a7:
                          f1:54:ea:6d:71:f9:ea:e1:c3:59:66:06:bd:06:60:
                          ef:55
                      Exponent: 65537 (0x10001)
              X509v3 extensions:
                  X509v3 Subject Key Identifier:
                      CD:81:AC:5B:A1:D7:DC:5A:22:95:7C:47:78:D9:B7:17:2E:B0:E4:53
                  Authority Information Access:
`                CA Issuers - URI:`[`http://didi-f19-2.ci.lab.tlv.redhat.com:80/ovirt-engine/services/pki-resource?resource=ca-certificate&format=X509-PEM-CA`](http://didi-f19-2.ci.lab.tlv.redhat.com:80/ovirt-engine/services/pki-resource?resource=ca-certificate&format=X509-PEM-CA)
                  X509v3 Authority Key Identifier:
                      keyid:D3:77:D1:AA:82:18:2E:FF:43:5B:F2:50:6E:A0:A5:CA:15:78:A8:C8
                      DirName:/C=US/O=ci.lab.tlv.redhat.com/CN=didi-f19-2.ci.lab.tlv.redhat.com.12011
                      serial:10:00
                  X509v3 Basic Constraints:
                      CA:FALSE
                  X509v3 Key Usage: critical
                      Digital Signature, Key Encipherment
                  X509v3 Extended Key Usage: critical
                      TLS Web Server Authentication, TLS Web Client Authentication
          Signature Algorithm: sha1WithRSAEncryption
               23:7c:f2:4c:d5:a0:6f:42:0a:06:77:2c:19:85:86:be:28:71:
               84:ae:7b:4b:f0:6e:84:14:37:3a:59:4f:d2:5f:d1:c9:58:31:
               da:3b:9b:d1:21:8e:21:33:b3:36:c2:95:e3:bd:d1:35:f9:39:
               4d:c3:c5:4e:dd:52:74:64:15:15:f5:34:a9:d8:fe:46:62:9b:
               79:3d:68:4d:3d:cb:2b:cd:ac:6a:c8:3c:30:6e:66:bb:0d:9e:
               52:95:ae:2d:7c:49:70:17:e0:6b:10:6a:1b:de:8a:e6:2c:60:
               bf:3e:13:2b:c4:6a:29:6e:e6:b6:d9:b0:6d:07:38:c8:0f:30:
               3e:95:b0:1f:a6:df:ca:66:0a:80:0b:64:d8:e7:46:79:6e:37:
               c2:b8:57:d3:d3:4b:4c:cf:41:f8:89:04:6f:51:36:47:ee:4c:
               10:6f:c5:47:ab:32:ab:a3:3e:0c:a7:cc:7c:cb:b5:6c:b8:3f:
               cb:24:66:e8:dd:7b:4f:b7:93:46:02:c7:ff:ce:04:6e:52:77:
               d4:33:63:31:1a:a6:e5:65:33:a0:ed:88:92:e1:cf:e4:6c:5e:
               97:b5:53:58:8d:87:ff:77:d0:70:92:0b:40:9e:18:68:92:e2:
               ae:32:08:99:36:96:4c:c7:11:be:eb:b5:d0:49:5c:82:84:c0:
               62:f9:0d:96 
      -----BEGIN CERTIFICATE-----
      MIIExTCCA62gAwIBAgICEAcwDQYJKoZIhvcNAQEFBQAwXjELMAkGA1UEBhMCVVMx
      HjAcBgNVBAoTFWNpLmxhYi50bHYucmVkaGF0LmNvbTEvMC0GA1UEAxMmZGlkaS1m
      MTktMi5jaS5sYWIudGx2LnJlZGhhdC5jb20uMTIwMTEwIhcRMTQwODAzMDkzNzQ5
      KzAwMDAXDTE5MDcwOTA5Mzc0OVowYDELMAkGA1UEBhMCVVMxHjAcBgNVBAoTFWNp
      LmxhYi50bHYucmVkaGF0LmNvbTExMC8GA1UEAxMoZGlkaS1mMTktMi1yZXBvcnRz
      LmNpLmxhYi50bHYucmVkaGF0LmNvbTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCC
      AQoCggEBALdsSwp93Mq/GcgNF7nqRtmIRJ6BtrSv0Yq4sCBfor1uKyrraDKPHo7b
      rGCy/KA1+evPmi+4TdNtLr5PQZY9/2P0AdkE7zqEm/Tp6GAHs3PYaTx9QxCa0/C+
      l3SCk1OxRYD2Z7LnEw2v9Uhq8TFWkOWQ7I0S+CHwYLtlSlObALBc0ogIW7qXMGg3
      zYtyPeHNe/CRaTxALFj3WzR7yllhMsnKLwlVtL3ehTZZ4NgnJGDDCsSVBsHuMW9c
      1mmIy/4o5dnP7oAq4Z6cTtsyP1drzetpaQkbM175YthZDbDoZxVh8B6N2gikIAhm
      S7RDfYen8VTqbXH56uHDWWYGvQZg71UCAwEAAaOCAYUwggGBMB0GA1UdDgQWBBTN
      gaxbodfcWiKVfEd42bcXLrDkUzCBlwYIKwYBBQUHAQEEgYowgYcwgYQGCCsGAQUF
      BzAChnhodHRwOi8vZGlkaS1mMTktMi5jaS5sYWIudGx2LnJlZGhhdC5jb206ODAv
      b3ZpcnQtZW5naW5lL3NlcnZpY2VzL3BraS1yZXNvdXJjZT9yZXNvdXJjZT1jYS1j
      ZXJ0aWZpY2F0ZSZmb3JtYXQ9WDUwOS1QRU0tQ0EwgYgGA1UdIwSBgDB+gBTTd9Gq
      ghgu/0Nb8lBuoKXKFXioyKFipGAwXjELMAkGA1UEBhMCVVMxHjAcBgNVBAoTFWNp
      LmxhYi50bHYucmVkaGF0LmNvbTEvMC0GA1UEAxMmZGlkaS1mMTktMi5jaS5sYWIu
      dGx2LnJlZGhhdC5jb20uMTIwMTGCAhAAMAkGA1UdEwQCMAAwDgYDVR0PAQH/BAQD
      AgWgMCAGA1UdJQEB/wQWMBQGCCsGAQUFBwMBBggrBgEFBQcDAjANBgkqhkiG9w0B
      AQUFAAOCAQEAI3zyTNWgb0IKBncsGYWGvihxhK57S/BuhBQ3OllP0l/RyVgx2jub
      0SGOITOzNsKV473RNfk5TcPFTt1SdGQVFfU0qdj+RmKbeT1oTT3LK82sasg8MG5m
      uw2eUpWuLXxJcBfgaxBqG96K5ixgvz4TK8RqKW7mttmwbQc4yA8wPpWwH6bfymYK
      gAtk2OdGeW43wrhX09NLTM9B+IkEb1E2R+5MEG/FR6syq6M+DKfMfMu1bLg/yyRm
      6N17T7eTRgLH/84EblJ31DNjMRqm5WUzoO2IkuHP5Gxel7VTWI2H/3fQcJILQJ4Y
      aJLirjIImTaWTMcRvuu10ElcgoTAYvkNlg==
      -----END CERTIFICATE-----

And back on reports machine:

                type '--=451b80dc-996f-432e-9e4f-2b29ef6d1141=--' in own line to mark end.
      -----BEGIN CERTIFICATE-----
      MIIExTCCA62gAwIBAgICEAcwDQYJKoZIhvcNAQEFBQAwXjELMAkGA1UEBhMCVVMx
      HjAcBgNVBAoTFWNpLmxhYi50bHYucmVkaGF0LmNvbTEvMC0GA1UEAxMmZGlkaS1m
      MTktMi5jaS5sYWIudGx2LnJlZGhhdC5jb20uMTIwMTEwIhcRMTQwODAzMDkzNzQ5
      KzAwMDAXDTE5MDcwOTA5Mzc0OVowYDELMAkGA1UEBhMCVVMxHjAcBgNVBAoTFWNp
      LmxhYi50bHYucmVkaGF0LmNvbTExMC8GA1UEAxMoZGlkaS1mMTktMi1yZXBvcnRz
      LmNpLmxhYi50bHYucmVkaGF0LmNvbTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCC
      AQoCggEBALdsSwp93Mq/GcgNF7nqRtmIRJ6BtrSv0Yq4sCBfor1uKyrraDKPHo7b
      rGCy/KA1+evPmi+4TdNtLr5PQZY9/2P0AdkE7zqEm/Tp6GAHs3PYaTx9QxCa0/C+
      l3SCk1OxRYD2Z7LnEw2v9Uhq8TFWkOWQ7I0S+CHwYLtlSlObALBc0ogIW7qXMGg3
      zYtyPeHNe/CRaTxALFj3WzR7yllhMsnKLwlVtL3ehTZZ4NgnJGDDCsSVBsHuMW9c
      1mmIy/4o5dnP7oAq4Z6cTtsyP1drzetpaQkbM175YthZDbDoZxVh8B6N2gikIAhm
      S7RDfYen8VTqbXH56uHDWWYGvQZg71UCAwEAAaOCAYUwggGBMB0GA1UdDgQWBBTN
      gaxbodfcWiKVfEd42bcXLrDkUzCBlwYIKwYBBQUHAQEEgYowgYcwgYQGCCsGAQUF
      BzAChnhodHRwOi8vZGlkaS1mMTktMi5jaS5sYWIudGx2LnJlZGhhdC5jb206ODAv
      b3ZpcnQtZW5naW5lL3NlcnZpY2VzL3BraS1yZXNvdXJjZT9yZXNvdXJjZT1jYS1j
      ZXJ0aWZpY2F0ZSZmb3JtYXQ9WDUwOS1QRU0tQ0EwgYgGA1UdIwSBgDB+gBTTd9Gq
      ghgu/0Nb8lBuoKXKFXioyKFipGAwXjELMAkGA1UEBhMCVVMxHjAcBgNVBAoTFWNp
      LmxhYi50bHYucmVkaGF0LmNvbTEvMC0GA1UEAxMmZGlkaS1mMTktMi5jaS5sYWIu
      dGx2LnJlZGhhdC5jb20uMTIwMTGCAhAAMAkGA1UdEwQCMAAwDgYDVR0PAQH/BAQD
      AgWgMCAGA1UdJQEB/wQWMBQGCCsGAQUFBwMBBggrBgEFBQcDAjANBgkqhkiG9w0B
      AQUFAAOCAQEAI3zyTNWgb0IKBncsGYWGvihxhK57S/BuhBQ3OllP0l/RyVgx2jub
      0SGOITOzNsKV473RNfk5TcPFTt1SdGQVFfU0qdj+RmKbeT1oTT3LK82sasg8MG5m
      uw2eUpWuLXxJcBfgaxBqG96K5ixgvz4TK8RqKW7mttmwbQc4yA8wPpWwH6bfymYK
      gAtk2OdGeW43wrhX09NLTM9B+IkEb1E2R+5MEG/FR6syq6M+DKfMfMu1bLg/yyRm
      6N17T7eTRgLH/84EblJ31DNjMRqm5WUzoO2IkuHP5Gxel7VTWI2H/3fQcJILQJ4Y
      aJLirjIImTaWTMcRvuu10ElcgoTAYvkNlg==
      -----END CERTIFICATE-----
      --=451b80dc-996f-432e-9e4f-2b29ef6d1141=--

That's it...

Note that a very similar process should be followed if using any other CA.

      [ INFO  ] Stage: Setup validation
                --== CONFIGURATION PREVIEW ==--
                Update Firewall                         : True
                Host FQDN                               : didi-f19-2-reports.ci.lab.tlv.redhat.com
                Firewall manager                        : firewalld
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
                Engine database name                    : engine
                Engine database secured connection      : False
                Engine database host                    : f19-2
                Engine database user name               : engine
                Engine database host name validation    : False
                Engine database port                    : 5432
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
                To update the Reports link on the main web interface page, please restart the engine service, by running the following command on the engine host:
                # service ovirt-engine restart
                --== END OF SUMMARY ==--
      [ INFO  ] Restarting httpd
      [ INFO  ] Starting reports service
      [ INFO  ] Stage: Clean up
                Log file is located at /var/log/ovirt-engine/setup/ovirt-engine-setup-20140804123507-4dccqt.log
      [ INFO  ] Generating answer file '/var/lib/ovirt-engine/setup/answers/20140804124255-setup.conf'
      [ INFO  ] Stage: Pre-termination
      [ INFO  ] Stage: Termination
      [ INFO  ] Execution of setup completed successfully
      [root@didi-f19-2-reports ~]# 

The generated keys/certs:

      [root@didi-f19-2-reports ~]# ls -lR /etc/pki/ovirt-engine
      /etc/pki/ovirt-engine:
      total 12
      lrwxrwxrwx 1 root  root    43 Aug  4 12:42 apache-ca.pem -> /etc/pki/ovirt-engine/apache-reports-ca.pem
      -rw------- 1 ovirt ovirt 1464 Aug  4 12:42 apache-reports-ca.pem
      drwxr-xr-x 2 ovirt ovirt 4096 Aug  4 12:42 certs
      drwxr-xr-x 2 root  root  4096 Aug  4 12:42 keys
      /etc/pki/ovirt-engine/certs:
      total 8
      lrwxrwxrwx 1 root  root    46 Aug  4 12:42 apache.cer -> /etc/pki/ovirt-engine/certs/apache-reports.cer
      -rw------- 1 ovirt ovirt 1716 Aug  4 12:42 apache-reports.cer
      -rw------- 1 ovirt ovirt 1716 Aug  4 12:42 reports.cer
      /etc/pki/ovirt-engine/keys:
      total 8
      lrwxrwxrwx 1 root  root    52 Aug  4 12:42 apache.key.nopass -> /etc/pki/ovirt-engine/keys/apache-reports.key.nopass
      -rw------- 1 ovirt ovirt 1675 Aug  4 12:42 apache-reports.key.nopass
      -rw------- 1 ovirt ovirt 1675 Aug  4 12:42 reports.key.nopass
      [root@didi-f19-2-reports ~]# 

### Benefit to oVirt

Reports might cause significant load on the engine machine. Installing it on a separate machine will allow distributing the load.

Some installations might want to separate for security reasons, e.g. to give some users access only to Reports and not to the engine web admin.

### Dependencies / Related Features

### Documentation / External references

<https://bugzilla.redhat.com/1080998>

### Testing

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

### Comments and Discussion

*   Refer to <Talk:Separate-Reports-Host>

<Category:Feature> <Category:Template>
