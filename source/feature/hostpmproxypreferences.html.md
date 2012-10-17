---
title: HostPMProxyPreferences
category: feature
authors: emesika, simong, yair zaslavsky
wiki_category: Feature
wiki_title: Features/HostPMProxyPreferences
wiki_revision_count: 18
wiki_last_updated: 2012-11-11
---

# Host PM Proxy Preferences

Note this is Work In Progress for now

## Hosts Power Management

### Summary

The Host Power Management feature allows the oVirt engine to remotely control the host power in order to execute the fencing command as part of the high availability features, or allow the user to manually commit remote operations as PowerOff, PowerOn, and Restart.

### Owner

*   Name: [ Simon Grinberg](User:MyUser)

<!-- -->

*   Email: sgrinber@redhat.com

### Current status

The current implementation of the Power Management is focused on supporting the most popular power management device, while the fencing proxi selection is naive, and there is no support for topologies where redundant power supply exists which requires supporting additional power management device.

*   Last updated date:

### Detailed Description

Expand on the summary, if appropriate. A couple sentences suffices to explain the goal, but the more details you can provide the better.

### Benefit to oVirt

What is the benefit to the oVirt project? If this is a major capability update, what has changed? If this is a new feature, what capabilities does it bring? Why will oVirt become a better distribution or project because of this feature?

### Dependencies / Related Features

What other packages depend on this package? Are there changes outside the developers' control on which completion of this feature depends? In other words, completion of another feature owned by someone else and might cause you to not be able to finish on time or that you would need to coordinate? Other Features that might get affected by this feature?

### Documentation / External references

[ <http://h20566.www2.hp.com/portal/site/hpsc/public/kb/docDisplay/?docId=emr_na-c02510164&ac.admitted=1350494275400.876444892.199480143> Example from HP for redundant power supply with separate management - see Figure II]

### Comments and Discussion

This below adds a link to the "discussion" tab associated with your page. This provides the ability to have ongoing comments or conversation without bogging down the main feature page

*   Refer to [Talk:Your feature name](Talk:Your feature name)

<Category:Feature> <Category:Template>
