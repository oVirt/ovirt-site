---
title: Supervdsm service
category: vdsm
authors: lvroyce, ybronhei
wiki_category: Feature
wiki_title: Features/Supervdsm service
wiki_revision_count: 33
wiki_last_updated: 2013-08-04
---

# Supervdsm service

## General

Supervdsm is responsible for all privileged operations. Currently Supervdsm is managed (started and restarted) by unprivileged process 'vdsm'. To perform that, Vdsm process runs privileged operations, manage process that runs as root, and communicate with it by external UDS. All that leads to races between new and old instances of the process. Aim of this feature is to get Vdsm to be a pure unprivileged process and simplify the handling of crashes and re-establish communication between Vdsm and Supervdsm after failures.

## Owner

*   Name: [ lvroyce](User:Royce Lv)
*   Name: [ybronhei](User:Yaniv Bronheim)

<!-- -->

*   Email: <lvroyce@linux.vnet.ibm.com>
*   Email: <ybronhei@redhat.com>

## Current status

*   current solution

1.  Vdsmd.init start vdsm with user “vdsm”
2.  Launch supervdsm when it is not running by sudo command
3.  Vdsm tries to call supervdsm
4.  When authentication error, re-launch (kill old instance and initiate new one), other errors just raise
5.  When vdsm dies, supervdsm distinguish it and kill itself automatically, next vdsm instance starts new supervdsm process

![](First launch.jpeg "fig:First launch.jpeg")![](Normal call.jpeg "fig:Normal call.jpeg") ![](Auth error.jpeg "fig:Auth error.jpeg")

*   Current problems

1.  Unprivileged vdsm and proxy need to call previleged “sudo launch” and “sudo kill”
2.  Redundent key between vdsm and supervdsm as they are parent and child
3.  Error handling cause races between old and new instance of supervdsm and vdsm

*   Last updated: ,

## Proposed changes

*   Proposal A:[patch for proposal A](http://gerrit.ovirt.org/gitweb?p=vdsm.git;a=commit;h=976dbb13e6cd8136b12ed58ccd2a5176b730bddf)

1.  Vdsmd.init starts vdsm as root
2.  Vdsm forks supervdsm server and then drop privilege
3.  When vdsm exit, supervdsm probe vdsm heart beat stop and exit
4.  Vdsm call supervdsm may discover supervdsm server exit, vdsm will exit itself and restart

*   Proposal B:[patch for proposal B](http://gerrit.ovirt.org/gitweb?p=vdsm.git;a=commit;h=033ef4bc73dbbb36dd8180049626e7f4cde56334)

1.  vdsmd.init starts supervdsm as root
2.  supervdsm forks vdsm as child process
3.  when vdsm dies, supervdsm kill itself and start over again
4.  when supervdsm, vdsm distinguish that and kill itself

*   proposal C:[patch for proposal C](http://gerrit.ovirt.org/#/c/11051/) -> **Selected solution.**

1.  Vdsmd.init starts vdsm as vdsm user
2.  Supervdsmd.init starts supervdsm as root
3.  Both services are managed by respawn and start over again after crash
4.  When vdsm cannot connect to supervdsm socket, it restarts supervdsm service 3 tries

## Exception flows to consider

*   Exception flows:

1.  One of supervdsm server export function raise error
    -   expected result: raise to proxy caller

2.  Supervdsm main thread died during a call (need to test)
    -   expected result: raise to proxy caller EOFError
    -   supervdsm restarts automatically and vdsm call to the same function again

3.  supervdsm main thread killed before call
    -   expected result:restart supervdsm and call

4.  vdsm crash
    -   supervdsm stays up and vdsm re-establish communication to supervdsm socket

## Proposal comparison

*   Exception flows need attention：

1.  First launch
    -   A: Supervdsm server process lauched by priviledged vdsm, then vdsm drop priviledge
    -   B: Supervdsm server process lauched by vdsmd.init
    -   C: Supervdsm server process launched by supervdsmd.init

2.  One of supervdsm server export function raise error
    -   A:Just raise to Proxy Caller
    -   B:Just raise to Proxy Calller
    -   C:Just raise to Proxy Calller

3.  Supervdsm main thread killed when calling
    -   A: Discover when call return EOFError and then restart
    -   B: Vdsmd as supervdsm's child should kill itself when receive EOFError
    -   C: Supervdsmd restarts supervdsmServer and vdsm call the method again

4.  Supervdsm main thread killed before call
    -   A: Discover when "isRunning" raise error, then restart
    -   B: Vdsmd as supervdsm's child should be killed when next time supervdsm start, or vdsmd also has a heart beat scheme for super vdsm
    -   C: Supervdsmd restarts supervdsm

5.  Supervdsm server thread killed(not started) before call
    -   A: Connect error, restart
    -   B: Supervdsm restart itself
    -   C: Supervdsmd restarts, if still doesn't work for 3 reties vdsm call panic and restarts

6.  Vdsm process died
    -   A: Supervdsm has heart beat for vdsm to kill itself
    -   B: Supervdsm joined vdsm and restart all over
    -   C: Nothing.

As we can see from the above, proposal B will involve more complex logic when supervdsm died, vdsm will probe its heart beat or supervdsm should kill vdsm for next time, but vdsm still in the middle of some operations, possible inconsistent situation will happen. Proposal C is intuitive, easier, and less complex than both A and B proposals. The main odd is that every code update of vdsm we need restart both services, as they both share same code.

## Benefit to oVirt

1.  Clean vdsm priviledge usage
2.  Clean and stable vdsm/supervdsm exception flow and races

## Documentation / External references

*   TODO: paste corresponding bugzilla link and gerrit link here

## Comments and Discussion

This below adds a link to the "discussion" tab associated with your page. This provides the ability to have ongoing comments or conversation without bogging down the main feature page

*   Refer to [Talk:Your feature name](Talk:Your feature name)

<Category:Feature> <Category:Vdsm>
