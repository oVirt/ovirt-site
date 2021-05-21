---
title: RCC Case study
category: community
authors: jmarks
---

<div class="row">
<div class="col-md-7 col-md-offset-1 pad-sides">
# Florida State University RCC Adopts oVirt Over Cloud

The Florida panhandle is the home for Florida State University’s Research Computing Center (RCC), which provides the FSU research community with high-performance computational resources to enable scientific research. The RCC’s mission also includes the support of multidisciplinary research, the provision of a general access computing platform, and encouraging cost sharing by departments with dedicated computing needs.

While most of the hardware is dedicated to high performance computing (HPC) activities, about 15% of RCC's machines are dedicated to virtual machines that provide basic data center services like LDAP, DNS, and web servers. For these virtual machines, RCC has turned to oVirt to manage the services that support its high performance computing efforts.

## Migrating from the Cloud

Originally, RCC used OpenStack for running its customers' virtual machines. However, OpenStack was overly complicated for situations where RCC’s researcher customers just wanted more flexibility to run a variety of applications, or even something as simple as the capability to install firewalls.

According to Edson Manners, RCC’s Operations Manager and Senior Systems Administrator, RCC started using oVirt in August of 2015 for internal testing. Manners explained that oVirt was deployed on “off-warranty server hardware.”

The test machine deployments proved so successful that Manners moved the RCC production virtual machines to oVirt, while still using the older hardware. Eventually, Manners said, he would have to migrate those machines to actual production-ready hardware. But he didn’t seem to be in too much of a hurry, based on oVirt performance to date.

The choice to move to oVirt wasn’t a difficult one; RCC was already using Red Hat Satellite 6, the systems-management product that enables administrators to deploy and manage enterprise Linux (in this case, CentOS) hosts.

Deployment was also made easier by the fact OpenStack already utilizes KVM. Some of the virtual machines RCC migrated had been built with Puppet and Foreman, so migrating them was a simple matter of rebuilding the virtual machines on the oVirt platform. The other KVM machines had to be migrated over as KVM images, but Manners explained there were no real technical deployment issues, with deployment taking a week when each machine was available for migration.

## Challenges and Future Plans

The migration was pretty smooth, Manners confirmed, though it did prove tricky to connect to a repository using the Satellite 6 tools, since Satellite is by default looking for Red Hat Virtualization repositories.

Manners added that the Gluster storage system needs more stability and more transparency in the file system, though it hasn’t been a deal breaker.

RCC’s current oVirt platform has 60 users across 20 different academic departments. The setup includes 42 virtual machines running on 17 hypervisors. The reason for the low ratio, Manners explained, is that the older hypervisor machines have low CPU density – just four to eight cores per chassis.

In the future, Manners plans to shift oVirt to production hardware with 32-core hypervisors. This will ensure even better performance and scalability for RCC’s virtual machine needs.



</div>
<div class="col-md-4 pad-sides">
<div class="well well-lg">
![](/images/logos/FSUSig_Horizontal_Color.png)<br>

**Company name:** Florida State University Research Computing Center<br>
**Activity:** Scientific research<br>
**Founded:** 1984<br>
**Size:** 60 users, 20 academic departments

</div>
</div>
</div>
