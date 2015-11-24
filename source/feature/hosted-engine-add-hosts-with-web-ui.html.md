---
title: Hosted Engine add hosts with Web UI
category: feature
authors: sandrobonazzola
wiki_category: Feature|Hosted Engine add hosts with Web UI
wiki_title: Features/Hosted Engine add hosts with Web UI
wiki_revision_count: 3
wiki_last_updated: 2015-10-06
feature_name: 'Hosted Engine: add hosts with Web UI'
feature_modules: all
feature_status: NEW
---

# Hosted Engine: add hosts with Web UI

### Summary

Allow to deploy additional hosts for Hosted Engine using Web UI

### Owner

*   Name: [ Sandro Bonazzola](User:SandroBonazzola)
*   Email: <sbonazzo@redhat.com>

### Detailed Description

*   ovirt-host-deploy must allow to deploy and configure ovirt-hosted-engine-ha daemons
*   ovirt-engine web UI must be changed for allowing the user to set an host as part of Hosted Engine HA cluster

### Benefit to oVirt

*   will simplify Hosted Engine deployment on additional hosts

### Dependencies / Related Features

*   Depends on [Features/Hosted_Engine_configuration_on_shared_storage](Features/Hosted_Engine_configuration_on_shared_storage)
*   A tracker bug has been created for tracking issues:

### Documentation / External references

<tbd>

### Testing

<tbd>

### Contingency Plan

*   The additional hosts will still be deployed by running hosted-engine --deploy and related patches will be reverted.

### Release Notes

      == Hosted Engine ==
      Hosted Engine additional hosts can now be deployed using the Web UI

### Comments and Discussion

*   Refer to [Talk:Hosted Engine add hosts with Web UI](Talk:Hosted Engine add hosts with Web UI)

[Hosted Engine add hosts with Web UI](Category:Feature) [Hosted Engine add hosts with Web UI](Category:oVirt 4.0 Proposed Feature) [Hosted Engine add hosts with Web UI](Category:Integration)
