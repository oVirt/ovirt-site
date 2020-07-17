---
title: oVirt 3.6 Release Management
category: release
authors: bproffitt, danken, sandrobonazzola
---

# oVirt 3.6 Release Management

## Key Milestones
| Date | Milestone |
|---|---|
| **2014-10-17**    | oVirt 3.5.0 GA Releases                                                             |
| **2014-10-22**    | Release criteria discussion start                                                   |
| <s>2014-11-12</s><br><s>2014-11-19</s><br>**2014-11-26** | Release criteria ready |
| **2015-04-22**    | Feature Review - Feature Submission Closed                                          |
| <s>2015-05-06</s> 
 <s>2015-05-12</s>  
 **2015-05-19**     | Alpha Release: [oVirt 3.6 Release Notes](/develop/release-management/releases/3.6/)        |
| <s>2015-05-12</s> 
 <s>2015-05-19</s>  
 <s>2015-05-26</s>  
 <s>2015-05-27</s>  | <s>Alpha Release Test Day</s>  |
| **2015-06-15**    | Feature freeze                                                                      |
| <s>2015-06-17</s> 
 <s>2015-06-24</s>  
 <s>2015-06-25</s>  
 <s>2015-06-26</s>  
 **2015-06-29**     | Second Alpha Release: [oVirt 3.6 Release Notes](/develop/release-management/releases/3.6/) |
| **2015-07-28**    | Third Alpha Release: [oVirt 3.6 Release Notes](/develop/release-management/releases/3.6/)  |
| <s>2015-07-15</s> 
 **2015-08-03**     | Beta Release                                                                        |
| <s>2015-07-20</s> 
 **2015-08-10**     | Beta Release Test Day                                                               |
| <s>2015-08-11</s> 
 **2015-08-14**     | Second Beta Release                                                                 |
| <s>2015-08-03</s> 
 **2015-08-19**     | String Freeze                                                                       |
| **2015-08-20**    | Third Beta Release                                                                  |
| <s>2015-09-02</s> 
 **2015-09-07**     | Fourth Beta Release                                                                 |
| **2015-09-09**    | Fifth Beta Release                                                                  |
| **2015-09-16**    | Sixth Beta Release                                                                  |
| <s>2015-08-19</s> 
 <s>2015-09-02</s>  
 <s>2015-09-16</s>  
 <s>2015-09-22</s>  
 **2015-09-28**     | Release Candidate                                                                   |
| <s>2015-08-24</s> 
 <s>2015-09-08</s>  
 <s>2015-09-17</s>  
 <s>2015-09-24</s>  | <s>Release Candidate Test Day</s>                                                   |
| **2015-10-14**    | Second Release Candidate                                                            |
| **2015-10-21**    | Third Release Candidate                                                             |
| <s>2015-09-08</s> 
 <s>2015-09-22</s>  
 <s>2015-09-29</s>  
 <s>2015-10-12</s>  
 **2015-11-04**     | Release                                                                             |

**NOTE** this is a tentative planning according to [Release process](Release process)

## External Project Schedules

Links to other significant project schedules, useful for seeing how oVirt aligns with them.

*   Debian Jessie 8.2: [2015-09-05](https://lists.debian.org/debian-announce/2015/msg00003.html)
*   Fedora 24: [2016-05-17](https://fedoraproject.org/wiki/Releases/23/Schedule)
*   Fedora 23: [2015-10-27](https://fedoraproject.org/wiki/Releases/23/Schedule)
*   Fedora 22 End Of Life: [2016-06-17 (1 month after Fedora 24 release)](https://fedoraproject.org/wiki/Releases/24/Schedule)
*   Fedora 21 End Of Life: [2015-11-27 (1 month after Fedora 23 release)](https://fedoraproject.org/wiki/Releases/23/Schedule)
*   Foreman 1.8.4: [2015-09-15](http://projects.theforeman.org/rb/releases/foreman)
*   Foreman 1.9.2: [2015-10-13](http://projects.theforeman.org/rb/releases/foreman)
*   Foreman 1.10.0: [2015-11-01](http://projects.theforeman.org/rb/releases/foreman)
*   Foreman 1.11.0: [2016-02-01](http://projects.theforeman.org/rb/releases/foreman)
*   GlusterFS 3.7: [2015-05-06](http://www.gluster.org/community/documentation/index.php/Planning37)
*   GlusterFS 4.0: [No date yet](http://www.gluster.org/community/documentation/index.php/Planning40)
*   OpenStack Kilo: [2015-04-30](https://wiki.openstack.org/wiki/Kilo_Release_Schedule)
*   OpenStack Liberty: [2015-10-15](https://wiki.openstack.org/wiki/Liberty_Release_Schedule)
*   QEMU 2.5.0: [2015-12-10](http://wiki.qemu.org/Planning/2.5)
*   Tiny Core 6.4: [2015-09-08](http://forum.tinycorelinux.net/index.php/topic,18818.0.html)


## oVirt Live

oVirt Live has been rebased on EL7.

Please help us testing it! Latest nightly iso is available here: <http://jenkins.ovirt.org/job/ovirt_live_create_iso/>

## Features Status Table

To try and improve 3.6 planning over the wiki approach in 3.3, this google doc <http://goo.gl/9X3G49> has been created.

## Translation Status

Translations are handled by Zanata. You can join the translators team and see current translation status here:
<https://translate.zanata.org/zanata/iteration/view/ovirt/master/languages>

## Key Proposed Changes

The following list is a subset of the features proposed for oVirt 3.6

*   [Features/Management Network As A Role](/develop/release-management/features/network/management-network-as-a-role.html)
*   [Features/DetailedHostNetworkingApi](/develop/release-management/features/network/detailedhostnetworkingapi.html)
*   [Features/HostNetworkingApi](/develop/release-management/features/network/hostnetworkingapi.html)
*   [Features/IsolatedNetworks](/develop/release-management/features/network/isolatednetworks.html)
*   [Features/Cluster parameters override](/develop/release-management/features/engine/cluster-parameters-override.html)
*   Drop support for Fedora <= 20
*   [Add support for Fedora 22](/develop/release-management/features/os-support/fedora-22-support.html)
*   [Add support for Ubuntu hosts](/develop/release-management/features/debian-support-for-hosts.html)
*   No support for new features on el6. el6 hosts would be allowed only in [3.5 compatibility mode](https://lists.ovirt.org/pipermail/users/2014-September/027421.html).
*   Hosted Engine support only on hosts supporting 3.6 compatibility level (EL7 and Fedora). A guide will be provided for migrating from EL6

## Tracker Bug

*   - Tracker: oVirt 3.6 release

## Release Criteria

### Alpha Release Criteria

1.  MUST: All sources must be available on ovirt.org
2.  MUST: All packages listed by subprojects must be available in the repository

### Beta Release Criteria

1.  MUST: Release Notes have feature-specific information: [oVirt 3.6 Release Notes](/develop/release-management/releases/3.6/)
2.  MUST: Alpha Release Criteria are met
3.  MUST: Supported localizations must be at least at 70% of completeness for being included in the release
4.  MUST: All accepted features must be substantially complete and in a testable state and enabled by default -- if so specified by the change

### Candidate Release Criteria

1.  MUST: Beta Release Criteria are met
2.  MUST: All test cases defined for each accepted feature must be verified and pass the test for the build to be released
3.  MUST: All lower-level components must be available on supported distributions at required version [1]
4.  MUST: No known regressions from previous releases should be present
5.  MUST: Each subproject must allow upgrade from a previous version, either providing documented manuals or automated upgrade procedures
6.  MUST: All features working on previous release must still work in the new release if not dropped as deprecated

[1] This means we're not hosting any package we don't develop inside oVirt repository just because it's not yet released officially.

