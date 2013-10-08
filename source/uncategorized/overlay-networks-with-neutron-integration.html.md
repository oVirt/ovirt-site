---
title: Overlay Networks with Neutron Integration
authors: amuller
wiki_title: Overlay Networks with Neutron Integration
wiki_revision_count: 25
wiki_last_updated: 2013-12-23
---

# Overlay Networks with Neutron Integration

![](oVirt_Neutron_GRE.jpeg "oVirt_Neutron_GRE.jpeg")

Install oVirt 3.3 Setup a couple of RHEL 6.5 hosts, run yum update.

On the RHEL 6.5 host that will be used as the Neutron server, L3 agent and DHCP agent - Install iproute 2 that supports namespaces (For example 2.6.32-130): <https://brewweb.devel.redhat.com/buildinfo?buildID=297968>

This host will now be known as the controller.

On the controller: yum install -y <http://rdo.fedorapeople.org/openstack-havana/rdo-release-havana.rpm>

No need for a yum update or reboot.

"Due to the quantum/neutron rename, SELinux policies are currently broken for Havana, so SELinux must be disabled/permissive on machines running neutron services, edit /etc/selinux/config to set SELINUX=permissive."

On the controller:

Install packstack: sudo yum install -y openstack-packstack

Make packstack generate an answer file:

packstack --gen-answer-file=<file name>

An answer file will be created in /root/<file name>

Edit it, change:

All of the IP addresses to the IP address of the host's "internal" network's device, apart from:

CONFIG_HORIZON_HOST=<public_network_ip>

CONFIG_NOVA_VNCPROXY_HOST=<public_network_ip>

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

From oVirt, add the hosts.
