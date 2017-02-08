---
title: Hot Unplug Memory
category: feature
authors: mzamazal
wiki_category: Feature
wiki_title: Features/Hot Unplug Memory
wiki_revision_count: 1
wiki_last_updated: 2017-02-15
---

# Hot unplug memory

## Summary

This feature allows removing memory from a VM while the VM is running.

## Owner

*   Name: Milan Zamazal
*   Email: mzamazal@redhat.com
*   BZ: https://bugzilla.redhat.com/1228543

## Description

Until now, it was possible to only add memory to a running VM.  In order to
remove memory from a VM, the VM had to be shut down.

It is now possible to hot unplug memory from a running VM.  However there are
some limitations:

- You can't remove arbitrary amount of memory.  Only previously hot plugged
  memory devices can be removed.

- The guest OS must support memory hot unplug.  Most contemporary Linux systems
  should support it.

- All blocks of the previously hot plugged memory must be onlined as movable.

- It is not recommended to combine memory hot unplug with memory ballooning.

If any of those conditions is not satisfied, the memory hot unplug action may
fail or cause problems.

## Making hot plugged memory movable

To make hot plugged memory movable, it is necessary to execute proper actions
when onlining a hot plugged memory.  The hot plugged memory is not available to
the guest OS until it is onlined.  Your guest OS may ensure that a hot plugged
memory is onlined automatically.  For instance, on RHEL 7.3 systems there is a
udev file `/lib/udev/rules.d/40-redhat.rules` containing a line that looks like
this:

    # Memory hotadd request
    SUBSYSTEM=="memory", ACTION=="add", PROGRAM="/bin/uname -p", RESULT!="s390*", ATTR{state}=="offline", ATTR{state}="online"

However the state of the newly added memory is set to `online`, rather than
`online_movable`, in the rule.  This makes the hot plugged memory non-movable.
Simply changing `online` to `online_movable` would not work on current systems
(as of RHEL 7.3) since movable blocks of memory must be onlined in the right
order and the system doesn't guarantee that.  In the result, only a part of the
newly added memory might be available if `online` was changed to
`online_movable`.  (But if `online_movable` has already been present in the
udev rule then the system should support it correctly and you probably do not
have to change anything.)

To handle the problem you must disable the rule.  Copy
`/lib/udev/rules.d/40-redhat.rules` to `/etc/udev/rules.d/40-redhat.rules` and
comment out the line above in `/etc/udev/rules.d/40-redhat.rules` file by
putting `#` character in front of it:

    # Memory hotadd request
    # SUBSYSTEM=="memory", ACTION=="add", PROGRAM="/bin/uname -p", RESULT!="s390*", ATTR{state}=="offline", ATTR{state}="online"

Then run

    sudo systemctl restart systemd-udevd

After that udev won't online the newly added memory automatically anymore.  You
must do that manually each time after you hot plug some memory, using the
following shell script:

    #!/bin/bash
    for i in `ls -d1 /sys/devices/system/memory/memory* | sort -nr -t y -k 5`; do 
      if [ "`cat $i/state`" == "offline" ]; then
        echo online_movable > $i/state
      fi
    done
    
Note: After upgrading the system to a new version, you should check whether
there are any changes in `/lib/udev/rules.d/40-redhat.rules`.  If they are then
you should propagate them to `/etc/udev/rules.d/40-redhat.rules`, e.g. by
copying and editing the changed file again as described above.

## How to hot unplug memory from a VM

**Not yet implemented.**

The previously hot plugged memory appears in the form of memory devices in
*Vm Devices* tab of the given VM.  You can remove any of the devices (assuming
they have been hot plugged considering the constraints described above) and
thus remove that amount of memory from the VM.  Once the memory device is
successfully hot unplugged the device disappears from the device list.
