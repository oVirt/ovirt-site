---
title: Node Stateless
category: node
authors: mburns, pmyers
wiki_title: Node Stateless
wiki_revision_count: 24
wiki_last_updated: 2012-05-29
---

# Node Stateless

## Goals

*   Be able to run a node image without installing to local disk
*   Required configuration is posted and retrieved from a configuration server
*   Minimal size configuration bundle
*   Provide some sort of security for communications

## High Level Design

*   Machine boots and retrieves it's configuration bundle from the configuration server
*   Configuration bundle is extracted and applied
*   Machine makes itself available based on configuration

## Details

### Boot Process

*   Makes the most sense in a pxe environment, but can be done with usb or CD/DVD
*   Machine boots the image
*   Image comes up and processes command line options
    -   If not stateless, then continue with existing stateful functionality
*   Start network using DHCP on nic specified in BOOTIF
    -   ?? Default to eth0 otherwise ??
    -   ?? Or should we abort stateless attempt ??
*   Get DNS SRV record for the configuration server
*   Check config server for config bundle

#### Previously configured

*   Retrieve the config bundle from the configuration server
*   Decrypt config bundle
*   Apply changes in config bundle
    -   ?? Do we need to (re)start services ??
*   Make node available to Engine

#### Not Configured

*   No config bundle found
*   Check for autoinstall parameters
*   Autoinstall
    -   Configure based on parameters
    -   Build configuration bundle
    -   Encrypt configuration bundle
    -   Send configuration bundle to config server
    -   Make available to Engine
*   TUI install
    -   Start configuration TUI
    -   After config is complete, User does something to confirm configuration
    -   On confirmation, build bundle, encrypt/sign, and send to config server
    -   Make available to Engine

### Configuration Server

*   A simple server that is running both an nfs and web server
*   New hosts will upload their new config bundles to the nfs server
*   OPTIONAL: Administrator confirms the new bundle and moves to web server
    -   Otherwise, web server can server from same location as nfs server
*   Provide web interface for admin to move and manage config bundles

#### Config Server Future

*   Probably not for initial development but some considerations for the future
*   May want to integrate the config server into ovirt-engine and have all the management from there
*   Might want to investigate integrating with other heavyweight configuration servers
    -   Katello
    -   IPA
    -   etc...

### Open Issues

*   Do we need something that prevents a host from uploading a new bundle while waiting for it to be approved?
*   What about updating configuration bundles?
*   How do we tell a host to create a new bundle even if one exists?
    -   kernel commandline?
    -   Admin on web server removes? <-- Do we need this anyway?

## Security Considerations

How do we authenticate a node with the configuration server?

*   Multiple levels that could be done
*   USB drive that contains some certificate or key for encrypting and decrypting the bundle
*   Single key embedded in the pxe image
*   TPM module to contain unique key per machine
    -   motherboard upgrades would require a node to be re-registered and configured in this case

## Upgrades

*   Should be as simple as updating the PXE image (or usb stick or CD/DVD)
*   Shouldn't be much need to change the config bundle, but a new config bundle shouldn't be difficult to upload

## To Swap or Not To Swap

*   In order to overcommit a host, you need to have swap space to support it
*   First implementation will probably disable swap
*   Future implementation may allow the system to configure a local disk as swap space

## Other

### irc conversations

temporarily preserved to ensure we don't lose anything

      A couple on conversations on IRC today regarding Stateless deployments of ovirt-node.  Pasting mostly verbatim here for now, and will cleanup (or let someone else cleanup) in the future.

      Some irrelevant (though amusing to downright hilarious) comments have been editted out and added to the new [[IRC_Quotes]] page.

       <xTs_w> Hi. I stumbled upon ovirt while I was looking for a virtualization management solution and despite the fact that the software itself shall be made public in a few weeks, I took a peek at old sources and the RedHat documents and have some questions left, hoping to find an answer here.

      <xTs_w> Ok, questions. Will the ovirt manager run on linux or - like the RHEV - just on windows? And will the node part be installable without creating a boot image, just by installing and configuring the necessary parts in the software?

      <mburns> xTs_w: the ovirt-engine will be completely on linux

      <mburns> RHEV 3.0 (currently in beta) will also run on linux btw

      <mburns> xTs_w: the node part does require installation to a local disk currently

      <xTs_w> just to be sure that we speak of the same things? I just found this http://www.redhat.com/virtualization/rhev/ and was pretty overwhelmed, except the part with the windows 2003 server...

      <mburns> xTs_w: we want to get the node to be completely stateless, but not there yet

      <mburns> xTs_w: the currently released version of RHEV is version 2.2 which does require a windows server

      <xTs_w> you mean like booting it over PXE, then fetching all necessary config options from somewhere else, so that you don't need a local harddisk anymore, if you've got shared disk space, like SAN?

      <mburns> as of the 3.0 release, the server portion of RHEV has been ported to java and now runs on RHEL

      <mburns> xTs_w: for the node, yes, we would like to have that option eventually

      <xTs_w> i had the same thing in mind, when my boss asked me about building something for a few million users...

      <xTs_w> and you can save a lot of money, when you don't need harddisks ;)

      <mburns> that's true

      <xTs_w> And it's one thing less that can fail.

      <mburns> it is possible to have the *local* storage be san storage

      <mburns> but you would need to define 1 lun per host in that case

      <xTs_w> configured by initrd then?

      <mburns> no, you configure a lun, and assign it to your host machine

      <mburns> the host machine's HBA card recognizes that lun as a boot disk and boots from it

      <xTs_w> Ah!

      <xTs_w> too many LUNs to configure (and to manage), if you ask me :)

      <mburns> yeah, probably

      <xTs_w> but it would be possible to use one lun (set to read-only, I guess that's possible) for all systems to boot from. But this wouldn't be different to a pxe boot

      <xTs_w> anyway

      <xTs_w> thank you for your help :)

      <xTs_w> I'm really looking forward to the release

      <mburns> xTs_w: no, that's not possible currently

      <mburns> it's on the roadmap, but there is per machine configuration stored on each box

      <mburns> and even with single lun, you would need a small amount of space per machine

      <mburns> for the config partition

      <mburns> but that would be doable with an sd card or a usb stick

      <xTs_w> Well, I've got some experience with embedded linux, where you configure the base system that it never writes something back to the flash memory

      <mburns> again, that isn't supported at the moment, but on the roadmap

      <mburns> xTs_w: excellent, then you can help when we get back to setting that up :)

      <xTs_w> and i'd built my own PXE images, to get some more things automatically configured.

      <xTs_w> I'm thinking about an image booting from PXE, receiving it's ip address via dhcp (the MAC address is stored in the dhcp server configs) and then asking a config server for its config files

      <mburns> yeah, that's the model we want to get to

      <mburns> but the config server piece is something that we're missing at the moment

      <mburns> and there are some security concerns, iirc, with that method

      <mburns> though in a private lab, those concerns are lessened somewhat

      <xTs_w> That's true, yes. It only secure, if you've got a management network separated from the public net

      <xTs_w> *It's

      <mburns> having an approval process on the management side helps as well

      <xTs_w> and I don't think that there is a way to secure it, without having some sort of memory for the node

      <mburns> so even if a machine breaks into the network and manages to get the config, it can't do anything unless an admin approves it in management interface

      <xTs_w> like a usb flash memory stick with a key on it

      <mburns> xTs_w: i'm no security expert, but that was a sticking point when we explored it previously

      <mburns> yeah, sneaker net makes it more secure...

      <mburns> xTs_w: i'm sure moving toward a stateless node is something that will come up again soon

      <xTs_w> but a small usb flash memory stick would cost much less than a hard disk

      <mburns> yes, it would

      <xTs_w> but pxe boot is not secure, too.

      <mburns> yeah, that's true too

      <xTs_w> so, the most secure way would be to boot from the hba controller, have a usb stick with a key plugged into the machine and fetch the missing config files over an encrypted connection

      <xTs_w> would require fiddling with the init system, but nothing impossible or really big

      <mburns> xTs_w: that's similar to what we were trying to do before

      <mburns> we split out the Root and RootBackup partitions from our VG

      <mburns> and we needed to have those and the config partition locally

      <mburns> note that we were targeting a single iscsi lun that was shared across all hosts

      <mburns> the Root and RootBackup partitions are setup so that the host knows how to boot with the remote iscsi lun

      <mburns> xTs_w: what we had in there has mostly been left alone at this point, so a different implementation would be good too

      <mburns> xTs_w: you're more than welcome to get involved and submit patches

      <mburns> we'll certainly work with you on them

      <xTs_w> well, yes. If I create something like this I will ask if I can share it with you. I guess I'll get the permission, because this would be a benefit for us, too

      <xTs_w> until then I've got to wait for ovirt to test it :)

      <mburns> xTs_w: the node is available now if you want to see what's involved in it

      <mburns> well, the source code is

      <mburns> we're debugging a couple issues with F16 still

      ---

      <SEJeff_work> mburns, Here is a crack idea for you

      <SEJeff_work> Once you've got node pxe working, store the configuration in a custom schema stored in a directory like IPA or openldap

      <SEJeff_work> That gives you replication (via ldap) for free

      <mburns> SEJeff_work: interesting thought

      <mburns> especially given the engine uses IPA

      <SEJeff_work> Yes, my thoughts exactly

      <SEJeff_work> With Pre RHEV ovirt and pre 1.0 FreeIPA, I used to joke that the ovirt developer's appliance was the quickest and easiest way to setup freeipa

      <SEJeff_work> As it was.

      <acathrow> stateless requires TPM/TXT to make it viable

      <SEJeff_work> acathrow, Care to elaborate? TPM makes me think of the trusted platform module in some servers and TXT is a dns record type.

      <mburns> http://en.wikipedia.org/wiki/Trusted_Execution_Technology

      <acathrow> TXT->trusted execution technology, very nice to add but TPM will be  a hard requirement

      <acathrow> in our labs we trust that it's just our severs that are booting up and joining the cluster but having a secure store to keep certificates etc is going to be required for a secure enterprise deployment

      <acathrow> the original ovirt server kind of presumed a happy, trusted environment. we have to be a little more cynical

      <SEJeff_work> Why is that?

      <SEJeff_work> If you don't trust the servers on your lan sounds like you have bigger problems to deal with

      <acathrow> security concerns are amplified in virt environments

      <SEJeff_work> Of course

      <acathrow> we see this today with our existing customer base

      <SEJeff_work> things like svirt help

      <SEJeff_work> IA problems are best solved with IA tools

      <SEJeff_work> IA == Information Assurance

      <acathrow> svirt only helps if you trust the host

      <acathrow> which is where tpm comes in

      <acathrow> (and txt if we go that far)

      <SEJeff_work> Sorry, I'm still not seeing the problem or the attack vector you're worried about.

      <acathrow> to make sure the host is really the host 

      <SEJeff_work> You can't figure that out with krb or something?

      <acathrow> chicken and the egg

      <acathrow> you have to get the krb credentials to the host

      <SEJeff_work> Because you're pxebooting the host

      <acathrow> you could sneaker net the krb credentials there 

      <SEJeff_work> Still to me seems like if you're pxebooting random servers that are not secure, you have bigger problems

      <SEJeff_work> virt or not

      <SEJeff_work> I'm fully confused right now

      <acathrow> I walk into your lab

      <acathrow> spoof a mac address

      <acathrow> boot up and get access to the virt environment

      <acathrow> mac alone isn't enough to identify a server 

      <SEJeff_work> Sure, I see that as a problem solved by physical security.

      <SEJeff_work> Mac is too easy to spoof

      <SEJeff_work> just like an ip

      <SEJeff_work> So I'm just not seeing the attack vector unless the admins have setup things in a sloppy or negligent fashion. Can you explain it further please?

      <SEJeff_work> If I manage a lab with hosts that should be secure and $joe_blow has access to it, I've failed at security.

      <pmyers> the answer is to set up your datacenters like SCIFs :)

      <acathrow> so one guy drops his access card in the canteen and you're in trouble 

      <pmyers> acathrow: if your physical security can be subverted by one guy dropping an access card, your physical security sucks :)

      <acathrow> we've been around these discussions numerous times with customers especially the more sensitive ones such as the Fed 7 DoD 

      <SEJeff_work> and lasers

      <SEJeff_work> friggin' lasers on their heads

      <mburns> acathrow: tbh, i can understand the need to support things like TPM/TXT, etc...

      <mburns> but is it a requirement for all deployments?

      <SEJeff_work> And couldn't those environments just use stateful nodes instead of stateless nodes?

      <SEJeff_work> problem solved with a lot less machinery

      <acathrow> mburns no but we need a solution that covers both use cases 

      <acathrow> but people still want stateless

      <SEJeff_work> Requiring stateful for those environments doesn't seem like an unreasonable compromise

      <SEJeff_work> As it would be a very niche use case

      <mburns> at least as a stop gap until we get it fully working with TPM/TXT

      <acathrow> how do we plan on exchanging keys?

      <mburns> acathrow: could step one solution be that machine pxes and registers to the engine, and the admin approves in the machine?

      <mburns> it's the least secure option, but for people that trust their physical security and pxe setup, it could be sufficient

      <SEJeff_work> Would the pxe be setup as a pool or static mac registrations?

      <mburns> then we have step 2 solution where machines have keys loaded on usb sticks that are sneaker net'ed to the hosts

      <mburns> step 3 would be full blown TPM/TXT solution...

      <mburns> SEJeff_work: i've generally done static mac registration in my environment

      <mburns> though undefined machines could still choose the distro from the menu

      <mburns> (we use cobbler currently)

      <SEJeff_work> mburns, Thats exactly how our environment here at work is.

      <acathrow> btw we still have the issue that many customers hate PXE but that's a different matter

      <SEJeff_work> acathrow, How do you propose wanting stateless without pxe?

      <SEJeff_work> Sometimes you need to tell the customers their demands don't make sense.

      <mburns> SEJeff_work: telepathy...

      <acathrow> who said I wanted that 

      <SEJeff_work> <acathrow> but people still want stateless

      <acathrow> I made the point that many customers hate pxe

      <SEJeff_work> Ah right

      <acathrow> there's always the usb disk approach 

      <acathrow> not as clean obviously 

      <SEJeff_work> Dell R series servers have an onboard small usb area you can write data to

      <SEJeff_work> There is an option to let the EFI stuff try to boot it up

      <SEJeff_work> And you can write to it using some userspace tools which work on RHEL

      <acathrow> and it's literally a usb/sd disk inside the chassis 

      <SEJeff_work> yup

      <mburns> i've seen some HP blades that have an internal SD card reader that could be using in a similar way

      <SEJeff_work> acathrow, Would that satisfy your use case for pxe in an untrusted environment?

      <mburns> i think the answer is that it's going to depend on the deployment requirements

      <acathrow> no I still think we need to do pxe+tpm also

      <acathrow> doesn't mean of course that it's all or nothing

      <SEJeff_work> Right

      <SEJeff_work> That is a very interesting use case, but still seems like it would be the rather extreme fringe

      <SEJeff_work> Not having physical security in a server room gives me the shakes

      <acathrow> vocal extreme fringe with large environments and federally funded mandates

      <SEJeff_work> So they pay redhat to make tpm/txt + pxe work

      <SEJeff_work> Problem solved, lets go eat ice cream!

      <acathrow> the beauty of commercial open source

      <acathrow> let's save that for san jose

      <SEJeff_work> indeed

[Category:Node development](Category:Node development)
