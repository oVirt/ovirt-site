---
title: HostBiosInfo
category: feature
authors: jrankin, ybronhei
wiki_category: Feature
wiki_title: Features/Design/HostBiosInfo
wiki_revision_count: 29
wiki_last_updated: 2012-12-24
---

# Host's Bios Information

### Summary

When assigning new host to RHEV-M the engine gets general information about the host. This information includes Vdsm version, CPU units and more. This article describes the bios information that the host provides to RHEV-M, as describing in the following bug ticket: [bz867543](https://bugzilla.redhat.com/show_bug.cgi?id=867543)

### Owner

*   Name: [ Yaniv Bronhaim](User:ybronhei)

<!-- -->

*   Email: ybronhei@redhat.com

### Current status

*   Target Release: 3.1
*   Status: Work in progress
*   Last updated date: Nov 20 2012

### Detailed Description

The following feature allows the portal to present host's bios information when adding new RHEV-H.
This information is taken by using dmidecode command, this command runs with root permissions over the host and returns the information throw getCapabilities API method. This adds the following data:
 1. Host Manufacturer - Manufacturer of the host's machine and bios' vendor (e.g LENOVO)

      2. Host Version - For each host the manufacturer gives a unique name (e.g. Lenovo T420s)
      3. Host Product Name - ID of the product - same for all similar products (e.g 4174BH4)
      4. Host UUID - Unique ID for each host (e.g E03DD601-5219-11CB-BB3F-892313086897)
      5. Host Family - Type of host's CPU - (e.g Core i5)
      6. Host Serial Number - Unique ID for host's chassis (e.g R9M4N4G)

Of course we can add more information in the future on request.

#### User Experience

Under Hosts tab we have general information about the chosen host. In this tab you get general information that retrieved from the host: ![](General-tab.jpeg "fig:General-tab.jpeg")
This feature adds to this tab the following fields:
![](Bios.jpeg "fig:Bios.jpeg")

#### Engine Flows

When gathering host's capabilities we receive host's bios details by VDSM API. This information is written to the database and updated every time the host returns different response. Usually bios information stays constant. Because host capabilities are filled with dynamic data, also here we keep the dynamic flow. Engine requests are sent every refresh and update the database if needed.

#### REST API

#### Engine API

#### Model

##### Error codes

#### VDSM API

No change.

#### Events

### Dependencies / Related Features and Projects

### Comments and Discussion

### Open Issues

NA

<Category:Feature>
