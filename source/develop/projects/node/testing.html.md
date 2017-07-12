---
title: Node Testing
category: node
authors: fabiand, mburns
---

# Node Testing

Automated testing can be done on several levels. Currently we plan to do some checks at build time and some high level checks on a running node instance.

## Tests at build time

**Requirements**

*   Should check the basic functionality of low-level libraries to reduce simple programming errors or changes in function calls which break some depending code.
*   Should be triggered at build time e.g. with a `make check` and test some basic functionality

### Syntax checks

Very trivial, just check if we follow pythons style guide [pep8](http://www.python.org/dev/peps/pep-0008/)

*   pep8 - Syntax checks
*   pylint
*   pyflakes

## Runtime tests

### Infrastructure

The tests need to be carried out on VMs and real hardware. The necessary steps involved to run the tests (select and prepare a host, run the test, tear it down) are not part of Jenkins and are carried out by [igor](https://gitorious.org/ovirt/igord).

The page [How to write Igor tests for Node](/documentation/how-to/write-igor-tests-for-node/) covers how to write Igor tests for Node.

#### Workflow

*   Jenkins builds an ISO
*   With Jenkins
    -   Inject [ovirt-igor-client](https://gitorious.org/ovirt/ovirt-igor-client) into ISO using edit-node tool
    -   Upload modified ISO to igor
    -   Start igor job by providing testsuite, profile(ISO+kargs), and host
    -   Wait for igor to finish
    -   Mail igor report

#### Todo

*   Merge upload ISO and start testing functionality into something more high level
*   Allow to define test plans (list of (testsuite,profile,host)-tuples)

### Sanity checks

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

### Unit tests

Unit tests can be used to check our internal "API" stability and discover bugs or regressions.

doctests is one way to add basic unit tests as comments to methods in python.

*   doctest - <http://docs.python.org/library/doctest.html> , <http://wiki.python.org/moin/DocTest>
*   unittest
*   nose

**Problems** Much code in ovirt relies on runtime informations and thus might be hard to test outside of a running system.

### TUI testing

The plan is to separate the TUI code and "logic" code even more, so that TUI actions (approximately) map to library methods. In such a case we can use unit testing to test the functionality of the library backing the TUI, and it should be easier to track bugs down which arise in the TUI.

# Testplan

The testcases and kept in the [test subdirectory of the ovirt-node git repository](http://gerrit.ovirt.org/gitweb?p=ovirt-node.git;a=tree;f=tests/igor;hb=HEAD).

## Basic Testcases

Link: [All available igor testcases/sets/suites](http://gerrit.ovirt.org/gitweb?p=ovirt-node.git;a=tree;f=tests/igor;hb=HEAD)

| Testsuite                                                                            | Difficulty | Complete | Comment                                                                                                                                               | Updated    |
|--------------------------------------------------------------------------------------|------------|----------|-------------------------------------------------------------------------------------------------------------------------------------------------------|------------|
| Auto-install with storage_init=usb,ata                                              | difficult  | 0%       | Igor changes: VM with different storage devices                                                                                                       | 2012-11-19 |
| Engine registration - Register with an existing Engine instance                      | difficult  | 0%       | Should be possible with igor's current featureset                                                                                                     | 2012-11-15 |
| Update - Basic update                                                                | difficult  | 100%     | [testplan](http://gerrit.ovirt.org/gitweb?p=ovirt-node.git;a=blob;f=tests/igor/plans/ai_upgrade.plan;hb=HEAD)                                         | 2013-03-20 |
| Basic Auto-Install - Installation with the basic parameters and a login into the TUI | easy       | 100%     | [testsuite](http://gerrit.ovirt.org/gitweb?p=ovirt-node.git;a=blob;f=tests/igor/suites/ai_basic.suite;hb=HEAD)                                        | 2012-06-20 |
| Basic TUI-Install - Simple TUI installation using sane defaults                      | medium     | 100%     | [testsuite](http://gerrit.ovirt.org/gitweb?p=ovirt-node.git;a=blob;f=tests/igor/suites/mi_basic.suite;hb=HEAD)                                        | 2012-11-15 |
| Basic TUI Testing - Perform a couple of TUI tasks                                    | medium     | 100%     | [testcase](http://gerrit.ovirt.org/gitweb?p=ovirt-node.git;a=blob;f=tests/igor/sets/tui/check_navigation.set;hb=HEAD) part of \*_extended testsuites | 2012-11-15 |
| Basic unit tests - Perform doctest and unitests on the running Node                  | easy       | 100%     | [testcase](http://gerrit.ovirt.org/gitweb?p=ovirt-node.git;a=blob;f=tests/igor/sets/python.set;hb=HEAD) part of \*_extended testsuites               | 2012-11-15 |

