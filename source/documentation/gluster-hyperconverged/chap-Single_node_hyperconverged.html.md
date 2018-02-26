---
title: Deploying oVirt and Gluster Single node Hyperconverged
---

# Chapter 6: Deploying a Single Node oVirt and Gluster Hyperconverged

## Pre-requisites

* A single host with  Enterprise Linux 7 or oVirt Node. Refer [Enterprise Linux Hosts](../install-guide/chap-Enterprise_Linux_Hosts) or [oVirt Nodes](../install-guide/chap-oVirt_Nodes)

* You must have at least 2 interfaces on the host, so that the frontend and backend traffic can be separated out. Having only one network will cause the engine monitoring, client traffic, gluster I/O traffic to all run together and interfere each other. To segregate the backend network, the gluster cluster is formed using the backend network addresses, and the nodes are added to the engine using the frontend network address.

* You must have a fully qualified domain name prepared for your Engine and the host. Forward and reverse lookup records must both be set in the DNS. **The Engine should use the same subnet as the management network.**

* You must have configured passwordless ssh between the host to itself. gdeploy uses Ansible playbooks and the ability to remotely execute commands is a pre-requisite.
Follow below steps to configure this.
```
# ssh-keygen 
# ssh-copy-id root@<host-address>
```

## Deploying on Enterprise Linux Hosts

### Installing the Required Packages

**Installing the packages on the host**

1. Subscribe to ovirt repos from http://resources.ovirt.org/pub/yum-repo/
   For instance, to subscribe to oVirt 4.2 repo,

        # yum install http://resources.ovirt.org/pub/yum-repo/ovirt-release42.rpm

2. Install gdeploy and cockpit-ovirt that will provide a UI for the installation of Hosted Engine. gdeploy is a wrapper tool around Ansible that helps to setup gluster volumes. vdsm-gluster is used to manage gluster from oVirt, and pulls in all the required gluster dependencies. Install the oVirt Engine Virtual Appliance package for the Engine virtual machine installation.
     
        # yum install gdeploy cockpit-ovirt-dashboard vdsm-gluster ovirt-engine-appliance


## Deploying on oVirt Node based Hosts

**oVirt Node contains all the required packages to set up the hyperconverged environment.**
Refer [oVirt Nodes](../install-guide/chap-oVirt_Nodes) for instructions on installing oVirt Node on the host. You can proceed to setting up the hyperconverged environment if you have an oVirt Node based host.

### Setting up the hyperconverged environment

#### Installing and setting up gluster volume

Gluster volumes need to be created first prior to the Hosted Engine installation flow. One of the volumes that's created is used to host the Hosted Engine VM. Use the below gdeploy configuration file as a template to create volumes and configure the host.
Since the Cockpit UI only supports the 3 node deployment, we have to manually run a gdeploy config file to handle this currently.

```
[hosts]
@HOSTNAME@

[disktype]
@RAIDTYPE@ #Possible values raid6, raid10, raid5, jbod

[diskcount]
@NUMBER_OF_DATA_DISKS@ #Ignored in case of jbod

[stripesize]
@STRIPE_SIZE@ #256 in case of jbod

[pv]
action=create
devices=@DEVICE@

[vg1]
action=create
vgname=RHGS_vg1
pvname=@DEVICE@

[lv1]
action=create
vgname=RHGS_vg1
lvname=engine_lv
lvtype=thick
size=100GB 
mount=/rhgs/brick1

[lv2]
action=create
vgname=RHGS_vg1
poolname=lvthinpool
lvtype=thinpool
poolmetadatasize=15GB
chunksize=1024k
size=@SIZE@ #For example: 18000GB, depending on device capacity

[lv3]
action=create
lvname=lv_vmdisks
poolname=lvthinpool
vgname=RHGS_vg1
lvtype=thinlv
mount=/rhgs/brick2
virtualsize=@SIZE@

[lv4]
action=create
lvname=lv_datadisks
poolname=lvthinpool
vgname=RHGS_vg1
lvtype=thinlv
mount=/rhgs/brick3
virtualsize=@SIZE@

#[vg2]
#action=extend
#vgname=RHGS_vg1
#pvname=@SSD_DEVICE@

#[lv5]
#action=setup-cache
#ssd=@SSD_DEVICE@
#vgname=RHGS_vg1
#poolname=lvthinpool
#cache_lv=lvcache
#cache_lvsize=5GB # Provide device size
## cachemode=writeback

[selinux]
yes

[service3]
action=restart
service=glusterd
slice_setup=yes

[firewalld]
action=add
ports=111/tcp,2049/tcp,54321/tcp,5900/tcp,5900-6923/tcp,5666/tcp,16514/tcp,54322/tcp
services=glusterfs

[script2]
action=execute
file=/usr/share/gdeploy/scripts/disable-gluster-hooks.sh

[volume]
action=create
volname=engine
transport=tcp
key=storage.owner-uid,storage.owner-gid,features.shard,performance.low-prio-threads,performance.strict-o-direct,network.remote-dio,network.ping-timeout,user.cifs,nfs.disable,performance.quick-read,performance.read-ahead,performance.io-cache,cluster.eager-lock
value=36,36,on,32,on,off,30,off,on,off,off,off,enable
brick_dirs=/rhgs/brick1/engine
ignore_volume_errors=no

[volume2]
action=create
volname=vmstore
transport=tcp
key=storage.owner-uid,storage.owner-gid,features.shard,performance.low-prio-threads,performance.strict-o-direct,network.remote-dio,network.ping-timeout,user.cifs,nfs.disable,performance.quick-read,performance.read-ahead,performance.io-cache,cluster.eager-lock
value=36,36,on,32,on,off,30,off,on,off,off,off,enable
brick_dirs=/rhgs/brick2/vmstore
ignore_volume_errors=no

[volume3]
action=create
volname=data
transport=tcp
key=storage.owner-uid,storage.owner-gid,features.shard,performance.low-prio-threads,performance.strict-o-direct,network.remote-dio,network.ping-timeout,user.cifs,nfs.disable,performance.quick-read,performance.read-ahead,performance.io-cache,cluster.eager-lock
value=36,36,on,32,on,off,30,off,on,off,off,off,enable
brick_dirs=/rhgs/brick3/data
ignore_volume_errors=no
```

Once the configuration file is edited (the @ @ replaced), the gluster environment can be setup using
```
gdeploy -c gdeploy.conf

```
#### Setting up Hosted Engine 

Use the Ansible based installation flow of Hosted Engine to set up oVirt within a virtual machine. The storage details should be provided as type: ```glusterfs``` and connection path as: ```<hostname>:/engine``` (Replace hostname with address of host on which installation is carried out)

**Prev:**  [Chapter: Maintenance and Upgrading Resources ](../chap-Maintenance_and_Upgrading_Resources) <br>



