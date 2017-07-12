---
title: Docker Integration
authors: mbetak
---

# Docker Integration (draft)

This page documents the ongoing effort to add support to oVirt for management of docker containers.

The work itself is split in separate **iterations** each adding more functionality, exploring the possibilities along the way.

## Iteration #1

### Overall architecture

First we want to enable to communication with docker registries. This will provide us with source of images that can be run as containers. For each registry we will maintain list of images which will be updated periodically or on user demand (similar to refresh of CDs with ISO domains).

Next we will enable user to define a new **Container** entity which will information such as underlying image, port mappings, resource allocation limits and the command to execute. This is similar to the instance type/instance image relationship.

For actual run of the docker containers we will add additional flag to host in the form of "Docker support". For now this will require manual installation of docker on the host, which will be checked by the VDSM in the capabilities. Later maybe we could add support to otopi to automatically install docker on hosts with "Docker support" checked.

Before a container can be run on a host we need to make sure it contains locally the image - it has issued \`docker pull\`. For this reason the engine will store information about local images per host and will make sure it is cached locally before attempting to run given container on given host. (sending appropriate \`pull\` commands for given image)

For initial PoC we will have two new vdsm verbs **dockerRest** and **dockerCli** enabling quick experimentation using remotely the docker restful api or command line. In later iterations when we the communication between engine and VDSM is more stabilized we can make proper verbs for common operations.

### UI

*   Add new main tab **Containers**, Actions: Run/Stop, New/Edit Container dialog
*   List added docker registries in the **Storage** main tab. -> upon selection list all images in subtab

### Features

*   Add registry
*   List registry's images
*   create/edit container
*   Run/Stop container (specific or any host)

## Iteration #2

*   Run container with replication
*   Enable external container storage via bind-mount (integrated with our existing disks)

## Owners

*   Engine: Martin Betak (Mbetak) <mbetak@redhat.com>
*   VDSM: Martin Polednik (Mpolednik) <mpolednik@redhat.com>
