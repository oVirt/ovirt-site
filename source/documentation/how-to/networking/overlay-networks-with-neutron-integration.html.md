---
title: Overlay Networks with Neutron Integration
authors: amuller
---

<!-- TODO: Content review -->

# Overlay Networks with Neutron Integration

![](oVirt_Neutron_GRE.jpeg "oVirt_Neutron_GRE.jpeg")

## Current Status

*   Adding hosts from the GUI uses hard-coded Quantum names (And so won't work for OpenStack Havana). This is fixed in oVirt 3.3.3
*   The oVirt GUI currently does not support GRE and VXLAN tenant networks, only VLAN. For this reason we will configure the compute nodes manually

## The oVirt Side

[Install the engine on a host.](Quick Start Guide) Setup a couple of RHEL 6.5 compatible hosts, run yum update. These will be used to host guests. You can use oVirt's GUI to add the hosts now. If you do, you can select 'reinstall' later to install the Neutron agents.

## Install Neutron Controller

On the RHEL 6.5 host that will be used as the Neutron server, L3 agent and DHCP agent - Install iproute 2 that supports namespaces (For example 2.6.32-130): <https://brewweb.devel.redhat.com/buildinfo?buildID=297968>

This host will now be known as the controller.

On the controller:

    yum install -y http://rdo.fedorapeople.org/openstack-havana/rdo-release-havana.rpm

No need for a yum update or reboot.

"Due to the quantum/neutron rename, SELinux policies are currently broken for Havana, so SELinux must be disabled/permissive on machines running neutron services, edit /etc/selinux/config to set SELINUX=permissive."

Install Neutron manuall, using Foreman or Packstack.

Via packstack:

    sudo yum install -y openstack-packstack

Make packstack generate an answer file:

    packstack --gen-answer-file=<file name>

An answer file will be created in the current directory.

Packstack supports GRE, but does not support VXLAN until <https://bugzilla.redhat.com/show_bug.cgi?id=1021778> is resolved. Make the following changes both for GRE and VXLAN. For VXLAN an **additional** step will follow. Either way, since we're only using Packstack to install the Neutron server, configuring the compute nodes will be done manually until GRE/VXLAN support is added to oVirt.

Edit it and change:

Only install required services (Neutron only would be ideal but as of 17.10.13 Packstack fails if you don't select Nova as well)

Make sure Neutron server IP is reachable from the host that will act as the oVirt engine

From:

    CONFIG_NEUTRON_OVS_TENANT_NETWORK_TYPE=local

To:

    CONFIG_NEUTRON_OVS_TENANT_NETWORK_TYPE=gre

Change the tunnel ranges to something similar to:

    CONFIG_NEUTRON_OVS_TUNNEL_RANGES=1:1000

Finally change:

    CONFIG_NEUTRON_OVS_TUNNEL_IF=<ethX>

To the device which faces the compute nodes.

Now run:

    packstack --answer-file=<file name>

## oVirt Configuration

On the machine that runs the oVirt engine:

    engine-config --set KeystoneAuthUrl=http://<host.fqdn>:35357/v2.0
    engine-config --set OnlyRequiredNetworksMandatoryForVdsSelection=true

From the GUI, add Neutron as an external provider

## Hosts Configuration

The next step is to add hosts to oVirt. It requires a few yum repositories.

### Repositories

For VDSM: ovirt-stable for Fedora:

    sudo yum install -y http://resources.ovirt.org/releases/ovirt-release-fedora.noarch.rpm

Or for RHEL:

    sudo yum install -y http://resources.ovirt.org/releases/ovirt-release-el.noarch.rpm

Additionally, for the Open vSwitch layer 2 agent:

    sudo yum install -y http://rdo.fedorapeople.org/openstack-havana/rdo-release-havana.rpm

### Configuration

oVirt can install the layer 2 agent on the host if external provider is selected during host install. However, GRE/VXLAN integration is not currently supported in 3.3. Until it is fixed, follow these manual steps on each host:

To install layer 2 ovs agent follow the instructions on (If not using using oVirt 3.3.3+):

<http://www.ovirt.org/Features/Detailed_Quantum_Integration#OVS_Agent_installation_steps>

After installing the layer 2 ovs agent (Either manually or via oVirt's 3.3.3), please make the following additional modifications:

Edit:

/etc/neutron/neutron.conf

Under [agent]

Change:

    root_helper = sudo quantum-rootwrap /etc/quantum/rootwrap.conf

To:

    root_helper = sudo neutron-rootwrap /etc/neutron/rootwrap.conf

Edit:

/etc/neutron/plugins/openvswitch/ovs_plugin.ini:

    [ovs]
    tenant_network_type = (gre | vxlan)
    enable_tunneling = True
    tunnel_type = (gre | vxlan)
    tunnel_id_ranges = 1:1000
    local_ip = <ip of nic that should bring up tunnels>

    [agent]
    tunnel_types = (gre | vxlan)
    vxlan_udp_port = 8472 (Open this port on your network's firewalls for VXLAN)

Then eradicate the OVS db and restart the agent's service:

    ovs-vsctl emer-reset && service openstack-openvswitch-agent

## VDSM Hook

Finally install the oVirt VDSM hook that enables Neutron integration:

    yum install vdsm-hook-openstacknet

## MTU

Resolve packet fragmentation (And increase throughput) via **one** of the following changes:

1.  Decrease the MTU in all VMs to 1480~
2.  Increase the MTU on all physical network devices to 1520~

## Enjoying the Results

1.  Create the desired networks in Neutron
2.  From oVirt: Import those networks
3.  Connect VMs to those networks
4.  Start the VMs!

The VMs should be able to connect to both oVirt and Neutron networks.
