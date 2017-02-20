---
title: HyperConverged oVirt (GlusterFS) with OVN (OpenVSwitch + OpenFlow + Tunnels) provider (part 1)
author: stirabos
tags: community, documentation, howto, glusterfs, gluster, hyperconverged, hyper-converged, hosted-engine, OVN, SDN, demo, cockpit
date: 2017-02-16 21:00:00 CET
comments: true
published: false
---

How-to build a demo env for HyperConverged oVirt with OVN (part 1).

In this tutorial I'm going to provide the instructions to deploy a test environment from scratch to try out the newest oVirt 4.1 features.
The idea is to keep everything as simple as possible to let you simply deploy a demo env to get in touch with new features.
A production deployment requires more cares: in particular for this demo environment we are going to:
* Use just /etc/hosts instead of relying on a properly configured DHCP and DNS infrastructure which is instead strongly recommended for a production system.
* Use a single network for management, storage and OVN transport: using separated network is strongly recommended for production systems; to achieve the best performance on the storage side we recommend a 10GbE.
The advantage of this simplistic approach is that in less than a couple of hours you are able to set up from scratch a  rich environment to get in touch with the new features of 4.1 without many hassles. 

## Background

* [oVirt](http://www.ovirt.org/) is a free, open-source virtualization management platform. A typical deployment is composed by one or more virtualization hosts and a central engine that manages them. The engine can run on a VM hosted by the hosts that it's managing, this setup is called **hosted-engine**.
* [GlusterFS](http://www.gluster.org/) is a free and open source scalable network file-system. Using common off-the-shelf hardware, you can create a large and distributed storage solution for your virtualization needs. If you run GlusterFS to save your VMs on the same hosts you are using to run them, you have an **HyperConverged setup**.
* OVN, **Open Virtual Network**, is part of the [Open vSwitch (OVS)](http://openvswitch.org/) project: it complements the existing capabilities of OVS to add native support for virtual network abstractions, such as virtual L2 and L3 overlays and security groups. Since release 4.1, oVirt ships an OVN provider to be used to consume and manage OVN networks from oVirt.
* [Cockpit](http://www.cockpit-project.org/) is an **interactive web-based server admin interface**.

In this tutorial we'll see how to deploy a test environment deploying oVirt hosted-engine in an hyper-converged way consuming OVN networks; the deployment will be mainly performed in a graphical way using Cockpit.

## Prerequisites

* Three hosts (or three VMs enabling the nested virtualization support on your physical host) called also nodes; each node should have at least 6 GB of RAM, two disks (20GB for local storage and 200GB for GlusterFS) and single nic (three nics with 10GbE for the storage network are strongly advised for production systems).
* Each node should be installed with a fully updated CentOS-7 (1611).
* For simplicity we avoid requiring DNS and DHCP infrastructure although they are strongly recommended for production deployments. In this tutorial we'll simply use static IPv4 addressing and /etc/hosts manually synchronized on all the hosts to resolve the hostnames. The naming schema we are going to use is:
```
192.168.1.200 enginevm.localdomain enginevm
192.168.1.201 demovm1.localdomain demovm1
192.168.1.202 demovm2.localdomain demovm2
192.168.1.203 demovm3.localdomain demovm3
```
'enginevm.localdomain' is the hostname we are going to use for the virtual machine we are going to create for the engine; 'demovm{1,2,3}.localdomain' are the hostnames we are going to use on our three hosts.

## Initial steps

Fill /etc/hosts on all the three hosts:
```
# Add hosts to /etc/hosts
cat <<EOF >> /etc/hosts
192.168.1.200 enginevm.localdomain enginevm
192.168.1.201 demovm1.localdomain demovm1
192.168.1.202 demovm2.localdomain demovm2
192.168.1.203 demovm3.localdomain demovm3
EOF
```
On all the three hosts, add oVirt and gdeploy repositories (gdeploy packages are not included in oVirt 4.1 release but they will be in the next minor release):
```
yum install -y http://resources.ovirt.org/pub/yum-repo/ovirt-release41.rpm

#Add gdeploy repo
cat <<EOF > /etc/yum.repos.d/gdeploy.repo
[rnachimu-gdeploy]
name=Copr repo for gdeploy owned by rnachimu
baseurl=https://copr-be.cloud.fedoraproject.org/results/rnachimu/gdeploy/epel-7-x86_64/
type=rpm-md
skip_if_unavailable=True
gpgcheck=1
gpgkey=https://copr-be.cloud.fedoraproject.org/results/rnachimu/gdeploy/pubkey.gpg
repo_gpgcheck=0
enabled=1
enabled_metadata=1
EOF
```

Choose one of the three host to be used to run gdeploy and ovirt-hosted-engine setup, we call it the first host.
On the first host install gdeploy and ovirt-engine-appliance
```
yum install -y cockpit-ovirt-dashboard gdeploy ovirt-engine-appliance
```
and generate and distribute an ssh key for key based password-less authentication, try it out to ensure that it's working and add each host to know hosts file.
```
# generate and distribute ssh key
ssh-keygen
ssh-copy-id root@demovm1.localdomain
ssh-copy-id root@demovm2.localdomain
ssh-copy-id root@demovm3.localdomain
# try it on demovm1.localdomain demovm2.localdomain demovm3.localdomain to add ssh keys to known hosts
```
On additional hosts simply install cockpit-ovirt-dashboard and gdeploy to fetch all the required dependencies.
```
yum install -y cockpit-ovirt-dashboard gdeploy
```
On all the three hosts enable and start cockpit and add a firewall rule for it:
```
systemctl enable cockpit
systemctl start cockpit
firewall-cmd --zone=public --add-port=9090/tcp --permanent
firewall-cmd --reload
```
If you are using VMs as your nodes, you should consider using a virtio-rng device on them to provide a source of entropy since going low on entropy can significantly slow down your demo env.
```
yum install -y epel-release
yum install -y haveged
systemctl start haveged
systemctl enable haveged
yum remove -y epel-release
```
If you are using EPEL please take care or removing it since it's going to make the installation of oVirt fail due to a dependency conflict.

## Setup

Now we can point your browser to https://demovm1.localdomain:9090/ to connect to cockpit running on your first host. Connect as root user.
Point to Virtualization Tab and then Hosted Engine sub tab and choose there 'Hosted Engine with Gluster' as for picture 1.
![2017-02-16-hyperconverged-ovirt-with-ovn-picture01.png](2017-02-16-hyperconverged-ovirt-with-ovn-picture01.png "2017-02-16-hyperconverged-ovirt-with-ovn-picture01.png")
As the first step add the hostname of your three hosts on the *storage network*, since we have a single nic on each host I could simply use the FQDN but to make it more clear that's a different thing I’m going to use the host IP addresses as in picture 2.
![2017-02-16-hyperconverged-ovirt-with-ovn-picture02.png](2017-02-16-hyperconverged-ovirt-with-ovn-picture02.png "2017-02-16-hyperconverged-ovirt-with-ovn-picture02.png")
On the *Packages* step we can just keep everything as it is since we already installed what's needed.
On the *Volumes* step it will propose by default to use three volumes but we are going to remove the vmstore one since we just want to build the minimal env for this demo lab so proceed as for picture 3. Please note that gdeploy will propose by default to use replica with arbiter mode to provide more space efficiency than a pure replica 3 mode.
![2017-02-16-hyperconverged-ovirt-with-ovn-picture03.png](2017-02-16-hyperconverged-ovirt-with-ovn-picture03.png "2017-02-16-hyperconverged-ovirt-with-ovn-picture03.png")
On the *Bricks* step remove the vmstore brick since we are not going to create the vmstore volume; point the device field to the storage device you are really going to use for the brick (vdb for both the volumes in my case); change the size of every brick to be sure they can fit on your device as in picture 4.
![2017-02-16-hyperconverged-ovirt-with-ovn-picture04.png](2017-02-16-hyperconverged-ovirt-with-ovn-picture04.png "2017-02-16-hyperconverged-ovirt-with-ovn-picture04.png")
Gdeploy will create the two gluster volumes and it will configure them to serve as best as possible for virtualization purposes. Wait until it successfully complete the volume definition as in picture 5.
![2017-02-16-hyperconverged-ovirt-with-ovn-picture05.png](2017-02-16-hyperconverged-ovirt-with-ovn-picture05.png "2017-02-16-hyperconverged-ovirt-with-ovn-picture05.png")
Now you can continue with hosted-engine deployment; you can accept the default proposed values almost in every question. The relevant questions are pointed out here.
When it asks for the FQDN of the engine VM enter ‘enginevm.localdomain’ as for picture 6.
![2017-02-16-hyperconverged-ovirt-with-ovn-picture06.png](2017-02-16-hyperconverged-ovirt-with-ovn-picture06.png "2017-02-16-hyperconverged-ovirt-with-ovn-picture06.png")
When it asks *Please specify the memory size of the VM in MB (Defaults to maximum available): [4688]:* you can set 4096.
When it asks *How should the engine VM network be configured (DHCP, Static)[DHCP]?* you should enter static since we are not relying on an external DHCP service as for picture 7.
![2017-02-16-hyperconverged-ovirt-with-ovn-picture07.png](2017-02-16-hyperconverged-ovirt-with-ovn-picture07.png "2017-02-16-hyperconverged-ovirt-with-ovn-picture07.png")
and when it asks for an IP address for the engine VM enter 192.168.1.200.
When it asks *Add lines for the appliance itself and for this host to /etc/hosts on the engine VM?
Note: ensuring that this host could resolve the engine VM hostname is still up to you
(Yes, No)[No]* choose yes as for picture 8 since we are not relying on an external DNS service.
![2017-02-16-hyperconverged-ovirt-with-ovn-picture08.png](2017-02-16-hyperconverged-ovirt-with-ovn-picture08.png "2017-02-16-hyperconverged-ovirt-with-ovn-picture08.png")
hosted-engine-setup will configure the management bridge, will create a VM from ovirt-engine-appliance at it will configured it as required via cloud-init. See picture 9.
![2017-02-16-hyperconverged-ovirt-with-ovn-picture09.png](2017-02-16-hyperconverged-ovirt-with-ovn-picture09.png "2017-02-16-hyperconverged-ovirt-with-ovn-picture09.png")
Wait for it to successfully complete as for picture 10.
![2017-02-16-hyperconverged-ovirt-with-ovn-picture10.png](2017-02-16-hyperconverged-ovirt-with-ovn-picture10.png "2017-02-16-hyperconverged-ovirt-with-ovn-picture10.png")
Go to the virtual machine subtab and wait for ovirt-ha-agent restart the engine VM as for picture 11; it could take up to a couple of minutes.
![2017-02-16-hyperconverged-ovirt-with-ovn-picture11.png](2017-02-16-hyperconverged-ovirt-with-ovn-picture11.png "2017-02-16-hyperconverged-ovirt-with-ovn-picture11.png")

## Additional configuration steps
The setup currently requires a few manual post install actions; they are going to be automated in one of the next minor releases.
First step is connecting to the administration portal on https://enginevm.localdomain/ovirt-engine/ ; login with admin user with the password you chose at setup time.

The first action is go to the *clusters* tab and edit the default cluster to set *Enable Gluster Service* as for picture 12.
![2017-02-16-hyperconverged-ovirt-with-ovn-picture12.png](2017-02-16-hyperconverged-ovirt-with-ovn-picture12.png "2017-02-16-hyperconverged-ovirt-with-ovn-picture12.png")
Once done, new volumes tab should appear as for picture 13. You see just one brick for volumes since the engine doesn't still know the other two involved hosts.
![2017-02-16-hyperconverged-ovirt-with-ovn-picture13.png](2017-02-16-hyperconverged-ovirt-with-ovn-picture13.png "2017-02-16-hyperconverged-ovirt-with-ovn-picture13.png")
At this point create your first storage domain for regular VMs on the second gluster volume (the hosted-engine storage domain is a special one and could contain just the engine VM).
Go to the storage tab and choose new domain; set Domain Function *Data*, Storage Type *GlusterFS*, set *Use managed gluster* and choose the existing *data* volume. Set *Data* as storage domain name and enter *backup-volfile-servers=192.168.1.202:192.168.1.203* (this ensures that everything should work also if the first host is down without any single point of failure) in the mount option field as for picture 14.
![2017-02-16-hyperconverged-ovirt-with-ovn-picture14.png](2017-02-16-hyperconverged-ovirt-with-ovn-picture14.png "2017-02-16-hyperconverged-ovirt-with-ovn-picture14.png")
Once the first regular storage domain goes up also the datacenter should go up and the hosted-engine storage domain and the engine VM should be automatically imported by the engine; wait for them to apper as for picture 15.
![2017-02-16-hyperconverged-ovirt-with-ovn-picture15.png](2017-02-16-hyperconverged-ovirt-with-ovn-picture15.png "2017-02-16-hyperconverged-ovirt-with-ovn-picture15.png")
Once they are in you should add the two additional hosts but, before that, since we skipped the DNS infrastructure, you should also add two entries for the two additional hosts under /etc/hosts on the engine VM:
```
cat <<EOF >> /etc/hosts
192.168.1.202 demovm2.localdomain demovm2
192.168.1.203 demovm3.localdomain demovm3
EOF
```
At this point we can go to the hosts tab and choose new host setting name=address=*demovm2.localdomain* and its root password in the general tab and *deploy* in the hosted-engine tab as for pictures 16 and 17.
![2017-02-16-hyperconverged-ovirt-with-ovn-picture16.png](2017-02-16-hyperconverged-ovirt-with-ovn-picture16.png "2017-02-16-hyperconverged-ovirt-with-ovn-picture16.png")
![2017-02-16-hyperconverged-ovirt-with-ovn-picture17.png](2017-02-16-hyperconverged-ovirt-with-ovn-picture17.png "2017-02-16-hyperconverged-ovirt-with-ovn-picture17.png")
Repeat it for the third host and wait for both of them to come up as for picture 18. The hosts are ready for hosted-engine when they are shown with a little crown: the host where the engine VM is running is shown with a gold crown, the other two with silver crown.
![2017-02-16-hyperconverged-ovirt-with-ovn-picture18.png](2017-02-16-hyperconverged-ovirt-with-ovn-picture18.png "2017-02-16-hyperconverged-ovirt-with-ovn-picture18.png")
The running status of hosted-engine could be checked also from cockpit running on any of the participants hosts as for picture 19.
![2017-02-16-hyperconverged-ovirt-with-ovn-picture19.png](2017-02-16-hyperconverged-ovirt-with-ovn-picture19.png "2017-02-16-hyperconverged-ovirt-with-ovn-picture19.png")
The last important step is to check the HA configuration of each host:
```
[root@demovm3 ~]# cat /etc/ovirt-hosted-engine/hosted-engine.conf 
ca_cert=/etc/pki/vdsm/libvirt-spice/ca-cert.pem
gateway=192.168.1.1
iqn=
conf_image_UUID=4e421013-73ed-452d-b2ed-c9f76e4b3bc6
ca_cert=/etc/pki/vdsm/libvirt-spice/ca-cert.pem
sdUUID=ffc2409e-680b-4d4a-be0b-9c2b381887cc
connectionUUID=937c723a-1232-4a24-8612-2044e454a232
conf_volume_UUID=f6258dac-da0d-499a-a5db-0de0821f86cc
user=
host_id=3
bridge=ovirtmgmt
metadata_image_UUID=ab5ea2f9-52d2-4419-bec6-f48915ebb8c2
spUUID=00000000-0000-0000-0000-000000000000
mnt_options=backup-volfile-servers=192.168.1.202:192.168.1.203
fqdn=enginevm.localdomain
portal=
vm_disk_id=6c4b4fe0-c1f8-4f76-b9f8-757c15d8d046
metadata_volume_UUID=ca58722f-3f89-4f6a-9c5e-e19aa4166e2f
vm_disk_vol_id=71d3095b-2eae-489d-9836-7522309b0003
domainType=glusterfs
port=
console=vnc
ca_subject="C=EN, L=Test, O=Test, CN=Test"
password=
vmid=f478697b-52f2-42f6-9f03-e45639952986
lockspace_image_UUID=1eee643d-7dd5-4bad-8ddc-44cfdc516449
lockspace_volume_UUID=30acc22f-623b-48bb-a244-62181a60c18c
vdsm_use_ssl=true
storage=192.168.1.201:/engine
conf=/var/run/ovirt-hosted-engine-ha/vm.conf
```
having 'mnt_options=backup-volfile-servers=192.168.1.202:192.168.1.203' there means that every host could run the hosted-engine VM mounting the gluster storage domain from any of the hosts in the pool without a single point of failure.
Tho hosts over the three are required to be up in order to run the engine VM.

In part 2, I'll show how to add the OVN provider to this setup.
