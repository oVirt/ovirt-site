---
title: Bonding VLAN Bridge
authors:
  - danken
  - karli.sjoberg
---

# Bonding VLAN Bridge

## How set up an enterprise network configuration manually.

Start by disabling `NetworkManager` and enable the good ol' `network` service.

Fedora:

    # systemctl stop NetworkManager
    # systemctl disable NetworkManager
    # systemctl enable network
    # systemctl start network

CentOS:

    # service NetworkManager stop
    # chkconfig --level 2345 NetworkManager off
    # chkconfig --level 2345 network on
    # service network start

 Define to load bonding at boot:

    # cat > /etc/modprobe.d/bonding.conf << EOF
    alias bond0 bonding
    EOF

 Then define the bond. This is LACP mode:

    # cat > /etc/sysconfig/network-scripts/ifcfg-bond0 << EOF
    DEVICE=bond0
    NM_CONTROLLED=no
    USERCTL=no
    BOOTPROTO=none
    BONDING_OPTS="mode=4 miimon=100"
    TYPE=Ethernet
    MTU=9000
    EOF

 Then "enslave" the physical NICs to the bond:

    # cat > /etc/sysconfig/network-scripts/ifcfg-em1 << EOF
    NM_CONTROLLED="no"
    BOOTPROTO="none"
    DEVICE="em1"
    ONBOOT="yes"
    USERCTL=no
    MASTER=bond0
    SLAVE=yes
    EOF

    # cat > /etc/sysconfig/network-scripts/ifcfg-em2 << EOF
    NM_CONTROLLED="no"
    BOOTPROTO="none"
    DEVICE="em2"
    ONBOOT="yes"
    USERCTL=no
    MASTER=bond0
    SLAVE=yes
    EOF

 Then create VLAN interfaces ontop of the bond. In this example, I´m using VLAN ID 1 and 2:

    # cat > /etc/sysconfig/network-scripts/ifcfg-bond0.1 << EOF
    DEVICE=bond0.1
    VLAN=yes
    BOOTPROTO=none
    NM_CONTROLLED=no
    BRIDGE=br0
    MTU=1500
    EOF

    # cat > /etc/sysconfig/network-scripts/ifcfg-bond0.2 << EOF
    DEVICE=bond0.2
    VLAN=yes
    BOOTPROTO=none
    NM_CONTROLLED=no
    BRIDGE=ovirtmgmt
    MTU=9000
    EOF

 Lastly, create the bridges ontop of the VLAN interfaces. The names can be whatever you want, except one needs to be called "ovirtmgmt" of course:

    # cat > /etc/sysconfig/network-scripts/ifcfg-ovirtmgmt << EOF
    TYPE=Bridge
    NM_CONTROLLED="no"
    BOOTPROTO="none"
    DEVICE="ovirtmgmt"
    ONBOOT="yes"
    IPADDR=XXX.XXX.XXX.XXX
    NETMASK=255.255.255.0
    GATEWAY=XXX.XXX.XXX.XXX  # gateway goes into management network
    EOF

    # cat > /etc/sysconfig/network-scripts/ifcfg-br0 << EOF
    TYPE=Bridge
    NM_CONTROLLED="no"
    BOOTPROTO="none"
    DEVICE="br0"
    ONBOOT="yes"
    IPADDR=XXX.XXX.XXX.XXX
    NETMASK=255.255.255.0
    DEFROUTE=no
    EOF

 Last thing is to restart the network for the changes to take effect.

Fedora:

    # systemctl restart network

CentOS:

    # service network restart

 This way, you can have almost(4096) as many interfaces as you want with only two physical NICs. I also gave an example on how you tune Jumbo Frames to be active on some interfaces, and have regular window size on the rest.

When adding more networks, start by adding them in all of your Hosts before defining the new "Logical Network" in Engine, it´ll get cranky:)

    # cp /etc/sysconfig/network-scripts/ifcfg-bond0.1 /etc/sysconfig/network-scripts/ifcfg-bond0.3
    # sed -i -e 's/DEVICE=bond0.1/DEVICE=bond0.3/' -e 's/BRIDGE=br0/BRIDGE=NFS/' /etc/sysconfig/network-scripts/ifcfg-bond0.3
    # cp /etc/sysconfig/network-scripts/ifcfg-br0 /etc/sysconfig/network-scripts/ifcfg-NFS
    # sed -i -e 's/DEVICE="br0"/DEVICE="NFS"/' -e 's/IPADDR=XXX.XXX.XXX.XXX/IPADDR=YYY.YYY.YYY.YYY/' /etc/sysconfig/network-scripts/ifcfg-NFS

 No need to restart the entire network, just `ifup` the new interfaces:

    # ifup bond0.3
    # ifup NFS

 Oh, and `vdsmd` needs to be restarted to pick it up. You *can* do this while Host is up, but again, Engine will get cranky. More elegant is to put Host in maintenance before.

Fedora:

    # systemctl restart vdsmd

CentOS:

    # service vdsmd restart

 **Please note!** Jumbo Frames must only be active on interfaces that aren´t routed, since the default routing size is 1500.
