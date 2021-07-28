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
- Last updated: Tue Jul 27 2021
- Target release: oVirt 4.5.0
- Reference bug: Bug [1986335](https://bugzilla.redhat.com/1986335) - [RFE] Support CentOS Stream 9


## Detailed Description

- Support building oVirt project packages on CentOS Stream 9
- Add automation for building and testing oVirt project packages on CentOS Stream 9

## Prerequisites

- [mock-core-configs-34.5-1](https://github.com/rpm-software-management/mock/releases/tag/mock-core-configs-34.5-1) is needed in order to get CentOS Stream 9 build environment.

## Limitations

There are currently no known limitations.

## Benefit to oVirt

oVirt will be able to run on top of CentOS Stream 9 and RHEL 9 once it will be available.

## Entity Description

No new entity needed in oVirt Engine.

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

## Documentation & External references

- Nightly CentOS Stream 9 composes candidate to production are available at <https://composes.stream.centos.org/production/>


## Testing

- Running same testing previously executed on CentOS Stream 8.


## Contingency Plan

If we can't complete CentOS Stream 9 support, packages won't be shipped.


## Release Notes

```
oVirt can now be deployed on CentOS Stream 9 and derivatives.
```

## Open Issues

Newly-discovered issues will be tracked in bugzilla, as dependencies of the tracker Bug [1986335](https://bugzilla.redhat.com/1986335) - [RFE] Support CentOS Stream 9.
