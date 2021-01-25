---
title: Migrate to Hosted Engine
authors: didi
---

# Migrate to Hosted Engine

An example showing how to migrate an existing engine installation to [Self Hosted Engine](/develop/release-management/features/sla/self-hosted-engine.html), using [backup/restore](/develop/release-management/features/integration/engine-backup.html).

## Preparations

I had in the dns an A record 'ovirttest.home.local' and a CNAME record my-engine.home.local pointing to ovirttest.

I installed fedora 19 on a host (actually a VM) with hostname 'ovirttest'.

I installed, using the nightly repo, ovirt-engine on ovirttest, ran 'engine-setup', and input as FQDN for the engine 'my-engine.home.local'.

Now I wanted to migrate this installation to hosted engine.

## Hosted engine deploy - part one

I installed a new host with fedora 19, gave it hostname 'didi-box1.home.local'.

Installed on it hosted engine. On didi-box1, added the nightly repos, and then:

      # yum install ovirt-hosted-engine-setup

Now deploy it. On didi-box1:

      # hosted-engine --deploy
      [ INFO  ] Stage: Initializing
                Continuing will configure this host for serving as hypervisor and create a VM where oVirt Engine will be installed afterwards.
                Are you sure you want to continue? (Yes, No)[Yes]:
      [ INFO  ] Generating a temporary VNC password.
      [ INFO  ] Stage: Environment setup
                Configuration files: []
                Log file: /var/log/ovirt-hosted-engine-setup/ovirt-hosted-engine-setup-20131111142620.log
                Version: otopi-1.2.0_master (otopi-1.2.0-0.0.master.20131105.git6a17a76.fc19)
      [ INFO  ] Hardware supports virtualization
      [ INFO  ] Stage: Environment packages setup
      [ INFO  ] Stage: Programs detection
      [ INFO  ] Stage: Environment setup
      [ INFO  ] Stage: Environment customization
                --== STORAGE CONFIGURATION ==--
                During customization use CTRL-D to abort.
                Please specify the storage you would like to use (glusterfs, nfs)[nfs]:
                Please specify the full shared storage connection path to use (example: host:/path): didi-lap:/vm/he1
      [ INFO  ] Installing on first host
                Please provide storage domain name [hosted_storage]:
                Local storage datacenter name [hosted_datacenter]:
                --== SYSTEM CONFIGURATION ==--
                --== NETWORK CONFIGURATION ==--
                Please indicate a nic to set ovirtmgmt bridge on: (em1) [em1]:
                iptables was detected on your computer, do you wish setup to configure it? (Yes, No)[Yes]:
                Please indicate a pingable gateway IP address: 10.0.0.138
                --== VM CONFIGURATION ==--
                Please specify the device to boot the VM from (cdrom, disk, pxe) [cdrom]:
                The following CPU types are supported by this host:
                       - model_Westmere: Intel Westmere Family
                       - model_Nehalem: Intel Nehalem Family
                       - model_Penryn: Intel Penryn Family
                       - model_Conroe: Intel Conroe Family
                Please specify the CPU type to be used by the VM [model_Westmere]:
                Please specify path to installation media you would like to use [None]: /iso/Fedora-18-x86_64-netinst.iso
                Please specify the number of virtual CPUs for the VM [Defaults to minimum requirement: 2]:
                Please specify the disk size of the VM in GB [Defaults to minimum requirement: 25]:
                Please specify the memory size of the VM in MB [Defaults to minimum requirement: 4096]:
                Please specify the console type you would like to use to connect to the VM (vnc, spice) [vnc]:
                --== HOSTED ENGINE CONFIGURATION ==--
                Enter the name which will be used to identify this host inside the Administrator Portal [hosted_engine_1]:
                Enter 'admin@internal' user password that will be used for accessing the Administrator Portal:
                Confirm 'admin@internal' user password:
                Please provide the FQDN for the engine you would like to use. This needs to match the FQDN that you will use for the engine installation within the VM: my-engine.home.local
      [ INFO  ] Stage: Setup validation
                --== CONFIGURATION PREVIEW ==--
                Bridge interface                   : em1
                Engine FQDN                        : my-engine.home.local
                Bridge name                        : ovirtmgmt
                SSH daemon port                    : 22
                Firewall manager                   : iptables
                Gateway address                    : 10.0.0.138
                Host name for web application      : hosted_engine_1
                Host ID                            : 1
                Image size GB                      : 25
                Storage connection                 : didi-lap:/vm/he1
                Console type                       : vnc
                Memory size MB                     : 4096
                Boot type                          : cdrom
                Number of CPUs                     : 2
                ISO image (for cdrom boot)         : /iso/Fedora-18-x86_64-netinst.iso
                CPU Type                           : model_Westmere
                Please confirm installation settings (Yes, No)[No]: yes
      [ INFO  ] Generating answer file '/etc/ovirt-hosted-engine/answers.conf'
      [ INFO  ] Stage: Transaction setup
      [ INFO  ] Stage: Misc configuration
      [ INFO  ] Stage: Package installation
      [ INFO  ] Stage: Misc configuration
      [ INFO  ] Configuring libvirt
      [ INFO  ] Generating VDSM certificates
      [ INFO  ] Configuring VDSM
      [ INFO  ] Starting vdsmd
      [ INFO  ] Waiting for VDSM hardware info
      [ INFO  ] Configuring the management bridge
      [ INFO  ] Creating Storage Domain
      [ INFO  ] Creating Storage Pool
      [ INFO  ] Connecting Storage Pool
      [ INFO  ] Verifying sanlock lockspace initialization
      [ INFO  ] Initializing sanlock lockspace
      [ INFO  ] Initializing sanlock metadata
      [ INFO  ] Creating VM Image
      [ INFO  ] Disconnecting Storage Pool
      [ INFO  ] Start monitoring domain
      [ INFO  ] Configuring VM
      [ INFO  ] Updating hosted-engine configuration
      [ INFO  ] Stage: Transaction commit
      [ INFO  ] Stage: Closing up
      [ INFO  ] Creating VM
                You can now connect to the VM with the following command:
                      /bin/remote-viewer vnc://localhost:5900
                Use temporary password "0494DEVS" to connect to vnc console.
                Please note that in order to use remote-viewer you need to be able to run graphical applications.
                This means that if you are using ssh you have to supply the -Y flag (enables trusted X11 forwarding).
                Otherwise you can run the command from a terminal in your preferred desktop environment.
                If you cannot run graphical applications you can connect to the graphic console from another host or connect to the console using the following command:
                virsh -c qemu+tls://didi-box1/system console HostedEngine
                If you need to reboot the VM you will need to start it manually using the command:
                hosted-engine --vm-start
                You can then set a temporary password using the command:
`          hosted-engine --add-console-password=`<password>
                Please install the OS on the VM.
                When the installation is completed reboot or shutdown the VM: the system will wait until then

At this point I connected to the console of the new machine, using:

      % remote-viewer vnc://didi-box1:5900

and the temporary password shown above, and continued the installation of fedora 19 on the new VM. I configured its hostname to be 'he1vm.home.local'. When the installation finished, I pressed 'Reboot', and then, on the console where I ran 'hosted-engine --deploy' on didi-box1, I continued:

                Has the OS installation been completed successfully?
                Answering no will allow you to reboot from the previously selected boot media. (Yes, No)[Yes]:  
      [ INFO  ] Creating VM
                You can now connect to the VM with the following command:
                      /bin/remote-viewer vnc://localhost:5900
                Use temporary password "0494DEVS" to connect to vnc console.
                Please note that in order to use remote-viewer you need to be able to run graphical applications.
                This means that if you are using ssh you have to supply the -Y flag (enables trusted X11 forwarding).
                Otherwise you can run the command from a terminal in your preferred desktop environment.
                If you cannot run graphical applications you can connect to the graphic console from another host or connect to the console using the following command:
                virsh -c qemu+tls://didi-box1/system console HostedEngine
                If you need to reboot the VM you will need to start it manually using the command:
                hosted-engine --vm-start
                You can then set a temporary password using the command:
`          hosted-engine --add-console-password=`<password>
                Please install the engine in the VM, hit enter when finished.

## hosted engine deploy - part two

Now I connected to the vm with:

      % ssh root@he1vm.home.local

On he1vm, after enabling the ovirt nightly repo:

      # yum install ovirt-engine

### The cutoff point

Now suppose we are ready to do the cutoff. We stop the engine on the old machine, backup, restore on the new machine, and setup there. Note that running backup does not require the engine to be down, but we do not want users to make changes in the old machine that will not be copied to the new one. We also do not want both the old and the new engines to try and manage the same existing hosts and VMs.

On ovirttest, we stop the engine:

      # service ovirt-engine stop

We should also prevent the service from starting on a reboot. This can be done with

      # service ovirt-engine disable

for fedora 19, or, for el6 machines, with

      # chkconfig ovirt-engine off

We update our dns to point the name 'my-engine.example.com' to the IP address of the new VM 'he1vm'. Alternatively, if we did not have separate dns entries 'ovirttest' and 'my-engine', but just e.g. 'my-engine', we'll probably want to change the entry 'my-engine' to 'old-my-engine' and create a new entry 'my-engine' pointing at the address of 'he1vm'.

Then we backup, still on ovirttest:

      # engine-backup --mode=backup --file=backup1 --log=backup1.log

Copy backup1 from ovirttest to oe1vm. E.g., on ovirttest:

      # scp -p backup1 he1vm:

Then restore the backup using a database we already created on another machine. On he1vm:

      # engine-backup --mode=restore --file=backup1 --log=backup1-restore.log --change-db-credentials --db-host=didi-lap --db-user=engine --db-password --db-name=engine

This will require manual preparation work of configuring postgresql and creating a user/database if using a local database, which is the default. For more details see [backup/restore](/develop/release-management/features/integration/engine-backup.html).

This restores files and the database, but still does not start the service nor does other stuff which is normally done by setup.

Note that you can also create a local database and restore to it. You'll then still need to manually enable postgresql to start on reboot and open the firewall to be able to access it.

Next, run engine-setup. It will identify the existing files and database and do an "upgrade", including fixing around stuff that restore does not do. Still on he1vm:

      # engine-setup
      [ INFO  ] Stage: Initializing
      [ INFO  ] Stage: Environment setup
                Configuration files: ['/etc/ovirt-engine-setup.conf.d/10-packaging.conf', '/etc/ovirt-engine-setup.conf.d/20-setup-ovirt-post.conf']
                Log file: /var/log/ovirt-engine/setup/ovirt-engine-setup-20131111102015.log
                Version: otopi-1.2.0_master (otopi-1.2.0-0.0.master.20131105.git6a17a76.fc18)
      [ INFO  ] Stage: Environment packages setup
      [ INFO  ] Stage: Programs detection
      [ INFO  ] Stage: Environment setup
      [ INFO  ] Stage: Environment customization
                --== PACKAGES ==--
      [ INFO  ] Checking for product updates...
      [ INFO  ] No product updates found
                --== NETWORK CONFIGURATION ==--
                --== DATABASE CONFIGURATION ==--
                Using existing credentials
                --== OVIRT ENGINE CONFIGURATION ==--
                Skipping storing options as database already prepared
                --== PKI CONFIGURATION ==--
                PKI is already configured
                --== APACHE CONFIGURATION ==--
                --== SYSTEM CONFIGURATION ==--
                --== END OF CONFIGURATION ==--
      [ INFO  ] Stage: Setup validation
      [WARNING] Less than 16384MB of memory is available
      [ INFO  ] Cleaning stale zombie tasks
                --== CONFIGURATION PREVIEW ==--
                Database name                      : engine
                Database secured connection        : False
                Database host                      : didi-lap
                Database user name                 : engine
                Database host name validation      : False
                Datbase port                       : 5432
                NFS setup                          : False
                Firewall manager                   : firewalld
                Configure WebSocket Proxy          : False
                Host FQDN                          : my-engine.home.local
                Set application as default page    : True
                Configure Apache SSL               : True
                Please confirm installation settings (OK, Cancel) [OK]:
      [ INFO  ] Cleaning async tasks and compensations
      [ INFO  ] Checking the DB consistency
      [ INFO  ] Stage: Transaction setup
      [ INFO  ] Stopping engine service
      [ INFO  ] Stopping websocket-proxy service
      [ INFO  ] Stage: Misc configuration
      [ INFO  ] Fixing DB inconsistencies
      [ INFO  ] Stage: Package installation
      [ INFO  ] Stage: Misc configuration
      [ INFO  ] Backing up database to '/var/lib/ovirt-engine/backups/engine-20131111102210.hRulo6.sql'.
      [ INFO  ] Updating database schema
      [ INFO  ] Generating post install configuration file '/etc/ovirt-engine-setup.conf.d/20-setup-ovirt-post.conf'
      [ INFO  ] Stage: Transaction commit
      [ INFO  ] Stage: Closing up
                --== SUMMARY ==--
      [WARNING] Less than 16384MB of memory is available
                SSH fingerprint: A8:9D:9F:B0:0A:2A:35:FF:9C:D7:6D:92:1E:0B:4A:B4
                Internal CA A4:D1:D1:B0:97:02:5F:1D:08:ED:F0:43:F6:96:2F:54:03:AD:30:4A
                Web access is enabled at:
`              `[`http://my-engine.home.local:80/ovirt-engine`](http://my-engine.home.local:80/ovirt-engine)
`              `[`https://my-engine.home.local:443/ovirt-engine`](https://my-engine.home.local:443/ovirt-engine)
                --== END OF SUMMARY ==--
      [ INFO  ] Starting engine service
      [ INFO  ] Restarting httpd
      [ INFO  ] Generating answer file '/var/lib/ovirt-engine/setup/answers/20131111102241-upgrade.conf'
      [ INFO  ] Stage: Clean up
                Log file is located at /var/log/ovirt-engine/setup/ovirt-engine-setup-20131111102015.log
      [ INFO  ] Stage: Pre-termination
      [ INFO  ] Stage: Termination
      [ INFO  ] Execution of upgrade completed successfully

Then we go back to the console where we ran 'hosted-engine --deploy', on didi-box1:

                Please install the engine in the VM, hit enter when finished.
      [ INFO  ] Engine replied: DB Up!Welcome to Health Status!
      [ INFO  ] Waiting for the host to become operational in the engine. This may take several minutes...
      [ INFO  ] The VDSM Host is now operational
                Please shutdown the VM allowing the system to launch it as a monitored service.
                The system will wait until the VM is down.

Now we go back to he1vm and reboot it. On he1vm:

      # reboot

Then, on the console where we ran 'hosted-engine --deploy', on didi-box1:

                The system will wait until the VM is down.
      [ INFO  ] Enabling and starting HA services
                Hosted Engine successfully set up
      [ INFO  ] Stage: Clean up
      [ INFO  ] Stage: Pre-termination
      [ INFO  ] Stage: Termination

That's it. If we now point a browser at **https://my-engine.home.local/ovirt-engine/** , we can login to the web admin interface, and in addition to our existing data, we'll also find a host called 'hosted_engine_1' and a VM called 'HostedEngine'.
