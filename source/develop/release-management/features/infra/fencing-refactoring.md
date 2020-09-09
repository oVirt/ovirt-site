---
title: Fencing refactoring
category: feature
authors: mperina, sandrobonazzola
feature_name: Fencing refactoring
feature_modules: engine
feature_status: Design
---

# Fencing refactoring

## Summary

The goal of this fencing refactoring is to clean up the code and provide those features:

*   Make SSH Soft Fencing part of Non Responding Treatment
*   Refactor fencing related code to be more reliable, readable, covered by unit tests and we could provided ability to enable/disable SSH Soft Fencing, Kdump detection and Power Management Restart per host
*   Refactor Power Management tab in Host Detail to ease management of multiple power management agents

Following bugs are associated with fencing refactoring:

*   [#1182510 - [RFE] - Fencing refactoring](https://bugzilla.redhat.com/1182510)
*   [#1198628 - [RFE] - Refactoring of Power Management tab in Host Detail](https://bugzilla.redhat.com/1198628)

## Owner

*   Name: Martin Peřina
*   Email: mperina@redhat.com

## Status

Following parts were finished and they will be part of oVirt 3.6 release:

*   Make SSH Soft Fencing part of Non Responding Treatment
*   Refactor fencing related code to be more reliable, readable, covered by unit tests
*   Refactor Power Management tab in Host Detail to ease management of multiple power management agents

Following parts were not finished and they were postponed to oVirt 4 release:

*   Ability to enable/disable SSH Soft Fencing, Kdump detection and Power Management Restart per host

## Detailed Description

Non Responding Treatment in oVirt <= 3.5 is described [ here](/images/wiki/Current-whole-process.png). Following changes are planned for oVirt 3.6:

*   Non Responding Treatment will be executed for any host when host status is changed to **NonResponsive** (in oVirt <= 3.5 SSH Soft Fencing execution is enabled for all hosts and Non Responding Treatment execution is enabled only for hosts with **Virt** capabilities, in oVirt 3.6 only SSH Soft Fencing step will be executed for **Gluster** only hosts).
*   The delay between host status **Up** is changed to **NonResponsive** is defined on page [Automatic Fencing](/develop/developer-guide/engine/automatic-fencing.html#automatic-fencing).
*   Non Responding Treatment will contain by default 3 steps (they can be enabled/disabled per host):
    1.  **SSH Soft Fencing**
    2.  **Kdump Detection**
    3.  **Power Management Restart**

So in oVirt 3.6 whole Non Responding Treatment will be [ simplified](/images/wiki/New-whole-process.png) using configurable [ steps](/images/wiki/Fence-sequence-definition.png).

### Database structure

To hold information about Non Responding Treatment steps table `fence_sequence_steps` will be created:

| Name          | Type        | NULL | PK  | Description                 |
|---------------|-------------|------|-----|-----------------------------|
| step_name    | VARCHAR(25) | N    | Y   | One of `SSH`, `KDUMP`, `PM` |
| vds_id       | UUID        | N    | Y   | Existing host ID            |
| step_order   | SMALLINT    | N    | N   | Order of the step           |
| step_enabled | BOOLEAN     | N    | N   |                             |

Each host will own one record in this table, which will be created during 1st host deploy or during oVirt upgrade. Also during oVirt upgrade value of existing column `vds_static.pm_detect_kdump` will converted into `KDUMP` step in `fence_sequence_steps` table.

### Webadmin UI

New [ Host Availability](/images/wiki/Fence-refactoring-host-availability-tab.png) tab will be added into **Host detail** dialog. This tab will contain check boxes for all steps to enabled/disable each step for the specific host. And it will also contain other options related to host availability.

[ Power Management](/images/wiki/Fence-refactoring-power-management-tab.png) tab will be refactored to ease handling of multiple power management agents.

### REST API

*   Existing Fence Sequence Steps for a host can be listed using URL `/api/hosts/{id}/fence-sequence-steps`:
        <fence-sequence-steps>
          <fence-sequence-step>
            <name>Name</name>
            <order>1</order>
            <enabled>1</enabled>
          <fence-sequence-step>
        ...
        </fence-sequence-steps>

*   To enable or disable Fence Sequence Step `PUT` operation using URL `/api/hosts/{id}/fence-sequence-steps/{name}` with `enabled` parameter can be executed.
*   Other operation like creating and removing step is not currently supported.

## Testing

Testing of the feature can be divided to fencing flow testing and new Power Management UI testing.

### Fencing flow testing

Huge part of fencing related code were refactored so all fencing related flows should be tested for regressions. Here are test which was tested prior to merging the code:

*   Testing fence agent options (for all possible host/custer/DC combinations)
*   Testing manual Start/Stop/Restart PM actions for the host
*   Testing SSH Soft Fencing
*   Testing Kdump integration
*   Testing Non Responding Treatment

Also prior to merging new code following bugs were successfully tested for regressions: 1149235 1141514 1149235 1140098 1145321 1129381 1133611 1070674 1131411 1120829 1122473 1114977 1093742 878662 1005756 1064860 1099903 1090800 961753 1054778 1044089 917039 1048356

### New Power Management tab UI testing

Following feature should be tested:

*   Ability to add/edit/remove fence agents options
*   Ability to add multiple sequential fence agents
*   Ability to add multiple concurrent fence agents
*   Ability to mix sequential/concurrent fence agents

