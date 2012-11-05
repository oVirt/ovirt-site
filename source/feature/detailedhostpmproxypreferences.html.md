---
title: DetailedHostPMProxyPreferences
category: feature
authors: emesika, yair zaslavsky
wiki_category: Feature
wiki_title: Features/Design/DetailedHostPMProxyPreferences
wiki_revision_count: 81
wiki_last_updated: 2014-04-08
wiki_warnings: list-item?
---

# Detailed Host PM Proxy Preferences

## Host Power Management Proxy Preferences

### Summary

### Owner

*   Feature owner: [ Eli Mesika](User:emesika)

    * GUI Component owner: [ Eli Mesika](User:emesika)

    * REST Component owner: [ Eli Mesika](User:emesika)

    * Engine Component owner: [ Eli Mesika](User:emesika)

    * QA Owner: [ Yaniv Kaul](User:ykaul)

*   Email: emesika@redhat.com

### Current status

*   Target Release: 3.2
*   Status: Design
*   Last updated date: Nov 4 2012

### Detailed Description

### CRUD

Adding a pm_proxy_preferences column to vds_static table.
this column represents a comma separated proxy preferences lists per Host
The default value for this column will be : 'engine,cluster,dc'
So, if this value is for example the default value, a Host that is in non-responsive state and has Power Management configured will be fenced using first the engine then the first UP Host in Cluster then the first UP Host in the Data Center.

#### Metadata

Adding test for the new pm_proxy_preferences field in VdsStaticDAOTest
Adding test data in fixtures.xml

### Business Logic

#### Flow

### User Experience

### Installation/Upgrade

#### User work-flows

### Enforcement

### Dependencies / Related Features and Projects

#### Affected oVirt projects

### Documentation / External references

[Features/HostPMProxyPreferences](Features/HostPMProxyPreferences)

### Open Issues

[Category: Feature](Category: Feature)
