---
title: Alter Way case study
category: community
authors: dneary
wiki_category: Community
wiki_title: Alter Way case study
wiki_revision_count: 11
wiki_last_updated: 2013-09-09
---

# Alter Way case study

Interview with Stéphane Vincent, Director of Innovation, Alter Way, with Dave Neary, Red Hat

Translated from French by Dave Neary.

Questions:

*   Can you tell me a little bit about Alter Way?

Alter Way is a French company with four major activities: hosting, which represents 45% of their revenue, services and integration, representing 40%, training, which ac counts for 10%, and finally consulting work, which accounts for the remaining 5%. The company was founded in 2006, has 110 employees, and brought in 11 million Euro in revenue last year.

*   How do you use oVirt?

As a hosting company, we are obviously interested in virtualization as a way to get more from our hardware, and support our clients' needs. We have over 3000 servers, spread over 4 datacenters, so something that can handle the management of VMs across multiple nodes was important to us.

We looked at several hypervisors, and quickly settled on KVM as the hypervisor, and we have used a variety of management applications with it, including Proxmox, Cloudstack and OpenNebula. We also looked at Red Hat Enterprise Virtualization and oVirt and OpenStack. In the end, we settled on oVirt for hosting our public cloud offering, and OpenStack for our private cloud offering.

*   Why did you choose oVirt?

The main selling point was that oVirt allowed us both to scale out across several VMs and to scale up for clients who did not want to rearchitect all of their applications. oVirt allows us to do everything that our clients expect.

In addition, the oVirt community had three major selling points: it has a very active community, and an ambitious technical roadmap with regular releases. In addition, the involvement of companies including Red Hat, Intel, NetApp, Cisco and IBM reassured us that the project would be around for the duration.

The main technical features which we depend on are related to memory ballooning - the ability to scale up the memory available to a VM based on demand. Other features such as CPU pinning, quotas, and network quality of service guarantees are also important to us.

*   How many clients do you have running workloads on oVirt now? How many VMs?

Our cloud offering H2O went into production at the beginning of 2013. At the moment, we have around 300 VMs running on the offering. We expect that to grow in the future.

*   Do you expose the self service User Console to your clients?

We plan to offer self service to our customers in the near future, but for the moment we have been managing our client's needs internally on demand.

*   Are you happy with the help that you have received from the oVirt community?

The oVirt community is one of the main reasons why we decided to go with oVirt. The community is very active, and provides a lot of information about what is happening and what is coming in the next version.

We are also participants in the oVirt community - we have been happy to sponsor some hardware and network bandwidth for some of the project's infrastructure - it's appropriate that oVirt is running part of its infrastructure on oVirt managed VMs, hosted by a company running oVirt in production. In addition, we have produced several videos promoting oVirt and explaining our technical choices and how we use oVirt alongside OpenStack.

*   What features from oVirt 3.3 excite you?

When we chose oVirt, we were looking for convergence between our private cloud offering and our public cloud. The integration with OpenStack's projects, Glance and Neutron, is very exciting for us. The other features we're really looking forward to are the ability to set custom properties on VMs and devices, which will allow greater customization and control, and RAM snapshots, which will capture not only disk state but also in-memory state of VMs at the time of a snapshot.

*   How do you plan to develop your usage of oVirt in the future?

We plan to expand our usage of oVirt. As a service provider, we will respond to our customer's needs, and there are a number of use-cases which oVirt addresses which are not possible in alternative solutions. We are very happy with our choice of oVirt, and we are happy to see that interoperability is a high priority. Moving forward it gives us the flexibility to use the best solution for the problems our clients ask us to address.

## Article form

[Alter Way](//alterway.fr), a French hosting and services company founded in 2006, has been using oVirt in its public cloud offering, [H2O](//h2o.alterway.fr/), since last year. The service graduated from beta in early 2013, and there are already over 300 VMs being managed on the service for clients. We caught up with Stéphane Vincent, Director of Innovation recently to talk about why AlterWay chose oVirt, how they are using it, and what excites them about the 3.3 release.

"We decided early on to standardise on KVM for our hypervisor layer, and evaluated a number of management solutions for it. We looked at OpenNebula, CloudStack, Proxmox, Red Hat Enterprise Virtualization, oVirt and OpenStack. In the end, we settled on oVirt for hosting our public cloud offering, and OpenStack for our private cloud offering," says Stéphane. The main features of oVirt which influenced the decision were "it allowed us to scale up as well as scale out our client workloads. The main technical feature we depend on is memory ballooning - the ability to scale up the memory available to a VM based on demand."

Three other factors were key in the decision: "a very active community, an ambitious technical roadmap with regular releases, and the involvement of companies including Red Hat, Intel, NetApp, Cisco and IBM reassured us that the project would be around for the duration." The oVirt community has been very helpful, and Stéphane and his colleagues appreciate the visibility into what is coming in future versions. "We are also participants in the oVirt community", says Stéphane, "we have been happy to sponsor some hardware and network bandwidth for some of the project's infrastructure - it's appropriate that oVirt is running part of its infrastructure on oVirt managed VMs, hosted by a company running oVirt in production. In addition, we have produced several videos promoting oVirt and explaining our technical choices and how we use oVirt alongside OpenStack."
