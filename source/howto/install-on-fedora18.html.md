---
title: How to install ovirt on fedora18
category: howto
authors: obasan
wiki_title: How to install ovirt on fedora18
wiki_revision_count: 2
wiki_last_updated: 2012-11-22
---

# How to install ovirt on fedora18

Clean F18 vdsm

-Installation - There are several workarounds that have to be made prior to connect the engine to the Fedora18 host.

After RPM installation Bootstrapping fails. unable to create bridge.

             - workaround - prior to connecting the hypervisor to the engine, create bridge manually.
              1.disable NetworkManager: systemctl disable NetworkManager.service
              2.stop NetworkManager: systemctl stop NetworkManager.service
              3. add a bridge: brctl add ovirtmgmt
              4. add ifcfg scripts to /etc/sysconfig/network-scripts in the following convention.

              ifcfg-eth0
              DEVICE=eth0
              ONBOOT=yes
              BOOTPROTO=none
              HWADDR=xx:xx:xxxx:xx:xx
              BRIDGE=ovirtmgmt
              NM_CONTROLLED=no

             ifcfg-ovirtmgmt
             DEVICE=ovirtmgmt
             TYPE=Bridge
             ONBOOT=yes
             DELAY=0
             NM_CONTROLLED=no
             NETBOOT=yes
             BOOTPROTO=dhcp
             ONBOOT=yes

5. connect bridge to eth interface:

             brctl addif ovirtmgmt eth0

6. disable selinux:

             setenforce 0

7. restart network service:

             systemctl restart network.service

Failure to connect engine to host

this is due to the bootstrap trying to configure the iptables on the host. in Fedora 18 iptables has been replaced with firewalld. a workaround is disabling and stopping firewalld:

            systemctl disable firewalld.service
            systemctl stop firewalld.service

VDSM can't find network interface - this is due to the fact that ifconfig has been removed from fedora 18's default installation a workaround would be installing net-tools:

            yum install net-tools

After connecting the host to the engine you will need to reboot the machine manually because the bootstrap will fail to do it.

            reboot

relevant bugs:

`      `[`https://bugzilla.redhat.com/show_bug.cgi?id=869963`](https://bugzilla.redhat.com/show_bug.cgi?id=869963)
