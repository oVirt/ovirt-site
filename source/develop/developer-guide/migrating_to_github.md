---
title: Migrating a project from Gerrit to GitHub
authors:
  - sandrobonazzola
---

# Introduction
Until the end of November 2021, the oVirt project hosted its git repositories within a self-hosted Gerrit instance at `gerrit.ovirt.org`. These git repos were automatically mirrored to the GitHub oVirt organization and GitHub was used only as a backup platform.

Starting in December 2021, the oVirt project started decommissioning self-hosted infrastructure in favor of more widely used services. This guide is meant to help project maintainers with migrating from Gerrit to GitHub as main repository.

*Note:* For a quick setup, you can use the [template repository](https://github.com/oVirt/gerrit-to-gh) that includes a README notice, GitHub Actions as well as PR and Issue templates, and more.

# Decide how to handle open reviews

Please check the open reviews for your project at `https://gerrit.ovirt.org/q/project:<your_project>+status:open`. If you have no open reviews you can just continue. If you do have open reviews, you need to decide how to handle them:
- Get them merged before continuing
- Abandon and re-send them as PR to the GitHub project

Once you finish with this you can continue.

# Stopping the mirroring service from Gerrit to GitHub

The procedure for activating the mirroring is described within the [oVirt Infra documentation](https://ovirt-infra-docs.readthedocs.io/en/latest/General/Creating_Gerrit_Projects/index.html#enable-gerrit-to-gihub-mirroring).

In order to deactivate the mirroring, the procedure must be reverted. As a pre-requisite you need to have gerrit administrator rights. If you are missing these rights, either:

* Open a ticket on [the infra ticketing system](https://issues.redhat.com/projects/CPDEVOPS/summary)
* Or ask on the [devel@ovirt.org](https://lists.ovirt.org/archives/list/devel@ovirt.org/) mailing list
* Or ask for [joining the oVirt infrastructure team](/develop/infra/infrastructure.html)

If you have a user with admin permission on Gerrit:

```bash
ssh -p 22 <youruser>@gerrit.ovirt.org
sudo su - gerrit2
vi ~/review_site/etc/replication.config
```

Remove your project from the `[remote github]` section.

# Advising that the project moved to GitHub within Gerrit

At this stage the mirroring to GitHub is disabled.

Push a commit for your project removing the whole content of the default branch (usually `master` or `main`) and adding a `README.md` with something similar to:

```markdown
# <your_project> moved to GitHub!

This repo on Gerrit is not used anymore.
Please use https://github.com/ovirt/<your_project>

Thanks

```

An example is here: <https://gerrit.ovirt.org/c/ovirt-release/+/117674>

Once this commit is merged, check the GitHub repo ensuring the commit wasn't mirrored as verification of the above procedure success at `https://github.com/oVirt/<your_project>`.

You can archive the gerrit repo, moving to read only. In order to do so, go to `https://gerrit.ovirt.org/admin/repos/<your_project>`. Under the `Repository Options` section change the `State` option from `Active` to `Read Only`.

# Updating GitHub project settings

As a first step let's drop the backup notice in the `About` section at `https://github.com/oVirt/<your_project>`. Click on the gear icon next to `About` and replace the `Description` field with something meaningful.

Next go to `https://github.com/oVirt/<your_project>/settings`.

Within the `Options` section:
- Turn on the `Issues` feature
- Turn off `Allow merge commits`

Within the `Manage access` section:
- Ensure `oVirt/Admins` team has Administrator role for the project
- Add `oVirt/Developers` with Triage role
- Setup additional roles as needed, e.g. Maintain or Write for maintainers

Within the `Security & Analysis` section:
- Enable Dependabot features
- Consider enabling Code Scanning in the future

Within the `Branches` section:
- Add a rule on `Branch protection rules`
    - set the regex for matching the branches you want to protect (like `master`, `main`, `ovirt-4.4`, ...)
    - turn on `Require a pull request before merging` and `Require approvals`: this is similar to `+2` requirement in Gerrit
    - turn on `Require conversation resolution before merging` to ensure nothing will be merged with some open review
    - turn on `Require linear history` to make it simpler reading the git repo history by avoiding merge commits

Within the `Actions` section:
- Set `Require approval for all outside collaborators` and save


As last step, update the README.md to welcome contributors and drop the redirection to Gerrit. An example is here: <https://github.com/oVirt/ovirt-release/pull/5>

# Enabling GitHub Actions

As last step we need to turn on automation.

- Go to `https://github.com/oVirt/<your_project/actions/new`
- Click on `set up a workflow yourself`
- Write your `check-patch` CI flow, here is an example which builds rpms on both CentOS Stream 8 and CentOS Stream 9:

```yaml
name: Check patch

on:
  push:
    branches: [master]
  pull_request:
    branches: [master]

jobs:
  build-el8:

    runs-on: ubuntu-latest
    container:
      image: quay.io/centos/centos:stream8

    steps:
    - name: prepare env
      run: |
           mkdir -p ${PWD}/tmp.repos/BUILD
           yum install -y --setopt=tsflags=nodocs autoconf automake createrepo_c gettext-devel git systemd make git rpm-build
    - uses: actions/checkout@v2
      with:
        fetch-depth: 0

    - name: autoreconf
      run: autoreconf -ivf

    - name: configure
      run: ./configure

    - name: run distcheck
      run: make -j distcheck

    - name: Build RPM
      run: rpmbuild -D "_topdir ${PWD}/tmp.repos" -D "release_suffix .$(date -u +%Y%m%d%H%M%S).git$(git rev-parse --short HEAD)" -ta ovirt-release*.tar.gz

    - name: Collect artifacts
      run: |
          mkdir -p exported-artifacts
          find tmp.repos -iname \*rpm -exec mv "{}" exported-artifacts/ \;
          mv ./*tar.gz exported-artifacts/

    - name: Create DNF repository
      run: createrepo_c exported-artifacts/

    - name: test install
      run: |
          yum install -y exported-artifacts/ovirt-release-master-4*noarch.rpm
          yum module enable -y javapackages-tools:201801
          yum module enable -y maven:3.5
          yum module enable -y pki-deps:10.6
          yum module enable -y postgresql:12
          yum module enable -y mod_auth_openidc:2.3
          yum --downloadonly install -y exported-artifacts/*noarch.rpm
          yum --downloadonly install -y ovirt-engine ovirt-engine-setup-plugin-websocket-proxy
    - name: Upload artifacts
      uses: ovirt/upload-rpms-action@v2
      with:
        directory: test-artifacts


  build-el9:

    runs-on: ubuntu-latest
    container:
      image: quay.io/centos/centos:stream9

    steps:
    - name: prepare env
      run: |
           mkdir -p ${PWD}/tmp.repos/BUILD
           yum install -y --setopt=tsflags=nodocs autoconf automake createrepo_c gettext-devel git systemd make git rpm-build
    - uses: actions/checkout@v2
      with:
        fetch-depth: 0

    - name: autoreconf
      run: autoreconf -ivf

    - name: configure
      run: ./configure

    - name: run distcheck
      run: make -j distcheck

    - name: Build RPM
      run: rpmbuild -D "_topdir ${PWD}/tmp.repos" -D "release_suffix .$(date -u +%Y%m%d%H%M%S).git$(git rev-parse --short HEAD)" -ta ovirt-release*.tar.gz

    - name: Collect artifacts
      run: |
          mkdir -p exported-artifacts
          find tmp.repos -iname \*rpm -exec mv "{}" exported-artifacts/ \;
          mv ./*tar.gz exported-artifacts/

    - name: Create DNF repository
      run: createrepo_c exported-artifacts/

    - name: test install
      run: |
          yum install -y exported-artifacts/ovirt-release-master-4*noarch.rpm
          yum --downloadonly install -y exported-artifacts/*noarch.rpm

    - name: Upload artifacts
      uses: ovirt/upload-rpms-action@v2
      with:
        directory: test-artifacts
```

# Require "CI +1" for merging

Once your GitHub Action is working, you can require it to pass in order to be able to merge the patch, similarly to "CI +1" used in Gerrit. For enabling it go to `https://github.com/oVirt/<your_project>/settings`.

Within the `Branches` section:
- Edit the protection rule you setup for protected branches
  - Enable `Require status checks to pass before merging`
  - Enable `Require branches to be up to date before merging`
  - Within the search tool `Search for status checks in the last week for this repository` search for the jobs required to pass (e.g. `build-el9` and `build-el8` from above)

# Clean up redundant files and folders

If you were previously and are now no longer using [STDCI](https://ovirt-infra-docs.readthedocs.io/en/latest/CI/STDCI-Configuration/index.html), you should clean up your project repository to avoid outdated content. This means deleting the `stdci.yaml` file as well as the `automation` folder, assuming that your automation folder does not contain additional files that you would like to keep.

# Set up CODEOWNERS to automatically assign reviewers

`CODEOWNERS` is a file within each repository that should include only people with write permissions to the repository who will automatically get assigned as reviewers for any incoming pull requests. You can place this file either in the repository root or your `.github` repository. An example `CODEOWNERS` file that automatically assigns `username` and a team called `team-name` within the oVirt organization to all PRs could look like this:

```
* @username @ovirt/team-name
```

For more information on syntax and options, check out [GitHub's documentation on code owners](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-code-owners).

# Add PR and issue templates

You can create PR and issue templates to make sure contributions follow a certain pattern. Like the code owners, PR and issue templates can be placed either in the repository root or in the `.github` folder. You can create different templates for different types of PRs and issues. GitHub's documentation offers more information on [issue templates](https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/configuring-issue-templates-for-your-repository) and [PR templates](https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/creating-a-pull-request-template-for-your-repository). As a quick solution for all PRs, we could create a `pull_request_template.md` with the following contents:

```
Fixes issue # (delete if not relevant)

## Changes introduced with this PR

*

*

*

## Are you the owner of the code you are sending in, or do you have permission of the owner?

[y/n]
```

Issue templates are saved in an additional folder within the `.github` repository. There is a corresponding `.md` file for each type of issue you would like contributors to be able to create. A recommended directory structure for the `.github` folder including issue templates looks like this:

```
├── .github/

│   ├── pull-request.md

│   ├── ISSUE_TEMPLATE/
│   │   ├── bug_report.md
│   │   ├── config.yml
│   │   ├── feature_request.md

│   ├── workflows/
│   │   ├── <youraction1>.yml
│   │   ├── <youraction2>.yml
```

If you choose to add the `config.yml` within the `ISSUE_TEMPLATE` folder, you can fill it with additional links that show up when someone is creating a new issue, for example:

```
blank_issues_enabled: true
contact_links:
  - name: oVirt Mailing Lists
    url: https://lists.ovirt.org/archives/
    about: Join us on the mailing list for more conversations and community support
  - name: oVirt User Documentation
    url: https://ovirt.org/documentation/
    about: Documentation for oVirt users
  - name: oVirt Developer Documentation
    url: https://ovirt.org/develop/devdocs.html
    about: Documentation for oVirt developers

```

# Use labels

For each repository, you can assign [labels](https://github.com/actions/labeler) to easily label things such as good first issues, bugs, documentation, tested labels, and more. Your repository labels can be found at: `https://github.com/oVirt/<your_project>/labels`

There is also a GitHub Action you can use in your repository to [automatically label PRs](https://github.com/actions/labeler).


# Developing code on GitHub

You can find the best practices for developing an oVirt project on GitHub in [Working with oVirt on GitHub](https://www.ovirt.org/develop/dev-process/working-with-github.html).
