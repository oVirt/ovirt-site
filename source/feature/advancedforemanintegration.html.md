---
title: AdvancedForemanIntegration
authors: moti, ovedo, ybronhei
wiki_title: Features/AdvancedForemanIntegration
wiki_revision_count: 47
wiki_last_updated: 2014-11-10
---

# Advanced Foreman Integration

### Summary

[Foreman](http://theforeman.org/) [1] The Foreman is a complete lifecycle management tool for physical and virtual servers. Through deep integration with configuration management, DHCP, DNS, TFTP, and PXE-based unattended installations, Foreman manages every stage of the lifecycle of your physical or virtual servers. The Foreman provides comprehensive, auditable interaction facilities including a web frontend and robust, RESTful API. [Cloud-init](https://launchpad.net/cloud-init/) [1] is a tool used to perform initial setup on cloud nodes, including networking, SSH keys, timezone, user data injection, and more. It is a service that runs on the guest, and supports various Linux distributions including Fedora, RHEL, and Ubuntu.

Integrating Foreman with oVirt will help adding hypervisor hosts that are managed by Foreman to the oVirt engine (installed hosts, discovered hosts, etc.) VM configuration and etc.

Today, there is basic Foreman integration, described in [2], which allows the administrator to see hosts installed in Foreman, and get their basic details. This feature aims to extend this integration to cover other aspects such as Bare-Metal provisioning, VM provisioning and Host configuration.

### Owners

*   Name: Yaniv Bronheim
*   Email: ybronhei@redhatdotcom
*   Name: Oved Ourfali
*   Email: ovedo@redhatdotcom

### Current Status

*   Integrated fully in oVirt-3.5 as tech preview feature. Currently tested.
*   In enhancements and bug fixes phase
*   Using Foreman 1.6

### Detailed Description

#### Use Cases

*   The following use-cases assume you already have a Foreman provider in the system. For more information on adding Foreman providers have a look at [2].
*   Foreman setup must include the following plugins (for plugin installation guide follow [3]):

      * `[`https://github.com/theforeman/ovirt_provision_plugin`](https://github.com/theforeman/ovirt_provision_plugin)` (>=0.0.1)- Allows full integration with oVirt after provisioning new host
      * `[`https://github.com/theforeman/foreman_discovery`](https://github.com/theforeman/foreman_discovery)` (>=1.3.0.rc2)- Foreman pack for bare metal discovery feature

For yum installation perform:

`* yum -y install `[`http://yum.theforeman.org/releases/1.5/el6/x86_64/foreman-release.rpm`](http://yum.theforeman.org/releases/1.5/el6/x86_64/foreman-release.rpm)
      * Enable foreman-nightly and foreman-plugins-nightly repositories (for foreman < 1.5.2)
      * yum -y install ruby193-rubygem-ovirt_provision_plugin ruby193-rubygem-foreman_discovery foreman-ovirt

      [TODO: remove this section when plugin gets to official repo] Currently you can use:
[`http://yum.theforeman.org/plugins/nightly/el6/x86_64/ruby193-rubygem-ovirt_provision_plugin-0.0.1-1.el6.noarch.rpm`](http://yum.theforeman.org/plugins/nightly/el6/x86_64/ruby193-rubygem-ovirt_provision_plugin-0.0.1-1.el6.noarch.rpm)
`The plugin requires also rbovirt updates, which can be found in: `[`http://yum.theforeman.org/nightly/el6/x86_64/ruby193-rubygem-rbovirt-0.0.28-1.el6.noarch.rpm`](http://yum.theforeman.org/nightly/el6/x86_64/ruby193-rubygem-rbovirt-0.0.28-1.el6.noarch.rpm)

##### First phase - Bare-Metal provisioning

Prerequisites:

*   Foreman admin has a designated host group(s) in foreman for that purpose to define full provision setup with default values
*   Have the proper images for the OS installation setup in the foreman setup
*   Correlate the defined Host group with relevant templates (PXE / kickstart files) associated to the relevant OSs

* For oVirt Node provisioning also provide appropriate cmdline arguments inside the PXE provision template, such as:

      append initrd=<%= @initrd %> ks=<%= foreman_url('provision')%> root=live:/[filename].iso BOOTIF=link storage_init rhevm_admin_password=123 adminpw=123 management_server=[ip]:[port] rootfstype=auto ro liveimg check RD_NO_LVM rd_NO_MULTIPATH rootflags=ro crashkernel=128M elevator=deadline quiet max_loop=256 rhgb rd_NO_LUKS rd_NO_MD rd_NO_DM ONERROR LOCALBOOT 0 

*   oVirt needs proper permissions to view relevant bare-metal hosts, host groups, compute resources and execute provision request.
*   Set Foreman's compute resource that correlates to the required permissions (Availability to approve and add host by custom plugin. For more information about Foreman plugin see [3])
*   Define puppet class for installing oVirt-Engine public key to allow deploy oVirt on provisioned host (locate them under /usr/share/puppet/modules)

* For example:

      class ovirt_pk {                                                                
             # create a directory                                                    
             file { "/root/.ssh":                                                    
                     ensure => "directory",                                          
                     before => File['/root/.ssh/authorized_keys'],                   
             }                                                                       
             file { "/root/.ssh/authorized_keys":                                    
                     path => '/root/.ssh/authorized_keys',                           
                     ensure => file,                                                 
                     source => "puppet:///modules/ovirt-pk/authorized_keys",         
             }                                                                       
      }   

<big>**User-flow:**</big>
![](Discover-1-phase.png "fig:Discover-1-phase.png")
![](Discover-2-phase.png "fig:Discover-2-phase.png")
![](Discover-3-phase.png "fig:Discover-3-phase.png")
# Add new host form in oVirt shows new list of discovered hosts taken from Foreman

1.  Select a host group for this host. all proper configuration needs to be declared in host group definition (part of Foreman setup)
2.  Select compute resource to allow access back from Foreman to oVirt (part of Foreman setup)
3.  All "discovered" information will filled out in the new host form, edit them as desired

![](discoverUIexample.png "fig:discoverUIexample.png") ![](Discover-4-phase.png "fig:Discover-4-phase.png") ![](Discover-5-phase.png "fig:Discover-5-phase.png") the following system flow will occur:

1.  add the host to foreman using the API (Provision the discovered host)
2.  The host will be added and appear in the oVirt UI with status "Installing OS" util the following ends:
    1.  For oVirt-node hosts - the registration will occur through the oVirt-node (assuming the kernel parameters are configured for that Foreman template), and the host will be approved automatically by Foreman
    2.  For other OS - at first step won't do the registration by themselves, but foreman will do that using a plugin (plugin will send REST-API call to add or approve the host)

![](installingOSExample.png "installingOSExample.png")

Open issues:

##### Second phase - VM provisioning - add new VMs which will be configured by Foreman

We have two options here: a. Add the VM through oVirt, and then add it to Foreman as bare-metal (add the oVirt compute resource) - only PXE installation, passing the MAC address to foreman b. Add the VM through foreman (using compute resource)

I'd go with option "a", as it leaves the VM creation similar to what we have today. However, we don't really leverage oVirt templates with that approach.

### Benefit to oVirt

*   Better integration with external host providers, that will ease the work for the administrator
*   Providing an interface that other host providers can implement, to add their own properties and logic

### Setup Testing Environment

To allow testing the feature in "allinone" configuration, which means running foreman on a VM and simulate new bare-metal hosts with new VMs, you should configure the following on your hypervisor: (NOTE: This manual set the foreman subnet to 192.168.223.0, which 192.168.223.2 is the foreman VM address and 192.168.223.1 is the gateway to the external network)

*   Enable IP forwarding

      Edit /etc/sysctl.conf and set "net.ipv4.ip_forward = 1"

*   Create virt network

      save the following to file called foreman_net.xml:
` `<network>
`  `<name>`foreman`</name>
`   `<uuid>`3a80901c-a020-4e7a-bd3b-770b29844b03`</uuid>
`   `<forward mode='nat'>
`   `<nat>
`    `<port start='1024' end='65535'/>
`   `</nat>
`   `</forward>
`   `<bridge name='virbrforeman' stp='off' delay='0'/>
`    `<mac address='52:54:00:38:f9:08'/>
`    `<ip address='192.168.223.1' netmask='255.255.255.0'></ip>
` `</network>

*   Set the network to virsh

      # virsh - vdsm@ovirt:shibboleth
      # net-define /path/to/foreman_net.xml
      # net-autostart foreman
      # net-start foreman 
      With "ip -4 a" you should see that virbrforeman has the right ip

*   Config engine

      #engine-config -s CustomDeviceProperties='{type=interface;prop={extnet=^[a-zA-Z0-9_ ---]+$}}'
      #engine-config -g CustomDeviceProperties
      ( You can read about it under vdsm_hooks/*extnet*/README )

*   Install the vdsm-hook-extnet rpm on host
*   Add the host to engine if its not already there
*   Create route rule on host

       ip route add 192.168.223.0/24 scope link dev virbrforeman table 170066347
      (The number of table depends on your dhcp assigned address. You can check for yours by:  "ip rule show")

*   Configure oVirt

      Go to the Networks tab
      click on "ovirtmgmt"
      then on the "vNIC Profiles" subtab
      New -> name: foreman_libvirt_net ->  in "please select a key" select extnet and put "foreman" as value

*   Set foreman Vm network by running

      ip addr add dev eth0 192.168.223.2/24
      ip link set dev eth0 up
      ip route add dev eth0 default via 192.168.223.1

### Make Foreman Appliance

[The following includes for instructions to make your own simple foreman's env with discovery abilities. Later we plan to have public template for this appliance][BR]

*   I would suggest to do it all in a libvirt environment for testing, unless you have switch and few physical hosts for this test
*   if you use virt-manager : set isolated network with virt manager and create NAT to em1 on you physical hosts in ovirt -> create another network, separted from the ovirtmgmt all the machine will be connected to this isolate network and will get connection outside by the host itself as default gw
*   install on one machine centos 6.5- don't create user foreman. leave only root user
*   set static ip in this network. copy /etc/resolve.conf from the physical host that runs the vm and set this host as the default gw.
*   set epel repo: wget <http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm> , rpm -ivh epel-release-6-8.noarch.rpm
*   install foreman on it: yum -y install <http://yum.theforeman.org/releases/1.6/el6/x86_64/foreman-release.rpm> , yum -y install foreman-installer
*   run: foreman-installer -i (enable all ovirt related stuff - you can always re-run it. so don't worry about mistakes)
*   go to foreman web interface - change admin password
*   In the WebUI: Go to infrastructure -> provisioning setup -> follow the guide and configure and dns and dhcp by the foreman-installer command that the foreman suggested (see [1])
*   Run the installer with the desired configuration
*   Install the ovirt provision plugin: yum -y install ruby193-rubygem-ovirt_provision_plugin
*   Install the discovery images: foreman-installer --foreman-plugin-discovery-install-images=true (see also [1])
*   Go to the ui again ->Hosts->Provisioning Templates-> find PXELinux global default and add there in the end :

        LABEL discovery
        MENU LABEL Foreman Discovery 
        MENU DEFAULT
        KERNEL boot/foreman-discovery-image-latest.el6.iso-vmlinuz
        APPEND rootflags=loop initrd=boot/foreman-discovery-image-latest.el6.iso-img  root=live:/foreman.iso rootfstype=auto ro rd.live.image rd.live.check rd.lvm=0 rootflags=ro crashkernel=128M elevator=deadline max_loop=256 rd.luks=0 rd.md=0 rd.dm=0 nomodeset selinux=0 stateless foreman.url=`[`https://192.168.100.2`](https://192.168.100.2)` <-- here put the foreman's ip
        IPAPPEND 2

        And change - ONTIMEOUT discovery

*   Go back to Host->Provisioning Templates and click on "Build PXE defaults"
*   Stop the iptables on your foreman machine - [iptables -F]
*   Now run new host in the same network and you'll see the discovery screen. when this host\\vm will finish to boot you should see new entery in the Hosts->Discovered Hosts page
*   If you'll add this foreman server as external provider to ovirt, you will be able to see discovered host in the add host tab and follow the instructions above.

[1] you might need to stop foreman-tasks - service foreman-tasks stop - sometimes without stopping this service the installer will fail

### Dependencies / Related Features

### Documentation / External References

1.  Foreman homepage: <http://theforeman.org/>
2.  Basic Foreman integration feature page : <http://ovirt.org/Features/ForemanIntegration>
3.  Foreman plugin examples: <http://projects.theforeman.org/projects/foreman/wiki/How_to_Create_a_Plugin>

### Known issues for followup

*   <http://projects.theforeman.org/issues/5781>

### Comments and Discussion

*   Refer to [Talk:Advanced Foreman Integration](Talk:Advanced Foreman Integration)
