---
title: Multipath Events
category: feature
authors: Fred Rolland
feature_name: Multipath Events
feature_modules: engine,vdsm
feature_status: Design
---

# Multipath Events


## Overview

This feature adds the ability to display events to the user in
the engine UI when multipath device path changes its status.
The supported events are when a path moves to down or up state.
With these events, the user will be able to detect storage issues faster.


## Owner

- Name: [Fred Rolland](https://github.com/rollandf)
- Email: <frolland@redhat.com>


## Detailed Description


### How it works

When a host is connected to a DC (Storage Pool), Vdsm will register
to udev multipath events. For each event, a message will be sent to Engine
with the details of the event. Engine will create an audit log event. 
Once the host is disconnected from the DC, Vdsm will unregister from
the 'udev' events.


### New vdsm API

New multipath event type


#### Multipath Event

An event with information about the multipath device, path and status.

A mapping with these keys:
- type: Path Failed/Path Reinstated (DM_ACTION)
- device (GUID): unique GUID of this device (DM_NAME)
- valid_paths - number of valid paths (DM_NR_VALID_PATHS)
- seqnum - event sequence number, may be used to detect missed messages later (DM_SEQNUM)


### Vdsm multipath event monitoring

Introduce a new Vdsm internal service for handling events:

- Code interested in receiving mutlipath events will subscribe a callback to receive the event
- When an event is received, all subscribers will receive the events (in another thread).
- If nobody is registered for events, the events are dropped
- The multipath event monitor will be started when connecting to the pool
- The multipath event monitor will be stopped when disconnecting from the pool


A Udev event monitor is introduced, listening to device-mapper udev events.
The relevant events for this feature are PATH_FAILED and PATH_REINSTATED:

Variable Name: DM_ACTION
Uevent Action(s): KOBJ_CHANGE
Type: string
Description:
Value: Device-mapper specific action that caused the uevent action.
	PATH_FAILED - A path has failed.
	PATH_REINSTATED - A path has been reinstated.

- The Vdsm will suscribe the monitor to events during startup.
- The Vdsm will start the Udev event monitor when connecting to the storage pool.
- The listener will send an event to the engine when its callback is called.
- The Vdsm will unregister the listener to the Udev event monitor when 
disconnecting to the storage pool.
- The user can disable this feature in a specific host in Vdsm configuration file

In the future, the monitor can be used for other code, for example maintaining LVM filter.

### New engine API

New audit logs are added:
- Multipath device path up
- Multipath device path down

## Benefit to oVirt

- The user will be able to detect storage issues faster.


## User Experience

New audit logs are added with information on the device path status.


## Installation/Upgrade

This feature does not affect engine or Vdsm installation or upgrades


## User work-flows

- Once a user connects to an ISCSI server, 'Multipath device path up' event
will be created.

- If there is an issue with the connection to the storage server, and the 
multipath reports an issue with one or more device path,
'Multipath device path down' will be created.

- Once the issue is fixed, 'Multipath device path up' event will be created.


## Dependencies / Related Features

Additional package dependency in Vdsm:
- pyudev

No related features.


### Entity Description

NA

## CRUD

NA


## Event Reporting

- 'Multipath device path up'
- 'Multipath device path down'


## Documentation / External references

This feature is required for resolving
[Bug 723931](https://bugzilla.redhat.com/723931)

Pyudev - [Monitoring devices](http://pyudev.readthedocs.io/en/latest/guide.html#monitoring-devices)

Uevent [example](https://www.kernel.org/doc/Documentation/device-mapper/dm-uevent.txt)

## Testing

- Connect to a new ISCSI storage server
  - For each multipath device path a 'Multipath device path up' is triggered


### Negative flows

- Block network to ISCSI storage server
  - For each multipath device path a 'Multipath device path down' is triggered
- Unblock access to iscsi server
  - Wait until all paths go up. There should be 'Multipath device path up' for 
    every path on this iscsi server

## Release Notes

TBD

## Open Issues

- Connecting to a new ISCSI storage server will trigger a lot of events,
that are not useful to the user.
- In a scale environment, issue on the storage server or network can trigger
an event storm.
