---
title: OVirt 3.6 Test Day
authors: sandrobonazzola
wiki_title: OVirt 3.6 Test Day
wiki_revision_count: 7
wiki_last_updated: 2015-05-05
---

# OVirt 3.6 Test Day

## Objective

*   engage project users and stakeholders to a hands-on experiences with oVirt new release.
*   improve the quality of oVirt.
*   Introduce and validate new oVirt 3.6 features.

## What I should do

Test Days are an opportunity to exercise a completed, or in-development, Feature planned for an upcoming oVirt release. Each Test Day brings something unique and you're encouraged to join and share your ideas, tests, and results.

*   If you already have the hardware, verify if it meets the hardware requirements in [oVirt 3.6 Release Notes](oVirt 3.6 Release Notes)
*   Write down the configuration you used (HW, console, etc) and what you've tested in the [oVirt 3.6 Alpha Test Day etherpad](http://etherpad.ovirt.org/p/ovirt-3.6-alpha-test-day-1).
*   Follow the documentation to setup your environment, and test drive the new features.
*   Please remember we expect to see some issues, and anything you come up with will save you when you'll install final release.
*   Remember to try daily tasks you'd usually do in the engine, to see there are no regressions.
*   Accomplish the goals set in objective section , run the tests, update the test matrix.
*   Running into any issues?
    -   [ Try to get help from the community ](Community) on #ovirt IRC channel or
    -   [open a bugzilla](https://bugzilla.redhat.com/enter_bug.cgi?product=oVirt) ticket or

## New Features - Test Status Table

|---------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------|-------------------|-----|---------|
| Feature                                                                                                                               | Test page                                                                                                         | Tested By/ Distro | BZs | remarks |
| [Features/BackupAwareness](Features/BackupAwareness)                                                                       |                                                                                                                   |                   |     |         |
| [CinderGlance Docker Integration](CinderGlance Docker Integration)                                                         | [CinderGlance_Docker_Integration#Testing](CinderGlance_Docker_Integration#Testing)                  |                   |     |         |
| [Features/Debian support for hosts](Features/Debian support for hosts)                                                     | [Features/Debian support for hosts#Testing](Features/Debian support for hosts#Testing)                |                   |     |         |
| [Features/Fedora 22 Support](Features/Fedora 22 Support)                                                                   | [Features/Fedora_22_Support#Testing](Features/Fedora_22_Support#Testing)                            |                   |     |         |
| [Features/oVirt Live Rebase on CentOS 7](Features/oVirt Live Rebase on CentOS 7)                                           | [Features/oVirt_Live_Rebase_on_CentOS_7#Testing](Features/oVirt_Live_Rebase_on_CentOS_7#Testing) |                   |     |         |
| [Features/Self Hosted Engine FC Support](Features/Self Hosted Engine FC Support)                                           | [Features/Self_Hosted_Engine_FC_Support#Testing](Features/Self_Hosted_Engine_FC_Support#Testing)  |                   |     |         |
| [Features/Self Hosted Engine Gluster Support](Features/Self Hosted Engine Gluster Support)                                 | <QA:TestCase_Hosted_Engine_External_Gluster_Support>                                                              |                   |     |         |
| [Features/Self Hosted Engine Hyper Converged Gluster Support](Features/Self Hosted Engine Hyper Converged Gluster Support) |                                                                                                                   |                   |     |         |

## Bug Reporting

*   oVirt - <https://bugzilla.redhat.com/enter_bug.cgi?product=oVirt>
*   Spice - <https://bugs.freedesktop.org/> under Spice product
