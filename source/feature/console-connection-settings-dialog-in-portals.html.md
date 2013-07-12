---
title: Console connection settings dialog in portals
category: feature
authors: fkobzik, pstehlik
wiki_category: Feature
wiki_title: Features/Console connection settings dialog in portals
wiki_revision_count: 12
wiki_last_updated: 2013-07-23
---

# Console settings dialog in Webadmin and User Portal

### Owner

*   Name: [Frank Kobzik](User:Fkobzik)
*   Email: <fkobzik@redhat.com>

### Description/status

This feature has these aims:

1.  to extract the console settings dialog from User Portal and use it in Webadmin as well - MERGED
2.  to enhance this dialog with additional options that reflect recently added oVirt features, there are:
    -   [Features/Spice Proxy](Features/Spice Proxy) - MERGED
    -   [Features/Display Address Override](Features/Display Address Override)
    -   [Features/Non plugin console invocation](Features/Non plugin console invocation) - MERGED
    -   [Features/noVNC console](Features/noVNC console), SPICE HTML 5 client

3.  to make use of browser local storage to save configuration of the dialog per-VM - MERGED

### Limitations

*   this feature will not allow changing console type from vnc to spice and vice versa (on running VM) as this affects the VM entity and requires VM restart

### Benefit to oVirt

This feature will allow quick changing of console parameters from frontend.

<Category:Feature>
