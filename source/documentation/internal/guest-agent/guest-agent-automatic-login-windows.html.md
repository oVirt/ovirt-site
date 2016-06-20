---
title: oVirt guest agent automatic login windows
category: ovirt-guest-agent
authors: bazulay
wiki_category: Ovirt_guest_agent
wiki_title: Ovirt guest agent automatic login windows
wiki_revision_count: 1
wiki_last_updated: 2011-10-28
---

<!-- TODO: Content review -->

# Ovirt guest agent automatic login windows

## Automatic login on Windows

The automatic login on Windows is based on two components:

      1. The ovirt-guest-agent which handle the user's credentials and workflow.
      2. A Window's component interaction with the Winlogon system.
         * for Windows XP - the component is implemented as a `[`GINA`](http://msdn.microsoft.com/en-us/library/aa375457(v=vs.85).aspx)` DLL. 
         * for WIn7 -The Gina interface was changed on Windows Vista with the new `[`Credential` `Providers`](http://msdn.microsoft.com/en-us/magazine/cc163489.aspx)` model.

Both above component are included in the ovirt-guest-agent git repo

#### The flow:

      1. The Window's component create a named pipe and is waiting for an incoming connection.
      2. The RHEV-Agnet receive the user's credentials from the VDSM though the virtio-serial device.
      3. The agent send the user's credentials though the named pipe.
      4. Using the user's credentials received from the named pipe, a login is performed on user's behalf.

<Category:Ovirt_guest_agent>
