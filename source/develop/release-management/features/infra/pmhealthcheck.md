---
title: PMHealthCheck
category: feature
authors:
  - emesika
  - gchaplik
---

# PM Health Check

## Power Management Health Check

### Summary

### Owner

*   Name: Eli Mesika
*   Email: emesika@redhat.com

<!-- -->

*   Name: Arthur Berezin


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




