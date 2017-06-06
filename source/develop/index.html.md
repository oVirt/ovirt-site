---
title: Develop
category: developer
authors: dneary, jbrooks, ykaplan, sandrobonazzola
wiki_category: Developer
wiki_title: Develop
wiki_revision_count: 9
wiki_last_updated: 2017-06-01
---


<!-- TODO: [Mikey] Fix this page after content structure is final -->

# Develop
{:.hidden}

<section class="row">

<section class="col-md-4">

## Projects

oVirt is a [collection of projects](/documentation/architecture/architecture/) which work together to provide a complete data center virtualization solution.

ovirt-engine
: oVirt Engine allows you to configure your network, storage, nodes and images. oVirt Engine also provides a command line interface tool (ovirt-engine-cli) and a RESTful API (ovirt-engine-api), including a Python wrapper (ovirt-engine-python-sdk) which allow developers to integrate management functionality into shell scripts of third party applications.

VDSM
: The Virtual Desktop and Server Management daemon runs on oVirt managed nodes, and allows oVirt to remotely deploy, start, stop and monitor virtual machines running on the node.

ovirt-node
: oVirt Node is just enough operating system to run virtual machines. It is also possible to convert a standard Linux distribution into a node which can be managed by ovirt-engine by installing VDSM and other dependencies.

dwh and reports
: The reports and data warehouse components for ovirt-engine are optional, and are packaged and developed separately.

_More information on [oVirt subprojects](/subprojects/)_

</section>


<section class="col-md-4">

## Developer documentation

- [Install nightly snapshot](/develop/dev-process/install-nightly-snapshot/)
- [Building oVirt engine](Building oVirt engine)
- [Testing ovirt-engine patches with Lago](/develop/infra/testing/lago/testing-engine-patches-with-lago/)
- [Building oVirt Node](/develop/projects/node/building/)
- [Building VDSM](/develop/developer-guide/vdsm/developers/)
- [Contributing to the Node project](/develop/projects/node/contributing-to-the-node-project/)
- [Submitting a patch with Gerrit](/develop/dev-process/working-with-gerrit/)
- [The development process](/develop/dev-process/devprocess/)
- [Release management](/develop/release-management/releases/)
- [Getting in contact with the oVirt community](/community/about/contact/)
- [Becoming a maintainer](/develop/dev-process/becoming-a-maintainer/)
- [oVirt architecture](/documentation/architecture/architecture/)
- [Building a custom user portal](/develop/developer-guide/sample-user-portals/)
- [Building oVirt engine DWH](/documentation/how-to/reports/dwh-development-environment/)

</section>


<section class="col-md-4">

## oVirt Architecture

[![oVirt architecture](/images/wiki/Overall-arch.png)](images/wiki/Overall-arch.png)

## oVirt teams

 - [Integration](./projects/project-integration/)
 - [Project Infrastructure](./infra/infrastructure)
 - Data Warehouse
 - Docs
 - Gluster
 - I18N
 - Infra
 - Marketing
 - Network
 - [Node](./projects/node/contributing-to-the-node-project)
 - Release Engineering
 - SLA
 - Storage
 - Spice
 - Virt
 - UX
</section>
</section>
