---
title: Vdsm Nose Tests
category: vdsm
authors: danken, ykaplan
---

# Vdsm Nose Tests

How to run vdsm Nose Tests:

1.  First you must have a vdsm git repository:
        git clone "https://gerrit.ovirt.org/vdsm"

2.  Install python-nose
3.  To perform static tests (pyflakes and pep8) use: 'make check-local'
4.  To run all of the tests use:
        make check

    -   Please notice that 'make rpm' also runs all of the tests automatically.

5.  To run a specific test use: '`../tests/run_tests.sh _____Tests.py`' in the directory `vdsm/vdsm`
6.  We strongly prefer you don't use the following option, but if you must it is possible to exclude some of the tests using: 'NOSE_EXCLUDE='(here you create your rule)'

