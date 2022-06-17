---
title: Making an oVirt release
category: release-management
authors:
  - sandrobonazzola
---

Updated on: 2022-01-20

# Making an oVirt release

The purpose of this document is to provide instructions on how to prepare a release for the oVirt project following the transition to external providers for
the git hosting and build execution.

## Development phase

During the development of the next oVirt release, patches are being verified using GitHub Actions.

We also have [oVirt System Tests](https://github.com/oVirt/ovirt-system-tests) for gating but haven't integrated them into GitHub Actions yet.

Once a PR is merged, the packages are being built by COPR infrastructure within the [ovirt/ovirt-master-snapshot](https://copr.fedorainfracloud.org/coprs/ovirt/ovirt-master-snapshot/) project.

Manual and automated testing can then be done using the [snapshot composes provided by COPR](/develop/dev-process/install-nightly-snapshot.html).

Instructions on how to get your package added to this flow are provided here:
- [Migrating a project from Gerrit to GitHub](/develop/developer-guide/migrating_to_github.html)
- [Adding a project to ovirt-master-snapshot COPR repository](/develop/release-management/process/add_a_package_to_copr.html)

## Pre release phase

A pre release (alpha, beta, release candidate) should be built from tagged content.
In order to do that we are going to use the [CentOS Community Build Service (CBS)](https://cbs.centos.org/koji/).

Package maintainers must have a [CentOS Account](https://accounts.centos.org/) or a [Fedora Account](https://accounts.fedoraproject.org/),
which were unified in the middle of 2021 to use the same account system.

In order to build for oVirt you need to be added to the CBS for which you need to join the [CentOS Virtualization SIG](https://wiki.centos.org/SpecialInterestGroup/Virtualization).
You can do that by attending a [Virt SIG IRC meeting](https://www.centos.org/community/calendar/#virtualization-sig)
or asking on the [CentOS Virt mailing list](https://lists.centos.org/mailman/listinfo/centos-virt).

> Please note that if you want to ship oVirt packages in other distributions, you'll need to get permissions there.
> For example, if you want to ship for Fedora, you need to be a package owner on the [Fedora Build System](https://koji.fedoraproject.org/koji/).
>
> At the time of writing, the oVirt project is focusing only on [CentOS Stream](https://www.centos.org/centos-stream/).

The build process on the [Community Build Service is documented on the CentOS website](https://wiki.centos.org/HowTos/CommunityBuildSystem).

Once you have been approved with the corresponding permissions, you need to set up a build environment and to generate an authentication certificate. It's described in detail in the page linked above, here is a short version:

```bash
# Install the necessary packages
dnf install epel-release
dnf install centos-packager fedora-packager

# If you haven't set up Kerberos yet, you may need to set
# the following line in /etc/krb5.conf if the default KEYRING
# setting doesn't work with the commands below:
# default_ccache_name = FILE:/tmp/krb5cc_%{uid}

# Log in to Kerberos
fkinit -u <your CentOS/Fedora account username>

# Generate the authentication certificate
centos-cert -u <your CentOS/Fedora account username>
```

A typical build is done by taking a src.rpm from the COPR [ovirt/ovirt-master-snapshot Builds](https://copr.fedorainfracloud.org/coprs/ovirt/ovirt-master-snapshot/builds/)
and rebuilding with:

```bash
# This builds a scratch (just a test) build for CentOS Stream 9 for oVirt 4.5
cbs build --scratch virt9s-ovirt-45-el9s <your package .src.rpm>

# This is for CentOS Stream 8:
cbs build --scratch virt8s-ovirt-45-el8s <your package .src.rpm>

# If the build goes through fine, you can do a real build
# CentOS Stream 9:
cbs build virt9s-ovirt-45-el9s <your package .src.rpm>

# CentOS Stream 8:
cbs build virt8s-ovirt-45-el8s <your package .src.rpm>
```

Once the builds complete it will be tagged as a candidate to be released as `virt8s-ovirt-45-candidate` (for CentOS Stream 8) or `virt9s-ovirt-45-candidate` (for CentOS Stream 9).

In order to publish the build you need to tag it for testing:

```bash
# CentOS Stream 8
cbs tag virt8s-ovirt-45-testing <your build without the trailing '.src.rpm'>

# Example:
cbs tag virt8s-ovirt-45-testing ovirt-hosted-engine-ha-2.4.10-1.el8
```

This will publish the build under the https://buildlogs.centos.org/centos/8-stream/virt/ repository.


```bash
# CentOS Stream 9
cbs tag virt9s-ovirt-45-testing <your build without the trailing '.src.rpm'>

#example:
cbs tag virt9s-ovirt-45-testing ovirt-hosted-engine-ha-2.4.10-1.el9
```

This will publish the build on https://buildlogs.centos.org/centos/9-stream/virt/.


## Release phase

Once the content in testing has been properly verified and considered good to be released for general availability, the release manager needs to tag the builds for release:

```bash
# CentOS Stream 8
cbs tag virt8s-ovirt-45-release <build without the trailing '.src.rpm'>

#example:
cbs tag virt8s-ovirt-45-release ovirt-hosted-engine-ha-2.4.10-1.el8
```

This will publish the build on the http://mirror.centos.org/centos/8-stream/virt/ repository and to CentOS mirrors.


```bash
# CentOS Stream 9
cbs tag virt9s-ovirt-45-release <build without the trailing '.src.rpm'>

# Example:
cbs tag virt9s-ovirt-45-release ovirt-hosted-engine-ha-2.4.10-1.el9
```

This will publish the build on http://mirror.stream.centos.org/SIGs/9-stream/virt/ and to CentOS mirrors.

## Release notes preparation

Release notes are auto-generated from git logs using scripts and config files stored in the [oVirt/releng-tools](https://github.com/oVirt/releng-tools) repository.

Please follow the instructions on the [oVirt Release Engineering Tools documentation](https://github.com/oVirt/releng-tools/blob/master/releases/README-prepare-patches).
Remember that the release config file is going to be used only to deliver content which couldn't build on CentOS Community Build Service (CBS).
The milestone config is the one used for generating the release notes.

Once ready, the notes can be automatically generated with [`release_notes_git.py`](https://github.com/oVirt/releng-tools/blob/master/release_notes_git.py) on the command line like:

```bash
# this assumes milestone/ovirt-4.5.0.conf being already populated
# https://github.com/oVirt/releng-tools/blob/master/milestones/ovirt-4.5.0.conf
 ./release_notes_git.py --git-basedir /var/tmp/release-cache --contrib-project-list ovirt-4.5.0 >notes.md
```

## Move oVirt verified bugs to closed

Have a look at oVirt bugs targeted to the milestone being shipped and in verified state.
You can use a query like:
```xml
https://bugzilla.redhat.com/buglist.cgi?quicksearch=classification%3Aovirt%20target_milestone%3A<replace_with_target_milestone>%20status%3Averified
```
using something like `ovirt-4.5.0` as replacement for `<replace_with_target_milestone>`.

Move them to `CLOSED` state with resolution `CURRENT`.
While doing it, a comment like the following would help:
```
This bugzilla is included in oVirt 4.5.0 release, published on April 20th 2022.
Since the problem described in this bug report should be resolved in oVirt 4.5.0 release, it has been closed with a resolution of CURRENT RELEASE.
If the solution does not work for you, please open a new bug report.
```


## Announcements

Once ready to announce, the release manager must ensure the announcement is sent:

To the [oVirt Blog](https://blogs.ovirt.org/)

To the relevant mailing list:

* [Announce](https://lists.ovirt.org/archives/list/announce@ovirt.org/)
* [Users](https://lists.ovirt.org/archives/list/users@ovirt.org/)
* [Devel](https://lists.ovirt.org/archives/list/devel@ovirt.org/)

To social media:

* [Twitter](https://twitter.com/ovirt)
* [Reddit](https://www.reddit.com/r/ovirt)
* [LinkedIn Official](https://www.linkedin.com/company/ovirt)
* [LinkedIn oVirt group](https://www.linkedin.com/groups/4707460/)
* [Facebook Official](https://www.facebook.com/groups/ovirt.openvirtualization)

To local communities:

* [LinkedIn oVirt Italia](https://www.linkedin.com/groups/13669751/)
* [Facebook oVirt India](https://www.facebook.com/groups/409421802961475/)
* [Facebook oVirt Italia](https://www.facebook.com/groups/ovirt.italia/)
* [Facebook oVirt Korea](https://www.facebook.com/groups/ovirt.korea/)
* [Facebook oVirt Malaysia](https://www.facebook.com/groups/ovirtUGMY/)
* [Facebook oVirt Myanmar](https://www.facebook.com/Ovirt-Myanmar-Community-974969229309990)
* [Facebook oVirt Philippines](https://www.facebook.com/groups/ovirtph/)

Missed something? Please add!

A typical announcement for social media:

```
The #oVirt project community is pleased to announce the general availability of the new stable release
of the #opensource #virtualization solution for your entire enterprise: oVirt <new version>.
Read more about it on <link to announcement blog post>.
```

Typical blog post: <https://blogs.ovirt.org/2022/01/ovirt-4-4-10-is-now-generally-available/>

Try contacting our [Press Plan Contacts](/develop/release-management/process/press-plan.html) to get press coverage.
