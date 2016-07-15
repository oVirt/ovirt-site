---
title: oVirt cluster level test
authors: markwu
wiki_title: Ovirt cluster level test
wiki_revision_count: 2
wiki_last_updated: 2013-03-25
---

# oVirt cluster level test

**oVirt cluster level test work flow** ![](Ovirt-test.png "fig:Ovirt-test.png")

**Explanations about the flow chart.**

<big>Initial Setup:</big>

1 Configure igor with the following given stuff:

*   kickstart files for engine and vdsm host based on Fedora or RHEL.
*   installation medias for Fedora/RHEL or oVirt-node/RHEV-H
*   oVirt test packages repo.

2.Igor updates cobbler with stuff above except ISOs for oVirt-node/RHEV-H because they're going to be edited on each test plan. Igor also adds a few different profiles to cobbler and creates some VM as templates.

<big>Jenkins triggers a new testsuite:</big>

3. Jenkins updates the oVirt test repo with new built packages including ovirt-engine, vdsm, test cases etc.

4. Jenkins submits a test plan to Igor. The test plan describes testsuites and the spec of the test environment.

5. Igor prepares test hosts: both virtual machines and physical hosts can be used as test hosts. For virtual machines, they're based on nested KVM technology. And the new vm for test can be cloned from existing templates. For oVirt-node and RHEV-H, igor needs to edit the ISO image and add it to cobbler before creating new vm.

6. Igor setups the required resource of storage and network according to the description in test plan.

7. Igor updates oVirt related packages via ssh commands to guests (ssh public keys are injected during installation via kickstart's post script). And then invoke an igor client script inside the oVirt engine host. It will run the testsuite based on oVirt engine SDK on oVirt engine host and report result back to Igor

8. Igor reports the test result back to Jenkins.

Reference:

*   <https://gitorious.org/ovirt/igord/blobs/master/docs/Testing_process_overview.rst>
