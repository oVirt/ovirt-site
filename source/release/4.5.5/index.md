---
title: oVirt 4.5.5 Release Notes
category: documentation
authors:
  - sandrobonazzola
toc: true
page_classes: releases
---


# oVirt 4.5.5 Release Notes

The oVirt Project is pleased to announce the availability of the 4.5.5 release as of December 01, 2023.

oVirt is a free open-source distributed virtualization solution,
designed to manage your entire enterprise infrastructure.
oVirt uses the trusted KVM hypervisor and is built upon several other community
projects, including libvirt, Gluster, PatternFly, and Ansible.

This release is now available on x86_64 architecture for:

* oVirt Node NG (based on CentOS Stream 8)
* oVirt Node NG (based on CentOS Stream 9)
* CentOS Stream 8
* CentOS Stream 9
* RHEL 8 and derivatives
* RHEL 9 and derivatives

Experimental builds are also available for ppc64le and aarch64.

To find out how to interact with oVirt developers and users and ask questions,
visit our [community page](/community/).
All issues should be reported via [oVirt GitHub](https://github.com/oVirt).

If you'd like to try oVirt as quickly as possible, follow the instructions on
the [Download](/download/) page.

For complete installation, administration, and usage instructions, see
the [oVirt Documentation](/documentation/).

For a general overview of oVirt, read the [About oVirt](/community/about.html)
page.

To learn about features introduced before 4.5.5, see the
[release notes for previous versions](/documentation/#previous-release-notes).

> IMPORTANT
> If you are going to install on RHEL or derivatives please follow [Installing on RHEL](/download/install_on_rhel.html) first.

## Suggestion to use nightly

As [discussed in oVirt Users mailing list](https://lists.ovirt.org/archives/list/users@ovirt.org/thread/DMCC5QCHL6ECXN674JOLABH36U2LVJLJ/)
we suggest the user community to use [oVirt master snapshot repositories](/develop/dev-process/install-nightly-snapshot.html)
ensuring that the latest fixes for the platform regressions will be promptly available.

This oVirt 4.5.5 release is meant to provide what has been made available in nightly repositories as base for new installations.
If you are already using oVirt master snapshot you should already have received this release content.

## What's New in 4.5.5?

* [OTOPI 1.10.4](https://github.com/oVirt/otopi/releases/tag/otopi-1.10.4)
* [oVirt Ansible Collection 3.2.0-1](https://github.com/oVirt/ovirt-ansible-collection/releases/tag/3.2.0-1)
* [oVirt dependencies 4.5.3](https://github.com/oVirt/ovirt-dependencies/releases/tag/ovirt-dependencies-4.5.3)
* [oVirt Engine Data Warehouse 4.5.8](https://github.com/oVirt/ovirt-dwh/releases/tag/ovirt-engine-dwh-4.5.8)
* [oVirt Engine 4.5.5](https://github.com/oVirt/ovirt-engine/releases/tag/ovirt-engine-4.5.5)
* [oVirt Engine API Metamodel 1.3.10](https://github.com/oVirt/ovirt-engine-api-metamodel/releases/tag/1.3.10)
* [oVirt Engine API Model 4.6.0](https://github.com/oVirt/ovirt-engine-api-model/releases/tag/4.6.0)
* [oVirt Engine Build Dependencies 4.5.5](https://github.com/oVirt/ovirt-engine-build-dependencies/releases/tag/ovirt-engine-build-dependencies-4.5.5)
* [oVirt Engine AAA Misc Extension 1.1.1](https://github.com/oVirt/ovirt-engine-extension-aaa-misc/releases/tag/ovirt-engine-extension-aaa-misc-1.1.1)
* [oVirt Engine Metrics 1.6.2](https://github.com/oVirt/ovirt-engine-metrics/releases/tag/ovirt-engine-metrics-1.6.2)
* [oVirt Hosted Engine HA 2.5.1](https://github.com/oVirt/ovirt-hosted-engine-ha/releases/tag/v2.5.1)
* [oVirt Hosted Engine Setup 2.7.1](https://github.com/oVirt/ovirt-hosted-engine-setup/releases/tag/ovirt-hosted-engine-setup-2.7.1)
* [oVirt ImageIO 2.5.0](https://github.com/oVirt/ovirt-imageio/releases/tag/v2.5.0)
* [oVirt Log Collector 4.5.0](https://github.com/oVirt/ovirt-log-collector/releases/tag/ovirt-log-collector-4.5.0)
* [oVirt Open vSwitch 2.15-4(el8) / 2.17-1(el9)](https://github.com/oVirt/ovirt-openvswitch/compare/2.15-2...97dde4dcb91478ff8290518dd612ac0b050cfca1)
* [oVirt Provider OVN 1.2.36](https://github.com/oVirt/ovirt-provider-ovn/releases/tag/1.2.36)
* [oVirt Release Host Node 4.5.5](https://github.com/oVirt/ovirt-release/releases/tag/ovirt-release-host-node-4.5.5-1)
* [oVirt vmconsole 1.0.9-3](https://github.com/oVirt/ovirt-vmconsole/compare/v1.0.9...9c67ce6069a7742813e160a4ab4298429af85d9c)
* [oVirt Engine SDK 4 Python 4.6.2](https://github.com/oVirt/python-ovirt-engine-sdk4/releases/tag/4.6.2)
* [VDSM JSON-RPC Java 1.7.3](https://github.com/oVirt/vdsm-jsonrpc-java/releases/tag/v1.7.3)
* [VDSM 4.50.5.1](https://github.com/oVirt/vdsm/releases/tag/v4.50.5.1)
* [oVirt Engine Appliance 4.5.5](https://github.com/oVirt/ovirt-appliance/releases/tag/ovirt-engine-appliance-4.5.5)
* [oVirt Node NG Image 4.5.5](https://github.com/oVirt/ovirt-node-ng-image/releases/tag/ovirt-node-ng-image-4.5.5)
* [oVirt Web Site](https://github.com/oVirt/ovirt-site/compare/6e92d19b385ae1a9e175e858daa41237d44fcde2...a5a801193a1ea7ab24be7b6f7fa6759f1e2b7fa2)

### Contributors

46 people contributed to this release:

* [Abba Soungui YOUNOUSS](https://github.com/yasalos) (Contributed to: vdsm)
* [Albert Esteve](https://github.com/aesteve-rh) (Contributed to: ovirt-imageio, vdsm)
* [Aleš Musil](https://github.com/almusil) (Contributed to: ovirt-openvswitch, ovirt-provider-ovn)
* [Arik Hadas](https://github.com/ahadas) (Contributed to: ovirt-engine, vdsm)
* [Artur Socha](https://github.com/arso) (Contributed to: vdsm-jsonrpc-java)
* [Asaf Rachmani](https://github.com/arachmani) (Contributed to: ovirt-ansible-collection, ovirt-hosted-engine-ha)
* [Avital Pinnick](https://github.com/apinnick) (Contributed to: ovirt-engine-api-model, ovirt-site)
* [Bella Khizgiyaev](https://github.com/bkhizgiy) (Contributed to: ovirt-imageio)
* [Benny Zlotnik](https://github.com/bennyz) (Contributed to: ovirt-engine, ovirt-engine-api-model)
* [Celil Buğra Karacan](https://github.com/cbugk) (Contributed to: ovirt-site)
* [Dana Elfassy](https://github.com/dangel101) (Contributed to: ovirt-engine)
* [Eitan Raviv](https://github.com/erav) (Contributed to: ovirt-engine, ovirt-provider-ovn, vdsm)
* [Eli Marcus](https://github.com/emarcusRH) (Contributed to: ovirt-site)
* [Eli Mesika](https://github.com/emesika) (Contributed to: ovirt-engine, ovirt-site)
* [Fabrice Bacchella](https://github.com/fbacchella) (Contributed to: ovirt-engine-extension-aaa-misc)
* [Felix Hamme](https://github.com/betanummeric) (Contributed to: ovirt-engine)
* [Guillaume Pavese](https://github.com/gpavinteractiv) (Contributed to: ovirt-node-ng-image)
* [Hema K](https://github.com/hemak88) (Contributed to: ovirt-ansible-collection)
* [Illia Polliul](https://github.com/ilush) (Contributed to: ovirt-ansible-collection)
* [Jean-Louis Dupond](https://github.com/dupondje) (Contributed to: ovirt-ansible-collection, ovirt-engine, vdsm, vdsm-jsonrpc-java)
* [Klaas Demter](https://github.com/Klaas) (Contributed to: ovirt-release)
* [Laszlo Szomor](https://github.com/lszomor) (Contributed to: ovirt-engine)
* [Lev Veyde](https://github.com/lveyde) (Contributed to: ovirt-log-collector)
* [Liran Rotenberg](https://github.com/liranr23) (Contributed to: ovirt-engine)
* [Lucia Jelinkova](https://github.com/ljelinkova) (Contributed to: ovirt-engine)
* [Marcin Sobczyk](https://github.com/tinez) (Contributed to: ovirt-hosted-engine-setup)
* [Martin Nečas](https://github.com/mnecas) (Contributed to: ovirt-ansible-collection, ovirt-imageio, python-ovirt-engine-sdk4)
* [Martin Perina](https://github.com/mwperina) (Contributed to: ovirt-ansible-collection, ovirt-dependencies, ovirt-dwh, ovirt-engine, ovirt-engine-api-model,
  ovirt-engine-build-dependencies, ovirt-engine-extension-aaa-misc, ovirt-engine-metrics, ovirt-hosted-engine-setup, ovirt-openvswitch, python-ovirt-engine-sdk4, vdsm, vdsm-jsonrpc-java)
* [Michal Skrivanek](https://github.com/michalskrivanek) (Contributed to: ovirt-ansible-collection, ovirt-dwh, ovirt-engine, ovirt-engine-api-model,
  ovirt-engine-metrics, ovirt-hosted-engine-setup, ovirt-imageio, ovirt-openvswitch, ovirt-release, ovirt-site)
* [Miguel Martin](https://github.com/mmartinv) (Contributed to: ovirt-ansible-collection, ovirt-engine)
* [Milan Zamazal](https://github.com/mz-pdm) (Contributed to: ovirt-vmconsole, vdsm, vdsm-jsonrpc-java)
* [Moritz "WanzenBug" Wanzenböck](https://github.com/WanzenBug) (Contributed to: vdsm)
* [Nicolás Kovac Neumann](https://github.com/nkovacne) (Contributed to: ovirt-engine)
* [Nijin Ashok](https://github.com/nijinashok) (Contributed to: ovirt-ansible-collection)
* [Nir Soffer](https://github.com/nirs) (Contributed to: ovirt-imageio, ovirt-site, vdsm)
* [Ori Liel](https://github.com/oliel) (Contributed to: ovirt-engine-api-metamodel, ovirt-engine-api-model)
* [Saksham Srivastava](https://github.com/saksham-oracle) (Contributed to: ovirt-ansible-collection, vdsm)
* [Sandro Bonazzola](https://github.com/sandrobonazzola) (Contributed to: otopi, ovirt-appliance, ovirt-dwh, ovirt-engine, ovirt-engine-extension-aaa-misc, ovirt-engine-metrics,
  ovirt-hosted-engine-ha, ovirt-hosted-engine-setup, ovirt-log-collector, ovirt-node-ng-image, ovirt-openvswitch, ovirt-release, ovirt-site, ovirt-vmconsole, vdsm, vdsm-jsonrpc-java)
* Sanja Bonic (Contributed to: ovirt-appliance)
* [Shane McDonald](https://github.com/shanemcd) (Contributed to: ovirt-ansible-collection)
* [Shmuel Melamud](https://github.com/smelamud) (Contributed to: vdsm)
* [Shubha Kulkarni](https://github.com/shubhaOracle) (Contributed to: ovirt-engine, ovirt-vmconsole)
* [Stepan Ermakov](https://github.com/sermakov-orion) (Contributed to: ovirt-engine)
* [Tomáš Golembiovský](https://github.com/nyoxi) (Contributed to: ovirt-vmconsole, vdsm)
* [Wenlong Zhang](https://github.com/zhangwenlong8911) (Contributed to: ovirt-engine-api-model)
* [Yedidyah Bar David](https://github.com/didib) (Contributed to: otopi, ovirt-ansible-collection, ovirt-engine, ovirt-hosted-engine-ha, ovirt-log-collector, ovirt-site)
