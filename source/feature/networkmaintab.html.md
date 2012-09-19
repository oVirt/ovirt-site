---
title: NetworkMainTab
category: feature
authors: alkaplan, danken, lpeer, moti, msalem, ykaul
wiki_category: Feature
wiki_title: Feature/NetworkMainTab
wiki_revision_count: 107
wiki_last_updated: 2013-03-07
---

# Network Main Tab

### Summary

A sentence or two summarizing what this feature is and what it will do. This information is used for the overall feature summary page for each release. - Adding main tab for Networks. - Adding Networks to the tree. - Adding search strings and queries for Networks.

### Owner

This should link to your home wiki page so we know who you are

*   Name: [ My User](User:MyUser)

Include you email address that you can be reached should people want to contact you about helping with your feature, status is requested, or technical issues need to be resolved

*   Email: <my@email>

### Current status

*   Link to feature page in a specific release. That release may complete the feature, or parts of it. The complete scope of this feature in this release will be described in the release feature page
*   Last updated date: ...

### Detailed Description

### User Experience

<b>Tree</b> <b>Main Tab</b>

      - Columns-
      - Actions-

<b>Sub Tabs</b>

      General-  
      - Feilds- Name, Data Center, Description, VM Network, VLAN tagging, MTU
      Clusters- 
      - Columns- Name, Compatiblity Version, Network Status, Network Assigned, Network Required, Role
      - Actions- 
        Assign/Unassign Network (add mock-up)
      Hosts - (list of hosts the network is attached to one of its nicks)
      - Columns- "Status image", Name, Cluster, Data Center, Status
      - Actions- none
      Virtual Machines- (tree of vms that has at least one vnic attached to the network, under each vm- a list of the vnics attached to the network)
       add print screen
      - Columns- Name (Can be expanded to show a list of the vnics the network is attached to) , IP Address, Network, Status, Uptime
      - Actions- none
      Templates- (tree of templates that has at least one vnic attached to the network, under each template- a list of the vnics attached to the network)
      - Columns- Name (Can be expanded to show a list of the vnics the network is attached to), Status, Cluster, Data Center
      - Actions- none

      Permissions-
      - Columns- User, Role, Inherited Permission
      - Actions- Add, Remove

# Search

# Queries

### Benefit to oVirt

What is the benefit to the oVirt project? If this is a major capability update, what has changed? If this is a new feature, what capabilities does it bring? Why will oVirt become a better distribution or project because of this feature?

### Dependencies / Related Features

What other packages depend on this package? Are there changes outside the developers' control on which completion of this feature depends? In other words, completion of another feature owned by someone else and might cause you to not be able to finish on time or that you would need to coordinate? Other Features that might get affected by this feature?

### Documentation / External references

Is there upstream documentation on this feature, or notes you have written yourself? Link to that material here so other interested developers can get involved. Links to RFEs.

### Comments and Discussion

This below adds a link to the "discussion" tab associated with your page. This provides the ability to have ongoing comments or conversation without bogging down the main feature page

*   Refer to [Talk:Your feature name](Talk:Your feature name)

<Category:Feature> <Category:Template>
