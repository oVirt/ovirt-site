---
title: Detailed OSN Integration
category: detailedfeature
authors: danken, lvernia, mkolesni, moti, mpavlik
wiki_category: DetailedFeature
wiki_title: Features/Detailed OSN Integration
wiki_revision_count: 72
wiki_last_updated: 2014-03-24
---

# Detailed OSN Integration

## Overview

A network provider is an external provider that can provide networking capabilities for consumption by oVirt hosts and/or virtual machines. The network provider has the knowledge about the networks that it manages, and can work autonomously from oVirt. The provider should enable integration on 3 points:

*   Discovery of networks
*   Provisioning of networks
*   Provisioning of virtual NICs on the network

## Network discovery

There should be a way for oVirt to discover what networks are available on the provider. An oVirt user could then decide to import the network as a new one into a data center, or attach it to an existing data center network, marking that the network is also provided by this provider.

Question: Can an imported network be implemented internally, or if it's external network then we don't control it?

## Network provisioning

The network can be exported from oVirt into the network provider, but from that moment on it will be as if the network was discovered from the provider - i.e. if it goes out of sync, that's OK.

## Virtual NIC provisioning

The network provider should be able to provision a virtual NIC's data (name, MAC, etc) on a network that it provides. Currently, we assume that the networks provided by the provider are available on all clusters, but it is possible to have this capability added so that we would be able
