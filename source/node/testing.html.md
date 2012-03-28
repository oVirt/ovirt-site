---
title: Node Testing
category: node
authors: fabiand, mburns
wiki_category: Testing
wiki_title: Node Testing
wiki_revision_count: 20
wiki_last_updated: 2013-03-20
---

# Node Testing - WIP

Automated testing can be done on several levels. Currently we plan to do some checks at build time and some high level checks on a running node instance.

### Tests at build time

**Requirements**

*   Should check the basic functionality of low-level libraries to reduce simple programming errors or changes in function calls which break some depending code.
*   Should be triggered at build time e.g. with a `make check` and test some basic functionality

#### Syntax checks

Very trivial, just check if we follow pythons style guide [pep8](http://www.python.org/dev/peps/pep-0008/)

#### Unit tests

Unit tests can be used to check our internal "API" stability and discover bugs or regressions.

doctests is one way to add basic unit tests as comments to methods in python.

*   <http://docs.python.org/library/doctest.html>
*   <http://wiki.python.org/moin/DocTest>
*   <http://en.wikipedia.org/wiki/Doctest>

**TUI testing** The plan is to separate the TUI code and "logic" code even more, so that TUI actions (approximately) map to library methods. In such a case we can use unit testing to test the functionality of the library backing the TUI, and it should be easier to track bugs down which arise in the TUI.

### Post-Build testing

#### Sanity checks

**Requirements**

*   Should be triggered automatically from automated builds (Jenkins)
*   ideally will cause builds to be marked either failed or unstable
*   should cover basic sanity testing scenarios that we cover in manual testing today

**Basic Sanity testing scenarios**

1.  Boot and install oVirt on real hardware or virtualized (Sanity testing should always include at least 1 test on real hardware)
2.  install using TUI
3.  install using auto-install
4.  general configuration done (network, storage, ovirt-engine)
5.  start vms on running ovirt-node hosts using FC and iscsi storage domains

<Category:Node> <Category:Testing> <Category:Automation>
