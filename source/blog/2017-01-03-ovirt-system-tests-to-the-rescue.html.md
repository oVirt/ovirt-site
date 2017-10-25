---
title: oVirt System Tests to the Rescue!&mdash;How to Run End-to-End oVirt Tests on Your Patch
author: eedri
tags: infrastructure, developers, ci
date: 2017-01-03 10:00:00 CET
comments: true
published: true
---

Today, when an oVirt developer pushes a patch to review on oVirt Gerrit, various validations are triggered in CI via the ['check-patch'](http://ovirt-infra-docs.readthedocs.io/en/latest/CI/Build_and_test_standards.html) job, as defined by the project maintainers. Usually these jobs includes 'unit-tests', 'db tests', static analysis checks, and even an occasional 'functional test'. While it might seem that it covers alot and gives a good indication that the patch is good to be merged, unfortunately it is not always the case.

The reason it's not enough lies in oVirt's complexity and the fact it's a Virtualization project, which means the only real way to know if your patch didn't break things is to install oVirt and try running a few basic commands, like 'adding host', 'adding vm', 'creating snapshots', and other tasks you can only do if you have a full oVirt system up and running. Here is where OST comes in!

READMORE

## oVirt System Tests (OST)

[oVirt system tests](http://ovirt-system-tests.readthedocs.io) is a testing framework written in Python using 'python-nose' and oVirt Python SDK, and runs on auto-generated VMs created by [Lago](http://lago.readthedocs.io). It is used by oVirt CI to run post-merge end-to-end testing on a fully deployed oVirt environment. OST is capable of detecting multiple
regressions on merged commits from oVirt projects.

## The Current Status (And Why it is Never Enough)

You may ask yourself, if we have OST running after (almost) every merged commit, where is the problem? You might have guessed the answer which is already in the question--it's only 'AFTER', which means it's detected too late in the development cycle. The result of such breakage in CI means that any other developer using the same branch will now be blocked from working/verifying his patch because existing HEAD is broken, and usually it takes some time to either revert the offending patch or send a fix (and that's after the relevant people were found and started debugging the issue). On some occasions in the past, it even took a few days to see a fix merged. During that time, developers and testers were blocked, not an ideal status.

Luckily, we now have a super easy way to avoid this!

## Running OST on Open Patches (Pre Merge)

I know you can't wait to hear about how to run OST on your patch, so I'll just jump into the TL;DR version, here is how you do it:

* *Build RPMs from your open patch(es)*

    Building RPMs today from any open oVirt patch is simple as just
    asking for it.. :)<br>
    The new 'build-on-demand' option from oVirt Standard CI allows
    you to just type **ci please build** in a comment on your patch
    and a new build will be triggered on the project 'build-on-demand' jobs.<br>
    Once the 'build-on-demand' job finished building, write down the job URL.<br>
    For example: [vdsm-master-build-on-demand](http://jenkins.ovirt.org/job/vdsm_master_build-artifacts-on-demand-el7-x86_64//).
    (btw, you can do this for as many oVirt projects you want and have a list of URLs).


* *Run the manual OST job with your custom RPMs*

    Now that you have your custom RPMs ready, you're JUST a few clicks away from running OST
    on them.<br>
    * Login to [Jenkins](http://jenkins.ovirt.org) (make sure you have 'dev role' permissions, if not open a ticket to infra)<br>
    * Go to the [OST Manual job](http://jenkins.ovirt.org/job/ovirt-system-tests_manual/).<br>
    * Click on 'build with parameters' menu ( on the left side )
    * Choose the oVirt version: This is the version that we actually tested.<br>
      (in the upgrade suites, this is the version that we will be upgrading to)<br>
    * Choose the suite type you want to run:<br>
        <b>basic:</b> For running engine-setup and basic tests (bootstrap, sanity and etc).<br>
        <b>upgrade:</b> Initialize the engine with a base version, test if an upgrade to the target version is possible.<br>
        There are 3 upgrade options:<br>
        <b>upgrade-from-rc:</b> This option will be displayed when a release candidate is available. The current release candidate is your base version (the version installed before the upgrade).<br>
        <b>upgrade-from-release:</b> Choose this option if you want to test your patch on the released version. In this scenario, the current official release will be set as the base installed version from which we will upgrade. For example, if you choose to upgrade from oVirt-4.1, the suite will install the official release of <b>4.1</b> and upgrade to the latest repo with your patch on top of it.<br>
        <b>upgrade-from-prevrelease:</b> Choose this option if you want to test your patch on a previously released version. In this scenario, the previous official release will be set as the base installed version from which we will upgrade. For example, if you choose upgrade from oVirt-4.0, the suite will install the official release of <b>4.0</b> and upgrade to the latest repo with your patch on top of it.<br>
    * Add all the URLs for the custom RPMS to the CUSTOM_REPOS text box ( one per line ). For example, [vdsm-build](http://jenkins.ovirt.org/job/vdsm_master_build-artifacts-on-demand-el7-x86_64/lastSuccessfulBuild/)<br>
    * Choose a fallback_repo:<br>
        This is a base repo to be used under your tested patch, and containing all the other files needed for the complete oVirt platform. Choose between:<br>
        <u>latest:</u> includes all the RPMs that passed CI.<br>
        <u>latest_release:</u> includes all the rpm's in the latest release.<br>
    * Choose the lago_version (unless you are testing lago itself, you'll probably want the stable release)<br>
    * Click 'Build'<br>
    * Go get some coffee; Don't worry the job will send you an email once it is done ( on any status )

This info can also be found on the [official OST documentation page](http://ovirt-system-tests.readthedocs.io/en/latest/docs/CI/developers_info.html).

For more info or questions, please send email to infra@ovirt.org or lago-devel@ovirt.org if it is a lago-related question.

Happy testing!
