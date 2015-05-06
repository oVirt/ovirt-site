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
feature_status: Implementation
---

# VM Icons

### Summary

It allows users to add icon to VMs and Templates in order to customize the appearance of these entities in userportal.

### Owner

*   Name: [Jakub Niedermertl](User:jniederm)
*   Email: <jniederm@redhat.com>

### Description

User can optionally add arbitrary image (limited in dimensions, size, and format) - icon - to VM and Template entities. Icons are stored in new separate DB table 'vm_icons'. Rows of this table are referenced from 'vm_static' table.

Currently used default icons (assigned according to OS) will also be stored in 'vm_icons' table. Thus this system fully replace current approach of storing and providing icons - GWT ClientBundles and ImageResources.

Each icon is stored in two sizes:

*   Large, 150x120 px, used in basic userportal
*   Small, 43x43 px, used in mostly in extended userportal

User can only upload the large version of custom icon, the small one is computed during store procedure.

#### Icon inheritance

*   When new Template is created, it inherits icon from VM it is based on.
*   When new VM is created, it inherits icon from Template it is based on.
*   When new Pool is created, it inherits icon from Template it is based on.
*   When new VM in Pool is created, it inherits icon from Pool it belongs to.

#### Pools

*   Similarly to other VM parameters user can't directly edit icon of pool or icons of VMs attached to a Pool. To update icon of a Pool one can create a Template with desired icon and then create new Pool based on that Template, or provided that the Pool is based on latest template version, create new version of base Template with desired icon.
*   When icon of a pool is updated, icons of all attached VMs are also updated to the same icon.

#### Default Icons

*   Default icons are assigned based on operating system.
*   'vm_icon_defaults' database table maps operating system IDs to icon IDs
*   'vm_icon_defaults' table and default icons are updated during each engine startup according to '/usr/share/ovirt-engine/conf/osinfo-defaults.properties' file and '/user/share/ovirt-engine/icons/small,large' directories.

### Design

*   Supported image formats are: jpg, png, gif
*   Maximum dimensions are 150px <small>x</small> 120px (w <small>x</small> h) (based on Userportal > Basic icons)
*   Maximum size is 24kB (limit imposed by IE8)
*   Icons are transferred and stored in dataUrl format.
*   Icons are cached in browser based on their UUIDs in order to save network resources during listing updates.
*   Icons are stored in separate database table. Each image is stored at most once.

#### UI

*   Show icons in Userportal > Basic, Userpotal > Extended > Virtual Machines, Templates.
*   Add icon editing and validating tab to 'New VM', 'Edit VM' and 'Edit Template', 'New Pool' dialogs.
*   Create per-session cache of Icons: Map<Guid, String> iconUuid -> icon

#### Backend

*   Extend commands saving VMs and templates to be able to validate and store icon reference. It should validate that old icon, if custom (user defined), is still reference by other row or delete unused custom icon.
*   Create new command to validate and store a new icon.
*   Create new query to fetch map [guid->icon] by list of icon guids.
*   Extend model VmBase by `Guid smallIconId` and `Guid LargeIconId`.
*   Create new business entities corresponding to 'vm_icons' and 'vm_icon_defaults' database tables.

#### Database

![Database schema](vm_icons_db.png "Database schema")

#### REST API

*   `/api/icons` read-only top level collection of all icons
*   `/api/icons/{id}` provides an object corresponding to VmIcon business entity
*   entities at `/api/vms/{id}` and `/api/templates/{id}` contains properties `small_icon_id` and `large_icon_id` that provide icon IDs and can be resolved using top level `/api/icons` collection
*   org.ovirt.engine.api.model.VmBase entity contains `vmLargeIcon` property corresponding to org.ovirt.engine.core.common.action.VmManagementParametersBase#vmLargeIcon that allows to update icon in [dataUrl](http://en.wikipedia.org/wiki/Data_URI_scheme) form. Similarly to WebAdmin/UserPorlal UI, there is no direct way to add, update, delete icon itself.

#### Compatibility issues

Proposed design requires following browser 'HTML5' features:

*   dataURL, IE8 limits content size to 24kB, IE9 full support
*   File API (File and FileReader objects), since IE10

Current minimal supported version of IE:

*   webadmin: 9
*   userportal: 8

Hence the functionality can't be fully implemented for all supported browsers. Proposed solution:

*   Limit the icon size to 24kB. It should be ok for jpg, gif and 'iconic' graphic in png. It can sometimes cause problem for 'photographic' png. This restriction allows to **display** VM Icons on all supported browsers. Canvas based automatic resize and png -> jpg conversion and be added to help mitigate size limit.
*   Implement **editing** of VM Icons only for IE10+ and other browser using differed binding `replace-with` tag. Editing functionality (side tab in dialogs) wouldn't be visible in IE8 and IE9.
*   Flash base polyfill can be later used for IE8 and IE9, e.g. [1](http://html5please.com/#file).

[VM Icon](Category:Feature) [VM Icon](Category:oVirt 3.6 Proposed Feature)
