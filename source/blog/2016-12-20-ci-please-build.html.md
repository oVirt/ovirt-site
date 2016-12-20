---
title: CI Please Build&mdash;How to build your oVirt project on-demand
author: eedri
tags: infrastructure, developers, ci
date: 2016-12-20 10:00:00 CET
---

All projects in oVirt CI are built today post merge, using the 'build-artifacs' stage from [oVirt's CI standards](http://ovirt-infra-docs.readthedocs.io/en/latest/CI/Build_and_test_standards.html).
This ensures that all oVirt projects are built and deployed to oVirt repositories and can be consumed by CI jobs, developers or oVirt users.

However, on some occasions a developer might need to build his project from an open patch.
Developers need this to be able to examine the effects of their changes on a full oVirt installation before merging those changes. On some cases developers may even want to hand over packages based on un-merged patches to the QE team to verify that a given change will fix some complex issue.

## The Current Build Option

Until now, to build rpms from a patch, a developer needed to use a custom [Jenkins job](http://jenkins.ovirt.org/job/ovirt-engine_master_build-artifacts-el7-x86_64_build_from_patch/), which was only available to ovirt-engine and only for master branch. 
Another option is to try and build it locally using standard CI 'mock runner.sh' script which will use the same configuration
as in CI. For full documentation on how to use 'mock-runner', checkout the [Standard CI](http://infra-docs.readthedocs.io/en/latest/CI/Build_and_test_standards.html#testing-the-scripts-locally) page. 

## The New Build Option

To ease and simplify the build from patch option, the oVirt infra team added a new feature to the [oVirt's CI standards framework](http://ovirt-infra-docs.readthedocs.io/en/latest/CI/Build_and_test_standards.html) called 'build on demand'.

It allows any oVirt developer to trigger a build from a patch just by adding the comment 'ci please build' on the patch in Gerrit. 
It will then trigger a 'build-artifacts-on-demand' job on jenkins which will build rpms from the patch, but not publish them to any repo.

## How Do I Enable It For My oVirt Project ?

Adding this is a simple one liner to your project standard yaml file, just add the following line to your 'build-artifacts' section, under 'jobs':

      - '{project}_{version}_{stage}-on-demand-{distro}-{arch}'

For a full example on how to add it in Gerrit, Checkout an example [Patch](https://gerrit.ovirt.org/#/c/68759/) which adds 
on-demand builds to 4 different projects.


## What Else Can I Do With It ? (Hint: OST)

One more thing you can do, is to run the oVirt system tests suit, here is how you do it:

After the job you triggered finished running in Jenkins, use the Jenkins build URL you got ([Example](http://jenkins.ovirt.org/job/vdsm_master_build-artifacts-on-demand-el7-x86_64/1/artifact/exported-artifacts/))
as a parameter to to run OST on your laptop.
From the OST root dir, run the following to run basic master suite for e.g:

    ./run_suite.sh -s http://jenkins.ovirt.org/job/vdsm_master_build-artifacts-on-demand-el7-x86_64/1/artifact/exported-artifacts/ basic_suite_master

For more info and help on using this new feature, feel free to come and ask us on infra@ovirt.org.

Happy Building!
