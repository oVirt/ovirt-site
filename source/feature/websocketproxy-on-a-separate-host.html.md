---
title: WebSocketProxy on a separate host
category: feature
authors: sandrobonazzola, stirabos
wiki_category: Feature|WebSocketProxy on a separate host
wiki_title: Features/WebSocketProxy on a separate host
wiki_revision_count: 29
wiki_last_updated: 2015-01-16
feature_name: WebSocketProxy on a separate host
feature_modules: websocket-proxy
feature_status: completed
---

### WebSocketProxy on a separate host

#### Summary

The aim of this feature is to enhance the engine setup being able to install and configure the WebSocketProxy on a second machine, where engine does not run, in a fully automated way.

#### Owner

*   Name: [ Simone Tiraboschi](User:stirabos)

<!-- -->

*   Email: <stirabos@redhat.com>

#### Current status

*   Completed
*   Last updated on -- by [ WIKI}}](User:{{urlencode:{{REVISIONUSER}})

#### Detailed Description

The noVNC client used for VM web console utilizes websockets for passing VNC data. However, VNC server in qemu doesn't support websockets natively and there must be a websocket proxy placed between the client and VNC server. This proxy can run either on any node that has access to the host network but, currently, the engine-setup is only able to install and configure the WebSocketProxy on the node that runs the engine.

It's currently already possible run the WebSocketProxy on a separate host but it requires a manual procedure. What we are proposing will automate a bit the setup process making it easier but still requiring some manual actions on both the machine.

Assumption:

*   The user has to install the needed RPMs on both the machine
*   The user has to run engine-setup on both the machine
*   This process is relative to a new install but an upgrade of ovirt-engine-websocket-proxy should not be a problem
*   The two hosts should be installed in strictly order:
    -   first the host with the engine to setup also the CA
    -   than the host with websocket-proxy

Under this assumptions it can works this way:

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

# Example setup

Two VMs were created with fedora 19 installed. They are named 'f19t11' (for the engine) and 'f19t12' (for the websocket-proxy).

### Engine

Install the engine as usual on the first host.

### WebSocket Proxy

Add ovirt-engine-websocket-proxy on the second host

      [root@f19t12 ~]# yum install ovirt-engine-websocket-proxy

Than, on the second host, run engine setup

      [root@f19t12 ~]# engine-setup 
      [ INFO  ] Stage: Initializing
      [ INFO  ] Stage: Environment setup
                Configuration files: []
                Log file: /var/log/ovirt-engine/setup/ovirt-engine-setup-20140919173308-96y9sa.log
                Version: otopi-1.3.0_master (otopi-1.3.0-0.0.master.20140911.git7c7d631.fc19)
      [ INFO  ] Stage: Environment packages setup
      [ INFO  ] Stage: Programs detection
      [ INFO  ] Stage: Environment setup
      [ INFO  ] Stage: Environment customization
               
                --== PRODUCT OPTIONS ==--
               
                Configure WebSocket Proxy on this host (Yes, No) [Yes]: 
                Setup can automatically configure the firewall on this system.
                Note: automatic configuration of the firewall may overwrite current settings.
                Do you want Setup to configure the firewall? (Yes, No) [Yes]: 
      [ INFO  ] iptables will be configured as firewall manager.
                Host fully qualified DNS name of this server [f19t12.localdomain]: 
      [WARNING] Failed to resolve f19t12.localdomain using DNS, it can be resolved only locally
      [ INFO  ] Stage: Setup validation
               
                --== CONFIGURATION PREVIEW ==--
               
                Update Firewall                         : True
                Host FQDN                               : f19t12.localdomain
                Firewall manager                        : iptables
                Configure WebSocket Proxy               : True
               
                Please confirm installation settings (OK, Cancel) [OK]: 
      [ INFO  ] Stage: Transaction setup
      [ INFO  ] Stopping websocket-proxy service
      [ INFO  ] Stage: Misc configuration
      [ INFO  ] Stage: Package installation
      [ INFO  ] Stage: Misc configuration
      [ INFO  ] Configuring WebSocket Proxy
               
                ATTENTION
               
                Manual actions are required on the engine host
                in order to enroll certs for this host and configure the engine about it.
               
                Please execute this command on the engine host: 
                   engine-config -s WebSocketProxy=f19t12.localdomain:6100
                and than restart the engine service to make it effective
               
               
                Do you prefer to manage certificate signing request and response
                inline or thought support files? (Inline, Files) [Inline]: 
               
                Please issue WebSocket Proxy certificate based on this certificate request
               
      D:MULTI-STRING WSP_CERTIFICATE_REQUEST --=451b80dc-996f-432e-9e4f-2b29ef6d1141=--
      -----BEGIN CERTIFICATE REQUEST-----
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
      -----END CERTIFICATE REQUEST-----
      --=451b80dc-996f-432e-9e4f-2b29ef6d1141=--
               
                Enroll SSL certificate for the websocket proxy service.
                It can be done using engine internal CA, if no 3rd party CA is available,
                with this sequence:
               
                1. Copy and save certificate request at
                    /etc/pki/ovirt-engine/requests/websocket-proxy-f19t12.localdomain.req
                on the engine host
               
                2. execute, on the engine host, this command to enroll the cert:
                 /usr/share/ovirt-engine/bin/pki-enroll-request.sh \
                     --name=websocket-proxy-f19t12.localdomain \
                     --subject="/C=`<country>`/O=`<organization>`/CN=f19t12.localdomain"
                Substitute `<country>`, `<organization>` to suite your environment
                (i.e. the values must match values in the certificate authority of your engine)
               
                3. Certificate will be available at
                    /etc/pki/ovirt-engine/certs/websocket-proxy-f19t12.localdomain.cer
                on the engine host, please paste that content here when required
               
                Please input WSP certificate chain that matches certificate request,
                (issuer is not mandatory, from intermediate and upper)
               
                type '--=451b80dc-996f-432e-9e4f-2b29ef6d1141=--' in own line to mark end.
      -----BEGIN CERTIFICATE-----
      MIIEYjCCA0qgAwIBAgICEBgwDQYJKoZIhvcNAQEFBQAwRjELMAkGA1UEBhMCVVMx
      FDASBgNVBAoTC2xvY2FsZG9tYWluMSEwHwYDVQQDExhmMTl0MTEubG9jYWxkb21h
      aW4uODQxMzMwIhcRMTQwOTE4MTUzNTI1KzAwMDAXDTE5MDgyNDE1MzUyNVowQDEL
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
      AAOCAQEADHYPo6vhcHMnzc7ykeI7OKbnR+tZTCTbAtbI+SDcmZTGWsriEsJI5jYn
      cUzzPgbBINcVx4Z63WxLOdI/ud2oGWZbjFvU1IBRVFp6XttFz1Y6wHUsjBMZpW6N
      0VTQY3FkeaPF6bIMQmQY8fxQZHSlUF3Kd+6DBv6eWtahoXVbY5nOozNXK+HybPVX
      elGcn08asXRHFMIpQCxm8Dig9RYyQhBj3+U5bkr26g7VEn0uJdNrH0pdm4HYbTuF
      Gn2dbLgCL8+OTeHXIy+/jwDGjqCunCw3T5lEiv/najYU0KtnQ9vV79aIeuy+ruhe
      gKiKo9aUNVG2YwPx1DSRYfxpDb4UeQ==
      -----END CERTIFICATE-----
      --=451b80dc-996f-432e-9e4f-2b29ef6d1141=--
                Please provide the FQDN or IP of the remote engine host: f19t11.localdomain
      [ INFO  ] Generating post install configuration file '/etc/ovirt-engine-setup.conf.d/20-setup-ovirt-post.conf'
      [ INFO  ] Stage: Transaction commit
      [ INFO  ] Stage: Closing up
               
                --== SUMMARY ==--
               
               
                --== END OF SUMMARY ==--
               
      [ INFO  ] Stage: Clean up
                Log file is located at /var/log/ovirt-engine/setup/ovirt-engine-setup-20140919173308-96y9sa.log
      [ INFO  ] Generating answer file '/var/lib/ovirt-engine/setup/answers/20140919173600-setup.conf'
      [ INFO  ] Stage: Pre-termination
      [ INFO  ] Stage: Termination
      [ INFO  ] Execution of setup completed successfully

#### Benefit to oVirt

The installation process will become easier for who needs to install the WebSocketProxy on a separate engine cause it will require less manual actions

#### Dependencies / Related Features

The WebSocketProxy is already able to run on a different host, only the engine setup should be improved to allow it being automatically configured.

#### Documentation / External references

*   [RFE] Allow setup of ovirt-websocket-proxy on separate machine - [1](https://bugzilla.redhat.com/show_bug.cgi?id=1080992)
*   [RFE] rhevm-websocket-proxy - using as standalone service - automatic configuration - [2](https://bugzilla.redhat.com/show_bug.cgi?id=985945)

#### Testing

A tester should perform a full oVirt installation choosing to install the WebSocketProxy on a different host. The The tester should be able to connect to any running machine via the noVNC web client.

#### Comments and Discussion

*   Refer to [Talk:WebSocketProxy on a separate host](Talk:WebSocketProxy on a separate host)

<Category:Feature>
