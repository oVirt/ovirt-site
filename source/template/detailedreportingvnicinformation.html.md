---
title: DetailedReportingVnicInformation
category: template
authors: moti
wiki_category: Template
wiki_title: Feature/DetailedReportingVnicInformation
wiki_revision_count: 24
wiki_last_updated: 2012-12-17
---

# Detailed Reporting Vnic Information

## Reporting vNIC implementation reported by Guest Agent Detailed Design

### Summary

The Guest Agent reports the vNic details:

*   IP addresses (both IPv4 and IPv6).
*   vNic internal name

[http://wiki.ovirt.org/wiki/Feature/ReportingVnicImplementation Reporting vNIC implementation reported by Guest Agent Feature Page](http://wiki.ovirt.org/wiki/Feature/ReportingVnicImplementation Reporting vNIC implementation reported by Guest Agent Feature Page)

### Owner

*   Name: Moti Asayag
*   Email: masayag@redhat.com

### Current status

*   Target Release: 3.2
*   Status: Design
*   Last updated date: Nov 12 2012

### Detailed Description

The internal vNic implementation details are reported by VDSM by verbs *getVmStats* and *getAllVmStats*.

         netIfaces = [{'name': 'eth8', 'inet6': ['fe80::21a:4aff:fe16:1ac'], 'inet': ['10.35.17.36'], 'hw': '00:1a:4a:16:01:ac'}, 
                      {'name': 'eth9', 'inet6': ['fe80::21a:4aff:fe16:160','fe80::21a:4aff:fe16:161'], 'inet': ['10.35.1.254'], 'hw': '00:1a:4a:16:01:60'}, 
                      {'name': 'eth7', 'inet6': ['fe80::21a:4aff:fe16:1af'], 'inet': ['10.35.18.69'], 'hw': '00:1a:4a:16:01:af'}]

The vNic device data on the guest includes the interface name, the ipv4 addresses and the ipv6 addresses.

#### Engine Flows

#### VDSM API

*getVmStats* and *getAllVmStats* reports the guest's vnic data.

### Dependencies / Related Features and Projects

### Open Issues

NA

<Category:Template> <Category:Feature>
