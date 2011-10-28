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

# Working with oVirt Gerrit

## registering as a user

* you can use any OpenID provider
* login page shows google and yahoo
* any fedora FAS account can login as well via
<https://admin.fedoraproject.org/accounts/openid/id/>&lt;username&gt;

## set ssh keys in gerrit settings

* on your local machine, create a set of ssh keys if you don't have one via

      'ssh-keygen -t rsa'
       

* update via gerrit settings the ssh public key to allow ssh to gerrit

## define gerrit in ~/.ssh/config

      Host gerrit.ovirt.org
         HostName gerrit.ovirt.org
         Port 29418
         User &lt;username&gt;
       

## check ssh works correctly, verify and ack the host fingerprint

      ssh gerrit.ovirt.org
       

if you get this, it is fine:

      ***    Welcome to Gerrit Code Review    ****
       

## cloning the repo

      git clone gerrit.ovirt.org:ovirt-engine
       

this can be done without registering to gerrit using:

      git clone git://gerrit.ovirt.org/ovirt-engine
       

## install the change-Id hook

**you must do this before you commit anything**

      scp -p gerrit.ovirt.org:hooks/commit-msg .git/hooks/
       

## rebase

      git fetch gerrit.ovirt.org:ovirt-engine master
       

## push your patch for review

      git push gerrit.ovirt.org:ovirt-engine HEAD:refs/for/master
       

## track patch review process

the review process is comprised of: - anyone can send a patch - anyone can code review and comment on the patch and +1/-1. This helps maintainers in reviewing the patches. - a maintainer can code review it with +2 it, which is required to commit (submit) it. - someone (anyone) needs to confirm they checked the patch works and flag it as verified +1 - a maintainer can submit (commit) the patch when it has:

        Code Review: +2
        Verified: +1

* nacked (-1) patches should not be submitted - a submitted patch is merged to the git

[1] if anyone provides a reason to limit to specific OpenID providers that's an option as well.
