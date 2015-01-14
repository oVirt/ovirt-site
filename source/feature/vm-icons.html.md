---
title: VM Icons
category: feature
authors: jniederm
wiki_category: Feature|VM Icon
wiki_title: Features/VM Icons
wiki_revision_count: 44
wiki_last_updated: 2015-05-12
---

# VM Icons

### Summary

It allows users to add icon to VMs and Templates in order to customize the appearance of these entities in userportal.

### Owner

*   Name: [Jakub Niedermertl](User:jniederm)
*   Email <jniederm@redhat.com>

### Status

*   Design
*   Last updated on 2015-1-14 by [Jakub Niedermertl](User:jniederm)

### Description

User can optionally add arbitrary image (limited in dimensions, size, and format) - icon - to VM and Template entities. Icons are stored in 'vm_static' database table. If the icon is set, it is used instead of generic graphic in Userportal listings.

### Design

#### UI

*   Show icons in Userportal > Basic, Userpotal > Extended > Virtual Machines, Templates.
*   Add icon editing tab to 'New VM', 'Edit VM' and 'Edit Template' dialogs.

#### Backend

*   New command for storing icon into database.
*   Extend model VmBase by byte[] icon property.

#### Database

*   New nullable column 'icon' of type 'bytea' in table 'vm_static'
