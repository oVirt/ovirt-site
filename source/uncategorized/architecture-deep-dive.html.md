---
title: OVirt architecture deep dive
authors: dneary
wiki_title: OVirt architecture deep dive
wiki_revision_count: 5
wiki_last_updated: 2012-07-06
---

# OVirt architecture deep dive

## Overview

The [architecture](architecture) page has lots of relevant information.

A standard oVirt network consists of three things, primarily:

*   One or more nodes, on which we will run virtual machines (VMs)
*   One or more storage nodes, which hold the images and ISOs corresponding to those VMs
*   ovirt-engine running on a server, which we will use to deploy, monitor, move, stop and create VM images
*   Optionally, an identity service, to authenticate users and administrators for ovirt-engine

The nodes are Linux distributions with VDSM and libvirt installed, along with some extra packages to easily enable virtualisation of networking and other system services. The supportedd Linux distributions to date are Fedora 17 or oVirt node, which is basically a stripped-down distribution containing just enough stuff to allow virtualisation.

The storage nodes can use block or file storage, and can be local or remote, accessed via NFS. Storage technologies like Gluster are supported through the POSIXFS storage type. Storage nodes are grouped into storage pools, which can ensure high availability and redundancy. The [Vdsm Storage Terminology](Vdsm Storage Terminology) page has more details.

oVirt engine is a JBoss-based Java application (previously C#) which runs as a web service. This service talks directly to VDSM on the engine nodes to deploy, start, stop, migrate and monitor VMs, and it can also create new images on storage from templates.

## oVirt node

## oVirt engine

## Accessing guests

## Storage

## Reports and history

<Category:Documentation>
