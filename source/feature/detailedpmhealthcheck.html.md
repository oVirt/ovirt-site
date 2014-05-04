---
title: DetailedPMHealthCheck
category: feature
authors: emesika, gchaplik
wiki_category: Feature
wiki_title: Features/Design/DetailedPMHealthCheck
wiki_revision_count: 25
wiki_last_updated: 2014-05-04
---

# Detailed PM Health Check

## Power Management Health Check

### Summary

The requirement is to add a periodic health check of all Hosts with confifigured PM
The schedulted job will try to send a status command to all PM enabled hosts periodically (once a hour by default) and raise alerts for failed operations

### Owner

Feature owner: [ Eli Mesika](User:emesika)
Engine Component owner: [ Eli Mesika](User:emesika)
QA Owner: [ Pavel Stehlik](User:pstehlik)
Email: emesika@redhat.com

### Current status

*   Target Release: 3.5
*   Status: Design
*   Last updated date: MAY 3 2014

### Detailed Description

Add a class PmHealtCheckManager to handle the schedualed check
This class will

        Read the related configuration values(see Configuration) and if feature is enabled reads the PMHealtCheckIntervalInSec configurationvariable.
        Create the Quartz job in it initialize() method which will be called from backend::initialize()

### CRUD

N/A

#### DAO

N/A

#### Metadata

N/A

### Configuration

The following configuration variabled will be added to vdc_options

        PMHealthCheckEnabled (boolean, false by default) - Enable/Diable the Pm Health Check scheduled job
        PMHealtCheckIntervalInSec (int, default 3600) - Determines the number of seconds for scheduling the PM Healt Check operation

Those configuration value should be exposed to the engine-config tool.

### Business Logic

#### Flow

### API

N/A

### User Experience

N/A

### Installation/Upgrade

#### User work-flows

### Enforcement

### Dependencies / Related Features and Projects

#### Affected oVirt projects

### Documentation / External references

[Features/PMHealthCheck](Features/PMHealthCheck)

### Future Directions

### Open Issues

[Category: Feature](Category: Feature)
