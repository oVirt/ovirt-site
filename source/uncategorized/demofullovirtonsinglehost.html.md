---
title: DemoFullOvirtOnSingleHost
authors: mburns
wiki_title: DemoFullOvirtOnSingleHost
wiki_revision_count: 1
wiki_last_updated: 2012-11-30
---

# DemoFullOvirtOnSingleHost

This is my summary of setting up a full demo oVirt environment on a single host using virtual machines and nested virtualization.

### Overview

The overall layout of the will include 4 virtual machines. The machines will be isolated from the rest of the world with a single vm acting as a gateway.

### Virtual Machines

*   Infrastructure
    -   Provides DNS, DHCP, IPA (optional)
    -   Acts as a gateway to the world
*   Engine
    -   Runs oVirt Engine
*   Host1, Host2
    -   Hosts for running Virtual machines

### Recommended Host Configuration

My machine has 16GB RAM and a dedicated 250GB SSD. You could conceivable run with less disk space and less RAM, but it will limit what you can demo and run.

I am running the latest Fedora 17, though I've also done this with Fedora 16 and RHEL 6 [1] installs.

[1] Nested virtualization for Intel is not supported in the RHEL 6 kernel as of 6.3. You need to use either AMD or use Fedora.

### Base Host Configuration

#### Configure Nested Virtualization on the Host

For Intel:

      echo "options kvm_intel nested=Y" > /etc/modprobe.d/kvm.conf

For AMD:

It should already be configured, but to check look at:

      cat /sys/module/kvm_amd/parameters/nested

The value should be "1"

If you needed to make a change, you may need to either modprobe the appropriate module or reboot the host.

#### Configure Routes on base machine to make private network routeable

      sudo route add -net 192.168.130.0/24 gw 192.168.122.10

NOTE: 192.168.122.10 should be the ip address of the infrastructure vm on the default libvirt network. NOTE2: You have to do this every time you reboot the base host. It may make sense to add it to a script and run it when you startup.

### Create an isolated libvirt network

Add the following to a file, then run virsh net-define file.xml

    <network>
      <name>ovirt</name>
      <bridge name='ovirt' stp='on' delay='0' />
      <ip address='192.168.130.1' netmask='255.255.255.0'>
      </ip>
    </network>

### Create an infrastructure vm

*   RAM: 512 MB
*   OS: Fedora or RHEL (doesn't matter, I used RHEL)
*   NIC1: on default libvirt network
*   NIC2: on isolated oVirt network
*   Storage: 20GB

Configure network as static

#### Install and configure IPA(RHEL) or FreeIPA(Fedora) (optional)

\*# yum install ipa-server (RHEL) or # yum install freeipa-server (Fedora)

\*# ipa-server-install --setup-dns --forwarder=192.168.122.1

*   follow prompts to setup (I used domain demo.ovirt.private)

#### Setup DHCP

*   yum install dhcp
*   edit /etc/dhcp/dhcpd.conf with the following while replacing the MAC_ADDRESS entries with the correc entries

<!-- -->

    option domain-name "demo.ovirt.private";

    default-lease-time 3600;
    max-lease-time 7200;

    subnet 192.168.130.0 netmask 255.255.255.0 {
      range 192.168.130.51 192.168.130.99;
      option ip-forwarding off;
      option broadcast-address 193.168.130.0;
      option subnet-mask 255.255.255.0;
      option ntp-servers 192.168.130.2;
      option domain-name-servers 192.168.122.2;
      option routers 192.168.122.2;
    }
    host infra {
      hardware ethernet MAC_ADDRESS;
      fixed-address 192.168.130.2;
    }
    host engine {
      hardware ethernet MAC_ADDRESS;
      fixed-address 192.168.130.3;
    }
    host host1 {
      hardware ethernet MAC_ADDRESS;
      fixed-address 192.168.130.5;
    }
    host host2 {
      hardware ethernet MAC_ADDRESS;
      fixed-address 192.168.130.6;
    }

#### Setup DNS (if not using IPA)

I strongly suggest using system-config-bind to do this.

#### Configure hosts in DNS

*   system-config-bind if using named directly
*   IPA UI is good if you're using IPA

#### Configure the host as a router

Plenty of references out there. I followed [http://etutorials.org/Linux+systems/red+hat+linux+bible+fedora+enterprise+edition/Part+IV+Red+Hat+Linux+Network+and+Server+Setup/Chapter+16+Connecting+to+the+Internet/Setting+up+Red+Hat+Linux+as+a+Router/ this one](http://etutorials.org/Linux+systems/red+hat+linux+bible+fedora+enterprise+edition/Part+IV+Red+Hat+Linux+Network+and+Server+Setup/Chapter+16+Connecting+to+the+Internet/Setting+up+Red+Hat+Linux+as+a+Router/ this one)

### Create Engine and Host VMs

*   RAM: 4GB (Engine)/2GB (Hosts)
*   OS: Fedora
*   NIC1: on isolated oVirt network
*   Storage: 20GB

<!-- -->

*   You should be able to set the hosts to dhcp and be able to ping the internet if everything is setup correctly in the infra machine.

<!-- -->

*   default gateway should be 192.168.130.2
*   /etc/resolv.conf should include 192.168.130.2

### Enable Nested Virtualization on the VMS

*   Stop/Shutdown the host1 and host2 guests

<!-- -->

*   Run the following command on the bare metal host to get the right xml info:

      # virsh  capabilities | virsh cpu-baseline /dev/stdin` `copy and paste the output into the xml for your host1 and host2 guests using virsh edit

*   start the host1 and host2 guests again.
*   You should be able to modprobe kvm_intel or kvm_amd now.

### Install oVirt Engine

*   On the engine host:

      #yum install http://ovirt.org/releases/ovirt-release-fedora.noarch.rpm` `#yum install ovirt-engine` `#engine-setup

*   follow prompts to complete setup

### Configure Hosts

*   navigate a browser to engine.demo.ovirt.private/webadmin
*   use the add host flow to add host1 and host2 (they must be up and running)
*   The hosts will be added to the oVirt environment.

### Configure storage domains

*   On the base host or infrastructure vm, configure 2 NFS shares
*   Add one nfs share as a data storage domain to your oVirt DataCenter.
*   Add the other as an ISO storage domain to your DataCenter.
*   Add ISOS to your ISO storage domain and chmod 36:36 them

### Create VMs

*   Using the oVirt interface.
