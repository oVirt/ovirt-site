---
title: the Solution Company case study
category: community
authors: sandrobonazzola
---

<div class="row">
<div class="col-md-7 col-md-offset-1 pad-sides">
# the Solution Company

![](/images/user-stories/theSolutionCompany_ThinClients.jpg)

We at [the Solution Company](https://www.the-solution-company.com/en/home) were asked to do IT for a hospital at the start of the 2020 and it was aweful.
The Hardware and Software was from back in the 2000 decade and we had a very hard time to get around there, since hospitals tend not to invest too much in IT,
there were no means in updating anything in the near future.
From Cabling over hardware to software and administrative things, everything was in a very bad shape.

With the coronavirus feared to come to Europe, the ministry of health in Germany started preparing.
For the area the hospital was in, it was decided not to take patients to nearest hospital, but to concentrate treatment to a few specialized ones.

A week or two before the lockdown in Germany started, we got a call, asking us to renew the entire IT to support the nurses and doctors.
They also told us, we had two and a half weeks to do that and we needed to start immediately.

With that kind of time pressure we started to buy and install lots of hardware, renewed the cabling, installed wireless, build two more server rooms.
Luckily most companies we relied on did a lot to help as fast as they could. 

Wherever we could, we chose the ways that meant the less time efford in organizing and installing.
That was the point where **oVirt** came on the scene. We do a lot with open-source software and had experience with oVirt,
it has **proven to be reliable and fast, immediatly available and had anything we needed to get started**. 

So we installed a hyperconverged oVirt (on Gluster) infrastructure, moved existing machines to it, and also started to introduce Windows 10 Pools for the medical staff to work with.
We also built an easy-to-use thin client based off **CentOS Linux** and started deploying it all over the hospital. 
(The staff wanted them so badly, whenever we appeared with a cart full of thin clients, they stood in a row to be the first to get them. No joke.)

To be honest, we weren't quite in time after two and half weeks, due to lots of organizational and logistic issues.
However, oVirt was no part of that. From day one **it made the entire IT a lot faster, easier and more reliable**
(we had some cases during the preparation with parts of the hyperconverged cluster failing, with **little to no downtime**, which was not possible there before the intruduction of oVirt)

Since then we are happy with it (and so is the hospitals staff). It also has cut time spent for support a lot.
And more important, the time the staff sitting in front of a computer, which in turn helped patients.
Thanks to mobile thin clients, the doctors can even take their computers with them.

It worked so good, we soon start to deploy oVirt in several schools in the area, to support IT & Computer Science Education.

For the records, the Hyperconverged Cluster deployed at the hostpial consists of 3 Storages, 3 Hosts, (120 Cores, 2.2TB RAM, 60T(x3) Storage total), 40GBit Interconnect between the clusters. 
We also utilize **AWX/Ansible** for administration and **Centos Linux for the ThinClients** and to carry out other services throughout the Hospital. 
Our ThinClients support currently up to two screens, and the entire infrastructure has proven to work with medical equipment, too 
(some connected to computers via usb, especially the medical card readers)

</div>
<div class="col-md-4 pad-sides">
<div class="well well-lg">
![](/images/logos/theSolutionCompany.png)<br>

**Company name:** the Solution Company<br>
**Activity:** Consulting<br>
**Founded:** ???<br>
**Size:** ??? employees, ??? revenues

</div>
</div>
</div>
