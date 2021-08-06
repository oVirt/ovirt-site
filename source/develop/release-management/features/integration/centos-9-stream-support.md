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
- Last updated: Fri Aug 06 2021 Sandro Bonazzola <sbonazzo@redhat.com>
- Target release: oVirt 4.5.0
- Status: design
- Reference bugs:
  - Bug [1986335](https://bugzilla.redhat.com/show_bug.cgi?id=1986335) - [RFE] Support hosts based on CentOS Stream 9
  - Bug [1990767](https://bugzilla.redhat.com/show_bug.cgi?id=1990767) - [RFE] Support oVirt Engine on CentOS Stream 9


## Detailed Description

- CI - Support building oVirt project packages on CentOS Stream 9.
- CI - Add automation for building and testing oVirt project packages on CentOS Stream 9.
- Engine: Support clusters with CentOS Stream 9 based hosts.
- Host: provide oVirt Node based on CentOS Stream 9 and allow provisioning equivalent host based on CentOS Stream 9 or derivatives.
- Not a goal for this feature but nice to have: oVirt Engine running on CentOS Stream 9 as well.

## Prerequisites

- [mock-core-configs-34.5-1](https://github.com/rpm-software-management/mock/releases/tag/mock-core-configs-34.5-1) is needed in order to get CentOS Stream 9 build environment.

## Limitations

There are currently no known limitations.

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

Dependencies not provided by CentOS Stream 9 repositories will be handled either within CentOS Virtualization SIG or
within a repository managed by oVirt project.

While CentOS Virtualization SIG is not able to provide packages based on CentOS Stream 9, COPR repo will be used for
providing the dependencies.

The `ovirt-release-master` package will provide the needed repository configuration.

On a plain CentOS Stream 9 system you can enable a preview of the oVirt packages and their dependencies with:

```bash
$ sudo dnf copr enable sbonazzo/oVirt_on_CentOS_Stream_9_preview
```

Please note that COPR provides only x86_64 and aarch64 build roots so ppc64le and s390x builds won't be available until we can get the needed dependencies on those architectures.


## Documentation & External references

- Nightly CentOS Stream 9 composes candidate to production are available at <https://composes.stream.centos.org/production/>. ISOs can be downloaded from there under `BaseOS/$basearch/iso`


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
