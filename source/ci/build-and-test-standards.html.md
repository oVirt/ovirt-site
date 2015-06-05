---
title: Build and test standards
category: ci
authors: dcaroest, mkovgan, nsoffer
wiki_category: CI
wiki_title: CI/Build and test standards
wiki_revision_count: 10
wiki_last_updated: 2015-06-05
---

# Build and test standards

This is the recommended setup to be able to build and test a project using the ovirt infrastructure.

### The automation directory

Each project in the root directory must have a subdirectory named `automation` containing the scripts and configuration files described here. All the scripts will be run from the root directory, using a relative path, like: `automation/build-artifacts.sh` No parameters will be passed, and no assumptions on any preexisting environment variables should be made except for the default minimal ones (USER, PWD, ...).

### Builds

To build a project, you have to create a shell script (will be run with bash) named `build-artifacts.sh` inside the automation directory.

It should generate any artifacts to be archives (isos, rpms, debs, tarballs, ...) and leave them at `exported-artifacts/` directory, at the same level as the `automation` directory, in the root. The build system will collect anything left there. It must make sure that the exported-artifacts is empty if needed, or created if non-existing.

      The build should not dirty the source directory with build artifacts. The build system should create a directory for each build out of the source directory, and pass this directory to the build scripts in an environment variable or parameter to the script.

To declare package dependencies when building the artifacts, you shall create a plain text file named `build-artifacts.req` at the same level as the script, with a newline separated list of packages to install. If the packages are distribution specific, you must put them on their own requirements file, that should have the name `build-artifacts.req.${releasever}` is one of:

*   fc19
*   fc20
*   fc21
*   el6
*   el7

This list will be updated with new values as new versions and distributions become available.

### Tests

There are two different tests/test sets that will be run on different events:

*   pushing the patch to gerrit will trigger `check-patch.sh`
*   merging the patch will trigger `check-merged.sh`

#### check-patch.sh

This script should:

*   Usually only run static code analysis tools and unit tests
*   no long-running tests
*   focus is on giving quick feedback to the developer while working on a patchset

#### check-merged.sh

This script is meant to be the merge gate when merging changes to the main branch, so it should:

*   run all the tests that you find required for any change to get merged, e.g. it could simply run all the tests in `check-patch.sh`
*   have also some functional/other tests that require more time/resources
*   It will be run less often than `check-patch.sh`

#### Dependencies

As with the `build-artifacts.sh` script, if you need any packages for the tests to run, you can create a generic file or releasever specific one with the packages needed listed.

#### Running parallel tests

In the future we might support having more than one of the above scripts, possibly in the form:

      check-patch.testN.sh

To allow running them in parallel, for starters we only support a unique script, if you want/&need any parallel execution you should handle it yourself for now.

### Extra note on dependencies

The tests will run on a minimal installation environment, so don't expect anything to be installed, if you are not sure if your dep is installed, declare it. Note that the distribution matrix to run the tests on is defined in the yaml at the [| jenkins repo](http://gerrit.ovirt.org/#/admin/projects/jenkins).

For example, if your build scripts needs git to get the version string, add it as a dependency, if it needs autotools, maven, pep8, tox or similar, declare it too.

<Category:CI> <Category:Infrastructure>
