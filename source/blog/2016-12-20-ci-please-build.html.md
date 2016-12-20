---
title: CI Please Build&mdash;How to build your oVirt project on-demand
author: eedri
tags: infrastructure, developers, ci
date: 2016-12-20 10:00:00 CET
---

All projects in oVirt CI are built today post merge, using the 'build-artifacs' stage from [oVirt's CI standards](http://ovirt-infra-docs.readthedocs.io/en/latest/CI/Build_and_test_standards.html).

This ensures that all oVirt projects are built and deployed to oVirt repositories and can be consumed by CI jobs, developers or oVirt users.
However, on some occasions a developer might need to build his project from an open patch in order to test the code before it is merged to the branch,
So in any case of errors, he can go back to the patch and fix them before merging.
Another exmaple is a UI developer, that works on a new UI fix/feature and wants to see the changes on each patch change.

## The Current Build Option

Until now, to build rpms from a patch, a developer needed to use a custom [Jenkins job](http://jenkins.ovirt.org/job/ovirt-engine_master_build-artifacts-el7-x86_64_build_from_patch/), which was only available to ovirt-engine and only for master branch. 
Another option was to try and build it locally, but then you need to make sure you have all the right packages installed ( something that is given automatically in CI ).

## The New Build Option

To ease and simplify the build from patch option, the oVirt infra team added a new feature to the [oVirt's CI standards framework](http://ovirt-infra-docs.readthedocs.io/en/latest/CI/Build_and_test_standards.html) called 'build on demand'.

It allows any oVirt developer to trigger a build from a patch just by adding the comment 'ci please build' on the patch in Gerrit. 
It will then trigger a 'build-artifacts-on-demand' job on jenkins which will build rpms from the patch, but not publish them to any repo.

## How Do I Enable It For My oVirt Project ?

Adding this is a simple one liner to your project standard yaml file, just add the following line to your 'build-artifacts' section, under 'jobs':

      - '{project}_{version}_{stage}-on-demand-{distro}-{arch}'


## What Else Can I Do With It ? (Hint: OST)

Now that you know you can build new rpms whenever you want using a simple comment, you might ask yourself what can I do with those rpms?
After the job you triggered finished running in Jenkins,you can use the Jenkins build URL, [Example](http://jenkins.ovirt.org/job/vdsm_master_build-artifacts-on-demand-el7-x86_64/1/artifact/exported-artifacts/) as a parameter to running oVirt system tests on your laptop!
From ost root dir, run the following to run basic master suite for e.g:

    ./run_suite.sh -s http://jenkins.ovirt.org/job/vdsm_master_build-artifacts-on-demand-el7-x86_64/1/artifact/exported-artifacts/ basic_suite_master

For more info and help on using this new feature, feel free to come and ask us on infra@ovirt.org.

Happy Building!
