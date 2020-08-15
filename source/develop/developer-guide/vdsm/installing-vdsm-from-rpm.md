---
title: Installing VDSM from rpm
category: vdsm
authors: abonas, danken, dougsland, imansano, jniederm, jumper45, lvroyce, mburns,
  ranglust, sming, tdosek
---

# Installing VDSM from rpm

This Documents has come to describe the steps required in order to install & configure VDSM on the same host with ovirt-engine,
this steps are usually not required when installing VDSM on another host than ovirt-engine.

### Installing Prerequisite Packages

execute the following command as root:

      yum install -y bridge-utils

### Configuring oVirt's Repository

Execute the following command:

      sudo yum install http://resources.ovirt.org/releases/ovirt-release/ovirt-release-master.rpm

## VDSM

### Configuring the bridge Interface

Disable the network manager service by executing as root:

      systemctl stop NetworkManager.service
      systemctl disable NetworkManager.service

      service network start
      chkconfig network on

Add the following content into a new file named: **/etc/sysconfig/network-scripts/ifcfg-ovirtmgmt**:

      DEVICE=ovirtmgmt
      TYPE=Bridge
      ONBOOT=yes
      DELAY=0
      BOOTPROTO=static
      IPADDR=192.168.1.110
      NETMASK=255.255.255.0
      GATEWAY=192.168.1.1

Add the following line into the configuration file of your out going interface (usually em1/eth0) the file is located at: **/etc/sysconfig/network-scripts/ifcfg-em1** (assuming the device is em1)

      BRIDGE=ovirtmgmt

and remove the IPADDR, NETMASK and BOOTPROTO keys, since the interface should not have an IP address of its own. Full Example

      DEVICE=em1
      ONBOOT=yes
      BRIDGE=ovirtmgmt

Restart the network service by executing:

      service network restart

**Note that if any other bridge (from ovirtmgmt) is present at the time of host installation, the bridge creation operation is skipped and you have to change the bridge settings to correspond to above shown configuration manually.**

### Installing & Configuring VDSM

#### Install

Install VDSM by executing as root the following commands:

      yum install -y vdsm vdsm-cli

Note:if you are using vdsm-4.10.0, you may need to install libvirt-0.10.0 which can't be found in yum. You can find the libvirt rpm in the following page:<http://libvirt.org/sources/>

#### Configure

Add the following content into the file: **/etc/vdsm/vdsm.conf** (you may need to create that file):

      [vars]
      ssl = false

Restart the vdsmd service by executing:

      systemctl restart vdsmd

If Vdsm was started earlier with ssl=true, it would refuse to start and you may need to use the undocumented verb

      vdsm-tool configure --force
      systemctl start vdsmd

which edits **/etc/libvirt/qemu.conf** and changes **spice_tls=1** to **spice_tls=0**.

