---
title: DetailedHostPMMultipleAgents
category: feature
authors: emesika
wiki_category: Feature
wiki_title: Features/Design/DetailedHostPMMultipleAgents
wiki_revision_count: 35
wiki_last_updated: 2012-12-25
wiki_warnings: list-item?
---

# Detailed Host PM Multiple Agents

## Host Power Management Multiple Agent Support

### Summary

Current implementation assumes that a Host that its Power Management is configured has only one fencing agent from a certain type (i.e. rsa, ilo, apc etc.)
This document describes what should be done in order to support dual-power Hosts in which each power switch may have its own agent (may be from same or different type)
We will treat current Power Management agent as Primary Agent and the added one as Secondary Agent.

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
*   Last updated date: Nov 15 2012

### Detailed Description

There may be two main configurations for Primary/Secondary Agents:
1) Concurrent, when Host is fenced both agents are used concurrently, for Stop command we need both to succeed and for Start command if one succeeded the Host is considered to be UP.
2) Sequential, when Host is fenced either for Stop or Start commands, Primary Agent is used, if it fails (after all configured retries) then the Secondary Agent is used.

### CRUD

Adding the following columns to vds_static:

      pm_secondary_ip
      pm_secondary_options
      pm_secondary_port
      pm_secondary_password
      pm_secondary_user
      pm_secondary_type

Views:
 vds (adding all pm_secondary\* fields)

      vds_with_tags (adding all pm_secondary* fields)
      dwh_host_configuration_history_view (adding only pm_secondary_ip)
      dwh_host_configuration_full_check_view (adding only pm_secondary_ip)

Stored Procedures:
 InsertVdsStatic

      UpdateVdsStatic
      InsertVds

#### DAO

Adding handling of pm_secondary\* fields to
VdsStaticDAODbFacadeImpl
VdsDAODbFacadeImpl

#### Metadata

Adding test data for VdsStaticDAOTest & fixtures.xml

### Business Logic

#### Flow

### User Experience

### Installation/Upgrade

#### User work-flows

### Enforcement

### Dependencies / Related Features and Projects

#### Affected oVirt projects

### Documentation / External references

[Features/HostPMMultipleAgents](Features/HostPMMultipleAgents)

### Open Issues

[Category: Feature](Category: Feature)
