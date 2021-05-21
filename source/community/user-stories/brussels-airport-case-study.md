---
title: Brussels Airport Case Study
category: community
authors:
  - bproffitt
  - roy
---

<div class="row">
<div class="col-md-7 col-md-offset-1 pad-sides">
# Brussels Airport Company Case Study

You want to talk high traffic? Try these numbers on for size: 1.57 million travelers. 15,505 flights. 40,481 tons of cargo.

Those are just the stats for March 2014 at the [Brussels Airport](http://www.brusselsairport.be/), a major global travel center that got an average of 50,502 passengers a day to and from their destinations on 500 daily flights in March. Keeping track of that kind of comings and goings is not exactly a picnic, but it's a challenge that the Brussels Airport team succeeds at every day.

Keeping an airport running is more than just rolling out the runway and letting planes come and go. Tens of thousands of scheduling changes and updates are made daily for passengers and aircraft alike, and as the infrastructure provider for the airlines that frequent Brussels Airport, the IT team is responsible for providing the systems that will enable airlines to do just that.

Airlines are, in general, pretty demanding customers--they have to be, given the very thin margins involved with getting people, staff and planes moving from point A to point B. When an airline is housed in an airport, they will bring their own IT systems, but they will also need to coordinate with the local airport's IT infrastructure for services that only the airport can provide, such as a centralized messaging exchange that communicates all of the flight status information taking off and landing at any given time.

To manage this mission-critical service, the Brussels Airport Company's solution is to let airlines deploy their applications on virtual machines, which in turn talk to a centralized Sybase database, according to David Van Zeebroeck, Product Manager Unix Infrastructure. "Unix" is not a typo, either: until recently, the Brussels Airport Company was primarily a Solaris-based shop, though the team is presently migrating many of their servers over to Linux. This presents an opportunity to take the approximately 150 virtual machines currently housed on 30 Solaris machines and manage them with another virtual datacenter management tool.

That solution, Van Zeebroeck emphasized, is oVirt running atop CentOS.

It was not, he added, the only solution the Brussels Airport Company examined. Initially, the team examined CloudStack and OpenStack as cloud-based solutions to their needs. But they found that CloudStack needed to much maintenance with the limited manpower and OpenStack proved too complex to setup. CloudStack, he added, did not have some of the feature sets the were looking for.

At this point, Van Zeebroeck and his colleague, Unix System Engineer Koen Vanoppen, started really looking at virtual datacenter tools based on Xen or KVM. oVirt, they found, fit the bill quite nicely.

The team was able to install oVirt and figure out how to migrate a CloudStack instance to oVirt in just two days, Vanoppen explained.

Now the Brussels Airport Company is committed to a nearly full migration of VMs from Solaris to oVirt. Currently there are 12 oVirt hypervisors the Brussels Airport Company is using, but this number will increase by the time the migration's planned completion at the end of 2015, Van Zeebroeck said. The length of the migration is not due to any particular challenge but driven by the operational nature of the airport.

The conversation with the Brussels Airport Company happened before the release of oVirt 3.4, so the team was looking forward to checking out the new features in latest release. They are also hoping that folder structure will be added to the oVirt interface and, like many other oVirt users and developers, are looking head to seeing more third-party vendors making use of the backup API for oVirt. In the meantime the upgrade to 3.4 has happened

Vanoppen has been very pleased with the strength and responsiveness of the community to date. When he has posed a question, "I get an almost immediate response, which is a huge plus for me."

"oVirt's community is an example of how a community should be," Van Zeebroeck echoed.

</div>
<div class="col-md-4 pad-sides">
<div class="well well-lg">
![](/images/logos/BrusselsAirport.svg)

**Company name:** Brussels Airport Company
**Activity:** Major people and cargo transportation center
**Founded:** 1914
**Size:** ~1,200 employees

</div>
</div>
</div>
