---
title: Up and Running with oVirt 4.0 and Gluster Storage
author: jbrooks
date: 2016-08-26 17:46:00 UTC
tags: ovirt, gluster, centos
comments: true
published: true
---

In June, the oVirt Project [shipped version 4.0](/blog/2016/06/ovirt-40-release/) of its open source virtualization management system. With a new release comes an update to this howto for running oVirt together with Gluster storage using a trio of servers to provide for the system's virtualization and storage needs, in a configuration that allows you to take one of the three hosts down at a time without disrupting your running VMs.

One of the biggest new elements in this version of the howto is the introduction of [gdeploy](http://gdeploy.readthedocs.io/en/latest/), an Ansible based deployment tool that was initially written to install GlusterFS clusters, but that's grown to take on a bunch of complementary tasks. For this process, it'll save us a bunch of typing and speed things up significantly.

**Important Note:** I want to stress that while Red Hat has recently begun to sell and support a converged [virtualization and storage configuration](https://access.redhat.com/articles/2360321) on a limited basis, the converged oVirt/Gluster setup I describe here should be considered somewhat bleeding edge.

If you're looking instead for a simpler, single-machine option for trying out oVirt, your best bet is the <a href="http://www.ovirt.org/OVirt_Live">oVirt Live ISO</a>. This is a LiveCD image that you can burn onto a blank CD or copy onto a USB stick to boot from and run oVirt. This is probably the fastest way to get up and running, but once you're up, this is definitely a low-performance option, and not suitable for extended use or expansion.

READMORE

## oVirt, Glusterized

Read on to learn about my favored way of running oVirt.

### Prerequisites

__Hardware:__ You’ll need three machines with plenty of RAM and processors with [hardware virtualization extensions](http://en.wikipedia.org/wiki/X86_virtualization#Hardware-assisted_virtualization). Physical machines are best, but you can test oVirt using [nested KVM](http://community.redhat.com/blog/2013/08/testing-ovirt-3-3-with-nested-kvm/) as well. I've written this howto using VMs running on my "real" oVirt+Gluster install.

__Software:__ For this howto, I'm using CentOS 7 for both the host and the Engine VM. oVirt does support other OS options. For more info see the project's <a href="http://www.ovirt.org/download/">download page</a>.

__Network:__ Your test machine’s host name must resolve properly, either through your network’s DNS, or through the `/etc/hosts` file on your virt host(s), on the VM that will host the oVirt engine, and on any clients from which you plan on administering oVirt. It's not strictly necessary, but it's a good idea to set aside a separate storage network for Gluster traffic and for VM migration. In my lab, I use a separate 10G nic on each of the hosts for my storage network.

__Storage:__ The hosted engine feature requires NFS, iSCSI, FibreChannel or Gluster storage to house the VM that will host the engine. For this walkthrough, I'm using a Gluster arbiter volume, which involves creating a replica 3 Gluster volume with two standard data bricks and a third arbiter brick that stores only file names and metadata, thereby providing an oVirt hosted engine setup with the data consistency it requires, while cutting down significantly on duplicated data and network traffic.

### Installing oVirt with Hosted Engine

I'm starting out with three test machines with 32 GB of RAM and 4 processor cores, running a minimal installation of CentOS 7 with all updates applied. I actually do the testing for this howto in VMs hosted on my "real" oVirt setup, but that "real" setup closely resembles what I describe below.

I've identified a quartet of static IP address on my network to use for this test (three for my virt hosts, and one for the hosted engine). In addition, I'm using three other static IPs, on a different network, for Gluster storage. I've set up the DNS server in my lab to make these IPs resolve properly, but you can also edit the /etc/hosts files on your test machines for this purpose.

As I mentioned up top, I'm using gdeploy to automate some of this process. I couldn't find an rpm for gdeploy, so I built one with [Fedora's Copr service](https://copr.fedorainfracloud.org/coprs/jasonbrooks/gdeploy/), using the [2.0 branch of gdeploy](https://github.com/gluster/gdeploy/tree/2.0). You'll also need ansible, which is available from [EPEL](https://fedoraproject.org/wiki/EPEL), and a gdeploy config file.

I'm running gdeploy from my first host:

```
[host1]# yum install -y epel-release

[host1]# yum install -y https://copr-be.cloud.fedoraproject.org/results/jasonbrooks/gdeploy/epel-7-x86_64/00442607-gdeploy/gdeploy-2.0-0.noarch.rpm

[host1]# curl -O https://gist.githubusercontent.com/jasonbrooks/a5484769eea5a8cf2fa9d32329d5ebe5/raw/ovirt-gluster.conf
```

Our host1 will need to be able to access itself and the other two nodes via passwordless ssh:

```
[host1]# ssh-keygen

[host1]# ssh-copy-id root@$HOST1

[host1]# ssh-copy-id root@$HOST2

[host1]# ssh-copy-id root@$HOST3
```

Next, make some edits to the `ovirt-gluster.conf` file we fetched earlier. Change all instances of host1, host2, host3 to match the IP addresses of your own hosts. Also, in the `[lv2]` section, you'll want to change the `size=` of the thin pool for ovirt's data volumes to a larger value appropriate to the amount of space available for these images on your hosts.

Now, we can run gdeploy:

```
[host1]# gdeploy -c ovirt-gluster.conf
```

This process will take some time to complete, as gdeploy installs required packages and configures gluster volumes and their underlying storage.

## Installing the Hosted Engine (Run on host one)

In previous versions of this howto, I grappled with different ways of ensuring that the mount address we use for our engine VM would remain available when any one of our three hosts went down. It turns out that there's a great solution for this built into gluster, the `backup-volfile-servers` mount option. The hosted engine deploy script doesn't ask about this on its own, though, so we need to pass it as a `--config-append` option when we run the script:

```
[host1]# curl -O https://gist.githubusercontent.com/jasonbrooks/97820c486eb52bd92a08dfd2f1f508ef/raw/storage.conf

# now change the above file to match your host1, host2, host3 IP addresses
```
Fire up `screen` (this comes in handy in case of network interruption), kick off the installation process, and begin answering the installers, answering questions.

```
[host1]# screen

[host1]# hosted-engine --deploy --config-append=storage.conf
```

#### Storage Configuration

Here you need to specifiy the `glusterfs` storage type, and supply the path to your Gluster volume.

![](uarwo40-storage-configuration.png)

#### Network Configuration

Next, we need to specify which network interface to use for oVirt's management network, and whether the installer should configure our firewall. Decline the firewall configuration offer for now.

![](uarwo40-network-config.png)

#### VM Configuration

Now, we answer a set of questions related to the virtual machine that will serve the oVirt engine application. First, we tell the installer to use the oVirt Engine Appliance image that we downloaded earlier:

![](uarwo40-vm-config.png)

Then, we configure cloud-init to customize the appliance on its initial boot, providing host name and network configuration information. We can configure the VM to kick off the engine setup process automatically, but I've found that making this choice has left me without the option to enable Gluster volume management in my oVirt cluster, so we'll run that installer separately in a bit.

The next part of the installer prompts you to choose the number of virtual CPUs and RAM for your engine VM. The optimal amount of RAM is 16GB, and the recommended minimum is 4GB.

Once you've supplied all these answers, and confirmed your choices, the installer will configure the host for virtualization, set up a storage domain, upload the appliance image to that domain, and then launch the engine VM.

Next, the installer will provide you with an address and password for accessing the VM with the vnc client of your choice. You can fire up a vnc client, enter the address provided and enter the password provided to access the VM, or you can access your engine VM via ssh using the hostname you chose above, which is what I prefer:

```
[engine-vm]# engine-setup
```

![](uarwo40-engine-setup.png)

Go through the engine-setup script, answering its questions. For the most part, you'll be fine accepting the default answers, but opt out of creating an NFS share for the ISO domain. We'll be creating a Gluster-backed domain for our ISO images in a bit. In oVirt 4.0, the data warehouse component is no longer optional -- you can deploy it alongside the engine (this is what I've done) or separately.

![](uarwo40-config-preview.png)

When the installation process completes, open a web browser and visit your oVirt engine administration portal at the address of your hosted engine VM. Log in with the user name `admin` and the password you chose during setup, head over to the "Clusters" tab in the engine web admin console, right-click the "Default" cluster entry, and choose "Edit" from the context menu. Then, check the box next to "Enable Gluster Service," and hit the "OK" button.

![](uarwo40-edit-cluster.png)

Then head back to the terminal where you're running the hosted engine installer.

Before hitting enter to proceed with the process, make sure that your host1 can ping the engine VM. I've encountered cases where, following setup of the ovirtmgmt bridge, my host's dns configuration has been disrupted. The screen command comes in handy here: you can hit `Ctrl-a` and then `d` to detach, test ping and modify `/etc/resolv.conf` if needed, and then run `screen -r` to reattach.

Hit enter to indicate that the engine configuration is complete. The installer will register itself as a virtualization host on the oVirt engine instance we've just installed.

![](uarwo40-connect-engine.png)

Once this completes, the installer will tell you to shut down your VM so that the ovirt-engine-ha services on the first host can restart the engine VM as a monitored service.

```
[engine-vm]# poweroff
```

### Configuring Hosts Two and Three

Once the engine is back up and available, head to your **second** machine to configure it as a second host for our oVirt management server:

````
[host2]# screen

[host2]# hosted-engine --deploy
````

As with the first machine, the script will ask for the storage type we wish to use. Just as before, answer `glusterfs`and then provide the information for your gluster volume, just as on host one.

After accessing your storage, the script will detect that there's an existing hosted engine instance, and ask whether you're setting up an additional host. Answer yes, and when the script asks for a Host ID, make it `2`. The script will then ask for the IP address and root password of your first host, in order to access the rest of the settings it needs.

When the installation process completes, head over to your **third machine** and perform the same steps you did w/ your second host, substituting `3` for the Host ID.

Once that process is complete, the script will exit and you should be ready to configure storage and run a VM.

## Configuring Storage

Head to your oVirt engine console at the address of your hosted engine VM, log in with the user name `admin` and the password you chose during setup, and visit the "Storage" tab in the console.

Click "New Domain," give your new domain a name, and choose "Data" and "GlusterFS" from the "Domain Function" and "Storage Type" drop down menus. (If you're using a different sort of external storage, you can choose an option matching that, instead.)

In the "Path" field, enter the remote path to your Gluster data volume, using the address $HOST1:data. In the mount options field, enter `backup-volfile-servers=$HOST2:$HOST3`, and hit the OK button to proceed.

![](uarwo40-data-domain.png)

The export and iso domains, which oVirt uses, respectively, for import and export of VM images, and for storing iso images, can be set up in roughly the same way. Click "New Domain," choose Export or ISO from the "Domain Function" drop down, choose GlusterFS from the "Storage Type" drop down, give the domain a name, fill in the correct "Path," and provide the `backup-volfile-servers` mount option.

So far, we've created all of our Gluster-backed storage domains as replica 3 arbiter 1 volumes, which ensures that we can bring down one of our nodes at a time while keeping our storage available and consistent. There's a performance cost to replication, however, so I typically create one or more non-replicated Gluster volume-backed oVirt data domains, for times when I favor speed over availability.

In this howto, I set up all four of our gluster volumes using gdeploy, which didn't allow me to specificy which node to task with the arbiter duties. As a result, host 3 is the arbiter for all four volumes. You might attempt to balance things out by creating a single-node volume on host 3, but I'll leave this as an exercise for the reader.

Within an oVirt data center, it's easy to migrate VM storage from one data domain to another, so you can shuttle disks around as needed when it's time to bring one of your storage hosts down.

## Running your First VM

Since version 3.4, oVirt engine has come pre-configured with a public Glance instance managed by the oVirt project. We'll tap this resource to launch our first VM.

From the storage tab, you should see an "ovirt-image-repository" entry next to a little OpenStack logo. Clicking on this domain will bring up a menu of images available in this repository. Click on the "CirrOS" image (which is very small and perfect for testing) in the list and then click "Import," before hitting the OK button in the pop-up dialog to continue.

![](uarwo40-import-image.png)

The image will be copied from the oVirt project's public Glance repository to the storage domain you just configured, where it will be available as a disk to attach to a new VM. In the import image dialog, you have the option of clicking the "Import as Template" check box to give yourself the option of basing multiple future VMs on this image using oVirt's templates functionality.

Next, head to the "Virtual Machines" tab in the console, click "New VM," choose "Linux" from the "Operating System" drop down menu, supply a name for your VM, and choose the "ovirtmgmt/ovirtmgmt" network in the drop down menu next to "nic1." Then, click the "Attach" button under the "Instance Images" heading and check the radio button next to the CirrOS disk image you just imported before hitting the "OK" button to close the "Attach Virtual Disks" dialog, and hitting "OK" again to exit the "New Virtual Machine" dialog.

For additional configuration, such as setting RAM and CPU values and using cloud-init, there's a "Show Advanced Options" button in the dialog, but you can revisit that later.

Now, back at the Virtual Machines list, right-click your new VM, and choose "Run" from the menu. After a few moments, the status of your new VM will switch from red to green, and you'll be able to click on the green monitor icon next to “Migrate” to open a console window and access your VM.

## Storage Network

I mentioned above that it's a good idea to set aside a separate storage network for Gluster traffic and for VM migration. If you've set up a separate network for Gluster traffic, you can bring it under oVirt's management by visiting the "Networks" tab in the web console, clicking "New," and giving your network a name before hitting "OK" to close the dialog.

![](uarwo40-storage-net.png)

Next, highlight the new network, and in the **bottom pane**, choose the "Hosts" tab, and then click the radio button next to "Unattached." One at a time, highlight each of your hosts, click on "Setup Host Networks," and drag the new network you created from the list of "Unassigned Logical Networks" to the interface you're already using for your Gluster traffic, before clicking OK. Clicking the pencil icon in the network brings up an "Edit Network storage" dialog where you can configure the boot protocol and other configuration details.

![](uarwo40-storage-net-a.png)

Then, also in the **bottom pane**, choose the "Clusters" tab, right-click the "Default" cluster, and choose "Manage Network" from the context menu. Then check the "Migration Network" and "Gluster Network" boxes and hit the "OK" button to close the dialog.

![](uarwo40-storage-net-b.png)

## Maintenance, Failover, and Storage

The key thing to keep in mind regarding host maintainence and downtime is that this converged three node system relies on having at least two of the nodes up at all times. If you bring down two machines at once, you'll run afoul of the Gluster quorum rules that guard us from split-brain states in our storage, the volumes served by your remaining host will go read-only, and the VMs stored on those volumes will pause and require a shutdown and restart in order to run again.

You can bring a single machine down for maintenance by first putting the system into maintenance mode from the oVirt console, and updating, rebooting, shutting down, etc. as desired.

Putting a host into maintenance mode will also put that host's hosted engine HA services into local maintenance mode, rendering that host ineligible to take over engine-hosting duties.

To check on and modify hosted engine ha status, you can head back to the command line to run `hosted-engine --vm-status`. If your host's "Local maintenance" status is "True," you can return it to engine-hosting preparedness with the command `hosted-engine --set-maintenance --mode=none`.

Also worth noting, if you want to bring down the engine service itself, you can put your whole trio of hosts into global maintenance mode, preventing them from attempting to restart the engine on their own, with the command `hosted-engine --set-maintenance --mode=global`. You can also enable and disable global maintenance mode by left-clicking on the Hosted Engine VM in the web admin console.

## 'Til Next Time

If you run into trouble following this walkthrough, I’ll be happy to help you get up and running or get pointed in the right direction. On IRC, I’m jbrooks, ping me in the #ovirt channel on OFTC or give me a shout on Twitter [@jasonbrooks](https://twitter.com/jasonbrooks).

If you’re interested in getting involved with the oVirt Project, you can find all the mailing list, issue tracker, source repository, and wiki information you need <a href="http://www.ovirt.org/community">here</a>.
