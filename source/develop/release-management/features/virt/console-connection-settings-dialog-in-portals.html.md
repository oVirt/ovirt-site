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

*   to extract the console settings dialog from User Portal and use it in Webadmin as well - MERGED
*   to enhance this dialog with additional options that reflect recently added oVirt features, there are:
    -   [Features/Spice Proxy](Features/Spice Proxy) - DONE
    -   [Features/Display Address Override](Features/Display Address Override)
    -   [Features/Non plugin console invocation](Features/Non plugin console invocation) - DONE
    -   [Features/noVNC console](Features/noVNC console), [Features/SpiceHTML5](Features/SpiceHTML5) - DONE
*   to make use of browser local storage to save configuration of the dialog per-VM - DONE

### Limitations

*   this feature will not allow changing console type from VNC to SPICE and vice versa (on running VM) as this affects the VM entity and requires VM restart

### Benefit to oVirt

This feature will allow quick changing of console parameters from frontend.

### Testing

#### Mission 1 - Test dialog functionality

*   Create 2 VMs with SPICE and VNC display protocol, run them.
*   Open Console Option dialog for them and then try selecting various combinations of options for the dialog and then connect to VM .

#### Mission 2 - Testing options persistence

*   Open Console Options dialog for a VM
*   Change some options, click OK
*   Refresh the browser window (to reinitialize gwt app)
*   Open Console Options dialog for that VM again
*   Check if previously selected options are selected now.

<Category:Feature>
