---
title: SPICERelatedFeatures
category: feature
authors: acathrow, danken, ecohen, ovedo
wiki_category: Feature
wiki_title: Features/SPICERelatedFeatures
wiki_revision_count: 43
wiki_last_updated: 2012-06-04
---

[[File:

# SPICE related features

### Summary

This page describes the changes needed in the engine in order to support changes/additions to SPICE client functionality.

### Owner

This should link to your home wiki page so we know who you are

*   Name: [ Oved Ourfali](User:Ovedo)
*   Email: <ovedo@redhat.com>

### Current status

*   In design phase
*   Last updated date: February 6th, 2012.

### Detailed Description

In the upcoming version, SPICE is about to perform the following changes/additions:

1.  New SPICE client: virt-viewer
2.  Native USB support
    -   In previous versions, the USB support was based on Incentives Pro (which requires special guest utils to be installed on the guest). Today, a support for USB redirect is being added.
    -   This option will only be supported in the virt-viewer client

3.  Change multiple monitor support on RHEL
    -   Instead of supporting multiple monitor support by adding several display devices, it will be done using one device, with a number of available monitors

4.  WAN support - there are several protocol options that are useful when connecting using SPICE via WAN (compression options, display options, etc.)

### Implementation Details

1.  Change multiple monitor support on RHEL
    -   UserPortal changes
        -   Enable using multiple monitors on RHEL (it is disabled today)
    -   VDSM changes
        -   Pass libvirt the number of monitors using the "heads" property in the display device on the libvirt domain.xml file
    -   Engine-core changes
        -   Support the use of multiple monitors on a single device only in cluster level 3.1+. Lower cluster levels will use multiple devices.
    -   UserPortal/webadmin changes
        -   Allow setting multiple monitors to RHEL guests

2.  WAN Support
    -   In the protocol options in the User Portal, we should add the following options:
        -   Network mode:
            -   auto-detect (default)
            -   LAN
            -   WAN
        -   Compression mode:
            -   loci or not
    -   Should we persist these options per VM?

#### virt-viewer support

At first phase, both SPICEC and the virt-viewer will work side by side. Some features, such as native USB support, will only be supported when using the new virt-viewer client. So, in order to support working with both clients side by side, working with the client that we need in order to get the required capabilities, we need to do the following:

*   In the UserPortal, identify which clients are installed
*   For each client
    -   Get the client version
    -   Get the client capabilities (start with Native USB support, IncentivesPro USB support, WAN support, but in the future we might have more capabilities)
*   Work with either SPICEC and virt-viewer, per-VM
*   If virt-viewer is installed, work with it by default, unless there is a need get IncentivesPro USB support
*   If we need IncentivesPro USB support, and SPICEC is not installed, give the user a proper error message
*   Show the protocol options according to the client type - now the only change is that the WAN options should be displayed only when working with virt-viewer

### Benefit to oVirt

Integrating with new SPICE capabilities will ease the user work in the oVirt environment.

### Dependencies / Related Features

1. Fully functional and supported virt-viewer

### Comments and Discussion

Issues/Questions:

*   Is server-side filtering support needed?
*   USB support - today it is only on desktops. Should it be supported on servers as well?
*   Should we persist these options per VM?
*   Today we have all the API needed to pass the number of monitors. Are there any other flags needed for that feature (like amount of memory per-monitor)? If so, we will need to extend the API to support that.
*   Installation/Packaging - will we package and install virt-viewer, or is that the responsibility of the user?

<Category:Feature> <Category:Template>
