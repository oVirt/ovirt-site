---
title: oVirt Software Defined Networking, The OVN Network Provider
author: mmirecki
date: 2016-10-03 14:21:00 UTC
tags: community, howto, blog, network
comments: true
published: true
---

oVirt offers not only its own internal networking, but also an API for external network providers. This API enables using external network management software inside environments managed by oVirt and takes advantage of their extended capabilities. 
One of such solutions is OVN: Open Virtual Network. OVN is an OVS (Open vSwitch) extension that brings Software Defined Networking to [OVS](http://openvswitch.github.io/support/dist-docs/README.md.html).

OVN enables support for virtual networks abstraction by adding native OVS support for virtual L2 and L3 overlays.

READMORE

The oVirt provider for OVN consists of two parts:
* The oVirt OVN driver
* The oVirt OVN provider

## oVirt OVN Driver

The oVirt OVN driver is the Virtual Interface Driver placed on oVirt hosts that handles the wiring of VM NICs to OVN networking.

The driver allows Vdsm, libvirt, and OVN to interact whenever a NIC is pluged in such a way that the VM NIC is added to an appropriate OVN Logical Switch and the appropriate OVN overlays on all the hosts in the oVirt environment.

The [oVirt OVN driver rpm](http://resources.ovirt.org/repos/mmirecki/ovirt-provider-ovn-driver-0-1.noarch.rpm) is now available. The latest version can always be downloaded and built from the repository (described later in this article). Once the rpm is downloaded, it can be installed in the following way:

    `dnf install ovirt-provider-ovn-driver-0-1.noarch.rpm`

OVN requires Vdsm and OVN (version 2.6 or later) to be installed on the host. The following OVN packages are required by the ovirt-provider-ovn-driver rpm:

* `openvswitch`
* `openvswitch-ovn-common`
* `openvswitch-ovn-host`
* `python-openvswitch`

These are available from the [OVS website](http://openvswitch.org/download/) or built using the code downloaded from the OVS repo (described below).

After installing the driver and OVN, the OVN-controller must be configured. This can be done either using the vdsm-tool:

    `vdsm-tool ovn-config <OVN central IP> <local IP used for OVN tunneling>`

or by using the OVN command-line interface directly. For more information about OVN-controller setup, please check the
[OVS ducumentation](http://openvswitch.org/support/dist-docs/) 

## oVirt OVN Provider

The oVirt OVN provider is a proxy that the oVirt Engine uses to interact with OVN. It is delivered as an rpm that is to be installed on the host where OVN central is installed.

The [oVirt OVN provider RPM](http://resources.ovirt.org/repos/mmirecki/ovirt-provider-ovn-0-1.noarch.rpm) is also available now. The latest version can always be downloaded and built from the repository as well. Once the rpm is downloaded, it can be installed with this command:

    `yum install ovirt-provider-ovn-0-1.noarch.rpm`

OVN requires OVN to be installed on the host (version 2.6 or later). The following OVN packages must be installed:

* `openvswitch`
* `openvswitch-ovn-common`
* `openvswitch-ovn-central`
* `python-openvswitch`

These are also available from the [OVS website](http://openvswitch.org/download/) or built using the code downloaded from the OVS repo (described below).

After installing the oVirt OVN provider, the admin needs to open up port 9696 in the firewall.
This can be done manually or by adding the ovirt-provider-ovn firewalld service to the appropriate firewalld zone.

`firewall-cmd --zone=<zone to add service to> --add-service=ovirt-provider-ovn --permanent`
`firewall-cmd --reload`

The zone currently selected as default can be obtained by executing:

`firewall-cmd --get-default-zone`

After installation, the provider can be started as follows:

	`systemctl start ovirt-provider-ovn`

The provider can then be added to oVirt as an external network provider. In order to add a new provider, go to the External Providers section in the oVirt UI and click the Add button.

![adding a new provider](uarwo40-edit-cluster.png)

When the provider is successfully added, existing OVN networks can be imported to oVirt.
New OVN networks can be defined using oVirt by adding a network and specifying it to be added on an external provider (make sure you add the external provider in read-write mode, so that you can add external networks from oVirt).

A VM NIC can be added to OVN networks by simply choosing an external network during NIC provisioning.

OVN based networking brings many advantages to oVirt:
* More granular security - it brings complete network isolation without the need for defining VLANs.
* Less resources - since the OVN networks are logical overlays, many of them can be defined on the same underlying physical infrastructure. As oposed to traditional oVirt networking, where each network required a separate host NIC, all the OVN networks can be acommodated on a single NIC.
* Easier management - the management of the networking infrastructure should also become much easier, as instead of managing the network isolation on each of the networking components, it will be automatically taken care of by OVN.

## Building oVirt OVN Provider rpms From Repository

Clone the repository:

`git clone https://github.com/openvswitch/ovirt-provider-ovn`

Build the rpms:

`cd ovirt-provider-ovn`
`make rpm`

The built rpms can be found in: `~/rpmbuild/RPMS/noarch/`

## Building OVN Provider rpms From Repository

Clone the repository:

`git clone https://github.com/openvswitch/ovs`

Install the following packages, as they are need to build ovn:

`dnf -y install gcc make python-devel openssl-devel kernel-devel graphviz kernel-debug-devel autoconf automake rpm-build redhat-rpm-config rpm-build rpmdevtools bash-completion autoconf automake libtool PyQt4 groff libcap-ng-devel python-twisted-core python-zope-interface graphviz openssl-devel selinux-policy-devel`

Build the ovn rpms:

`cd ovs`
`./boot.sh`
`./configure`
`make dist`
`cp openvswitch-<version>.tar.gz $HOME/rpmbuild/SOURCES`
`cd $HOME/rpmbuild/SOURCES`
`tar xzf openvswitch-<version>.tar.gz`
`cd openvswitch-<version>`
`rpmbuild -bb rhel/openvswitch-fedora.spec` 

The built rpms will reside here: `~/rpmbuild/RPMS/x86_64/`

## useful Links

* [Project repository](https://gerrit.ovirt.org/#/q/project:ovirt-provider-ovn)
* [oVirt provider for OVN](http://www.ovirt.org/develop/release-management/features/ovirt-ovn-provider/)
* [External network providers](http://www.ovirt.org/develop/release-management/features/external-network-provider/)
* [OVS ducumentation](http://openvswitch.org/support/dist-docs/) 
* [OVN architecture](http://openvswitch.org/support/dist-docs/ovn-architecture.7.html)
