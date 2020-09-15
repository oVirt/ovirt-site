---
title: the Solution Company case study
category: community
authors: sandrobonazzola, bproffitt, stoobie
---

<div class="row">
<div class="col-md-7 col-md-offset-1 pad-sides">
# the Solution Company

![](/images/user-stories/theSolutionCompany_ThinClients.jpg)

[the Solution Company](https://www.the-solution-company.com/en/home) was asked to revamp the IT infrastructure for a hospital at the beginning of 2020… and frankly,
the existing infrastructure situation was awful. Their hardware and software were from back in the 2000’s, and it was very difficult to manage and operate.
This hospital had made the decision to not invest much in IT, so there were no available funds in the foreseeable future. Everything was in bad shape, all the way down to the cables!

With COVID-19 threatening to arrive in Europe, the Ministry of Health in Germany began preparations.
For the area in which the hospital is located, it was decided to set aside specific hospitals to treat COVID-19 patients, including this one.

A week or two before the lockdown in Germany started, we got a call asking us to refresh the entire IT infrastructure to support the nurses and doctors.
The hospital administrators also told us that we only had two and a half weeks, and we needed to start immediately.

With the clock ticking, we started to buy and install large quantities of hardware, including new cabling, wireless networking, and two additional server rooms.
Luckily, most vendors we relied on did a lot to help as quickly as they could. Wherever we could, we made choices that required less time and effort to organize and install.

That’s where [oVirt](https://www.ovirt.org) came on the scene. We do a lot with open source software and had experience with oVirt, which has proven to be reliable and fast,
was immediately available, and had everything we needed to get started right away.

So we installed a hyperconverged oVirt (on Gluster) infrastructure, migrated existing virtual machines, and also started to introduce Windows 10 VM pools for the medical staff to use.

We also built easy-to-use thin clients based on [CentOS Linux](https://www.centos.org) and began deploying them all over the hospital.
(Not a joke: the staff wanted them so badly, whenever we appeared with a cart full of thin clients, they stood in line to be the first to get them. )

To be honest, we didn’t quite make the two-and-a-half week deadline, because of several organizational and logistic issues.
But oVirt was one of the reasons that we completed the job as quickly as we did. From day one it made the entire IT infrastructure a lot faster, easier to use and maintain, and more reliable.



Since then, we (and the hospital staff) are very happy with oVirt. It has even significantly cut the time the support staff invests, and more importantly,
the time the hospital staff spends sitting in front of a computer. So the patients win too, which is really the ultimate goal.
Thanks to mobile thin clients, the doctors can even take their computers with them.

It worked so well, we’ll soon begin to deploy oVirt in several schools in the area, to support IT and Computer Science Education.

For the record, the hyperconverged cluster deployed at the hospital consists of 3 storage domains, 3 hosts, totalling 120 Cores, 2.2 TB RAM, 180 TB storage),
and 40 GBit Interconnect between the clusters.

We also use AWX/Ansible for administration and CentOS Linux for the thin clients, and to carry out other services throughout the hospital.
Thin clients support up to two screens, and the entire infrastructure has proven to work with medical equipment too, some of which is connected via USB, such as medical card readers.


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
