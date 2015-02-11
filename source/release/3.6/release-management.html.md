---
title: OVirt 3.6 Release Management
category: release
authors: bproffitt, danken, sandrobonazzola
wiki_category: Releases
wiki_title: OVirt 3.6 Release Management
wiki_revision_count: 64
wiki_last_updated: 2015-05-27
---

# OVirt 3.6 Release Management

## Key Milestones

|----------------------------------------|--------------------------------------------|
| **2014-10-17**                         | oVirt 3.5.0 GA Releases                    |
| **2014-10-22**                         | Release criteria discussion start          |
| <s>2014-11-12</s>                      
 <s>2014-11-19</s>                       
 **2014-11-26**                          | Release criteria ready                     |
| 4 months and 2 weeks before GA release | Feature Review - Feature Submission Closed |
| 4 months before GA release             | Alpha Release                              |
| 4 months before GA release             | Alpha Release Test Day                     |
| 3 months before GA release             | Feature freeze                             |
| 2 months before GA release             | Beta Release                               |
| 2 months before GA release             | Beta Release Test Day                      |
| 1 month and 2 weeks before GA release  | String Freeze                              |
| 1 month before GA release              | Release Candidate                          |
| 1 month before GA release              | Release Candidate Test Day                 |
| X months after oVirt 3.5.0 release     | Release                                    |

**NOTE** this is a tentative planning according to [Release process](Release process)

## External Project Schedules

Links to other significant project schedules, useful for seeing how oVirt aligns with them.

*   Fedora 22: [2015-05-19](https://fedoraproject.org/wiki/Releases/22/Schedule)
*   Fedora 20 End Of Life:[2015-06-19 (1 month after Fedora 22 release)](https://fedoraproject.org/wiki/Releases/22/Schedule)
*   Foreman 1.8.0: [2015-04-01](http://projects.theforeman.org/rb/releases/foreman)
*   GlusterFS 3.7: [2015-04-29](http://www.gluster.org/community/documentation/index.php/Planning37)
*   OpenStack Kilo: [2015-04-30](https://wiki.openstack.org/wiki/Kilo_Release_Schedule)
*   QEMU 2.3.0: [2015-03-27](http://wiki.qemu.org/Planning/2.3)

## Nightly Builds

Nightly builds are available from oVirt snapshots repositories:

[`http://resources.ovirt.org/pub/ovirt-master-snapshot-static/`](http://resources.ovirt.org/pub/ovirt-master-snapshot-static/)
[`http://resources.ovirt.org/pub/ovirt-master-snapshot/`](http://resources.ovirt.org/pub/ovirt-master-snapshot/)

Please refer to [Install nightly snapshot](Install nightly snapshot) guide for enabling those repositories

## oVirt Live

oVirt Live has been rebased on EL7.

Please help us testing it! Latest nightly iso is available here: <http://jenkins.ovirt.org/job/ovirt_live_create_iso/>

## Features Status Table

To try and improve 3.6 planning over the wiki approach in 3.3, this google doc <http://goo.gl/9X3G49> has been created.

## Key Proposed Changes

The following list is a subset of the [features proposed for oVirt 3.6](http://www.ovirt.org/Category:OVirt_3.6_Proposed_Feature)

*   [Features/Management Network As A Role](Features/Management Network As A Role)
*   [Features/DetailedHostNetworkingApi](Features/DetailedHostNetworkingApi)
*   [Features/HostNetworkingApi](Features/HostNetworkingApi)
*   [Features/IsolatedNetworks](Features/IsolatedNetworks)
*   [Features/Cluster parameters override](Features/Cluster parameters override)
*   Drop support for Fedora 19 End of Life
*   [ Add support for Fedora 22](Features/Fedora 22 Support)
*   Add support for Ubuntu hosts
*   No support for new features on el6. el6 hosts would be allowed only in [3.5 compatibility mode](http://lists.ovirt.org/pipermail/users/2014-September/027421.html).
*   Hosted Engine support only on hosts supporting 3.6 compatibility level (EL7 and Fedora). A guide will be provided for migrating from EL6

## Tracker Bug

*   - Tracker: oVirt 3.6 release

## Release Criteria

### Alpha Release Criteria

1.  MUST: All sources must be available on ovirt.org
2.  MUST: All packages listed by subprojects must be available in the repository
3.  MUST: All accepted features must be substantially complete and in a testable state and enabled by default -- if so specified by the change

### Beta Release Criteria

1.  MUST: Release Notes have feature-specific information
2.  MUST: Alpha Release Criteria are met
3.  MUST: Supported localizations must be at least at 70% of completeness for being included in the release

### Candidate Release Criteria

1.  MUST: Beta Release Criteria are met
2.  MUST: All test cases defined for each accepted feature must be verified and pass the test for the build to be released
3.  MUST: All lower-level components must be available on supported distributions at required version [1]
4.  MUST: No known regressions from previous releases should be present
5.  MUST: Each subproject must allow upgrade from a previous version, either providing documented manuals or automated upgrade procedures
6.  MUST: All features working on previous release must still work in the new release if not dropped as deprecated

[1] This means we're not hosting any package we don't develop inside oVirt repository just because it's not yet released officially.

<Category:Releases> [Category:Release management](Category:Release management)
