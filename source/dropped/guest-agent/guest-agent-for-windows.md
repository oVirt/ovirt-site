---
title: oVirt Guest Agent For Windows
authors:
  - karli.sjoberg
  - lveyde
  - nkesick
---

<!-- TODO: Content review -->

# oVirt Guest Agent For Windows

## Important Note!

With the release of oVirt 3.5 we have introduced the oVirt WGT (Windows Guest Tools).

The oVirt WGT provides an ISO with all the tools and drivers one needs to install on a Windows VM, with an easy to use installer to install it all in one step.

So manual compilation and installation of oVirt Guest Agent is no longer necessary.

The oVirt WGT ISO is included in [ovirt-guest-tools-iso-3.5-7.noarch.rpm](http://resources.ovirt.org/pub/ovirt-3.5/rpm/fc20/noarch/ovirt-guest-tools-iso-3.5-7.noarch.rpm) package.

## How to install the ovirt-guest-agent on Windows.

First of all, make sure that you have installed drivers for virtio-serial and let the VM reboot, it won´t work otherwise. Then you need to get the files for windows. You use "git" to clone the tree needed:

    $ git clone https://github.com/oVirt/ovirt-guest-agent.git

You either install git inside the VM, or sit at another machine where you have git and then find a way to get the `ovirt-guest-agent` directory over on to the Windows VM.

So you´ll end up with a directory called ovirt-guest-agent. Inside of it is another directory also called `ovirt-guest-agent` (to not complicate matters..), and inside of that is a file called `README-windows.txt` that very clearly explains how to install the service.

1.  [Install Python 2.7 for Windows](http://www.python.org/ftp/python/2.7.3/python-2.7.3.msi)
2.  [Install Python for Windows extension](http://sourceforge.net/projects/pywin32/files/pywin32/Build216/pywin32-216.win32-py2.7.exe/download)
3.  [Install py2exe](http://sourceforge.net/projects/py2exe/files/py2exe/0.6.9/py2exe-0.6.9.win32-py2.7.exe/download)
4.  Run command:

        %EXTRACTDIR%\ovirt-guest-agent\ovirt-guest-agent> C:\Python27\python.exe setup.py py2exe -b 1

And you´ll get two files in `.\dist\` called `OVirtGuestService.exe` and `w9xpopen.exe`. Take them, along with `.\ovirt-guest-agent.ini`, create an appropriate folder for them, e.g. `C:\Program Files\Guest Agents\oVirt Guest Agent` and copy those files there.

Using as command prompt running as administrator, run the following commands to get it installed:

    C:\Program Files\Guest Agents\oVirt Guest Agent> OVirtGuestService.exe -install
    C:\Program Files\Guest Agents\oVirt Guest Agent> net start OVirtGuestService
    C:\Program Files\Guest Agents\oVirt Guest Agent> sc config "OVirtGuestService" start= auto

Everything is then installed so you can delete the `%EXTRACTDIR%\ovirt-guest-agent`. You won't be needing it anymore.
