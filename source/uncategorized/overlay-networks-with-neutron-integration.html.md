---
title: Overlay Networks with Neutron Integration
authors: amuller
wiki_title: Overlay Networks with Neutron Integration
wiki_revision_count: 25
wiki_last_updated: 2013-12-23
---

# Overlay Networks with Neutron Integration

## **NOTE: This guide is a work in progress! Do not use!**

![](oVirt_Neutron_GRE.jpeg "oVirt_Neutron_GRE.jpeg")

Install oVirt 3.3

Setup a couple of RHEL 6.5 hosts, run yum update.

On the RHEL 6.5 host that will be used as the Neutron server, L3 agent and DHCP agent - Install iproute 2 that supports namespaces (For example 2.6.32-130): <https://brewweb.devel.redhat.com/buildinfo?buildID=297968>

This host will now be known as the controller.

On the controller: yum install -y <http://rdo.fedorapeople.org/openstack-havana/rdo-release-havana.rpm>

No need for a yum update or reboot.

"Due to the quantum/neutron rename, SELinux policies are currently broken for Havana, so SELinux must be disabled/permissive on machines running neutron services, edit /etc/selinux/config to set SELINUX=permissive."

On the controller: Install Neutron manually or use Packstack.

Install packstack: sudo yum install -y openstack-packstack

Make packstack generate an answer file:

packstack --gen-answer-file=<file name>

An answer file will be created in /root/<file name>

Edit it and change:

Only install required services (CHECK WHICH THESE ARE)

Make sure Neutron server IP is reachable from the host that will act as the oVirt engine

For neutron GRE:

CONFIG_NEUTRON_OVS_TENANT_NETWORK_TYPE=local

To:

CONFIG_NEUTRON_OVS_TENANT_NETWORK_TYPE=gre

And change the tunnel ranges to:

CONFIG_NEUTRON_OVS_TUNNEL_RANGES=1:1000

Finally change:

CONFIG_NEUTRON_OVS_TUNNEL_IF=<ethX>

To the device which faces the compute nodes.

Now run: packstack --answer-file=<file name>

Check if required: NOTE: When using GRE, set the MTU in the Guest to 1400, this will allow for the GRE header and no packet fragmentation. Also you should set TSO to off on the instance machine for outbound traffic to work. This can be done by this command : ethtool -K eth0 tso off . You can create a bash script for init.d to run it at startup.

oVirt Configuration: engine-config --set KeystoneAuthUrl=<http://><host.fqdn>:35357/v2.0 engine-config --set OnlyRequiredNetworksMandatoryForVdsSelection=true Add Neutron as an external provider

The next step is to add hosts to oVirt. It requires a few yum repositories. For VDSM: ovirt-nightly or similar For ovs layer 2 agent: sudo yum install -y <http://rdo.fedorapeople.org/openstack-havana/rdo-release-havana.rpm> oVirt can install the layer 2 agent on the host if external provider is selected during host install. However, it is currently broken with OpenStack Havana until <https://bugzilla.redhat.com/show_bug.cgi?id=1019818> is resolved. To install layer 2 ovs agent follow the instructions on (Until the bug is fixed): <http://www.ovirt.org/Features/Detailed_Quantum_Integration#OVS_Agent_installation_steps> When the bug is fixed simply select external provider when adding the host. Edit: /etc/neutron/neutron.conf Under [agent] Change: root_helper = sudo quantum-rootwrap /etc/quantum/rootwrap.conf To: root_helper = sudo neutron-rootwrap /etc/neutron/rootwrap.conf
