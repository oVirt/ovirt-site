---
title: Vdsm Nose Tests
category: vdsm
authors: danken, ykaplan
wiki_category: Vdsm
wiki_title: Vdsm Nose Tests
wiki_revision_count: 7
wiki_last_updated: 2012-05-02
---

# Vdsm Nose Tests

How to run vdsm Nose Tests:

1.  First you must have a vdsm git repository:
        git clone ssh://username@gerrit.ovirt.org:29418/vdsm

2.  Install python-nose
3.  To perform static tests (pyflakes and pep8) use: 'make check-local'
4.  To run all of the tests use:
        make check

    -   Please notice that 'make rpm' also runs all of the tests automatically.

5.  To run a specific test use: '`../tests/run_tests.sh _____Tests.py`' in the directory `vdsm/vdsm`
6.  We strongly prefer you don't use the following option, but if you must it is possible to exclude some of the tests using: 'NOSE_EXCLUDE='(here you create your rule)'

<Category:Vdsm>
