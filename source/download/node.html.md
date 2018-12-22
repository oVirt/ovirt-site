# oVirt Node

## Installing oVirt Node

oVirt Node is a minimal operating system based on CentOS that is designed to provide a simple method for setting up a
physical machine to act as a hypervisor in an oVirt environment. The minimal operating system contains only the packages
required for the machine to act as a hypervisor, and features a Cockpit user interface for monitoring the host and
performing administrative tasks. See [http://cockpit-project.org/running.html](http://cockpit-project.org/running.html)
for the minimum browser requirements.

See [Chapter 6: oVirt Nodes](/documentation/install-guide/chap-oVirt_Nodes.html) in the [Installation Guide](/documentation/install-guide/)
for installation instructions.

Also see [Chapter 5: Introduction to Hosts](/documentation/install-guide/chap-Introduction_to_Hosts.html) and
[Chapter 7: Enterprise Linux Hosts](/documentation/install-guide/chap-Enterprise_Linux_Hosts.html)

Installing oVirt Node on a physical machine involves three key steps:

 * Download the oVirt Node Installation ISO below (probably [oVirt Node 4.2 - Stable Release - Installation ISO](http://jenkins.ovirt.org/job/ovirt-node-ng_ovirt-4.2_build-artifacts-el7-x86_64/lastSuccessfulBuild/artifact/exported-artifacts/latest-installation-iso.html))

 * Write the oVirt Node Installation ISO disk image to a USB, CD, or DVD.

 * Boot your physical machine from that media and install the oVirt Node minimal operating system.

## oVirt Node 4.2 - Stable Release

This is the oVirt Node 4.2 image including the latest oVirt 4.2 packages. This is the latest stable release.

* **[oVirt Node 4.2 - Stable Release - Installation ISO (based on el7)](http://jenkins.ovirt.org/job/ovirt-node-ng_ovirt-4.2_build-artifacts-el7-x86_64/lastSuccessfulBuild/artifact/exported-artifacts/latest-installation-iso.html)**
* Jenkins job (el7): <http://jenkins.ovirt.org/job/ovirt-node-ng_ovirt-4.2_build-artifacts-el7-x86_64/>

## oVirt Node Master - Latest master, experimental

This is the oVirt Node image build based on oVirt packages from the master branches.

* [oVirt Node master experimental ISO (based on el7)](http://jenkins.ovirt.org/job/ovirt-node-ng-image_master_build-artifacts-el7-x86_64/lastSuccessfulBuild/artifact/exported-artifacts/latest-installation-iso.html)
* [oVirt Node master experimental ISO (based on fc28)](http://jenkins.ovirt.org/job/ovirt-node-ng-image_master_build-artifacts-fc28-x86_64/lastSuccessfulBuild/artifact/exported-artifacts/latest-installation-iso.html)

* Jenkins job (el7): <http://jenkins.ovirt.org/job/ovirt-node-ng-image_master_build-artifacts-el7-x86_64/>
* Jenkins job (fc28): <http://jenkins.ovirt.org/job/ovirt-node-ng-image_master_build-artifacts-fc28-x86_64>

# Old releases

## oVirt Node 4.1

This is the oVirt Node 4.1 image including the latest oVirt 4.1 packages.

* [Installation ISO](https://resources.ovirt.org/pub/ovirt-4.1/iso/ovirt-node-ng-installer-ovirt/4.1-2018012411/ovirt-node-ng-installer-ovirt-4.1-2018012411.iso)

## oVirt Node 4

This is the oVirt Node 4 image, including the latest oVirt 4 packages.

* [Installation ISO](http://resources.ovirt.org/pub/ovirt-4.0/iso/ovirt-node-ng-installer/ovirt-node-ng-installer-ovirt-4.0-2017011712.iso)

## oVirt Node 3

* **oVirt Node 3 Next** (Tech-Preview, downwards compatible within oVirt 3, **recommended**)
  * This is the oVirt Node Next image, with the newly designed oVirt Node, but using the stable oVirt 3 packages.
  * [Installation ISO](http://resources.ovirt.org/pub/ovirt-3.6/iso/ovirt-node-ng-installer/ovirt-node-ng-installer-ovirt-3.6-2016052403.iso)


