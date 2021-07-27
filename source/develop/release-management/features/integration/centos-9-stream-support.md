---
title: CentOS 9 Stream support
category: feature
authors:
  - sandrobonazzola
---

# {{ page.title }}

## Summary

Add support for CentOS 9 Stream to oVirt project

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
- Reference bug: Bug [1986335](https://bugzilla.redhat.com/1986335) - [RFE] Support CentOS 9 Stream


## Detailed Description

- Support building oVirt project packages on CentOS 9 Stream
- Add automation for building and testing oVirt project packages on CentOS 9 Stream

## Prerequisites

- [mock-core-configs-34.5-1](https://github.com/rpm-software-management/mock/releases/tag/mock-core-configs-34.5-1) is needed in order to get CentOS 9 Stream build environment.

## Limitations

There are currently no known limitations.

## Benefit to oVirt

oVirt will be able to run on top of CentOS 9 Stream and RHEL 9 once it will be available.

## Entity Description

No new entity needed in oVirt Engine.

## CRUD

No CRUD operation needed in oVirt Engine.

## User Experience

No UX change needed in oVirt Engine.

## Installation/Upgrade

Host upgrade will require full re-install when upgrading from CentOS 8 Stream or derivatives.

## Event Reporting

No event reporting updates needed.

## Dependencies and Related Features

Dependencies not provided by CentOS 9 Stream repositories will be handled either within CentOS Virtualization SIG or
within a repository managed by oVirt project.

## Documentation & External references

- Nightly CentOS 9 Stream composes candidate to production are available at <https://composes.stream.centos.org/production/>


## Testing

- Running same testing previously executed on CentOS 8 Stream.


## Contingency Plan

If we can't complete CentOS Stream 9 support, packages won't be shipped.


## Release Notes

```
oVirt can now be deployed on CentOS 9 Stream and derivatives.
```

## Open Issues

No known open issues.
