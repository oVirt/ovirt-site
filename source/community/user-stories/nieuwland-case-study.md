---
title: Nieuwland case study
category: case-studies
authors: bproffitt
---

# Nieuwland case study

<div class="row">
<div class="col-md-7 col-md-offset-1 pad-sides">
## Virtual data centers are not just for the enterprise

The idea of the virtual data center has been, perhaps justly, tied to the enterprise: a set of tools designed to assist large-scale businesses manage the data that has become the life-blood of business in the 21st Century. But virtualization is not just for the enterprise, and a virtualization management platform like oVirt can be a valuable asset to smaller, entrepreneurial companies, too.

[Nieuwland Geo-Informatie](https://www.nieuwland.nl/), a Wageningen, Netherlands software company, is one such organization. Nieuwland builds mobile applications as well as offers their clients back-end storage and web hosting to support those apps.

Joop van de Wege, a systems engineer with Nieuwland, outlined in detail how his firm uses oVirt to manage the many virtual servers that are key to their business processes.

## Infrastructure and workloads

Nieuwland builds cloud-type applications that use REST APIs that are exposed to the mobile application on the client. Typically, Nieuwland developers tend to make those applications available for off-line use, so the mobile app will use a small database inside the smartphone or the tablet, upload that data to the back-end data servers whenever they have connectivity.

Most of the time, van de Wege explained, workloads on their oVirt installation are fairly light, but because the applications being built have geographic features, there are some virtual database machines that are getting hit by higher loads.

“This can be quite intensive,” van de Wege said, “Mostly what's in the database is geographic information about roads, trees, waterways--things like that. Data is queried and mapped by the server and then sent as a picture to the end user. Which could be the client or mobile phone.”

Use cases in such instances rely heavily on data from Google Maps and OpenStreetMaps.

Currently, van de Wege outlined, Nieuwland has about 100 virtual machines, of which about 70 to 80 are currently running on oVirt. Van de Wege emphasized that this is a temporary solution, until Nieuwland can consolidate a new set up, which they are building now.

That future configuration will also be centered on oVirt, using Gluster as a storage back-end, van de Wege revealed, a configuration that will be completely redundant. Whether that new setup will be based on oVirt 3.3 or 3.4 will depend on whether RHEL 6.5 or 7 will include the newer libvirts that are necessary to talk directly to Gluster, he added.

Native Gluster access is not a necessary prerequisite to this move, as Nieuwland's team could use the POSIX layer now, but then they would need to migrate again, and they would rather skip that.

For the present, Nieuwland is running those hundred Vms on five oVirt hypervisors, one of which is being used for testing, which van de Wege classified as a light workload. The software development company also has two older Xen hypervisors with roughly 20 VMs each.

Managing this kind of heterogeneous environment has its challenges. Until recently, everything was managed from the command line, and even now the Xen hypervisors must still be run from the command line interface.

## Favorite features and issues

Nieuwland has thus far appreciated its decision to use oVirt.

“We didn't want VMware. Too expensive. There was already a heavy investment in Linux, so switching to Microsoft HyperV was no option, either; too costly,” van de Wege, “Well, after that, there is nothing, because real enterprise management packages? None, so far as I know, except Oracle.”

van de Wege added that they had also looked at solutions like Convirture, but they were too invasive for the host they were too disruptive to use in a production environment.

Circumstances also precluded Nieuwland from going with RHEV. Around the time van de Wege started, the company was using Xen on Debian GNU/Linux, and before that SUSE. Just dumping Debian and going to RHEV, then, would have been difficult, not to mention the licensing costs.

oVirt on its own has a lot of features that helped it to stand as a solution for Nieuwland. First and foremost, the central management features are the most important in van de Wege's opinion.

“That's the one thing you really needed. Everything that's related to that is nice, it works,” van de Wege said. “But central management is the big thing. It's terrible to see if you have five hosts and you need to maintain that by command line. No live migration. Nothing. If something goes wrong, you’re stuck on the command line, starting 50 VMs.”

Live migration is also a feature from which Nieuwland gets a lot of use.

There are some things that ven de Wege would like to see in upcoming versions of oVirt.

“GlusterFS being available in CentOS or Red Hat that's the biggest problem' not being able to use the newer libvirt qemu and KVM functionality that's available upstream. That's the big problem,” he stated. “So, for Fedora there's a virt preview repository and well, RHEL 7 and 6.5 are maybe going to fix that, but that's only a short-term solution because developments go fast. Within six, seven months you have the same problem again.”

Ideally, van de Wege added, he would like to see a virt preview repository for RHEL 6. “Something like that. That's a more permanent solution for fast-moving projects like oVirt.”

The oVirt community has been a big plus for the platform as well at Nieuwland. Van de Wege is happy with the level of community support and being able to help others. He believes this give-and take is a big part of why his company is pleased with oVirt.

“If that didn't work, we would need to go for paying support, because otherwise you can't run enterprises on it”

</div>
<div class="col-md-4 pad-sides">
<div class="well well-lg">
![](/images/logos/Nwld.png)

**Name:** [Nieuwland Geo-Informati](https://www.nieuwland.nl/)
**Activity:** Software Development
**Location:** Wageningen, Netherlands
**Size:** Approx. 100 staff

</div>
</div>
</div>
[Category:Case studies](/community/user-stories/user-stories/)
