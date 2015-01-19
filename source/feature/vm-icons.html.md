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
*   Last updated on 2015-1-19 by [Jakub Niedermertl](User:jniederm)
*   Target release: 3.6

### Description

User can optionally add arbitrary image (limited in dimensions, size, and format) - icon - to VM and Template entities. Icons are stored in 'vm_static' database table. If the icon is set, it is used instead of generic graphic in Userportal listings.

#### Icon inheritance

*   When new Template is created, it inherits icon from VM it is based on.
*   When new VM is created, it inherits icon from Template it is based on.
*   When new Pool is created, it inherits icon from Template it is based on.
*   When new VM in Pool is created, it inherits icon from Pool it belongs to.

*Inherit* in this section means to initialize the relevant database columns based on ancestor entity. Each entity always shows icon based on data in its database record - after creation of each entity there is no linkage between icons of ancestor and descendant.

#### Pools

*   Similarly to other VM parameters user can't directly edit icon of pool of VMs attached to a Pool. To update icon of a Pool one can create a Template with desired icon and then create new Pool based on that Template, or provided that the Pool is based on latest template version, create new version of base Template with desired icon.
*   When icon of a pool is updated, icons of all attached VMs are also updated to the same icon.

### Design

*   Supported image formats are: jpg, png, gif
*   Maximum dimensions are 150px <small>x</small> 120px (w <small>x</small> h) (based on Userportal > Basic icons)
*   Maximum size is 24kB (limit imposed by IE8)
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
*   'vm_static' table stores VMs, Templates, Pools and Instance types. Content of two aforementioned columns is relevant only for VMs, Templates and Pools.

#### Compatibility issues

Proposed design requires following browser 'HTML5' features:

*   dataURL, IE8 limits content size to 24kB, IE9 full support
*   File API (File and FileReader objects), since IE10

Current minimal supported version of IE:

*   webadmin: 9
*   userportal: 8

Hence the functionality can't be fully implemented for all supported browsers. Proposed solution:

*   Limit the icon size to 24kB. It should be ok for jpg, gif and 'iconic' graphic in png. It can sometimes cause problem for 'photographic' png. This restriction allows to **display** VM Icons on all supported browsers.
*   Implement **editing** of VM Icons only for IE10+ and other browser using differed binding `replace-with` tag. Editing functionality (side tab in dialogs) wouldn't be visible in IE8 and IE9.
*   Flash base polyfill can be later used for IE8 and IE9, e.g. [1](http://html5please.com/#file).

[VM Icon](Category:Feature) [VM Icon](Category:oVirt 3.6 Proposed Feature)
