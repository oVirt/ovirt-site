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

This page needs significant updates once we integrate with git and gerrit hosted on the oVirt infrastructure

## Prerequisites

To clone a copy of one of the project repositories, refer to the [Build instructions](Build instructions).

What you need to have is a development environment that allows you to create a branch for writing your code and to build and test your changes prior to submitting them to the project.

## Creating the development branch

Unless you're submitting a high priority bug fix, all patches should be based on the current development branch.

### First, start tracking the next branch (only do it once)

The oVirt team does all development work on a branch named **next**, so you should create your development branch off of that. To begin tracking the **next** branch, in your git repo you would do the following:

    git checkout -b next --track origin/next

... which creates a local branch named **next** that will track the remote branch with the name **next**; i.e., it updates based on the central repository's contents.

### Second, create your development branch

Now that you have the **next** branch, create your development branch based on it. To do so, you do the following:

    git checkout -b [the name of your branch] next

This creates a new branch with the name you specified and bases it on the **next** branch. You want to do this to ensure that your changes cleanly apply on top of the current codebase.

Now you're ready to start working on your new feature or bug fix.

## Testing

In order to verify that the bug is fixed, you need to thorough test your changes prior to submitting them to the project for consideration. Depending on the code being written, the type of tests will change.

## Committing Your Changes

You should frequently check in your changes to make sure your work isn't lost.

When you get to a stopping point, you can commit your changes to Git using the following:

    git commit -a [--amend]

You only need to include the *--amend* argument on subsequent commits to add them to your previous changes. Be sure you do **not** do this with your first commit as that will tack it onto someone else's work.

### Commit comments

When entering the comment for your patch, please use the first line to be a one sentence summary of your changes, and try to limit it to less than 70 characters. This line is used by Git to set the Subject: of the patch email that you create later.

Starting with the second line, please provide a sufficiently detailed description of what the patch is providing. If there is a [ticket](https://fedorahosted.org/ovirt/report) that is related to the patch, please include a line such as this at the end of the comment:

      Resolves: !#123456

where the numbers are the Bugzilla ticket id.

### !ChangeLog entry

Please be sure to add a note in the file **!ChangeLog** describing your patch. This helps to make sure your changes are documented when a release is made available.

## Creating and submitting the patch

To create a patch in Git, you will do the following.

    git format-patch HEAD~1 --signoff

This creates a new, ready-to-be-mailed patch file that includes all of your changes, as well as your details. **This is important:** we want to make sure you get the credit for your changes, and also keeping track of who made what changes so that questions go to the right person.

Once created, simple send the patch using the following:

    git send-email [the name of the patch file]

<Category:Contributing> <Category:Node>
