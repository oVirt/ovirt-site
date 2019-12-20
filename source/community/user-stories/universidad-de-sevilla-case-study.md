---
title: Universidad de Sevilla Case Study
category: community
authors: bproffitt
---

<div class="row">
<div class="col-md-7 col-md-offset-1 pad-sides">
# Universidad de Sevilla Case Study

The transition to university is a rite of passage for students globally. The thrill of being away from home for the first time and meeting new people is tempered by the lack of familiarity of a new place and the pressure of academic workloads.

In a time of huge transition, academic institutions will do their best to try to help their students adjust to the new life of college. This is one of the main reasons why the trend of "bring your own device" is so pervasive on campuses around the world. Let students use their own computers, tablets, and phones, the reasoning goes, and some of their adjustment pains will be eased.

But universities have their own course content to deliver, which needs to be done with a common platform of operating system and software applications. So, to deliver content anytime, any where, and on any device, academic institutions are increasingly turning to virtualization to help solve this problem.

The [University of Seville](https://www.us.es/) in Spain - with an enrollment of over 60,000 students - definitely feels the pressure of providing effective transportable computing environments for its students. To accomplish this, they initially looked at a VMware-based solution--specifically Virtual Desktop Infrastructure, which is the centralized hosting of desktop environments within virtual machines. This is a concept first developed by Sun with Sun Ray and perfected by VMware, and there is little doubt their software is good at it.

But, according to Miguel Rueda, Technical Manager of Universidad de Sevilla, the costs for a vSphere solution "were really high," which led IT decision makers at the University to turn to UDS Enterprise for a more cost-effective solution.

At the start of the 2011-12 academic year, Rueda related, the University connected with then-brand-new UDS, based in Madrid, Spain. The new firm had already generated some success within Spanish universities by delivering virtualization solutions, and they were confident they could pull off a similar win with Sevilla.

## oVirt Goes To School

When moving away from vSphere, a big part of the savings were achieved directly because of the core virtualization management solution: oVirt.

It was very much a perfect fit, actually. The University of Sevilla already had Dell blade hardware and were continuing to incorporate additional blade servers to the infrastructure. This kept their initial hardware investment lower, and the extensibility kept costs down as well. Using  the Dell systems with CentOS operating systems enabled the University to choose the effective--and free--KVM hypervisor platform for creating and running the virtual machines that make up the VDI system.

Beatriz Lafuente of [UDS Enterprise](https://www.udsenterprise.com/en/) explained that with KVM virtual machines in use, choosing oVirt became a no-brainer for UDS and the University. Storage was not an obstacle, either, since the University opted to go with iSCSI with NL-SAS drives, which are typically much cheaper than purchasing Fibre Channel arrays (though oVirt can talk to Fibre Channel as well).

UDS Enterprise's role in the University's deployment is serving up the virtual desktops to end users. UDS Enterprise's connection broker controls, authenticates and authorizes users and serves them different virtual machines according to the type of user. It specifically communicates between the KVM hypervisor and the LDAP authentication system.

The connection software connects with oVirt through a REST API, to determine on which hosts the virtual machines are physically running. oVirt then orchestrates the virtual machines and it facilitates their management through its management and reporting interface.

To start, the University chose to pilot this new VDI architecture through its OpenLabs Project, delivering the content for eight courses across 180 virtual desktops: This pilot solved the OpenLab's problem with desktop space issues as well as overall accessibility to applications for students. Nowadays, more than 3,000 students use this virtual desktop infrastructure.

The solution also worked out well for the University. Though it pays a subscription fee to UDS Enterprise, the University's cost savings through the use of open source software, the increased lifespan of their workstations, and the centralization of application management still delivered significant savings to the institution.

Lafuente outlined that the pilot program is currently being expanded, with new functionalities, such as physical PC access during non-school hours being delivered first to faculty, and then eventually all students. Tests are underway at this time, she added, with a possible implementation this year.

If successful, it is very likely this type of VDI deployment based on oVirt will be a model for a lot of other universities (and commercial entities) to follow.

</div>
<div class="col-md-4 pad-sides">
<div class="well well-lg">
![](/images/wiki/Sevilla.png)

**Company name:** Universidad de Sevilla
**Activity:** Major public university in Spain
**Founded:** 1505
**Size:** 65,000 students

</div>
</div>
</div>
