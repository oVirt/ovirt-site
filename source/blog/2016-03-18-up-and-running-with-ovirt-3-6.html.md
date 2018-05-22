---
title: Up and Running with oVirt 3.6 and Gluster Storage
author: jbrooks
date: 2016-03-18 08:00:00 UTC
tags: ovirt, gluster, centos
comments: true
published: true
---

In November, version 3.6 of oVirt, the open source virtualization management system, [hit FTP mirrors](https://lists.ovirt.org/pipermail/announce/2015-November/000205.html) featuring a whole slate of [fixes and enhancements](/develop/release-management/releases/3.6/), including support for storing oVirt's self hosted management engine on a [Gluster volume](/develop/release-management/features/engine/self-hosted-engine-gluster-support/).

This expanded Gluster support, along with the new ["arbiter volume"](https://gluster.readthedocs.org/en/latest/Administrator%20Guide/arbiter-volumes-and-quorum/) feature added in [Gluster 3.7](http://blog.gluster.org/2015/05/glusterfs-3-7-0-has-been-released-introducing-many-new-features-and-improvements/), has allowed me to simplify (somewhat) the converged oVirt+Gluster installation [that's powered](http://community.redhat.com/blog/2014/11/up-and-running-with-ovirt-3-5-part-two/) my [test lab](http://community.redhat.com/blog/2014/05/ovirt-3-4-glusterized/) for the [past few years](http://community.redhat.com/blog/2013/09/ovirt-3-3-glusterized/).

Read on to learn about my favored way of running oVirt, using a trio of servers to provide for the system's virtualization and storage needs, in a configuration that allows you to take one of the three hosts down at a time without disrupting your running VMs.

READMORE

**Important Note:** I want to stress that this converged virtualization and storage scenario is a bleeding-edge configuration. Many of the ways you might use oVirt and Gluster are available in commercially-supported configurations using RHEV and RHS, but at this time, this oVirt+Gluster mashup isn't one of them. What's more, this configuration is not "supported" by the oVirt project proper, a state that should change somewhat once this <a href="http://www.ovirt.org/develop/release-management/features/engine/self-hosted-engine-hyper-converged-gluster-support">Self Hosted Engine Hyper Converged Gluster Support</a> feature lands in oVirt.

If you're looking instead for a simpler, single-machine option for trying out oVirt, here are a pair of options:

* <a href="http://www.ovirt.org/OVirt_Live">oVirt Live ISO</a>: A LiveCD image that you can burn onto a blank CD or copy onto a USB stick to boot from and run oVirt. This is probably the fastest way to get up and running, but once you're up, this is definitely a low-performance option, and not suitable for extended use or expansion.

* <a href="http://www.ovirt.org/develop/release-management/features/integration/allinone/">oVirt All in One plugin</a>: Run the oVirt management server and virtualization host components on a single machine with local storage. The setup steps for AIO haven't changed much since I wrote about it [two years ago](http://community.redhat.com/blog/2013/09/up-and-running-with-ovirt-3-3/). This approach isn't too bad if you have limited hardware and don't mind bringing the whole thing down for maintenance, but oVirt really shines brightest with a cluster of virtualization hosts and some sort of shared storage.


## oVirt, Glusterized

### Prerequisites

__Hardware:__ You’ll need three machines with plenty of RAM and processors with [hardware virtualization extensions](http://en.wikipedia.org/wiki/X86_virtualization#Hardware-assisted_virtualization). Physical machines are best, but you can test oVirt using [nested KVM](http://community.redhat.com/blog/2013/08/testing-ovirt-3-3-with-nested-kvm/) as well. I've written this howto using VMs running on my "real" oVirt+Gluster install.

__Software:__ For this howto, I'm using CentOS 7 for both the host and the Engine VM. oVirt does support other OS options. For more info see the project's <a href="http://www.ovirt.org/download/">download page</a>.

__Network:__ Your test machine’s host name must resolve properly, either through your network’s DNS, or through the `/etc/hosts` file on your virt host(s), on the VM that will host the oVirt engine, and on any clients from which you plan on administering oVirt. It's not strictly necessary, but it's a good idea to It's a good idea to set aside a separate storage network for Gluster traffic and for VM migration. In my lab, I use a separate 10G nic on each of the hosts for my storage network.

__Storage:__ The hosted engine feature requires NFS, iSCSI, FibreChannel or Gluster storage to house the VM that will host the engine. For this walkthrough, I'm using a Gluster arbiter volume, which involves creating a replica 3 Gluster volume with two standard data bricks and a third arbiter brick that stores only file names and metadata, thereby providing an oVirt hosted engine setup with the data consistency it requires, while cutting down significantly on duplicated data and network traffic. If you have access to good external storage to use with your oVirt exploration, you can skip the Gluster setup bits, and I'll point out where you can substitute your external storage resource.

### Installing oVirt with hosted engine

I'm starting out with three test machines with 16 GB of RAM and 4 processor cores, running a minimal installation of CentOS 7 with all updates applied.  I actually do the testing for this howto in VMs hosted on my "real" oVirt setup, but that "real" setup closely resembles what I describe below.

I've identified a quartet of static IP address on my network to use for this test (three for my virt hosts, and one for the hosted engine). In addition, I'm using three other static IPs, on a different network, for Gluster storage. I've set up the DNS server in my lab to make these IPs resolve properly, but you can also edit the /etc/hosts files on your test machines for this purpose.

Next, we need to configure the oVirt software repository on each of our three hosts.

```
[each-host]# yum install -y http://resources.ovirt.org/pub/yum-repo/ovirt-release36.rpm
```

Then, install the hosted engine packages, along with [screen](http://www.gnu.org/software/screen/), which can come in handy during the deployment process:

```
[each-host]# yum install -y ovirt-hosted-engine-setup screen glusterfs-server vdsm-gluster system-storage-manager
```

### Gluster preparations (run on each host)

We need a partition to store our Gluster bricks. For simplicity, I'm using a single XFS partition, and my Gluster bricks will be directories within this partition. I use system-storage-manager to manage my storage.

_If you're skipping the local Gluster storage, and using some different external storage, you can skip this step._

````
[each-host]# ssm add -p gluster $YOUR_DEVICE_NAME
[each-host]# ssm create -p gluster --fstype xfs -n bricks
````

Next, create a mountpoint and modify your `/etc/fstab` to ensure that your LVM volume gets mounted at boot time:

````
[each-host]# mkdir /gluster
[each-host]# echo "/dev/mapper/gluster-bricks /gluster xfs defaults 0 0" >> /etc/fstab
````

Now, we'll mount our LVM volume and create some mount points for our Gluster volumes-to-be. We'll have separate Gluster volumes for our hosted engine, and for our oVirt data, iso and export domains:

````
[each-host]# mount -a
[each-host]# mkdir -p /gluster/{engine,data,iso,export}/brick
````

I'd like to use firewalld for my firewall, but at this point oVirt gets along better with good old iptables. Rather than hand-edit my firewall configuration, I start out with no firewall active at all, and I allow oVirt engine to handle firewall configuration itself a bit later in the process:

```
[each-host]# systemctl stop firewalld  && systemctl mask firewalld
```

Now start the Gluster service and configure it to auto-start after subsequent reboots:

```
[each-host]# systemctl start glusterd && systemctl enable glusterd
```

I mentioned up top that it's no longer necessary to come up with a virtual IP to access Gluster via NFS, but I still want some failover for the mount point that oVirt will use to mount Gluster volumes in the system. I want round robin DNS to associate the storage network IP on each of my three nodes with a common host name that I'll use when I configure my Gluster volumes in oVirt. I could set this up in my network's DNS server, but for a more self-contained solution, I'm using dnsmasq on each of the three nodes.

I added `nameserver 127.0.0.1` to the top of `/etc/resolv.conf` on each of my machines, edited `/etc/hosts` to make three entries for my mount address, and enabled/started dnsmasq. If you're using a separate network for Gluster, use IPs from that network here:

```
[each-host]# vi /etc/hosts

$HOST1  glustermount
$HOST2  glustermount
$HOST3  glustermount

[each-host]# yum install dnsmasq -y
[each-host]# systemctl  enable dnsmasq && systemctl start dnsmasq
```

### Create your Gluster volumes (run on host one)

This next set of steps need be run on only one of your hosts.

First, from $HOST1 we'll add $HOST2 and $HOST3 to our gluster trusted pool. Again, If you're using a separate network for Gluster, use IPs from that network here:

```
[host-one]# gluster peer probe $HOST2
[host-one]# gluster peer probe $HOST3
```

Next, we'll create our four gluster volumes. Only the engine volume must be a replica 3 volume to proceed, but if you want your other three volumes to remain accessible in case one of the nodes goes down, you'll need to make them replica 3 as well. Because the gluster arbiter volume type stores data on the first two bricks listed, and only file names and metadata on the third brick, I'm shuffling the order of the bricks in order to spread the load around somewhat:

```
[host-one]# gluster volume create engine replica 3 arbiter 1 $HOST1:/gluster/engine/brick $HOST2:/gluster/engine/brick $HOST3:/gluster/engine/brick
[host-one]# gluster volume create data replica 3 arbiter 1 $HOST3:/gluster/data/brick $HOST1:/gluster/data/brick $HOST2:/gluster/data/brick
[host-one]# gluster volume create iso replica 3 arbiter 1 $HOST2:/gluster/iso/brick $HOST3:/gluster/iso/brick $HOST1:/gluster/iso/brick
[host-one]# gluster volume create export replica 3 arbiter 1 $HOST1:/gluster/export/brick $HOST2:/gluster/export/brick $HOST3:/gluster/export/brick
```

Now, apply a set of virt-related volume options to our engine and data volumes, and properly set our volume permissions:

````
[host-one]# gluster volume set engine group virt
[host-one]# gluster volume set data group virt
[host-one]# gluster volume set engine storage.owner-uid 36 && gluster volume set engine storage.owner-gid 36
[host-one]# gluster volume set data storage.owner-uid 36 && gluster volume set data storage.owner-gid 36
[host-one]# gluster volume set iso storage.owner-uid 36 && gluster volume set iso storage.owner-gid 36
[host-one]# gluster volume set export storage.owner-uid 36 && gluster volume set export storage.owner-gid 36
````

Finally, we need to start our volumes:

````
[host-one]# gluster volume start engine
[host-one]# gluster volume start data
[host-one]# gluster volume start iso
[host-one]# gluster volume start export
````

## Installing the hosted engine (run on host one)

PXE, ISO image, and OVF-formatted disk image are our installation media options for the VM that will host our engine. Here, I'm using the OVF image provided by the `ovirt-engine-appliance` package:

```
[host-one]# yum install ovirt-engine-appliance -y
```

Now we should be ready to fire up `screen` (this comes in handy in case of network interruption), kick off the installation process, and begin answering the installer's, answering questions.

```
[host-one]# screen
[host-one]# hosted-engine --deploy
```

#### Storage configuration

Here you need to specifiy the `glusterfs` storage type, and supply the path to your Gluster volume. If you're using a different sort of shared storage, specify the storage type and location details that apply.

![](uarwo36-storage-configuration.png)

#### Network configuration

Next, we need to specify which network interface to use for oVirt's management network, and whether the installer should configure our firewall. Decline the firewall configuration offer for now -- we'll take care of this a bit later.

![](uarwo36-network-config.png)

#### VM configuration

Now, we answer a set of questions related to the virtual machine that will serve the oVirt engine application. First, we tell the installer to use the oVirt Engine Appliance image that we downloaded earlier:

![](uarwo36-vm-config.png)

Then, we configure cloud-init to customize the appliance on its initial boot, providing host name and network configuration information. We can configure the VM to kick off the engine setup process automatically, but I've found that making this choice has left me without the option to enable Gluster volume management in my oVirt cluster, so we'll run that installer separately in a bit.

![](uarwo36-vm-config-a.png)

This part of the installer also prompts you to choose the number of virtual CPUs and RAM for your engine VM. The optimal amount of RAM is 16GB, and the recommended minimum is 4GB.

![](uarwo36-hosted-engine-config.png)

Once you've supplied all these answers, and confirmed your choices, the installer will configure the host for virtualization, set up a storage domain, upload the appliance image to that domain, and then launch the engine VM.

Next, the installer will provide you with an address and password for accessing the VM with the vnc client of your choice. You can fire up a vnc client, enter the address provided and enter the password provided to access the VM, or you can access your engine VM via ssh using the hostname you chose above, which is what I prefer:

```
[engine-vm]# engine-setup
```

![](uarwo36-engine-setup.png)

Go through the engine-setup script, answering its questions. For the most part, you'll be fine accepting the default answers, but opt out of creating an NFS share for the ISO domain. We'll be creating a Gluster-backed domain for our ISO images in a bit.

![](uarwo36-config-preview.png)

When the installation process completes, head back to the terminal where you're running the hosted engine installer and hit enter to indicate that the engine configuration is complete.

The installer will register itself as a virtualization host on the oVirt engine instance we've just installed.

![](uarwo36-connect-engine.png)

Once this completes, the installer will tell you to shut down your VM so that the ovirt-engine-ha services on the first host can restart the engine VM as a monitored service.

```
[engine-vm]# poweroff
```

### Configuring Hosts Two and Three

Once the engine is back up and available, head to your **second** machine to configure it as a second host for our oVirt management server:


````
[host-two]# screen
[host-two]# hosted-engine --deploy
````

As with the first machine, the script will ask for the storage type we wish to use. Just as before, answer `glusterfs`and then provide the information for your gluster volume, just as on host one.

After accessing your storage, the script will detect that there's an existing hosted engine instance, and ask whether you're setting up an additional host. Answer yes, and when the script asks for a Host ID, make it `2`. The script will then ask for the IP address and root password of your first host, in order to access the rest of the settings it needs.

When the installation process completes, head over to your **third machine** and perform the same steps you did w/ your second host, substituting `3` for the Host ID.

Once that process is complete, the script will exit and you should be ready to configure storage and run a VM.

## Configuring storage

Head to your oVirt engine console at the address of your hosted engine VM, log in with the user name `admin` and the password you chose during setup, and visit the "Storage" tab in the console.

Click "New Domain," give your new domain a name, and choose "Data" and "GlusterFS" from the "Domain Function" and "Storage Type" drop down menus. (If you're using a different sort of external storage, you can choose an option matching that, instead.)

In the "Path" field, enter the remote path to your Gluster data volume (in my case, this is `glustermount:data`), and hit the OK button to proceed.

![](uarwo36-data-domain.png)

The export and iso domains, which oVirt uses, respectively, for import and export of VM images, and for storing iso images, can be set up in roughly the same way. Click "New Domain," choose Export or ISO from the "Domain Function" drop down, choose GlusterFS from the "Storage Type" drop down, give the domain a name, and fill in the correct "Path."

![](uarwo36-export-domain.png)

So far, we've created all of our Gluster-backed storage domains as replica 3 arbiter 1 volumes, which ensures that we can bring down one of our nodes at a time while keeping our storage available and consistent. There's a performance cost to replication, however, so I typically create one or more non-replicated Gluster volume-backed oVirt data domains, for times when I favor speed over availability.

Within an oVirt data center, it's easy to migrate VM storage from one data domain to another, so you can shuttle disks around as needed when it's time to bring one of your storage hosts down.

## Enabling Gluster management

Head over to the "Clusters" tab in the engine web admin console, right-click the "Default" cluster entry, and choose "Edit" from the context menu. Then, check the box next to "Enable Gluster Service," and hit the "OK" button. This will allow us to manage and view our Gluster volumes from within the web console. It will also prompt the engine to configure our host firewalls correctly the next time the hosts are reinstalled.

To complete this process, head to the "Hosts" tab, right-click on one of the hosts that isn't currently hosting the engine VM (if you've been following along, the VM should still be on hosted_engine_1), and choose "Maintenance" from the context menu. When the host is in maintenance mode, right-click again and choose "Reinstall" from the menu, and then hit "OK" in the following dialog box. The engine will run through its host installation process, which will include correctly configuring the firewall to allow for the operation both of oVirt and of Gluster.

When the host is back in "Up" status, repeat on the next engine VM-less host. When that host is reconfigured, head to the "Virtual Machines" tab, right-click on the HostedEngine VM, and choose "Migrate" from the context menu. When the hosted engine migration is complete, carry out the same "Reinstall" operation on the last host. Once this has finished, all three hosts will have their firewalls properly configured.

## Running your first VM

Since version 3.4, oVirt engine has come pre-configured with a public Glance instance managed by the oVirt project. We'll tap this resource to launch our first VM.

From the storage tab, you should see an "ovirt-image-repository" entry next to a little OpenStack logo. Clicking on this domain will bring up a menu of images available in this repository. Click on the "CirrOS" image (which is very small and perfect for testing) in the list and then click "Import," before hitting the OK button in the pop-up dialog to continue.

![](uarwo36-import-image.png)

The image will be copied from the oVirt project's public Glance repository to the storage domain you just configured, where it will be available as a disk to attach to a new VM. In the import image dialog, you have the option of clicking the "Import as Template" check box to give yourself the option of basing multiple future VMs on this image using oVirt's templates functionality.

Next, head to the "Virtual Machines" tab in the console, click "New VM," choose "Linux" from the "Operating System" drop down menu, supply a name for your VM, and choose the "ovirtmgmt/ovirtmgmt" network in the drop down menu next to "nic1." Then, click the "Attach" button under the "Instance Images" heading and check the radio button next to the CirrOS disk image you just imported before hitting the "OK" button to close the "Attach Virtual Disks" dialog, and hitting "OK" again to exit the "New Virtual Machine" dialog.

![](uarwo36-run-vm.png)

For additional configuration, such as setting RAM and CPU values and using cloud-init, there's a "Show Advanced Options" button in the dialog, but you can revisit that later.

Now, back at the Virtual Machines list, right-click your new VM, and choose "Run" from the menu. After a few moments, the status of your new VM will switch from red to green, and you'll be able to click on the green monitor icon next to “Migrate” to open a console window and access your VM.

## Storage network

I mentioned above that it's a good idea to set aside a separate storage network for Gluster traffic and for VM migration. If you've set up a separate network for Gluster traffic, you can bring it under oVirt's management by visiting the "Networks" tab in the web console, clicking "New," and giving your network a name before hitting "OK" to close the dialog.

![](uarwo36-storage-net.png)

Next, highlight the new network, and in the **bottom pane**, choose the "Hosts" tab, and then click the radio button next to "Unattached." One at a time, highlight each of your hosts, click on "Setup Host Networks," and drag the new network you created from the list of "Unassigned Logical Networks" to the interface you're already using for your Gluster traffic, before clicking OK.

![](uarwo36-storage-net-a.png)

Then, also in the **bottom pane**, choose the "Clusters" tab, right-click the "Default" cluster, and choose "Manage Network" from the context menu. Then check the "Migration Network" and "Gluster Network" boxes and hit the "OK" button to close the dialog.

![](uarwo36-storage-net-b.png)

## Maintenance, failover, and storage

The key thing to keep in mind regarding host maintainence and downtime is that this converged three node system relies on having at least two of the nodes up at all times. If you bring down two machines at once, you'll run afoul of the Gluster quorum rules that guard us from split-brain states in our storage, the volumes served by your remaining host will go read-only, and the VMs stored on those volumes will pause and require a shutdown and restart in order to run again.

You can bring a single machine down for maintenance by first putting the system into maintenance mode from the oVirt console, and updating, rebooting, shutting down, etc. as desired.

Putting a host into maintenance mode will also put that host's hosted engine HA services into local maintenance mode, rendering that host ineligible to take over engine-hosting duties. Previous versions of oVirt enabled administrators to toggle the hosted engine ha maintenance mode from the web admin, but that option appears to have been removed in oVirt 3.6.

To check on and modify hosted engine ha status, you need to head back to the command line to run `hosted-engine --vm-status`. If your host's "Local maintenance" status is "True," you can return it to engine-hosting preparedness with the command `hosted-engine --set-maintenance --mode=none`.

Also worth noting, if you want to bring down the engine service itself, you can put your whole trio of hosts into global maintenance mode, preventing them from attempting to restart the engine on their own, with the command `hosted-engine --set-maintenance --mode=global`.

## Till next time

If you run into trouble following this walkthrough, I’ll be happy to help you get up and running or get pointed in the right direction. On IRC, I’m jbrooks, ping me in the #ovirt room on OFTC or give me a shout on Twitter [@jasonbrooks](https://twitter.com/jasonbrooks).

If you’re interested in getting involved with the oVirt Project, you can find all the mailing list, issue tracker, source repository, and wiki information you need <a href="http://www.ovirt.org/Community">here</a>.
