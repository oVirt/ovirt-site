---
title: Build and test standards
category: ci
authors:
  - dcaroest
  - mkovgan
  - nsoffer
  - bkorren
---
# Build and Test Standards

The oVirt project defined a set of standards that allow a source project to
specify how it should be built, tested and released in a generic manner that is
independent from the programming languages and tools that we used to develop the
source project.

These standards are used to create generic build and test tools such as
`mock_runner` that can work in a consistent manner for any oVirt project.

The oVirt CI system uses these standards in order to run build, test and release
processes for projects in an automated manner. This is why these standards are
also known as "Standard-CI" or "STDCI".

For more information about the oVirt build and test standards, and the tools
that use them, see [the Build and Test
Standards](http://ovirt-infra-docs.readthedocs.io/en/latest/CI/Build_and_test_standards/)
specification document.
