---
title: IT Novum case study
category: case-studies
authors:
  - bproffitt
  - dneary
---

# IT Novum case study

<div class="row">
<div class="col-md-7 col-md-offset-1 pad-sides">
Some things are just going to be obvious from the start. For German open source solutions provider it-novum, when it came time to build a solution for their customers that would manage virtual datacenters, the choice was pretty obvious: it was going to be oVirt.

it-novum is a provider of robust enterprise-grade open source business solutions, an SAP partner, and a long-time partner of open source infrastructure products and applications, explained Director of Infrastructure and Operations Steffen Rieger. The company was started in the 1990s as a datacenter and SAP infrastruture provider for its parent organization KAP-AG, but in 2001, it-novum became a provider to external customers as well. Today the company has about 160 customers and employs about 75 people in their offices in Fulda, Germany and Vienna, Austria.

it-novum is a company that's very focused on delivering open source, so when they decided to build a product and solution set for their customers' datacenter needs, it made sense that oVirt was included.

But oVirt wasn't the first tool in it-novum's open source datacenter project.

## Building the Stack

First, Rieger explained, it-novum started with a Nagios-based monitoring solution, and added several open source tools to create openITCOCKPIT, it-novum's SLA product. This would be the first open source project in the open source datacenter.

The next step was migrating their service management tools to open source, building OTRS, a ticketing system for incidents and changes, and i-doit, a configuration management database.

it-novum would build their own open source storage platform as well, combining several open source tools under one Python front end, called openATTIC. Eventually, the company migrated all of their storage systems to openATTIC.

Finally, it-novum set their sights on an open source datacenter management platform. After initially evaluating Red Hat Enterprise Virtualization Manager, Rieger finally settled on oVirt, , "which fulfilled all of the requirements we had."

At the time, usability and the community support were the main reasons for it-novum's choice, and they settled on oVirt as the basis for their solution, specifically, oVirt 3.2.3 on Fedora 18. Rieger added that both "RHEV and oVirt are the most advanced KVM management solutions and the only ones we found that were up to par with what VMware provides. Since oVirt is closer to the development process and the community is always helpful in solving problems, we decided to go with oVirt."

To date, the work has paid off very well, with nearly 1,100 VMware virtual machines successfully migrated to oVirt.

"When it came to migrating the VMs, it was a very easy but very time-intensive migration. Unfortunately, we migrated most VMs manually, because there is no tool that corresponded to our requirements," Rieger explained. "But most of the preparations were possible without any downtime and we were able to automate some steps of the migration by scripting (i.e., the conversion of virtual disks)."

## Committed to oVirt

it-novum's own infrastructure is fully committed to oVirt. They run workloads on oVirt Node, for its parent KAP-AG group, where they host all of KAP-AG's and their own servers as well as the development environments they need. The storage system uses one storage shelf with 24 disks per four-node oVirt Node, which totals to four openATTIC Nodes, 15 Shelves, and 60 oVirt Nodes, all on 960 CPU cores and 7680 GB of RAM.

it-novum's primary storage system has a total of 360 disks, 240 of which are usable, giving them a total of 144 TB storage space, which is mirrored within the same datacenter location. In addition to that, the hosted production systems are mirrored to a second location with an additional openATTIC storage system. The cluster management facilities built into openATTIC helped it-novum a lot with setting up the data stores and the high-availability configuration.

"One of the really special features is the capability to take snapshots of the oVirt farm, to have every timestamp be consistent and be able to roll things back if they don't go so well. The live snapshotting has been very useful," Rieger added.

Moving forward, it-novum is integrating their open cloud management system, with oVirt as the VM provider. Right now the company is in the planning/architecture stages of such an integration.

"We have been very happy with oVirt. It's fully open source and fulfills all of our requirements for virtualization and virtualization management. It's not too far away from VMware Virtual Center, a very powerful tool," Rieger said.

"For the future, we're wishing for a smoother installation process (setting up the networking can be really painful if you're using unsupported 10GE DA cables, as we learned the hard way) along with an update procedure. It would not hurt if oVirt would become more well-known, so it would be more well-received and understood by customers."

</div>
<div class="col-md-4 pad-sides">
<div class="well well-lg">
![](/images/logos/It-novum.png)

**Name:** [it-novum](//it-novum.com/)<br>
**Activity:** IT Business Solutions<br>
**Location:** Fulda, Germany<br>
**Size:** Approx. 75 staff

</div>
</div>
</div>
[Category:Case studies](/community/user-stories/user-stories.html)
