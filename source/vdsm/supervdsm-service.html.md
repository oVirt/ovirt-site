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

*   new proposal A:

1.  vdsmd.init starts vdsm as root
2.  vdsm forks supervdsm server and then drop privilege
3.  when vdsm exit, supervdsm probe vdsm heart beat stop and exit
4.  vdsm call supervdsm may discover supervdsm server exit, vdsm will exit itself and restart

*   new proposal B:

1.  vdsmd.init starts supervdsm as root
2.  supervdsm forks vdsm

## Exception flows to consider

*   supervdsm server process has 3 parts:

1.  main thread
2.  supervdsm server thread(the one starts supervdsmServer manager)
3.  keep alive thread(let's assume this simple function will not cause exceptions)

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

## Benefit to oVirt

What is the benefit to the oVirt project? If this is a major capability update, what has changed? If this is a new feature, what capabilities does it bring? Why will oVirt become a better distribution or project because of this feature?

## Dependencies / Related Features

What other packages depend on this package? Are there changes outside the developers' control on which completion of this feature depends? In other words, completion of another feature owned by someone else and might cause you to not be able to finish on time or that you would need to coordinate? Other Features that might get affected by this feature?

## Documentation / External references

Is there upstream documentation on this feature, or notes you have written yourself? Link to that material here so other interested developers can get involved. Links to RFEs.

## Comments and Discussion

This below adds a link to the "discussion" tab associated with your page. This provides the ability to have ongoing comments or conversation without bogging down the main feature page

*   Refer to [Talk:Your feature name](Talk:Your feature name)

<Category:Feature> <Category:Vdsm>
