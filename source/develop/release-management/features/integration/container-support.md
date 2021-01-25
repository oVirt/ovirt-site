---
title: Container support
category: feature
authors: fromani
feature_name: Container support
feature_modules: vdsm, engine?
feature_status: Planning
---

# Container support

## Summary

Add containers support to oVirt, to run containers on virtualization hosts, alongside VMs. Support to run containers-inside-VMs, all managed by oVirt is out of scope of this feature.

## Owner

*   Name: Francesco Romani (fromani)

<!-- -->

*   Email: <fromani@redhat.com>

## Detailed Description

The scope of this feature is not to provide a full-fledged container management system, but rather to add run containers alongside VMs.
The container should run seamlessly side to side with plain VMs, leveraging the existing management infrastructure of oVirt Engine.
The Containers will be represented as bare-bones VMs with minimal feature set (e.g. no migrations). The administrator will be able
to use different container runtimes (see below for details).
Future development includes the ability of running containers inside VMs, all managed by oVirt.
Containers and VMs must be created differently and cannot be converted from each other.

## Benefit to oVirt

The ability of running containers will give oVirt greater flexibility, making it possible to leverage transparently the best solution for any given circumstance. Sometimes VMs are the best tool for a job, sometimes containers are, sometimes one can need both at the same time. oVirt could be the most comprehensive solution in this regard. Please note that this feature will not shift the focus of oVirt, which will still be toward VM management.

## Dependencies / Related Features

The feature will be optionally enabled. If Vdsm reports the availability of supported runtime containers, the Engine will allow
the administrator to run container on a given host.
We will not add hard dependency on either Vdsm or oVirt Engine on container runtime support. Supported runtimes will be initially
[rkt](https://github.com/coreos/rkt) and later [runc](https://github.com/opencontainers/runc). See discussion below for details.

## Overview and design goals

This feature should be completely opt-in, should be completely transparent to the other flows and should require minimal changes to the current infrastructure.

### The feature should be opt-in
Vdsm should detect automatically if the host on which runs could run containers using any of the supported runtimes (e.g. rkt or runc).
If so, Vdsm will advertise the capabilities to Engine. Vdsm will use the existing `additionalFeatures` capability.
To the detect the container support, Vdsm will just try to load the [bridge python module](http://github.com/mojaves/convirt),
much like it already does for glusterfs, and will depend on such module for the low-level details. Vdsm will never talk directly to the container runtime,
like it never does to emulators.

### The feature should be completely transparent to the other flows
The main focus of oVirt is managing virtual machines. Container support will be fit in this context and framework. This means that the container support
is always additional and never hurts in any way the ability of an host to run VMs. A container-enabled host will be able to run side-by-side VMs and containers.
Inside the system, a container will be represented like a feature-reduced VMs. For example, migrations will always fail; in a later stage, Engine could
recognize the container "VMs" and just disable the features instead of allowing them and always see them fail.

### The feature should require minimal changes to the current infrastructure
We represent the containers as dumbed down VM, in order to leverage all existing storage, monitoring and networking infrastructures.
In the Engine data model, all the information a container need already fits in the VM representation.
We want to leverage integration with existing networking, monitoring and storage subsystem. A key factor to achieve this goal is the API of
the [bridge python module](http://github.com/mojaves/convirt). This module mimics the libvirt API to cleanly fit in the existing Vdsm.

## Implementation stages

1. Run containers alongside VMs (oVirt 4.0)

2. Better integration in Engine

3. Run containers inside VMs

## Open issues

The following is a list of issues not yet settled

1. Container attributes
Some container runtime requires extra parameters (e.g. executable to run). We will use custom properties for this, but needs to be tested

2. Storage integration
Container run images which should be stored into a Storage Domain. However, oVirt, at least initially, can't provide any facility to create them.
So, container images (e.g. [AppC images](https://github.com/appc) needs to be uploaded into the system.
The fact is that those image should be put into a data domain, but we lack the facility to store them there.
Once the images are into a data domain, the existing flows should work as they do right now for plain raw images on File Storage.

3. Network integration
We want to leverage existing infrastructure. No issues yet, but this was not explored yet.

4. Monitoring integration
No Engine changes. Vdsm will report the stats as the container were VMs. Few stat could be missed, or perhaps faked.

5. Engine UI changes
We will need some UI changes on the create VM flow to select the container runtime.
The container runtime will not be editable once set
Engine will initially allow any VM operation on containers, and the actions will fail once started. See implementation stage 2 for smarter
integration

## Container runtime technologies

*   systemd-nspawn

discarded because its very man page has an early warning:

       Note that even though these security precautions are taken systemd-nspawn is not suitable for secure container setups. Many of the security features may be circumvented and are hence 
       primarily useful to avoid accidental changes to the host system from the container.
       The intended use of this program is debugging and testing as well as building of packages, distributions and software involved with boot and systems management.

*   libvirt-lxc

discarded because in <https://access.redhat.com/articles/1365153> we can read

       The following libvirt-lxc packages are deprecated starting with Red Hat Enterprise Linux 7.1:

*   docker

Summary:

*   + very popular solution
*   - partially duplicates some oVirt infrastructure
*   - overcrowded product space. Should oVirt tackle this?

Discussion: The only concerns about integrating with Docker are the duplication of effort between oVirt and Docker project; furthermore is not clear if oVirt should lean that far (at least initially) from its strong area to chime in an already overcrowded space.

*   runc

Summary:

*   + core infrastructure from docker, the "plumbing" stripped from all docker "porcelaine", as advertiesed on <http://runc.io/>
*   + tools to import/export from docker, albeit in development or planeed
*   + minimizes duplication with oVirt infrastrcture, while retaining most of the strong points of docker
*   - spec and tool still rough, not finalized
*   - more plumbing needed w.r.t docker

Discussion: runc could be the sweet spot, because it provides the strong points of docker, while allowing integration as deeper as we can and want to provide in oVirt. While the ultimate code is probably solid (being runc spun off docker), the docs, tooling and support may be scarce or still volatile.

*   rkt

Summary:

*   TO BE FILLED

Discussion: TO BE FILLED

## Early implementation thoughts

*   Native support or hooks?

To implement container support leveraging hooks seems hard. The main challenge is that a container could (and should) retrofitted into a Vm object, but this object will not have an underlying libvirt Domain, thus will be unknown to libvirt. All the VDSM flows require interaction with libvirt, then all libvirt calls will fail. OTOH, we can add a new Container class which can expose the same Vm API, and do the smartest thing

*   Just replace the underlying domain, or reimplement it in terms of Container needs

This is feasible and could give some benefits (see also below). Currently being evaluated

*   Redesign Vm class

If we add a Container class, which will be related to Vm class, this opens the gate to a possible Vm redesign. We are still committed to do this redesign, but this redesign alone is a gargantuan effort, which must be tackled not by a single developer. We don't believe there is capacity and time to tackle this redesign in the context of this feature. We should instead take every chance to clean up, split up and streamline Vm class along the way, to make as much room as possible for such redesign.

*   Container support gap: supervising daemon

currently libvirtd supervises the VMs, in the context of containers we could need a replacement (runc). We can leverage systemd-run to do this task

*   Container support gap: collecting stats

If we use systemd-run, we could use systemd-cgtop to collect the stats we need. Preliminary analysis shows it should provide all the relevant data

*   Engine support

Changes could be minimal. We expect the first draft to be almost entirely opaque to Engine


## Patches/code

*  [container python module](http://github.com/mojaves/convirt)
*  [Vdsm patches](https://gerrit.ovirt.org/#/q/status:open+project:vdsm+branch:master+topic:container-support)
*  Engine patches: still pending


## Documentation / External references

*   [systemd-nspawn](http://www.freedesktop.org/software/systemd/man/systemd-nspawn.html)
*   [libvirt-lxc](https://libvirt.org/drvlxc.html)
*   [opencontainers (runc)](https://github.com/opencontainers)
*   [docker](https://www.docker.com/)

## Testing

TODO

## Contingency Plan

We add a new optional feature, so there is no negative fallback and no contingency plan, oVirt will just keep working as usual.

## Release Notes



