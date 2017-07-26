---
title: API Link Following
category: feature
authors: oliel
wiki_category: Feature
wiki_title: API Link Followin
wiki_revision_count: 0
wiki_last_updated: 2017-7-7
feature_name: Link Following
feature_modules: api (engine)
feature_status: Released
---

## Feature Name

API Link Following

## Summary

This features enable Ovirt API users to request that the contents of some of the entity's links be returned inline, in the requested entity.

## Owner

*   Name: Ori Liel (oliel)

*   Email: <oliel@redhat.com>

## Detailed Description

Motivation:

Currently when there is the need to retrieve multiple related objects from the API the only alternative is to retrieve the first one, and then, send additional requests to retrieve the related objects. For example, if you need a virtual machine and also the disks and NICs you need first to send a request like this:

  GET /ovirt-engine/api/vms/123

And then additional requests to get the disk attachments, the disks, and the NICs:

  GET /ovirt-engine/api/vms/123/diskattachments
  GET /ovirt-engine/api/disks/456
  GET /ovirt-engine/api/disks/789
  GET /ovirt-engine/api/vms/123/nics

In an environment with high latency this multiplies the time required to retrieve the data. In addition it also means that multiple queries have to be sent to the database to retrieve the data.

In order to improve in these two areas the new ‘follow’ parameter will be introduced. This parameter will be a list of links that the server should ‘follow’ and populate. For example, the previous scenario will be solved sending this request:

  GET /ovirt-engine/api/vms/123?follow=diskattachments.disks,nics

That will return the virtual machine with the disks and the NICs embedded in the same response, thus avoiding the multiple network round-trips.

The multiple database queries will be avoided only if the server is modified to retrieve that data with more efficient queries, otherwise the server will use the naive approach of calling itself to retrieve it, which won’t improve the number of queries.

The first step is analyzing the value of ‘follow’ and using it to fetch the desired hrefs - the actual links to be followed. Single entities hold their href directly inside them (e.g: vm.getCluster().getHref()), and herfs of sub-collections (e.g: nics, disks) are stored in the ‘links’ collection (1. vm.getLinks() 2. Find specific link. 3.link.getHref()). This division exists for historic reasons.

This requires the value cluster from follow=cluster,... to be translated to: vm.getCluster(). This is done by string manipulation. Ideally an explicit annotation on the getter method would be used: @Link(name="cluster", method="getter"), however it's impossible to add such an annotation, because the generation of business-entities is done by a third-party (the xjc compiler).

The 'href' attribute of the returned entity/entities is used to fetch it/them. This is done by crawling along the API tree to the context where the information can be retrieved. 

Crawling along the API tree is done using ServiceTree class, which was enhanced to provide this kind of service (https://gerrit.ovirt.org/#/c/76077/).

After the information has been retrieved it needs to be set in the original entity (for example, vm.setCluster(cluster). Getting from follow=cluster,... to vm.setCluster() is done by string manipulation, but would ideally be done using an annotation (similarly to ‘get’)

All business-logic described above is placed in: follow(ActionableResource entity) in BaseBackendResource - the parent class for all API ‘resources’.

This method is transparently invoked. To achieve transparent invocation, generated Jax-rs interfaces were made to include doGet(), doList() methods, and jax-rs @GET annotations was moved to them, making GET requests 'land' there. These methods have a default implementation which invokes follow():

@GET
default public Host doGet(String id) {
   Host host = get();
   follow(host);
   return host;
}

This follow() method is final, purposely forbidding developers from overriding it. But as part of its flow it invokes another signature of 'follow'. This method is the entry point for developers who need to add specific following logic.

For cases like GET ...api/vms?follow="a,b,c", when developer adds specific logic for following 'a', his code should include:

Check if ‘a’ exists in follow url parameter.
Follow ‘a’ and insert results into the vm
Mark ‘a’ as followed.

Example: get Vms with Nics.
• Class: BackendVmsResource
• Override follow( ActionableResource entity, LinksTreenode linksTree )
Decide whether to intervene: Boolean exists = linksTree.pathExists(“nics”)
Run engine query: getBackendCollection(VdcQueryType.GetVmsWithNics). 
Map and set data
Mark followed=true: linksTree.markAsFollowed(“nics”)

## Prerequisites

None

## Limitations

The generic solution is naive and costly in terms of performance. Frequent cases requiring link-following should be handled manually (the infrastructure provides an intervention point)

## Benefit to oVirt

This features saves the need from client-side scripts for following links and enables running designated queries for common scenarios (e.g: get vms+nics+disks)

## Entity Description

## CRUD

## User Experience

Commas separate the links that are to be followed:
GET .../api/vms?follow=nics,disk_attachments

Dots denote levels of depth. Limitless levels of following possible:
GET ...api/vms?follow=disk_attachments.template

Combinations possible:
GET .../api/vms?follow=nics.x, nics.y

## Installation/Upgrade

no effect on installation or upgrades

## User work-flows

Common example of usage: get vms+nics+disks:  GET .../api/vms?follow=nics,disk_attachments

## Dependencies and Related Features

no dependencies

