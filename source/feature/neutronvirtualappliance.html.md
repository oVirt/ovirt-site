---
title: NeutronVirtualAppliance
category: feature
authors: danken, moti
wiki_category: Feature
wiki_title: Features/NeutronVirtualAppliance
wiki_revision_count: 52
wiki_last_updated: 2014-09-22
feature_name: Neutron Virtual Appliance
feature_modules: network
feature_status: Development
wiki_warnings: list-item?
---

# Neutron Virtual Appliance

### Summary

oVirt engine has integrated the OpenStack Neutron service as a [network provider](Features/OSN_Integration). The OpenStack network provider enables ovirt-engine to consume Neutron services.
However, in order to provision Neutron services, one needs to manually deploy Neutron and Keystone services.
The Neutron Virtual Appliance designed to provide an easy and simple deployment of those services.

### Owner

*   Name: [ Moti Asayag](User:Moti Asayag)
*   Email: <masayag@redhat.com>

### Current status

*   Last updated on -- by [ WIKI}}](User:{{urlencode:{{REVISIONUSER}})

### Detailed Description

The feature designed to ease the neutron services provisioning from within ovirt by reducing the overhead of installing and configuring OpenStack.
For that purpose an image was created for a rapid provisioning, where the image contains all of the relevant services installed and configured with basic configuration that allows the ovirt-engine administrator with few (or more) steps to use the neutron services from ovirt.
The neutron appliance for ovirt-engine 3.5 is based on the Havana-RDO which uses [Packstack](https://wiki.openstack.org/wiki/Packstack) for installing OpenStack.
 The neutron node contains the following services:

1.  Neutron server
2.  Neutron L3 Agent
3.  Neutron DHCP Agent
4.  Open vSwitch Agent
5.  Open vSwitch
6.  QPID (messaging)

### Add OpenStack network external provider using the Neutron appliance

#### Create a vm based on neutron-appliance image

1.  Add new vm network (e.g. named 'neutron') named in the relevant data-center.
2.  Edit the 'neutron' vnic profile of the 'neutron' network to include custom properties "mac-spoof=true"
    1.  Instructions for adding the 'mac-spoof' property can be found [here](https://github.com/oVirt/vdsm/tree/master/vdsm_hooks/macspoof).

3.  Import the neutron-appliance image as a template (e.g. named 'neutron-appliance') from the glance.ovirt.org repository.
4.  Add a new VM (i.e. named 'neutron-provider') with 4GB RAM based on 'neutron-appliance' template and with 2 vnics:
    1.  eth0 - connected to 'ovirtmgmt' (needs to communicate with ovirt-engine and with the compute nodes/hypervisors)
    2.  eth1 - connected to 'neutron' network

#### Run the neutron server vm

1.  Install the no-macspoof hook on the host the vm is scheduled to be run on:
    1.  yum -y install vdsm-hook-macspoof

2.  Run the vm with cloud-init:
    1.  Set a root password.
    2.  Configure a static IP address (will be referred later as NEUTRON_SERVER_IP_ADDRESS) for eth0 (which is connected to 'ovirtmgmt')

3.  Connect to the vm (ssh/console) and run the following to verify OpenStack services are active:

       # . /root/keystonerc_admin
       # openstack-status 

#### Configure Neutron network provider on ovirt-engine

1.  engine-config -s KeystoneAuthUrl=<http://NEUTRON_SERVER_IP_ADDRESS:35357/v2.0/>
2.  Restart the ovirt-engine
3.  Add external network provider with the following properties:

    * On the general left tab:

    1. Type: OpenStack Network

    1. Networking Plugin: Open vSwitch

    1. Provider URL: <http://NEUTRON_SERVER_IP_ADDRESS:9696>

    1. User name: neutron

    1. Password: should be found by: 'grep CONFIG_NEUTRON_KS_PW /root/packstack-answers\*.txt' on the neutron server vm.

    1. Tenant name: services Verify 'connectivity test' passes (by clicking the 'Test' button)

    * On the Agent Configuration left tab:

    1. Bridge Mappings: vmnet:br-neutron g:# Host: NEUTRON_SERVER_IP_ADDRESS

    1. Port: 5672

    1. Username: guest

    1. Password: guest

#### Install a Host with the network provider

1.  Configure OpenStack repository on the host, i.e.: sudo yum install -y <http://rdo.fedorapeople.org/rdo-release.rpm>
2.  Install the host with external network provider by clicking the 'Network Provider' left tab
3.  Select the newly configured 'neutron' network provider and set:
    1.  bridge_mappings = vmnet:br-neutron

4.  Click 'OK' to engage the installation
5.  After installation is successfully completed, install the no-macspoof hook:
    1.  yum -y install vdsm-hook-macspoof

6.  Configure 'neutron' network on the host using the 'Setup Networks' dialog
7.  Run the following on the host, to connect neutron integration bridge to neutron network:
    1.  ovs-vsctl add-port br-neutron neutron

### Steps for creating the image

1.  Import CentOS-6.5 image as a template to 3.4 cluster from ovirt-glance repository
2.  Create a vm from CentOS-6.5 template, configure via cloud-init:
    1.  Set root password
    2.  define network interface 'eth0' as dhcp and on-boot (could be static ip as well)
    3.  Increase memory to 2048MB
    4.  Create 2 nics: eth0 (connected to ovirtmgmt) and eth1 (connected to 'neutron' vm network on ovirt)

<!-- -->

1.  Set root authorized-keys to be able to access via ssh

see <http://unix.stackexchange.com/questions/69314/automated-ssh-keygen-without-passphrase-how>

1.  Install packstack:
    1.  sudo yum install -y <http://rdo.fedorapeople.org/rdo-release.rpm>
    2.  sudo yum install -y openstack-packstack
    3.  sudo yum update -y python-backports

2.  Generate answer file:
    1.  packstack --gen-answer-file=/root/packstack-answers.txt

3.  Manipulate answer-file packstack-answers.txt

       IP_ADDRESS=$(grep CONFIG_MYSQL_HOST /root/packstack-answers.txt | cut -d= -f2)
       sed -i "s/$IP_ADDRESS/127.0.0.1/g" /root/packstack-answers.txt
       
       sed -i 's/CONFIG_PROVISION_ALL_IN_ONE_OVS_BRIDGE=n/CONFIG_PROVISION_ALL_IN_ONE_OVS_BRIDGE=y/' /root/packstack-answers.txt
       sed -i 's/CONFIG_CINDER_INSTALL=y/CONFIG_CINDER_INSTALL=n/' /root/packstack-answers.txt
       sed -i 's/CONFIG_NOVA_INSTALL=y/CONFIG_NOVA_INSTALL=n/' /root/packstack-answers.txt
       sed -i 's/CONFIG_HORIZON_INSTALL=y/CONFIG_HORIZON_INSTALL=n/' /root/packstack-answers.txt
       sed -i 's/CONFIG_SWIFT_INSTALL=y/CONFIG_SWIFT_INSTALL=n/' /root/packstack-answers.txt
       sed -i 's/CONFIG_CEILOMETER_INSTALL=y/CONFIG_CEILOMETER_INSTALL=n/' /root/packstack-answers.txt
       sed -i 's/CONFIG_NAGIOS_INSTALL=y/CONFIG_NAGIOS_INSTALL=n/' /root/packstack-answers.txt
       sed -i 's/CONFIG_NEUTRON_OVS_TENANT_NETWORK_TYPE=local/CONFIG_NEUTRON_OVS_TENANT_NETWORK_TYPE=vlan/' /root/packstack-answers.txt
       sed -i 's/CONFIG_NEUTRON_OVS_VLAN_RANGES=/CONFIG_NEUTRON_OVS_VLAN_RANGES=vmnet:1024:2048/' /root/packstack-answers.txt
       sed -i 's/CONFIG_NEUTRON_OVS_BRIDGE_MAPPINGS=/CONFIG_NEUTRON_OVS_BRIDGE_MAPPINGS=vmnet:br-eth1/' /root/packstack-answers.txt
       sed -i 's/CONFIG_NEUTRON_OVS_BRIDGE_IFACES=/CONFIG_NEUTRON_OVS_BRIDGE_IFACES=br-eth1:eth1/' /root/packstack-answers.txt

1.  Create ssh keys to ease packstack installer
    1.  ssh-keygen -f /root/.ssh/id_dsa -t dsa -q -N ""
    2.  cat /root/.ssh/id_dsa.pub >> /root/.ssh/authorized_keys

<!-- -->

1.  packstack --answer-file=/root/packstack-answers.txt
2.  change iptables rule:

      replace:
      -A INPUT -s 127.0.0.1/32 -p tcp -m multiport --dports 9696 -m comment --comment "001 neutron incoming 127.0.0.1" -j ACCEPT
      with:
      -A INPUT -p tcp -m multiport --dports 9696 -m comment --comment "001 neutron incoming all" -j ACCEPT

and

      -A INPUT -s 127.0.0.1/32 -p tcp -m multiport --dports 5671,5672 -m comment --comment "001 qpid incoming 127.0.0.1" -j ACCEPT
      with
      -A INPUT -p tcp -m multiport --dports 5671,5672 -m comment --comment "001 qpid incoming all" -j ACCEPT      
      service iptables restart

1.  yum install -y tcpdump
2.  Stop the vm
3.  Seal the vm's disk using [sysprep](http://libguestfs.org/virt-sysprep.1.html):

      virt-sysprep -a b228993a-1d1b-4bcc-8158-56354172b089 -a f541c84c-5d8e-4217-a6fd-ffd3a38ab02a --enable net-hwaddr,dhcp-client-state,ssh-hostkeys,ssh-userdir,udev-persistent-net

1.  Import into [glance](https://access.redhat.com/site/documentation/en-US/Red_Hat_Enterprise_Linux_OpenStack_Platform/2/html/Getting_Started_Guide/ch09s02.html):

      glance image-create --name "neutron-appliance" --is-public true --disk-format qcow2 --file 93b372dc-022e-4c49-a0aa-988cb1876c18 --container-format bare

1.  Add 'glance' as external provider into ovirt
2.  Import "neutron-appliance" as a template
3.  Create a vm based on the "neutron-appliance" template with cloud-init (root password, nic as eth0)

### Benefit to oVirt

There are two major benefits for having this feature:

1.  Enhance oVirt networking capabilities by Neutron services.
2.  Provide 'soft landing' for ovirt users in the OpenStack field.

### Dependencies / Related Features

The neutron virtual appliance is provided as an image which contains:

1.  CentOS 6.5 (based on public CentOS-6.5 image at glance.ovirt.org)
2.  Havana RDO
3.  Cloud-init 0.7.2-2

### Documentation / External references

[RDO documentation](http://openstack.redhat.com/Docs)

### Testing

1.  Create a vm based on neutron-appliance image
2.  Connect to the vm (ssh/console)

       # . /root/keystonerc_admin
       # neutron net-list

A list of existing networks should appear.

1.  Add the neutron server vm into ovirt-engine and run it.
2.  Add an external network provider with the vm address.
3.  Discover the networks of the external provider.
4.  Create a network 'testnet' on the provider.
5.  Add a subnet for that network
6.  Install a host with the external network provider
7.  Add a vm 'test1' which has a vnic connected to 'testnet'
8.  run vm 'test1' with cloud-init and configure its vnic for DHCP
9.  Verify an IP address was obtained by the vm.

#### Test neutron services

More scenarios can be taken from [Testing ovirt-neutron integration](Features/OSN_Integration#Testing)

### Open Issues

*   Should the default quotas as configured on the neutron server should be increased ?

      [root@localhost ~(keystone_admin)]# neutron quota-show 
      +---------------------+-------+
      | Field               | Value |
      +---------------------+-------+
      | floatingip          | 50    |
      | network             | 10    |
      | port                | 50    |
      | router              | 10    |
      | security_group      | 10    |
      | security_group_rule | 100   |
      | subnet              | 10    |
      +---------------------+-------+

*   Currently, the only supported plugin is Open vSwitch plugin. Is there any need for other plugin types ?

<Category:Feature> <Category:Template>
