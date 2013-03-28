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

### Description

This feature has three main aims:

1.  to extract the console settings dialog from User Portal and use it in Webadmin as well
2.  to enhance this dialog with additional options that reflect recently added oVirt features, there are:
    -   [Features/Spice Proxy](Features/Spice Proxy)
    -   [Features/Display Address Override](Features/Display Address Override)
    -   [Features/Non plugin console invocation](Features/Non plugin console invocation)
    -   noVNC console, SPICE HTML 5 client

3.  to make use of browser local storage to save configuration of the dialog per-VM

### Status

*   extracting console dialog - merged upstream
*   enhancing the dialog
    -   Adding spice proxy - on upstream review
*   make use of local storage - on upstream review

### Limitations

*   the feature will not allow changing console type from vnc to spice and vice versa as this affects the VM entity and requires VM restart

### Benefit to oVirt

This feature will allow quicke changing of console parameters from frontend.

<Category:Feature>
