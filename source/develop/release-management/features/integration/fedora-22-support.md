---
title: Fedora 22 Support
category: feature
authors: sandrobonazzola
feature_name: Fedora 22 Support
feature_modules: all
feature_status: Delivered in oVirt 3.6
---

# Fedora 22 Support

## Summary

Add support for Fedora 22

## Owner

*   Name: [Sandro Bonazzola](https://github.com/sandrobonazzola)
*   Email: <sbonazzo@redhat.com>

## Detailed Description

*   Support building on Fedora 22
*   Create Jenkins jobs for automated build and testing on Fedora 22
*   Create Fedora 22 Jenkins slaves
*   Verify that all the components have no regressions only due to Fedora 22

## Benefit to oVirt

*   oVirt will be able to run on Fedora 22

## Dependencies / Related Features

*   All subprojects must support Fedora 22
*   A tracker bug has been created for tracking issues:

## Documentation / External references

*   <https://fedoraproject.org/wiki/Releases/22/Schedule>
*   <https://fedoraproject.org/wiki/Releases/22/ChangeSet>
*   <http://fedoraproject.org/wiki/Releases/21/ChangeSet>

## Testing

The whole test case collection must work on Fedora 22.

## Contingency Plan

The feature is self contained: if support for Fedora 22 won't be ready for 3.6.0 we won't deliver Fedora 22 RPMs.

## Release Notes

    == Fedora 22 Support ==
    Support for running oVirt on Fedora 22 (or similar) has been added providing custom packaging of Wildfly 8.2.0.
