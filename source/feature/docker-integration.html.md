---
title: Docker Integration
authors: mbetak
wiki_title: Features/Docker Integration
wiki_revision_count: 4
wiki_last_updated: 2014-09-25
---

# Docker Integration (draft)

This page documents the ongoing effort to add support to oVirt for management of docker containers.

The work itself is split in separate **iterations** each adding more functionality, exploring the possibilities along the way.

### Iteration #1

#### Overall architecture

First we want to enable to communication with docker registries. This will provide us with source of images that can be run as containers. For each registry we will maintain list of images which will be updated periodically or on user demand (similar to refresh of CDs with ISO domains).

Next we will enable user to define a new **Container** entity which will information such as underlying image, port mappings, resource allocation limits and the command to execute. This is similar to the instance type/instance image relationship.

### Iteration #2

*   Run container with replication
*   Enable external container storage via bind-mount (integrated with our existing disks)

### Owners

*   Engine: [Martin Betak](User:Mbetak) <mbetak@redhat.com>
*   VDSM: [Martin Polednik](User:Mpolednik) <mpolednik@redhat.com>
