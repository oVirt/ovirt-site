---
title: Services Migration Plan
category: infra
authors: dcaroest, eedri
wiki_category: Infrastructure
wiki_title: Infra/Services Migration Plan
wiki_revision_count: 24
wiki_last_updated: 2014-11-20
---

# Services Migration Plan

## Infra team services migration plan

The Infra team is planning to migrate all services to a new data center lab placed in pheonix, US. This document will explain the phases for this migration and what and when each phase will include.

### Phase I: Bringing the lab online

### Estimated Date: 11/08/14

*   Installing 2 nfs storage servers and setting up data mirroring using [DRDB](http://www.drbd.org/), and bonding between
*   Setting up the firewall rules to allow maintainance and external access (managed by DC team at Red Hat)
*   Installing all hypervisors running fedora 19 (to allow nested virtualization)
*   Set up networking for all hosts, including bonding and switch configuration (done by local network team at Red Hat)
*   Setting up dns for all servers, using ovirt.org domain.
*   Installing ovirt hosted engine 3.4.Z and running on multiple hypervisors for fail-safe if one hypervisor is down
*   Add all hypervisors to hosted engine
*   Add storage domain to hosted engine
*   Create 2 DataCenters: Jenkins & Production (see diagram)
*   Setting up DHCP, DNS, PXE via foreman-proxy
*   Test connectivity to other ovirt resources (rackspace, alterway)
*   Add all bare-metal servers to foreman/puppet and ensure all authorized infra memebers have ssh access.
*   Enure lab layout is documented and updated (including backup of network,fw configuration)

#### Phase II: Setting up Jenkins DC

*   Setting up a jenkins DC with 5 hypervisors
*   Installing jenkins slaves with fedora/centos and starting testing jenkins jobs on them
*   Installing nested hosts running feodra/centos and testing automation on them (probably in a different cluster)

#### Phase III: Decommision RACKSPACE

*   After verifying the new jenkins DC is capabale of running all our jenkins needs for the time being, remove all rackspace vms and stop the contract.

#### Phase IV: Start migration of production Servers

*   Migrate vm from alterway
