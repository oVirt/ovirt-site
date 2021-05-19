---
title: Supervdsm service
category: feature
authors: lvroyce, ybronhei
---

# Supervdsm service

## General

Supervdsm is responsible for all privileged operations. Currently Supervdsm is managed (started and restarted) by unprivileged process 'vdsm' and vdsm starts up by init service manager. To perform that, Vdsm process runs privileged operations, manage process that runs as root, and communicate with it by external UDS. All that leads to races between new and old instances of the process. Aim of this feature is to get Vdsm to be a pure unprivileged daemon and simplify the handling of crashes and re-establish communication between Vdsm and Supervdsm after failures.

## Owner

*   Name: lvroyce (Royce Lv)
*   Name: ybronhei (Yaniv Bronheim)

<!-- -->

*   Email: <lvroyce@linux.vnet.ibm.com>
*   Email: <ybronhei@redhat.com>

## Background - History until 3.3

*   current solution

1.  Vdsm daemon script starts vdsm with user “vdsm”
2.  Vdsm process launches supervdsm process when it is not running by sudo command
3.  Vdsm tries to send uds packets to supervdsm to establish communication
4.  When authentication error is raised, vdsm tries to re-launch (kill old instance and initiate new one)
5.  When vdsm crashes, supervdsm distinguish it and kill itself automatically, next vdsm instance starts new supervdsm process

![](/images/wiki/First_launch.png)![](/images/wiki/Normal_call.png) ![](/images/wiki/Auth_error.png)

*   Current flow errors

1.  Unprivileged vdsm and proxy need to call previleged “sudo launch” and “sudo kill”
2.  Redundant key between vdsm and supervdsm as they are parent and child
3.  Error handling cause races between old and new instance of supervdsm and vdsm

*   Last updated: ,

## Proposed changes

*   Proposal A:[patch for proposal A](http://gerrit.ovirt.org/gitweb?p=vdsm.git;a=commit;h=976dbb13e6cd8136b12ed58ccd2a5176b730bddf)

1.  Vdsm init script starts vdsm as root
2.  Vdsm forks supervdsm server and then drop privilege
3.  When vdsm exits, supervdsm probe vdsm heart beat stop and exit
4.  Vdsm call supervdsm may discover supervdsm server exit, vdsm will exit itself and restart

*   Proposal B:[patch for proposal B](http://gerrit.ovirt.org/gitweb?p=vdsm.git;a=commit;h=033ef4bc73dbbb36dd8180049626e7f4cde56334)

1.  Vdsm init script starts supervdsm as root
2.  Supervdsm forks vdsm as child process
3.  When vdsm dies, supervdsm kill itself and start over again
4.  When supervdsm, vdsm distinguish that and kill itself

*   proposal C:[patch for proposal C](http://gerrit.ovirt.org/#/c/11051/) -> **Selected solution.**

1.  Vdsmd.init starts vdsm as vdsm user
2.  Supervdsmd.init starts supervdsm as root
3.  Both services are managed by service manager and restart after a crash.
4.  No need to handle broken connection. When supervdsm or vdsm fails to start an automatically restart takes care of establishing recommunication.

## Exception flows to consider

*   Exception flows:

1.  One of Supervdsm server export function raise error
    -   Expected result: Raise to proxy caller, supervdsm restarts automatically without trying to call the same function again. The proxy caller should handle exceptions specifically.

2.  Supervdsm main thread died during a call or before call
    -   Expected result: Raise to proxy caller related exception. Supervdsm proxy caller should handle exceptions specifically.

3.  Vdsm crash
    -   supervdsm stays up and vdsm re-establish communication to supervdsm socket after restart.

## Proposal comparison

*   Exception flows need attention：

1.  First launch
    -   A: Supervdsm server process lauched by priviledged vdsm, then vdsm drop priviledge
    -   B: Supervdsm server process lauched by service manager
    -   C: Supervdsm server process launched by service manager

2.  One of supervdsm server export function raise error
    -   A: Raise to Proxy Caller
    -   B: Raise to Proxy Calller
    -   C: Raise to Proxy Calller

3.  Supervdsm main thread killed when calling
    -   A: Discover when call return EOFError and then restart
    -   B: Vdsmd as supervdsm's child should kill itself when receive EOFError
    -   C: Services manager restarts supervdsm. Caller should handle the returned exception.

4.  Supervdsm main thread killed before call
    -   A: Discover when "isRunning" raise error, then restart
    -   B: Vdsmd as supervdsm's child should be killed when next time supervdsm start, or vdsmd also has a heart beat scheme for super vdsm
    -   C: Supervdsmd restarts supervdsm

5.  Supervdsm server thread killed(not started) before call
    -   A: Connect error, restart
    -   B: Supervdsm restart itself
    -   C: Service manager restarts Supervdsm.

6.  Vdsm process died
    -   A: Supervdsm has heart beat for Vdsm to kill itself
    -   B: Supervdsm joined Vdsm and restart all over
    -   C: Service manager restarts Vdsm.

As we can see from the above, proposal B will involve more complex logic when supervdsm died, vdsm will probe its heart beat or supervdsm should kill vdsm for next time, but vdsm still in the middle of some operations, possible inconsistent situation will happen. Proposal C is intuitive, easier, and less complex than both A and B proposals. The main odd is that every code update of vdsm we need restart both services, as they both share same code.

## Benefit to oVirt

1.  Clean vdsm priviledge usage
2.  Clean and stable vdsm/supervdsm exception flow and races
