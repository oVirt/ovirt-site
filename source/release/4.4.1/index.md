---
title: oVirt 4.4.1 Release Notes
category: documentation
authors: sandrobonazzola lveyde
toc: true
---

<style>
h1, h2, h3, h4, h5, h6, li, a, p {
    font-family: 'Open Sans', sans-serif !important;
}
</style>

# oVirt 4.4.1 Release Notes

The oVirt Project is pleased to announce the availability of the 4.4.1 Third Release Candidate as of June 03, 2020.

oVirt is a free open-source distributed virtualization solution,
designed to manage your entire enterprise infrastructure.
oVirt uses the trusted KVM hypervisor and is built upon several other community
projects, including libvirt, Gluster, PatternFly, and Ansible.

This release is available now for Red Hat Enterprise Linux 8.1 and
CentOS Linux 8.1 (or similar).


To find out how to interact with oVirt developers and users and ask questions,
visit our [community page]"(/community/).
All issues or bugs should be reported via
[Red Hat Bugzilla](https://bugzilla.redhat.com/enter_bug.cgi?classification=oVirt).
The oVirt Project makes no guarantees as to its suitability or usefulness.
This pre-release should not to be used in production, and it is not feature
complete.


If you'd like to try oVirt as quickly as possible, follow the instructions on
the [Download](/download/) page.

For complete installation, administration, and usage instructions, see
the [oVirt Documentation](/documentation/).

For a general overview of oVirt, read the [About oVirt](/community/about.html)
page.

To learn about features introduced before 4.4.1, see the
[release notes for previous versions](/documentation/#previous-release-notes).

## RELEASE CANDIDATE

In order to install this Release Candidate you will need to enable pre-release repository.

`# yum install `[`http://resources.ovirt.org/pub/yum-repo/ovirt-release44-pre.rpm`](http://resources.ovirt.org/pub/yum-repo/ovirt-release44-pre.rpm)



## What's New in 4.4.1?

### Bug Fixes

#### oVirt Engine

 - [BZ 1837460](https://bugzilla.redhat.com/1837460) **grafana is not backed up**


### Other

#### oVirt Engine

 - [BZ 1839676](https://bugzilla.redhat.com/1839676) **Run engine-setup with answerfile fails on "rollback failed: cannot use a string pattern on a bytes-like object"**

   

 - [BZ 1679730](https://bugzilla.redhat.com/1679730) **Warn about host IP addresses outside range**

   

 - [BZ 1538649](https://bugzilla.redhat.com/1538649) **[RFE] [UI] - Add right click menu to VM's vNIC panel**

   

 - [BZ 1839967](https://bugzilla.redhat.com/1839967) **Error encountered when running ovirt-engine-rename**

   

 - [BZ 1662733](https://bugzilla.redhat.com/1662733) **Webadmin- Download 2 disks on a running VM fails but only 1 disk is shown in the error message**

   

 - [BZ 1707707](https://bugzilla.redhat.com/1707707) **Ovirt: Can't upload Disk Snapshots with size >1G to iSCSI storage using Java/Python SDK**

   

 - [BZ 1828931](https://bugzilla.redhat.com/1828931) **engine-vacuum fails with permission denied for schema pg_temp_23**

   

 - [BZ 1832828](https://bugzilla.redhat.com/1832828) **Serial number provided is ignored**

   

 - [BZ 1517764](https://bugzilla.redhat.com/1517764) **ovirt-imageio: socket.error:  Address already in use**

   


#### VDSM

 - [BZ 1810974](https://bugzilla.redhat.com/1810974) **ipmilan fencing fails with JSON-RPC error when password contains space**

   

 - [BZ 1690485](https://bugzilla.redhat.com/1690485) **vdsm should send events on dhcpv4 and dhcpv6 success to engine**

   

 - [BZ 1835096](https://bugzilla.redhat.com/1835096) **Snapshot reports as 'done' even though it failed (due to I/O error)**

   

 - [BZ 1832967](https://bugzilla.redhat.com/1832967) **Uploading images from glance may delay sanlock I/O and cause sanlock operations to fail**

   


#### cockpit-ovirt

 - [BZ 1833879](https://bugzilla.redhat.com/1833879) **"Installation Guide" and "RHV Documents" didn't jump to the correct pages.**

   


### No Doc Update

#### oVirt Engine

 - [BZ 1835586](https://bugzilla.redhat.com/1835586) **ansible-runner-service.log is in /var/lib**

   


#### Contributors

34 people contributed to this release:

	Ahmad Khiet
	Ales Musil
	Amit Bawer
	Andrej Cernek
	Arik Hadas
	Artur Socha
	Asaf Rachmani
	Aviv Turgeman
	Bell Levin
	Bella Khizgiyev
	Dana Elfassy
	Daniel Erez
	Dominik Holler
	Eitan Raviv
	Eli Mesika
	Eyal Shenitzky
	Fedor Gavrilov
	Gal Zaidman
	Gal-Zaidman
	Lev Veyde
	Liran Rotenberg
	Marcin Sobczyk
	Martin Necas
	Martin Perina
	Michal Skrivanek
	Milan Zamazal
	Nir Levy
	Nir Soffer
	Ori Liel
	Pavel Bar
	Sandro Bonazzola
	Steven Rosenberg
	Vojtech Juranek
	Yedidyah Bar David
