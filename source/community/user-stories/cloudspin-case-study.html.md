---
title: CloudSpin Case Study
category: community
authors: bproffitt
---

<div class="row">
<div class="col-md-7 col-md-offset-1 pad-sides">
# CloudSpin Case Study

The open source community is full of stories of altruism. From grass-roots efforts like [Reglue](//www.reglue.org/) to the [opening of patents by rising-star corporations](//www.teslamotors.com/blog/all-our-patent-are-belong-you), there is something about open source that seems to inspire people to go above and beyond.

In south-central Colorado, one man is demonstrating that same sort of attitude, turning a learning experience into something that will benefit many in the IT community at large.

Donny Davis had a problem. An active-duty soldier just months from his discharge, Davis is working to enhance the tech skills he acquired in the US Army as he prepares to move into the civilian private sector. Davis' work in the military included satellite communications and networking, but not so much system administrative work. So, to punch up that part of his résumé, Davis opted to obtain Red Hat Certified Engineer (RHCE) certification.

<div class="thumbnail pull-left">
![](/images/wiki/Donnydavis.jpg)

</div>
Of course, if you're working towards certification as a system administrator, then it helps a lot if you have a lot of systems on which to practice. For Davis, this was not a major concern. A hardware collector of sorts, Davis has server racks containing enough machines for "a couple hundred Xeon processors and a couple hundred GB of RAM." To maximize his server potential, Davis decided to turn to a virtualization solution to increase the number of managed machines. But would that solution be a virtual datacenter solution or a cloud solution like OpenStack or CloudStack?

For Davis, the solution was pretty well laid out by one particular limitation in his setup: the connection to the Internet provider requires a physical connection to the bridge, and any IPv6 addresses used in Davis' configuration were coming from the Internet provider. Because of the limitations of Neutron, which assumes multi-tenancy, this is something that OpenStack and CloudStack simply cannot handle at the present time... not if Davis wanted to manage an IPv6 network.

"oVirt is the only project with the networking flexibility to let me do this," Davis explained in a recent conversation. So, he set about building an oVirt installation, even taking advantage of the hosted engine feature to shift his initial management machine to a self-hosted virtual machine.

If the story ended there, this would be a fairly straightforward use-case for an oVirt deployment: hardware, decent network connection, use requirements met... nothing special here. But it's what Davis decided to do next that make this particular setup unique.

Davis is giving away space on his servers free. As in beer.

Under the [CloudSpin](//cloudspin.me/) name, Davis is letting all comers sign up for any VM space they need, free of charge. This is not just for non-profits or non-commercial developers, either... starting last December, Davis made his setup open to anyone with a need. The only caveat he insists users understand: this is not a production environment, and it should not be treated as such.

Davis intends to keep CloudSpin up and running indefinitely, and aims to provide users quickly available development and testing environments on an as-needed basis.

For Davis, the benefits are clear: he gains valuable real-world experience working with systems and virtual data centers as he works towards RHCE. He is not looking to generate any revenue from this project, though towards the end of December, Davis did set up a donation system to help recoup the costs of the biggest expense for CloudSpin, power, as well as other plans.

"The money donated will first be used to fund a better connection and get IPv4 so all the VM’s will have dual stack capabilities," [Davis explained in a blog post](//cloudspin.me/donations/). "The next order of business will be to get more hardware, and begin offering a enough resources for you to actually host a real server at CloudSpin. I am shooting for minimums of 1GB of ram, one processor, and 40GB of space.

"If you haven’t already figured it out, I am not in CloudSpin for money, I do this so developers have somewhere to fire up their project and put it on the real Internet. This is a place to chop, cut, rebuild, and work together," Davis added.

It's nicely altruistic arrangement that fits well with the spirit of open source.

</div>
<div class="col-md-4 pad-sides">
<div class="well well-lg">
![](/images/wiki/Cloudspin.png)

**Company name:** CloudSping
**Activity:** Computer services and hosting
**Founded:** 2014
**Size:** 1 employee

</div>
</div>
</div>
