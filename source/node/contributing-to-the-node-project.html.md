---
title: Contributing to the Node project
category: node
authors: fabiand, mburns, quaid, rbarry
wiki_category: Contributing
wiki_title: Contributing to the Node project
wiki_revision_count: 6
wiki_last_updated: 2013-07-22
---

# Contributing to the Node project

## Overview

This page describes the patch submission process. As an open source project, oVirt Node gladly accepts and encourages the submission of patches from the community.

## Prerequisites

To clone a copy of one of the project repositories, refer to [Node Building](Node Building).

Some packages are required in order to run the oVirt TUI and test your changes. At the moment, these are:

    PyPAM python-augeas python-lockfile python-urwid python-gudev cracklib-python libvirt-python system-config-keyboard

You'll also need to create

    /etc/default/ovirt

It can be blank, but it must exist.

### Working with Gerrit

The oVirt team uses Gerrit to manage patch submissions. In order to get your development environment ready to submit, review [Working with oVirt Gerrit](Working with oVirt Gerrit).

Once you're ready,

    git clone gerrit.ovirt.org:ovirt-node.git

## Testing

In order to verify that the bug is fixed, you need to thorough test your changes prior to submitting them to the project for consideration. If your changes involve modifications on a level below the TUI, it would be a good idea to [ build an ISO to test with](Node Building) to simulate an actual install.

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

<Category:Contributing> <Category:Node>
