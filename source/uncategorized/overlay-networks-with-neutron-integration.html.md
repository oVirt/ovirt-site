---
title: Overlay Networks with Neutron Integration
authors: amuller
wiki_title: Overlay Networks with Neutron Integration
wiki_revision_count: 25
wiki_last_updated: 2013-12-23
---

# Overlay Networks with Neutron Integration

## oVirt & Neutron GRE Integration

![](oVirt_Neutron_GRE.jpeg "oVirt_Neutron_GRE.jpeg")

### The oVirt Side

[Install the engine on a host.](Quick Start Guide) Setup a couple of RHEL 6.5 compatible hosts, run yum update. These will be used to host guests. You can use oVirt's GUI to add the hosts now. If you do, you can select 'reinstall' later to install the Neutron agents.

### Install Neutron Controller

On the RHEL 6.5 host that will be used as the Neutron server, L3 agent and DHCP agent - Install iproute 2 that supports namespaces (For example 2.6.32-130): <https://brewweb.devel.redhat.com/buildinfo?buildID=297968>

This host will now be known as the controller.

On the controller:

    yum install -y http://rdo.fedorapeople.org/openstack-havana/rdo-release-havana.rpm

No need for a yum update or reboot.

"Due to the quantum/neutron rename, SELinux policies are currently broken for Havana, so SELinux must be disabled/permissive on machines running neutron services, edit /etc/selinux/config to set SELINUX=permissive."

Install Neutron manually or use Packstack.

Via packstack:

    sudo yum install -y openstack-packstack

Make packstack generate an answer file:

    packstack --gen-answer-file=<file name>

An answer file will be created in /root/<file name>

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

When using GRE, set the MTU in the Guest to 1400, this will allow for the GRE header and no packet fragmentation. Also you should set TSO to off on the instance machine for outbound traffic to work. This can be done by this command : ethtool -K eth0 tso off . You can create a bash script for init.d to run it at startup.

### oVirt Configuration

On the machine that runs the oVirt engine:

    engine-config --set KeystoneAuthUrl=http://<host.fqdn>:35357/v2.0
    engine-config --set OnlyRequiredNetworksMandatoryForVdsSelection=true

From the GUI, add Neutron as an external provider

### Hosts Configuration

The next step is to add hosts to oVirt. It requires a few yum repositories.

#### Repositories

For VDSM: ovirt-stable for Fedora:

    sudo yum install -y http://resources.ovirt.org/releases/ovirt-release-fedora.noarch.rpm

Or for RHEL:

    sudo yum install -y http://resources.ovirt.org/releases/ovirt-release-el.noarch.rpm

Additionally, for the Open vSwitch layer 2 agent:

    sudo yum install -y http://rdo.fedorapeople.org/openstack-havana/rdo-release-havana.rpm

#### Configuration

oVirt can install the layer 2 agent on the host if external provider is selected during host install. However, it is currently broken with OpenStack Havana until <https://bugzilla.redhat.com/show_bug.cgi?id=1019818> is resolved. GRE/VXLAN integration is also not currently supported in 3.3. Until it is fixed, follow these manual steps on each host:

To install layer 2 ovs agent follow the instructions on (Until the bug is fixed):

<http://www.ovirt.org/Features/Detailed_Quantum_Integration#OVS_Agent_installation_steps>

After you complete that set of instructions, please make the following additional modifications:

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

    tenant_network_type = gre

    enable_tunneling = True

    tunnel_type = gre

    tunnel_id_ranges = 5000:10000

    local_ip = <ip of nic that should bring up GRE tunnels>

    [agent]

    tunnel_types = gre

Then restart the agent's service:

    service neutron-openvswitch-agent restart

### VDSM Hook

Finally install the oVirt VDSM hook that enables Neutron integration:

    yum install vdsm-hook-openstacknet

### Enjoying the Results

1.  Create the desired networks in Neutron
2.  From oVirt: Import those networks
3.  Connect VMs to those networks
4.  Start the VMs!

The VMs should be able to connect to both oVirt and Neutron networks.
