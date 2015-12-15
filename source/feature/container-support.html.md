---
title: Container support
category: feature
authors: fromani
wiki_category: Feature
wiki_title: Container support
wiki_revision_count: 6
wiki_last_updated: 2015-12-15
feature_name: Container support
feature_modules: vdsm, engine?
feature_status: Planning
---

# Container support

### Summary

Add containers support to oVirt, to run containers on virtualization hosts, alongside VMs. Support to run containers-inside-VMs, all managed by oVirt is out of scope of this feature.

### Owner

*   Name: [ Francesco Romani](User:fromani)

<!-- -->

*   Email: <fromani@redhat.com>

### Detailed Description

The purpose of this feature is to let oVirt run containers alongside VMs. Future development includes the ability of running containers inside VMs, all managed by oVirt.

### Benefit to oVirt

The ability of running containers will give oVirt greater flexibility, making it possible to leverage transparently the best solution for any given circumstance. Sometimes VMs are the best tool for a job, sometimes containers are, sometimes one can need both at the same time. oVirt could be the most comprehensive solution in this regard.

### Dependencies / Related Features

To be decided. See [here](Container_support#Container_technologies).

### Container technologies

*   systemd-nspawn

discarded because its very man page has an early warning:

       Note that even though these security precautions are taken systemd-nspawn is not suitable for secure container setups. Many of the security features may be circumvented and are hence 
       primarily useful to avoid accidental changes to the host system from the container.
       The intended use of this program is debugging and testing as well as building of packages, distributions and software involved with boot and systems management.

*   libvirt-lxc

discarded because in <https://access.redhat.com/articles/1365153> we can read

       The following libvirt-lxc packages are deprecated starting with Red Hat Enterprise Linux 7.1:

*   docker

Summary:

*   + very popular solution
*   - partially duplicates some oVirt infrastructure
*   - overcrowded product space. Should oVirt tackle this?

Discussion: The only concerns about integrating with Docker are the duplication of effort between oVirt and Docker project; furthermore is not clear if oVirt should lean that far (at least initially) from its strong area to chime in an already overcrowded space.

*   runc

Summary

*   + core infrastructure from docker, the "plumbing" stripped from all docker "porcelaine", as advertiesed on <http://runc.io/>
*   + tools to import/export from docker, albeit in development or planeed
*   + minimizes duplication with oVirt infrastrcture, while retaining most of the strong points of docker
*   - spec and tool still rough, not finalized
*   - more plumbing needed w.r.t docker

Discussion: runc could be the sweet spot, because it provides the strong points of docker, while allowing integration as deeper as we can and want to provide in oVirt. While the ultimate code is probably solid (being runc spun off docker), the docs, tooling and support may be scarce or still volatile.

### Early implementation thoughts

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

### Documentation / External references

*   [systemd-nspawn](http://www.freedesktop.org/software/systemd/man/systemd-nspawn.html)
*   [libvirt-lxc](https://libvirt.org/drvlxc.html)
*   [opencontainers (runc)](https://github.com/opencontainers)
*   [docker](https://www.docker.com/)

### Testing

TODO

### Contingency Plan

We add a new feature, so there is no negative fallback and no contingency plan, oVirt will just keep working as usual.

### Release Notes

### Comments and Discussion

*   Refer to [Talk:Your feature name](Talk:Your feature name)

<Category:Feature>
