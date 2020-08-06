---
title: Release process
category: release-management
authors: bproffitt, dneary, oschreib, quaid, sandrobonazzola
---

# Release process

## Planning Phase

This phase deciding if a feature is ready to be released.

*   After a new 4.*y*.0 release, a new 4.*y+1.0* release is tentatively scheduled after six months.
*   A new release management page is created (see [oVirt 4.0 Release Management](../releases/4.0/release-management.html))
*   Must have a clear schedule, like [1](http://fedoraproject.org/wiki/Releases/24/Schedule)

<!-- -->

*   A new target milestone is created (e.g. ovirt-4.1.0)
*   A discussion is started on devel and users mailing list gathering ideas for next release features
*   Teams prepare a list of accepted features collecting / creating bug tracker, devel owner, qa owner, and feature page for each of them.
    -   The QA owner should build a test suite that effectively covers what's indicated in the Features page.
    -   The feature must contain enough documentation to be considered "a contract" between the feature owner and the feature tester / user.
*   Several presentations will be scheduled by the teams presenting the accepted features
*   An alpha release is tentatively scheduled four months before GA
*   Feature freeze is tentatively scheduled three months before GA
*   A beta release is tentatively scheduled two months before GA, git tree is branched for stabilization
*   A release candidate is tentatively scheduled one month before GA
*   A string freeze is tentatively scheduled two weeks before RC
*   Test days are scheduled after every milestone release

## Feature Submission

*   Each feature must come with a set of test cases covering the functionality provided by the new feature.
*   Each feature must define a contingency plan, allowing either to disable the incomplete feature or ensuring that the feature code is isolated in a directory or package that can be easily dropped.
*   Those features that can't be done with a contingency plan should live in their own branch until they're finished and merged in the main tree just when completed.

## Feature Review - Feature Submission Closed

Before Alpha Release, submitted features must be reviewed for inclusion in Alpha release.

### Ignoring Feature Submission Closure

Introducing significant changes after Feature Submission Closure can result in your patch being reverted.

These actions are allowed after Feature Submission Closure:

*   Adding code meant for automated testing of the feature
*   Adding bug fixes
*   Adding localization
*   Cleaning or optimizing the code without introducing new features

These actions are not allowed after Feature Submission Closure:

*   Continuing to add new enhancements (note that supporting a new distribution is an enhancement)
*   Trying to cover new enhancements under bug fixes
*   Making changes that require other subprojects to make changes as well (API, ABI and configuration files included) if not absolutely required for fixing a bug
*   Make changes that require packages not yet available on supported distributions.

### Exceptions

A public vote on the exception is required.

Exceptions should be asked for at least one week before Feature Submission Closure and voting on them should be closed by Feature Submission Closure date.

This means that you're not allowed to open new features, but you can complete those that can't be completed for Feature Submission Closure if the vote allows it.

### Incomplete Features

Incomplete features will be reverted according to their contingency plan

## Development Phase

*   Each subproject must list packages expected to be in the release.
*   All milestones releases are created by taking the latest nightly snapshot available after verifying that the build passes basic sanity test
*   Weekly status emails are sent starting three weeks before alpha release.
*   Release Manager updates the release notes pages starting from Alpha
*   Release Candidate will be postponed until all known blockers are fixed
*   Between RC and GA, release criteria are tested on the RC and if the release meets the criteria, a GA release will be built just updating the versioning code to drop master, git hash, and timestamp suffix from tarballs and rpms.
*   A new RC will be created and GA postponed by one week if release criteria are not met.
*   The whole test case suite must be verified on each release candidate.
*   Only patches fixing blockers bug must be allowed between RC and GA.

## Maintenance Phase

Once a version is released it enters the maintenance mode. This means that the following revision releases only fix security and critical bug fixes commits are backported to the stable branch. The first release following GA may also include minor fixes for new features included with that release.

### Acceptance criteria

*   The Bug is a Regression.
*   The Bug is a Security threat.
*   The Bug affects major functionality of the release.
*   The fix for the Bug won't introduce a major change in the code causing potential risk to the stability of the application.

### Release Planning

Maintenance releases are tentatively scheduled once per month.
