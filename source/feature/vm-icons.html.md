---
title: VM Icons
category: feature
authors: jniederm
wiki_category: Feature|VM Icon
wiki_title: Features/VM Icons
wiki_revision_count: 44
wiki_last_updated: 2015-05-12
feature_name: VM Icons
feature_modules: engine
feature_status: Design
---

# VM Icons

### Summary

It allows users to add icon to VMs and Templates in order to customize the appearance of these entities in userportal.

### Owner

*   Name: [Jakub Niedermertl](User:jniederm)
*   Email: <jniederm@redhat.com>

### Status

*   Design
*   Last updated on 2015-1-14 by [Jakub Niedermertl](User:jniederm)
*   Target release: 3.6

### Description

User can optionally add arbitrary image (limited in dimensions, size, and format) - icon - to VM and Template entities. Icons are stored in 'vm_static' database table. If the icon is set, it is used instead of generic graphic in Userportal listings.

### Design

*   Supported image formats are: jpg, png, gif
*   Maximum dimensions are 150px x 120px (w x h) (based on Userportal > Basic icons)
*   Maximum size is 100kB
*   Icons are transferred and stored in dataUrl format.
*   Icons are cached in browser based on their hashes in order to save network resources during listing updates.

#### UI

*   Show icons in Userportal > Basic, Userpotal > Extended > Virtual Machines, Templates.
*   Add icon editing and validating tab to 'New VM', 'Edit VM' and 'Edit Template' dialogs.
*   Create per-session cache of Icons: Map<String, String> iconHash -> icon

#### Backend

*   Extend commands saving VMs and templates to be able to validate and store icon.
*   Extend queries for fetching VMs and templates by additional parameter to be able to provide either icon and its hash or icon hash only.
*   Create new query to to separately fetch icon of certain `VmBase`d entity.
*   Extend model VmBase by `String icon` property and `String iconHash` property

#### Database

*   New nullable column 'icon' of type 'character varing' in table 'vm_static'
*   New nullable column 'icon_hash' of type 'character' in table 'vm_static'

[VM Icon](Category:Feature) [VM Icon](Category:oVirt 3.6 Proposed Feature)
