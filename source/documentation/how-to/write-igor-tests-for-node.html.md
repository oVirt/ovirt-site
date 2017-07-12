---
title: How to write Igor tests for Node
category: howto
authors: fabiand
---

<!-- TODO: Content review -->

# How to write Igor tests for Node

A good introduction how testing of Node works is given in [Node Testing](Node Testing). This page focuses on getting started with Igor tests and Node.

## Terminology

The following terms are described to explicitly define their meaning in the context of igor.

*   Testcase: A script which is run on the system under test
*   Testset: A list of testcases
*   Testsuite: A list of testsets
*   Job: A tuple which ties a (testsuite, host, profile) together. These three components are required to run a job on igor.
*   Testplan: A list of job specifications
*   Profile: Is basically a ISO or kernel+initramfs+kargs which is used to provision a host.
*   Host: Either a VM or a real host

## Concept

Igor takes job specs which define what "testcase" is run on which "host" with what kind of "profile". This three information bits for a job specification. Igor takes a job spec and will provision the given host with the given profile and will run the testsuite on it. In reality igor is just provisioning and launching the host, the testsuite is initiated by a service which is run on the host and injected into the ISO which is used to created the profile. Setting up igor is outside of the scope of this document and is described elsewhere.

## Writing a new Igor testcase

Writing a new testcase is easy. Just create a script (bash or python) in the *ovirt-node* `tests/igor/tcs` directory. As an example we can create a testcase (`tests/igor/tcs/selinux-denials.sh`) which checks for any SELinux denials.

    #!/bin/bash -x
    #
    # A simple testcase which checks for denials in the audit.log
    #

    grep denied /var/log/audit/audit.log
    RETVAL=$?

    # Failed if there are any denied entries
    [[ $RETVAL != 0 ]] && exit 1

    # Otherwise this testcases passes
    exit 0

One thing to note is that all output to stderr and stdout is logged by the igor service and fed back to the igor server.

***Note:** Python unit tests can also be testcases (in the igor sense) an be run at runtime. This makes sense because many functions which are part of Node's codebase require runtime informations*

## Referencing an Igor testcase

The testcase above won't be run yet, because it is not referenced in any testset and testsuite. To run the testcase it has to be referenced in a testset - which is the later referenced in a testsuite, and can be used in a job specification. You can use one of the existing testsets (given in `tests/igor/sets`) or create your own testset.

***Note:** Testsets and Testsuites use the yaml syntax to define a testset or testsuite.*

### Referencing a testcase in a testset

For now we assume that a `tests/igor/sets/selinux.set` testset exists where we add our new testcase. The testset file could look like the following snippet:

    ---
    description: 'Does some basic selinux checks'
    libs: ['../libs/common']
    searchpath: '../tcs'
    ---
    filename: 'selinux-denials.sh'
    ---

The first "document" (the lines between a pair of `---`) defines some testset metadata ("description", "libs", "searchpath"). All following "documents" reference a testcase.

A testcase is referenced by adding a "document" with a "filename" line, pointing to the appropriate testcase. The filename must be relative to the testset file or relative to the path given with the "searchpath" line in the testset header.

### Referencing a testset in a testsuite

Now this testset needs to be referenced by a "testsuite" so it can be run. A testsuite definition resides in `tests/igor/suites` and looks like the following snippet:

    ---
    description: 'Automated installation without TUI tests.'
    ---
    # Where to look for testsets.
    # By default it's the dirname of this file
    searchpath: '../sets/'
    sets:
      - 'after_auto_install.set'
      - 'basic.set'
      - 'reboot.set'
      - 'services.set'
      - 'selinux.set'
      - 'after_testing.set'
    ---

The "selinux.set" is referenced in the "sets:" section of that testsuite specification. Wrapping all this up means that the `check-selinux.sh` testcase will be run, when the testuite above is submitted to igor.

# Common and advanced stuff

## Annotations

Annotations can be used to add more high level informations to a testcase run. TBD

## Artifcats

Artifacts can be used to archive files during a testcase run. TBD

## Libraries

Libraries can be part of testsets which can be referenced by testcases. This is usefull if something isn't packaged for Fedora but you need it during the testrun. TBD

# Weblinks

*   [oVirt Node specific documentation for Igor](http://gerrit.ovirt.org/gitweb?p=ovirt-node.git;a=tree;f=tests/igor/docs;hb=HEAD)
*   [oVirt Node Igor tests](http://gerrit.ovirt.org/gitweb?p=ovirt-node.git;a=tree;f=tests/igor;hb=HEAD)
*   [Documentation provided by Igor](https://gitorious.org/ovirt/igord/trees/master/docs)

