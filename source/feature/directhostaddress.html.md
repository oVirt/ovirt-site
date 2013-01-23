---
title: DirectHostAddress
category: feature
authors: danken, moti, msalem
wiki_category: Feature
wiki_title: Features/DirectHostAddress
wiki_revision_count: 12
wiki_last_updated: 2013-03-07
wiki_warnings: list-item?
---

# Direct Host Address

------------------------------------------------------------------------

### Summary

The Direct Host Address feature will allow the admin to define a "direct" IP address on a host, for SSH purposes, without necessarily managing this network interface through ovirt.

### Owner

*   Feature owner: [ Muli Salem](User:msalem)

    * Backend Component owner: [ Muli Salem](User:msalem)

    * GUI Component owner: [ ?](User:?)

    * QA Owner: [ ?](User:?)

*   Email: msalem@redhat.com

### Current status

*   Status: Design

### Detailed Description

When adding a host, admin sets the host address. The engine uses this address to manage the host in two ways. The first is via SSH for host installation, and the second is via xml-rpc for any other action. Current behaviour assumes the network interface with the specified address is configured properly in the engine although this may not be the case initially.

The direct IP address will be optional, and when not specified by the admin, it will be set to the same address as the regular host address.

### Design

#### Engine

A new column will be added to the vds_static table:

| Column Name | Column Type  | Null? / Default | Description                  |
|-------------|--------------|-----------------|------------------------------|
| direct_ip  | VARCHAR(255) |                 | the host's direct IP address |

##### API Changes

The tag <direct_address> will be added to the host resource /api/hosts/{host:id}:

`   `<host id="56d6d62f-6af0-4c02-8500-4be041180031">
             ...
             

<address>
10.35.1.160

</address>
             `<direct_address>`10.35.1.162

</address>
             ...
`   `</host>

##### UI Changes

A new textbox named "Direct Address" in both the add and edit host dialogs will be added (in red):

![](addHostEdited.png "addHostEdited.png")

### Open Issues

### Dependencies / Related Features

Affected projects:

*   engine
*   Webadmin

### Documentation / External references

### Comments and Discussion

------------------------------------------------------------------------

<Category:Template> <Category:Feature>
