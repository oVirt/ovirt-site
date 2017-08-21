---
title: oVirt guest agent automatic login windows
category: ovirt-guest-agent
authors: bazulay
---

<!-- TODO: Content review -->

# oVirt guest agent automatic login windows

## Automatic login on Windows

The automatic login on Windows is based on two components:

1. The ovirt-guest-agent which handles the user's credentials and workflow.
2. A component that interacts with the Winlogon system:
   * For Windows XP -- the component is implemented as a [GINA](http://msdn.microsoft.com/en-us/library/aa375457(v=vs.85).aspx) DLL.
   * For Windows 7 and newer -- the component uses the new [Credential Providers](https://msdn.microsoft.com/en-us/library/windows/desktop/bb648647(v=vs.85).aspx) model.

Both above component are included in the ovirt-guest-agent git repo

#### The flow:

1. The Windows component creates a named pipe and waits for an incoming connection.
2. The RHEV-Agnet receives the user's credentials from the VDSM through the virtio-serial device.
3. The agent sends the user's credentials through the named pipe.
4. Using the user's credentials received from the named pipe, a login is performed on the user's behalf.

