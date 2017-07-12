---
title: autoballooning-howto
category: howto
authors: aglitke
---

<!-- TODO: Content review -->

# autoballooning-howto

## Setup autoballooning in oVirt 3.2

This HOWTO explains how to set up an auto-ballooning policy using the oVirt 3.2 release. Eventually this will be integrated into oVirt but for those interested in tinkering with a cutting edge feature, this guide will help you to set it up in your environment.

### Nested Virtualization

Since I was a bit short on hardware when I wrote this tutorial, I set all of this up in a nested virtualization environment (ovirt-engine and my hypervisor node were each virtual machines themselves). The hypervisor used the nestedvt vdsm hook to spawn nested VMs. I recommend using real hardware for your hypervisor node if available because it will give you a more realistic result.

### oVirt Setup

Create an oVirt 3.2 environment consisting of an ovirt-engine system and at least one hypervisor host. You will be modifying the hypervisor so it's best to use a plain Fedora 18 installation rather than ovirt-node. Once everything is set up and you can launch virtual machines, set your cluster level memory optimization to "Desktop load". This will allow you to spawn enough VMs on your host to trigger the ballooning behavior.

### VM Setup

*   Install a single VM with the distribution of your choice. I used [Tiny Core Linux](http://distro.ibiblio.org/tinycorelinux/) because I used nested virtualization and had pretty limited resources to start with. If you can spare the resources, I recommend Fedora 18 VMs because the guest agent is packaged for that distribution.
*   Install the ovirt-guest-agent into the virtual machine. This is important because the guest agent provides vital memory statistics to the hypervisor which uses them to make autoballoon decisions.

Idle VMs don't usually consume a lot of memory and won't stress the system the way we need to for this exercise. The tool memknobs was written by Dave Hansen to produce continuous memory stress in a Linux system. I use it to increase the management challenge in the hypervisor.

*   Build memknobs binary

<!-- -->

    git clone git://git.sr71.net/memknobs.git
    cd memknobs
    gcc -m32 -g -static -o memknobs memknobs.c

*   Copy this binary to a known location in your VM
*   Calculate the parameters. You want to set the parameters to get the VM's memory usage high enough so that the hypervisor's memory becomes constrained after several VMs have been started. You can run memknobs and then observe its effect on the VM in the oVirt Webadmin console. The most important ones impacting this scenario are:

:;run_duration

::The amount of time memknobs should run

:;loop_duration_secs

::Increase this to cause memknobs to sleep longer between intervals and reduce CPU consumption

:;size_mb

Sets the working set size of memknobs. Higher values will result in more memory usage.

*   Arrange for memknobs to be started automatically when the VM boots. You can probably use your distribution's rc.local facility for this.
*   Once you have a working VM power it off and use the Webadmin to create a template from it. Use that template to create a VM pool with as many VMs as you think you'll need to stress the system.

### Hypervisor Setup

In oVirt 3.2, all the software needed to do autoballooning is already installed in the hypervisor as part of the default configuration. You just need to change the MOM management policy. MOM stands for Memory Overcommitment Manager and it is a dynamic policy engine that is designed to optimize the configuration of a KVM hypervisor over time in response to changing load. By default, oVirt uses MOM for tuning KSM page sharing only. In the future it will also tune ballooning, IO bandwidth, CPU capping, etc.

We need to change VDSM's mom configuration in order to add a Ballooning plugin and change the policy. First, grab [mom-balloon.conf](Sla/autoballooning-howto/mom-balloon.conf) and [mom-balloon.policy](Sla/autoballooning-howto/mom-balloon.policy) and place them in /etc/vdsm on your hypervisor host. Next, edit /etc/vdsm/vdsm.conf and add:

    [mom]
    conf = /etc/vdsm/mom-balloon.conf

Finally, restart vdsm. Your hypervisor is now configured for autoballooning.

#### About this autoballooning policy

The policy you have installed contains the same logic for tuning KSM as the default oVirt policy. It adds new logic for dynamically changing the amount of memory allocated to VMs based on the amount of host memory pressure. If the host has less than 20% of its memory readily available, it begins to reclaim some memory by shrinking virtual machines. Rather than indiscriminately shrinking all VMs, it tries to apply pressure to the VMs with the most free memory and tries to avoid forcing VMs into memory pressure themselves. If the host gets into more trouble (less than 5% of memory readily available) then ballooning becomes more aggressive and VM performance will start to degrade. In my research, I've found it is always better to have memory pressure in virtual machines than in the hypervisor. Hopefully the ballooning will correct the memory pressure in the host. When readily available memory rises above 20%, the virtual machines are gradually returned to their full memory allocation.

### Testing it out

Now that your environment is set up, testing it is as simple as starting up some virtual machines. Because ballooning is a low-level optimization that should happen transparently, you will not see much evidence of it happening (except for the ability to run more VMs). If you want to see the individual balloon operations happening you can follow MOM's actions by looking at its log on the hypervisor:

    tail -f /var/log/vdsm/mom.log

### Extra credit

One of the greatest challenges with hypervisor dynamic policies and autoballooning in particular, is that the optimal policy depends on the workload. This is why the policy is separated out into its own file. It allows the policy to be easily replaced with another one if required. The memknobs program creates a very particular type of memory pressure because it does not perform any file I/O. This may be similar to the kind of memory pressure you would see with a Java application server. The kind of memory pressure that can be seen with a web server workload is much different and this ballooning policy will have different results. For more details about this, see the [<http://www.ibm.com/developerworks/linux/library/l-overcommit-kvm-resources/index.html?ca=drs>- developerWorks article] I wrote on the topic:.

Other people are experimenting with different kinds of policies. In particular, [this policy](http://gerrit.ovirt.org/#/c/8945/) does not require a guest agent to be installed, but will not differentiate between idle and busy VMs.

There are lots of ways to try and estimate how much memory a VM actually needs in order to perform well enough. If you have any ideas on other autoballooning policies that could give even better results than the one we have tried here I would love to hear about them.
