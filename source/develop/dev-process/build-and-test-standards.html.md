---
title: Build and test standards
category: ci
authors: dcaroest, mkovgan, nsoffer
---

**NOTE**: for the latest version of this doc, see <http://ovirt-infra-docs.readthedocs.org/en/latest/>

# Build and test standards

This is the recommended setup to be able to build and test a project using the ovirt infrastructure.

## The automation directory

Each project must have in the root directory, a subdirectory names automation, that must contain any scripts and configuration files described here.

All the scripts will be run from the root directory, using a relative path, like:

    automation/build-artifacts.sh

No parameters will be passed, and no assumptions on any preexisting environment variables should be made except for the default minimal ones (USER, PWD, ...).

## Scripts

### build-artifacts.sh

To build a project, you have to create a shell script (will be run with bash) named *build-artifacts* inside the automation directory.

This should generate any artifacts to be archives (isos, rpms, debs, tarballs, ...) and **leave them at exported-artifacts/** directory, at the same level as the automation directory, in the root. The build system will collect anything left there. It must make sure that the exported-artifacts is empty if needed, or created if non-existing.

### check-patch.sh

This script should not run any long-running tests, it should be focused on giving quick feedback to the developers while developing a patchset. Usually you would run static code checks and unit tests.

### check-merged.sh

This script is ment to be run as a gate when merging changes to the main branch, it should run all the tests that you find required for any change to get merged, that might include all the tests you run for *check-patch.sh*, but also some functional tests or other tests that require mote time/resources. It will not be run as often as the *check-patch.sh*

### Running parallel tests

In the future we might support having more than one of the above scripts, possibly in the form:

    check-patch.testN.sh

To allow running them in parallel, for starters we only support a unique script, if you want or need any parallelized execution you should handle it yourself for now.

## Declaring dependencies

#### Packages

To declare package dependencies when building the artifacts, you can create a plain text file named **build-artifacts.req** or **build-artifacts.packages** at the same level as the script, *bulid-artifacts.packages* being preferred, with a newline separated list of packages to install. If the packages are distribution specific, you must put them on their own requirements file, that should have the name **build-artifacts.packages.${releasever}** is one of:

    * fc20
    * fc21
    * fc22
    * el6
    * el7

That list will be updated with new values when new versions and distros become available. This technique can be applied to any requirements file (req/packages, repos or mounts)

#### Repositories

You can also specify custom repos to use in the mock chroot, to do so, you can specify them one per line in a file named **build-artifacts.repos**, with the format:

    [name,]url

If no name is passed, one will be generated for the repo. Those repos will be available at any time inside the chroot. If you use the keyword $distro in the url it will be replaced with the current chroot distro at runtime (el6, el7, fc21, ...).

#### Mounted dirs

Sometimes you will need some extra directories inside the chroot, to do so you can specify them in a file named **build-artifacts.mounts**, one per line with the format:

    src_dir[:dst_dir]

If no dst_dir is specified, the src_dir will be mounted inside the chroot with the same path it has outside.

## Extra note on dependencies

The tests will run on a minimal installation environment, so do not expect anything to be installed, if you are not sure if your dep is installed, declare it. Note that the distribution matrix to run the tests on is defined in the yaml files at the [jenkins repo](https://gerrit.ovirt.org/#/admin/projects/jenkins).

For example, if your build scripts needs git to get the version string, add it as a dependency, if it needs autotools, maven, pep8, tox or similar, declare it too.

## Testing the scripts locally

To test the scripts locally, you can use the *mock_runner.sh* script that is stored in the [jenkis repo](https://gerrit.ovirt.org/#/admin/projects/jenkins), under mock_config directory.

Take into account that you must have mock installed and your user should be able to run it, if you don't, check the [mock help page](https://fedoraproject.org/wiki/Projects/Mock)

The *mock_runner.sh* script will use the default mock configs, located at */etc/mock* dir on your machine, but we recommend using the same ones that we use on CI, that are located in the same dir than the script, under *mock_configs* dir in the [jenkins repo](https://gerrit.ovirt.org/#/admin/projects/jenkins).

Let's see a full session with *mock_runner.sh*, that will execute the scripts (check-patch, check-merged and build-artifacts) on each chroot. That will take some time the first time you run it, as it will generate the chroot base images for each distro.

    git clone git://gerrit.ovirt.org/jenkins
    cd myproject
    ls automation
    ...
    shows the check-patch.sh, check-merged.sh and build-artifacts.sh
    scripts and .repo, .packages and .mounts files if any
    ...
    ../jenkins/mock_configs/mock_runner.sh \
        --mock-confs-dir ../jenkins/mock_configs

If you only wanted to run one of the scripts, say the check-patch, you can pass the *--patch-only* option.

To debug a run, you can start a shell right where it would run the script, to do so you have to run it like this:

    ../jenkins/mock_configs/mock_runner.sh \
        --mock-confs-dir ../jenkins/mock_configs \
        --patch-only \
        --shell el6

Note that you have to specify a chroot to the *--shell* option, or it will not know which one to start the shell on. Then you can explore the contents of the chroot. **Remember that the project dir is mounted on */tmp/run* directory**

### Specifying which chroots to run on

The complete specification of the chroot is in the form:

    req_file_suffix:mock_root_name

For example:

    mock_runner.sh \
        --mock-confs-dir ../jenkins/mock_configs \
        --build-only \
        el7:epel-7-x86_64

This will run the *build-artifacts.sh* script inside the epel-7-x86_64 mock chroot and will use any *build-artifacts.\*.el7* files to customize it.

But a nice feature that *mock_runner.sh* has is that it will match the name passed with the default specs. With that feature the above command can be simplified as:

    mock_runner.sh \
        --mock-confs-dir ../jenkins/mock_configs \
        --build-only \
        el7

A lot simpler! You can specify more than one chroot at a time, for example to run on el6 and el7, just:

    mock_runner.sh \
        --mock-confs-dir ../jenkins/mock_configs \
        --build-only \
        el6 \
        el7

If none passed, will run on all of the defaults.

