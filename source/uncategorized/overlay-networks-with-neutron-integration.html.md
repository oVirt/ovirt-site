---
title: Overlay Networks with Neutron Integration
authors: amuller
wiki_title: Overlay Networks with Neutron Integration
wiki_revision_count: 25
wiki_last_updated: 2013-12-23
---

# Overlay Networks with Neutron Integration

Install oVirt 3.3 Setup a couple of hosts

Setup a couple of (separate) RHEL 6.5 hosts to be used by OpenStack, and run yum -y update.

On RHEL 6.5 OpenStack hosts, install iproute 2 that supports namespaces (For example 2.6.32-130): <https://brewweb.devel.redhat.com/buildinfo?buildID=297968>

sudo yum install -y <http://rdo.fedorapeople.org/openstack-havana/rdo-release-havana.rpm>

No need for a yum update or reboot.

"Due to the quantum/neutron rename, SELinux policies are currently broken for Havana, so SELinux must be disabled/permissive on machines running neutron services, edit /etc/selinux/config to set SELINUX=permissive."

Install packstack: sudo yum install -y openstack-packstack

packstack --allinone (On the controller host) (???)

Check if required: NOTE: When using GRE, set the MTU in the Guest to 1400, this will allow for the GRE header and no packet fragmentation. Also you should set TSO to off on the instance machine for outbound traffic to work. This can be done by this command : ethtool -K eth0 tso off . You can create a bash script for init.d to run it at startup.
