---
title: Contributing to the Node project
category: node
authors: fabiand, mburns, quaid, rbarry, sandrobonazzola
---
# The oVirt Node team and project

## Who's in oVirt Node team?

The members of the oVirt Node team are

*   [Douglas Schilling Landgraf](https://github.com/dougsland)
*   Ryan Barry
*   [Sandro Bonazzola](https://github.com/sandrobonazzola)
*   Yuval Turgeman

Outstanding contributors

*   Alan Pevec
*   Fabian Deutsch
*   Haiyang Dong
*   Ido Rosenzwig
*   Joey Boggs
*   Mike Burns
*   Perry Myers
*   Tolik Litovsky


## What does oVirt Node team do?

Leads the following projects:

*   oVirt NextGeneration Node
*   oVirt Node
*   oVirt Engine Appliance

Collaborates with other communities / projects:

*   [Fedora](https://getfedora.org/)
*   [CentOS](http://centos.org/)
*   [VDSM](/develop/developer-guide/vdsm/vdsm/)
*   [Libvirt](http://libvirt.org/)
*   [oVirt Continuous Integration / Infra](/develop/infra/infrastructure/)
*   [Gluster](http://www.gluster.org/)

## How may I help?

*   Fixing one of the [open bugs](https://bugzilla.redhat.com/buglist.cgi?quicksearch=product%3Aovirt%20cf_ovirt_team%3Anode%20status%3Anew) we have (see below section on how to contribute code)
*   Testing one of the [bugs we fixed](https://bugzilla.redhat.com/buglist.cgi?quicksearch=product%3Aovirt%20cf_ovirt_team%3Anode%20status%3Amodifed%2Con_qa)
*   Joining the [oVirt Quality Assurance](/develop/projects/project-qa/) effort
*   Help updating documentation


# Contributing to the Node project

## Overview

This page describes the patch submission process. As an open source project, oVirt Node gladly accepts and encourages the submission of patches from the community.

## Prerequisites

To clone a copy of one of the project repositories, refer to [Node Building](/develop/projects/node/building/).

Some packages are required in order to run the oVirt TUI and test your changes. At the moment, these are:

    PyPAM python-augeas python-lockfile python-urwid python-gudev cracklib-python libvirt-python system-config-keyboard

You'll also need to create

    /etc/default/ovirt

It can be blank, but it must exist.

### Working with Gerrit

The oVirt team uses Gerrit to manage patch submissions. In order to get your development environment ready to submit, review [Working with oVirt Gerrit](/develop/dev-process/working-with-gerrit/).

Once you're ready,

    git clone gerrit.ovirt.org:ovirt-node.git

## Testing

In order to verify that the bug is fixed, you need to thorough test your changes prior to submitting them to the project for consideration. If your changes involve modifications on a level below the TUI, it would be a good idea to [build an ISO to test with](/develop/projects/node/building/) to simulate an actual install.

## Committing Your Changes

You should frequently check in your changes to make sure your work isn't lost.

When you get to a stopping point, you can commit your changes to Git using the following:

    git commit -a [--amend]

You only need to include the *--amend* argument on subsequent commits to add them to your previous changes.

### Commit comments

When entering the comment for your patch, please use the first line to be a one sentence summary of your changes, and try to limit it to less than 70 characters. This line is used by Gerrit to set the title of your patch.

Starting with the second line, please provide a sufficiently detailed description of what the patch is providing. If there is a [ticket](https://fedorahosted.org/ovirt/report) that is related to the patch, please include a line such as this at the end of the comment:

Use the following format to point to a RedHat Bugzilla ID or other external bug the patch solves:

`Bug-Url: `[`http://bugzilla.redhat.com/show_bug.cgi?id=123456`](http://bugzilla.redhat.com/show_bug.cgi?id=123456)

### Working with EFI/UEFI bios and QEMU

If you are interested in reproduce a report using EFI/UEFI bios we comment this link: [Using UEFI with QEMU](https://fedoraproject.org/wiki/Using_UEFI_with_QEMU)

### Example commit message

Summarizing all the informations above a commit message could look like:

    ui: Add page to view log files

    Previously the UI did not offer a page to view the system wide logfiles.
    This patch adds a page which the user can use to view a number of log files.

    Bug-Url: http://bugzilla.redhat.com/show_bug.cgi?id=123456

## Creating and submitting the patch

To create a patch in Gerrit, you will do the following:

    git push gerrit.ovirt.org:ovirt-node HEAD:refs/for/master

## Finishing up

Your patch will be reviewed on Gerrit, and comments on that patch will go to the email you registered with Gerrit. You can view it on [oVirt Gerrit](http://gerrit.ovirt.org) at any time.

