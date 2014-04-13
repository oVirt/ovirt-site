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
---

# Neutron Virtual Appliance

### Summary

oVirt engine has integrated the OpenStack Neutron service as a [network provider](Features/OSN_Integration), providing the ovirt-engine administrator to leverage the neutron services to be consumed by oVirt.
However, in order to provision neutron services, one needs to manually deploy a neutron and keystone services.
The Neutron Virtual Appliance designed to provide an easy and simple deployment of the neutron service.

### Owner

*   Name: [ Moti Asayag](User:Moti Asayag)
*   Email: <masayag@redhat.com>

### Current status

*   Last updated on -- by [ WIKI}}](User:{{urlencode:{{REVISIONUSER}})

### Detailed Description

The feature designed to ease the neutron services provisioning from within ovirt by reducing the overhead of installing and configuring OpenStack.
For that purpose an image was created for a rapid provisioning, where the image contains all of the relevant services installed and configured with basic configuration that allows the ovirt-engine administrator with few (or more) steps to use the neutron services from ovirt.
The neutron appliance for ovirt-engine 3.5 is based on the Havana-RDO which uses [Packstack](https://wiki.openstack.org/wiki/Packstack) for installing OpenStack.

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

#### Create a vm based on neutron-appliance image

1.  Add new vm network named 'neutron' in the relevant data-center.
2.  Edit the 'neutron' vnic profile to include custom properties "mac-spoof=true".
3.  Import the neutron-appliance image as a template from the glance.ovirt.org repository.
4.  Configure the VM with 2048MB memory and 2 vnics:
    1.  eth0 - connected to 'ovirtmgmt' (needs to communicate with the ovirt-engine and with compute nodes)
    2.  eth1 - connected to 'neutron' vm network

#### Run the neutron server vm

1.  Run the vm with cloud-init:
    1.  Set a root password.
    2.  Configure a static IP address for eth0

2.  Connect to the vm (ssh/console)

       # . /root/keystonerc_admin
       # neutron net-list

A list of existing networks should appear.

#### Configure Neutron network provider on ovirt-engine

`# engine-config -s KeystoneAuthUrl=`[`http://NEUTRON_SERVER_IP_ADDRESS:35357/v2.0/`](http://NEUTRON_SERVER_IP_ADDRESS:35357/v2.0/)

1.  Restart the ovirt-engine
2.  Add external network provider with the following properties:
3.  On the general left tab:
    1.  Type: OpenStack Network
    2.  Networking Plugin: Open vSwitch
    3.  Provider URL: <http://NEUTRON_SERVER_IP_ADDRESS:9696>
    4.  User name: neutron
    5.  Password: should be found by: 'grep CONFIG_NEUTRON_KS_PW /root/packstack-answers.txt' on the neutron server vm.
    6.  Tenant name: services

Verify 'connectivity test' passes (by clicking the 'Test' button)

1.  On the Agent Configuration left tab:
    1.  Bridge Mappings: vmnet:br-neutron
    2.  QPID:
    3.  Host: NEUTRON_SERVER_IP_ADDRESS
    4.  Port: 5672
    5.  Username: guest
    6.  Password: guest

#### Install a Host with the network provider

1.  Install host with external network provider by clicking the 'network provider' left tab
2.  select the newly configured network provider and set:
    1.  bridge_mappings = vmnet:br-neutron

3.  Click 'OK'
4.  yum -y install vdsm-hook-macspoof
5.  Configure 'neutron' network on the host

      # ovs-vsctl add-port br-neutron neutron

#### Test neutron services

Specific scenarios will be added later, for now these test cases should be fine: [Testing ovirt-neutron integration](Features/OSN_Integration#Testing)

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
