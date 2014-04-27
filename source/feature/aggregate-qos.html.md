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

Status: development (http://gerrit.ovirt.org/#/q/status:open+project:ovirt-engine+branch:master+topic:aggregate_qos,n,z)

Last updated: ,

### Detailed Description

#### Engine Core

*   Introducing a new name space QoS, IQoS interface, and QoSType (network, cpu, storage).
*   Data Base: extend netwok_qos, rename it to qos, have a type field (QoSType), all other limits wil be added here (sparse matrix).

#### RESTful API

* POST: /ovirt-engine/api/datacenters/{datacenter:id}/qoss; body: qos; response: qos

`   `<qos type="network">
`     `<name>`test_qos`</name>
`     `<inbound_average>`10`</inbound_average>
`     `<inbound_peak>`10`</inbound_peak>
`     `<inbound_burst>`100`</inbound_burst>
`     `<outbound_average>`-1`</outbound_average>
`     `<outbound_peak>`-1`</outbound_peak>
`     `<outbound_burst>`-1`</outbound_burst>
`   `</qos>

* GET: /ovirt-engine/api/datacenters/{datacenter:id}/qoss; response: qoss - DELETE: /ovirt-engine/api/datacenters/{datacenter:id}/qoss/{qos:id}; - GET: /ovirt-engine/api/datacenters/{datacenter:id}/qoss/{qos:id}; response: qos

`   `<qos type="network" href="/ovirt-engine/api/datacenters/00000002-0002-0002-0002-000000000321/qoss/a66577ff-d5f1-40f7-aebb-0b350ad8bb8c" id="a66577ff-d5f1-40f7-aebb-0b350ad8bb8c">
`       `<name>`test2`</name>
`       `<data_center href="/ovirt-engine/api/datacenters/00000002-0002-0002-0002-000000000321" id="00000002-0002-0002-0002-000000000321"/>
`       `<inbound_average>`10`</inbound_average>
`       `<inbound_peak>`10`</inbound_peak>
`       `<inbound_burst>`100`</inbound_burst>
`       `<outbound_average>`-1`</outbound_average>
`       `<outbound_peak>`-1`</outbound_peak>
`       `<outbound_burst>`-1`</outbound_burst>
`   `</qos>

* PUT: /ovirt-engine/api/datacenters/{datacenter:id}/qoss/{qos:id}; body: qos; response: qos

*   ulimited: -1.

NOTE: the qos object will contain all limits from all types.

#### GUI

*   Remove network profile as a main tab.
*   Add a splitter to network profiles subtab, and include permissions sub tab (UX RFE will be opened to enhance ‘splitter subtabs’ l&f).
*   Network QoS sub tab under data centers will be renamed to QoS.
*   QoS sub tab will contain a vertical tab control with 4 values: All, Network, Storage, CPU:

each view will show a separate table including its limit, in All we’ll have a generic limit text, taken from IQoS, and the QoSType.

*   [WiP] mockups to follow.

#### Profiles

Aggregate profiles: 'vnic_profiles' to change to 'profiles', and include a type field (sparse matrix). Same solution as for QoS, reuse all vnicProfiles flows/tests and stability. If will need it, Separating the table is easy.

<Category:Feature> <Category:SLA>
