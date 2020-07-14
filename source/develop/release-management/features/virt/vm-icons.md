---
title: VM Icons
category: feature
authors: jniederm
feature_name: VM Icons
feature_modules: engine
feature_status: Done
---

# VM Icons

## Summary

It allows users to add icon to VMs and Templates in order to customize the appearance of these entities in userportal.

## Owner

*   Name: Jakub Niedermertl (jniederm)
*   Email: <jniederm@redhat.com>

## Description

User can optionally add arbitrary image (limited in dimensions, size, and format) - icon - to VM and Template entities. Icons are stored in new separate DB table 'vm_icons'. Rows of this table are referenced from 'vm_static' table.

Currently used default icons (assigned according to OS) will also be stored in 'vm_icons' table. Thus this system fully replace current approach of storing and providing icons - GWT ClientBundles and ImageResources.

Each icon is stored in two sizes:

*   Large, 150x120 px, used in basic userportal
*   Small, 43x43 px, used in mostly in extended userportal

User can only upload the large version of custom icon, the small one is computed during store procedure.

### Icon inheritance

*   When new Template is created, it inherits icon from VM it is based on.
*   When new VM is created, it inherits icon from Template it is based on.
*   When new Pool is created, it inherits icon from Template it is based on.
*   When new VM in Pool is created, it inherits icon from Pool it belongs to.

### Pools

*   Similarly to other VM parameters user can't directly edit icon of pool or icons of VMs attached to a Pool. To update icon of a Pool one can create a Template with desired icon and then create new Pool based on that Template, or provided that the Pool is based on latest template version, create new version of base Template with desired icon.
*   When icon of a pool is updated, icons of all attached VMs are also updated to the same icon.

### Default Icons

*   Default icons are assigned based on operating system.
*   'vm_icon_defaults' database table maps operating system IDs to icon IDs
*   'vm_icon_defaults' table and default icons are updated during each engine startup according to '/usr/share/ovirt-engine/conf/osinfo-defaults.properties' file and '/user/share/ovirt-engine/icons/small,large' directories.

## Design

*   Supported image formats are: jpg, png, gif
*   Maximum dimensions are 150px <small>x</small> 120px (w <small>x</small> h) (based on Userportal > Basic icons)
*   Maximum size is 24kB
*   Icons are transferred and stored in dataUrl format.
*   Icons are cached in browser based on their UUIDs in order to save network resources during listing updates.
*   Icons are stored in separate database table. Each image is stored at most once.

### UI

*   Show icons in Userportal > Basic, Userpotal > Extended > Virtual Machines, Templates.
*   Add icon editing and validating tab to 'New VM', 'Edit VM' and 'Edit Template', 'New Pool' dialogs.
*   Create per-session cache of Icons: Map<Guid, String> iconUuid -> icon

### Backend

*   Extend commands saving VMs and templates to be able to validate and store icon reference. It should validate that old icon, if custom (user defined), is still reference by other row or delete unused custom icon.
*   Create new command to validate and store a new icon.
*   Create new query to fetch map [guid->icon] by list of icon guids.
*   Extend model VmBase by `Guid smallIconId` and `Guid LargeIconId`.
*   Create new business entities corresponding to 'vm_icons' and 'vm_icon_defaults' database tables.

### Database

![Database schema](/images/wiki/Vm_icons_db.png "Database schema")

### REST API

*   `/api/icons` read-only top level collection of all icons

      GET /icons
      Accept: application/xml

<icons>
`    `<icon href="/ovirt-engine/api/icons/4905bfca-59a5-4022-ae66-ab7763f33c8f" id="4905bfca-59a5-4022-ae66-ab7763f33c8f">
`        `<media_type>`image/jpeg`</media_type>
`        `<data>`/9j/4AAQSkZJRgABAQEAYABgAAD...`</data>
`    `</icon>
`    `<icon href="/ovirt-engine/api/icons/91386415-dc7f-41db-90c6-e0b8f4f941b2" id="91386415-dc7f-41db-90c6-e0b8f4f941b2">
`        `<media_type>`image/png`</media_type>
`        `<data>`iVBORw...`</data>
`    `</icon>
</icons>

*   `/api/icons/{id}` provides an object corresponding to VmIcon business entity

      GET /icons/4905bfca-59a5-4022-ae66-ab7763f33c8f
      Accept: application/xml

<icon href="/ovirt-engine/api/icons/4905bfca-59a5-4022-ae66-ab7763f33c8f" id="4905bfca-59a5-4022-ae66-ab7763f33c8f">
`    `<media_type>`image/jpeg`</media_type>
`    `<data>`/9j/4AAQSkZJ...`</data>
</icon>

*   entities at `/api/vms/{id}` and `/api/templates/{id}` contains properties `small_icon` and `large_icon` that provides icon IDs that and can be resolved using top level `/api/icons` collection

      GET /api/vms/789
      Accept: application/xml

<vm id="789" href=...>
      ...
`    `<small_icon id="123" href="/icons/123" />
`    `<large_icon id="456" href="/icons/456" />
      ...
</vm>

*   Icons of vm or template can be updated either by uploading new large icon (small icon is automatically computed by shrinking large one) or by setting new id of small, large or both icons. Similar approach can be applied to creation of vms and templates.

      PUG /vms/789
      Content-Type: application/xml
      Accept: application/xml
<vm>
`    `<large_icon>
`        `<media_type>`image/png`</media_type>
`        `<data>`iVBORw0KGgoAAAANSUhEUgAAAJ...`</data>
`    `</large_icon>
          ...
</vm>

<vm id="789" href=...>
`    `<small_icon id="111" href="/icons/111" />
`    `<large_icon id="222" href="/icons/222" />
          ...
</vm>

<hr/>
      PUT /vms/789
      Content-Type: application/xml
      Accept: application/xml
<vm>
`    `<small_icon id="123" />
`    `<large_icon id="456" />
</vm>

<vm id="147" href=...>
`    `<small_icon id="123" href="/icons/123" />
`    `<large_icon id="456" href="/icons/456" />
          ...
</vm>

*   `/api/operationgsystems` and `/api/operationgsystems/{id}` provides information about default icons of operating systems

      GET /operatingsystems
      Accept: application/xml

<operating_systems>
`    `<operating_system href="/operatingsystems/1" id="1">
`        `<name>`windows_xp`</name>
`        `<description>`Windows XP`</description>
`        `<large_icon href="/icons/14f38bb8-4754-4837-b158-e00fd9ec7297" id="14f38bb8-4754-4837-b158-e00fd9ec7297"/>
`        `<small_icon href="/icons/d300a94e-f00b-477f-b040-6763dc7bce0c" id="d300a94e-f00b-477f-b040-6763dc7bce0c"/>
`    `</operating_system>
</operating_systems>

### Compatibility issues

Proposed design requires following browser 'HTML5' features:

*   dataURL, IE8 limits content size to 24kB, IE9 full support
*   File API (File and FileReader objects), since IE10
