---
title: Up and Running with oVirt 4.1 and Gluster Storage
author: jbrooks
date: 2017-02-21 08:00:00 UTC
tags: centos, gluster, ovirt, hyperconverged
comments: true
published: true
---

Earlier this month, the oVirt Project [shipped version 4.1](https://www.ovirt.org/release/4.1.0/) of its open source virtualization management system. With a new release comes an update to this howto for running oVirt together with Gluster storage using a trio of servers to provide for the system's virtualization and storage needs, in a configuration that allows you to take one of the three hosts down at a time without disrupting your running VMs.

**Important Note:** I want to stress that while Red Hat has recently begun to sell and support a converged [virtualization and storage configuration](https://access.redhat.com/articles/2360321) on a limited basis, the converged oVirt/Gluster setup I describe here should be considered somewhat bleeding edge.

If you're looking instead for a simpler, single-machine option for trying out oVirt, your best bet is the <a href="http://www.ovirt.org/OVirt_Live">oVirt Live ISO</a>. This is a LiveCD image that you can burn onto a blank CD or copy onto a USB stick to boot from and run oVirt. This is probably the fastest way to get up and running, but once you're up, this is definitely a low-performance option, and not suitable for extended use or expansion.

Read on to learn about my favored way of running oVirt.

READMORE

## oVirt, Glusterized

### Prerequisites

__Hardware:__ You’ll need three machines with plenty of RAM and processors with [hardware virtualization extensions](http://en.wikipedia.org/wiki/X86_virtualization#Hardware-assisted_virtualization). Physical machines are best, but you can test oVirt using [nested KVM](http://community.redhat.com/blog/2013/08/testing-ovirt-3-3-with-nested-kvm/) as well. I've written this howto using VMs running on my "real" oVirt+Gluster install.

__Software:__ For this howto, I'm using CentOS 7 for both the host and the Engine VM. oVirt does support other OS options. For more info see the project's <a href="http://www.ovirt.org/download/">download page</a>.

__Network:__ Your test machine’s host name must resolve properly, either through your network’s DNS, or through the `/etc/hosts` file on your virt host(s), on the VM that will host the oVirt engine, and on any clients from which you plan on administering oVirt. It's not strictly necessary, but it's a good idea to set aside a separate storage network for Gluster traffic and for VM migration. In my lab, I use a separate 10G nic on each of the hosts for my storage network.

__Storage:__ The hosted engine feature requires NFS, iSCSI, FibreChannel or Gluster storage to house the VM that will host the engine. For this walkthrough, I'm using a Gluster arbiter volume, which involves creating a replica 3 Gluster volume with two standard data bricks and a third arbiter brick that stores only file names and metadata, thereby providing an oVirt hosted engine setup with the data consistency it requires, while cutting down significantly on duplicated data and network traffic.

### Installing oVirt with hosted engine

I'm starting out with three test machines with 16 GB of RAM and 4 processor cores, running a minimal installation of CentOS 7 with all updates applied. I actually do the testing for this howto in VMs hosted on my "real" oVirt setup, but that "real" setup resembles what I describe below.

I've identified a quartet of static IP address on my network to use for this test (three for my virt hosts, and one for the hosted engine). I've set up the DNS server in my lab to make these IPs resolve properly, but you can also edit the /etc/hosts files on your test machines for this purpose.

I'm using [gdeploy](http://gdeploy.readthedocs.io/en/lates) to automate some of the setup  process. You'll also need ansible, which is available from [EPEL](https://fedoraproject.org/wiki/EPEL), and a gdeploy config file. Once gdeploy is installed, we'll disable EPEL again, due to a conflict between the version of collectd included in EPEL and the version required by oVirt. If you don't want to remove EPEL, you can add `excludepkgs=collectd*` to your `epel.repo` file instead.

I'm running gdeploy from my first host:

```
[host1]# yum install -y epel-release

[host1]# yum install -y https://download.gluster.org/pub/gluster/gdeploy/LATEST/CentOS7/gdeploy-2.0.1-9.noarch.rpm

[host1]# yum remove -y epel-release

[host1]# curl -O https://gist.githubusercontent.com/jasonbrooks/a5484769eea5a8cf2fa9d32329d5ebe5/raw/3075160aa28065d500c47ef8053f79aa79d71ecd/ovirt-gluster.conf
```

Our host1 will need to be able to access itself and the other two nodes via passwordless ssh:

```
[host1]# ssh-keygen

[host1]# ssh-copy-id root@$HOST1

[host1]# ssh-copy-id root@$HOST2

[host1]# ssh-copy-id root@$HOST3
```

Next, make some edits to the `ovirt-gluster.conf` file we fetched earlier. Change all instances of host1, host2, host3 to match the IP addresses of your own hosts. Also, in the `[lv2]` section, you'll want to change the `size=` of the thin pool for ovirt's data volumes to a larger value appropriate to the amount of space available for these images on your hosts.

**Due to an issue that's fixed in gdeploy master, but present in the linked rpm, run the following two commands before proceeding to run gdeploy:**

```
[host1]# sed -i 's/from gdeploylib import defaults, Helpers/from gdeploylib import defaults, Helpers, Global/' /usr/lib/python2.7/site-packages/gdeployfeatures/pv/pv.py
[host1]# sed -i 's/from gdeploylib import Helpers/from gdeploylib import Helpers, Global/' /usr/lib/python2.7/site-packages/gdeployfeatures/script/script.py
```

Now, we can run gdeploy:


```
[host1]# gdeploy -c ovirt-gluster.conf
```

This process will take some time to complete, as gdeploy installs required packages and configures gluster volumes and their underlying storage.

## Installing the hosted engine (run on host one)

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

#### Storage configuration

Here you need to specifiy the `glusterfs` storage type, and supply the path to your Gluster volume.

```
[root@ovirt-1 ~]# hosted-engine --deploy --config-append=storage.conf
[ INFO  ] Stage: Initializing
[ INFO  ] Generating a temporary VNC password.
[ INFO  ] Stage: Environment setup
          During customization use CTRL-D to abort.
          Continuing will configure this host for serving as hypervisor and create a VM where you have to install the engine afterwards.
          Are you sure you want to continue? (Yes, No)[Yes]:
[ INFO  ] Hardware supports virtualization
          Configuration files: ['/root/storage.conf']
          Log file: /var/log/ovirt-hosted-engine-setup/ovirt-hosted-engine-setup-20170217181534-ueerz0.log
          Version: otopi-1.6.0 (otopi-1.6.0-1.el7.centos)
[ INFO  ] Detecting available oVirt engine appliances
[ INFO  ] Stage: Environment packages setup
[ INFO  ] Stage: Programs detection
[ INFO  ] Stage: Environment setup
[ INFO  ] Stage: Environment customization

          --== STORAGE CONFIGURATION ==--

          Please specify the storage you would like to use (glusterfs, iscsi, fc, nfs3, nfs4)[nfs3]: glusterfs
[ INFO  ] Please note that Replica 3 support is required for the shared storage.
[ INFO  ] GlusterFS replica 3 Volume detected
[ INFO  ] GlusterFS replica 3 Volume detected

```

#### Network configuration

Next, we need to specify which network interface to use for oVirt's management network, and whether the installer should configure our firewall. Decline the firewall configuration offer for now.

```
--== HOST NETWORK CONFIGURATION ==--

iptables was detected on your computer, do you wish setup to configure it? (Yes, No)[Yes]: No
Please indicate a pingable gateway IP address [10.10.171.254]:
Please indicate a nic to set ovirtmgmt bridge on: (eth1, eth0) [eth1]: eth0
```

#### VM configuration

Now, we answer a set of questions related to the virtual machine that will serve the oVirt engine application. First, we tell the installer to use the oVirt Engine Appliance image that gdeploy installed for us:

```
--== VM CONFIGURATION ==--

The following appliance have been found on your system:
      [1] - The oVirt Engine Appliance image (OVA) - 4.1-20170201.1.el7.centos
      [2] - Directly select an OVA file
Please select an appliance (1, 2) [1]:
```

Then, we configure cloud-init to customize the appliance on its initial boot, providing various VM configuration details covering networking, VM RAM and storage amounts, and authentication. Enter the details appropriate to your environment, and when the installer asks whether to automatically execute engine-setup on the engine appliance on first boot, answer yes. Here's what the configuration on my test instance looked like:

```
--== CONFIGURATION PREVIEW ==--

Bridge interface                   : eth0
Engine FQDN                        : engine.osas.lab
Bridge name                        : ovirtmgmt
Host address                       : ovirt-1.osas.lab
SSH daemon port                    : 22
Gateway address                    : 10.10.171.254
Storage Domain type                : glusterfs
Image size GB                      : 25
Host ID                            : 1
Storage connection                 : ovirt-1.osas.lab:/engine
Console type                       : vnc
Memory size MB                     : 4096
MAC address                        : 00:16:3e:78:20:9d
Number of CPUs                     : 4
OVF archive (for disk boot)        : /usr/share/ovirt-engine-appliance/ovirt-engine-appliance-4.1-20170201.1.el7.centos.ova
Appliance version                  : 4.1-20170201.1.el7.centos
Restart engine VM after engine-setup: True
Engine VM timezone                 : America/New_York
CPU Type                           : model_SandyBridge
```

Once you've supplied all these answers, and confirmed your choices, the installer will configure the host for virtualization, set up a storage domain, upload the appliance image to that domain, launch the engine VM, and then configure the engine service within that VM.

When the installation process completes, open a web browser and visit your oVirt engine administration portal at the address of your hosted engine VM. Log in with the user name `admin` and the password you chose during setup, head over to the "Clusters" tab in the engine web admin console, right-click the "Default" cluster entry, and choose "Edit" from the context menu. Then, check the box next to "Enable Gluster Service," and hit the "OK" button. 

![](uarwo41-edit-cluster.png)

Next, check out the bottom pane of the Clusters tab, where you should see the Action Item: "Some new hosts are detected in the cluster. You can Import them to engine or Detach them from the cluster." Click "Import," and in the dialog window that appears, provide passwords for your two hosts, uncheck the box next to "Automatically configure firewall for the hosts of this cluster," and hit OK.

![](uarwo41-import-hosts.png)

## Configuring storage

Now, visit the "Storage" tab in the console, click "New Domain," give your new domain a name, and choose "Data" and "GlusterFS" from the "Domain Function" and "Storage Type" drop down menus. Check the box marked "Use managed gluster," and from the drop down box that appears, choose your "data" volume, and hit the OK button to proceed.

![](uarwo41-data-domain.png)

The export and iso domains, which oVirt uses, respectively, for import and export of VM images, and for storing iso images, can be set up in roughly the same way. Click "New Domain," choose Export or ISO from the "Domain Function" drop down, choose GlusterFS from the "Storage Type" drop down, give the domain a name, check the box marked "Use managed gluster," and from the drop down box that appears, choose the matching volume, and hit the OK button to finish.

So far, we've created all of our Gluster-backed storage domains as replica 3 arbiter 1 volumes, which ensures that we can bring down one of our nodes at a time while keeping our storage available and consistent. In this howto, host 3 is the arbiter for all four volumes, which leaves all of the storage burden on the first two hosts. 

There are all sorts of ways to strike a better storage balance -- for instance, in my lab, I've taken to running four gluster nodes with distributed-replicated volumes made up of four data bricks and two arbiter bricks. The details depend a great deal on your particular environment, so I'll leave further storage tweaking as an exercise for the reader.

## Configuring hosts two and three for Hosted Engine

Head over to the Hosts tab, select host two, and in the toolbar below the tabs, click Management, and then Maintenance, and hit OK in the dialog box that appears next. Once the host is in maintenance mode, click Installation, and then Reinstall in the toolbar. In the dialog that appears next, click "Hosted Engine," and then, in the drop down box, choose DEPLOY, and hit OK. After that process completes, repeat the process on host three. When that's done, do the same for host one, but skip the Hosted Engine DEPLOY step, as we only need the engine to carry out the firewall configuration on host one that we skipped when we deployed the hosted engine in the first place.

![](uarwo41-deploy-hosted.png)

Once all three hosts are back up, you should be able to bring down any one of the hosts at a time without losing access to the management engine or to your VM storage. 

## Running your first VM

Since version 3.4, oVirt engine has come pre-configured with a public Glance instance managed by the oVirt project. We'll tap this resource to launch our first VM.

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

You can bring a single machine down for maintenance by first putting the system into maintenance mode from the oVirt console, and updating, rebooting, shutting down, etc. as desired.

Putting a host into maintenance mode will also put that host's hosted engine HA services into local maintenance mode, rendering that host ineligible to take over engine-hosting duties. 

To check on and modify hosted engine ha status, you can head back to the command line to run `hosted-engine --vm-status`. If your host's "Local maintenance" status is "True," you can return it to engine-hosting preparedness with the command `hosted-engine --set-maintenance --mode=none`.

Also worth noting, if you want to bring down the engine service itself, you can put your whole trio of hosts into global maintenance mode, preventing them from attempting to restart the engine on their own, with the command `hosted-engine --set-maintenance --mode=global`. You can also enable and disable global maintenance mode by left-clicking on the Hosted Engine VM in the web admin console.

## Till next time

If you run into trouble following this walkthrough, I’ll be happy to help you get up and running or get pointed in the right direction. On IRC, I’m jbrooks, ping me in the #ovirt room on OFTC or give me a shout on Twitter [@jasonbrooks](https://twitter.com/jasonbrooks).

If you’re interested in getting involved with the oVirt Project, you can find all the mailing list, issue tracker, source repository, and wiki information you need <a href="http://www.ovirt.org/Community">here</a>.