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

The oVirt Project is pleased to announce the availability of the 4.4.1 First Release Candidate as of May 22, 2020.

oVirt is a free open-source distributed virtualization solution,
designed to manage your entire enterprise infrastructure.
oVirt uses the trusted KVM hypervisor and is built upon several other community
projects, including libvirt, Gluster, PatternFly, and Ansible.

This release is available now for Red Hat Enterprise Linux 7.7 and
CentOS Linux 7.7 (or similar).


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

### Other

#### oVirt Engine

 - [BZ 1828931](https://bugzilla.redhat.com/1828931) **engine-vacuum fails with permission denied for schema pg_temp_23**

   

 - [BZ 1832828](https://bugzilla.redhat.com/1832828) **Serial number provided is ignored**

   

 - [BZ 1517764](https://bugzilla.redhat.com/1517764) **ovirt-imageio: socket.error:  Address already in use**

   


#### VDSM

 - [BZ 1835096](https://bugzilla.redhat.com/1835096) **Snapshot reports as 'done' even though it failed (due to I/O error)**

   

 - [BZ 1832967](https://bugzilla.redhat.com/1832967) **Uploading images from glance may delay sanlock I/O and cause sanlock operations to fail**

   


#### Contributors

12 people contributed to this release:

	Ales Musil
	Amit Bawer
	Andrej Cernek
	Artur Socha
	Eli Mesika
	Eyal Shenitzky
	Lev Veyde
	Liran Rotenberg
	Milan Zamazal
	Nir Soffer
	Ori Liel
	Yedidyah Bar David
