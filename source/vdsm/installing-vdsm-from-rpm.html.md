---
title: Installing VDSM from rpm
category: vdsm
authors: abonas, danken, dougsland, imansano, jniederm, jumper45, lvroyce, mburns,
  ranglust, sming, tdosek
wiki_category: Vdsm
wiki_title: Installing VDSM from rpm
wiki_revision_count: 23
wiki_last_updated: 2015-03-16
---

# Installing VDSM from rpm

This Documents has come to describe the steps required in order to install & configure ovirt-node on the same host with ovirt-engine, this steps are usually not required when installing ovirt-node on another host then ovirt-engine
Use this guide in order to install ovirt-engine: [Installing_ovirt-engine_from_rpm](Installing_ovirt-engine_from_rpm)

### Installing Prerequisite Packages

execute the following command as root:

      yum install -y bridge-utils
       

### Configuring Ovirt's Repository

Execute the following command:

      wget http://www.ovirt.org/releases/stable/fedora/16/ovirt-engine.repo -P /etc/yum.repos.d/
       

## ovirt-node

### Configuring the bridge Interface

Disable the network manager service by executing as root:

      systemctl stop NetworkManager.service
      systemctl disable NetworkManager.service

      service network start
      chkconfig network on
       

Add the following content into a new file named: **/etc/sysconfig/network-scripts/ifcfg-engine**:

      DEVICE=engine
      TYPE=Bridge
      ONBOOT=yes
      DELAY=0
      BOOTPROTO=dhcp
      ONBOOT=yes
       

Add the following line into the configuration file of your out going interface (usually em1/eth0) the file is located at: **/etc/sysconfig/network-scripts/ifcfg-em1** (assuming the device is em1)

      BRIDGE=engine
       

Restart the network service by executing:

      service network restart
       

### Installing & Configuring ovirt-node

#### Install

Install ovirt-node by executing as root the following commands:

      yum install -y vdsm*
      service vdsmd start
       

#### Configure

Edit **/etc/libvirt/qemu.conf** and change **spice_tls=1** to **spice_tls=0**

Add the following content into the file: **/etc/vdsm/vdsm.conf**:

      [vars]
      ssl = false
       

Restart the vdsmd service by executing:

      service vdsmd restart
       
