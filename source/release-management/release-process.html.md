---
title: Release process
category: release-management
authors: bproffitt, dneary, oschreib, quaid, sandrobonazzola
wiki_category: Release management
wiki_title: Release process
wiki_revision_count: 11
wiki_last_updated: 2015-02-23
---

# oVirt Release Process

### General

1.  **oVirt will issue a new release every 6 months.**
    -   EXCEPTION: First three releases will be issued in a ~3 month interval.
    -   Exact dates must be set for each release.

2.  **A week after the n-1 release is out, a release criteria for the new release should be discussed.**
    -   Release criteria will include MUST items and SHOULD items (held in wiki)
        -   MUST items will DELAY the release in any case.
        -   SHOULD items will include less critical flows and new features.
        -   SHOULD items will be handled as "best-effort" by component owners
    -   Component owners (e.g. Node, engine-core, vdsm) must ACK the criteria suggested.
    -   Release criteria discussions shouldn't take more then 2 weeks
    -   Progress on MUST items should be review every month, during the weekly meeting

3.  **Discuses the new version number according to the release criteria/amount of features.**
    -   Versions will be handled by each component.
    -   The general oVirt version will the engine version.

4.  **60 Days before release - Feature freeze**
    -   EXCEPTION: 30 days for 3 month release cycle
    -   All component owners must create a new versioned branch
    -   "Beta" version should be supplied immediately after.
        -   And on a nightly basis afterwards.
    -   Stabilization efforts should start on the new builds.
    -   Cherry-pick fixes for high priority bugs.
        -   Zero/Minimal changes to user interface.
        -   Inform in advance on any user interface change, and any API change.
    -   At this stage, we should start working on the release notes.

5.  **45 days before release - Test Day**
6.  **30 days before release - release candidate**
    -   EXCEPTION: 15 days for 3 month release cycle
    -   If no blockers (MUST violations) are found the last release candidate automatically becomes the final release.
        -   Rebuild without the "RC" string.
        -   ANOTHER OPTION- Avoid "Beta" or "RC" strings, just use major.minor.micro, and bump the micro every time needed.
    -   Release manager will create a wiki with list of release blockers
    -   Only release blockers should be fixed in this stage.
    -   OPTIONAL: final release requires three +1 from community members
        -   This item is currently optional, I'm not sure what a +1 means (does a +1 means "I tested this release", or "This release generally looks fine for me"?)

7.  **Create a new RC if needed**
    -   There must be at least one week between the last release candidate and the final release
    -   Go/No go meetings will happen once a week in this stage.
        -   Increase the amount of meeting according to the release manager decision.
        -   Release manager will inform the community on any delay.
    -   Official vote as described in <http://www.ovirt.org/governance/voting/>

8.  **Release**
    -   Create ANNOUNCE message few days before actual release.
    -   Move all release candidate sources/binaries into the "stable" directory
    -   Encourage community members to blog / tweet about the release
    -   PARTY

[Category:Release management](Category:Release management)
