---
title: OVirt 3.3.4 release notes
category: documentation
authors: dougsland, sandrobonazzola
wiki_category: Documentation
wiki_title: OVirt 3.3.4 release notes
wiki_revision_count: 11
wiki_last_updated: 2014-03-04
---

# OVirt 3.3.4 release notes

## Install / Upgrade from previous versions

## What's New in 3.3.4?

## Known issues

## Bugs fixed

### oVirt Engine

### VDSM

* vdsm: pre-defined range for spice/vnc ports
 - Avoid going into 'Paused' status during long lasting migrations
 - vdsmd not starting on first run since vdsm logs are not included in rpm
 - vdsm: fix RTC offset
 - netinfo.speed: avoid log spam
 - vm: discover volume path from xml definition
 - Removing vdsm-python-cpopen rpm creation from vdsm
 - vm iface statistics: never report negative rates
sos: plugin should ignore /var/run/vdsm/storage

### ovirt-node-plugin-vdsm

* UI: AttributeError("'module' object has no attribute 'configure_logging'",)
 - engine_page: use vdsm to detect mgmt interface
 - engine_page: display url/port only on available

<Category:Documentation> <Category:Releases>
