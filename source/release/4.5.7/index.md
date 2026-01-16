---
title: oVirt 4.5.7 Release Notes
category: documentation
authors:
  - jasperb
toc: true
page_classes: releases
---


# oVirt 4.5.7 Release Notes

The oVirt Project is pleased to announce the availability of the 4.5.7 release as of January 13 2026.

oVirt is a free open-source distributed virtualization solution,
designed to manage your entire enterprise infrastructure.
oVirt uses the trusted KVM hypervisor and is built upon several other community
projects, including libvirt, Gluster, PatternFly, and Ansible.

This release is now available on x86_64 architecture for:

* oVirt Node NG (based on CentOS Stream 9)
* CentOS Stream 9
* CentOS Stream 10
* RHEL 9 and derivatives
* RHEL 10 and derivatives

To everyone using the oVirt Node NG we urge you to switch over to another way of using the product for ensured stability and security due to the way of how that product is structured.

To find out how to interact with oVirt developers and users and ask questions,
visit our [community page](/community/).
All issues or bugs should be reported via
[oVirt GitHub](https://github.com/oVirt).


If you'd like to try oVirt as quickly as possible, follow the instructions on
the [Download](/download/) page.


For complete installation, administration, and usage instructions, see
the [oVirt Documentation](/documentation/).

For a general overview of oVirt, read the [About oVirt](/community/about.html)
page.

To learn about features introduced before 4.5.7, see the
[release notes for previous versions](/documentation/#previous-release-notes).

> IMPORTANT
> If you are going to install on RHEL or derivatives please follow [Installing on RHEL](/download/install_on_rhel.html) first.

> NOTE
> It is important that for installs on RHEL 10 and derivatives that version 10.0-4 (or newer) of centos-release-ovirt45 is used.

## What's New in 4.5.7?

- CentOS 10 and AlmaLinux 10 support.
- Fixed [CVE-2024-7259](https://github.com/advisories/GHSA-9gxg-3rjh-xv63)
- Introduced [new CPUs](#New-cpu's)
- Bumped external dependencies.
- Implemented a new way of deploying to maven central.
- All Java code is now built on Java 21 and compatible with Java 11.
- Reconnect faster to hosts after reboot, instead of a static 10 minutes adapted to connect when the host is back online.
- On boot of VM have a spare of `NumOfPciExpressPorts` PCIe ports available instead of a fixed number.
- Add the optional `attach_wgt` flag to the vm start endpoint. This will auto attach the virtio-win iso to the vm.
- Ability to add tags to templates via UI in the administration panel.
- Add operating system description to host API object.
- Added option for user to decide preference of vnc console invocation.
- Added Windows 2025 and RHEL 10 to OS list.
- Improve isLiveDelete check on VM.
- Dropped deprecated packages.
- Dropped Ceph, Cinderlib and collectd in CentOS 10 due to not available.
- Added new DC/Cluster level (4.8).
- Cluster level 4.8 now uses `pc-q35-rhel9.6.0` machine type and enables discard-no-unref by default.
- Added ability to alter video device through API.
- Set audio value to ich9 starting from RHEL7 on Q35.
- When a VDS network error occurs during VM start, set the VM status to "Unknown" instead of letting it fall through to "Down". This to prevent duplicate VM deployments.
- Ability to update QoS on running VMs when a QoS profile has been modified or when QoS was changed on a vNIC profile.

Many more changes were implemented in the newest releases of the oVirt packages and can be read about in detail down below.

## New releases in 4.5.7

* [ovirt-engine-4.5.7](https://github.com/oVirt//ovirt-engine/releases/tag/ovirt-engine-4.5.7)
* [cockpit-ovirt-0.16.3](https://github.com/oVirt//cockpit-ovirt/releases/tag/cockpit-ovirt-0.16.3)
* [ovirt-hosted-engine-setup-2.7.2](https://github.com/oVirt//ovirt-hosted-engine-setup/releases/tag/ovirt-hosted-engine-setup-2.7.2)
* [ovirt-node-ng-4.4.3](https://github.com/oVirt//ovirt-node-ng/releases/tag/ovirt-node-ng-4.4.3)
* [ovirt-engine-extension-aaa-ldap-1.5.0](https://github.com/oVirt//ovirt-engine-extension-aaa-ldap/releases/tag/ovirt-engine-extension-aaa-ldap-1.5.0)
* [otopi-1.10.5](https://github.com/oVirt//otopi/releases/tag/otopi-1.10.5)
* [ovirt-engine-ui-extensions-1.3.8-1](https://github.com/oVirt//ovirt-engine-ui-extensions/releases/tag/ovirt-engine-ui-extensions-1.3.8-1)
* [imgbased-1.2.26](https://github.com/oVirt//imgbased/releases/tag/imgbased-1.2.26)
* [ovirt-engine-metrics-1.6.3](https://github.com/oVirt//ovirt-engine-metrics/releases/tag/ovirt-engine-metrics-1.6.3)
* [ovirt-engine-extension-aaa-jdbc-1.3.1](https://github.com/oVirt//ovirt-engine-extension-aaa-jdbc/releases/tag/ovirt-engine-extension-aaa-jdbc-1.3.1)
* [ovirt-engine-keycloak-15.0.2-7](https://github.com/oVirt//ovirt-engine-keycloak/releases/tag/ovirt-engine-keycloak-15.0.2-7)
* [engine-db-query-1.6.5](https://github.com/oVirt//engine-db-query/releases/tag/engine-db-query-1.6.5)
* [ovirt-host-4.5.1-1](https://github.com/oVirt//ovirt-host/releases/tag/ovirt-host-4.5.1-1)
* [ovirt-engine-extensions-api-1.0.2](https://github.com/oVirt//ovirt-engine-extensions-api/releases/tag/ovirt-engine-extensions-api-1.0.2)
* [ovirt-log-collector-4.5.1](https://github.com/oVirt//ovirt-log-collector/releases/tag/ovirt-log-collector-4.5.1)
* [ovirt-engine-extension-aaa-misc-1.1.2](https://github.com/oVirt//ovirt-engine-extension-aaa-misc/releases/tag/ovirt-engine-extension-aaa-misc-1.1.2)
* [ovirt-dependencies-4.5.7](https://github.com/oVirt//ovirt-dependencies/releases/tag/ovirt-dependencies-4.5.7)
* [ovirt-setup-lib-1.3.4](https://github.com/oVirt//ovirt-setup-lib/releases/tag/ovirt-setup-lib-1.3.4)
* [ovirt-engine-build-dependencies-4.5.7](https://github.com/oVirt//ovirt-engine-build-dependencies/releases/tag/ovirt-engine-build-dependencies-4.5.7)
* [ovirt-web-ui 1.9.4](https://github.com/oVirt/ovirt-web-ui/releases/tag/1.9.4)
* [vdsm v4.50.6.1](https://github.com/oVirt/vdsm/releases/tag/v4.50.6.1)
* [vdsm-jsonrpc-java v1.7.4](https://github.com/oVirt/vdsm-jsonrpc-java/releases/tag/v1.7.4)
* [python-ovirt-engine-sdk4 4.6.3](https://github.com/oVirt/python-ovirt-engine-sdk4/releases/tag/4.6.3)
* [ovirt-engine-api-metamodel 1.3.11](https://github.com/oVirt/ovirt-engine-api-metamodel/releases/tag/1.3.11)
* [ovirt-engine-api-model 4.6.1](https://github.com/oVirt/ovirt-engine-api-model/releases/tag/4.6.1)
* [ovirt-ansible-collection 3.2.1](https://github.com/oVirt/ovirt-ansible-collection/releases/tag/3.2.1-1)
* [ovirt-dwh 4.5.10](https://github.com/oVirt/ovirt-dwh/releases/tag/ovirt-engine-dwh-4.5.10)
* [ovirt-hosted-engine-ha v2.5.2](https://github.com/oVirt/ovirt-hosted-engine-ha/releases/tag/v2.5.2)
* [mom 0.6.5](https://github.com/oVirt/mom/releases/tag/v0.6.5)
* [ovirt-engine-sdk-ruby 4.6.1](https://github.com/oVirt/ovirt-engine-sdk-ruby/releases/tag/4.6.1)
* [ovirt-engine-sdk-java 4.6.0](https://github.com/oVirt/ovirt-engine-sdk-java/releases/tag/4.6.0)
* [ovirt-provider-ovn 1.2.36](https://github.com/oVirt/ovirt-provider-ovn/releases/tag/1.2.36)
* [ovirt-engine-nodejs-modules 2.3.21](https://github.com/oVirt/ovirt-engine-nodejs-modules/releases/tag/2.3.21)
* [ovirt-vmconsole 10.0.10](https://github.com/oVirt/ovirt-vmconsole/releases/tag/v1.0.10)
* [terraform-provider-ovirt v2.2.0](https://github.com/oVirt/terraform-provider-ovirt/releases/tag/v2.2.0)
* [ovirt-engine-sdk 4.5.1](https://github.com/oVirt/ovirt-engine-sdk/releases/tag/4.5.1)
* [ioprocess v1.4.3](https://github.com/oVirt/ioprocess/releases/tag/v1.4.3)
* [userstorage 0.5.3](https://github.com/oVirt/userstorage/releases/tag/v0.5.3)
* [ovirt-tinycore-linux v13.13](https://github.com/oVirt/ovirt-tinycore-linux/releases/tag/v13.13)
* [ovirt-engine-wildfly 24.0.1-3](https://github.com/oVirt/ovirt-engine-wildfly/releases/tag/24.0.1-3)
* [ovirt-jboss-modules-maven-plugin 2.0.4](https://github.com/oVirt/ovirt-jboss-modules-maven-plugin/releases/tag/2.0.4)


## Contributors

33 people contributed to this release:

* [Arthur Verschaeve](https://github.com/arthurvr) (Contributed to: ovirt-site)
* [Artur Socha](https://github.com/arso) (Contributed to: vdsm-jsonrpc-java)
* [Brian King](https://github.com/inflatador) (Contributed to: mom)
* [Brooklyn Dewolf](https://be.linkedin.com/in/brooklyndewolf) (Contributed to: vdsm)
* [Eli Marcus](https://github.com/emarcusRH) (Contributed to: ovirt-site)
* [Frank Wall](https://github.com/fraenki) (Contributed to: ovirt-site)
* [Geoff O'Callaghan](https://github.com/gocallag) (Contributed to: ovirt-site, ovirt-node-ng-image, ovirt-appliance)
* [Jasper Berton](https://github.com/JasperB-TeamBlue) (Contributed to: ovirt-engine, vdsm, ovirt-web-ui, ovirt-engine-sdk, ovirt-site, cockpit-ovirt, ovirt-engine-sdk-java, mom, ovirt-engine-sdk-ruby, ovirt-provider-ovn, ovirt-engine-api-model, ovirt-hosted-engine-setup, python-ovirt-engine-sdk4, ovirt-engine-sdk-go, java-client-kubevirt, ovirt-engine-extension-aaa-ldap, ovirt-engine-api-metamodel, ovirt-engine-ui-extensions, imgbased, ovirt-engine-metrics, releng-tools, ovirt-engine-extension-aaa-jdbc, ovirt-engine-keycloak, ovirt-hosted-engine-ha, engine-db-query, ovirt-cockpit-sso, ovirt-lldp-labeler, ovirt-engine-extensions-api, ovirt-log-collector, ovirt-engine-nodejs-modules, ovirt-engine-extension-aaa-misc, ovirt-jboss-modules-maven-plugin, ovirt-dependencies, ovirt-setup-lib, ovirt-engine-build-dependencies)
* [Jean-Louis Dupond](https://github.com/dupondje) (Contributed to: ovirt-engine, vdsm, terraform-provider-ovirt, ovirt-web-ui, ovirt-engine-sdk, ovirt-ansible-collection, cockpit-ovirt, ovirt-engine-sdk-java, ovirt-node-ng-image, ovirt-appliance, ovirt-imageio, mom, ovirt-engine-sdk-ruby, ovirt-provider-ovn, ovirt-engine-api-model, ovirt-hosted-engine-setup, python-ovirt-engine-sdk4, ovirt-engine-sdk-go, ovirt-system-tests, java-client-kubevirt, ovirt-engine-extension-aaa-ldap, otopi, vdsm-jsonrpc-java, ovirt-engine-api-metamodel, ovirt-engine-ui-extensions, imgbased, ovirt-release, ovirt-openvswitch, ovirt-engine-metrics, ovirt-vmconsole, ovirt-engine-extension-aaa-jdbc, ovirt-dwh, ovirt-engine-keycloak, ost-images, ovirt-hosted-engine-ha, engine-db-query, ovirt-cockpit-sso, ioprocess, buildcontainer, ovirt-engine-extensions-api, ovirt-log-collector, ovirt-engine-nodejs-modules, ovirt-engine-extension-aaa-misc, ovirt-jboss-modules-maven-plugin, ovirt-dependencies, ovirt-engine-wildfly, ovirt-setup-lib, userstorage, ovirt-tinycore-linux, ovirt-resources-upload-action, ovirt-build-dependencies, ovirt-engine-build-dependencies)
* [Anton](https://github.com/xakod) (Contributed to: ovirt-imageio)
* [Jiri Slezka](https://github.com/dron23) (Contributed to: ovirt-engine)
* [Joschokvc](https://github.com/JoschoKVC) (Contributed to: ovirt-engine-extension-aaa-jdbc)
* [José Enrique Gutiérrez Mazón](https://github.com/josgutie) (Contributed to: vdsm)
* [Juan Hernandez](https://github.com/jhernand) (Contributed to: ovirt-engine-sdk-ruby, ovirt-engine-api-metamodel)
* [Keenan Brock](https://github.com/kbrock) (Contributed to: ovirt-engine-sdk-ruby)
* [Lev Veyde](https://github.com/lveyde) (Contributed to: ovirt-site)
* [Marc Dequènes (Duck)](https://github.com/duck-rh) (Contributed to: ovirt-site)
* [Marcin Sobczyk](https://github.com/tinez) (Contributed to: vdsm, ovirt-system-tests, ovirt-vmconsole, ost-images)
* [Martin Necas](https://github.com/mnecas) (Contributed to: ovirt-ansible-collection)
* [Martin Perina](https://github.com/mwperina) (Contributed to: ovirt-engine-extension-aaa-ldap, ovirt-engine-extension-aaa-misc)
* [Maxime Besson](https://github.com/maxbes) (Contributed to: terraform-provider-ovirt)
* [Michael Trapp](https://github.com/TrappM) (Contributed to: vdsm)
* [Michalskrivanek](https://github.com/michalskrivanek) (Contributed to: ovirt-node-ng-image, ovirt-appliance, ovirt-system-tests)
* [Peter Boden](https://github.com/peter-boden) (Contributed to: ovirt-engine, vdsm, ovirt-ansible-collection, ovirt-provider-ovn, ovirt-engine-api-model, ovirt-system-tests, otopi, vdsm-jsonrpc-java, ovirt-vmconsole, releng-tools, ovirt-dwh, ost-images, ovirt-tinycore-linux, ovirt-engine-build-dependencies)
* [Puhamihai](https://github.com/puhamihai) (Contributed to: terraform-provider-ovirt)
* [Raaghav Wadhawan](https://github.com/Raaghavcodes) (Contributed to: ovirt-engine)
* [Sandro Bonazzola](https://github.com/sandrobonazzola) (Contributed to: ovirt-site, 512-byte-vm, ovirt-node-ng-image, ovirt-engine-sdk-ruby, python-ovirt-engine-sdk4, ovirt-system-tests, ovirt-engine-api-metamodel, imgbased, ovirt-release, ovirt-dwh, ost-images, ovirt-host, ioprocess, safelease, upload-rpms-action, checkout-action, ovirt-engine-build-dependencies)
* [Sergii Kuzko](https://github.com/gorsing) (Contributed to: vdsm)
* [Shubhaoracle](https://github.com/shubhaOracle) (Contributed to: vdsm, ovirt-ansible-collection)
* [Stanislav Melnichuk](https://github.com/0ffer) (Contributed to: ovirt-engine, ovirt-dwh, ovirt-engine-extension-aaa-misc, ovirt-engine-build-dependencies)
* [Tomáš Golembiovský](https://github.com/nyoxi) (Contributed to: mom)
* [Vic Demuzere](https://github.com/sorcix) (Contributed to: ovirt-engine-sdk-go)
* [Yedidyah Bar David](https://github.com/didib) (Contributed to: ovirt-dwh)

## New cpu's

Intel:
  - Sapphire Rapids Server
  - Secure Sapphire Rapids Server (all security features mentioned in v2 on qemu)

AMD:
  - EPYC Milan
  - Secure EPYC Milan (all security features mentioned in v2 on qemu)
  - EPYC Rome
  - EPYC Rome v2 (all features mentioned in v2 on qemu)
  - EPYC Genoa

IBM:
  - POWER10