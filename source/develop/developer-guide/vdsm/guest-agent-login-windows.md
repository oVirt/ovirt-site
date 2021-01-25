---
title: Guest Agent Login Windows
category: vdsm
authors: danken
---

# Guest Agent Login Windows

## Automatic login on Windows

The automatic login on Windows is based on two components:

      1. The guest agent which handle the user's credentials and workflow.
      2. A Window's component interaction with the Winlogon system.

On Windows XP the component is implemented as a [GINA](http://msdn.microsoft.com/en-us/library/aa375457(v=vs.85).aspx) DLL. This method was replaced on Windows Vista with the new [Credential Providers](http://msdn.microsoft.com/en-us/magazine/cc163489.aspx) model.

The flow:

      1. The Window's component create a named pipe and is waiting for an incoming connection.
      2. The guest agent send the user's credentials though the named pipe.
      4. Using the user's credentials received from the named pipe, a login is performed on user's behalf.

