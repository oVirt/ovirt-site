---
title: oVirt Live Rebase on CentOS 7
category: feature
authors: sandrobonazzola
feature_name: oVirt Live Rebase on CentOS 7
feature_modules: all
feature_status: ON_QA
---

# oVirt Live Rebase on CentOS 7

## Summary

oVirt Live ISO will be rebased on CentOS 7

## Owner

*   Name: [Sandro Bonazzola](https://github.com/sandrobonazzola)
*   Email: <sbonazzo@redhat.com>

## Detailed Description

*   Rebase kickstart on CentOS 7 Live CD
*   Update Jenkins jobs for automated build
*   Verify that the ISO works as it worked with CentOS 6

## Benefit to oVirt

*   Will allow to use oVirt Live with 3.6 cluster level support

## Dependencies / Related Features

*   Depends on all components to support CentOS 7

## Documentation / External references

*   CentOS GIT repository for Live ISO kickstart: <https://git.centos.org/summary/sig-core!livemedia.git>

## Testing

*   Burn a oVirt Live ISO from <http://jenkins.ovirt.org/job/ovirt_live_create_iso/>
*   Verify it allow to run oVirt Engine in 3.6 compatibility mode
*   Verifiy it has no regression against oVirt Live 3.5

## Contingency Plan

*   No contingency plan, either we have it working or we won't have oVirt Live.

## Release Notes

      == oVirt Live ==
      oVirt Live has been rebased on CentOS 7 allowing to run oVirt in 3.6 compatibility mode



[oVirt Live Rebase on CentOS 7](/develop/release-management/features/) [oVirt Live Rebase on CentOS 7](/develop/release-management/releases/3.6/proposed-feature/) [|oVirt Live Rebase on CentOS 7](Category:oVirt 3.6 Feature) [oVirt Live Rebase on CentOS 7](Category:Integration)
