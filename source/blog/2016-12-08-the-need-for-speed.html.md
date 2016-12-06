---
title: The need for speed: Coming changes in oVirt's CI standards
author: bkorren
tags: infrastructure, developers, ci
dete: 2016-12-08 15:00:00 CET
---

[oVirt's CI standards][1] have been is use for a while in most oVirt projects and have largely been a success.

These standards have put the control of what the CI system does in the hands of the developers without them
having to learn about [Jenkins][2] and the [tooling around it][3]. The way the standards were implemented, with the 
"[mock_runner.sh][4]" script, also enabled developers to easily emulate the CI system on their own machines to 
debug and diagnose issues.

From the oVirt infra team's point of view, the CI standards have removed the need to constantly maintain build 
dependencies on the Jenkins slaves and also eliminated most of the situations where jobs running on the same
slave influenced one another.

The CI standards implementation we have has one shortcoming, it was not particularity fast.

[1]: http://ovirt-infra-docs.readthedocs.io/en/latest/CI/Build_and_test_standards.html
[2]: https://jenkins.io/
[3]: http://docs.openstack.org/infra/jenkins-job-builder/index.html
[4]: https://gerrit.ovirt.org/gitweb?p=jenkins.git;a=blob;f=mock_configs/mock_runner.sh

READMORE

We started seriously looking at this  after one of the VDSM maintainers [complained][5] that the "check_patch" jobs
for his project are running for far to long a time. It the end it turned out that a major reason for the delay
was in the way the [tests themselves worked][6], but still, we looked at "mock_runner.sh" and manage to speed it up
quite a bit.

[5]: http://lists.ovirt.org/pipermail/devel/2016-December/014427.html
[6]: https://gerrit.ovirt.org/#/c/67799/

What did we change
==================

Most of the time "mock_runner.sh" spends when it isn't actually running the user's CI script, is spent setting up
the [mock][7] environment. It turns out that despite mock being able to cache mock environments, we were aggressively
erasing the cache after each job invocation leading to the same environment having to be rebuilt.

[The first change we implemented][8] was simply to stop deleting the whole cache and instead only delete files that are
older then two days.

The CI standard allows developers to specify additional packages that would be available inside the mock environment.
With the way "mock_runner.sh" was implemented, those packages were installed in a way that prevented them from being
included in the mock cache. This means they were newly installed every time a job was running.

[The second change we implemented][9] was therefore to ensure those packages were saved to the mock cache as well.

[7]: https://github.com/rpm-software-management/mock
[8]: https://gerrit.ovirt.org/#/c/67795/
[9]: https://gerrit.ovirt.org/#/c/67801/

What does this mean for oVirt developers
========================================

The most noticeable aspect of the changes we've implemented (Besides the shorter job run times), is that while
previously the mock environment was freshly installed with the latest packages for each CI job, now most jobs will
use a cached mock environment that can be up to two days old.

Most developers will probably not notice the change, but sometimes the most recent package are needed at all times. 
In that case there are two thinks developers can do:

* Specify the exact required version of the package in the CI standard "*.packages" file.
* Install the package explicitly with a "yum" or a "dnf" command from the CI standard script.

Bottom line, how much faster is it?
===================================

In our tests, by using the changes above, we managed to shorten the time to setup the mock environment from 2.5-3
minutes to around 20 seconds! That is a worthwhile change indeed.

