---
title: DetailedHostPMMultipleAgents
category: feature
authors: emesika
---

# Detailed Host PM Multiple Agents

## Host Power Management Multiple Agent Support

### Summary

Current implementation assumes that a Host that its Power Management is configured has only one fencing agent from a certain type (i.e. rsa, ilo, apc etc.)
This document describes what should be done in order to support dual-power Hosts in which each power switch may have its own agent or two agents connected to the same power switch.
Agents may be from same or different type
We will treat current Power Management agent as Primary Agent and the added one as Secondary Agent.

### Owner

*   Feature owner: Eli Mesika (emesika)

    * GUI Component owner: Eli Mesika (emesika)

    * REST Component owner: Eli Mesika (emesika)

    * Engine Component owner: Eli Mesika (emesika)

    * QA Owner: Yaniv Kaul (ykaul)

*   Email: emesika@redhat.com

### Current status

*   Target Release: 3.2
*   Status: Design
*   Last updated date: Nov 15 2012

### Detailed Description

There may be two main configurations for Primary/Secondary Agents:
1) Concurrent, when Host is fenced both agents are used concurrently, for Stop command we need both to succeed and for Start command if one succeeded the Host is considered to be UP.
 ![](/images/wiki/Hostdualpower.png)
 2) Sequential, when Host is fenced either for Stop or Start commands, Primary Agent is used, if it fails (after all configured retries) then the Secondary Agent is used.
 ![](/images/wiki/Hostsinglepower.png)

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

### Configuration

Change default configuration FenceStopStatusDelayBetweenRetriesInSec and FenceStartStatusDelayBetweenRetriesInSec to 10 and FenceStopStatusRetries , FenceStartStatusRetries to 18, this will insure we are responding faster to Hosts while it change status.

### Business Logic

Add pm_secondary\* fields to VdsStatic
Add pm_secondary\* fields to VDS
 Changing FenceVdsBaseCommand::executeCommand() to handle all scenarios described in [Flow](#flow)

### API

The REST API will be enhanced to include the multiple Agents definitions as follows
Keep in mind that we should preserve the former syntax for backward compatibility and deprecate it in future
For any case in which we found old flat PM definitions and other definitions inside the agents block, the setting in the agent block will take presence.

` `<power_management type="rsa">
`     `<enabled>`true`</enabled>
           

<address>
ip or fqdn

</address>
`     `<username>`user`</username>
`     `<password>`password`</password>
`      `<options><option value="" name="port"/><option value="false" name="secure"/></options>
`      `<agents>
`        `<agent type="rsa">
                          

<address>
ip or fqdn

</address>
                          `<username>`user`</username>` order="primary"
`                    `<password>`password`</password>
`                    `<options><option value="" name="port"/><option value="false" name="secure"/></options>
`                    `<concurrent>`false`</concurrent>
`                    `<order>`1`</order>
`        `</agent>
`       `<agent type="ipmi">
                          

<address>
ip or fqdn

</address>
                          `<username>`user`</username>` order="primary"
`                    `<password>`password`</password>
`                    `<options><option value="" name="port"/><option value="false" name="secure"/></options>
`                    `<concurrent>`false`</concurrent>
`                    `<order>`2`</order>
`        `</agent>
            ......
`      `</agents>
`   `</power_management>
       

*concurrent* flag will be handled in the Host level
Add custom mapping for these new power-management fields in HostMapper.java, for both REST-->Backend and Backend-->REST directions)

### Flow

**No Secondary Agent**
If no Power Management is defined , the Stop/Start scenarios works without a change. For example, the Restart scenario is:

       Send a Stop command 
       Wait for status 'off' [1]    
       Send a Start command
       Wait for status 'on' [2]

If a secondary agent is defined
 **Sequential**:
 Send a Stop command to Primary agent

       Wait for status 'off' [1]
       If Stop failed 
          Send a Stop command to Secondary agent and wait for status 'off'
       Send a Start command to Primary agent
       Wait for status 'on' [2]
       If Start failed 
          Send a Start command to Secondary agent and wait for status 'on'

**Concurrent**:

       Send a Stop command to Primary and Secondary agents
       Wait for status 'off' on both Primary and Secondary agents[1]
       Send a Start command to Primary and Secondary agents
       Wait for status 'on' on either  Primary or Secondary agent[2]

[1] Controlled by FenceStopStatusDelayBetweenRetriesInSec,FenceStopStatusRetries configuration values
[2] Controlled by FenceStartStatusDelayBetweenRetriesInSec,FenceStartStatusRetries configuration values

### User Experience

A new drop-down box will be added to the Power Management screen that enables selection of Primary/Secondary agents in order to insert agent details and test the agent.
The Concurrent check box controls if the secondary agent works in the concurrent or sequential mode
 ![](/images/wiki/Pmmultiagentscreen.png)

### Installation/Upgrade

Add the new pm_secondary\* columns in the upgrade script.

#### User work-flows

### Enforcement

### Dependencies / Related Features and Projects

#### Affected oVirt projects

[Host Power Management Proxy Preferences](/develop/release-management/features/infra/hostpmproxypreferences.html)

### Documentation / External references

[Features/HostPMMultipleAgents](/develop/release-management/features/infra/hostpmmultipleagents.html)

### Future Directions

For 3.2 we will handle only Primary/Secondary agents
We may add 3rd agent support in future to handle other scenarios
