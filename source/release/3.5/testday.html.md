---
title: OVirt 3.5 TestDay
authors: danken, didi, fkobzik, gchaplik, gshereme, lvernia, sandrobonazzola
wiki_title: OVirt 3.5 TestDay
wiki_revision_count: 29
wiki_last_updated: 2014-09-17
---

# OVirt 3.5 TestDay

## Objective

*   engage project users and stakeholders to a hands-on experiences with oVirt new release.
*   improve the quality of oVirt.
*   Introduce and validating new oVirt 3.5 features

## What I should do

*   If you already have the hardware, verify if it meets the hardware requirement, refer information detail section below
*   Write down the configuration you used (HW, console, etc) and what you've tested in the [first test day report etherpad](http://etherpad.ovirt.org/p/3.5-testday-1)
*   Go ahead and [ install ovirt ](oVirt_3.5_TestDay#Installation_notes)
*   Follow the documentation to setup your environment, and test drive the new features.
*   Please remember we expect to see some issues, and anything you come up with will save a you when you'll install final release
*   Remember to try daily tasks you'd usually do in the engine, to see there are no regressions.
*   Accomplish the goals set in objective section , run the tests, update the test matrix.
*   Running into any issues?
    -   [ Try to get help from the community ](Community) on #ovirt IRC channel or
    -   [open a bugzilla](https://bugzilla.redhat.com/enter_bug.cgi?product=oVirt) ticket or
    -   Report it on the [first test day report etherpad](http://etherpad.ovirt.org/p/3.5-testday-1)

## Installation notes

*   Make sure you have one of the following distributions installed on your machine:
    -   Fedora 19
    -   Fedora 20
    -   CentOS 6.5
    -   Red Hat Enterprise Linux 6.5
    -   Any other distribution based on Red Hat Enterprise Linux 6.5
*   Follow installation instructions provided within [oVirt 3.5 Release Notes](OVirt_3.5_Release_Notes#Fedora_.2F_CentOS_.2F_RHEL)

### Known issues

*   VDSM packages released with the first 3.5.0 alpha have version lower than the ones we had in 3.4.1 so they won't be updated.
*   You can't add hosts to 3.5 clusters until a new VDSM build with 3.5 compatibility level will be released (All in One won't work).

## oVirt 3.5 New Features - Test Status Table

Please report test results on the [first test day report etherpad](http://etherpad.ovirt.org/p/3.4-testday-1) or on the table below.

|-----------------|----------------------------|-------|--------------|-----------|-------------------|-----|---------|
| Functional team | Feature                    | Owner | Dev - Status | Test page | Tested By/ Distro | BZs | remarks |
| General         | oVirt Live 3.5 (testing)   |       |              |           |                   |     |         |
| General         | upgrade from 3.4 (testing) |       |              |           |                   |     |         |
| General         | All in One setup (testing) |       |              |           |                   |     |         |

## Regression testing

### General

### Configuration

### Infra

### Storage

### Network

### Tools

#### New to v3.1:

#### New to v3.2:

#### New to v3.3:

#### New to v3.4:

### APIs

### Spice

### User Interface

### Node

### SLA

#### Affinity Groups

## Bug Reporting

*   ovirt - <https://bugzilla.redhat.com/enter_bug.cgi?product=oVirt>
*   Spice - <https://bugs.freedesktop.org/> under Spice product
*   VDSM - <https://bugzilla.redhat.com/enter_bug.cgi?product=oVirt> with vdsm component

Tracker bug for the release
