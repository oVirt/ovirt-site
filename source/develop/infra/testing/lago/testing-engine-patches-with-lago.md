---
title: Testing ovirt-engine patches with Lago
authors: rafaelmartins
---

# Testing ovirt-engine patches with Lago

## Introduction

[Lago](http://lago.readthedocs.io/) is an ad-hoc virtual testing environment framework, that can be used to test ovirt-engine patches using the [ovirt-system-tests](http://ovirt-system-tests.readthedocs.io/en/latest/) test suites. Lago can handle the setup of ovirt-engine as well as virtual machine hosts and storage.

This guide will describe how to adapt ovirt-system-tests test suites, that are mainly designed for CI testing, to manually test ovirt-engine patches.

This guide assumes that you have lago and all the ovirt-system-tests requirements installed on your machine, [according to the documentation](https://ovirt-system-tests.readthedocs.io/en/latest/general/installation/index.html), and that you got yourself previously familiarized with ovirt-system-tests.

## Creating the test suite

ovirt-system-tests is composed by several test suites designed for CI testing. To test our patches, we will copy one of these test-suites and change it to suit our needs.

The first thing to do is select which test suite can be used as base for our manual test. This guide will be testing a patch for ovirt-engine's master branch, then it will be based on `basic_suite_master`.

Inside the ovirt-system-tests repository, copy the test suite directory:

    $ cp -r basic_suite_master manual_suite_master

Now we need to edit the Lago initialization file. This file is usually a symlink to a common initialization file. We will copy the actual file, so we can change it.

    $ cd manual_suite_master
    $ cp --remove-destination $(realpath LagoInitFile.in) LagoInitFile.in

Edit the `LagoInitFile.in` file to suit your needs. Easier way to do it is keep the predefined machines and just edit their parameters, if they are reasonable for your tests. If you need more machines to reproduce a real environment, or less machines to save resources, you'll need to edit the test scenarios later.

## Editing test scenarios

ovirt-system-tests' suites come with test scenarios, that are ran by Lago. As our base test suite was designed to test ovirt-engine setup, these steps are part of test scenarios, not of deployment scripts. We will still need to run these tests to get engine up and running.

We need to remove the tests that are not doing engine setup. Please note that, depending on the patch you are testing, you may want to keep those tests/update them to test the new behaviour introduced by your patch):

    $ cd test-scenarios
    $ rm 004_basic_sanity.py 005_aaa-ldap.py

Also, if you added or removed machines in the Lago initialization file, you'll need to edit `002_bootstrap.py` to reflect the new environment, implementing the code needed to add the new machines to the engine. You may also want to check the engine-setup answer file used by `001_initialize_engine.py` and modify it if you need some different answers.

## Preparing a build with your patch

To be able to use your modifications in lago, you must build a modified RPM. Lago is built on [repoman](https://repoman.readthedocs.io/en/latest/), so it can fetch RPMs from several places, including [oVirt Jenkins instance](https://jenkins.ovirt.org/).

The easier way to build an RPM is using jenkins' `build-artifacts` jobs, but they take around 1 hour to run, and the artifacts will be removed after some time. You must also consider that these jobs are used by the scheduled jobs that update the `ovirt-master-snapshot` repository, then your job may need to wait on the build queue.

For this example we will use the following job: [https://jenkins.ovirt.org/job/ovirt-engine_4.3_build-artifacts-el7-x86_64/](https://jenkins.ovirt.org/job/ovirt-engine_4.3_build-artifacts-el7-x86_64/).

To build a Gerrit patch manually on it, you must authenticate and click on the "Build with Parameters" link. It will ask for two paramenters:

- GERRIT\_REFSPEC: Go to your Gerrit patch and click on Download. The URLs have the git refspec, that looks similar to `refs/changes/54/64454/1`. This is the value you need.
- GERRIT\_BRANCH: No need to change.

When it is done, artifacts will be attached to the build page. You will need the build page URL, that looks similar to `https://jenkins.ovirt.org/job/ovirt-engine_4.3_build-artifacts-el7-x86_64/424/`.

If you want to build locally, just create the RPM as usual, and use its path instead of the Jenkins URL in the next steps.

## Running the test suite

To run the test suite with the custom patch, run:

    $ cd ../../
    $ ./run_suite.sh -s $CUSTOM_BUILD_URL manual_suite_master

Where `$CUSTOM_BUILD_URL` is your Jenkins URL or the path to your custom RPM

If everything was done correctly, Lago will deploy your environment with your custom package, will run the 2 first test scenarios to do the basic setup, and will keep the environment running, so you can do your manual tests. You will want to check Lago documentation to see how to tunnel the engine service to your local machine, so you can use it in your browser.

## Cleaning up

When you are done, you can kill the environment with the following command:

    $ ./run_suite.sh -c manual_suite_master
