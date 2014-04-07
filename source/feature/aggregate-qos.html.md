---
title: aggregate QoS
category: feature
authors: gchaplik
wiki_category: Feature
wiki_title: Features/aggregate QoS
wiki_revision_count: 25
wiki_last_updated: 2014-04-29
---

# Aggregate QoS Objects

### Description

While oVirt is rapidly continues to grow and gather features, it’s important to wrap already existing features with new ones, for better UX reasons. In oVirt 3.5, there are going to be 2 new QoS objects, [CPU limits](http://www.ovirt.org/Features/CPU_SLA) and [blkio limits](http://www.ovirt.org/Features/blkio-support), added to the existing one [network QoS](http://www.ovirt.org/Features/Network_QoS) (since 3.3).

### Owner

Name: [ Gilad Chaplik](User:gchaplik)

Email: <gchaplik@redhat.com>

### Current status

Target Version: 3.5

Status: design

Last updated: ,

### Detailed Description

#### Engine Core

*   Introducing a new name space QoS, IQoS interface, and QoSType (network, cpu, storage).
*   Data Base: extend netwok_qos, rename it to qos, have a type field (QoSType), all other limits wil be added here.

#### RESTful API

*   GET: api/capabilities/<version>/qos_type
*   GET: /api/datacenters/<datacenter_id>/qos #list of qos objects
*   GET: /api/datacenters/<datacenter_id>/qos/<qos_id> #qos object

`   `<qos id=”qos_id”>
`       `<name>`qos_network_object`</name>
             `<data_center href="<datacenter_id>`"/>
`       `<type>`network`</type>
`       `<in..></>
`       `<out..></>
             ….
`   `</qos>

*   [TBD] ulimited: -1/"unlimited" (case insensitive)

NOTE: the qos object will contain all limits from all types.

*   POST/PUT/DELETE methods are trivial.

#### GUI

*   Remove network profile as a main tab.
*   Add a splitter to network profiles subtab, and include permissions sub tab (UX RFE will be opened to enhance ‘splitter subtabs’ l&f).
*   Network QoS sub tab under data centers will be renamed to QoS.
*   QoS sub tab will contain a vertical tab control with 4 values: All, Network, Storage, CPU:

each view will show a separate table including its limit, in All we’ll have a generic limit text, taken from IQoS, and the QoSType.

*   [WiP] mockups to follow.

#### Open Issue - profiles

2 options:

         1) Aggregate profiles: 'vnic_profiles' to change to 'profiles', and include a type field.
         2) Separate flow for each profile.

Currently I'm going on #1 unless justified objections will arise. I perfectly aware of all the implications (even 'permission' wise). There is no need for separate flows (#2), needs just renaming and adding type to each flow (probably permissions will need some thinking, but IMO nothing's serious). will update the wiki once it gets resolved.

<Category:Feature> <Category:SLA>
