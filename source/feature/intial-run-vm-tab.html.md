---
title: Intial Run Vm tab
category: feature
authors: jbiddle, roy
wiki_category: Feature
wiki_title: Features/Intial Run Vm tab
wiki_revision_count: 5
wiki_last_updated: 2013-07-09
---

# Intial Run Vm tab

### Summary

Initial Run is a replacment for sysprep tab. It contains OS independent properties as well as specific one's like the current "Domain" for Windows sysprep tool.

### Owner

This should link to your home wiki page so we know who you are

*   Name: [ rgolan](User:rgolan)

<!-- -->

*   Email: <rgolan@redhat.com>

### Current status

in code review...

### Detailed Description

This feature emereged from the need to set the HW clock for non-windows machine in the first time the VM runs and store it in templates and their instances.
To do so we must use the Timezone offset from GMT in seconds and send it to VDSM:

<clock offset="variable" adjustment="-3600">
`  `<timer name="rtc" tickpolicy="catchup">
</clock>

### Benefit to oVirt

First an admin can set a VM with a desired clock offset, make a template from it and each VM created from that templte will have its clock set already. Second we would be able to use future sysprep for linux.

### Screenshot

<file:initial-run-tab.png>

### Comments and Discussion

This below adds a link to the "discussion" tab associated with your page. This provides the ability to have ongoing comments or conversation without bogging down the main feature page

*   Refer to [Talk:Intial Run Vm tab](Talk:Intial Run Vm tab)

<Category:Feature> <Category:Template>
