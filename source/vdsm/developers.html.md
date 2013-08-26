---
title: Vdsm Developers
category: vdsm
authors: abonas, adahms, amuller, amureini, apahim, apevec, danken, dougsland, ekohl,
  fromani, herrold, itzikb, lhornyak, mbetak, mlipchuk, moolit, moti, mpavlik, nsoffer,
  phoracek, quaid, sandrobonazzola, sgordon, smelamud, vered, vfeenstr, vitordelima,
  yanivbronhaim, ybronhei
wiki_category: Vdsm
wiki_title: Vdsm Developers
wiki_revision_count: 169
wiki_last_updated: 2015-05-21
---

# Vdsm Developers

## Installing required packages

RHEL 6 users must add EPEL yum repository for installing python-ordereddict and pyton-pthreading. The rpm bellow will install the epel yum repo and required gpg keys.

      rpm -Uvh http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm 

Fedora users should verify the following packages are installed before attempting to build:

       yum -y install autoconf automake pyflakes logrotate gcc python-pep8 libvirt-python python-devel \
       python-nose rpm-build sanlock-python genisoimage python-ordereddict python-pthreading libselinux-python\
       python-ethtool m2crypto python-dmidecode python-netaddr python-inotify git

RHEL 6 users should install this version of pep8. Older pep8 versions have a bug that's tickled by vdsm.

      yum install http://danken.fedorapeople.org/python-pep8-1.3.3-3.el6.noarch.rpm 

## Getting the source

Our public git repo is located on [oVirt.org](http://gerrit.ovirt.org/gitweb?p=vdsm.git)

you can clone it with

`git clone `[`http://gerrit.ovirt.org/p/vdsm.git`](http://gerrit.ovirt.org/p/vdsm.git)

## Building a Vdsm RPM

Vdsm uses autoconf and automake as it's build system.

To configure the build env:

      ./autogen.sh --system

To create an RPM do:

      make rpm

or

      make NOSE_EXCLUDE=.* rpm  #(As development only, avoid the unittests validation)

Note: To exclude a specific test (testStressTest):

      make NOSE_EXCLUDE=testStressTest rpm

Vdsm automatically builds using the latest tagged version. If you want to explicitly define a version use

      make rpmversion=4.9 rpmrelease=999.funkyBranch

## Building with hooks support

      ./autogen.sh --system && ./configure  --enable-hooks && make rpm

## Code Style

*   Variables and arguments are in mixedCase
*   Class names are in CamelCase
*   Function and method names are in mixedCase
*   All indentation is made of space characters
*   A space character follows any comma
*   Spaces surround operators, but
*   No spaces between

      def f(arg=its_default_value):

*   Lines longer than 80 chars are frowned upon
*   Whitespace between functions and within stanza help to breath while reading code
*   A space char follows a comment's hash char
*   Let logging method do the formatting for you:

      logging.debug('hello %s', 'world')

Rather than

      logging.debug('hello %s' % 'world')

## Sending patches

Send them to [our gerrit server](http://gerrit.ovirt.org) ([see how](Working with oVirt Gerrit)). With your first major patch, do not forget to add yourself to the AUTHORS file. Do not be shy - it gives you a well-deserved recognition, and it shows to the team that you stand behind your code.

Please be verbose in your commit message. Explain the motivations for your patch, and the reasoning behind it. This information would assist the reviewers of your code, before and after it is submitted to the master branch.

The commit message should follow the guidelines in the DISCUSSION section of <http://kernel.org/pub/software/scm/git/docs/git-commit.html> : short subject line, empty line, verbose paragraphs.

General development discussions are in `vdsm-devel@lists.fedorahosted.org`.

## Basic installation

      cd ~/rpmbuild/RPMS
      yum install x86_64/* noarch/vdsm-xml* noarch/vdsm-cli*

## Creating local yum repo to test vdsm changes

1) First you will need to generate the rpm with your changes, from the vdsm source directory:

      #vdsm> ./autogen.sh --system
      #vdsm> make
      #vdsm> make rpm

**Note**: all rpm files will be generated at rpmbuild dir, usually: /home/your-user/rpmbuild/RPMS

2) Setting environment:

*   Install required package

      # yum install createrepo -y

*   Enable httpd service (if it's not installed, install it first with yum install httpd)

      # chkconfig httpd on

or

      # ln -s '/lib/systemd/system/httpd.service' '/etc/systemd/system/multi-user.target.wants/httpd.service'

*   Create the directory that will hold the rpm files (repo)

      # mkdir /var/www/html/my-vdsm-changes

*   Copy the vdsm packages to repo

      # cp /home/your-user/rpmbuild/RPMS/noarch/* /var/www/html/my-vdsm-changes
      # cp /home/your-user/rpmbuild/RPMS/x86_64/* /var/www/html/my-vdsm-changes

*   Create the repo inside the yum.repos.d

      # vi /etc/yum.repos.d/my-vdsm-changes.repo
      [my-vdsm-changes]
      name = my vdsm changes
      baseurl = http://127.0.0.1/my-vdsm-changes
      enabled = 1
      gpgcheck = 0

*   Execute createrepo tool

      # createrepo /var/www/html/my-vdsm-changes

*   Start httpd service

      # service httpd start

*   List all repos and see your new repo

      # yum repolist

**Note**: SELinux might throw permission denied to repo located at /var/www/html/

## Using VM console

If you want to use the console for a VM using the Spice protocol (VNC is not supported right now) Run the following command on the host running ovirt-engine:

    # psql -U postgres engine -c "update vdc_options set option_value = 'false' 
    where option_name = 'UseSecureConnectionWithServers';"

## Fake KVM Support

As developer you might need to add many hosts into your environment for tests. VDSM provides a functionality called 'fake_kvm_support' for **VDSM quality assurance/developers** emulate a real host/kvm hardware without running real guests.

*   1) Create a guest as Fedora 17 (Tested on Fedora 17 but should work in higher versions as well)

<!-- -->

*   2) Install required packages

      # yum install vdsm-hook-faqemu -y 

*   3) Change vdsm config file to enable this feature

      # vi /etc/vdsm/vdsm.conf 
       [vars]

       fake_kvm_support = true  

*   4) Restart the vdsmd daemon (**Only required if you had previously VDSM installed**)

      # systemctl restart vdsmd.service 

*   5) Open the oVirt Engine portal and add the new 'Fake' Host

       Login with your admin user -> Hosts -> New 

*   6) The host should be UP

### Troubleshooting Fake KVM Support

**Problems adding the fake Host in the engine**

The vdsm bootstrapper was deprecated and replaced by ovirt-host-deploy, the /usr/share/doc/ovirt-host-deploy-1.1.0/README file includes details about how to configure a fake host.

**Failed: Server does not support virtualization**

If during the installation of the host you received the message "Server does not support virtualization" from oVirt Engine, it's probably because your vdsm version doesn't include the patch: <http://gerrit.ovirt.org/#/c/5611/3> (might be a bug as well).
 This patch add the 'fake kvm' support to vds_bootstrap.

There are several ways to update your vds_bootstrap, for example:

*   Yum update in **oVirt Engine** machine (if the repo is not updated, use the others approaches)

       # yum update vdsm-bootstrap 

*   Clone vdsm tree and create an updated vdsm-bootstrap rpm and update the **oVirt Engine** system

        # git clone git://gerrit.ovirt.org/vdsm
        # cd vdsm
        (if required increase the Version/Release from vdsm.spec.in)
        # ./autogen.sh --system && make && make rpm
        # rpm -Uvh ~/rpmbuild/RPMS/noarch/vdsm-bootstrap* 

*   Clone the vdsm tree, execute autogen/make and copy the vds_bootstrap/vds_bootstrap.py to /usr/share/vds_bootstrap

        # git clone git://gerrit.ovirt.org/vdsm
        # cd vdsm
        # ./autogen.sh --system && make
        # cp vds_bootstrap/vds_bootstrap.py /usr/share/vds_bootstrap 
                 

*   Manually backport the above <http://gerrit.ovirt.org/5611> patch to your current vds_bootstrap (/usr/share/vds_bootstrap)

        # vi /usr/share/vds_bootstrap/vds_bootstrap.py
        Make the changes manually

**Non Responsive status**

*   Check if vdsm and libvirt daemons are running
*   Firewall?

'''Default networks, the following networks are missing on host 'ovirtmgmt' '''

Something goes wrong setting the bridge ovirtmgmt, check the logs (/tmp/vds\*.log) in the host side.
If required, use the manual process to create the bridge and re-add the host: <http://www.ovirt.org/wiki/Installing_VDSM_from_rpm#Configuring_the_bridge_Interface>

## Running Node as guest - Nested KVM

Following the below instructions you can use oVirt Node, Fedora Node and oVirt Engine as guests.

Requires: Processors with **Full Virtualization** embedded

Attention: The below steps were tested on Fedora 17 but should work in higher versions (maybe not even required in the future releases, hopefully virt-manager will handle that directly in the next versions)

"Nested VMX" feature adds this missing capability - of running guest hypervisors (which use VMX) with their own nested guests. It does so by allowing a guest to use VMX instructions, and correctly
 and efficiently emulating them using the single level of VMX available in the hardware.

Finally, we are assuming you already have qemu-kvm/libvirt/virt-manager installed in your system

### Intel

*   1) Check if nested KVM is enabled (should be **Y**)

       # cat /sys/module/kvm_intel/parameters/nested
        N

*   2) In that case, it's disabled, to enable (can be via modprobe conf as well, simply: echo "options kvm-intel nested=1" > /etc/modprobe.d/kvm-intel.conf ):

       # vi /etc/default/grub

Add to the end of line **GRUB_CMDLINE_LINUX kvm-intel.nested=1**

Example:

       GRUB_CMDLINE_LINUX="rd.md=0 rd.dm=0  KEYTABLE=us SYSFONT=True rd.lvm.lv=vg/lv_root rd.luks=0 rd.lvm.lv=vg/lv_swap LANG=en_US.UTF-8 rhgb quiet kvm-intel.nested=1"

*   3) Save the changes:

       # grub2-mkconfig -o /boot/grub2/grub.cfg

*   4) Reboot the system:

       # reboot

*   5) Install oVirt Node as guest with virt-manager (or any other distro) and shutdown after the installation

<!-- -->

*   6) Copy the cpu model, vendor and vmx flag from **Hypervisor** to the guest:

       # virsh capabilities  (collecting data from hypervisor)
        ...
          <cpu match='exact'>
            <model>Penryn</model>
            <vendor>Intel</vendor>
            <feature policy='require' name='vmx'/>
          </cpu>
        ....

Note that I have removed all flags from my Hypervisor, just leaving he vmx but you can use all of them if you want.

Alright, time to add to your virtual machine (**guest**) the vmx flag:

       # vi /etc/libvirt/qemu/ovirt-node-2-5.xml (or virsh edit?)
        <domain type='kvm'>
          <cpu match='exact'>
            <model>Penryn</model>
            <vendor>Intel</vendor>
            <feature policy='require' name='vmx'/>
          </cpu>

Of course, all the above steps could be automated/improved. Fell free to change it.

*   7) Test if it works:

        # virsh create ovirt-node-2-5.xml

*   if the virtual machine starts check in the guest that vmx flag in the /proc/cpuinfo. Also, don't forget to define **(save) the new xml**:

        # virsh define /etc/libvirt/qemu/ovirt-node-2-5.xml

### AMD

Works out of the box.

*   1) To check if nested KVM is enabled (should be **1**)

       # cat /sys/module/kvm_amd/parameters/nested
        1

*   2) Install oVirt Node as guest with virt-manager (or any other distro).

<!-- -->

*   3) After virtual machine starts, check in the guest that svm flag in the /proc/cpuinfo.

       # grep -m1 svm /proc/cpuinfo
        flags           : fpu de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 syscall nx lm up nopl pni cx16 popcnt hypervisor lahf_lm svm abm sse4a

More info about nested-kvm: <https://github.com/torvalds/linux/blob/master/Documentation/virtual/kvm/nested-vmx.txt>

<Category:Vdsm> <Category:Documentation> [Category:Development environment](Category:Development environment)
