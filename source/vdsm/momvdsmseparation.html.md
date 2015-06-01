---
title: MomVdsmSeparation
category: vdsm
authors: fromani, msivak
wiki_category: Feature
wiki_title: Features/MomVdsmSeparation
wiki_revision_count: 7
wiki_last_updated: 2015-06-03
feature_name: Starting MOM as a separate process instead of VDSM threa
feature_modules: vdsm,mom
feature_status: Draft
---

# Mom Vdsm Separation

## Starting MOM as a separate process instead of VDSM thread

### Summary

MOM is moving to be used as a standalone process again because of some VDSM performance issues caused by a number of threads.

### Owner

*   Name: [ Martin Sivak](User:Msivak)
*   Email: <msivak@redhat.com>
*   Name: [ Francesco Romani](User:fromani)
*   Email: <fromani@redhat.com>

### Detailed Description

#### The proposed changes

*   The RPC port will be enabled in MOM
*   MOM will be started using new systemd service (mom-vdsm) provided by VDSM
*   the service file will also configure MOM to use the config files and policy dir provided by VDSM
*   VDSM will use the RPC port to talk to MOM (UpdateMomPolicy)
*   KsmTune command needs to be added to the VDSM's API
*   MOM will use either XML-RPC or json-RPC to talk to VDSM
*   MOM will cache the results of getAllVmStats instead of asking for stats per VM

### Benefit to oVirt

### Dependencies / Related Features

### Documentation / External references

TBD

### Testing

### Contingency Plan

We can tweak the config file (/etc/vdsm/mom.conf) values to use 15 second period for all loops. That provides a huge improvement on the test (120 CPUs) machine.

### Release Notes

TBD

### Comments and Discussion

*   Refer to <Talk:MomVdsmSeparation>

<Category:Feature> <Category:Sla>
