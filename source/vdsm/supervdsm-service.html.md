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

The actual name of your feature page should look something like: "Your feature name". Use natural language to [name the pages](How to make pages#Page_naming).

## Summary

Supervdsm should be responsible for all priviledged operations, but as supervdsm is started by unpriviledged vdsm, vdsm now does some priviledged operations. Aim of this feature is to get vdsm to be a pure unpriviledged process and move all privildged operations to supervdsm.

## Owner

*   Name: [ lvroyce](User:Royce Lv)

<!-- -->

*   Email: <lvroyce@linux.vnet.ibm.com>

## Current status

*   current solution

1.  vdsmd.init start vdsm with user “vdsm”
2.  launch supervdsm when it is not running
3.  vdsm tries to call supervdsm
4.  when authentication error, re-launch, others just raise

![](First launch.jpeg "fig:First launch.jpeg")![](Normal call.jpeg "fig:Normal call.jpeg") ![](Auth error.jpeg "fig:Auth error.jpeg")

*   current problem

1.  unprivileged vdsm and proxy need to call previleged “sudo launch” and “sudo kill”
2.  redundent key between vdsm and supervdsm as they are parent and child
3.  vdsm call supervdsm exception flow problems

*   Last updated: ,

## Detailed Description

*   new proposal A:[patch for proposal A](http://gerrit.ovirt.org/gitweb?p=vdsm.git;a=commit;h=976dbb13e6cd8136b12ed58ccd2a5176b730bddf)

1.  vdsmd.init starts vdsm as root
2.  vdsm forks supervdsm server and then drop privilege
3.  when vdsm exit, supervdsm probe vdsm heart beat stop and exit
4.  vdsm call supervdsm may discover supervdsm server exit, vdsm will exit itself and restart

*   new proposal B:[patch for proposal B](http://gerrit.ovirt.org/gitweb?p=vdsm.git;a=commit;h=033ef4bc73dbbb36dd8180049626e7f4cde56334)

1.  vdsmd.init starts supervdsm as root
2.  supervdsm forks vdsm

## Exception flows to consider

*   supervdsm server process has 4 parts:

1.  main thread
2.  supervdsm server thread(the one starts supervdsmServer manager)
3.  supervdsm server exported functions
4.  keep alive thread(let's assume this simple function will not cause exceptions)

item 1.2.4 mean supervdsm server framework problem, 1.2 need to be handled by restart supervdsmServer.

*   exception flows need attention(also future test cases)：

1.  one of supervdsm server export function raise error
    -   expected result: raise to proxy caller

2.  supervdsm main thread killed when calling
    -   expected result: raise to proxy caller EOFError(now)
    -   vdsm restart all over, because vdsm lost privilege(future)

3.  supervdsm main thread killed before call
    -   expected result:restart supervdsm and call(current)
    -   vdsm restart all over(future)

4.  supervdsm server thread killed(not started) before call
    -   expected result: connection error will raised to proxy caller(current)
    -   connection error and then vdsm restart all over(future)

5.  supervdsm server thread killed(not started) when call
    -   expected result:current:TODO
    -   new:TODO

6.  vdsm process died
    -   expected result:current: supervdsm server will kill itself(seconds delay, careful of regression, bug related:<https://bugzilla.redhat.com/show_bug.cgi?id=890365>)
    -   future: supervdsm server will kill itself and restart all over

## Proposal comparison

*   exception flows need attention(also future test cases)：

1.  first launch
    -   A: supervdsm server process lauched by priviledged vdsm, then vdsm drop priviledge
    -   B: supervdsm server process lauched by vdsmd.init

2.  one of supervdsm server export function raise error
    -   A: just raise to Proxy Caller
    -   B:just raise to Proxy Calller

3.  supervdsm main thread killed when calling
    -   A: discover when call return EOFError and then restart
    -   vdsm restart all over, because vdsm lost privilege(future)

4.  supervdsm main thread killed before call
    -   expected result:restart supervdsm and call(current)
    -   vdsm restart all over(future)

5.  supervdsm server thread killed(not started) before call
    -   expected result: connection error will raised to proxy caller(current)
    -   connection error and then vdsm restart all over(future)

6.  supervdsm server thread killed(not started) when call
    -   expected result:current:TODO
    -   new:TODO

7.  vdsm process died
    -   expected result:current: supervdsm server will kill itself(seconds delay, careful of regression, bug related:<https://bugzilla.redhat.com/show_bug.cgi?id=890365>)
    -   future: supervdsm server will kill itself and restart all over

## Benefit to oVirt

1.  Clean vdsm priviledge usage
2.  clean and stable vdsm/supervdsm exception flow

## Documentation / External references

*   TODO: paste corresponding bugzilla link and gerrit link here

## Comments and Discussion

This below adds a link to the "discussion" tab associated with your page. This provides the ability to have ongoing comments or conversation without bogging down the main feature page

*   Refer to [Talk:Your feature name](Talk:Your feature name)

<Category:Feature> <Category:Vdsm>
