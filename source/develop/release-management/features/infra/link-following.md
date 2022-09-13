---
title: API Link Following
category: feature
authors: oliel
---

## Feature Name

API Link Following

## Summary

This feature enables oVirt API users to request that the contents of some of the entity's links be returned inline, inside the requested entity.

## Owner

*   Name: Ori Liel (oliel)

*   Email: <oliel@redhat.com>

## Detailed Description

Motivation:

Currently, when there is a need to retrieve multiple related objects from the API, the only option is to retrieve the first one, and then send additional requests to retrieve the related objects. For example, if you need a virtual machine and also the disks and NICs, first you need to send a request like this:

  <code>GET /ovirt-engine/api/vms/123</code>

And then additional requests to get the disk attachments, the disks, and the NICs:

<code>GET /ovirt-engine/api/vms/123/diskattachments</code>

<code>GET /ovirt-engine/api/disks/456</code>

<code>GET /ovirt-engine/api/disks/789</code>

<code>GET /ovirt-engine/api/vms/123/nics</code>

In an environment with high latency this multiplies the time required to retrieve the data. In addition, it means that multiple queries have to be sent to the database to retrieve the data.

To improve these two areas the new <code>follow</code> parameter will be introduced. This parameter will be a list of links that the server should follow and populate. For example, the previous scenario will be solved sending this request:

  <code>GET /ovirt-engine/api/vms/123?follow=diskattachments.disks,nics</code>

That will return the virtual machine with the disks and the NICs embedded in the same response, thus avoiding the multiple network round-trips.

The multiple database queries will be avoided only if the server is modified to retrieve that data with more efficient queries. Otherwise the server will use the naive approach of calling itself to retrieve it, which won’t improve the number of queries.

The first step is analyzing the value of follow and using it to fetch the desired hrefs - the actual links to be followed. Single entities contain their href directly inside them (e.g: <code>vm.getCluster().getHref())</code>, and hrefs of sub-collections (e.g: nics, disks) are stored in the links collection (1. vm.getLinks() 2. Find specific link. 3.link.getHref()). This division exists for historic reasons.

This requires the value <code>cluster</code> from <code>follow=cluster,...</code> to be translated to: <code>vm.getCluster()</code>. This is done by string manipulation. Ideally, an explicit annotation on the getter method would be used: <code>@Link(name="cluster", method="getter")</code>. However it's impossible to add such an annotation because the generation of business-entities is done by a third-party (the xjc compiler).

The href attribute of the returned entity/entities is used to fetch it/them. This is done by crawling along the API tree to the context where the information can be retrieved.

Crawling along the API tree is done using <code>ServiceTree</code> class, which was enhanced to provide this kind of service (https://gerrit.ovirt.org/#/c/76077/).

After the information has been retrieved it needs to be set in the original entity (for example, <code>vm.setCluster(cluster)</code>. Getting from follow=cluster,... to vm.setCluster() is done by string manipulation, but would ideally be done using an annotation.

All business-logic described above is placed in: <code>follow(ActionableResource entity)</code> in <code>BaseBackendResource</code> - the parent class for all API resources.

This method is transparently invoked. To achieve transparent invocation, generated Jax-rs interfaces were made to include <code>doGet(), doList()</code> methods, and jax-rs <code>@GET</code> annotations was moved to them, making GET requests land there. These methods have a default implementation which invokes <code>follow()</code>:

<code>@GET</code>
<code>default public Host doGet(String id) {</code>
<code>   Host host = get();</code>
<code>   follow(host);</code>
<code>   return host;</code>
<code>}</code>

This <code>follow()</code> method is final, purposely forbidding developers from overriding it. But as part of its flow it invokes another signature of <code>follow()</code>. This method is the entry point for developers who need to add the specific following logic.

For cases like <code>GET ...api/vms?follow="a,b,c"</code>, when developer adds specific logic for following a, his code should include:

<ol>
<li>Check if a exists in follow url parameter.</li>
<li>Follow a and insert results into the vm</li>
<li>Mark a as followed.</li>
</ol>

Example: get VMs with Nics.
• Class: <code>BackendVmsResource</code>
• Override <code>follow( ActionableResource entity, LinksTreenode linksTree )</code>
Decide whether to intervene: <code>Boolean exists = linksTree.pathExists(“nics”)</code>
Run engine query: <code>getBackendCollection(VdcQueryType.GetVmsWithNics). </code>
Map and set data
Mark followed=true: <code>linksTree.markAsFollowed(“nics”)</code>

## Prerequisites

None

## Limitations

The generic solution is naive and costly in terms of performance. Frequent cases requiring link-following should be handled manually (the infrastructure provides an intervention point).

## Benefit to oVirt

This feature saves the need for client-side scripts for following links, and enables running designated queries for common scenarios (e.g: get vms+nics+disks).

## User Experience

Commas separate the links that are to be followed:
<code>GET .../api/vms?follow=nics,disk_attachments</code>

Dots denote levels of depth. Limitless levels of following possible:
<code>GET ...api/vms?follow=disk_attachments.template</code>

Combinations possible:
<code>GET .../api/vms?follow=nics.x, nics.y</code>

