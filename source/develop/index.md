---
title: Joining the developers community
authors:
  - sandrobonazzola
page_classes: community
no_container: true
hide_metadata: true
---
<section class="community_head">

# Joining the developers community

oVirt is a community-driven virtualization project and people just like you are making it happen.
</section>

<section class="container">

## I’m interested - how can I get familiar with oVirt?

You should start by deploying oVirt in a test lab. The minimum configuration needed is a single host or a single VM with at least 16GB of RAM and 4 cores CPU.
On this system you will be able to setup everything needed to run virtual machines (what we call oVirt Host) and the virtualization manager (what we call oVirt Engine)
on top of it within a Virtual Machine (a configuration that we call oVirt Self Hosted Engine).
If you have no spare resources for providing a shared storage, you can configure the system for providing GlusterFS Replica 1 shared file system to be used for your VMs
(a configuration we call Hyperconverged Infrastructure).

Please follow the [user documentation](/documentation/index.html) for deploying your system.

Sign up for the [devel@ovirt.org](https://lists.ovirt.org/archives/list/devel@ovirt.org/) mailing list and send us an email saying how you would like to contribute.
Visit our [mailing lists](https://lists.ovirt.org/archives/) page for other oVirt mailing lists to sign up for.

For fluent, real time communication, you can [join us on IRC](/community/about/contact.html#irc)

Please read our [community etiquette guidelines](/community/about/community-guidelines.html). (Quick summary: Be nice!)

## Exploring the documentation

Skim through the [user documentation](/documentation/index.html) and the [developers documentation](devdocs.html) in order to understand how the system works and can be configured.

Several presentations both on the technical side and on the user side are available on [oVirt Youtube channel](https://www.youtube.com/ovirtproject).

## Joining a team

Within oVirt project several teams are taking care of different aspects of the system.

The [oVirt GitHub issues](https://github.com/issues?q=is%3Aopen+is%3Aissue+user%3Aovirt+archived%3Afalse) are labeled accordingly to identify the main impacted area.

- [Project Infrastructure](infra/infrastructure.html): takes care of the oVirt datacenter and of all the systems and services running within the datacenter such as Jenkins, Gerrit, Apache, ...
- [Integration and Node](integration/index.html): integrates the oVirt subprojects making them work together as a complete solution.
- Infra and Metrics: responsible for Engine/VDSM infra code, shared entities, shared features, API/SDK/CLI and reporting.
- Network: responsible for Integration with Network virtualization providers, Dedicated and user defined networks, and other networking handling.
- Storage: responsible for providing and handling of storage (SDM, import/export, etc).
- Virtualization: responsible for VM lifecycle, System and host level scheduling / SLA
- User Experience: responsible for UI Infra and overall UX consistency.

The teams are discussing their work on [devel@ovirt.org](https://lists.ovirt.org/archives/list/devel@ovirt.org/) mailing list so to join a team
you should start getting involved in these conversations.

## Contributing Code

oVirt is an open-source project composed by several sub projects. Most of them are licensed under the [Apache license version 2.0](https://www.apache.org/licenses/LICENSE-2.0.html)
but please check the license of the subproject you're going to contribute before submitting code.
Contributions of all types are gladly accepted!

If you are looking for some task to pick up, you can ask for it on [devel@ovirt.org](https://lists.ovirt.org/archives/list/devel@ovirt.org/) mailing list.
As an alternative you can look at open tickets on [oVirt GitHub issues](https://github.com/issues?q=is%3Aopen+is%3Aissue+user%3Aovirt+archived%3Afalse) and once you choose what to work on
please comment on the ticket you are looking into it. If the ticket has already an assignee, please get in touch with the assignee before starting to work on the ticket.

Before writing any code, please check the subproject coding standards in the README file. If there is no mention about coding standards, try to follow
the coding style used within the subproject existing sources.

You can find us on both our mailing list and IRC if you run into trouble when selecting issues or setting up your development environment or if you have questions.

## Setting up a development environment

Each subproject should have instructions on how to setup your development environment to be able to develop and test your changes.
If you don't find adequate documentation and you need help, please contact us on IRC or on the [devel@ovirt.org](https://lists.ovirt.org/archives/list/devel@ovirt.org/) mailing list.

</section>
