---
title: Adding a project to ovirt-master-snapshot COPR repository
authors:
  - sandrobonazzola
---

# About oVirt/ovirt-master-snapshot

The [oVirt/ovirt-master-snapshot](https://copr.fedorainfracloud.org/coprs/ovirt/ovirt-master-snapshot/) COPR project
is meant to provide the latest build from merged patches for all the subprojects within the oVirt project.

The builds included in this project are pre-release builds for testing purposes, not suited for production.

For using these pre-production builds, please refer to [Install nightly oVirt master snapshot](/develop/dev-process/install-nightly-snapshot.html).

# Adding a new sub-project to oVirt/ovirt-master-snapshot

This procedure assumes the source code is hosted on GitHub or correctly mirrored from Gerrit to GitHub.

This procedure requires:
- **administrator** access level to [oVirt/ovirt-master-snapshot](https://copr.fedorainfracloud.org/coprs/ovirt/ovirt-master-snapshot/)
- **administrator** access level to the GitHub sub-project

If you are not an administrator you can open an issue within the subproject and request `@oVirt/admins` as a reviewer.

## Getting administrator rights

For requesting administrator access to [oVirt/ovirt-master-snapshot](https://copr.fedorainfracloud.org/coprs/ovirt/ovirt-master-snapshot/):
- Login to COPR (register if you do not have an account yet)
- Go to https://copr.fedorainfracloud.org/coprs/ovirt/ovirt-master-snapshot/permissions/
- Request administrator rights
- Existing administrators will review and either approve or deny the request

If you are not already an administrator of your subproject within the oVirt organization, you can open an issue within the subproject and request review from `@oVirt/admins`.
Existing administrators will review and either approve or deny the request.

## Procedure for adding the project

The first step is [adding the package](https://copr.fedorainfracloud.org/coprs/ovirt/ovirt-master-snapshot/package/add) to [oVirt/ovirt-master-snapshot](https://copr.fedorainfracloud.org/coprs/ovirt/ovirt-master-snapshot/).

Within `Provide the source` section set:
- `Package name`: use the name of the source RPM, e.g. `ovirt-engine`.
- `Type`: use `git`.
- `Clone url`: set the anonyumous git clone url as provided by GitHub, e.g. `https://github.com/oVirt/ovirt-engine.git`.
- `Committish`: set the branch name, e.g. `master`.
- Leave the rest blank.

Within `How to build SRPM from the source` section, select `make srpm`.

Within `Generic package setup` section set:
- `Chroot denylist`: set it if you want to exclude some targets, e.g. `*ppc64_le*` if you want to exclude ppc64_le architecture.
- `Max number of builds`: set it to a reasonable value, e.g. `5`
- `Auto-rebuild`: enable the checkbox.

The second step is preparing your subproject for building in COPR.

You need to prepare a Makefile in order to produce a source RPM. You can learn more about how to do this on
[COPR documentation for make srpm](https://docs.pagure.org/copr.copr/user_documentation.html#make-srpm).

Once your project is ready, the last step is activating the COPR web hook. The procedure is well documented in [COPR integration panel](https://copr.fedorainfracloud.org/coprs/ovirt/ovirt-master-snapshot/integrations/).

Once everything is set, you can add a badge to your sub-project README file. Get the code to do that from
`https://copr.fedorainfracloud.org/coprs/ovirt/ovirt-master-snapshot/package/<change this with your new package name>/`.

If you need help, feel free to reach out to the [devel@ovirt.org](https://lists.ovirt.org/archives/list/devel@ovirt.org/) mailing list.
