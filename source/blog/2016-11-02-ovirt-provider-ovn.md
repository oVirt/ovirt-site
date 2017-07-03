---
title: oVirt Software Defined Networking, The OVN Network Provider
author: mmirecki
date: 2016-11-02 17:00:00 UTC
tags: community, howto, blog, network
comments: true
published: true
---

oVirt offers not only its own internal networking, but also an API for external network providers. This API enables using external network management software inside environments managed by oVirt and takes advantage of their extended capabilities.
One of such solutions is OVN: Open Virtual Network. OVN is an OVS (Open vSwitch) extension that brings Software Defined Networking to [OVS](http://openvswitch.github.io/support/dist-docs/README.rst.html).

OVN enables support for virtual networks abstraction by adding native OVS support for virtual L2 and L3 overlays.
This allows the user to create as many VM networks as required, without troubling the adminstrator with vlan requests or infrastructure changes.

READMORE

The oVirt provider for OVN consists of two parts:
* The oVirt OVN driver
* The oVirt OVN provider

## oVirt OVN Driver

The oVirt OVN driver is the Virtual Interface Driver placed on oVirt hosts that handle the wiring of VM NICs to OVN networking.

The driver allows Vdsm, libvirt, and OVN to interact whenever a NIC is plugged in such a way that the VM NIC is added to an appropriate OVN Logical Switch and the appropriate OVN overlays on all the hosts in the oVirt environment.

The [oVirt OVN driver rpm](http://resources.ovirt.org/repos/mmirecki/ovirt-provider-ovn-driver-1.0-1.fc24.noarch.rpm) is now available for testing. The latest version can always be downloaded and built from the repository (described later in this article). Once the rpm is downloaded, it can be installed in the following way:

    yum install ovirt-provider-ovn-driver-1.0-1.fc24.noarch.rpm

OVN requires Vdsm and OVN (version 2.6 or later) to be installed on the host. The following OVN packages are required by the ovirt-provider-ovn-driver rpm:

* `openvswitch`
* `openvswitch-ovn-common`
* `openvswitch-ovn-host`
* `python-openvswitch`

These are available from the [OVS website](http://openvswitch.org/download/) or built using the code downloaded from the OVS repo (described below).

The OVN-controller service can be started using the following command:

    systemctl start ovn-controller

In order to make the service start automatically at boot, the service could be enabled using:

    systemctl enable ovn-controller

After installing the driver and OVN, the OVN-controller must be configured. This can be done either using the vdsm-tool:

    vdsm-tool ovn-config <OVN central server IP> <local IP used for OVN tunneling>

The second parameter (local IP used for OVN tunneling) can be the IP address of the ovirtmgmt interface on the host, and should be reachable by OVN hosts and central server.
vdsm-tool will also configure ovn-controller with the PKI required to safely connect to the ovn central server.
To add support for Transport Layer Security (TLS) connectivity with the OVN-controller, vdsm-tool will use the VDSM private and public keys, and configures OVN-controller to enable PKI encryption between the host and the OVN south db on the OVN central server. This provides privacy and data-integrity in the management connections to the south database

The OVN-controller can also be set up by using the OVN command-line interface directly. For more information about OVN-controller setup, please check the
[OVS documentation](http://openvswitch.org/support/dist-docs/).

The command above should create OVN tunnels to other OVN controllers (if at least one other ovn-controller is present).
Please verify that the tunnel has been created by issuing the following commands:

`ip link` - the result should include a link called `genev_sys_ ...`

`ovs-vsctl show` - the bridge `br-int` should include a port looking somewhat like this:

    Port "ovn-6b2d2f-0"
       Interface "ovn-6b2d2f-0"
            type: geneve
            options: {csum="true", key=flow, remote_ip="10.35.128.14"}


Please check the OVN logs in case of problems. The relevant OVN logs are located in `/var/log/openvswitch/`.


## oVirt OVN Provider

The oVirt OVN provider is a proxy that the oVirt Engine uses to interact with OVN. It is delivered as an rpm that is to be installed on the host where OVN central is installed.

The [oVirt OVN provider RPM](http://resources.ovirt.org/repos/mmirecki/ovirt-provider-ovn-1.0-1.fc24.noarch.rpm) is also available now. The latest version can always be downloaded and built from the repository as well. Once the rpm is downloaded, it can be installed with this command:

    yum install ovirt-provider-ovn-1.0-1.fc24.noarch.rpm

OVN requires OVN to be installed on the host (version 2.6 or later).
The OVN provider requires the following OVS and OVN packages:

* `openvswitch`
* `openvswitch-ovn-common`
* `openvswitch-ovn-central`
* `python-openvswitch`

These are also available from the [OVS website](http://openvswitch.org/download/) or built using the code downloaded from the OVS repo (described below).

After installing the oVirt OVN provider, the admin needs to open up port 9696 in the firewall.
This can be done manually or by adding the ovirt-provider-ovn firewalld service to the appropriate firewalld zone with:

    firewall-cmd --zone=<zone to add service to> --add-service=ovirt-provider-ovn --permanent
    firewall-cmd --reload

The zone currently selected as default can be obtained by executing:

    firewall-cmd --get-default-zone

Firewalld also needs to be configured for OVN components. This will be handled by OVN in the near future (https://bugzilla.redhat.com/1390938).
In the mean time the following commands open the required ports on the OVN central server:

    firewall-cmd --permanent --zone=public --add-rich-rule='rule family="ipv4" port protocol="tcp" port="6641" accept'

    firewall-cmd --permanent --zone=public --add-rich-rule='rule family="ipv4" port protocol="tcp" port="6642" accept'

Stop iptables on the hosts (needed for OVN tunnels):

    systemctl stop iptables


After installation, the provider can be started as follows:

    systemctl start ovirt-provider-ovn

Enable the service in order to make it start at boot, use:

    systemctl enable ovirt-provider-ovn

Since OVS 2.7, OVN central must be configured to listen to requests on appropriate ports:

    ovn-sbctl set-connection ptcp:6642
    ovn-nbctl set-connection ptcp:6641


The provider can then be added to oVirt as an external network provider. In order to add a new provider, go to the External Providers section in the oVirt UI and click the Add button.

![adding a new provider](new-ovirt-provider-ovn.png)

When the provider is successfully added, existing OVN networks can be imported to oVirt.
New OVN networks can be defined using oVirt by adding a network and specifying it to be added on an external provider (make sure you add the external provider in read-write mode, so that you can add external networks from oVirt).

A vNIC can be attached to OVN network by simply choosing an external network during NIC provisioning.

OVN based networking brings many advantages to oVirt:
* More granular security - it brings complete network isolation without the need for defining VLANs.
* Easier management - the management of the networking infrastructure should also become much easier, as instead of managing the network isolation on each of the networking components, it will be automatically taken care of by OVN.
* Self service - the user can create many VM networks without troubling the network admin with vlan or infrastructure requests.

## Building oVirt OVN Provider rpms from repository

Clone the repository:

    git clone https://gerrit.ovirt.org/ovirt-provider-ovn

Build the rpms:

    cd ovirt-provider-ovn
    make rpm

The built rpms can be found in: `~/rpmbuild/RPMS/noarch/`

## Building OVN rpms from repository

Note: for the most up-to-date description of building OVS resources please refer to <a href="http://openvswitch.org">the OVS site</a>

Clone the repository:

    git clone https://github.com/openvswitch/ovs

Install the following packages, as they are need to build ovn:

    yum -y install gcc make python-devel openssl-devel kernel-devel graphviz kernel-debug-devel autoconf automake rpm-build redhat-rpm-config rpm-build rpmdevtools bash-completion autoconf automake libtool PyQt4 groff libcap-ng-devel python-twisted-core python-zope-interface graphviz openssl-devel selinux-policy-devel

Build the ovn rpms:

    cd ovs
    ./boot.sh
    ./configure
    make dist
    cp openvswitch-<version>.tar.gz $HOME/rpmbuild/SOURCES
    cd $HOME/rpmbuild/SOURCES
    tar xzf openvswitch-<version>.tar.gz
    cd openvswitch-<version>
    rpmbuild -bb rhel/openvswitch-fedora.spec

The built rpms will reside here: `~/rpmbuild/RPMS/x86_64/`

## Provider setup using the engine-setup script

The provider can be set up on the engine host using the engine-setup tool.
The engine-setup tool is part of oVirt engine installation and is located in:

    /bin/engine-setup

During the setup process, engine-setup script will ask the user several questions related to OVN:

* `Install ovirt-provider-ovn(Yes, No) [Yes]?:`
  If 'Yes', engine-setup will install ovirt-provider-ovn.
  If engine-setup is used to update a system, this will only be asked if ovirt-provider-ovn has not been installed previously.
  If you reply 'No', you will not be asked again on the next run of engine-setup. If you do want to get asked again, run engine-setup with '--reconfigure-optional-components'.
* `Use default credentials (admin@internal) for ovirt-provider-ovn(Yes, No) [Yes]?:`
  If 'Yes', engine-setup will use the default engine user and password specified earlier in the setup process.
  This option is only available during new installations.
* `oVirt OVN provider user[admin]:`
   If the default credentials are not chosen, the user name which to use to connect to the provider.
* `oVirt OVN provider password[empty]:`
   If the default credentials are not chosen, the password to use to connect to the provider.

If used to set up ovirt-provider-ovn, engine-setup will perform the following tasks:

* install OVS and OVN packages on the engine
* install ovirt-provider-ovn on the engine
* add and configure a default External Network OVN provider. The engine provider will be configured to connect to provider on localhost. The provider will also be configured with the user and password specified during the setup process.
* generate the PKI (public key infrastructure) for OVN north db, OVN southdb and ovirt-provider-ovn (shared key for serving https and comunicating with OVN north db)
* configure the OVN north and south databases to use SSL
* configure the provider to use https
* configure the provider to connect to OVN north DB using SSL

### Configuring PKI manually

The PKI (public key infrastructure) for the provider and driver are configured automatically by engine-setup and vdsm-tool.
In case where the provider is not installed together with ovirt-engine, PKI will need to be created and configured manually.

In such a case, key/certificate pair signed by a common authority will be needed for the provider, ovn north db, ovn south db, and each of the ovn controllers.

Some of the possible ways to generate key/certificate pairs are using [OpenSSL](https://www.openssl.org/) or openvswitch [ovs-pki command](http://openvswitch.org/support/dist-docs/ovs-pki.8.txt).

The ovn north db must be configured using the following commands:

    ovn-nbctl set-ssl <private key file> <certificate file> <ca certificate file>
    ovn-nbctl set-connection pssl:6641

The ovn south db must be configured using the following commands:

    ovn-sbctl set-ssl <private key file> <certificate file> <ca certificate file>
    ovn-sbctl set-connection pssl:6642

The provider must be configured by setting the follwing values in the configuration file (/etc/ovirt-provider-ovn/ovirt-provider-ovn.conf):

    [SSL]
    ssl_enabled=true # enables/disables https for the REST API
    key-file=<private key file>
    cert-file=<certificate file>
    cacert-file=<ca certificate file>

The PKI of the provider will be used to connect to the OVN north db, as well as for the https connection.
The CA certificate must used for signing the certificate must be added to the external provider trust store on the engine:

    keytool -import -alias <certificate alias> -keystore <key store file> -file <ca certificate file> -noprompt -storepass <store password>

The key store file and the store password are defined in `/usr/share/ovirt-engine/services/ovirt-engine/ovirt-engine.conf`.

The ovn-controller can be set up using the `setup_ovn_controller` script (/usr/libexec/ovirt-provider-ovn/setup_ovn_controller.sh):

    setup_ovn_controller.sh <OVN central IP> <local tunneling IP> <private key file> <certificate file> <ca certificate file>

## Tested environments

This guide has been tested on both Fedora24 and RHEL7 environments.

Note: Currently a OVS spec file for Fedora is the only available in the OVS repo. We are however using the generated rpm's on RHEL7 and have not encountered any problems so far. Please consult the OVS team for more info.


## Useful Links

* <a href="http://resources.ovirt.org/repos/mmirecki/ovirt-provider-ovn-1.0-1.fc24.noarch.rpm">ovirt-provider-ovn RPM</a>
* <a href="http://resources.ovirt.org/repos/mmirecki/ovirt-provider-ovn-driver-1.0-1.fc24.noarch.rpm">ovirt-provider-ovn-driver RPMy</a>
* <a href="http://jenkins.ovirt.org/job/ovirt-provider-ovn_master_build-artifacts-el7-x86_64/lastSuccessfulBuild/artifact/exported-artifacts/">Latest development build</a>

* <a href="https://gerrit.ovirt.org/#/q/project:ovirt-provider-ovn">Project repository</a>
* <a href="http://www.ovirt.org/develop/release-management/features/ovirt-ovn-provider/">oVirt provider for OVN</a>
* <a href="http://www.ovirt.org/develop/release-management/features/external-network-provider/">External network providers</a>

* <a href="http://openvswitch.org/support/dist-docs/">OVS ducumentation</a>
* <a href="http://openvswitch.org/support/dist-docs/ovn-architecture.7.html">OVN architecture</a>

