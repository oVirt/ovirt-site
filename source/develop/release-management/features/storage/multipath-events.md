---
title: Multipath Alerts
category: feature
authors: frolland
---

# Multipath Alerts


## Overview

This feature adds the ability to display alerts to the user in
the engine UI when some multipath device have faulty paths, when
some multipath devices are non-operational because all paths became faulty,
and when all multipath devices on a host recover.

The purpose of this feature is to help users troubleshoot storage issues
before they become critical when a multipath device is lost, and to
make it easier to troubleshoot cases when some LUNs are not available
because all paths became faulty.

Currently, the user has no indication in oVirt of faulty paths.
As a result only when all paths are faulty and the access to the storage
domain is not working, the user will get an indication:
- If the all the hosts in the Data Center are reporting a problem in the 
storage domain. the storage domain status that will become 'Inactive'.
- If only one host reports a problem in the storage domain, the status
of the host will become 'Non Operational'.


## Owner

- Name: [Fred Rolland](https://github.com/rollandf)
- Email: <frolland@redhat.com>


## Detailed Description


### How it works

Vdsm will register to udev multipath events during storage initialization.
Vdsm will also build a map of all the faulty paths. 
For each event, Vdsm will update the map, according to the event.
The details of the faulty paths will be part of the statistics provided by
'Host.getStats' verb.

Engine polls the hosts for the statistics every 15 seconds.
Engine creates an audit log event according to the information provided
in the statistics. Only if there are changes in the faulty paths report,
an event will be created.


### New vdsm API

Host.getStats will report now new 'multipathHealth' key. The contents is a map of multipath alerts.


#### Multipath Health Map

The key of the map is the device mapper GUID.
The value is a MultipathAlert that contains:
- List of faulty paths.
- Number of valid paths

Here is an example of the map structure:

```json
"multipathHealth": {
    "36001405976dc283c6bf497b940e69eed": {
        "valid_paths": 0,
        "failed_paths": [
            "sdae"
        ]
    }
}
```

### Vdsm multipath event listener

Introduce a new Vdsm internal service for listening to multipath events:

- Code interested in receiving multipath events will subscribe a callback to receive the event
- When an event is received, all subscribers will receive the events (in another thread).
- If nobody is registered for events, the events are dropped
- The multipath event monitor will be started during storage initialization


The service will be implemented using 'pyudev', listening to these events:
- action=change,DM_ACTION=PATH_FAILED
- action=change,DM_ACTION=PATH_REINSTATED
- action=remove (for multipath devices)

We don't know yet how to detect multipath devices events efficiently for detecting removed devices.


- The user can disable this feature in a specific host in Vdsm configuration file

In the future, the monitor can be used for other code, for example maintaining LVM filter.

### Vdsm multipath health monitor

To report multipath health status to engine, we will add a multipath health monitor.

- The monitor subscribes to multipath events during startup
- The monitor builds a map of all the faulty paths during startup.
- The monitor updates the data set of the faulty paths when its callback is called:
    - PATH_FAILED - Add the faulty path to the map according to the device GUID
    - PATH_REINSTATED - Remove the faulty path to the map according to the device GUID
    - Multipath device removed  - remove the device from the map
- Multipath health status is provided to engine via 'Host.getStats' verb.


### New engine API

New audit logs are added:
- Faulty multipath paths on host "HOST_NAME" on devices: "GUID", "GUID" ...
- Devices without valid paths on host "HOST_NAME" : "GUID", "GUID" ...
- No faulty multipath paths on host "HOST_NAME"

## Benefit to oVirt

- The user will be able to detect storage issues faster.


## User Experience

New audit logs are added with information on the device path status.
The logs are per host.
Since the length of the information available in the audit log is limited,
the full information of the failing paths will be available in the logs.
The events are not generated on "real-time", but are based on polling of
the statistics. Only if a change in the data received is detected, a new
audit log will be created

If a single LUN goes down on all the hosts, the user will get an alarm
for each host in the DC.

If a single path goes down on one of the hosts, the user will get an alarm
only for this host.

## Logs

Vdsm logs the changes in the status of the paths.

```
INFO  (mpathlistener) [storage.mpathhealth] Path u'sdae' reinstated for multipath device u'36001405976dc283c6bf497b940e69eed', all paths are valid (mpathhealth:124)
WARN  (mpathlistener) [storage.mpathhealth] Path u'sdae' failed for multipath device u'36001405976dc283c6bf497b940e69eed', no valid paths left (mpathhealth:138)
```

## Installation/Upgrade

This feature does not affect engine or Vdsm installation or upgrades


## User workflows

- Once a user connects to a new ISCSI server, no events will be created.

- If there is an issue with the storage server, and multipath reports
an issue with one or more device path, a "Faulty multipath paths on host" event will be created

- Once the issue is fixed, and all paths are up a "No faulty multipath paths on host "HOST_NAME"
event will be created

- If only part of the paths are fixed, a "Faulty multipath paths on host" event will be created with the details of the devices.


## Dependencies / Related Features

Additional package dependency in Vdsm:
- pyudev

No related features.


### Entity Description

NA

## CRUD

NA


## Event Reporting

- Faulty multipath paths on host "HOST_NAME" on devices: "GUID", "GUID" ... 
- No faulty multipath paths on host "HOST_NAME"
- Devices without valid paths on host "HOST_NAME" : "GUID", "GUID" ...

## Documentation / External references

This feature is required for resolving
[Bug 723931](https://bugzilla.redhat.com/723931)

Pyudev - [pyudev documentation](http://pyudev.readthedocs.io/en/latest/guide.html#monitoring-devices)

Uevent [device mapper events kernel documentation](https://www.kernel.org/doc/Documentation/device-mapper/dm-uevent.txt)

## Testing

### Negative flows

- Block network to ISCSI storage server on a specific host
  - 'Faulty multipath paths on host "HOST_NAME" on devices: "GUID", "GUID" ...' is triggered
- Unblock access to ISCSI server on a specific host
  - Wait until all paths go up. a 'No faulty multipath paths on host "HOST_NAME"' is triggered
- Stop Vdsm, block network to ISCSI storage server on a specific host and start Vdsm
  - 'Faulty multipath paths on host "HOST_NAME" on devices: "GUID", "GUID" ...' is triggered

## Release Notes

TBD

## Open Issues

- In a scale environment, issue on the storage server or network can trigger
a lot of events. (Note that the events are generated per hosts and not per path).
