---
title: oVirt System Tests to the Rescue! -- How to Run End-to-End oVirt Tests on Your Patch
author: eedri
tags: infrastructure, developers, ci
date: 2017-01-01 10:00:00 CET
---

Today, when an oVirt developer pushes a patch to review on oVirt Gerrit, various validations are triggered in CI via the ['check-patch'](http://ovirt-infra-docs.readthedocs.io/en/latest/CI/Build_and_test_standards.html) job, as defined by the project maintainers. Usually these jobs includes 'unit-tests', 'db tests', static analysis checks, and even an occasional 'functional test'. While it might seem that it covers alot and gives a good indication that the patch is good to be merged, unfortunately it is not always the case.

The reason it's not enough lies in oVirt's complexity and the fact it's a Virtualization project, which means the only real way to know if your patch didn't break things is to install oVirt and try running a few basic commands, like 'adding host', 'adding vm', 'creating snapshots', and other tasks you can only do if you have a full oVirt system up and running. Here is where OST comes in!
 
## oVirt System Tests

[oVirt system tests](http://ovirt-system-tests.readthedocs.io) is a testing framework written in Python, using 'python-nose' and oVirt Python SDK and runs on auto-generated VMs created by [Lago](http://lago.readthedocs.io). It is used by the oVirt CI to run post merge end-to-end testing that runs on a fully deployed oVirt environment and has been proven to detect multiple
regressions so far on merged commits from oVirt projects.

## The Current Status (And Why it is Never Enough)

So you may ask yourself: if we have OST running after (almost) every merged commit, where is the problem? You might have guessed the answer which is already in the question--it's only 'AFTER', which means it's detected too late in the development cycle. The result of such breakage in CI means that any other developer using the same branch will now be blocked from working/verifying his patch because existing HEAD is broken, and usually it takes some time to either revert the offending patch or send a fix (and that's after the relevant people were found and started debugging the issue). On some occasions in the past, it even took a few days to see a fix merged. During that time, developers and testers were blocked, not an ideal status.

Luckily, we now have a super easy way to avoid this!

## Running OST on Open Patches (Pre Merge)

I know you can't wait to hear about how to run OST on your patch, so I'll just jump into the TL;DR version, here is how you do it:

* *Build RPMs from your open patch(es)*

    Building RPMs today from any open oVirt patch is simple as just
    asking for it.. :)<br>
    The new 'build-on-demand' option from oVirt Standard CI allows
    you to just type **ci please build** in a comment on your patch
    and a new build will be triggered on the project 'build-on-demand' jobs.<br>
    Once the 'build-on-demand' job finished building, write down the job URL,
    for e.g: [vdsm-master-build-on-demand](http://jenkins.ovirt.org/job/vdsm_master_build-artifacts-on-demand-el7-x86_64/9/).
    (btw, you can do this for as many oVirt projects you want and have a list of URLs).


* *Run the manual OST job with your custom RPMs*

    Now that you have your custom RPMs ready, your JUST a click away from running OST
    on them.<br>
    * Login to [Jenkins](http://jenkins.ovirt.org) (make sure you have 'dev role' permissions, if not open a ticket to infra)<br>
    * Go to the [OST Manual job](http://jenkins.ovirt.org/job/ovirt_master_system-tests_manual/) for your relevant version (usually master).<br>
    * Click on 'build with parameters' menu ( on the left side )
    * Now add all the URLs you have with the custom RPMs ( one per line ),for e.g [vdsm-build](http://jenkins.ovirt.org/job/vdsm_master_build-artifacts-on-demand-el7-x86_64/9/)<br>
    * Click 'Build'<br>
    * Go get some coffee; Don't worry the job will send you an email once it is done ( on any status )

This info can also be found on the [official OST documentation page](http://ovirt-system-tests.readthedocs.io/en/latest/docs/CI/developers_info.html).

For more info or questions, please send email to infra@ovirt.org or lago-devel@ovirt.org if it is a lago-related question.

Happy testing!
