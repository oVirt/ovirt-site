# oVirt Node

This is the main entry page for using oVirt Node.

# Overview

The oVirt Node sub-project is geared towards building a small, robust operating system
image. It uses minimal resources while providing the ability to control virtual machines
running upon it.

After installing oVirt Node the host can directly be added to oVirt Engine and be used as a
host to run your Virtual Machines.

For installation Node now relies on [Anaconda](https://github.com/rhinstaller/) - the installer
used for installing Fedora, CentOS and Red Hat Enterprise Linux. Formerly Node used a
specialiced TUI installer to perform the installation.

For administration Node is now leveraging [Cockpit](http://cockpit-project.org/) formerly
the administration was performed by a specialiced administration TUI.

# Quickstart

1. Download the oVirt Node installation iso from one of our release streams([see below](#releases))
2. Install oVirt Node on your bare-metal host

   For manual partitioning, check ([Minimum partitioning requirements session](#Minimum partitioning requirements))

3. Navigate to Cockpit on https://yourhost.example.com:9090/ to configure your host (i.e. configure networking)
4. Navigate to Engine and add the host **OR** run `hosted-engine-setup`

> If you encounter problems, please file them in [bugzilla](https://bugzilla.redhat.com/enter_bug.cgi?product=ovirt-node&component=General).

# Minimum partitioning requirements
In case you would like to do manual partitioning, [please see these notes](https://bugzilla.redhat.com/show_bug.cgi?id=1369874)

# Kickstart installation
In case you would like to do automated installation by kickstart, [example is here](https://bugzilla.redhat.com/show_bug.cgi?id=1369874#c5)

# Frequently asked questions

Please see [this page](faq) for some common questions.

# Releases and Streams

oVirt Node is released continously.

Usually you install Node once, using one of our installer images (see below). Afterwards you
use `yum update` (or updates through Engine from 4.0 on) to keep your hosts updated.

> Note: `yum update` will not update individual packages like on normal Fedora or CentOS systems,
> it will rather update the whole image.

> Note: You can verify the integrity of any downloaded installation iso by checking the embedded checksum:
> `checkisomd5 $ISONAME`

## Developing
More informations about developing oVirt Node can be found [here](/develop/projects/node/building/).

## Legacy vs. Vintage

With oVirt 4.0 Node got a complete overhaul and reimplementation - which are using Anaconda
and Cockpit as described above.

Up to oVirt 3.x Node was using a custom installer, a custom administration TUI, and a custom
build process. All of these - including other design decisions - caused a couple of issues,
which we addressed with the re-designed oVirt Node 4.0.


## oVirt Node 3

* **oVirt Node 3 Next** (Tech-Preview, downwards compatible within oVirt 3, **recommended**)
  * This is the oVirt Node Next image, with the newly designed oVirt Node, but using the stable oVirt 3 packages.
  * [Installation ISO](http://resources.ovirt.org/pub/ovirt-3.6/iso/ovirt-node-ng-installer/ovirt-node-ng-installer-ovirt-3.6-2016052403.iso)

## oVirt Node 4

This is the oVirt Node 4 image, including the latest oVirt 4 packages.

* [Installation ISO](http://resources.ovirt.org/pub/ovirt-4.0/iso/ovirt-node-ng-installer/ovirt-node-ng-installer-ovirt-4.0-2017011712.iso)

## oVirt Node 4.1

This is the oVirt Node 4.1 image including the latest oVirt 4.1 packages.

* [Installation ISO](https://resources.ovirt.org/pub/ovirt-4.1/iso/ovirt-node-ng-installer-ovirt/4.1-2018012411/ovirt-node-ng-installer-ovirt-4.1-2018012411.iso)

## oVirt Node 4.2

This is the oVirt Node 4.2 image including the latest oVirt 4.2 packages.

* [Installation ISO](http://jenkins.ovirt.org/job/ovirt-node-ng_ovirt-4.2_build-artifacts-el7-x86_64/lastSuccessfulBuild/artifact/exported-artifacts/latest-installation-iso.html)
* Jenkins job: <http://jenkins.ovirt.org/job/ovirt-node-ng_ovirt-4.2_build-artifacts-el7-x86_64/>

## oVirt Node Master

This is the oVirt Node image build based on oVirt packages from the master branches.

* [Installation ISO (based on el7)](http://jenkins.ovirt.org/job/ovirt-node-ng-image_master_build-artifacts-el7-x86_64/lastSuccessfulBuild/artifact/exported-artifacts/latest-installation-iso.html)
* [Installation ISO (based on fc28)](http://jenkins.ovirt.org/job/ovirt-node-ng-image_master_build-artifacts-fc28-x86_64/lastSuccessfulBuild/artifact/exported-artifacts/latest-installation-iso.html)

* Jenkins job (el7): <http://jenkins.ovirt.org/job/ovirt-node-ng-image_master_build-artifacts-el7-x86_64/>
* Jenkins job (fc28): <http://jenkins.ovirt.org/job/ovirt-node-ng-image_master_build-artifacts-fc28-x86_64>
