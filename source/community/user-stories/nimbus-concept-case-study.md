---
title: Nimbus Concept Case Study
category: community
authors: bproffitt
---

<div class="row">
<div class="col-md-7 col-md-offset-1 pad-sides">
# Nimbus Concept Case Study

"Give me a lever long enough and a fulcrum on which to place it, and I shall move the world." - Archimedes

Archimedes was speaking metaphorically, but even in the most literal sense, the 2nd Century-B.C. Greek scientist had his facts straight: with the simplest tool, one person can accomplish many great feats. We don't often think of software as such a tool, taking it for granted in these modern times. But software can be the great equalizer, enabling a few to do the work of many.

A very clear example of this can be found in the Spanish startup [Nimbus Concept](http://www.nimbusconcept.com/index.html). This two-person company located in Madrid has leveraged the power of open source solutions such as oVirt, OpenStack, and Gluster to deliver some powerful solutions.

According to Technical Manager Eduardo Garcia, Nimbus Concepts is a small consulting company primarily offering open source solutions and advice to small- to medium-sized businesses, supplementing any technical needs they may have, typically with an existing IT department. Most of Nimbus' clientele are in Spain but the also have some small clients in Latin America. While there are just two people on the payroll, Garcia added that they work closely with 3-5 freelancers on a regular basis and also collaborate with larger companies to fulfill the needs of their clients.

## The Discovery of oVirt

Nimbus Concept discovered oVirt about a year ago, looking for a way to manage virtualization infrastructure without going all the way to full-on cloud management.

"Our usage of oVirt is as an alternative to VMware vSphere, with improved personalization and integration capabilities," Garcia explained. "The possibility of doing a easy migration from oVirt to RHEV if the project or client requirements needed the improved support from Red Hat is very reassuring factor for choosing of a solution for clients and projects with a large growing potential."

For Nimbus Concept, the differentiation of oVirt from other virtualization management solutions was both the possibility to do a deep integration with external systems and the integration with existing solutions. For example, Garcia indicated, the possibility exists to integrate [OpenStack's Neutron](https://wiki.openstack.org/wiki/Neutron) as a network provider. The open source nature of the project and the possibility to migrate to RHEV if the client asks for advanced support was also very important to the Nimbus team.

oVirt also enables Garcia and his team to reuse the existing experience they have. Within their skill set is expertise with [KVM](http://www.linux-kvm.org/page/Main_Page), [Open vSwitch](http://openvswitch.org/), [GlusterFS](http://www.gluster.org/), and other technologies that oVirt supports, so it was easy to adopt and understand the oVirt platform.

Given the size of their clients, Nimbus Concept tends to deploy oVirt solutions ranging from three to five nodes, almost all the time using GlusterFS for storage or external enclosures (NFS/iSCSI). In a few cases OpenStack is deployed over oVirt, using nested virtualization and Neutron network integration as the main network layer.

When the Nimbus team integrates oVirt and OpenStack Neutron, they use [Puppet](http://puppetlabs.com/) to deploy and maintain the installation of all bare-metal and virtual systems, so the Puppet installation of the base oVirt nodes and the usage of hosted engine is perfect for some of their projects.

"We also have small hooks for use for monitoring operations inside the system," Garcia said. "We also plan to use the oVirt Reports and dwh to feed other systems in a near future, but we are still studying this part of oVirt, and we only use in an isolated way for now.

"All of our deployments are small scale, located on SME clients that use oVirt to 'replace' VMware deployments when cost is a major/deciding factor," he added.

## Creating a New oVirt Solution

Beyond deploying oVirt directly as a customer solution, Nimbus has also incorporated oVirt inside a product they are developing called OriginStack.

[OriginStack](https://www.youtube.com/watch?v=wikIIH8tLTc) consists of an appliance that integrates hardware, virtualization (oVirt/KVM), private cloud (OpenStack), and support in one integrated package. Nimbus Concept has partnered with an Intel platinum partner, Telecomputer, to offer unified hardware and basic software support, so a client can have a solution that provides an easy way of having a small virtualized infrastructure out of the box that also lets them start the migration of some services to the cloud.

Nimbus Concept provides a pre-deployed and pre-configured oVirt and OpenStack stack with storage ([Glance](http://glance.openstack.org)) and network (Neutron) linked so the user has a ready-to-use system with multiple ways of using computing resources. This can be done wither with a traditional “scale-up” virtualized method, or a “scale-out” cloud method.

"For us, oVirt is a full solution to SME virtualization needs, and piece of open source software that integrates beautifully with the surrounding tools, without reinventing the wheel, but using existing pieces," Garcia stated. oVirt presents the end user with an easy-to-use interface, without giving up a powerful API and integration capabilities, so Nimbus can start small and begin to integrate with existing client infrastructure.

Looking ahead, the capability to use other hypervisors with oVirt apart from KVM would be a much-desired feature for Nimbus Concept. This would enable Nimbus and other users to absorb existing infrastructure and manage it with oVirt more easily. Also, the capability to “expose” oVirt to OpenStack as a computing resource, such as what has been seen in the efforts to create a Nova-oVirt driver, will more tightly integrate oVirt with OpenStack.

</div>
<div class="col-md-4 pad-sides">
<div class="well well-lg">
![](/images/logos/Nimbus.png)

**Company name:** Nimbus Concept
**Location:** Madrid, Spain
**Activity:** Delivery of an open-source cloud solution that incorporates oVirt and OpenStack.
**Founded:** April 2013
**Staff:** 2

</div>
</div>
</div>
