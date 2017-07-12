---
title: NeutronVirtualAppliance
category: feature
authors: danken, moti
feature_name: Neutron Virtual Appliance
feature_modules: network
feature_status: Completed
---

# Neutron Virtual Appliance

## Summary

oVirt engine has integrated the OpenStack Neutron service as a [network provider](/develop/release-management/features/network/osn-integration/). The OpenStack network provider enables ovirt-engine to consume Neutron services.
However, in order to provision Neutron services, one needs to manually deploy Neutron and Keystone services.
The Neutron Virtual Appliance designed to provide an easy and simple deployment of those services.

Neutron virtual appliance in oVirt-engine **demo** can be watched [here](http://youtu.be/naLFSFwHI94).

## Owner

*   Name: Moti Asayag (Moti Asayag)
*   Email: <masayag@redhat.com>
*   Gitweb: <http://gerrit.ovirt.org/gitweb?p=ovirt-appliance.git>
    -   Pre-release development playground: <https://github.com/masayag/ovirt-appliance/>

## Detailed Description

The feature designed to ease the neutron services provisioning from within ovirt by reducing the overhead of installing and configuring OpenStack.
For that purpose an image was created for a rapid provisioning, where the image contains all of the relevant services installed and configured with basic configuration that allows the ovirt-engine administrator with few (or more) steps to use the neutron services from ovirt.
The neutron appliance for ovirt-engine 3.5 is based on the [IceHouse-RDO](http://openstack.redhat.com/Quickstart) which uses [Packstack](https://wiki.openstack.org/wiki/Packstack) for installing OpenStack.
 The neutron appliance node contains the following services:

1.  Neutron server (ML2 core plugin)
2.  Neutron L3 Agent
3.  Neutron DHCP Agent
4.  Open vSwitch Agent
5.  Open vSwitch
6.  RabbitMQ (messaging)
7.  Keystone
8.  MariaDB

### Neutron Appliance Topology

The neutron appliance is a vm running on one of ovirt's nodes. It is connected to two ovirt-engine networks:

*   To the 'ovirtmgmt' network for the ovirt-engine to communicate with the neutron server API.
*   To a designated network named *neutron*, which should be configured on any host designed to run vms to use external networks.

The following image demonstrates the neutron appliance topology:

![](/images/wiki/Neutron-appliance-topology.png)

## Add OpenStack network external provider using the Neutron appliance

### Create a vm based on neutron-appliance image

1.  Add new vm network (e.g. named 'neutron') in the relevant data-center.
2.  Edit the 'neutron' vnic profile of the 'neutron' network to include custom properties "ifacemacspoof=true"
    1.  Instructions for adding the 'ifacemacspoof' property can be found [here](https://github.com/oVirt/vdsm/tree/master/vdsm_hooks/macspoof).
    2.  Restart the ovirt-engine service to refresh the new configuration value.
    3.  Enabling mac-spoofing is required for the appliance specifically for dhcp agent which is connected to the networks bridge by a port (one or more dhcp agent per network). In order for packets not to be blocked by ebtable rules (introduced by [nwfilter](/develop/release-management/features/network/networkfiltering/)), mac-spoof should be enabled.

<!-- -->

1.  Import the neutron-appliance image as a template (e.g. named 'neutron-appliance') from the glance.ovirt.org repository.
2.  Add a new VM (i.e. named 'neutron-provider') with 4GB RAM based on 'neutron-appliance' template and with 2 vnics:
    1.  eth0 - connected to 'ovirtmgmt' (needs to communicate with ovirt-engine and with the compute nodes/hypervisors)
    2.  eth1 - connected to 'neutron' network

3.  Edit "Initial Run" left-tab ([http://www.ovirt.org/Features/Cloud-Init_Integration integrated with cloud-init](/Features/Cloud-Init_Integration integrated with cloud-init)):
    1.  Add new user 'admin' (this user will be created as a sudoer).
    2.  Set the "SSH Authorized Keys" to enable accessing the vm via ssh (root login is disabled) or define a password for the 'admin' user.
    3.  Configure a static IP address (will be referred later as NEUTRON_SERVER_IP_ADDRESS) for eth0 (which is connected to 'ovirtmgmt') and set the 'start on boot' checkbox.
        1.  DHCP boot protocol can be used if the IP is statically configured on the DHCP server for eth0 mac address.

    4.  Configure for eth1 'None' boot protocol and set the 'start on boot' checkbox.

![ 700px](/images/wiki/EditVmInitialization.png  " 700px")

### Run the neutron server vm

1.  Install the macspoof hook on the host the vm is scheduled to be run on:
    1.  yum -y install vdsm-hook-macspoof

2.  Run the neutron vm on that host (it takes cloud-init ~4 minutes since vm boot to finish)
3.  VM IP address should be reported to ovirt-engine (due to ovirt-guest-agent installed on the vm)
4.  Connect to the vm (ssh with the user complaint to the specified key) and run the following to verify OpenStack services are active:

       # sudo -i
       # . /root/keystonerc_admin
       # openstack-status

**Note:** It is highly recommended to replace the neutron service password configured by the appliance:

*   Configure new password on keystone for *neutron* user:

       # . /root/keystonerc_admin
       # keystone user-password-update neutron

*   Edit /etc/neutron/neutron.conf and set **admin_password** to the new chosen password and restart neutron service:

       # openstack-service restart neutron-server

### Configure Neutron network provider on ovirt-engine

1.  engine-config -s KeystoneAuthUrl=<http://NEUTRON_SERVER_IP_ADDRESS:35357/v2.0/>
2.  Restart the ovirt-engine
3.  Add external network provider with the following properties:

    * On the general left tab:

    1. Type: OpenStack Network

    1. Networking Plugin: Open vSwitch

    1. Provider URL: <http://NEUTRON_SERVER_IP_ADDRESS:9696>

    1. User name: neutron

    1. Password: should be found by: "*grep '^admin_password' /etc/neutron/neutron.conf*" on the neutron server vm.

    1. Tenant name: services Verify 'connectivity test' passes (by clicking the 'Test' button).
![](/images/wiki/AddProvider.png)
    * On the Agent Configuration left tab:

    1. Bridge Mappings: vmnet:br-neutron

    1. Broker Type: RabbitMQ

    1. Host: NEUTRON_SERVER_IP_ADDRESS

    1. Port: 5672

    1. Username: guest

    1. Password: guest ![](/images/wiki/AddProviderAmqp.png)

### Install a Host with the network provider

1.  Configure OpenStack repository on the host (for ovirt-3.5 use rdo-release-icehouse-3):
    1.  yum install -y <http://repos.fedorapeople.org/repos/openstack/openstack-icehouse/rdo-release-icehouse-3.noarch.rpm>

2.  Install the host with external network provider by clicking the 'Network Provider' left tab
3.  Select the newly configured 'neutron' network provider and set:
    1.  bridge_mappings = vmnet:br-neutron

4.  Click 'OK' to engage the installation
5.  After installation is successfully completed, install the no-macspoof hook:
    1.  yum -y install vdsm-hook-macspoof

6.  Configure 'neutron' network on the host using the 'Setup Networks' dialog
7.  Run the following on the host, to connect neutron integration bridge to neutron network:
    1.  ovs-vsctl add-port br-neutron neutron

From this point, the following use cases are supported:

1.  Create external networks on the neutron server from ovirt-engine
2.  Import networks from neutron server into ovirt-engine
3.  Add subnets to the external networks
4.  Configure security groups on the networks' profiles
5.  Attach vms to the external networks

**\1** It is highly recommended to install all of the hosts within the same cluster with the external network provider (or to configured the hosts manually). If a cluster contains a mixture of hosts, both installed with the external provider and without it, there are expected failures to schedule the vm, as external networks are considered as 'non-required' networks in ovirt-engine 3.5.

## Making your own Neutron Virtual Appliance image

Steps for creating the image and sealing it are described [here](https://github.com/masayag/ovirt-appliance#creating-the-image). Once the image is created, follow the next steps:

1.  Import into [glance](https://access.redhat.com/site/documentation/en-US/Red_Hat_Enterprise_Linux_OpenStack_Platform/2/html/Getting_Started_Guide/ch09s02.html):

      glance image-create --name "neutron-appliance" --is-public true --disk-format qcow2 --file 93b372dc-022e-4c49-a0aa-988cb1876c18 --container-format bare

1.  Add 'glance' as external provider into ovirt
2.  Import "neutron-appliance" as a template
3.  Create a vm based on the "neutron-appliance" template with cloud-init (root password, nic as eth0)

## Benefit to oVirt

There are two major benefits for having this feature:

1.  Enhance oVirt networking capabilities by Neutron services.
2.  Provide 'soft landing' for ovirt users in the OpenStack field.

## Dependencies / Related Features

The neutron virtual appliance is provided as an image which contains:

1.  CentOS 7.0 (based on CentOS-7.0 ISO from <http://wiki.centos.org/Download>)
2.  IceHouse RDO

The installed hosts should have epel repository enabled.

## Documentation / External references

[RDO documentation](http://openstack.redhat.com/Docs)

## Testing

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

### Test neutron services

More scenarios can be taken from [Testing ovirt-neutron integration](/develop/release-management/features/network/osn-integration/#testing)

