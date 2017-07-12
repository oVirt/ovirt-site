---
title: Update device hooks
authors: gvallarelli
---

# Update device hooks

### Summary

RHEV 3.2 introduces a verb called updateDevice which enable connecting a VM to a network on the fly. Update NIC flows in vdsm do not have hooks today. It can be a problem when using the other flows to connect a VM to the network but not being able to update the nic after updating it in the engine.

### Owner

*   Name: Giuseppe Vallarelli (gvallarelli)
*   Email: <gvallare@redhat.com>
*   IRC: gvallarelli at #ovirt (irc.oftc.net)

### Current Status

*   Status: done
*   Last updated: ,

### Hooks

Proposed hooks are the following ones:

*   before_update_device
*   after_update_device
*   after_update_device_fail

Hooks are triggered when updating a nic interface.
