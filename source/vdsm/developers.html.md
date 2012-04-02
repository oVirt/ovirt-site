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

Vdsm uses autoconf and automake as it's build system. To configure the build env:

      ./autogen.sh --system

To create an RPM do:

      make rpm

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

<Category:Vdsm> <Category:Documentation> [Category:Development environment](Category:Development environment)
