---
title: Fencing refactoring
category: feature
authors: mperina
wiki_category: Feature
wiki_title: Features/Fencing refactoring
wiki_revision_count: 26
wiki_last_updated: 2015-03-04
feature_name: Fencing refactoring
feature_modules: engine
feature_status: Design
---

# Fencing refactoring

## Summary

The goal of this fencing refactoring is to clean up the code and provide those features:

*   Make SSH Soft Fencing part of Non Responding Treatment
*   Provide ability to enable/disable SSH Soft Fencing, Kdump detection and Power Management Restart per host

## Owner

*   Name: Martin Peřina
*   Email: mperina@redhat.com

## Detailed Description

*   Non Responding Treatment will be executed for any host when host status is changed to **NonResponsive** (in oVirt <= 3.5 SSH Soft Fencing execution is enabled for all hosts and Non Responding Treatment execution is enabled only for hosts with **Virt** capabilities, in oVirt 3.6 only SSH Soft Fencing step will be executed for **Gluster** only hosts).
*   The delay between host status **Up** is changed to **NonResponsive** is defined on page [Automatic Fencing](Automatic_Fencing#Automatic_Fencing).
*   Non Responding Treatment will contain by default 3 steps (they can be enabled/disabled per host):
    1.  **SSH Soft Fencing**
    2.  **Kdump Detection**
    3.  **Power Management Restart**

### Database structure

To hold information about Non Responding Treatment steps table `fence_sequence_steps` will be created:

| Name          | Type        | NULL | PK  | Description                 |
|---------------|-------------|------|-----|-----------------------------|
| step_name    | VARCHAR(25) | N    | Y   | One of `SSH`, `KDUMP`, `PM` |
| vds_id       | UUID        | N    | Y   | Existing host ID            |
| step_order   | SMALLINT    | N    | N   | Order of the step           |
| step_enabled | BOOLEAN     | N    | N   |                             |

Each host will own one record in this table, which will be created during 1st host deploy or during oVirt upgrade. Also during oVirt upgrade value of existing column `vds_static.pm_detect_kdump` will converted into `KDUMP<tt> step in <tt>fence_sequence_steps` table.

### Webadmin UI

New **Fence Sequence** tab will be added into **Host detail** dialog. This tab will contain check boxes for all steps to enabled/disable each step for the specific host.

### REST API

*   Existing Fence Sequence Steps for a host can be listed using URL `/api/hosts/{id}/fence-sequence-steps`:
        <fence-sequence-steps>
          <fence-sequence-step>
            <name>Name</name>
            <host>Host ID</host>
            <step-order>1</step-order>
            <step-enabled>1</step-enabled>
          <fence-sequence-step>
        ...
        </fence-sequence-steps>

*   To enable or disable Fence Sequence Step `PUT` operation using URL `/api/hosts/{id}/fence-sequence-steps/{name}` with parameter `step-enabled` can be executed.
*   Other operation like creating and removing step is not currently supported.

## Testing

TBD

<Category:Feature> [Category:oVirt 3.6 Proposed Feature](Category:oVirt 3.6 Proposed Feature)
