---
title: CentOS Stream 9 support
category: feature
authors:
  - sandrobonazzola
---

# {{ page.title }}

## Summary

Add support for CentOS Stream 9 to oVirt project

## Owner

{% assign owner = site.data.authors["sandrobonazzola"] %}
{% if owner.github %}
* Name: [{{ owner.name }}](https://github.com/{{ owner.github }})
{% else %}
* Name: {{ owner.name }}
{% endif %}
{% if owner.email %}
* Email: <{{owner.email}}>
{% endif %}


## Current Status
- Last updated: Mon Oct 04 2021 Sandro Bonazzola <sbonazzo@redhat.com>
- Target release: oVirt 4.5.0
- Status: in progress
- Reference bugs:
  - Bug [1986335](https://bugzilla.redhat.com/show_bug.cgi?id=1986335) - [RFE] Support hosts based on CentOS Stream 9
  - Bug [1990767](https://bugzilla.redhat.com/show_bug.cgi?id=1990767) - [RFE] Support oVirt Engine on CentOS Stream 9


## Detailed Description

- [50 %] CI - Support building oVirt project packages on CentOS Stream 9.
  - Automation for builiding oVirt Node and its dependencies is in place.
  - Missing automation for building oVirt Engine and its dependencies.
- [0 %] CI - Add automation for building and testing oVirt project packages on CentOS Stream 9.
- [0 %] Engine: Support clusters with CentOS Stream 9 based hosts.
- [90%] Host: provide oVirt Node based on CentOS Stream 9 and allow provisioning equivalent host based on CentOS Stream 9 or derivatives.
  - [oVirt Node builds are available](https://jenkins.ovirt.org/job/ovirt-node-ng-image_master_build-artifacts-el9stream-x86_64/lastSuccessfulBuild/artifact/exported-artifacts/latest-installation-iso.html)
  - oVirt Node based on CentOS Stream 9 is lacking hosted engine setup related packages due to changes in Ansible 2.11.
- Not a goal for this feature but nice to have: oVirt Engine running on CentOS Stream 9 as well.

## Prerequisites

- [mock-core-configs-34.5-1](https://github.com/rpm-software-management/mock/releases/tag/mock-core-configs-34.5-1) is needed in order to get CentOS Stream 9 build environment.

## Limitations

Due to the move from Ansible 2.9 to Ansible 2.11 the oVirt Hosted Engine Setup flow needs to be re-designed as Ansible 2.11
requires to be executed within a container.

## Benefit to oVirt

oVirt will be able to run on top of CentOS Stream 9 and RHEL 9 once it will be available.

## Entity Description

In CentOS Stream 9, RHEL 7 emulated machine are going to be unsupported.
VDSM should report the host to be not compatible with cluster level < 4.4.

## CRUD

No CRUD operation needed in oVirt Engine.

## User Experience

No UX change needed in oVirt Engine.

## Installation/Upgrade

Both ovirt-engine host/appliance and ovirt-node/hosts will require full re-install when upgrading from CentOS Stream 8 or derivatives.

We are not considering in-place upgrade in this design.

## Event Reporting

No event reporting updates needed.

## Dependencies and Related Features

Dependencies not provided by CentOS Stream 9 repositories are handled within CentOS Virtualization SIG or
within a repository managed by oVirt project.

The `ovirt-release-master` package will provide the needed repository configuration.

On a plain CentOS Stream 9 system you can install the oVirt packages and their dependencies with:

```bash
$ sudo dnf install https://resources.ovirt.org/pub/yum-repo/ovirt-release-master.rpm
```

## Documentation & External references

- CentOS Stream 9 is now available at http://mirror.stream.centos.org/


## Testing

- Running same testing previously executed on CentOS Stream 8 hosts.

## Contingency Plan

If we can't complete CentOS Stream 9 host support, packages won't be shipped.


## Release Notes

```
oVirt can now be deployed on CentOS Stream 9 and derivatives based hosts.
```

## Open Issues

Newly-discovered issues will be tracked in bugzilla, as dependencies of the tracker Bugs:

- Bug [1986335](https://bugzilla.redhat.com/show_bug.cgi?id=1986335) - [RFE] Support hosts based on CentOS Stream 9
- Bug [1990767](https://bugzilla.redhat.com/show_bug.cgi?id=1990767) - [RFE] Support oVirt Engine on CentOS Stream 9
