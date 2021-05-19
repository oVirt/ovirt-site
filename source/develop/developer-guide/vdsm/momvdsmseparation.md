---
title: MomVdsmSeparation
category: feature
authors: fromani, msivak
---

# Mom Vdsm Separation

## Starting MOM as a separate process instead of VDSM thread

### Summary

MOM is moving to be used as a standalone process again because of some VDSM performance issues caused by a number of threads.

### Owner

*   Name: Martin Sivak (Msivak)
*   Email: <msivak@redhat.com>
*   Name: Francesco Romani (fromani)
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

We expect a performance gain in both VDSM and MOM, due to the reduced pressure on the python GIL in both processes. Both processes will be further optimized. Running the two processes separately makes it easier to profile and to evaluate the performances of each one.

### Dependencies / Related Features

The separation requires MOM >= TBD and VDSM >= 4.17.0. Older version are not compatible with this feature.

### Documentation / External references

Bugzilla entry: <https://bugzilla.redhat.com/show_bug.cgi?id=1227714>

### Testing

* non-regression: MOM as-process should provide the same functionality as MOM as-thread.

* resilience in presence of crashes: if MOM as-process restarts or is down for some time, VDSM should handle gracefully this event.

* reduced performance footprint (CPU): to be evaluated.

### Contingency Plan

We can tweak the config file (/etc/vdsm/mom.conf) values to use 15 second period for all loops. That provides a huge improvement on the test (120 CPUs) machine.

We want to ship mom as a separate process as new default in 3.6. However, old code will be kept, so it will be possible to run MOM as VDSM thread with manual configuration, obtaining the same behaviour as in oVirt 3.5.x.

Instructions to reconfigure MOM to run as VDSM thread will be provided on this page.

### Release Notes

TBD



