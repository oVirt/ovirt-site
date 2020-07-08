---
title: Alter Way case study
category: community
authors: dneary
---

<div class="row">
<div class="col-md-7 col-md-offset-1 pad-sides">
# Alter Way Case Study

[Alter Way](//alterway.fr), a French hosting and services company founded in 2006, has been using oVirt in its public cloud offering "H2O".
The service launched in October 2012, and there are already over 300 VMs being managed on the service for clients. We recently caught up with Stéphane Vincent, Director of Strategic Services and Innovation, to talk about why Alter Way chose oVirt, how they are using it, and what excites them about the 3.3 release.

"We decided early on to standardise on KVM for our hypervisor layer, and evaluated a number of management solutions for it. We looked at OpenNebula, CloudStack, Proxmox, Red Hat Enterprise Virtualization, oVirt and OpenStack. In the end, we settled on oVirt for hosting our public cloud offering, and OpenStack for our private cloud offering," says Stéphane. The main features of oVirt which influenced the decision were "it allowed us to scale up as well as scale out our client workloads. oVirt allows us to do everything that our clients expect, including the ability to dedicate several hypervisors within a datacenter to a client. The main technical feature we depend on is memory ballooning - the ability to scale up the memory available to a VM based on demand."

<div class="thumbnail pull-left col-md-5">
![](/images/wiki/Stephane_Vincent.png)
*Stéphane Vincent, Director of Strategic Services and Innovation, Alter Way*

</div>
Three other factors were key in the decision: "a very active community, an ambitious technical roadmap with regular releases, and the involvement of companies including Red Hat, Intel, NetApp, Cisco and IBM reassured us that the project would be around for the duration." The oVirt community has been very helpful, and Stéphane and his colleagues appreciate the visibility into what is coming in future versions. "We are also participants in the oVirt community", says Stéphane, "we have been happy to sponsor some hardware and network bandwidth for some of the project's infrastructure - it's appropriate that oVirt is running part of its infrastructure on oVirt managed VMs, hosted by a company running oVirt in production. In addition, we have produced several videos promoting oVirt and explaining our technical choices and how we use oVirt alongside OpenStack."

The oVirt 3.3 release is a significant one for Stéphane. "When we chose oVirt, we were looking for convergence between our private cloud offering and our public cloud. The integration with OpenStack's projects, Glance and Neutron, is very exciting for us. The other features we're really looking forward to are the ability to set custom properties on VMs and devices, which will allow greater customization and control, and RAM snapshots, which will capture not only disk state but also in-memory state of VMs at the time of a snapshot."

And what does the future hold? "We are very happy with our choice of oVirt, and we are happy to see that interoperability is a high priority", says Stéphane. "We plan to expand our usage of oVirt. As a service provider, we will respond to customer needs, and there are a number of use-cases which oVirt addresses which are not possible with alternative solutions."

</div>
<div class="col-md-4 pad-sides">
<div class="well well-lg">
![](/images/logos/AlterWay.png)<br>

**Company name:** Alter Way<br>
**Activity:** Computer services and hosting<br>
**Founded:** 2006<br>
**Size:** 110 employees, €11M revenues

</div>
</div>
</div>
