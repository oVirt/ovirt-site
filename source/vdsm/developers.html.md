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

## Getting the source

Our public git repo is located on [oVirt.org](http://gerrit.ovirt.org/gitweb?p=vdsm.git)

you can clone it with

`git clone `[`http://gerrit.ovirt.org/p/vdsm.git`](http://gerrit.ovirt.org/p/vdsm.git)

## Building a Vdsm RPM

Vdsm uses autoconf and automake as it's build system.

       Fedora users should verify the following packages are installed before attempting to build:
       yum install autoconf automake pyflakes logrotate gcc python-pep8 libvirt-python python-devel python-nose rpm-build sanlock-python

To configure the build env:

      ./autogen.sh --system

To create an RPM do:

      make rpm

or

      make NOSE_EXCLUDE=.* rpm  (As development only, avoid the unittests validation)

Vdsm automatically builds using the latest tagged version. If you want to explicitly define a version use

      make rpmversion=4.9 rpmrelease=999.funkyBranch

## Code Style

*   variables and arguments are in mixedCase
*   class names are in CamelCase
*   all indentation is made of space characters
*   a space character follows any comma
*   spaces surround operators, but
*   no spaces between

      def f(arg=its_default_value)

*   lines longer than 80 chars are frowned upon
*   whitespace between functions and within stanza help to breath while reading code
*   a space char follows a comment's hash char
*   let logging method do the formatting for you:

      logging.debug('hello %s', 'world')

rather than

      logging.debug('hello %s' % 'world')

## Sending patches

Send them to [our gerrit server](http://gerrit.ovirt.org) ([see how](Working with oVirt Gerrit)). With your first major patch, do not forget to add yourself to the AUTHORS file. Do not be shy - it gives you a well-deserved recognition, and it shows to the team that you stand behind your code.

General development discussions are in `vdsm-devel@lists.fedorahosted.org`.

## Creating local yum repo to test vdsm changes

1) First you will need to generate the rpm with your changes, from the vdsm source directory:

      #vdsm> ./autogen.sh --system
      #vdsm> make
      #vdsm> make rpm

**Note**: all rpm files will be generated at rpmbuild dir, usually: /home/your-user/rpmbuild/RPMS

2) Setting environment:

*   Install required package

      # yum install createrepo -y

*   Enable httpd service

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

<Category:Vdsm> <Category:Documentation> [Category:Development environment](Category:Development environment)
