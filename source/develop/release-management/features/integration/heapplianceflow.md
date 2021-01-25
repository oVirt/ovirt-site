---
title: HEApplianceFlow
category: feature
authors: stirabos
feature_name: oVirt hosted-engine appliance flow
feature_modules: hosted-engine
feature_status: WIP
---

# HE Appliance Flow

## oVirt hosted-engine appliance flow

### Summary

This feature will provide a more convenient way to deploy oVirt self-hosted-engine creating the engine VM from a pre-installed appliance to be configured on fly.
This can save a lot time and make the setup easier.

### Owner

*   Name: Simone Tiraboschi (stirabos)
*   Email: <stirabos@redhat.com>
*   IRC: tiraboschi

### Detailed Description

This feature is about deploying oVirt hosted-engine setup in a more convenient and automatizable way. In order to deploy hosted-engine, currently the mainstream flow means:

1.  create a VM booting from an ISO image
2.  connect to that VM to install the OS and eventually updated it
3.  reboot that VM
4.  connect again, download ovirt-engine rpms
5.  launch engine-setup and answer a few question (some of them already have a response on the host side but you need to type it again)
6.  go back to the host to complete the hosted-engine setup

The whole process could take a few hours.

Hosted-engine automated setup with the appliance flow means:

1.  ask a few question more (but they can be automated via an answerfile as well) regarding engine-setup on hosted-engine-setup side
2.  generate an aswerfile and inject it into the appliance via cloud-init
3.  automatically launch engine-setup on the appliance via cloud-init; the setup will be fully unattended
4.  the output of engine-setup will be redirected on a virtio-serial port to get shown inside hosted-engine-setup without the need for ssh console, virsh console or remote viewer. Using a virtio serial port instead of an ssh connection means that we are going to get some output also if the network wasn't properly set-up for the new VM.

The whole process could take a few minutes (excluding initial download time).

### Benefit to oVirt

*   Hosted-engine deployment becomes easier and quicker.
*   Hosted-engine deployment can be fully automated which means that we could have continuous integration on that.

### Dependencies / Related Features

The appliance jobs need to provide the correct images.

The RPM is available in the oVirt repo: the user could simply install them via yum and hosted-engine-setup should automatically detect them.
__NOTE:__ The installation may take some time due to the size of the RPM.

`[root@hostedEngine] yum install ovirt-engine-appliance`

### Documentation / External references

*   Cloud-init reference: <https://cloudinit.readthedocs.org/en/latest/>

### Testing

#### Prerequisites
*   Make sure your host and your virtual machine support nested virtualization. You can find detailed instructions here:       
    http://community.redhat.com/blog/2013/08/testing-ovirt-3-3-with-nested-kvm/.
    After setting nested virtualization in the host, reboot it. 
*   If you are opting for a DHCP network configuration (and not static) you must have a resolvable MAC address and DHCP name.   
#### Manual setup on hosted-engine side

Launch hosted-engine --deploy as usual

      [root@c71ghe1 ~]# hosted-engine --deploy 
      [ INFO  ] Stage: Initializing
      [ INFO  ] Generating a temporary VNC password.
      [ INFO  ] Stage: Environment setup
                Continuing will configure this host for serving as hypervisor and create a VM where you have to install oVirt Engine afterwards.
                Are you sure you want to continue? (Yes, No)[Yes]: 
                Configuration files: []
                Log file: /var/log/ovirt-hosted-engine-setup/ovirt-hosted-engine-setup-20150527003826-ger99j.log
                Version: otopi-1.4.0_master (otopi-1.4.0-0.0.master.20150525193239.git66c59b4.el7)
      [ INFO  ] Hardware supports virtualization
      [ INFO  ] Bridge ovirtmgmt already created
      [ INFO  ] Stage: Environment packages setup
      [ INFO  ] Stage: Programs detection
      [ INFO  ] Stage: Environment setup
      [ INFO  ] Stage: Environment customization
               
                --== STORAGE CONFIGURATION ==--
               
                During customization use CTRL-D to abort.

It should work on all the possible storage backends.

                Please specify the storage you would like to use (glusterfs, iscsi, fc, nfs3, nfs4)[nfs3]: nfs4
                Please specify the full shared storage connection path to use (example: host:/path): 192.168.1.115:/Virtual/exthe7
      [ INFO  ] Installing on first host
                Please provide storage domain name. [hosted_storage]: 
                Local storage datacenter name is an internal name
                and currently will not be shown in engine's admin UI.
                Please enter local datacenter name [hosted_datacenter]: 
               
                --== SYSTEM CONFIGURATION ==--
               
               
                --== NETWORK CONFIGURATION ==--
               
                iptables was detected on your computer, do you wish setup to configure it? (Yes, No)[Yes]: 
                Please indicate a pingable gateway IP address [192.168.1.1]: 
               
                --== VM CONFIGURATION ==--

Choose disk to boot using the appliance.

                Please specify the device to boot the VM from (cdrom, disk, pxe) [cdrom]: disk

Choose to use cloud-init to automatically configure the appliance.

                Would you like to use cloud-init to customize the appliance on the first boot (Yes, No)[Yes]?

You could provide a custom cloud-init no-cloud ISO image for complex configuration or you can simply have hosted-engine-setup generating one for you on flight.

                Would you like to generate on-fly a cloud-init no-cloud ISO image
                or do you have an existing one (Generate, Existing)[Generate]? 

Configure your appliance

                Please provide the FQDN you would like to use for the engine appliance.
                Note: This will be the FQDN of the engine VM you are now going to launch,
                it should not point to the base host or to any other existing machine.
                Engine VM FQDN: (leave it empty to skip): topolino.localdomain

If everything is OK and you don't need any other setup action on the engine VM, hosted-engine-setup could automatically start engine-setup for you on the appliance in order to silently setup the engine.

                Automatically execute engine-setup on the engine appliance on first boot (Yes, No)[Yes]? 
                Automatically restart the engine VM as a monitored service after engine-setup (Yes, No)[Yes]? 
                Enter root password that will be used for the engine appliance (leave it empty to skip): 
                Confirm appliance root password: 
                Please provide the domain name you would like to use for the engine appliance.
                Engine VM domain: [localdomain]

The appliance networking by default will get configured by DHCP but you need to know in advance the hostname (the host should be able to resolve it) so you need a DHCP reservation (you could force the appliance MAC address from here) with DHCP-DNS integration. Otherwise you could choose Static configuration and configure your appliance networking (including DNS, static entry in /etc/hosts...) from here.

                How should the engine VM network should be configured (DHCP, Static)[DHCP]? static
                Please enter the IP address to be used for the engine VM [192.168.1.2]: 192.168.1.184
      [ INFO  ] The engine VM will be configured to use 192.168.1.184/24
                Please provide a comma-separated list of IP addresses of domain name servers for the engine VM
                Engine VM DNS (leave it empty to skip) [192.168.1.1,0.0.0.0]: 192.168.1.1,8.8.8.8
                Add a line for this host to /etc/hosts on the engine VM?
                Note: ensuring that this host could resolve the engine VM hostname is still up to you
                (Yes, No)[No] yes

Please select the appliance path (WIP: the appliance should be distributed as an RPM and it should propose the correct path as a default)

                Please specify path to OVF archive you would like to use [None]: /mnt/ovirt.ova
      [ INFO  ] Checking OVF archive content (could take a few minutes depending on archive size)
      [ INFO  ] Checking OVF XML content (could take a few minutes depending on archive size)
      [WARNING] OVF does not contain a valid image description, using default.

You could customize the memory and CPU requirements of you appliance

                Please specify the memory size of the appliance in MB [Defaults to OVF value: 16384]: 4096
                Please specify an alias for the Hosted Engine image [hosted_engine]: 
                The following CPU types are supported by this host:
                  - model_SandyBridge: Intel SandyBridge Family
                  - model_Westmere: Intel Westmere Family
                  - model_Nehalem: Intel Nehalem Family
                  - model_Penryn: Intel Penryn Family
                  - model_Conroe: Intel Conroe Family
                Please specify the CPU type to be used by the VM [model_SandyBridge]: 
      [WARNING] Minimum requirements for disk size not met

If you opted for DHCP adressing you should be sure to have a correct DHCP reservation for your appliance.

                You may specify a unicast MAC address for the VM or accept a randomly generated default [00:16:3e:1e:02:c1]: 
                Please specify the console type you would like to use to connect to the VM (vnc, spice) [vnc]: 
               
                --== HOSTED ENGINE CONFIGURATION ==--
               
                Enter the name which will be used to identify this host inside the Administrator Portal [hosted_engine_1]: 
                Enter 'admin@internal' user password that will be used for accessing the Administrator Portal: 
                Confirm 'admin@internal' user password: 
                Please provide the name of the SMTP server through which we will send notifications [localhost]: 
                Please provide the TCP port number of the SMTP server [25]: 
                Please provide the email address from which notifications will be sent [root@localhost]: 
                Please provide a comma-separated list of email addresses which will get notifications [root@localhost]: 
      [ INFO  ] Stage: Setup validation
               
                --== CONFIGURATION PREVIEW ==--
               
                Engine FQDN                        : topolino.localdomain
                Bridge name                        : ovirtmgmt
                SSH daemon port                    : 22
                Firewall manager                   : iptables
                Gateway address                    : 192.168.1.1
                Host name for web application      : hosted_engine_1
                Host ID                            : 1
                Image alias                        : hosted_engine
                Image size GB                      : 10
                GlusterFS Share Name               : hosted_engine_glusterfs
                GlusterFS Brick Provisioning       : False
                Storage connection                 : 192.168.1.115:/Virtual/exthe7
                Console type                       : vnc
                Memory size MB                     : 4096
                MAC address                        : 00:16:3e:1e:02:c1
                Boot type                          : disk
                Number of CPUs                     : 4
                OVF archive (for disk boot)        : /mnt/ovirt.ova
                Restart engine VM after engine-setup: True
                CPU Type                           : model_SandyBridge
               
                Please confirm installation settings (Yes, No)[Yes]: 
      [ INFO  ] Stage: Transaction setup
      [ INFO  ] Stage: Misc configuration
      [ INFO  ] Stage: Package installation
      [ INFO  ] Stage: Misc configuration
      [ INFO  ] Configuring libvirt
      [ INFO  ] Configuring VDSM
      [ INFO  ] Starting vdsmd
      [ INFO  ] Waiting for VDSM hardware info
      [ INFO  ] Creating Storage Domain
      [ INFO  ] Creating Storage Pool
      [ INFO  ] Connecting Storage Pool
      [ INFO  ] Verifying sanlock lockspace initialization
      [ INFO  ] Creating VM Image
      [ INFO  ] Extracting disk image from OVF archive (could take a few minutes depending on archive size)
      [ INFO  ] Validating pre-allocated volume size
      [ INFO  ] Uploading volume to data domain (could take a few minutes depending on archive size)
      [ INFO  ] Image successfully imported from OVF
      [ INFO  ] Image not uploaded to data domain
      [ INFO  ] Disconnecting Storage Pool
      [ INFO  ] Start monitoring domain
      [ INFO  ] Configuring VM
      [ INFO  ] Updating hosted-engine configuration
      [ INFO  ] Stage: Transaction commit
      [ INFO  ] Stage: Closing up
      [ INFO  ] Creating VM

You could still connect with remote-viewer

                You can now connect to the VM with the following command:
                 /bin/remote-viewer vnc://localhost:5900
                Use temporary password "3379rNnj" to connect to vnc console.
                Please note that in order to use remote-viewer you need to be able to run graphical applications.
                This means that if you are using ssh you have to supply the -Y flag (enables trusted X11 forwarding).
                Otherwise you can run the command from a terminal in your preferred desktop environment.
                If you cannot run graphical applications you can connect to the graphic console from another host or connect to the console using the following command:
                virsh -c qemu+tls://c71ghe1.localdomain/system console HostedEngine
                If you need to reboot the VM you will need to start it manually using the command:
                hosted-engine --vm-start
                You can then set a temporary password using the command:
                hosted-engine --add-console-password

But if you choose to have hosted-engine launching engine-setup for you, you could see engine setup output here. In this case engine-setup should be fully unattended.

      [ INFO  ] Running engine-setup on the appliance
                |- [ INFO  ] Stage: Initializing
                |- [ INFO  ] Stage: Environment setup
                |-           Configuration files: ['/etc/ovirt-engine-setup.conf.d/10-packaging-jboss.conf', '/etc/ovirt-engine-setup.conf.d/10-packaging.conf', '/root/ovirt-engine-answers', '/root/heanswers.conf']
                |-           Log file: /var/log/ovirt-engine/setup/ovirt-engine-setup-20150526224609-k1cybk.log
                |-           Version: otopi-1.4.0_master (otopi-1.4.0-0.0.master.20150423125505.git08ea44e.el7)
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
                |-           --== ALL IN ONE CONFIGURATION ==--
                |-          
                |-          
                |-           --== NETWORK CONFIGURATION ==--
                |-          
                |- [ ERROR ] Host name is not valid: topolino.localdomain did not resolve into an IP address
                |- [ INFO  ] firewalld will be configured as firewall manager.
                |- [ ERROR ] Host name is not valid: topolino.localdomain did not resolve into an IP address
                |-          
                |-           --== DATABASE CONFIGURATION ==--
                |-          
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
                |- [WARNING] Cannot validate host name settings, reason: cannot resolve own name 'topolino.localdomain'
                |- [WARNING] Less than 16384MB of memory is available
                |-          
                |-           --== CONFIGURATION PREVIEW ==--
                |-          
                |-           Application mode                        : virt
                |-           Firewall manager                        : firewalld
                |-           Update Firewall                         : True
                |-           Host FQDN                               : topolino.localdomain
                |-           Default SAN wipe after delete           : False
                |-           Engine database secured connection      : False
                |-           Engine database host                    : localhost
                |-           Engine database user name               : engine
                |-           Engine database name                    : engine
                |-           Engine database port                    : 5432
                |-           Engine database host name validation    : False
                |-           Engine installation                     : True
                |-           PKI organization                        : localdomain
                |-           Configure local Engine database         : True
                |-           Set application as default page         : True
                |-           Configure Apache SSL                    : True
                |-           Configure WebSocket Proxy               : True
                |-           Engine Host FQDN                        : topolino.localdomain
                |- [ INFO  ] Stage: Transaction setup
                |- [ INFO  ] Stopping engine service
                |- [ INFO  ] Stopping ovirt-fence-kdump-listener service
                |- [ INFO  ] Stopping websocket-proxy service
                |- [ INFO  ] Stage: Misc configuration
                |- [ INFO  ] Stage: Package installation
                |- [ INFO  ] Stage: Misc configuration
                |- [ INFO  ] Initializing PostgreSQL
                |- [ INFO  ] Creating PostgreSQL 'engine' database
                |- [ INFO  ] Configuring PostgreSQL
                |- [ INFO  ] Creating/refreshing Engine database schema
                |- [ INFO  ] Creating CA
                |- [ INFO  ] Configuring WebSocket Proxy
                |- [ INFO  ] Generating post install configuration file '/etc/ovirt-engine-setup.conf.d/20-setup-ovirt-post.conf'
                |- [ INFO  ] Stage: Transaction commit
                |- [ INFO  ] Stage: Closing up
                |-          
                |-           --== SUMMARY ==--
                |-          
                |- [WARNING] Less than 16384MB of memory is available
                |-           SSH fingerprint: BC:40:1F:C9:50:E1:9B:2A:08:FE:E6:5B:29:BB:E4:49
                |-           Internal CA 6F:D2:D0:70:F6:FC:EF:19:06:29:23:8B:4E:48:23:8C:18:F5:89:6D
                |-           Note! If you want to gather statistical information you can install Reports and/or DWH:
`          |-               `[`http://www.ovirt.org/Ovirt_DWH`](/Ovirt_DWH)
`          |-               `[`http://www.ovirt.org/Ovirt_Reports`](/Ovirt_Reports)
                |-           Web access is enabled at:
`          |-               `[`http://topolino.localdomain:80/ovirt-engine`](http://topolino.localdomain:80/ovirt-engine)
`          |-               `[`https://topolino.localdomain:443/ovirt-engine`](https://topolino.localdomain:443/ovirt-engine)
                |-           Please use the user "admin" and password specified in order to login
                |-          
                |-           --== END OF SUMMARY ==--
                |-          
                |- [ INFO  ] Starting engine service
                |- [ INFO  ] Restarting httpd
                |- [ INFO  ] Stage: Clean up
                |-           Log file is located at /var/log/ovirt-engine/setup/ovirt-engine-setup-20150526224609-k1cybk.log
                |- [ INFO  ] Generating answer file '/var/lib/ovirt-engine/setup/answers/20150526224723-setup.conf'
                |- [ INFO  ] Stage: Pre-termination
                |- [ INFO  ] Stage: Termination
                |- [ INFO  ] Execution of setup completed successfully
                |- HE_APPLIANCE_ENGINE_SETUP_SUCCESS

Hosted-engine-setup will detect the success of the failure (en specific exit codes or after a long timeout) of engine-setup. Than conclude as usual.

      [ INFO  ] Engine-setup successfully completed 
      [ ERROR ] Engine is still unreachable
      [ INFO  ] Engine is still not reachable, waiting...
      [ INFO  ] Engine replied: DB Up!Welcome to Health Status!
      [ INFO  ] Connecting to the Engine
                Enter the name of the cluster to which you want to add the host (Default) [Default]: 
      [ INFO  ] Waiting for the host to become operational in the engine. This may take several minutes...
      [ INFO  ] Still waiting for VDSM host to become operational...
      [ INFO  ] Still waiting for VDSM host to become operational...
      [ INFO  ] The VDSM Host is now operational
      [ INFO  ] Shutting down the engine VM
      [ INFO  ] Enabling and starting HA services
                Hosted Engine successfully set up
      [ INFO  ] Stage: Clean up
      [ INFO  ] Generating answer file '/var/lib/ovirt-hosted-engine-setup/answers/answers-20150527005531.conf'
      [ INFO  ] Generating answer file '/etc/ovirt-hosted-engine/answers.conf'
      [ INFO  ] Stage: Pre-termination
      [ INFO  ] Stage: Termination

#### Fully unattended setup

You could launch hosted-engine --deploy appending an answerfile; the setup should be fully automated.

      hosted-engine --deploy --config-append=/root/test.conf

Your answer file should look like:

      [environment:default]
      OVEHOSTED_CORE/screenProceed=none:None
      OVEHOSTED_CORE/deployProceed=bool:True
      OVEHOSTED_CORE/confirmSettings=bool:True
      OVEHOSTED_NETWORK/fqdn=str:topolino.localdomain
      OVEHOSTED_NETWORK/bridgeName=str:ovirtmgmt
      OVEHOSTED_NETWORK/firewallManager=str:iptables
      OVEHOSTED_NETWORK/gateway=str:192.168.1.1
      OVEHOSTED_ENGINE/clusterName=str:Default
      OVEHOSTED_STORAGE/storageDatacenterName=str:hosted_datacenter
      OVEHOSTED_STORAGE/domainType=str:nfs4
      OVEHOSTED_STORAGE/glusterBrick=none:None
      OVEHOSTED_STORAGE/imgAlias=str:hosted_engine
      OVEHOSTED_STORAGE/LunID=none:None
      OVEHOSTED_STORAGE/imgSizeGB=int:10
      OVEHOSTED_STORAGE/iSCSIPortalIPAddress=none:None
      OVEHOSTED_STORAGE/iSCSITargetName=none:None
      OVEHOSTED_STORAGE/glusterProvisionedShareName=str:hosted_engine_glusterfs
      OVEHOSTED_STORAGE/iSCSIPortalPort=none:None
      OVEHOSTED_STORAGE/storageDomainName=str:hosted_storage
      OVEHOSTED_STORAGE/glusterProvisioningEnabled=bool:False
      OVEHOSTED_STORAGE/iSCSIPortal=none:None
      OVEHOSTED_STORAGE/storageType=none:None
      OVEHOSTED_STORAGE/storageDomainConnection=str:192.168.1.115:/Virtual/exthe7
      OVEHOSTED_STORAGE/iSCSIPortalUser=none:None
      OVEHOSTED_VDSM/consoleType=str:vnc
      OVEHOSTED_VM/vmMemSizeMB=str:4096
      OVEHOSTED_VM/vmMACAddr=str:00:16:3e:1e:02:c1
      OVEHOSTED_VM/emulatedMachine=str:pc
      OVEHOSTED_VM/vmBoot=str:disk
      OVEHOSTED_VM/vmVCpus=str:4
      OVEHOSTED_VM/ovfArchive=str:/mnt/ovirt.ova
      OVEHOSTED_VM/vmCDRom=none:None
      OVEHOSTED_VM/automateVMShutdown=bool:True
      OVEHOSTED_VM/cloudinitInstanceDomainName=str:localdomain
      OVEHOSTED_VM/cloudinitExecuteEngineSetup=bool:True
      OVEHOSTED_VM/cloudinitInstanceHostName=str:topolino.localdomain
      OVEHOSTED_VM/cloudinitVMStaticCIDR=str:192.168.1.184/24
      OVEHOSTED_VM/cloudInitISO=str:generate
      OVEHOSTED_VM/cloudinitVMETCHOSTS=bool:True
      OVEHOSTED_VM/cloudinitVMDNS=str:192.168.1.1,8.8.8.8
      OVEHOSTED_VDSM/spicePkiSubject=str:O=localdomain, CN=c71ghe1.localdomain
      OVEHOSTED_VDSM/pkiSubject=str:/C=EN/L=Test/O=Test/CN=Test
      OVEHOSTED_VDSM/caSubject=str:/C=EN/L=Test/O=Test/CN=TestCA
      OVEHOSTED_VDSM/cpu=str:model_SandyBridge
      OVEHOSTED_NOTIF/smtpPort=str:25
      OVEHOSTED_NOTIF/smtpServer=str:localhost
      OVEHOSTED_NOTIF/sourceEmail=str:root@localhost
      OVEHOSTED_NOTIF/destEmail=str:root@localhost
      OVEHOSTED_VM/cloudinitRootPwd=str:yourtestpwd
      OVEHOSTED_ENGINE/adminPassword=str:yourtestpwd
      OVEHOSTED_ENGINE/appHostName=str:hosted_engine_1

On each run hosted-engine-setup will generate its corresponded answerfile; please not that it will not include the latest three lines of this example (so you need to add them if you want a fully automated setup) and it will include all the storage related UUID which could be randomly generated on a fresh setup. Simply add 'OVEHOSTED_VM/cloudinitRootPwd=str:' if you want to skip the question regarding the appliance root password but you don't want to set one.

#### Additional Notes

If you are going to test is using a virtual machine for the host creating a nested virtual machine for the engine VM, please:

*   Enable nested virtualization on the external hypervisor
*   Disable no-mac-spoof filter on the external hypervisor; if you are using oVirt as your external hypervisor

### Contingency Plan

None

### Release Notes

      == oVirt Hosted-engine appliance flow ==
      An easy and quick way to deploy oVirt hosted-engine configuring an almost ready to use appliance.



