---
title: OVirt 3.0 release management
category: release
authors: danken, dneary, jumper45, mburns, oschreib, quaid, rmiddle
wiki_category: Releases
wiki_title: OVirt 3.0 release management
wiki_revision_count: 28
wiki_last_updated: 2012-08-20
---

# OVirt 3.0 release management

## First Release

### Timeline

*   oVirt first release is currently scheduled to **2012-01-31**.
    -   Versioned git branch creation: **2012-01-14**
    -   Components maintainers **MUST** send their release notes prior to the new branch creation.

### Requirements

*   **MUST**: Appropriate tag/branch in the git repos
*   **MUST**: Downloadable source tarball (signed)
*   **SHOULD**: Downloadable binary tarball
*   **SHOULD**: Downloadable binary builds for different distros
*   **MUST**: Easy SSL support (via installer or separate script)
*   **MUST**: Easy DB creation (via installer or separate script)
*   **SHOULD**: Easy installation method (ovirt-setup or ovirt service)
*   **MUST**: Pass minimal smoke test
    -   Running a VM on NFS and Local storage sounds reasonable to me (oschreib)
    -   **MUST**: ovirt-node full cycle (register, approve and running VM)

### Gaps

*   **setup process**:
    -   Missing SSL support
    -   No installer solution available yet
    -   **ETA**: 2011-12-14 (depends on the chosen solution)
*   **ovirt-node**:
    -   VDSM Doesn't register without manual process (http://ovirt.org/wiki/Engine_Node_Integration#Engine_core_machine)
        -   Patches posted, awaiting approval
    -   **ETA**: Dependent on VDSM, but should be by 2011-12-09

### Open issues

*   **Versioning**: What will be oVirt's first release version? 3.1.0-1, 0.0.1-1, 4.0.0-1?
*   **Upgrade**: Should we support upgrade in the first release?
*   **JBoss**:Which JBoss version should we support?
    -   Currently, only JBoss AS5 is available (self created rpm from their zip)
*   **Signing**: Who should sign tarballs?
*   **ovirt-engine-config**: Broken due to <https://bugzilla.redhat.com/show_bug.cgi?id=759094>

<Category:Releases>
