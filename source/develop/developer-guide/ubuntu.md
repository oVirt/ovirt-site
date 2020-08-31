---
title: ubuntu
category: debian
authors: dneary, lhornyak, vfeenstr
---

# ubuntu

### Building ovirt on debian/ubuntu

If you have questions about these notes ask xTs_w in #ovirt on OFTC (irc.oftc.net)

Depends:

*   postgresql-9.1
*   openjdk-6-jre
*   postgresql-contrib-9.1

Build-Depends: maven2, openjdk6-jdk It looks like postgres-8.4 is too old, so I'm increasing it to 9.1

### Building ovirt-engine (for Debian)

Following: [Building oVirt engine](/develop/developer-guide/engine/engine-development-environment.html) (changes to make are documented below) Changes: Installing JBoss AS Get JBoss from jboss.org or build the package. wget <http://sourceforge.net/projects/jboss/files/JBoss/JBoss-5.1.0.GA/jboss-5.1.0.GA-jdk6.zip/download> Building JBoss 5.1.0GA with Debian Squeeze: <http://wiki.debian.org/JBossPackaging#Building_the_packages_from_vcs> Build the package (but be aware that the package is n ot fully debian policy conform and no security patches get applied!)

Creating the database

*   create a different user (for packaging: do this) or
*   add in /etc/postgresql/9.1/main/pg_hba.conf: host all postgres 127.0.0.1/32 trust

when executing ./create_db_devel.sh you'll get some error about uuid-ossp because the script searches in the wrong path. Use ./create_db_devel.sh -f /usr/share/postgresql/8.4/contrib/uuid-ossp.sql With Postgres 9.1 this is done automatically

## Packaging

There is a Makefile now which should make packaging pretty easy. Notes: In the fedora package there are several scripts executed after copying the files. This is done by the program "engine-setup". This has to be done for debian somehow, too. It enables the SSL support and the support for the keystore file that you need to save passwords (for the power management). VDSM Building vdsm Depends: python, libvirt-bin, open-iscsi(>= 2.0.872), multipath-tools, python-ethtool, python-libvirt (>= 0.9.6-1), policycoreutils, sudo, bridge-utils, e2fsprogs (>=1.42), lvm2, python-apt (>=0.7.9), ifenslave-2.6, cman Build-Depends: automake, pyflakes Notes

*   requires python-ethtool, which is not in debian. Can be easily built from the ubuntu sources
*   Debian/Squeeze is too old. Try at least Wheezy(testing).
*   vdsm will run without cgroups but it'll throw an exception.

### Packaging notes

Multibinary-Package?

*   vdsmd
*   vdms-client
*   vdms-bootstrap
*   vdms-reg

<!-- -->

*   init-Script: needs cleanup for packaging (or rewriting. Shouldn't be too hard)
*   cron.d/vdsm-libvirt-logrotate really needed? Normally not -> Not needed, but vdsm creates a lot of debug output and therefore big log files)
*   cron.hourly/vdsm-\*: same as above
*   logrotate.d/vdsm: cleanup needed (cores?!)
*   change xz to gzip
*   ovirt-commandline.d: ?
*   ovirt-config-boot.d: ?
*   pki: Debian just knows /etc/ssl/
*   rc.d/: No rc.d in debian. What's its function in RH?
*   like init.d
*   rwtab.d: Really needed? -> just for the node (makes part of the read-only root-fs writeable)
*   sudoers.d/ -> changes are needed in the sudoers file (see below)
*   udev/rules.d/12-vdsm-lvm.rules: What's the function of this? Looks like a workaround
*   it is kind of a workaround. It sets the correct permissions of the lvm-volumes that get created for the storage of the VMs. It is needed to set the permissions correctly after a reboot. But the priority is too high. Set it to 95 and it will work correctly
*   vdsm/: provide an example vdsm.conf that is installed in /etc/vdsm/
*   vdsm-reg/: belongs to vdsm-reg and the question is, if this is really needed.

vdsm wont run as root. You need to start it as user (name it "vdsm") and copy the sudoers config file to /etc/sudoers.d to run it. Or edit METADATA_USER in vdsm/constants.py (for testing purpose only!)

*   vdsm creates a directory /rhev/data-center. Would fit better in /var/lib/vdsm/ (is configurable!)
*   vdsm listens on the IP of "default_bridge" (in vdsm.conf). Default is engine. Needs to be configured by preinst-Scripts somehow (or in /etc/default a script that disables vdsm by default, so the user can add the bridge and enable vdsm afterwards)

<!-- -->

*   needs module "cpuid" loaded
*   User vdsm must be in group libvirt supervdsmServer.pyc doesn't exist and wont get created.
*   in order to run vdsm the following changes are needed:
*   change in supervdsm.py: supervdsmServer.pyc to supervdsmServer.py
*   change the sudoers file accordingly
*   /etc/iscsi/initiatorname.iscsi has normally rights 600, but needs to be readable by vdsm. sudo might be a solution here
*   seems to be fixed in wheezy
*   not fixed. Right after installation of open-iscsi file has 644, but after a reboot 600
*   vdsm needs to run with uid 36 currently or something that maps to uid 36 on a nfs share (afaik this is not hard coded. Any uid will do, but has to be used on all systems then)
*   this is not hardcoded, but has something to do with nfs shares. So if you use nfs somewhere, be sure that vdsm runs as the same user everywhere or map the uids
*   in vdsm/constants.py: DISKIMAGE_GROUP and QEMU_PROCESS_USER need to be set to kvm and user libvirt-qemu (or whatever users exist)
*   the sudoers file has to be changed accordingly. (chown!)
*   libvirtd needs some config (if ssl=false):
*   listen_tcp=1
*   auth_tcp="none"
*   spice_tls=0
*   init-Script should check this

For the record: vdsm runs without any options, with a proper config file, started by hand without an init script. (don't forget to load the cpuid and the kvm module!) A few things need fixes:

*   vdsm looks in /etc/default/version for the version. Patch needed for upstream.
*   Upstream Debian support needs discussion but is in the works
*   <https://bugzilla.redhat.com/show_bug.cgi?id=768919>
*   in constants.py change EXT_SERVICE to '/usr/sbin/invoke-rc.d'
*   in sudoers file: replace "/usr/sbin/service" with "/usr/sbin/invoke-rc.d"m
*   utils::595::Storage.Misc.excCmd::(execCmd) '/bin/rpm -q --qf "%{NAME}\\t%{VERSION}\\t%{RELEASE}\\t%{BUILDTIME}\\n" qemu-kvm' (cwd None)

wont work, because we're using dpkg

*   in vdsm/storage/multipath.py change multipathd to multipath-tools change sudoers file accordingly

### SPICE

A spice-xpi package for debian/ubuntu would be nice, too. See here: <http://www.spice-space.org/> <http://www.spice-space.org/download.html> -> spice-xpi



