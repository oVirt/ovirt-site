---
title: Working with oVirt Gerrit
category: documentation
toc: true
authors: abonas, amuller, amureini, asaf, dcaroest, dneary, doron, dougsland, iheim,
  lpeer, mburns, mkovgan, msalem, ovedo, quaid, rmiddle, roy, sgordon, vered
---

# Working with oVirt Gerrit

Gerrit is a web-based code review system that uses the Git version control system. Gerrit makes it easy to review code by showing changes in a side by side display, allowing inline comments to be added by any reviewer.
In the oVirt project we use Gerrit to review new commits. With Gerrit, it's easy to add comments and suggestions, ask questions, and more.
In the following sections you will find step-by-step directions for setting up Gerrit in your development environment.

To get started, go to [gerrit.ovirt.org.](https://gerrit.ovirt.org)

## Registering as a User

You can register as a user with any OpenID provider.
Alternatively, sign in with:

* GitHub or Google OAuth 2.0
* Your Launchpad or Yahoo IDs
* Any fedora FAS account, using: &lt;username&gt;.id.fedoraproject.org


Once you log in, choose a Gerrit username. This username will be used to generate an HTTP password (Settings --> HTTP Password).

## SSH Configuration

### Setting up SSH Keys

If you don’t have a set of SSH keys, open the terminal on your local machine and enter the following:

ssh-keygen -t rsa

Ensure that your private RSA key is located at ~/.ssh and that the permissions on the .ssh directory are sufficiently restrictive. Typically, the .ssh directory should have permissions set to 700, and the file .ssh/id_rsa should have the permissions set to 600.

To allow SSH to access Gerrit, update the SSH public key via Gerrit settings:

* In the top right corner, click your username, and select Settings > SSH public keys.
* Copy and paste the contents of your public key file (typically ~/.ssh/id_rsa.pub) into the provided text box.

### Defining Gerrit in ~/.ssh/config

      Host gerrit.ovirt.org
         HostName gerrit.ovirt.org
         Port 29418
         User <username>
         PubkeyAcceptedKeyTypes=+rsa-sha2-512
       

### Changing File Permissions

      chmod 600 ~/.ssh/config
       

### Verifying the SSH Configuration

      ssh gerrit.ovirt.org

If SSH is configured correctly, you will see the following message:

      ***    Welcome to Gerrit Code Review    ****
       

## Git Configuration and Procedures

### Cloning the oVirt-engine Repository

      git clone gerrit.ovirt.org:ovirt-engine
       

For a read-only repository, this can also be done using:

      #Read-only
      git clone git://gerrit.ovirt.org/ovirt-engine
       

### Installing the change-ID Hook

**You must do this before you commit anything**
In order to easily track commit changes in Gerrit, each commit must have a change-ID. This change-ID is added automatically via a Git hook. To install this hook, enter:

      cd ovirt-engine
      scp -p gerrit.ovirt.org:hooks/commit-msg .git/hooks/

Or alternatively without need of authentication:

      wget -P .git/hooks https://gerrit.ovirt.org/tools/hooks/commit-msg

**ATTENTION**: All of the ovirt projects require a Signed-off-by (SOB), add the following lines in the end of .git/hooks/commit-msg, after the line "add_ChangeId":

      SOB=$(git var GIT_AUTHOR_IDENT | sed -n 's/^\(.*>\).*$/Signed-off-by: \1/p')
      grep -qs "^$SOB" "$1" || echo "$SOB" >> "$1"

Allow the hook to be executed:

      chmod a+x .git/hooks/commit-msg

**Note**: If you commit something before you do the above, you can add the Change-ID and signed-off-by lines by:

      git commit --amend -s
       

### Configuring Git Personal Settings

      git config --global user.name "John Doe"
      git config --global user.email johndoe@example.com
       

### Configuring the Commit Template

      cd ovirt-engine
      git config commit.template config/engine-commit-template.txt
       


> **_NOTE:_** Alternatively, if you're contributing to other projects than ovirt-engine
> try looking for template in it's git tree instead.

### Configuring the Git Commit Spell Check, Syntax Highlighting and Maxwidth

      # edit ~/.vimrc
      syntax on
      filetype plugin indent on
      autocmd Filetype gitcommit spell textwidth=72
       

### Rebasing

      git fetch -v
      git rebase origin/master
       

## Pushing a Patch for Review

Enter:

      git push gerrit.ovirt.org:ovirt-engine HEAD:refs/for/master
       

Alternatively, assuming your remote repository is 'origin', enter:

      git push origin HEAD:refs/for/master
       

### Pushing or Updating a Draft Using the Git Review Plugin

The git-review plugin is optional.

To push or update a draft, enter:

      git review -D -r origin master
       

To push or update a published patch:

      git review -r origin master
       

## The Track Patch Review Process

### A Summary of the Process

The patch life cycle process comprises of the following steps:

1.  ‎The patch is checked
    -   Verification (Verified+1): bug fixes or new functionality should be verified by a real person
    -   Maintainer review and approval (Code-Review+2)
    -   Publishing. This triggers Continuous Integration (CI)

2.  CI tests passed (Continuous-Integration+1)
3.  Patch merged by maintainer

### The Process in Detail

*   Anyone can send a patch
    -   Initially a patch should be sent as draft
*   Code-Review - human code review:
*   A human code review can result in "Code-Review" flag set to:
    -   -   +2 - Looks good to me, approved
        -   +1 - Looks good to me, but someone else must approve
        -   0 - No score
        -   -1 - I would prefer that you didn't submit this
        -   -2 - Do not submit
    -   Anyone can set Code-Review flag to +1/-1 and comment on the patch. This helps maintainers in reviewing the patches
    -   Only maintainer(s) can set Code-Review flag to +2, which is required to commit (submit) it

*   Verified - human verified
    -   Somebody (can be anyone) needs to confirm they checked the patch works and set "Verified" flag to +1
    -   this doesn't have to be the developer
    -   this does not have to be done fully manually, but human must verify
*   Automated tests by continuous integration:
    -   After humans have:
        -   set Code-Review +2
        -   confirmed the patch is ready and has Verified +1
    -   The developer should publish the draft patch:
        -   Visit the patch page with your browser
        -   Press on the button "Publish" in the web view of your patch
    -   After "Verified" flag is +1 and the patch is published, CI Runs on patch set updates:
        -   CI sets "Continuous-Integration" flag to:
            -   +1 if the patch passes CI tests
            -   -1 if the patch fails CI tests
*   The maintainer(s) can submit (commit) the patch when it has:
    \* Code-Review: +2
    -   Verified: +1
    -   Continuous-Integration: +1
*   NACK-ed (-1/-2) patches should not be submitted
*   A submitted patch is automatically merged to the git repository
*   When uploading a new patch set, the contributor should also add a review comment of the changes from previous version, to help reviewers track and review the changes (unless Gerrit itself added a comment that a rebase is needed, and in that case no new comment is needed).

### Submitting a Topic Branch to Gerrit

A [topic branch](http://progit.org/book/ch3-4.html) is a short-lived branch that you create and use for a single particular feature or related work.

*   First, download the git-review tool from Openstack and copy it to your project
    -   git-review is a tool that helps submitting git branches to Gerrit for review.
    -   URL: <https://github.com/openstack-infra/git-review>

&nbsp;

        $ git clone https://github.com/openstack-infra/git-review
        $ cp git-review/git-review project/

*   Setting git-review:

      git-review, by default, looks for a git remote called gerrit, and submits the current branch to HEAD:refs/for/master at that remote.
      If the "gerrit" remote does not exist, git-review looks for a file called .gitreview at the root of the repository with information
      about the gerrit remote. Assuming that file is present, git-review should be able to automatically configure your 
      repository the first time it is run. 

*   Example: project/.git/config

&nbsp;

      [remote "gerrit"]
        url = http://gerrit.ovirt.org/p/project
        pushurl = ssh://username@gerrit.ovirt.org:29418/project.git
        fetch = +refs/heads/*:refs/remotes/gerrit/* 

*   Execute git-review setup

&nbsp;

        $project> ./git-review -s 

*   Create your local branch feature

&nbsp;

        $project> git checkout -b engine-register 

*   Check if you are under branch

&nbsp;

        $project> git branch
        * engine-register
        master  

*   Execute the changes and commit it

&nbsp;

        $project> vi source.py
        $project> git add source.py
        $project> git commit  

*   Submit the topic branch changes to gerrit

&nbsp;

        $project>./git-review -t engine-register
        remote: Resolving deltas:   0% (0/3)
        remote: (W) fba45fe: no files changed, message updated
        To ssh://user@gerrit.ovirt.org:29418/project.git
       * [new branch]      HEAD -> refs/for/master/engine-register 

*   Now go to the gerrit url for your change and note that the topic field is changed to your topic branch name.
