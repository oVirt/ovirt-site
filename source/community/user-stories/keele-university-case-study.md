---
title: Keele University case study
category: case-studies
authors:
  - bproffitt
  - dneary
---

# Keele University case study

<div class="row">
<div class="col-md-7 col-md-offset-1 pad-sides">
## Free, open source consolidated management for KVM

[Keele University](//www.keele.ac.uk/) has been using oVirt 3.2 in production since mid 2013. At the KVM Forum in Edinburgh, we spoke with Martin Goldstone and Gary Lloyd, system administrators at the university, to talk about their experiences, how they are using it, what they've liked, and what they're looking forward to seeing in the future.

"We have been aware of oVirt for a long time", says Martin, "We started looking at oVirt seriously after the 3.2 release, and we have been using it in production now for about 3 months." When making their choice, a few factors swayed them towards using oVirt. "oVirt was really the best project out there for managing KVM hypervisors", says Martin. When asked which features were important to them, they cited consolidated management of hosts and VMs, live migration, cost and open source. "Choosing oVirt has saved us tens of thousands of pounds over proprietary alternatives like VMware. Open source wins the philosophical debate for us", said Gary. "We wanted something which was mature and well supported", said Martin, "and when we looked at the feature list for oVirt we were very impressed".

## Infrastructure and workloads

Their virtual infrastructure is typical of a university IT set-up. "Most of what we are using is Dell Poweredge R510s or R610s. We use Dell EqualLogic for SAN storage," says Martin. "The majority of our servers are now VMs. We have 130 to 140 VMs, and 20 to 30 physical hosts. oVirt manages about a dozen hypervisors in total for the moment, and there are a few more we plan to move over. The main issue with the migration has been scheduling down-time so that we can migrate services from virtmanager to oVirt. A lot of the hosts we manage with virtmanager are still running CentOS 5, so libvirt doesn't support live migration very well."

The workloads they are running on the virtual machines are also very standard. "We run a good portion of our enterprise databases, active directory, file servers, web servers, and user accounts all to virtual infrastructure. We have 10,000 students, about 2,000 staff, and about 20,000 user accounts, for some reason. So all of those user accounts and files are on virtualized boxes," says Martin. "The majority of the servers are running Linux - mostly CentOS - and we have quite a few Windows servers also."

## Favourite features and issues

One of the things which they are planning to roll out shortly is the user console, to allow staff to create and administer their own VMs on demand. "The user console looks great, because it means we can farm out some of the basic admin tasks to people who want to do things like spin up new VMs."

They have run into some issues, mostly related to their storage set-up. "Since we have moved to Dell EqualLogic for shared storage, we've lost the usage of local storage attached to the hypervisor nodes. There are some use cases where we would like to take advantage of the local disks. We looked at Gluster and got the impression that the Gluster integration with oVirt was not well supported on CentOS 6, and we didn't want to run Fedora on servers," says Martin. According to Gary, "One of the problems we had with Gluster was that we couldn't mix storage domain types with oVirt 3.2 inside a single cluster - we couldn't use an iSCSI storage domain and a Gluster storage domain at the same time. So we decided to hold off that is supported in oVirt." The other issue was related to a limitation of their storage solution. "EqualLogic has a 1024 connection limit per storage pool, and [we need to figure out how to get around that issue](//sites.google.com/a/keele.ac.uk/partlycloudy/ovirt/gettingovirttoworkwithdellequallogic)," said Gary.

With the 3.3 release fresh off the presses, there were a number of features they were very interested in too. "We like the network quality of service stuff. For some of our guests we'll give them a direct iSCSI connection inside the guests rather than through the storage layer, so being able to guarantee network QoS is very useful to prevent those guests from running away with themselves," said Martin. Gary pointed to the scheduling API and self hosted engine as two upcoming features he was looking forward to. "One of the things we'd like to see is more granular control over what order VMs come up - something like a priority number that you can give to a VM. We are also looking forward to moving our oVirt Engine to a self-hosted VM and adding high availability."

And how has their experience been with the oVirt community? "It would be great to have something on a feature page in the wiki which indicates whether something is in development, in planning, or has been released. Aside from that, the community support has been great when we've needed it," said Martin.

</div>
<div class="col-md-4 pad-sides">
<div class="well well-lg">
![](/images/logos/Keele.svg)

**Name:** [Keele University](//www.keele.ac.uk/)
**Activity:** Education
**Location:** Keele, Staffordshire, United Kingdom
**Founded:** 1949
**Size:** Approx. 2,000 staff, 10,000 students

</div>
</div>
</div>
[Category:Case studies](/community/user-stories/user-stories.html)
