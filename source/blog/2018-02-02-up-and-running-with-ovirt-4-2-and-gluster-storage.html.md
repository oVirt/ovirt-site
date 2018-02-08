---
title: Up and Running with oVirt 4.2 and Gluster Storage
author: jbrooks
date: 2018-02-02 20:45:55 UTC
published: true
---

In December, the oVirt Project [shipped version 4.2](https://ovirt.org/blog/2017/12/ovirt-4.2.0-now-ga/) of its open source virtualization management system. With a new release comes an update to this howto for running oVirt together with Gluster storage using a trio of servers to provide for the system's virtualization and storage needs, in a configuration that allows you to take one of the three hosts down at a time without disrupting your running VMs.

If you're looking instead for a simpler, single-machine option for trying out oVirt, your best bet is the [oVirt Live ISO](/download/ovirt-live) page. This is a LiveCD image that you can burn onto a blank CD or copy onto a USB stick to boot from and run oVirt. This is probably the fastest way to get up and running, but once you're up, this is definitely a low-performance option, and not suitable for extended use or expansion.

Read on to learn about my favorite way of running oVirt.

READMORE

## oVirt, Glusterized

### Prerequisites

__Hardware:__ You’ll need three machines with 16GB or more of RAM and processors with [hardware virtualization extensions](http://en.wikipedia.org/wiki/X86_virtualization#Hardware-assisted_virtualization). Physical machines are best, but you can test oVirt using [nested KVM](http://community.redhat.com/blog/2013/08/testing-ovirt-3-3-with-nested-kvm/) as well. I've written this howto using VMs running on my "real" oVirt+Gluster install.

__Software:__ For this howto, I'm using [oVirt Node 4.2](https://www.ovirt.org/node/), a streamlined operating system image based on CentOS 7, for my three hosts, and a CentOS-based appliance image for the Engine VM. oVirt does support other OS options. For more info see the project's <a href="http://www.ovirt.org/download/">download page</a>.

__Network:__ Your test machine’s host name must resolve properly, either through your network’s DNS, or through the `/etc/hosts` file on your virt host(s), on the VM that will host the oVirt engine, and on any clients from which you plan on administering oVirt. It's not strictly necessary, but it's a good idea to set aside a separate storage network for Gluster traffic and for VM migration. In my lab, I use a separate 10G nic on each of the hosts for my storage network.

__Storage:__ The hosted engine feature requires NFS, iSCSI, FibreChannel or Gluster storage to house the VM that will host the engine. For this walkthrough, I'm using a Gluster arbiter volume, which involves creating a replica 3 Gluster volume with two standard data bricks and a third arbiter brick that stores only file names and metadata, thereby providing an oVirt hosted engine setup with the data consistency it requires, while cutting down significantly on duplicated data and network traffic.

### Installing oVirt with hosted engine

I'm starting out with three test machines with 16 GB of RAM and 4 processor cores, running oVirt Node 4.2. I actually do the testing for this howto in VMs hosted on my "real" oVirt setup, but that "real" setup resembles what I describe below.

I've identified a quartet of static IP address on my network to use for this test (three for my virt hosts, and one for the hosted engine). I've set up the DNS server in my lab to make these IPs resolve properly, but you can also edit the /etc/hosts files on your test machines for this purpose.

Our host1 will need to be able to access itself and the other two nodes via passwordless ssh:

```
[host1]# ssh-keygen

[host1]# ssh-copy-id root@$HOST1

[host1]# ssh-copy-id root@$HOST2

[host1]# ssh-copy-id root@$HOST3
```

Next, open up a web browser and visit your first host at port 9090 to access the cockpit web interface. Log in with the machine's root account, click the "Virtualization" tab at the left of the screen, and then click the "Hosted Engine" link in the left sidebar. Select the radio button next to "Hosted Engine with Gluster" and hit the "Start" button.

![](uarwo42-cockpit-1.png)

oVirt Node ships with an Ansible-based Gluster deployment tool called [gdeploy](http://gdeploy.readthedocs.io/en/latest/). The dialog window that appears contains a series of steps through which you provide gdeploy with the information it needs to configure your three nodes for running ovirt with gluster storage, starting with the hosts you want to configure.

![](uarwo42-gdeploy-1.png)

Click next to accept the defaults in step two, and then in step three, specify the gluster volumes you want to create. The cockpit gdeploy plugin autofills some values here, including a volume for the engine, a data volume, and a second data volume called vmstore. At this point, you can choose whether to make some or your volumes [arbiter volumes](http://docs.gluster.org/en/latest/Administrator%20Guide/arbiter-volumes-and-quorum/), in which the first two nodes contain a full replica of your data, and the third node contains just enough information to arbitrate between the two other nodes when they disagree with each other.

![](uarwo42-gdeploy-2.png)

Click "Next" to hit step four, where we'll specify the brick locations for our volumes. Again, the plugin prefills some values here, which aren't likely to be correct for your environment, so pay close attention here. In my test environment, I'm using one additional disk for my gluster data, `/dev/sdb`, and I'm specifying one brick per host per volume:

![](uarwo42-gdeploy-3.png)

Finally, hit "Deploy" to kick off the deployment process. In some of my tests, I received a "deployment failed" error, and had to click the "redeploy" button before the deployment would proceed. Once underway, the process will take some time to complete, as gdeploy configures your gluster volumes and their underlying storage.

![](uarwo42-gdeploy-4.png)

At the end of the process, you'll see a green check mark, and the message "Successfully deployed Gluster."

![](uarwo41-gdeploy-6.png)

### Hosted engine setup

Once gdeploy is finished, click the "Continue to Hosted Engine Deployment" button to begin configuring your hosted engine. Provide hostname, domain, network configuration, password, and, if desired, ssh key information for your hosted engine virtual machine.

Then, we'll answer a set of questions related to the virtual machine that will serve the oVirt engine application. First, we tell the installer to use the oVirt Engine Appliance image that gdeploy installed for us. Then, we configure cloud-init to customize the appliance on its initial boot, providing various VM configuration details covering networking, VM RAM and storage amounts, and authentication. Enter the details appropriate to your environment, and when the installer asks whether to automatically execute engine-setup on the engine appliance on first boot, answer yes. Here's what the configuration on my test instance looked like:

![](uarwo42-he-1.png)

Nest, supply an admin password for the engine instance, and customize your notification server details.

![](uarwo42-he-2.png)

The correct details for the storage portion of the setup process should auto-populate.CK The engine VM will be stored on one of the gluster volumes we configured via gdeploy, with backup volfile servers specified for failover when our first node is unavailable.

![](uarwo42-he-3.png)

You should be able to accept the default values in the networking step, which configures the management bridge used by oVirt.

![](uarwo42-he-4.png)

In step five, you can review your engine VM configuration and click backward to make any changes you require.

![](uarwo42-he-5.png)

In the next four steps, the installer will offer to download the engine appliance, prompt you to accept the GPG key with which the appliance is signed, ask whether you wish to configure your engine to manage gluster volumes, and give you the opportunity to specify an alternate appliance image. 

You can accept the default values in all four steps, but I prefer to answer "Yes" when asked whether to configure the host and cluster for gluster:

![](uarwo42-he-5c.png)

Once you've finished clicking through the hosted engine installer, you'll have a configured VM running on your first host, with storage supplied by gluster, and an instance of the oVirt engine up and running on the VM.

![](uarwo42-he-5e.png)

## Access the engine

When the installation process completes, open a web browser and visit your oVirt engine administration portal at the address of your hosted engine VM. Log in with the user name `admin` and the password you chose during setup.

![](uarwo42-engine-1.png)

Next, check out the navigation bar on the left of the screen, and click Compute --> Clusters --> Default. Under the heading "Action Items," you should see text that reads "Some new hosts are detected in the cluster. You can Import them to engine or Detach them from the cluster." Click "Import," and in the dialog window that appears, provide passwords for your two hosts, and hit OK.

## Configuring storage

Once that completes, head to the left navigation bar again and click Storage --> Domains --> New Domain. Give your new domain a name, and choose "Data" and "GlusterFS" from the "Domain Function" and "Storage Type" drop down menus. Check the box marked "Use managed gluster," and from the drop down box that appears, choose your "data" volume, and hit the OK button to proceed.

![](uarwo42-data-domain.png)

## Configuring hosts two and three for Hosted Engine

From the left navigation bar, click Compute --> Hosts, select host two, and in the toolbar toward the right of the screen, click Management, and then Maintenance, and hit OK in the dialog box that appears next. Once the host is in maintenance mode, click Installation, and then Reinstall in the toolbar. In the dialog that appears next, click "Hosted Engine," and then, in the drop down box, choose DEPLOY, and hit OK. After that process completes, repeat the process on host three.

![](uarwo42-deploy-hosted.png)

Once all three hosts are back up, you should be able to put any one of them into maintenance mode and then upgrade or restart that host without losing access to the management engine, other VMs, or your VM storage.

## Running your first VM

oVirt engine comes pre-configured with a public Glance instance managed by the oVirt project. We'll tap this resource to launch our first VM.

From the left navigation bar, click Storage --> Domains, and you should see an "ovirt-image-repository" entry next to a little OpenStack logo. Clicking on this domain will bring up a menu of images available in this repository. Click on the "CirrOS" image (which is very small and perfect for testing) in the list and then click "Import," before hitting the OK button in the pop-up dialog to continue.

![](uarwo42-import-image.png)

The image will be copied from the oVirt project's public Glance repository to the storage domain you just configured, where it will be available as a disk to attach to a new VM. In the import image dialog, you have the option of clicking the "Import as Template" check box to give yourself the option of basing multiple future VMs on this image using oVirt's templates functionality.

Next, head to Compute --> Virtual Machines, click "New," choose "Linux" from the "Operating System" drop down menu, supply a name for your VM, and choose the "ovirtmgmt/ovirtmgmt" network in the drop down menu next to "nic1." Then, click the "Attach" button under the "Instance Images" heading and check the radio button next to the CirrOS disk image you just imported before hitting the "OK" button to close the "Attach Virtual Disks" dialog, and hitting "OK" again to exit the "New Virtual Machine" dialog.

For additional configuration, such as setting RAM and CPU values and using cloud-init, there's a "Show Advanced Options" button in the dialog, but you can revisit that later.

Now, back at the Virtual Machines list, right-click your new VM, and choose "Run" from the menu. After a few moments, the status of your new VM will switch from red to green, and you'll be able to click on the green monitor icon next to “Migrate” to open a console window and access your VM.

## Storage network

I mentioned above that it's a good idea to set aside a separate storage network for Gluster traffic and for VM migration. If you've set up a separate network for Gluster traffic, you can bring it under oVirt's management by visiting Network --> Networks, clicking "New," and giving your network a name before hitting "OK" to close the dialog.

![](uarwo42-storage-net.png)

Next, click on the new network, choose the "Hosts" toolbar item, and then click the "Unattached" button. One at a time, highlight each of your hosts, click on "Setup Host Networks," and drag the new network you created from the list of "Unassigned Logical Networks" to the interface you're already using for your Gluster traffic, before clicking OK. Clicking the pencil icon in the network brings up an "Edit Network storage" dialog where you can configure the boot protocol and other configuration details.

![](uarwo42-storage-net-a.png)

Then, choose the "Clusters" toolbar item, right-click the "Default" cluster, and choose "Manage Network" from the context menu. Then check the "Migration Network" and "Gluster Network" boxes and hit the "OK" button to close the dialog. This will instruct oVirt to send gluster and migration traffic over your storage network.

![](uarwo42-storage-net-b.png)

## Maintenance, failover, and storage

The key thing to keep in mind regarding host maintenance and downtime is that this converged three node system relies on having at least two of the nodes up at all times. If you bring down two machines at once, you'll run afoul of the Gluster quorum rules that guard us from split-brain states in our storage, the volumes served by your remaining host will go read-only, and the VMs stored on those volumes will pause and require a shutdown and restart in order to run again.

The oVirt engine pays attention to the state of its configured gluster volumes, and will warn you if certain actions will run afoul of quorum rules or if your volumes have pending healing operations.

You can bring a single machine down for maintenance by first putting the system into maintenance mode from the oVirt console by clicking on the host entry in the Hosts tab, and then clicking Management, and then Maintenance, before updating, rebooting, shutting down, etc. as desired.

Putting a host into maintenance mode will also put that host's hosted engine HA services into local maintenance mode, rendering that host ineligible to take over engine-hosting duties.

If you want to bring down the engine service itself, you can put your whole trio of hosts into global maintenance mode, preventing them from attempting to restart the engine on their own, by left-clicking on the Hosted Engine VM in the web admin console and enabling global maintenance mode.

## Till next time

If you run into trouble following this walkthrough, I’ll be happy to help you get up and running or get pointed in the right direction. On IRC, I’m jbrooks, ping me in the #ovirt room on OFTC or give me a shout on Twitter [@jasonbrooks](https://twitter.com/jasonbrooks).

If you’re interested in getting involved with the oVirt Project, you can find all the mailing list, issue tracker, source repository, and wiki information you need <a href="http://www.ovirt.org/community">here</a>.
