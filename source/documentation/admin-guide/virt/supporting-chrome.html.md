---
title: Supporting Chrome
authors: dneary, tjelinek
wiki_title: Supporting Chrome
wiki_revision_count: 2
wiki_last_updated: 2013-02-07
---

# Supporting Chrome

## Chrome Support

### Summary

Currently, the Google Chrome is not the recommended browser to use with ovirt for the following reasons:

*   lack of SPICE/RDP support
*   rendering issues

As both WebAdmin and UserPortal are built using the Google Web Toolkit it is possible to make them work on Google Chrome.

### Lack of RDP/SPICE support

#### SPICE

For opening SPICE console the SPICE xpi/ActiveX plugin is used (xpi for Linux + FF, ActiveX for Windows + IE). There are the following ways how to enable opening the SPICE console from Chrome:

*   enable to use the xpi plugin on Chrome: <http://gerrit.ovirt.org/#/c/9679/>
*   walk around the plugin by opening the SPICE using remote-viewer/MIME binding: <http://gerrit.ovirt.org/#/c/11702/2> and <http://gerrit.ovirt.org/#/c/11703/>
    -   remote-viewer with this support is not yet released even it has a corresponding patch upstream:
*   integrate the HTML5 implementation of SPICE (no work done yet, but will be done soon): <http://www.spice-space.org/page/Html5>

#### RDP

Currently it works on IE >= 7 (because it ships the msrdp.cab plugin).

*   For opening it from chrome, a remote-viewer/MIME binding could be used as well (no work done yet, but will be done soon)
    -   remote-viewer with this support is not yet released even it has a corresponding patch upstream:

#### Rendering Issues

There are several issues with proper rendering of the UI in Chrome but rarely reported:

*   <http://tinyurl.com/b4lbpbo>

### How to Contribute

After finishing and merging the above mentioned patches, the only issues will be the (mostly unknown) rendering ones.

*   so, if you find an issue when using Chrome, please [report it](https://bugzilla.redhat.com/enter_bug.cgi?product=oVirt)
*   Feel free to browse bugzilla for finding such issues and fixing them
