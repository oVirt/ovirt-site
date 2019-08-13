---
title: Judici Case Study
category: community
authors: bproffitt
---

<div class="row">
<div class="col-md-7 col-md-offset-1 pad-sides">
# Judici Case Study

If you've never been in a courthouse, there's one thing that might surprise you: courtrooms may be where all the action takes place, but their real worth is found in their file rooms and archives.

The average court case creates paperwork--a lot of paperwork. And in most countries, the rights of the participants in criminal, civil, and probate cases demands that records of such cases be kept on file for predetermined lengths of time, in case anything needs to be referenced later by anyone seeking precedence. So, files must be stored, and courthouses around the world are often full of papers and files and legal tomes that represent the history of the courts within.

In recent years, courts have become much more invested in the advantages of electronic file storage... the cost savings in paper and human resources alone make the migration to digital storage worth it. But wanting effective storage and getting it are two different things. The complexity of such a solution is increased when you need to make records public.

This was the situation the team behind the [Judici Project](http://www.judici.com/) found themselves in around the turn of the century. Tasked with creating an online repository for county courts in the State of Illinois, the Judici Project began by showing court data online, according to Jeremiah Jahn, one of the coordinators of the Project.

While few outside of Illinois may have heard of Judici, the project itself was ground breaking for its time, and has some historical moments of its own. Jahn explained that Judici was the first customer in the world for the [Hitachi BladeSymphony server with the Virtage hardware-based virtualization system](http://www.hitachi-america.us/supportingdocs/forbus/ssg/pdfs/Hitachi_Datasheet_Virtage_3D_10-30-08.pdf). This enabled a lot of flexibility for the project in terms of services, especially the on-board FibreChannel capabilities of BladeSymphony.

Virtage’s hardware-based virtualization scheme worked for Judici because of the requirements of PCI-DSS credit card transactions, where each service must run on its own server. Since the initial version of PCI didn't address virtualization, Judici had to go with a hardware-based system when it enabled participating courts to accept payments for traffic tickets by credit card in 2006. Eventually, the team would migrate to [KVM](http://www.linux-kvm.org/page/Main_Page) virtualization. As KVM became more production-ready, Jahn said, it was an easier system to manage than Virtage.

About a year ago, Jahn added, Judici began to show case documents as well as just court data. For these document storage needs, the projected started using [Gluster](http://www.gluster.org/) for host and guest storage, utilizing the FibreChannel features of the BladeSymphony servers. Initially Gluster was used to back up court documents in a cloud storage configuration, and since it was easier to support Gluster better, ultimately the team would support guest images on Gluster as well.

The older BladeSymphony hardware does impose some limitations on storage exports. Most of the server images and logical unit number (LUN) servers are exported through 4-Gbps FibreChannel cards from the servers using LIO (the replacement for the Linux Target Driver). The Windows desktop machines are attached directly to the Gluster storage pool, since normal users can create those VMs. Various servers use the Gluster system directly for storing a large number of documents and providing public access to the tune of about 300,000-400,000 requests per day, Jahn outlined.

## oVirt on the Docket

It would be Gluster that would lead Judici to migrate their KVM virtual machines to oVirt as late as December 2013.

"We were waiting for native Gluster support," Jahn explained. Once that feature was in place, Jahn and his colleagues would migrate their VMs to be managed by oVirt. There were "no big migration issues," Jahn added, "it took us about three days to get everything across."

Jahn did say that on the whole, it was probably a little easier for his team to make the Virtage-to-KVM migration than the move to oVirt, but that was only because of their familiarity with hardware virtualization in general.

With oVirt, there was more of a learning curve, since export domains, ISO domains, and storage pools were features that had to be mastered for the move. Jahn also indicated that oVirt Node did not work right away for Judici, but mostly because of Judici's own security standards. Since customer credit card data is being handled, PCI standards have to be maintained, which means a lot of handwritten SELinux policies needed to be added to oVirt Nodes.

Today, Judici offers the public litigant information, criminal and civil court information, case minutes, and calendar data for hearings, and is rolling out the capability to e-file cases online for 68 of Illinois' 102 county courts; quite a step up from its early days of storing court documents online in 2001.

To pull this off, Judici has a lot more going on under the hood than just a Linux box and a DSL line. oVirt is managing eight hypervisors, running 25 server VMs and over 15 desktop Windows VMs. The Gluster configuration includes three 12-Tb storage servers, all 1-TB based RAID 10 solid-state drives. Two of those servers have a 10-Gbps PTP connection with one geolocation server off-site. For the servers' operating system, Judici uses [Scientific Linux](https://www.scientificlinux.org/) 5 and 6.x.

Jahn cited the oVirt community as a big factor in the successful migration and continued use of oVirt. Any issues Judici has had with oVirt have been clearly and quickly answered by the community, which Jahn cites has having a high signal-to-noise ratio.

And Judici’s team would know, as oVirt and Gluster are just two of the many open source software projects that bring order to the documents of several Illinois courts. The entire Judici system is built on open source software, a fact for which Jahn is exceptionally proud.

</div>
<div class="col-md-4 pad-sides">
<div class="well well-lg">
![](/images/logos/Judici.png)

**Project name:** Judici
**Activity:** Online documentation and electronic filing for county courts in State of Illinois.
**Founded:** 2000
**Staff:** 3

</div>
</div>
</div>
