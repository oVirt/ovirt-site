---
title: Services Migration Plan
category: infra
authors:
  - dcaroest
  - eedri
---

# Services Migration Plan

## Infra team services migration plan

The Infra team is planning to migrate all services to a new data center lab placed in pheonix, US.
This document will explain the phases for this migration and what and when each phase will include.
The migration is lead by David Caro <dcaro@redhat.com> and Eyal Edri <eedri@redhat.com> from the oVIrt Infra team.

### Phase I: Bringing the lab online

##### Estimated finish date: [DONE]

*   [DONE] Installing 2 nfs storage servers and setting up data mirroring using [DRDB](http://www.drbd.org/),and network bonding between them.
*   [DONE] Setting up the firewall rules to allow maintainance and external access (managed by DC team at Red Hat)
*   [DONE] Installing all hypervisors running fedora 19 (to allow nested virtualization)
*   [DONE] Set up networking for all hosts, including bonding and switch configuration (done by local network team at Red Hat)
*   [DONE] Setting up DNS for all servers, using ovirt.org domain.
*   [DONE] Installing ovirt hosted engine 3.4.Z and running on multiple hypervisors for fail-safe if one hypervisor is down
*   [DONE] Add all hypervisors to the hosted engine
*   [DONE] Add the nfs storage domain to hosted engine
*   [DONE] Create 2 DataCenters: Jenkins & Production (see diagram)
*   [DONE] Setting up DHCP, DNS, PXE via foreman-proxy to allow easy vm spawn and installation of operating systems.
*   [DONE] Test connectivity to other ovirt resources (rackspace, alterway)
*   [DONE] Add all bare-metal servers to foreman/puppet and ensure all authorized infra memebers have ssh access.
*   [DONE] Enure lab layout is documented and updated (including backup of network,fw configuration). Docs [Infra/Phoenix_Lab_Overview](/develop/infra/phoenix-lab-overview.html)

#### Lab Layout

![](/images/wiki/Phx2-ovirt-lab-layout.png)

#### Phase II: Setting up Jenkins DC

##### Estimated finish date: [DONE]

*   [DONE] Setting up a jenkins DC with 5 hypervisors
*   [DONE] Installing jenkins slaves with fedora/centos and starting testing jenkins jobs on them
*   [DONE] Installing nested hosts running feodra/centos and testing automation on them (probably in a different cluster)

#### Phase III: Decommision RACKSPACE

##### Estimated finish date: [DONE]

*   After verifying the new jenkins DC is capabale of running all our jenkins needs for the time being, remove all rackspace vms and stop the contract.

#### Phase IV: Start migration of production servers to production DC

##### Estimated finish date: TBD

*   Migrate production vms from alterway (gradually)
*   Migrate all services from resources.ovirt.org
*   Migrate jenkins server from alterway02 baremetal into production VM.
*   Add the alterway bare metal servers as hypervisors (dc/cluster is TBD)
*   Optional: migrate gerrit server from amazon into production DC

