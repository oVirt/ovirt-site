---
title: oVirt 4.2 Release Management
category: release
authors: sandrobonazzola
tags: release, management
---

# oVirt 4.2 Release Management

## Key Milestones

| Date       | Milestone                |
|------------|--------------------------|
| 2017-09-28 | oVirt 4.2 Alpha          |
| 2017-10-31 | oVirt 4.2 Beta           |
| 2017-12-05 | oVirt 4.2 RC1            |
| 2017-12-12 | oVirt 4.2 RC2            |
| 2017-12-18 | oVirt 4.2 RC3            |
| 2017-12-20 | oVirt 4.2 GA Release     |


## Translation Status

Translations are handled by Zanata. You can join the translators team and see current translation status here:
<https://translate.zanata.org/iteration/view/ovirt/ovirt-4.2>

## Release Criteria

### Alpha Release Criteria

1.  MUST: All sources must be available on ovirt.org
2.  MUST: All packages listed by subprojects must be available in the repository

### Beta Release Criteria

1.  MUST: Release Notes have feature-specific information: [oVirt 4.2 Release Notes](/release/4.2.0/)
2.  MUST: Alpha Release Criteria are met
3.  MUST: Supported localizations must be at least at 70% of completeness for being included in the release
4.  MUST: All accepted features must be substantially complete and in a testable state and enabled by default -- if so specified by the change
5.  MUST: Wildfly 11 GA should be available for the beta consumption

### Candidate Release Criteria

1.  MUST: Beta Release Criteria are met
2.  MUST: All test cases defined for each accepted feature must be verified and pass the test for the build to be released
3.  MUST: All lower-level components must be available on supported distributions at required version
4.  MUST: No known regressions from previous releases should be present
5.  MUST: Each subproject must allow upgrade from a previous version, either providing documented manual or automated upgrade procedures
6.  MUST: All features working on previous release must still work in the new release if not dropped as deprecated
