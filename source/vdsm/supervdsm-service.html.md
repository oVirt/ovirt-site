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

## Normalize vdsm start up process

### Summary

Supervdsm should be responsible for all priviledged operations, but as supervdsm is started by unpriviledged vdsm, vdsm now does some priviledged operations. Aim of this feature is to get vdsm to be a pure unpriviledged process and move all privildged operations to supervdsm.

### Owner

*   Name: [ lvroyce](User:Royce Lv)

<!-- -->

*   Email: <lvroyce@linux.vnet.ibm.com>

### Current status

*   current solution

1.vdsmd.init start vdsm with user “vdsm”
 2.launch supervdsm when it is not running
 2.vdsm tries to call supervdsm
 3.when authentication error, re-launch, others just raise

*   current problem

1. unprivileged vdsm and proxy need to call previleged “sudo launch” and “sudo kill” 2. redundent key between vdsm and supervdsm as they are parent and child 3. vdsm call supervdsm exception flow problems

*   Link to feature page in a specific release. That release may complete the feature, or parts of it. The complete scope of this feature in this release will be described in the release feature page
*   Last updated: ,

### Detailed Description

Expand on the summary, if appropriate. A couple sentences suffices to explain the goal, but the more details you can provide the better.

### Benefit to oVirt

What is the benefit to the oVirt project? If this is a major capability update, what has changed? If this is a new feature, what capabilities does it bring? Why will oVirt become a better distribution or project because of this feature?

### Dependencies / Related Features

What other packages depend on this package? Are there changes outside the developers' control on which completion of this feature depends? In other words, completion of another feature owned by someone else and might cause you to not be able to finish on time or that you would need to coordinate? Other Features that might get affected by this feature?

### Documentation / External references

Is there upstream documentation on this feature, or notes you have written yourself? Link to that material here so other interested developers can get involved. Links to RFEs.

### Comments and Discussion

This below adds a link to the "discussion" tab associated with your page. This provides the ability to have ongoing comments or conversation without bogging down the main feature page

*   Refer to [Talk:Your feature name](Talk:Your feature name)

<Category:Feature> <Category:Vdsm>
