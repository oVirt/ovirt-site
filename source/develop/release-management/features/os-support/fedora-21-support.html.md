---
title: Fedora 21 Support
category: feature
authors: sandrobonazzola
feature_name: Fedora 21 Support
feature_modules: all
feature_status: WONTFIX
---

# Fedora 21 Support

## Summary

Add support for Fedora 21

## Owner

*   Name: [Sandro Bonazzola](https://github.com/sandrobonazzola)
*   Email: <sbonazzo@redhat.com>
*   Status: WONTFIX - dropped in favor of [Fedora 22 Support](/develop/release-management/features/os-support/fedora-22-support/)

## Detailed Description

*   Support building on Fedora 21
*   Create Jenkins jobs for automated build and testing on Fedora 21
*   Create Fedora 21 Jenkins slaves
*   Verify that all the components have no regressions only due to Fedora 21

## Benefit to oVirt

*   oVirt will be able to run on Fedora 21

## Dependencies / Related Features

*   All subprojects must support Fedora 21
*   A tracker bug has been created for tracking issues:

## Documentation / External references

<https://fedoraproject.org/wiki/Releases/21/Schedule>

## Testing

The whole test case collection must work on Fedora 21.

## Contingency Plan

The feature is self contained: if support for Fedora 21 won't be ready for 3.6.0 we won't deliver Fedora 21 RPMs.

## Release Notes

    == Fedora 21 Support ==
    Support for running oVirt on Fedora 21 (or similar) has been added providing custom packaging of JBoss Application Server 7.
