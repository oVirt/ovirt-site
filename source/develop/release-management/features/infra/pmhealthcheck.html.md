---
title: PMHealthCheck
category: feature
authors: emesika, gchaplik
wiki_category: Feature
wiki_title: Features/PMHealthCheck
wiki_revision_count: 7
wiki_last_updated: 2014-05-04
---

# PM Health Check

## Power Management Health Check

### Summary

### Owner

*   Name: [ Eli Mesika](User:MyUser)
*   Name: [ Arthur Berezin](User:MyUser)

<!-- -->

*   Email: aberezin@redhat.com
*   Email: emesika@redhat.com

### Current status

*   Last updated date: MAY 4, 2014

### Detailed Description

The requirement is to add a periodic health check of all Hosts with configured PM
The scheduled job will try to send a status command to all PM enabled hosts periodically (once a hour by default) and raise alerts for failed operations

### Benefit to oVirt

This feature will improve Host availability since once a Host fails the PM status command, the administrator will see the raised alert and will be able to address the problem ASAP

### Dependencies / Related Features

### Documentation / External references

[RFE](https://bugzilla.redhat.com/show_bug.cgi?id=1090800%20)

### Comments and Discussion

This below adds a link to the "discussion" tab associated with your page. This provides the ability to have ongoing comments or conversation without bogging down the main feature page

*   Refer to [[Talk:PMHealthCheck]

