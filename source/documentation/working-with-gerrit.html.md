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

Gerrit is a web based code review system, facilitating online code reviews for projects using the Git version control system.
Gerrit makes reviews easier by showing changes in a side-by-side display, and allowing inline comments to be added by any reviewer.
We use Gerrit in the oVirt project in order to review new commits, as it easily enables adding comments, suggestions, ask questions, and etc.
The following sections are a step-by-step manual to set up a Gerrit environment in your development environment.
oVirt Gerrit environment is in gerrit.ovirt.org

### Registering as a user

First of all you need to register as a new user to [gerrit](http://gerrit.ovirt.org). You can do that by using any OpenID provider:

*   Login page shows Google and Yahoo
*   Any fedora FAS account can login as well via

&lt;username&gt;.id.fedoraproject.org

Once you register, choose your username for the Gerrit system - this is the username you will use later in your SSH configuration: Settings --> HTTP Password

### SSH configuration

#### Set SSH keys in Gerrit settings

*   On your local machine, create a set of SSH keys (if you don't already have one) via

      ssh-keygen -t rsa
       

*   Ensure that your private RSA key is in ~/.ssh and that the permissions on the .ssh directory are sufficiently restrictive (typically, the directory .ssh should have permissions 700, and the file .ssh/id_rsa should have the permissions 600).
*   Update via Gerrit settings the SSH public key to allow SSH to Gerrit - in the SSH Public Keys settings, copy and paste the contents of your public key file (typically id_rsa.pub) into the text box shown.

#### Define Gerrit in ~/.ssh/config

      Host gerrit.ovirt.org
         HostName gerrit.ovirt.org
         Port 29418
         User &lt;username&gt;
       

#### Change permissions to the file

      chmod 600 ~/.ssh/config
       

#### Verify SSH configuration

In order to verify your SSH configuration, do the following:

      ssh gerrit.ovirt.org
       

if you get this, it is fine:

      ***    Welcome to Gerrit Code Review    ****
       

### Git configuration and procedures

#### Cloning the oVirt-engine repository

      git clone gerrit.ovirt.org:ovirt-engine
       

This can also be done without registering to Gerrit, using:

      git clone git://gerrit.ovirt.org/ovirt-engine
       

#### Install the change-ID hook

**You must do this before you commit anything**
In order to easily track commit changes in Gerrit, each commit must have a change-ID. This change-ID is added automatically via a Git hook. In order to install this hook do the following:

      cd ovirt-engine
      scp -p gerrit.ovirt.org:hooks/commit-msg .git/hooks/

**ATTENTION**: All of the ovirt projects require a Signed-off-by (SOB), add the following lines in the end of .git/hooks/commit-msg, after the line "add_ChangeId":

      SOB=$(git var GIT_AUTHOR_IDENT | sed -n 's/^\(.*>\).*$/Signed-off-by: \1/p')
      grep -qs "^$SOB" "$1" || echo "$SOB" >> "$1"

**Note**: If you commit something before you do the above, you can add the Change-ID and signed-off-by lines by:

      git commit --amend -s
       

#### Configure git personal settings

      git config --global user.name "John Doe"
      git config --global user.email johndoe@example.com
       

#### Configure the commit template

      cd ovirt-engine
      git config commit.template config/engine-commit-template.txt
       

#### Rebase

      git fetch -v
      git rebase origin/master
       

#### Push your patch for review

      git push gerrit.ovirt.org:ovirt-engine HEAD:refs/for/master
       

Assuming you remote repo is origin you could also

      git push origin HEAD:refs/for/master
       

#### Track patch review process

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
*   When uploading a new patch set, the contributor should also add a review comment of the changes from previous version, to help reviewers track and review the changes (unless gerrit itself added a comment that a rebase is needed, and in that case no new comment is needed).

#### Submit your topic branch to gerrit

[topic branch](http://progit.org/book/ch3-4.html) is a short-lived branch that you create and use for a single particular feature or related work.

*   First, download git-review tool from openstack and copy to your project
    -   git-review is a tool that helps submitting git branches to gerrit for review.
    -   URL: <https://github.com/openstack-infra/git-review>

        $ git clone https://github.com/openstack-infra/git-review
        $ cp git-review/git-review project/ 

*   Setting git-review:

      git-review, by default, looks for a git remote called gerrit, and submits the current branch to HEAD:refs/for/master at that remote.
      If the "gerrit" remote does not exist, git-review looks for a file called .gitreview at the root of the repository with information
      about the gerrit remote. Assuming that file is present, git-review should be able to automatically configure your 
      repository the first time it is run. 

*   Example: project/.git/config

      [remote "gerrit"]
        url = http://gerrit.ovirt.org/p/project
        pushurl = ssh://username@gerrit.ovirt.org:29418/project.git
        fetch = +refs/heads/*:refs/remotes/gerrit/* 

*   Execute git-review setup

        $project> ./git-review -s 

*   Create your local branch feature

        $project> git checkout -b engine-register 

*   Check if you are under branch

        $project> git branch
        * engine-register
        master  

*   Execute the changes and commit it

        $project> vi source.py
        $project> git add source.py
        $project> git commit  

*   Submit the topic branch changes to gerrit

        $project>./git-review -t engine-register
        remote: Resolving deltas:   0% (0/3)
        remote: (W) fba45fe: no files changed, message updated
        To ssh://user@gerrit.ovirt.org:29418/project.git
       * [new branch]      HEAD -> refs/for/master/engine-register 

*   Now go to the gerrit url for your change and note that the topic field is changed to your topic branch name.

<Category:Documentation> [Category:Development environment](Category:Development environment) <Category:Git> [Category:Source code repository](Category:Source code repository)
