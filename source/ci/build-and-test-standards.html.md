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

Each project in the root directory must have a subdirectory named `automation` containing the scripts and configuration files described here.

All the scripts will be run from the root directory, using a relative path, like:

      automation/build-artifacts.sh

No parameters will be passed, and no assumptions on any preexisting environment variables should be made except for the default minimal ones (USER, PWD, ...).

### Builds

To build a project, you have to create a shell script (will be run with bash) named *build-artifacts* inside the automation directory.

This should generate any artifacts to be archives (isos, rpms, debs, tarballs, ...) and leave them at exported-artifacts/ directory, at the same level as the automation directory, in the root. The build system will collect anything left there. It must make sure that the exported-artifacts is empty if needed, or created if non-existing.

To declare package dependencies when building the artifacts, you can create a plain text file named *build-artifacts.req* at the same level as the script, with a newline separated list of packages to install. If the packages are distribution specific, you must put them on their own requirements file, that should have the name *build-artifacts.req.${releasever}* is one of:

*   fc19
*   fc20
*   fc21
*   el6
*   el7

That list will be updated with new values when new versions and distros bcome available.

### Tests

There are two different tests/test sets that will be run on different events, the first is *check-patch.sh*, that will run each time a patch is sent to gerrit, and the other one is *check-merged.sh*, that will be executed when a change is merged.

#### check_patch.sh

This script should not run any long-running tests, it should be focused on giving quick feedback to the developers while developing a patchset. Usually you'd run static code checks and unit tests.

#### check_merged.sh

This script is ment to be run as a gate when merging changes to the main branch, it should run all the tests that you find required for any change to get merged, that might include all the tests you run for *check_patch.sh*, but also some functional tests or other tests that require mote time/resources. It will not be run as often as the *check_patch.sh*

#### Dependencies

As with the *build-artifacts.sh* script, if you need any packages for the tests to run, you can create a genertic file or releasever specific one with the packages needed listed.

#### Running parallel tests

In the future we might support having more than one of the above scripts, possibly in the form:

      check_patch.testN.sh

To allow running them in parallel, for starters we only support a unique script, if you want/&need any parallelized execution you should handle it yourself for now.

### Extra note on dependencies

The tests will run on a minimal installation environment, so don't expect anything to be installed, if you are not sure if your dep is installed, declare it. Note that the distribution matrix to run the tests on is defined in the yaml at the [| jenkins repo](http://gerrit.ovirt.org/#/admin/projects/jenkins).

For example, if your build scripts needs git to get the version string, add it as a dependency, if it needs autotools, maven, pep8, tox or similar, declare it too.

<Category:CI> <Category:Infrastructure>
