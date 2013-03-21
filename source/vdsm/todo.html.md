---
title: Vdsm TODO
category: vdsm
authors: aglitke, amuller, apuimedo, danken, ekohl, gvallarelli, ibarkan, phoracek
wiki_category: Vdsm
wiki_title: Vdsm TODO
wiki_revision_count: 122
wiki_last_updated: 2015-05-29
---

# Vdsm TODO

## What Can You Do for Vdsm

### Cleanup

*   `` pylint -E `git ls-files | grep '.py$'` `` makes me cry. A lot of it is "only" about bad style, but we should clear it up and add it to our `make check-local`. We should grow up and pass `pychecker` too.

<!-- -->

*   Improve Vdsm portability. We are very much Fedora-centric at best. Do you want to have Vdsm on your pet distribution? Own that port!

<!-- -->

*   remove all usage of `sudo`, and replace with specific calls to `superVdsm`.

<!-- -->

*   have a logrotate-dependent logrotate.conf that works on Fedora and EL equally well.

<!-- -->

*   Configure vdsm to use syslog -- done by Mark Wu, but now we need to stop trashing the console.

<!-- -->

*   Simplify the SysV init script, split most of its code to a "[vdsm-tool](http://gerrit.ovirt.org/295)". vdsm-tool should assume responsibility on hairy stuff such as [configuring multipath](http://bugzilla.redhat.com/547424), which should not be the business of Vdsm proper.

<!-- -->

*   running vdsClient from the project root dir ends with tears. Some PYTHONPATH games should fix this. **Patch submitted. Awaiting approval**.

### Testing

*   ~~write an automatic script that runs on each and every new change to gerrit, and adds an insulting comment if `pyflakes` fails for the new change.~~ Thanks, Robert!

<!-- -->

*   extend the former script, so that it runs a complete `` `make distcheck && make install` `` in a confined environment (chroot, VM) and reports if there is an error.

<!-- -->

*   run unit and functional tests on reviewed patches (before submission).

<!-- -->

*   add a unit test for domxml generation, with several examplary vmParams.

<!-- -->

*   make `getAllVolumesTests` more meaningful, not only counting the number of volumes, but testing the image structure.

### Features

*   Support striping for disk images.

<!-- -->

*   let Vdsm install and run on hosts with no iscsid (report that iscsi is missing to Engine?)

<!-- -->

*   ~~add hooks for device hotplug~~ done.
*   add hooks for device update <http://bugzilla.redhat.org/893576>

<!-- -->

*   add hooks for network operations

<!-- -->

*   Add configurable QoS controls on vnics <http://libvirt.org/formatdomain.html#elementQoS>

### refactoring

*   In vm.py, libvirtvm.py, clientIF.py there is a mess of prepare\*Path functions (end their respective teardowns), which is too complex to fathom. We have to convert all drive specifications (PDIV,GUID,path) into Drive object at the API entry.

<!-- -->

*   lvm.PV.guid is devicemapper-owned piece of information; lvm has nothing to do with it, and jumps through [hoops](http://gerrit.ovirt.org/2940) to produce it. Instead, it should be produced by devicemapper and consumed directly by blockSD.

<!-- -->

*   Define an API.VMState "enumeration" and use API.VMState.UP instead of the string 'Up'.

<!-- -->

*   factor betterPopen and betterThreading out of vdsm. They deserve a pipy review under the names [cPopen](https://pypi.python.org/pypi/cpopen) and [pthreading](http://pypi.python.org/pypi/pthreading) respectively.

<https://bugzilla.redhat.com/show_bug.cgi?id=903246>

*   factor the task framework out of storage. Networking may need it, too.

<!-- -->

*   make storage_mailbox testable; use bytearrays instead of 1MiB strings; use fileUtils.DirectFile instead of forking /bin/dd all the time.

<!-- -->

*   split VM monitoring threads out of core Vdsm. Monitoring process would write to a memory-mapped file the most up to date values, which can be read by Vdsm on demand. This would reduce thread contentions in Vdsm and may simplify the code.

### Bugzilla

*   pick one of the [<https://bugzilla.redhat.com/buglist.cgi?action=wrap&bug_file_loc>=&bug_file_loc_type=allwordssubstr&bug_id=&bug_id_type=anyexact&chfieldfrom=&chfieldto=Now&chfieldvalue=&component=vdsm&deadlinefrom=&deadlineto=&email1=&email2=&emailtype1=substring&emailtype2=substring&field0-0-0=flagtypes.name&keywords=&keywords_type=allwords&longdesc=&longdesc_type=allwordssubstr&short_desc=&short_desc_type=allwordssubstr&status_whiteboard=&status_whiteboard_type=allwordssubstr&type0-0-0=notsubstring&value0-0-0=rhel-6.2.0&votes=&=&bug_status=NEW NEW bugs], post a patch to [gerrit](http://gerrit.ovirt.org), and make the bug yours.

<!-- -->

*   undersntand what is the `(deleted)` state of an nfs mount (in /proc/mounts) and deal with it properly in vdsm. See <http://bugzill.redhat.com/807351> .

<Category:Vdsm>
