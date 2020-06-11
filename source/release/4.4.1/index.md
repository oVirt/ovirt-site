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

The oVirt Project is pleased to announce the availability of the 4.4.1 Fourth Release Candidate as of June 11, 2020.

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

### Enhancements

#### oVirt Engine

 - [BZ 1841083](https://bugzilla.redhat.com/1841083) **bump up max memory limit to 6TB**

   In 4.4 the maximum memory size for 64bit x86_64 and ppc64/ppc64le VMs is now 6TB. For x86_64 this limit is applied also to VMs in 4.2 and 4.3 Cluster Levels.


### Bug Fixes

#### oVirt Engine

 - [BZ 1837460](https://bugzilla.redhat.com/1837460) **grafana is not backed up**


#### VDSM

 - [BZ 1612152](https://bugzilla.redhat.com/1612152) **[GSS] Crashes in glusterVdoVolumeList seen in messages file.**


### Other

#### oVirt Release Package

 - [BZ 1844389](https://bugzilla.redhat.com/1844389) **CentOS Stream release rpm**

   


#### oVirt Engine

 - [BZ 1844797](https://bugzilla.redhat.com/1844797) **Can't extend a managed block disk**

   

 - [BZ 1575542](https://bugzilla.redhat.com/1575542) **date/time selectors in volume snapshot's schedule doesn't work**

   

 - [BZ 1842004](https://bugzilla.redhat.com/1842004) **Addition of IPV6 hosts to hyperconverged cluster fails**

   

 - [BZ 1624732](https://bugzilla.redhat.com/1624732) **Installing a Websocket Proxy on a Separate Machine fails on el8**

   

 - [BZ 1837911](https://bugzilla.redhat.com/1837911) **Can't edit a LUN disk attached to a VM from the VM->Disks screen**

   

 - [BZ 1826454](https://bugzilla.redhat.com/1826454) **When accessing any type of console error "Sorry, VM Portal is currently having some issues"**

   

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

 - [BZ 1842767](https://bugzilla.redhat.com/1842767) **Unable to call volumeEmptyCheck in vdsm-gluster due to errors in vdsm-gluster**

   

 - [BZ 1841030](https://bugzilla.redhat.com/1841030) **RHV upgrade for 4.3 to 4.4 fails for IBRS CPU type**

   

 - [BZ 1810974](https://bugzilla.redhat.com/1810974) **ipmilan fencing fails with JSON-RPC error when password contains space**

   

 - [BZ 1690485](https://bugzilla.redhat.com/1690485) **vdsm should send events on dhcpv4 and dhcpv6 success to engine**

   

 - [BZ 1835096](https://bugzilla.redhat.com/1835096) **Snapshot reports as 'done' even though it failed (due to I/O error)**

   

 - [BZ 1832967](https://bugzilla.redhat.com/1832967) **Uploading images from glance may delay sanlock I/O and cause sanlock operations to fail**

   


#### cockpit-ovirt

 - [BZ 1688245](https://bugzilla.redhat.com/1688245) **Gluster IPV6 storage domain requires additional mount options**

   

 - [BZ 1832822](https://bugzilla.redhat.com/1832822) **Cockpit: Blacklist list in inventory file entering empty fields**

   


#### oVirt imageio

 - [BZ 1839400](https://bugzilla.redhat.com/1839400) **[RFE] Support fallback to proxy_url if transfer_url is not accessible**

   

 - [BZ 1836858](https://bugzilla.redhat.com/1836858) **[v2v] Improve performance when using small requests**

   

 - [BZ 1835719](https://bugzilla.redhat.com/1835719) **[RFE] support showing parsed configuration**

   


#### oVirt Setup Lib

 - [BZ 1840756](https://bugzilla.redhat.com/1840756) **An endless loop occurs when using autoAcceptDefault=True**

   


#### oVirt Hosted Engine Setup

 - [BZ 1840756](https://bugzilla.redhat.com/1840756) **An endless loop occurs when using autoAcceptDefault=True**

   

 - [BZ 1634742](https://bugzilla.redhat.com/1634742) **HE cleanup code is not cleaning libvirt.qemu.conf correctly and HE can't be redeployed**

   


#### imgbased

 - [BZ 1827232](https://bugzilla.redhat.com/1827232) **[RHVH 4.4] sometimes when defining 2 sizes of huge pages the parameters order changed and all memory occupied by the huge pages.**

   


#### oVirt Node NG Image

 - [BZ 1838926](https://bugzilla.redhat.com/1838926) **ovirt-node-ng-image CI broken due to c, network is not active**

   


### No Doc Update

#### oVirt Engine

 - [BZ 1839076](https://bugzilla.redhat.com/1839076) **engine-vacuum on nonexistent table returns 0**

   

 - [BZ 1828669](https://bugzilla.redhat.com/1828669) **After SPM select the engine lost communication to all hosts until restarted [improved logging]**

   

 - [BZ 1833770](https://bugzilla.redhat.com/1833770) **Getting "WebSocket Proxy certificate signed successfully" log message when it actually fails**

   

 - [BZ 1835586](https://bugzilla.redhat.com/1835586) **ansible-runner-service.log is in /var/lib**

   


#### Contributors

51 people contributed to this release:

	Ahmad Khiet
	Ales Musil
	Amit Bawer
	Andrej Cernek
	Arik Hadas
	Artur Socha
	Asaf Rachmani
	Aviv Litman
	Aviv Turgeman
	Bell Levin
	Bella Khizgiyev
	Benny Zlotnik
	Dana Elfassy
	Daniel Erez
	Denis Chaplygin
	Dominik Holler
	Eitan Raviv
	Eli Mesika
	Eyal Shenitzky
	Fedor Gavrilov
	Gal Zaidman
	Gal-Zaidman
	Germano Veit Michel
	Gobinda Das
	Hilda Stastna
	Kaustav Majumder
	Lev Veyde
	Liran Rotenberg
	Lucia Jelinkova
	Marcin Sobczyk
	Martin Necas
	Martin Perina
	Michal Skrivanek
	Milan Zamazal
	Nir Levy
	Nir Soffer
	Ori_Liel
	Pavel Bar
	Prajith Kesava Prasad
	Radoslaw Szwajkowski
	Ritesh Chikatwar
	Sandro Bonazzola
	Shani Leviim
	Shirly Radco
	Shmuel Melamud
	Steven Rosenberg
	Tal Nisan
	Tomáš Golembiovský
	Vojtech Juranek
	Yedidyah Bar David
	parthdhanjal
