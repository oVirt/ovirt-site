---
title: Working with oVirt on GitHub
category: documentation
toc: true
authors:
  - mperina
---

# Working with oVirt on GitHub

[GitHub](https://github.com) is a web-based code review system that uses the [Git](https://git-scm.com/) version control system. All oVirt projects are hosted on GitHub under [oVirt organization](https://github.com/ovirt).

## Getting started with GitHub

If you haven't worked with Git previously, it's highly recommended to read [About Git](https://docs.github.com/en/get-started/using-git/about-git) and [Pro Git](https://git-scm.com/book/en/v2).

If you haven't worked with GitHub previously, you should start with [setting up your GitHub account](https://docs.github.com/en/get-started/onboarding/getting-started-with-your-github-account). The most important parts are:

* Fill-in your firstname and lastname (yes, oVirt community wants to know who they are working with)
* [Enabling two-factor authentication](https://docs.github.com/en/authentication/securing-your-account-with-two-factor-authentication-2fa/about-two-factor-authentication)
* [Setting up SSH keys](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account)

It's also suggested to install and configure [GitHub CLI](https://docs.github.com/en/github-cli/github-cli/about-github-cli) and reading [GitHub CLI manual](https://cli.github.com/manual/).


## Basic Procedures

### Cloning the oVirt-engine Repository

```sh
$ gh repo clone https://github.com/ovirt/ovirt-engine
```

### Creating your first patch

[GitHub flow](https://docs.github.com/en/get-started/quickstart/github-flow) is based on branches so before doing a patch you need to create a branch for it.

```sh
$ git checkout -b my-first-change
Switched to a new branch 'my-first-change'
```

Within this branch you can create your changes and add to changes into the standard git patch.

```sh
$ echo "My first document" > my-doc.txt
$ git add my-doc.txt
$ git commit -m "My first patch"
[my-first-change e3344c318ae] My first patch
 1 file changed, 1 insertion(+)
 create mode 100644 my-doc.txt
```

### Creating a PR from a branch

To post created patches for a review you need to create a PR from a branch, where your patches are created

```sh
$ gh pr create
? Where should we push the 'my-first-change' branch?  [Use arrows to move, type to filter]
  oVirt/ovirt-engine
> Create a fork of oVirt/ovirt-engine
  Skip pushing the branch
  Cancel
```

A PR should be created on your fork of original project. If you alread forked relevant project, then just select it so PR is created there.

```
? Where should we push the 'my-first-change' branch? Create a fork of oVirt/ovirt-engine

Creating pull request for mwperina:my-first-change into master in oVirt/ovirt-engine

? Title (My first patch) My first Patch
? Body [(e) to launch vim, enter to skip]
```

`Title` should describe the whole change, which can be spread over multiple commits. Details should be mentioned in `Body`.

Last steps is to select `Submit` to create a PR:

```
? What's next?  Submit
remote:
remote:
To github.com:mwperina/ovirt-engine.git
 * [new branch]              HEAD -> my-first-change
Branch 'my-first-change' set up to track remote branch 'my-first-change' from 'fork'.
https://github.com/oVirt/ovirt-engine/pull/32

```

You can access your first PR using [https://github.com/oVirt/ovirt-engine/pull/32](https://github.com/oVirt/ovirt-engine/pull/32).

### Updating a PR from your local patch changes

After you have made changes to patches in local branch associated with existing PR, you need to publish those changes in the PR

```sh
$ git push
```

If you have made changes to already posted commits, then you need force update using `-f` option.

### Rebasing existing PR

```sh
$ git pull --rebase origin master
$ git push -f
```

### Synchronizing local branch from GitHub repo

```sh
$ git checkout master
$ gh repo sync
```

## Further reading

Further details how to work with GitHub can be found in the [GitHub Docs](https://docs.github.com/en) or [GitHub CLI Manual](https://cli.github.com/manual/).


# Administration of an oVirt project on GitHub

Best practices for administration of an oVirt project on GitHub are described at [Migrating to GitHub](https://www.ovirt.org/develop/developer-guide/migrating_to_github.html).