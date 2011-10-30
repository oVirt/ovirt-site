---
title: Working with oVirt Gerrit
category: documentation
authors: abonas, amuller, amureini, asaf, dcaroest, dneary, doron, dougsland, iheim,
  lpeer, mburns, mkovgan, msalem, ovedo, quaid, rmiddle, roy, sgordon, vered
wiki_category: Documentation
wiki_title: Working with oVirt Gerrit
wiki_revision_count: 62
wiki_last_updated: 2015-06-09
---

# Working with gerrit.ovirt.org

Gerrit is a web based code review system, facilitating online code reviews for projects using the Git version control system. Gerrit makes reviews easier by showing changes in a side-by-side display, and allowing inline comments to be added by any reviewer. We use Gerrit in the oVirt project in order to review new commits, as it easily enables adding comments, suggestions, ask questions, and etc. The following sections are a step-by-step manual to set up a Gerrit environment in your development environment.

### Registering as a user

First of all you need to register as a new user to gerrit. You can do that by using any OpenID provider:

*   Login page shows Google and Yahoo
*   Any fedora FAS account can login as well via

<https://admin.fedoraproject.org/accounts/openid/id/>&lt;username&gt;

### Set SSH keys in Gerrit settings

*   On your local machine, create a set of SSH keys (if you don't already have one) via

      'ssh-keygen -t rsa'
       

*   Update via Gerrit settings the SSH public key to allow SSH to Gerrit

### Define Gerrit in ~/.ssh/config

      Host gerrit.ovirt.org
         HostName gerrit.ovirt.org
         Port 29418
         User &lt;username&gt;
       

### Verify configuration

In order to verify your SSH configuration, do the following:

      ssh gerrit.ovirt.org
       

if you get this, it is fine:

      ***    Welcome to Gerrit Code Review    ****
       

### Cloning the oVirt-engine repository

      git clone gerrit.ovirt.org:ovirt-engine
       

This can also be done without registering to Gerrit, using:

      git clone git://gerrit.ovirt.org/ovirt-engine
       

### install the change-ID hook

**You must do this before you commit anything**
In order to easily track commit changes in Gerrit, each commit must have a change-ID. This change-ID is added automatically via a Git hook. In order to install this hook do the following:

      cd ovirt-engine
      scp -p gerrit.ovirt.org:hooks/commit-msg .git/hooks/
       

### Rebase

      git fetch gerrit.ovirt.org:ovirt-engine master
       

### Push your patch for review

      git push gerrit.ovirt.org:ovirt-engine HEAD:refs/for/master
       

### Track patch review process

The review process is comprised of:

*   Anyone can send a patch
*   A review in Gerrit can result in:
    -   +2 - Looks good to me, approved
    -   +1 - Looks good to me, but someone else must approve
    -   0 - No score
    -   -1 - I would prefer that you didn't submit this
    -   -2 - Do not submit
*   Anyone can code review and comment on the patch and +1/-1. This helps maintainers in reviewing the patches
*   A maintainer can code review it with +2 it, which is required to commit (submit) it
*   Someone (can be anyone) needs to confirm they checked the patch works and flag it as verified +1
*   A maintainer can submit (commit) the patch when it has:
    \* Code Review: +2
    -   Verified: +1
*   NACK-ed (-1/-2) patches should not be submitted
*   A submitted patch is automatically merged to the git repository
