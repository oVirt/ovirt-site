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

### Summary

This feature has three main aims:

      1. to extract the console settings dialog from User Portal and use it in Webadmin as well
      2. to enhance this dialog with additional options that reflect recently added oVirt features, there are:
       - SPICE proxy
       - display address override
       - non plugin console invocation
       - noVNC console, SPICE HTML 5 client
      3. to clarify and implement saving the state of the dialog to the local storage

### Status

      - extracting console dialog - pending review
      - enhancing the dialog (see summary)
      - make use of local storage

### Detailed description

#### Saving the configuration

REVIEW NEEDED The state of the console dialog will be derived from three things (starting with 1., then 2. [if 1. is not set] etc.):

      1. per-vm state
      2. (per-cluster state (or DC))
      3. default state - the current implementation

Currently the state of dialog is not persisted - it doesn't survive the page refresh.

There are differencies between Webadmin and User Portal - whereas WA stores console related things in VmListModel, UP stores it in it's item model (UserPortalItemModel). vszocs suggested unifying this so that the data is saved in list models (VmListModel in WA, IUserPortalListModel), but I don't think we have the resources for it now.

#### Dialog buttons

The dialog will contain three buttons on the bottom:

      - OK - saves the state of the dialog for selected VM
      - Cancel
      - (Save as default - saves the state of the dialog as default for all VMs in corresponding cluster (DC - REVIEW NEEDED))

### Limitations

      - the feature will not allow changing console type from vnc to spice and vice versa - as this affects the VM entity and requires VM restart

### Benefit to oVirt

This feature will allow comfortable changing of console parameters from frontend.

<Category:Feature>
