---
title: Phoenix Lab Storage Hosts
category: infra
authors: dcaroest
---

# Phoenix Lab Storage Hosts

**NOTE**: for the latest version of this doc, see <http://ovirt-infra-docs.readthedocs.org/en/latest/>

Currently we have two storage servers, both of them have a CentOS 6.5 installation on them.

## Disk configuration

The storage servers have a set of 6 disks in a RAID5

## Storage replication

For the storage replication we are using [DRBD](http://www.drbd.org/users-guide/), it was required to install drbd84, and to do that on centos we had to use some special repos as it's been discontinued on the official repos. Here are the specific ones:

    [root@ovirt-storage01 ~]# cat /etc/yum.repos.d/hacluster.repo
    [haclustering]
    name=HA Clustering
    baseurl=http://download.opensuse.org/repositories/network:/ha-clustering:/Stable/CentOS_CentOS-6/
    enabled=1
    gpgcheck=0

You can check specifically the current status using the command:

    [root@ovirt-storage01 ~]# drbd-overview
    0:ovirt_storage/0  Connected Primary/Secondary UpToDate/UpToDate C r----- /srv/ovirt_storage ext4 11T 563G 9.7T 6% 

The DRBD cluster is started/stopped by the pacemaker cluster, so no need to handle it, but sometimes when the cluster degenerates is required to manually choose which node has to be master and start the replication between the nodes. You can check the cdocumentation on how to fix that type of issues [here](http://www.drbd.org/users-guide/ch-troubleshooting.html).

## Clustering

The clustering has been configured using crm and pacemaker. Here are a few tips on managing it:

To enter the management shell you can just type:

    crm

From there you can see a list of available commands using *tab* completion.

To see the current status of the cluster you can use:

    [root@ovirt-storage01 ~]# crm status
    Last updated: Sat Nov  8 03:59:18 2014
    Last change: Thu Jul 31 02:41:35 2014 via cibadmin on ovirt-storage01
    Stack: cman
    Current DC: ovirt-storage02 - partition with quorum
    Version: 1.1.10-14.el6_5.3-368c726
    2 Nodes configured
    7 Resources configured

    Online: [ ovirt-storage01 ovirt-storage02 ]

    Master/Slave Set: ms_drbd_ovirt_storage [p_drbd_ovirt_storage]
        Masters: [ ovirt-storage01 ]
        Slaves: [ ovirt-storage02 ]
    Resource Group: g_ovirt_storage
        p_fs_ovirt_storage  (ocf::heartbeat:Filesystem):    Started ovirt-storage01 
        p_ip_ovirt_storage  (ocf::heartbeat:IPaddr2):   Started ovirt-storage01 
        p_nfs_ovirt_storage (lsb:nfs):  Started ovirt-storage01
    Clone Set: cl_exportfs_ovirt_storage [p_exportfs_ovirt_storage]
        Started: [ ovirt-storage01 ovirt-storage02 ]

### Showing/editing the config

To see and edit the configuration you have to enter the configuration space from the crm shell, for future reference here's the output form the current config:

    crm(live)# cd configure
    crm(lise)configure# show

    node ovirt-storage01
    node ovirt-storage02
    primitive p_drbd_ovirt_storage ocf:linbit:drbd \
        params drbd_resource=ovirt_storage \
        op monitor interval=15 role=Master \
        op monitor interval=30 role=Slave
    primitive p_exportfs_ovirt_storage exportfs \
        params fsid=0 directory="/srv/ovirt_storage" options="rw,mountpoint,no_root_squash" clientspec="66.187.230.0/255.255.255.192" \
        op monitor interval=30s \
        meta target-role=Started
    primitive p_fs_ovirt_storage Filesystem \
        params device="/dev/drbd0" directory="/srv/ovirt_storage" fstype=ext4 \
        op monitor interval=10s \
        meta target-role=Started
    primitive p_ip_ovirt_storage IPaddr2 \
        params ip=66.187.230.61 cidr_netmask=26 \
        op monitor interval=30s \
        meta target-role=Started
    primitive p_nfs_ovirt_storage lsb:nfs \
        op monitor interval=30s \
        meta target-role=Started
    group g_ovirt_storage p_fs_ovirt_storage p_ip_ovirt_storage \
        meta target-role=Started
    ms ms_drbd_ovirt_storage p_drbd_ovirt_storage \
        meta master-max=1 master-node-max=1 clone-max=2 clone-node-max=1 notify=true target-role=Started
    clone cl_exportfs_ovirt_storage p_exportfs_ovirt_storage
    location cli-prefer-ms_drbd_ovirt_storage ms_drbd_ovirt_storage role=Started inf: ovirt-storage01
    colocation c_all_on_drbd inf: g_ovirt_storage ms_drbd_ovirt_storage:Master
    colocation c_nfs_on_drbd inf: p_nfs_ovirt_storage ms_drbd_ovirt_storage:Master
    colocation c_nfs_on_exportfs inf: g_ovirt_storage cl_exportfs_ovirt_storage
    order o_drbd_first inf: ms_drbd_ovirt_storage:promote g_ovirt_storage:start
    order o_exportfs_before_nfs inf: cl_exportfs_ovirt_storage g_ovirt_storage:start
    property cib-bootstrap-options: \
        dc-version=1.1.10-14.el6_5.3-368c726 \
        cluster-infrastructure=cman \
        expected-quorum-votes=2 \
        stonith-enabled=false \
        no-quorum-policy=ignore \
        last-lrm-refresh=1404978312

### NetworkConfiguration

The network is configured to use bonding on all interfaces using 802.3ad bonding protocol (requires special configuration on the switches).

Here's the current configuration files:

    [root@ovirt-storage01 ~]# cat /etc/modprobe.d/bonding.conf
    alias bond0 bonding
    ##mode=4 - 802.3ad   mode=6 - alb
    options bond0 mode=4 miimon=100 lacp_rate=1

    [root@ovirt-storage01 ~]# cat /etc/sysconfig/network-scripts/ifcfg-em1
    DEVICE="em1"
    BOOTPROTO=none
    HWADDR="F8:BC:12:3B:22:40"
    NM_CONTROLLED="no"
    ONBOOT="yes"
    TYPE="Ethernet"
    UUID="c0407968-795b-4fdb-9a43-3c70e4803c09"
    SLAVE=yes
    MASTER=bond0
    USERCTL=no

    [root@ovirt-storage01 ~]# cat /etc/sysconfig/network-scripts/ifcfg-bond0
    DEVICE=bond0
    IPADDR=66.187.230.1
    NETWORK=66.187.230.0
    NETMASK=255.255.255.192
    BROADCAST=66.187.230.63
    GATEWAY=66.187.230.62
    USERCTL=no
    BOOTPROTO=none
    ONBOOT=yes

