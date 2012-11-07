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

#### DAO

Adding handling of pm_proxy_preferences to
VdsStaticDAODbFacadeImpl
VdsDAODbFacadeImpl

#### Metadata

Adding test for the new pm_proxy_preferences field in VdsStaticDAOTest
Adding test data in fixtures.xml

### Business Logic

Add pmProxyPreferences field to VdsStatic
Add pmProxyPreferences field to VDS
 FencingExecutor::FindVdsToFence
------------------------------------ Apply the logic of searching for the proxy according to the pmProxyPreferences value

#### Flow

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
The list will have by default the entries : engine,cluster and DC
The user may add other Host IPs or FQDNs by typing a value and pressing the ADD button
The user may also use the UP and DOWN buttons to change items order inside the list
 ![](ProxyPreferences.png "fig:ProxyPreferences.png")

### Installation/Upgrade

Add the new pm_proxy_preferences column in the upgrade script.

#### User work-flows

### Enforcement

### Dependencies / Related Features and Projects

#### Affected oVirt projects

### Documentation / External references

[Features/HostPMProxyPreferences](Features/HostPMProxyPreferences)

### Open Issues

Are defaults applied implicitly?
Meaning, if a user modified the PM Proxy Preferences to be for example only : IP1,IP2
Does this means that this is the actual chain and if both IP1 & IP2 fails to serve as proxies the Power Management operation fails?
or, we should say that this actually implies IP1,IP2,engine,cluster,dc implicitly?
In case of that, what should we apply if user set PM Proxy Preferences to be engine,IP1,IP2 ?
Suggestion:
engine,cluster,dc should be applied implicitly and missing definitions from the original default (engine,cluster.dc) will be applied using the same priority
Examples:
engine,IP1,IP2 => engine,IP1,IP2,cluster,dc IP1,dc,IP2 => IP1,dc,IP2,engine,cluster

[Category: Feature](Category: Feature)
