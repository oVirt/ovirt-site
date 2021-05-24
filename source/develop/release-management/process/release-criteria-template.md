---
title: Release Criteria Template
category: release-management
authors: bproffitt
---

# Release Criteria Template

## Alpha Release Criteria

1.  MUST: All sources must be available on ovirt.org
2.  MUST: All packages listed by subprojects must be available in the repository
3.  MUST: All accepted features must be substantially complete and in a testable state and enabled by default -- if so specified by the change

## Beta Release Criteria

1.  MUST: Release Notes have feature-specific information
2.  MUST: Alpha Release Criteria are met
3.  MUST: Supported localizations must be at least at 70% of completeness for being included in the release

## Candidate Release Criteria

1.  MUST: Beta Release Criteria are met
2.  MUST: All test cases defined for each accepted feature must be verified and pass the test for the build to be released
3.  MUST: All lower-level components must be available on supported distributions at required version [1]
4.  MUST: No known regressions from previous releases should be present
5.  MUST: Each subproject must allow upgrade from a previous version, either providing documented manuals or automated upgrade procedures
6.  MUST: All features working on previous release must still work in the new release if not dropped as deprecated

[1] This means we're not hosting any package we don't develop inside oVirt repository just because it's not yet released officially.
