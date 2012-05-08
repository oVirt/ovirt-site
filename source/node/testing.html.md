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

*   pep8 - Syntax checks
*   pylint
*   pyflakes

#### Unit tests

Unit tests can be used to check our internal "API" stability and discover bugs or regressions.

doctests is one way to add basic unit tests as comments to methods in python.

*   doctest - <http://docs.python.org/library/doctest.html> , <http://wiki.python.org/moin/DocTest>
*   unittest
*   nose

**Problems** Much code in ovirt relies on runtime informations and thus might be hard to test outside of a running system.

#### TUI testing

The plan is to separate the TUI code and "logic" code even more, so that TUI actions (approximately) map to library methods. In such a case we can use unit testing to test the functionality of the library backing the TUI, and it should be easier to track bugs down which arise in the TUI.

### Post-Build testing

#### Sanity checks

**Requirements**

*   Should be triggered automatically from automated builds (Jenkins)
*   Ideally will cause builds to be marked either failed or unstable
*   Should cover basic sanity testing scenarios that we cover in manual testing today
*   Testcases should be easy to write and flexible
*   Individual testcases should be also *easily* testable
*   Needs to cover different (see below) to allow complex setups like: Test 'Suite A' on a Fedora host with three unpartitioned disks and on a second Fedora host with three partitioned disks
    -   hosts (e.g. virtual, real)
    -   distributions (e.g. RHEL, Fedora, CentOS, ...)
    -   profiles (e.g. partitioned or not, with auto-install or not, ...)

**Basic Sanity testing scenarios**

1.  Boot and install oVirt on real hardware or virtualized (Sanity testing should always include at least 1 test on real hardware)
2.  install using TUI
3.  install using auto-install
4.  general configuration done (network, storage, ovirt-engine)
5.  start vms on running ovirt-node hosts using FC and iscsi storage domains

#### Workflow

Actors:

*   A set of **Testsuites**. Consisting of one or more *Testcases*
    -   Testcases could be simple bash and python scripts
*   A set of **Profiles**. Describing the setup of a Host. E.g. distribution, installation method, storage and network layout.
    -   Specifies how to install the node, what storage and network configuration to use.
    -   In the easiest case this boils down to a specific kernel commandline getting passed to node (which is then picked up by the installer) to install it accordingly
*   A set of **Hosts**. The target of a *Testsuite*, virtual guests or real hardware.
    -   A host is mainly needed to create appropriate virtual guests
*   A **Controller**, dispatching (*Testsuites*, *Profile*, [*Host*]) tuples thus
    -   provisioning a *Host*,
    -   running a *Testsuite* on the provisioned *Host*,
    -   monitor progress and act if necessary
    -   and collect/summarize the results
    -   technical: rest-less, wsgi

The actual flow would be like:

1.  *Testsuite* is submitted to the *Controller*, triggered by e.g. jenkins
2.  While: *Controller* monitors the *Host* and e.g resets it if needed e.g. to long test duration, network ping timeout or some other criteria
    1.  *Controller* provisions one of the provided *Hosts* if available as given by the *Profile*
    2.  *Controller* passes the *Testsuite* to the *Host*
    3.  *Host* is executing each *Testcase* in the *Testsuite* and passes partial results back to the *Controller*

3.  *Controller* reports results back to e.g. jenkins

<Category:Testing> <Category:Automation>
