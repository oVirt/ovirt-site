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
This document describes what should be done in order to support dual-power Hosts in which each power switch may have its own agent or two agents connected to the same power switch.
Agents may be from same or different type
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
 ![](hostdualpower.png "fig:hostdualpower.png")
 2) Sequential, when Host is fenced either for Stop or Start commands, Primary Agent is used, if it fails (after all configured retries) then the Secondary Agent is used.
 ![](hostsinglepower.png "fig:hostsinglepower.png")

### CRUD

Adding the following columns to vds_static:

      pm_secondary_ip
      pm_secondary_options
      pm_secondary_port
      pm_secondary_password
      pm_secondary_user
      pm_secondary_type
      pm_secondary_concurrent

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

Add pm_secondary\* fields to VdsStatic
Add pm_secondary\* fields to VDS
 Changing FenceVdsBaseCommand::executeCommand() to handle all scenarios described in Flow

### API

The REST API will be enhanced to include the new Secondary Agent definitions as follows

` `<power_management type="rsa">
`   `<enabled>`true`</enabled>
         

<address>
ip or fqdn

</address>
`   `&lt;username&gt;`user`</username>
`   `<password>`password`</password>
`    `<options><option value="" name="port"/><option value="false" name="secure"/></options>
` `</power_management>
<power_management type="apc" concurrent="false">
         

<address>
ip or fqdn

</address>
`   `&lt;username&gt;`user`</username>
`   `<password>`password`</password>
`    `<options><option value="" name="port"/><option value="false" name="secure"/></options>
` `</power_management>

### Flow

If no Power Management is defined , the Stop/Start scenarios works without a change. For example, the Restart scenario is:

      Send a Stop command 
       Wait for status 'off' 
         (controlled by FenceStopStatusDelayBetweenRetriesInSec,FenceStopStatusRetries configuration values)
       Send a Start command
       Wait for status 'on' 
         (controlled by FenceStartStatusDelayBetweenRetriesInSec,FenceStartStatusRetries configuration values)

If a secondary agent is defined
 Sequential:
 Send a Stop command to Primary agent

       Wait for status 'off' 
         (controlled by FenceStopStatusDelayBetweenRetriesInSec,FenceStopStatusRetries configuration values)
       If Stop failed Send a Stop command to Secondary agent and wait for status 'off'
       Send a Start command to Primary agent
       Wait for status 'on' 
         (controlled by FenceStartStatusDelayBetweenRetriesInSec,FenceStartStatusRetries configuration values)
       If Start failed Send a Start command to Secondary agent and wait for status 'on'

Concurrent:

       Send a Stop command to Primary and Secondary agents
       Wait for status 'off' on both Primary and Secondary agents
         (controlled by FenceStopStatusDelayBetweenRetriesInSec,FenceStopStatusRetries configuration values)
       Send a Start command to Primary and Secondary agents
       Wait for status 'on' on either  Primary or Secondary agent
         (controlled by FenceStartStatusDelayBetweenRetriesInSec,FenceStartStatusRetries configuration values)

### User Experience

A new radio button will be added to the Power Management screen that enables selection of Primary/Secondary agents in order to insert agent details and test the agent.
The Concurrent check box controls if the secondary agent works in the concurrent or sequential mode
 ![](pmmultiagentscreen.png "fig:pmmultiagentscreen.png")

### Installation/Upgrade

Add the new pm_secondary\* columns in the upgrade script.

#### User work-flows

### Enforcement

### Dependencies / Related Features and Projects

#### Affected oVirt projects

[Host Power Management Proxy Preferences](http://wiki.ovirt.org/wiki/Features/HostPMProxyPreferences)

### Documentation / External references

[Features/HostPMMultipleAgents](Features/HostPMMultipleAgents)

### Open Issues

[Category: Feature](Category: Feature)
