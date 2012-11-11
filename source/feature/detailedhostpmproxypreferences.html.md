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

When Power Management is defined on the Host and the host becomes non-responding , the engine will attempt to restart the Host after a graceful period is passed
The Host non-responding treatment is doing the following actions
 Send a Stop command

        Wait for status 'off' 
          (controlled by FenceStopStatusDelayBetweenRetriesInSec,FenceStopStatusRetries configuration values)
        Send a Start command
        Wait for status 'on' 
          (controlled by FenceStartStatusDelayBetweenRetriesInSec,FenceStartStatusRetries configuration values)

The current implementation of PM proxy selection is based on selection of host from the data center with 'UP' status.
 This implementation is not robust enough, since fence action such as 'RestartVds' which is comprised of two fence actions (stop & start) might be able to complete the first action, but fails to detect a proxy for the second. In some cases the entire DC becomes non-responsive or even stopped. In that case no host on DC could act as a proxy.

This document describes an extension to the current proxy selection algorithm that enables each Host to define its proxy chain as a priority list.

Specifically, the local host may be chosen as a proxy for fencing operations
This may be achieved by installing a full VDSM packages on the local machine by using
[Local VDSM](http://wiki.ovirt.org/wiki/Features/Design/DetailedHostPMProxyPreferences#Local_VDSM)

An alternative to installing a lightweight local VDSM is writing a [Fence Wrapper](http://wiki.ovirt.org/wiki/Features/Design/DetailedHostPMProxyPreferences#Fence_Wrapper)

And finally , we can also implement it by additional [VDSM Instance](http://wiki.ovirt.org/wiki/Features/Design/DetailedHostPMProxyPreferences#VDSM_Instance)

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

Modify views vds and vds_with_tags to include pm_proxy_preferences
Update InsertVdsStatic and UpdateVdsStatic SPs to handle pm_proxy_preferences

#### DAO

Adding handling of pm_proxy_preferences to
VdsStaticDAODbFacadeImpl
VdsDAODbFacadeImpl

#### Metadata

Adding test for the new pm_proxy_preferences field in VdsStaticDAOTest
Adding test data in fixtures.xml

### Configuration

A new configuration value will be added named PROXY_DEFAULT_PREFERENCES , for backward compatibility it will be version dependant:
 For 3.1 - the value will be : DC

       For 3.2 - the value will be : CLUSTER,DC,ENGINE 

### Business Logic

Add pmProxyPreferences field to VdsStatic
Add pmProxyPreferences field to VDS
 FencingExecutor::FindVdsToFence
------------------------------------ Apply the logic of searching for the proxy according to the pmProxyPreferences value

#### Flow

Start/Stop commands are passed to the Host fencing agent via a proxy machine, in this case
The pm_proxy_preferences of the Host that is in non-responding state is examined
for each entry in the comma-separated values for this field we are trying to send the fencing command (Start/Stop) via the proxy
In the case that the proxy is the local engine , a validation phase of checking existence of local running vdsm and installed fence-agents package is issued
The first proxy on the pm_proxy_preferences chain that succeeded to execute the command takes
If all proxies in the pm_proxy_preferences chain fails to execute the fencing operation , an ERROR is written to the log.

### API

The REST API will be enhanced to include the new Proxy Preferences as follows

`  `<host>
`    `<power_management>
`       `<proxies>
`          `<proxy>
                  

<address>
1.1.1.1

</address>
`          `</proxy>
`          `<proxy>
                   

<address>
host.tlv.redhat.com

</address>
`          `</proxy>
`          `<proxy>
`             `<predefined>`engine`</predefined>
`          `</proxy>
`          `<proxy>
`             `<predefined>`cluster`</predefined>
`          `</proxy>
`         `<proxy>
`             `<predefined>`datacenter`</predefined>
`          `</proxy>
`       `</proxies>
`    `</power_management>
` `</host>

To achieve that we should do the following:
in api.xsd (schema) define new elements:
 *proxy* which contains two fields : address and predefined

        `*`proxies`*` which contains a list of proxy

Add enum PreDefinedFenceType {ENGINE,CLUSTER,DATACENTER} in org.ovirt.engine.api.model package
Add PreDefinedFenceType enum to capabilities (BackendCapabilitiesResource)
Add enum validations
Add custom mapping for these new power-management fields in HostMapper.java, for both REST-->Backend and Backend-->REST directions)
Add metadata to rsdl_metadata_v-3.1.yaml

### User Experience

A new list will be added to the Power Management Tab when adding a new Host or modifying existing Host
The list will have by default the entries : ENGINE,CLUSTER and DC (in 3.2)
 The user may also use the UP and DOWN buttons to change items order inside the list(item order = priority)
 Assuming that engine,cluster and datacenter are part of each chain and only priority may changes
See [pre-defined values](http://wiki.ovirt.org/wiki/Features/Design/DetailedHostPMProxyPreferences#Open_Issues) for details.

![](ProxyPreferences.png "ProxyPreferences.png")

### Installation/Upgrade

Add the new pm_proxy_preferences column in the upgrade script.

#### User work-flows

### Enforcement

### Dependencies / Related Features and Projects

#### Affected oVirt projects

[Host Power Management Multiple Agents](http://wiki.ovirt.org/wiki/Features/HostPMMultipleAgents)

### Documentation / External references

[Features/HostPMProxyPreferences](Features/HostPMProxyPreferences)

### Future Directions

The user may add other existing Host IPs or FQDNs by pressing the ADD button, this will open a drop-down list of all available Hosts defined in the Data Center except the currently edited/added Host
 We are skipping that for the first phase since it has complexities when a Host is removed or moved to another Cluster etc.

### Open Issues

#### pre-defined values

Are pre-defined values applied implicitly?
Meaning, if a user modified the PM Proxy Preferences to be for example only : IP1,IP2
Does this means that this is the actual chain and if both IP1 & IP2 fails to serve as proxies the Power Management operation fails?
or, we should say that this actually implies IP1,IP2,engine,cluster,dc implicitly?
In case of that, what should we apply if user set PM Proxy Preferences to be engine,IP1,IP2 ?
Suggestion:
engine,cluster,dc should be applied implicitly and missing definitions from the original default (engine,cluster.dc) will be applied using the same priority
Examples:
engine,IP1,IP2 => engine,IP1,IP2,cluster,dc IP1,dc,IP2 => IP1,dc,IP2,engine,cluster

#### Local VDSM

In the case that engine is selected as a proxy, we may want a separate service (temporary name : local vdm) that will run on the local host and expose only the fencing functionality from VDSM
 This option has major affect on the effort/cost and time-line of this feature since we need to write a new service for that, package it , install it etc.

#### Fence Wrapper

A script or standalone program that will call the fence-agents package scripts directly
An option is to use the separation of fenceAgent.py from API.py as suggested [here](http://gerrit.ovirt.org/#/c/7190/7/vdsm/API.py)
(Invocation in this case from JNA)
In this case we do not need a [Local VDSM](http://wiki.ovirt.org/wiki/Features/Design/DetailedHostPMProxyPreferences#Local_VDSM)

#### VDSM Instance

A separate instance of vdsm, listening on a separate port.

[Category: Feature](Category: Feature)
