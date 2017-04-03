---
title: Up and Running with oVirt 4.1 and Gluster Storage
author: jbrooks
date: 2017-03-29 08:00:00 UTC
tags: centos, gluster, ovirt, hyperconverged
comments: true
published: true
---

Last month, the oVirt Project [shipped version 4.1](http://lists.ovirt.org/pipermail/announce/2017-February/000312.html) of its open source virtualization management system. With a new release comes an update to this howto for running oVirt together with Gluster storage using a trio of servers to provide for the system's virtualization and storage needs, in a configuration that allows you to take one of the three hosts down at a time without disrupting your running VMs.

If you're looking instead for a simpler, single-machine option for trying out oVirt, your best bet is the <a href="http://www.ovirt.org/OVirt_Live">oVirt Live ISO</a>. This is a LiveCD image that you can burn onto a blank CD or copy onto a USB stick to boot from and run oVirt. This is probably the fastest way to get up and running, but once you're up, this is definitely a low-performance option, and not suitable for extended use or expansion.

Read on to learn about my favorite way of running oVirt.

READMORE

## oVirt, Glusterized

### Prerequisites

__Hardware:__ You’ll need three machines with 16GB or more of RAM and processors with [hardware virtualization extensions](http://en.wikipedia.org/wiki/X86_virtualization#Hardware-assisted_virtualization). Physical machines are best, but you can test oVirt using [nested KVM](http://community.redhat.com/blog/2013/08/testing-ovirt-3-3-with-nested-kvm/) as well. I've written this howto using VMs running on my "real" oVirt+Gluster install.

__Software:__ For this howto, I'm using [oVirt Node 4.1.1](https://www.ovirt.org/node/), a streamlined operating system image based on CentOS 7, for my three hosts, and a CentOS-based appliance image for the Engine VM. oVirt does support other OS options. For more info see the project's <a href="http://www.ovirt.org/download/">download page</a>.

__Network:__ Your test machine’s host name must resolve properly, either through your network’s DNS, or through the `/etc/hosts` file on your virt host(s), on the VM that will host the oVirt engine, and on any clients from which you plan on administering oVirt. It's not strictly necessary, but it's a good idea to set aside a separate storage network for Gluster traffic and for VM migration. In my lab, I use a separate 10G nic on each of the hosts for my storage network.

__Storage:__ The hosted engine feature requires NFS, iSCSI, FibreChannel or Gluster storage to house the VM that will host the engine. For this walkthrough, I'm using a Gluster arbiter volume, which involves creating a replica 3 Gluster volume with two standard data bricks and a third arbiter brick that stores only file names and metadata, thereby providing an oVirt hosted engine setup with the data consistency it requires, while cutting down significantly on duplicated data and network traffic.

### Installing oVirt with hosted engine

I'm starting out with three test machines with 16 GB of RAM and 4 processor cores, running oVirt Node 4.1.1. I actually do the testing for this howto in VMs hosted on my "real" oVirt setup, but that "real" setup resembles what I describe below.

I've identified a quartet of static IP address on my network to use for this test (three for my virt hosts, and one for the hosted engine). I've set up the DNS server in my lab to make these IPs resolve properly, but you can also edit the /etc/hosts files on your test machines for this purpose.

Our host1 will need to be able to access itself and the other two nodes via passwordless ssh:

```
[host1]# ssh-keygen

[host1]# ssh-copy-id root@$HOST1

[host1]# ssh-copy-id root@$HOST2

[host1]# ssh-copy-id root@$HOST3
```

Next, open up a web browser and visit your first host at port 9090 to access the cockpit web interface. Log in with the machine's root account, click the "Virtualization" tab at the top of the screen, and then click the "Hosted Engine" link in the left sidebar. Select the radio button next to "Hosted Engine with Gluster" and hit the "Start" button.

![](uarwo41-cockpit-1.png)

oVirt Node ships with an Ansible-based Gluster deployment tool called [gdeploy](http://gdeploy.readthedocs.io/en/latest/). The dialog window that appears contains a series of steps through which you provide gdeploy with the information it needs to configure your three nodes for running ovirt with gluster storage, starting with the hosts you want to configure.

![](uarwo41-gdeploy-1.png)

Click next to accept the defaults in step two, and then in step three, specify the gluster volumes you want to create. The cockpit gdeploy plugin autofills some values here, including a volume for the engine, a data volume, and a second data volume called vmstore. The storage domains you'll need for a minimal ovirt install are engine, data, export and iso, and so these are the ones I create: 

![](uarwo41-gdeploy-3.png)

Click "Next" to hit step four, where we'll specify the brick locations for our volumes. Again, the plugin prefills some values here, which aren't likely to be correct for your environment, so pay close attention here. In my test environment, I'm using one additional disk for my gluster data, `/dev/sdb`, and I'm specifying one brick per host per volume: 

![](uarwo41-gdeploy-4.png)

In the final, "Review" step, I found it necessary to click "Edit" and the following operation after the `script1` step:

```
# Disable multipath
[script3]
action=execute
file=/usr/share/ansible/gdeploy/scripts/disable-multipath.sh
```

![](uarwo41-gdeploy-5.png)

After making this edit, hit the "Save" button, and then hit "Deploy" to kick off the deployment process. This process will take some time to complete, as gdeploy installs required packages and configures gluster volumes and their underlying storage.

![](uarwo41-gdeploy-6.png)

### Hosted engine setup

Now, click the "Continue to Hosted Engine Deployment" button to begin configuring your hosted engine. After accepting the default "Yes" and clicking the "Next" button to begin the process, the install will offer to download the oVirt engine appliance image. Click "Next" to proceed.

The installer will ask if you want to configure your host and cluster for Gluster. Again, click "Next" to proceed. In some of my tests, the installer failed at this point, with an error message of `Failed to execute stage 'Environment customization'`. When I encountered this, I clicked "Restart Setup", repeated the above steps, and was able to proceed normally. 

You'll need to specify the `glusterfs` storage type, and then supply the path to your Gluster volume, which should be something like `host1:engine`.

Next, we need to specify which network interface to use for oVirt's management network, and whether the installer should configure our firewall. In some of my tests with oVirt Node, the management network setup step failed due to the presence of an ifcfg-eth0.bak file. When I encountered this issue, I removed the file from each of my hosts, restarted the process, and was able to proceed.

Then, we'll answer a set of questions related to the virtual machine that will serve the oVirt engine application. First, we tell the installer to use the oVirt Engine Appliance image that gdeploy installed for us. Then, we configure cloud-init to customize the appliance on its initial boot, providing various VM configuration details covering networking, VM RAM and storage amounts, and authentication. Enter the details appropriate to your environment, and when the installer asks whether to automatically execute engine-setup on the engine appliance on first boot, answer yes. Here's what the configuration on my test instance looked like:

![](uarwo41-config-preview.png)

Once you've supplied all these answers, and confirmed your choices, the installer will configure the host for virtualization, set up a storage domain, upload the appliance image to that domain, launch the engine VM, and then configure the engine service within that VM.

![](uarwo41-he-complete.png)

When the installation process completes, open a web browser and visit your oVirt engine administration portal at the address of your hosted engine VM. Log in with the user name `admin` and the password you chose during setup. Next, check out the bottom pane of the Clusters tab, where you should see the Action Item: "Some new hosts are detected in the cluster. You can Import them to engine or Detach them from the cluster." Click "Import," and in the dialog window that appears, provide passwords for your two hosts, and hit OK.

![](uarwo41-import-hosts.png)

## Configuring storage

Once that completes, visit the "Storage" tab in the console, click "New Domain," give your new domain a name, and choose "Data" and "GlusterFS" from the "Domain Function" and "Storage Type" drop down menus. Check the box marked "Use managed gluster," and from the drop down box that appears, choose your "data" volume, and hit the OK button to proceed.

![](uarwo41-data-domain.png)

The export and iso domains, which oVirt uses, respectively, for import and export of VM images, and for storing iso images, can be set up in roughly the same way. Click "New Domain," choose Export or ISO from the "Domain Function" drop down, choose GlusterFS from the "Storage Type" drop down, give the domain a name, check the box marked "Use managed gluster," and from the drop down box that appears, choose the matching volume, and hit the OK button to finish.

So far, we've created all of our Gluster-backed storage domains as replica 3 arbiter 1 volumes, which ensures that we can bring down one of our nodes at a time while keeping our storage available and consistent. In this howto, host 3 is the arbiter for all four volumes, which leaves all of the storage burden on the first two hosts. 

There are all sorts of ways to strike a better storage balance -- for instance, in my lab, I've taken to running four gluster nodes with distributed-replicated volumes made up of four data bricks and two arbiter bricks. The details depend a great deal on your particular environment, so I'll leave further storage tweaking as an exercise for the reader.

## Configuring hosts two and three for Hosted Engine

Head over to the Hosts tab, select host two, and in the toolbar below the tabs, click Management, and then Maintenance, and hit OK in the dialog box that appears next. Once the host is in maintenance mode, click Installation, and then Reinstall in the toolbar. In the dialog that appears next, click "Hosted Engine," and then, in the drop down box, choose DEPLOY, and hit OK. After that process completes, repeat the process on host three.

![](uarwo41-deploy-hosted.png)

Once all three hosts are back up, you should be able to bring down any one of the hosts at a time without losing access to the management engine or to your VM storage. 

## Running your first VM

oVirt engine comes pre-configured with a public Glance instance managed by the oVirt project. We'll tap this resource to launch our first VM.

From the storage tab, you should see an "ovirt-image-repository" entry next to a little OpenStack logo. Clicking on this domain will bring up a menu of images available in this repository. Click on the "CirrOS" image (which is very small and perfect for testing) in the list and then click "Import," before hitting the OK button in the pop-up dialog to continue.

![](uarwo40-import-image.png)

The image will be copied from the oVirt project's public Glance repository to the storage domain you just configured, where it will be available as a disk to attach to a new VM. In the import image dialog, you have the option of clicking the "Import as Template" check box to give yourself the option of basing multiple future VMs on this image using oVirt's templates functionality.

Next, head to the "Virtual Machines" tab in the console, click "New VM," choose "Linux" from the "Operating System" drop down menu, supply a name for your VM, and choose the "ovirtmgmt/ovirtmgmt" network in the drop down menu next to "nic1." Then, click the "Attach" button under the "Instance Images" heading and check the radio button next to the CirrOS disk image you just imported before hitting the "OK" button to close the "Attach Virtual Disks" dialog, and hitting "OK" again to exit the "New Virtual Machine" dialog.

For additional configuration, such as setting RAM and CPU values and using cloud-init, there's a "Show Advanced Options" button in the dialog, but you can revisit that later.

Now, back at the Virtual Machines list, right-click your new VM, and choose "Run" from the menu. After a few moments, the status of your new VM will switch from red to green, and you'll be able to click on the green monitor icon next to “Migrate” to open a console window and access your VM.

## Storage network

I mentioned above that it's a good idea to set aside a separate storage network for Gluster traffic and for VM migration. If you've set up a separate network for Gluster traffic, you can bring it under oVirt's management by visiting the "Networks" tab in the web console, clicking "New," and giving your network a name before hitting "OK" to close the dialog.

![](uarwo40-storage-net.png)

Next, highlight the new network, and in the **bottom pane**, choose the "Hosts" tab, and then click the radio button next to "Unattached." One at a time, highlight each of your hosts, click on "Setup Host Networks," and drag the new network you created from the list of "Unassigned Logical Networks" to the interface you're already using for your Gluster traffic, before clicking OK. Clicking the pencil icon in the network brings up an "Edit Network storage" dialog where you can configure the boot protocol and other configuration details.

![](uarwo40-storage-net-a.png)

Then, also in the **bottom pane**, choose the "Clusters" tab, right-click the "Default" cluster, and choose "Manage Network" from the context menu. Then check the "Migration Network" and "Gluster Network" boxes and hit the "OK" button to close the dialog.

![](uarwo40-storage-net-b.png)

## Maintenance, failover, and storage

The key thing to keep in mind regarding host maintainence and downtime is that this converged three node system relies on having at least two of the nodes up at all times. If you bring down two machines at once, you'll run afoul of the Gluster quorum rules that guard us from split-brain states in our storage, the volumes served by your remaining host will go read-only, and the VMs stored on those volumes will pause and require a shutdown and restart in order to run again.

The oVirt engine pays attention to the state of its configured gluster volumes, and will warn you if certain actions will run afoul of quorum rules or if your volumes have pending healing operations. 

You can bring a single machine down for maintenance by first putting the system into maintenance mode from the oVirt console by clicking on the host entry in the Hosts tab, and then, from either the tool bar below the tabs or from the right-click menu, choose Managegent, and then Maintenance, before updating, rebooting, shutting down, etc. as desired.

Putting a host into maintenance mode will also put that host's hosted engine HA services into local maintenance mode, rendering that host ineligible to take over engine-hosting duties. 

If you want to bring down the engine service itself, you can put your whole trio of hosts into global maintenance mode, preventing them from attempting to restart the engine on their own, by left-clicking on the Hosted Engine VM in the web admin console and enabling global maintenance mode.

## Till next time

If you run into trouble following this walkthrough, I’ll be happy to help you get up and running or get pointed in the right direction. On IRC, I’m jbrooks, ping me in the #ovirt room on OFTC or give me a shout on Twitter [@jasonbrooks](https://twitter.com/jasonbrooks).

If you’re interested in getting involved with the oVirt Project, you can find all the mailing list, issue tracker, source repository, and wiki information you need <a href="http://www.ovirt.org/Community">here</a>.
