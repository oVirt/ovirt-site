---
title: WebSocketProxy on a separate host
category: feature
authors: sandrobonazzola, stirabos
feature_name: WebSocketProxy on a separate host
feature_modules: websocket-proxy
feature_status: completed
---

# WebSocketProxy on a separate host

## Summary

The aim of this feature is to enhance the engine setup being able to install and configure the WebSocketProxy on a second machine, where engine does not run, in a fully automated way.

## Owner

*   Name: Simone Tiraboschi (stirabos)

<!-- -->

*   Email: <stirabos@redhat.com>

## Current status

*   Completed
*   Last updated on -- by (WIKI)

## Detailed Description

The noVNC client used for VM web console utilizes websockets for passing VNC data. However, VNC server in qemu doesn't support websockets natively and there must be a websocket proxy placed between the client and VNC server. This proxy can run either on any node that has access to the host network but, currently, the engine-setup is only able to install and configure the WebSocketProxy on the node that runs the engine.

Currently, it's already possible run the WebSocketProxy on a separate host but it requires a manual procedure. What we are proposing will automate a bit the setup process making it easier but still requiring some manual actions on both the machine.

Assumption:

*   The user has to install the needed RPMs on both the machine
*   The user has to run engine-setup on both the machine
*   This process is relative to a new install but an upgrade of ovirt-engine-websocket-proxy should not be a problem
*   The two hosts should be installed in strictly order:
    -   first the host with the engine to setup also the CA
    -   than the host with websocket-proxy

Under this assumptions it can work this way:

*   On the first node:
    1.  Via yum, the user installs the required RPMs on the first machine (the engine one)
    2.  Then he can launch engine-setup
    3.  engine-setup will ask about engine configuration; the user should choose YES to install the engine there.

<!-- -->

*   On the second node:
    1.  Via yum user install the required RPM (yum install ovirt-engine-websocket-proxy)
    2.  Then he can launch engine-setup
    3.  If the user also installed engine rpms, engine-setup will ask about engine configuration; the user should choose NO. He has instead to chose to configure the websocket proxy
    4.  acknowledging that the engine is not being configured, engine-setup show instruction to configure a remote engine to talk with the websocket proxy on this host, in particular:
        1.  it shows a command to configure, on the engine host, the new websocket proxy location (via engine-config)
        2.  it supports websocket proxy cert setup proposing the required commands; it can happen in two different way:
            1.  inline: the engine setup generates and prints a CSR on the screen, the user should paste it on the engine host into a well know path, sign it, and than paste back the signed cert within engine-setup UI
            2.  file-based: not that different from the previous one, CSR is not shown on the screen but is saved into a temp file, the user should copy it to the other host in order to sign it, than ha has to copy back the signed cert file providing the local path when required

    5.  engine-setup also asks engine fqdn in order to automatically download the engine cert

At the end WebSocket Proxy runs on a different host, in order to connect to it from your browser trusting the engine cert it's not enough (cause we now have two hosts) so the user has to download the CA cert end explicitly trust it in his browser. The CA cert can be downloaded from http://\<enginehost>/ca.crt

# Example setup

Two VMs were created with fedora 19 installed. They are named 'f19t11' (for the engine) and 'f19t12' (for the websocket-proxy).

## Engine

Install the engine as usual on the first host.

## WebSocket Proxy

Add ovirt-engine-websocket-proxy on the second host

      [root@f19t12 ~]# yum install ovirt-engine-websocket-proxy

Than, on the second host, run engine setup

      [root@f19t12 ~]# engine-setup 
      [ INFO  ] Stage: Initializing
      [ INFO  ] Stage: Environment setup
                Configuration files: []
                Log file: /var/log/ovirt-engine/setup/ovirt-engine-setup-20140919173308-96y9sa.log
                Version: otopi-1.3.0_master (otopi-1.3.0-0.0.master.20140911.git7c7d631.fc19)
      [ INFO  ] Stage: Environment packages setup
      [ INFO  ] Stage: Programs detection
      [ INFO  ] Stage: Environment setup
      [ INFO  ] Stage: Environment customization
               
                --== PRODUCT OPTIONS ==--
               
                Configure WebSocket Proxy on this host (Yes, No) [Yes]: 

Choose Yes here

                Setup can automatically configure the firewall on this system.
                Note: automatic configuration of the firewall may overwrite current settings.
                Do you want Setup to configure the firewall? (Yes, No) [Yes]: 
      [ INFO  ] iptables will be configured as firewall manager.
                Host fully qualified DNS name of this server [f19t12.localdomain]: 
      [ INFO  ] Stage: Setup validation
               
                --== CONFIGURATION PREVIEW ==--
               
                Update Firewall                         : True
                Host FQDN                               : f19t12.localdomain
                Firewall manager                        : iptables
                Configure WebSocket Proxy               : True
               
                Please confirm installation settings (OK, Cancel) [OK]: 
      [ INFO  ] Stage: Transaction setup
      [ INFO  ] Stopping websocket-proxy service
      [ INFO  ] Stage: Misc configuration
      [ INFO  ] Stage: Package installation
      [ INFO  ] Stage: Misc configuration
      [ INFO  ] Configuring WebSocket Proxy
               
                ATTENTION
               
                Manual actions are required on the engine host
                in order to enroll certs for this host and configure the engine about it.
               
                Please execute this command on the engine host: 
                   engine-config -s WebSocketProxy=f19t12.localdomain:6100
                and than restart the engine service to make it effective

Connect to first (engine) host and execute there the proposed command

      [root@f19t11 ~]# engine-config -s WebSocketProxy=f19t12.localdomain:6100
      [root@f19t11 ~]# service ovirt-engine restart
      Redirecting to /bin/systemctl restart  ovirt-engine.service

back to the second host:

                Do you prefer to manage certificate signing request and response
                inline or thought support files? (Inline, Files) [Inline]: 

Choose the way you prefer, here we run with the inline mode:

                Please issue WebSocket Proxy certificate based on this certificate request

This is the certificate request:

      D:MULTI-STRING WSP_CERTIFICATE_REQUEST --=451b80dc-996f-432e-9e4f-2b29ef6d1141=--
      -----BEGIN CERTIFICATE REQUEST-----
      MIICRDCCASwCADAAMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAzFNa
      PAFK0votbVDN+QfMarcXmpq1gq2zzCM3PU19Fnz+ULcgUqb7B2wQBYgTtRUQfswu
      XyB+Ki+O53+CUPWlVfwlxENmqyj5zCe4MiVHr09SCnztdtgVoPKOJThyviWbVW3Q
      iTNaTLOo7eBejfiBlFEnh15HkRSrm6HvMsFPgdolKopfZqxBeKZqT4BOS4qk4Y+B
      B2vthcKlLnTdyzIeDyUPsFkYritwU0DuNyQw4F3O5tdJGmW/Xc3GWLgHbILMXF9N
      Y1c4WOvD5hmsrEc1G8jXb0xmBzHfyUTve84V4pl+PVwQjIHXihOoi8x4R3tM2IBC
      5+sPDbJsBBMdEJ9G7QIDAQABoAAwDQYJKoZIhvcNAQEFBQADggEBAL6jeqY6RydJ
      7ON5Bye45m/amscASpC4YknG28zBRAJTvsUDOPMhqm/JC/keQe1dNJ/951lbQ5ob
      5Dzgz5lBQ9LGPpqozAfX930Gw+VsajL8RT0VgTtgaUt9G4iiUNObaRkBLALscBXG
      kUJ2kEyvd9vrsU/bGZ69mHmsK3eSV5aW4AKLoeUoWlnJqhfh9Dun6xWt9bLpQ7NH
      ku4pFXrRQ6aAiL88XT1vjvWI8DTit50atgxNZuY6m+ETeAUfcXtNM0pEVnMXr+s6
      rzI7Rgz+oLQOX4h0s0yaIHZk+OUPk5i+rQUZUeSXDpVl+UtntgjOB7fRECKXsNza
      23hFCulH9ok=
      -----END CERTIFICATE REQUEST-----
      --=451b80dc-996f-432e-9e4f-2b29ef6d1141=--
               
                Enroll SSL certificate for the websocket proxy service.
                It can be done using engine internal CA, if no 3rd party CA is available,
                with this sequence:
                1. Copy and save certificate request at
                    /etc/pki/ovirt-engine/requests/websocket-proxy-f19t12.localdomain.req
                on the engine host

As proposed save that certificate request at the proposed path on the engine host.

                2. execute, on the engine host, this command to enroll the cert:
                 /usr/share/ovirt-engine/bin/pki-enroll-request.sh \
                     --name=websocket-proxy-f19t12.localdomain \
                     --subject="/C=`<country>`/O=`<organization>`/CN=f19t12.localdomain"
                Substitute `<country>`, `<organization>` to suite your environment
                (i.e. the values must match values in the certificate authority of your engine)
               3. Certificate will be available at
                    /etc/pki/ovirt-engine/certs/websocket-proxy-f19t12.localdomain.cer
                on the engine host, please paste that content here when required

Connect again to the engine host in order to execute the proposed command. You also need to know the Country and Organization used for the CA, if you don't know:

      [root@f19t11 ~]# openssl x509 -in /etc/pki/ovirt-engine/certs/ca.der -noout -subject
      subject= /C=US/O=localdomain/CN=f19t11.localdomain.84133

so use them to complete the proposed command and execute it on the engine host

      [root@f19t11 ~]# /usr/share/ovirt-engine/bin/pki-enroll-request.sh --name=websocket-proxy-f19t12.localdomain --subject="/C=US/O=localdomain/CN=f19t12.localdomain"
      Using configuration from openssl.conf
      Check that the request matches the signature
      Signature ok
      The Subject's Distinguished Name is as follows
      countryName           :PRINTABLE:'US'
      organizationName      :PRINTABLE:'localdomain'
      commonName            :PRINTABLE:'f19t12.localdomain'
      Certificate is to be certified until Aug 24 15:47:58 2019 GMT (1800 days)
      Write out database with 1 new entries
      Data Base Updated

The cert will be available at the proposed path, so, on the engine host:

      [root@f19t11 ~]# cat /etc/pki/ovirt-engine/certs/websocket-proxy-f19t12.localdomain.cer       
      Certificate:
          Data:
              Version: 3 (0x2)
              Serial Number: 4121 (0x1019)
          Signature Algorithm: sha1WithRSAEncryption
              Issuer: C=US, O=localdomain, CN=f19t11.localdomain.84133
              Validity
                  Not Before: Sep 18 15:47:58 2014
                  Not After : Aug 24 15:47:58 2019 GMT
              Subject: C=US, O=localdomain, CN=f19t12.localdomain
              Subject Public Key Info:
                  Public Key Algorithm: rsaEncryption
                      Public-Key: (2048 bit)
                      Modulus:
                          00:cc:53:5a:3c:01:4a:d2:fa:2d:6d:50:cd:f9:07:
                          cc:6a:b7:17:9a:9a:b5:82:ad:b3:cc:23:37:3d:4d:
                          7d:16:7c:fe:50:b7:20:52:a6:fb:07:6c:10:05:88:
                          13:b5:15:10:7e:cc:2e:5f:20:7e:2a:2f:8e:e7:7f:
                          82:50:f5:a5:55:fc:25:c4:43:66:ab:28:f9:cc:27:
                          b8:32:25:47:af:4f:52:0a:7c:ed:76:d8:15:a0:f2:
                          8e:25:38:72:be:25:9b:55:6d:d0:89:33:5a:4c:b3:
                          a8:ed:e0:5e:8d:f8:81:94:51:27:87:5e:47:91:14:
                          ab:9b:a1:ef:32:c1:4f:81:da:25:2a:8a:5f:66:ac:
                          41:78:a6:6a:4f:80:4e:4b:8a:a4:e1:8f:81:07:6b:
                          ed:85:c2:a5:2e:74:dd:cb:32:1e:0f:25:0f:b0:59:
                          18:ae:2b:70:53:40:ee:37:24:30:e0:5d:ce:e6:d7:
                          49:1a:65:bf:5d:cd:c6:58:b8:07:6c:82:cc:5c:5f:
                          4d:63:57:38:58:eb:c3:e6:19:ac:ac:47:35:1b:c8:
                          d7:6f:4c:66:07:31:df:c9:44:ef:7b:ce:15:e2:99:
                          7e:3d:5c:10:8c:81:d7:8a:13:a8:8b:cc:78:47:7b:
                          4c:d8:80:42:e7:eb:0f:0d:b2:6c:04:13:1d:10:9f:
                          46:ed
                      Exponent: 65537 (0x10001)
              X509v3 extensions:
                  X509v3 Subject Key Identifier: 
                      87:D6:7C:B1:4D:89:E5:ED:79:1E:2C:5C:51:AD:9E:45:D6:7E:6D:FC
                  Authority Information Access: 
`                CA Issuers - URI:`[`http://f19t11.localdomain:80/ovirt-engine/services/pki-resource?resource=ca-certificate&format=X509-PEM-CA`](http://f19t11.localdomain:80/ovirt-engine/services/pki-resource?resource=ca-certificate&format=X509-PEM-CA)
                  X509v3 Authority Key Identifier: 
                      keyid:7C:62:A5:65:2B:58:8A:61:20:8E:F5:A2:B3:1E:2D:03:C4:3E:80:11
                      DirName:/C=US/O=localdomain/CN=f19t11.localdomain.84133
                      serial:10:00
                  X509v3 Basic Constraints: 
                      CA:FALSE
                  X509v3 Key Usage: critical
                      Digital Signature, Key Encipherment
                  X509v3 Extended Key Usage: critical
                      TLS Web Server Authentication, TLS Web Client Authentication
          Signature Algorithm: sha1WithRSAEncryption
               57:ce:55:f2:12:1f:18:6d:0b:ce:f4:c8:6e:1b:e4:d9:9c:a7:
               de:10:8b:13:54:ba:b3:a7:77:68:a1:09:90:d9:03:db:b9:f8:
               dd:20:15:a9:96:e8:21:55:2b:e3:39:fd:1e:f5:6a:01:1c:43:
               00:9d:7f:6d:d9:c4:7d:0c:f7:6b:c8:b1:97:e3:2e:af:62:40:
               95:3c:a9:63:83:17:6c:26:34:bb:4b:a8:74:7c:2f:51:70:b5:
               40:f7:5a:55:41:7d:1b:05:7a:95:23:3e:c0:b9:e1:e5:92:68:
               6d:07:ab:16:e6:72:7c:19:e1:b4:31:16:db:56:14:de:8e:bd:
               26:28:02:1d:2f:34:ac:a0:39:60:4c:d2:33:9e:9f:3b:46:06:
               fe:c9:be:4a:8a:f9:c1:4f:2b:1b:7d:c0:ed:43:41:d9:97:fc:
               f5:1a:83:77:69:f9:00:24:fd:67:0f:bc:c5:a2:0f:36:c9:04:
               47:39:bf:0a:8f:e6:05:41:04:38:c6:2d:45:12:60:b7:a9:0a:
               e8:0e:a5:ee:7c:d2:bb:09:79:fa:f5:da:db:a5:18:ed:a8:e3:
               d5:cc:e9:2b:11:31:0c:3f:fa:42:dc:d9:b6:55:94:7f:55:e8:
               ad:91:8d:d7:0e:38:09:cc:7c:21:99:73:9e:86:52:1d:84:f7:
               67:fa:2b:95
      -----BEGIN CERTIFICATE-----
      MIIEYjCCA0qgAwIBAgICEBkwDQYJKoZIhvcNAQEFBQAwRjELMAkGA1UEBhMCVVMx
      FDASBgNVBAoTC2xvY2FsZG9tYWluMSEwHwYDVQQDExhmMTl0MTEubG9jYWxkb21h
      aW4uODQxMzMwIhcRMTQwOTE4MTU0NzU4KzAwMDAXDTE5MDgyNDE1NDc1OFowQDEL
      MAkGA1UEBhMCVVMxFDASBgNVBAoTC2xvY2FsZG9tYWluMRswGQYDVQQDExJmMTl0
      MTIubG9jYWxkb21haW4wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDM
      U1o8AUrS+i1tUM35B8xqtxeamrWCrbPMIzc9TX0WfP5QtyBSpvsHbBAFiBO1FRB+
      zC5fIH4qL47nf4JQ9aVV/CXEQ2arKPnMJ7gyJUevT1IKfO122BWg8o4lOHK+JZtV
      bdCJM1pMs6jt4F6N+IGUUSeHXkeRFKuboe8ywU+B2iUqil9mrEF4pmpPgE5LiqTh
      j4EHa+2FwqUudN3LMh4PJQ+wWRiuK3BTQO43JDDgXc7m10kaZb9dzcZYuAdsgsxc
      X01jVzhY68PmGaysRzUbyNdvTGYHMd/JRO97zhXimX49XBCMgdeKE6iLzHhHe0zY
      gELn6w8NsmwEEx0Qn0btAgMBAAGjggFaMIIBVjAdBgNVHQ4EFgQUh9Z8sU2J5e15
      HixcUa2eRdZ+bfwwgYYGCCsGAQUFBwEBBHoweDB2BggrBgEFBQcwAoZqaHR0cDov
      L2YxOXQxMS5sb2NhbGRvbWFpbjo4MC9vdmlydC1lbmdpbmUvc2VydmljZXMvcGtp
      LXJlc291cmNlP3Jlc291cmNlPWNhLWNlcnRpZmljYXRlJmZvcm1hdD1YNTA5LVBF
      TS1DQTBvBgNVHSMEaDBmgBR8YqVlK1iKYSCO9aKzHi0DxD6AEaFKpEgwRjELMAkG
      A1UEBhMCVVMxFDASBgNVBAoTC2xvY2FsZG9tYWluMSEwHwYDVQQDExhmMTl0MTEu
      bG9jYWxkb21haW4uODQxMzOCAhAAMAkGA1UdEwQCMAAwDgYDVR0PAQH/BAQDAgWg
      MCAGA1UdJQEB/wQWMBQGCCsGAQUFBwMBBggrBgEFBQcDAjANBgkqhkiG9w0BAQUF
      AAOCAQEAV85V8hIfGG0LzvTIbhvk2Zyn3hCLE1S6s6d3aKEJkNkD27n43SAVqZbo
      IVUr4zn9HvVqARxDAJ1/bdnEfQz3a8ixl+Mur2JAlTypY4MXbCY0u0uodHwvUXC1
      QPdaVUF9GwV6lSM+wLnh5ZJobQerFuZyfBnhtDEW21YU3o69JigCHS80rKA5YEzS
      M56fO0YG/sm+Sor5wU8rG33A7UNB2Zf89RqDd2n5ACT9Zw+8xaIPNskERzm/Co/m
      BUEEOMYtRRJgt6kK6A6l7nzSuwl5+vXa26UY7ajj1czpKxExDD/6QtzZtlWUf1Xo
      rZGN1w44Ccx8IZlznoZSHYT3Z/orlQ==
      -----END CERTIFICATE-----

Take the last section in order to input it on the websocket proxy host

                Please input WSP certificate chain that matches certificate request,
                (issuer is not mandatory, from intermediate and upper)
               
                type '--=451b80dc-996f-432e-9e4f-2b29ef6d1141=--' in own line to mark end.

Use that line to end the input phase.

      -----BEGIN CERTIFICATE-----
      MIIEYjCCA0qgAwIBAgICEBkwDQYJKoZIhvcNAQEFBQAwRjELMAkGA1UEBhMCVVMx
      FDASBgNVBAoTC2xvY2FsZG9tYWluMSEwHwYDVQQDExhmMTl0MTEubG9jYWxkb21h
      aW4uODQxMzMwIhcRMTQwOTE4MTU0NzU4KzAwMDAXDTE5MDgyNDE1NDc1OFowQDEL
      MAkGA1UEBhMCVVMxFDASBgNVBAoTC2xvY2FsZG9tYWluMRswGQYDVQQDExJmMTl0
      MTIubG9jYWxkb21haW4wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDM
      U1o8AUrS+i1tUM35B8xqtxeamrWCrbPMIzc9TX0WfP5QtyBSpvsHbBAFiBO1FRB+
      zC5fIH4qL47nf4JQ9aVV/CXEQ2arKPnMJ7gyJUevT1IKfO122BWg8o4lOHK+JZtV
      bdCJM1pMs6jt4F6N+IGUUSeHXkeRFKuboe8ywU+B2iUqil9mrEF4pmpPgE5LiqTh
      j4EHa+2FwqUudN3LMh4PJQ+wWRiuK3BTQO43JDDgXc7m10kaZb9dzcZYuAdsgsxc
      X01jVzhY68PmGaysRzUbyNdvTGYHMd/JRO97zhXimX49XBCMgdeKE6iLzHhHe0zY
      gELn6w8NsmwEEx0Qn0btAgMBAAGjggFaMIIBVjAdBgNVHQ4EFgQUh9Z8sU2J5e15
      HixcUa2eRdZ+bfwwgYYGCCsGAQUFBwEBBHoweDB2BggrBgEFBQcwAoZqaHR0cDov
      L2YxOXQxMS5sb2NhbGRvbWFpbjo4MC9vdmlydC1lbmdpbmUvc2VydmljZXMvcGtp
      LXJlc291cmNlP3Jlc291cmNlPWNhLWNlcnRpZmljYXRlJmZvcm1hdD1YNTA5LVBF
      TS1DQTBvBgNVHSMEaDBmgBR8YqVlK1iKYSCO9aKzHi0DxD6AEaFKpEgwRjELMAkG
      A1UEBhMCVVMxFDASBgNVBAoTC2xvY2FsZG9tYWluMSEwHwYDVQQDExhmMTl0MTEu
      bG9jYWxkb21haW4uODQxMzOCAhAAMAkGA1UdEwQCMAAwDgYDVR0PAQH/BAQDAgWg
      MCAGA1UdJQEB/wQWMBQGCCsGAQUFBwMBBggrBgEFBQcDAjANBgkqhkiG9w0BAQUF
      AAOCAQEAV85V8hIfGG0LzvTIbhvk2Zyn3hCLE1S6s6d3aKEJkNkD27n43SAVqZbo
      IVUr4zn9HvVqARxDAJ1/bdnEfQz3a8ixl+Mur2JAlTypY4MXbCY0u0uodHwvUXC1
      QPdaVUF9GwV6lSM+wLnh5ZJobQerFuZyfBnhtDEW21YU3o69JigCHS80rKA5YEzS
      M56fO0YG/sm+Sor5wU8rG33A7UNB2Zf89RqDd2n5ACT9Zw+8xaIPNskERzm/Co/m
      BUEEOMYtRRJgt6kK6A6l7nzSuwl5+vXa26UY7ajj1czpKxExDD/6QtzZtlWUf1Xo
      rZGN1w44Ccx8IZlznoZSHYT3Z/orlQ==

Input the terminating line:

      --=451b80dc-996f-432e-9e4f-2b29ef6d1141=--

Now the second host needs to download and trust the engine cert, provide engine FQDN

                Please provide the FQDN or IP of the remote engine host: f19t11.localdomain

That's it...

      [ INFO  ] Generating post install configuration file '/etc/ovirt-engine-setup.conf.d/20-setup-ovirt-post.conf'
      [ INFO  ] Stage: Transaction commit
      [ INFO  ] Stage: Closing up
               
                --== SUMMARY ==--
               
               
                --== END OF SUMMARY ==--
               
      [ INFO  ] Stage: Clean up
                Log file is located at /var/log/ovirt-engine/setup/ovirt-engine-setup-20140919173308-96y9sa.log
      [ INFO  ] Generating answer file '/var/lib/ovirt-engine/setup/answers/20140919173600-setup.conf'
      [ INFO  ] Stage: Pre-termination
      [ INFO  ] Stage: Termination
      [ INFO  ] Execution of setup completed successfully

WebSocket Proxy now runs on a different host, in order to connect to it from your browser trusting the engine cert it's not enough (cause we have two host) so the user has to download the CA cert end explicitly trust it in his browser. The CA cert can be downloaded from http://\<enginehost>/ca.crt

## Benefit to oVirt

The installation process will become easier for who needs to install the WebSocketProxy on a separate engine cause it will require less manual actions

## Dependencies / Related Features

The WebSocketProxy is already able to run on a different host, only the engine setup should be improved to allow it being automatically configured.

## Documentation / External references

*   [RFE] Allow setup of ovirt-websocket-proxy on separate machine - [1](https://bugzilla.redhat.com/show_bug.cgi?id=1080992)
*   [RFE] rhevm-websocket-proxy - using as standalone service - automatic configuration - [2](https://bugzilla.redhat.com/show_bug.cgi?id=985945)

## Testing

Install and setup ovirt-engine on machine A, ovirt-engine-websocket-proxy on machine B and setup it as described. The user should be able to see a VM console thought websocket-proxy on host B.

On A:

      yum install ovirt-engine-setup 
      engine-setup

On B:

      yum install ovirt-engine-websocket-proxy
      engine-setup

Add a virtualization host, start a VM from the engine and pen the noVNC console. The user should be able to see the VM console.



[WebSocketProxy on a separate host](/develop/release-management/features/) [WebSocketProxy on a separate host](/develop/release-management/releases/3.5/feature.html) [WebSocketProxy on a separate host](Category:Integration)
