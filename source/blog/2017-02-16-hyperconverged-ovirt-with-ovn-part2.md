---
title: HyperConverged oVirt (GlusterFS) with OVN (OpenVSwitch + OpenFlow + Tunnels) provider (part 2)
author: stirabos
tags: community, documentation, howto, glusterfs, gluster, hyperconverged, hyper-converged, hosted-engine, OVN, SDN, demo, cockpit
date: 2017-02-16 21:00:00 CET
comments: true
published: false
---

How-to build a demo env for HyperConverged oVirt with OVN (part 2).

In part 1 we deployed an hyper-converged GlusterFS based ovirt cluster, now we'll see how to add the OVN provider to this setup.

## oVirt OVN Provider

OVN - Open Virtual Network - is an OVS (Open vSwitch) extension, adding support for virtual networks abstraction. It adds native OVS support for virtual L2 and L3 overlays. The oVirt OVN Provider allow using OVN provided networks from within oVirt, using the external network provider mechanism. We will be able to use/define OVN logical networks from within oVirt, and provision virtual machines with network interfaces connected to the OVN networks.

The oVirt OVN Provider is composed by *ovirt-provider-ovn* to be installed on a central system (the engine VM is our best option for our simple scenario) and *ovirt-provider-ovn-driver* to be installed on each of the involved hosts.
The ovirt-provider-ovn requires openvswitch-ovn-central which provides the OVN Northbound DB (contains the high level logical network configuration) - and the OVN Southbound DB (contains the physical network view) plus the required daemons to translate data and requests.
The ovirt-provider-ovn and openvswitch-ovn-central are required to define and edit logical network configuration but they are not required for the routing process which is instead distributed in the OVN world so they are not a single points of failure.

oVirt cannot yet directly install and configure ovirt-provider-ovn and ovirt-provider-ovn-driver so manual actions are required today to install and configure them; for simplicity we are now going to disable the firewall on the engine VM and on the hosts. A proper install mechanism and automated handling of the required firewall rules will come in one of the next minor releases.

On the engine VM:
```
# stop the firewall
systemctl stop firewalld
systemctl disable firewalld
# install ovirt-provider-ovn
yum install -y ovirt-provider-ovn
systemctl start ovirt-provider-ovn
systemctl enable ovirt-provider-ovn
```
On the hosts:
```
# stop the firewall
systemctl stop iptables
systemctl disable iptables
# install ovirt-provider-ovn-driver
yum install -y ovirt-provider-ovn-driver
systemctl start ovn-controller
systemctl enable ovn-controller
```
Now we have to create a tunnel to transport our overlay network traffic; VDSM already provides an helper command for that:
```
# vdsm-tool ovn-config <OVN central server IP> <local IP used for OVN tunneling>
# host 1:
vdsm-tool ovn-config 192.168.1.200 192.168.1.201
# host 1:
vdsm-tool ovn-config 192.168.1.200 192.168.1.202
# host 1:
vdsm-tool ovn-config 192.168.1.200 192.168.1.203
```
Please note that for simplicity in this demo env we are going to transport all or our overlay traffic over the management network but on a production system is by far better to use a dedicated network for it.

We can check the result running ovn-sbctl on the engine VM to check the status of OVN Southbound DB:
```
[root@enginevm ~]# ovn-sbctl show
Chassis "bd4c1830-c6c3-46cc-8719-c09dab301489"
    hostname: "demovm1.localdomain"
    Encap geneve
        ip: "192.168.1.201"
        options: {csum="true"}
Chassis "9e00a22e-e702-4d2f-a564-8f5e534eff9a"
    hostname: "demovm3.localdomain"
    Encap geneve
        ip: "192.168.1.203"
        options: {csum="true"}
Chassis "f67680d4-7237-49cf-b424-31ee9850444b"
    hostname: "demovm2.localdomain"
    Encap geneve
        ip: "192.168.1.202"
        options: {csum="true"}
```
and ovs-vsctl on each host to check the status of its OVS instance:
```
[root@demovm3 ~]# ovs-vsctl show
02e92c60-7f52-419f-9b08-6b83c4617f42
    Bridge br-int
        fail_mode: secure
        Port br-int
            Interface br-int
                type: internal
        Port "ovn-bd4c18-0"
            Interface "ovn-bd4c18-0"
                type: geneve
                options: {csum="true", key=flow, remote_ip="192.168.1.201"}
        Port "ovn-f67680-0"
            Interface "ovn-f67680-0"
                type: geneve
                options: {csum="true", key=flow, remote_ip="192.168.1.202"}
    ovs_version: "2.6.90"
```
Now we are ready to add our oVirt OVN Provider in the engine as an external network provider.
In the cluster property form keep the *switch type* to LEGACY as in picture 20:
![2017-02-16-hyperconverged-ovirt-with-ovn-picture20.png](2017-02-16-hyperconverged-ovirt-with-ovn-picture20.png "2017-02-16-hyperconverged-ovirt-with-ovn-picture20.png")
Go to the external provider tab, select add provider and enter 'OVN' as *Name* field, 'External network provider' as *Type* and 'http://localhost:9696' as *Provider URL* since the external provider is running on the engine VM as well. Proceed as in picture 21.
Please note that for this simplistic demo env we are going to skip the provider authentication mechanism while a proper mechanism is strongly advised for production systems.
![2017-02-16-hyperconverged-ovirt-with-ovn-picture21.png](2017-02-16-hyperconverged-ovirt-with-ovn-picture21.png "2017-02-16-hyperconverged-ovirt-with-ovn-picture21.png")
Now let's create our first OVN network:
let's go to the network tab on the default datacenter and choose new.
In the 'Create on external provider' select *Create on external provider* and 'OVN' in the *External provider* field.
Set 'demo_n1' as *Name* as in picture 22. In the subnet tab select *Create subnet* and choose 'demo_sn1' as its name, '172.16.1.0/24' as its *CIDR* and '172.16.1.1' as *Gateway* and *DNS Servers* as for picture 23.
![2017-02-16-hyperconverged-ovirt-with-ovn-picture22.png](2017-02-16-hyperconverged-ovirt-with-ovn-picture22.png "2017-02-16-hyperconverged-ovirt-with-ovn-picture22.png")
![2017-02-16-hyperconverged-ovirt-with-ovn-picture23.png](2017-02-16-hyperconverged-ovirt-with-ovn-picture23.png "2017-02-16-hyperconverged-ovirt-with-ovn-picture23.png")
Check the result on the engine VM:
```
[root@enginevm ~]# ovn-nbctl show
    switch f1fb3802-6980-4adc-a60f-33e13663da06 (demo_n1)
[root@enginevm ~]# ovn-nbctl dhcp-options-list
e3054f60-a748-4756-8c1b-347a8e9a492f
[root@enginevm ~]# ovn-nbctl dhcp-options-get-options e3054f60-a748-4756-8c1b-347a8e9a492f
server_mac=02:00:00:00:00:00
router=172.16.1.1
server_id=172.16.1.0
dns_server=172.16.1.1
lease_time=86400
```
Let's create two VMs and attach them to our logical network.
The easiest way is to go to the storage main tab, select ovirt-image-repository glance external provider and import a ready to use cloud image as in picture 24
![2017-02-16-hyperconverged-ovirt-with-ovn-picture24.png](2017-02-16-hyperconverged-ovirt-with-ovn-picture24.png "2017-02-16-hyperconverged-ovirt-with-ovn-picture24.png")
Once the VM template got imported from the oVirt glance provider, we can create a couple of VMs from that template.
Choose the template, set a VM *Name*, attach it to our *OVN network* and configure the *hostname* and the *initial root password* via cloud-init in the *initial run* tab (hit *Show advanced options* if it's not visible) as for pictures 25, 26, 27.
![2017-02-16-hyperconverged-ovirt-with-ovn-picture25.png](2017-02-16-hyperconverged-ovirt-with-ovn-picture25.png "2017-02-16-hyperconverged-ovirt-with-ovn-picture25.png")
![2017-02-16-hyperconverged-ovirt-with-ovn-picture26.png](2017-02-16-hyperconverged-ovirt-with-ovn-picture26.png "2017-02-16-hyperconverged-ovirt-with-ovn-picture26.png")
![2017-02-16-hyperconverged-ovirt-with-ovn-picture27.png](2017-02-16-hyperconverged-ovirt-with-ovn-picture27.png "2017-02-16-hyperconverged-ovirt-with-ovn-picture27.png")
Repeat this for the second VM and start them.
Connect to the two VMs using their spice console and note that each VM:
* got an address from the DHCP instance we configured
* is able to ping the other VM
* is not able to ping a gateway or router on the first address of the subnet since we still don’t have one
Check picture 28:
![2017-02-16-hyperconverged-ovirt-with-ovn-picture28.png](2017-02-16-hyperconverged-ovirt-with-ovn-picture28.png "2017-02-16-hyperconverged-ovirt-with-ovn-picture28.png")
Let's add our first OVN logical router and connect it to our demo_n1 switch:
```
[root@enginevm ~]# # add first logical router
[root@enginevm ~]# ovn-nbctl lr-add lr1
[root@enginevm ~]# # add a port to the logical router
[root@enginevm ~]# ovn-nbctl lrp-add lr1 lr1_p_demo_n1 02:ac:10:ff:01:93 172.16.1.1/24
[root@enginevm ~]# # add a port to the logical switch of our external net
[root@enginevm ~]# ovn-nbctl lsp-add demo_n1 demo_n1-lr1
[root@enginevm ~]# ovn-nbctl lsp-set-type demo_n1-lr1 router
[root@enginevm ~]# ovn-nbctl lsp-set-addresses demo_n1-lr1 02:ac:10:ff:01:93
[root@enginevm ~]# ovn-nbctl lsp-set-options demo_n1-lr1 router-port=lr1_p_demo_n1
[root@enginevm ~]# 
[root@enginevm ~]# ovn-nbctl show
    switch f1fb3802-6980-4adc-a60f-33e13663da06 (demo_n1)
        port 25419b09-acc9-4eea-8103-d82e328a9573
            addresses: ["00:1a:4a:16:01:51 dynamic"]
        port demo_n1-lr1
            addresses: ["02:ac:10:ff:01:93"]
        port e0f66284-2919-4d29-8eb0-633385c76d21
            addresses: ["00:1a:4a:16:01:52 dynamic"]
    router c9da6a63-901c-4482-881e-2d81e36dcd28 (lr1)
        port lr1_p_demo_n1
            mac: "02:ac:10:ff:01:93"
            networks: ["172.16.1.1/24"]
```
Now our VMs can ping our logical router, check picture 29:
![2017-02-16-hyperconverged-ovirt-with-ovn-picture29.png](2017-02-16-hyperconverged-ovirt-with-ovn-picture29.png "2017-02-16-hyperconverged-ovirt-with-ovn-picture29.png")

While OVN already supports distributed switching, distributed routing and distributed DHCP server it currently doesn't support distributed NAT but this is going to come with OVN 2.7 in a near future.
Currently the the best option to achieve nat capability is to bind an OVN gateway router to one of the hosts but this introduces a single point of failure for the external traffic of all the VMs. Please follow this post for detailed explanation about OVN gateway router.
[The OVN Gateway Router](http://blog.spinhirne.com/2016/09/the-ovn-gateway-router.html)
