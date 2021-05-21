---
title: oVirt 3.0 release management
category: release
authors:
  - danken
  - dneary
  - jumper45
  - mburns
  - oschreib
  - quaid
  - rmiddle
---

# oVirt 3.0 release management

## First Release

### Timeline

*   oVirt first release is currently scheduled to **2012-02-09**.
    -   Go/no-go meeting (#ovirt irc channel): **2012-02-07 15:00UTC**
    -   Final VDSM: **2012-01-10**
    -   Final oVirt-engine: **2012-01-12 12:00 UTC**
    -   Versioned git branch creation: **2012-01-12**
    -   First test day: **2012-01-16**
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

*   **ovirt-node**:
    -   VDSM Doesn't register without manual process (/wiki/Engine_Node_Integration#Engine_core_machine)
        -   Patches posted, awaiting approval
            -   suggested patches break backward compatibility with vdsm-4.9 in several cases - registration to a different servelet, different management network breaks migration, maybe more issues.
    -   **ETA**: Dependent on VDSM, but should be by 2011-12-09

### Open issues

*   **Signing**: Who should sign tarballs?

