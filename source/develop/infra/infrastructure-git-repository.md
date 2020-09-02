---
title: Infrastructure git repository
category: infra
authors: quaid
---

# Infrastructure git repository

## Overview

This repository is a private git repo setup for maintaining server configurations. This also gives us a quick way to rollback changes.

In the future there may be other services that supersede this need, but for now this is a lightweight solution to the problem.

## Steps

1.  Make the config folder symlink:
        cd /root/git/
        ln -s /path/to/foo-project/config/ ovirt-infra-foo

2.  Change in to the config folder via the symlink, then initiate a git repo:
        cd ovirt-infra-foo
        git init

3.  Add one or more files and directories to the repository, then commit the changes:
        git add * ## Or a specific file or directory
        git commit -m "Initial commit message."

4.  Change to the local git root and make a directory for the new git repo:
        cd /usr/local/git_root/
        mkdir ovirt-infra-foo.git

5.  Change to the new directory and initiate the bare repository:
        cd ovirt-infra-foo.git/
        git --bare init

6.  These configurations make sure everything is kept group read/write; merges are disallowed on push; and directory permissions are set:
        git config core.sharedrepository 1
        git config receive.denyNonFastforwards true
        find objects -type d -exec chmod 02770 {} \;

7.  Change back to the original directory, set the new origin location for tracking, and push up the initial commit:
        cd /root/git/ovirt-infra-foo
        git remote add origin /usr/local/git_root/ovirt-infra-foo.git
        git push origin master

8.  Create local "master" branch that is tracking "origin/master", switch to the new branch:
        git checkout origin/master
        git branch -f master origin/master
        git checkout master

### Example session

    [root@linode01 git]# ln -s /usr/lib/mailman/Mailman/ ovirt-infra-mailman
    [root@linode01 git]# cd ovirt-infra-mailman/
    [root@linode01 ovirt-infra-mailman]# ls
    Archiver           Digester.pyc        HTMLFormatter.pyc  Mailbox.pyo              OldStyleMemberships.pyo  TopicMgr.py
    Autoresponder.py   Digester.pyo        HTMLFormatter.pyo  MailList.py              Pending.py               TopicMgr.pyc
    Autoresponder.pyc  Errors.py           i18n.py            MailList.pyc             Pending.pyc              TopicMgr.pyo
    Autoresponder.pyo  Errors.pyc          i18n.pyc           MailList.pyo             Pending.pyo              UserDesc.py
    Bouncer.py         Errors.pyo          i18n.pyo           MemberAdaptor.py         Post.py                  UserDesc.pyc
    Bouncer.pyc        GatewayManager.py   __init__.py        MemberAdaptor.pyc        Post.pyc                 UserDesc.pyo
    Bouncer.pyo        GatewayManager.pyc  __init__.pyc       MemberAdaptor.pyo        Post.pyo                 Utils.py
    Bouncers           GatewayManager.pyo  __init__.pyo       Message.py               Queue                    Utils.pyc
    Cgi                Generator.py        ListAdmin.py       Message.pyc              SafeDict.py              Utils.pyo
    Commands           Generator.pyc       ListAdmin.pyc      Message.pyo              SafeDict.pyc             Version.py
    Defaults.py        Generator.pyo       ListAdmin.pyo      mm_cfg.py                SafeDict.pyo             Version.pyc
    Defaults.pyc       Gui                 LockFile.py        mm_cfg.pyc               SecurityManager.py       Version.pyo
    Defaults.pyo       Handlers            LockFile.pyc       mm_cfg.py.dist           SecurityManager.pyc      versions.py
    Deliverer.py       htmlformat.py       LockFile.pyo       mm_cfg.pyo               SecurityManager.pyo      versions.pyc
    Deliverer.pyc      htmlformat.pyc      Logging            MTA                      Site.py                  versions.pyo
    Deliverer.pyo      htmlformat.pyo      Mailbox.py         OldStyleMemberships.py   Site.pyc
    Digester.py        HTMLFormatter.py    Mailbox.pyc        OldStyleMemberships.pyc  Site.pyo
    [root@linode01 ovirt-infra-mailman]# git init
    Initialized empty Git repository in /usr/lib/mailman/Mailman/.git/
    [root@linode01 ovirt-infra-mailman]# git add mm_cfg.py
    [root@linode01 ovirt-infra-mailman]# git commit -m "Mailman git only needs the single config file, afaict."
    [master (root-commit) 93777d4] Mailman git only needs the single config file, afaict.
     Committer: root <root@linode01.ovirt.org>
    Your name and email address were configured automatically based
    on your username and hostname. Please check that they are accurate.
    You can suppress this message by setting them explicitly:

        git config --global user.name "Your Name"
        git config --global user.email you@example.com

    If the identity used for this commit is wrong, you can fix it with:

        git commit --amend --author='Your Name <you@example.com>'

     1 files changed, 100 insertions(+), 0 deletions(-)
     create mode 100644 mm_cfg.py
    [root@linode01 ovirt-infra-mailman]# pwd
    /root/git/ovirt-infra-mailman
    [root@linode01 ovirt-infra-mailman]# cd /usr/local/git_root/
    [root@linode01 git_root]# ls
    ovirt-infra-wordpress.git
    [root@linode01 git_root]# mkdir ovirt-infra-mailman.git
    [root@linode01 git_root]# cd ovirt-infra-mailman.git/
    [root@linode01 ovirt-infra-mailman.git]# git --bare init
    Initialized empty Git repository in /usr/local/git_root/ovirt-infra-mailman.git/
    [root@linode01 ovirt-infra-mailman.git]# git config core.sharedrepository 1
    [root@linode01 ovirt-infra-mailman.git]# git config receive.denyNonFastforwards true
    [root@linode01 ovirt-infra-mailman.git]# find objects -type d -exec chmod 02770 {} \;
    [root@linode01 ovirt-infra-mailman.git]# cd /root/git/ovirt-infra-mailman/
    [root@linode01 ovirt-infra-mailman]# git remote add origin /usr/local/git_root/ovirt-infra-mailman.git/
    [root@linode01 ovirt-infra-mailman]# git push origin master
    Counting objects: 3, done.
    Delta compression using up to 4 threads.
    Compressing objects: 100% (2/2), done.
    Writing objects: 100% (3/3), 1.92 KiB, done.
    Total 3 (delta 0), reused 0 (delta 0)
    Unpacking objects: 100% (3/3), done.
    To /usr/local/git_root/ovirt-infra-mailman.git/
     * [new branch]      master -> master
    [root@linode01 ovirt-infra-mailman]# git checkout origin/master
    Note: checking out 'origin/master'.

    You are in 'detached HEAD' state. You can look around, make experimental
    changes and commit them, and you can discard any commits you make in this
    state without impacting any branches by performing another checkout.

    If you want to create a new branch to retain commits you create, you may
    do so (now or later) by using -b with the checkout command again. Example:

      git checkout -b new_branch_name

    HEAD is now at 93777d4... Mailman git only needs the single config file, afaict.
    [root@linode01 ovirt-infra-mailman]# git branch -f master origin/master
    Branch master set up to track remote branch master from origin.
    [root@linode01 ovirt-infra-mailman]# git checkout master
    Switched to branch 'master'

## Resources

*   <http://qugstart.com/blog/ruby-and-rails/create-a-new-git-remote-repository-from-some-local-files-or-local-git-repository/>

[Category:Infrastructure documentation](/develop/infra/infrastructure-documentation.html)
