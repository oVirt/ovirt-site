---
title: Bugzilla rework
authors: ydary
---

# Bugzilla rework

1.  oVirt will move to a Bugzilla classification within the Red Hat bugzilla:

:#oVirt is a set of synced sub-projects that is growing in complexity every day.

:#Each project has its own versioning schema\\components and is built separately. Therefore it needs to be tracked for issues separately.

:#Each building block (sub-project) of oVirt will be a Bugzilla product which will allow tracking of package versions and target releases based on its versioning schema.

:#Each maintainer will have admin rights on his Bugzilla sub-project and will be able to change flags, versions, targets and components.

Example:

| Product | Components       | Details                                                                               |
|---------|------------------|---------------------------------------------------------------------------------------|
| vdsm    | RFEs             | Requests for enhancements.                                                            |
| vdsm    | Build            | Build related issues.                                                                 |
| vdsm    | Core             | Core issues.                                                                          |
| vdsm    | Documentation    | Documentation related issues.                                                         |
| vdsm    | General          | General issues and requests, select this if you do not know what component to select. |
| vdsm    | Packaging.debian | Debian Packaging related issues.                                                      |
| vdsm    | Packaging.rpm    | RPM Packaging related issues.                                                         |
| vdsm    | Services         | Services related issues.                                                              |
| vdsm    | Tools            | Tools related issues.                                                                 |
| vdsm    | SuperVDSM        | SuperVDSM related issues.                                                             |
| vdsm    | Gluster          | Gluster related issues.                                                               |
| vdsm    | Bindings/API     | Bindings/API related issues.                                                          |

1.  Flag system will be added to the oVirt tracker:

:#needinfo - Used to ask questions to other users of bugzilla.

:#requires_doc_text - Will be used to auto-generate release notes for oVirt releases using provided text box in the bug.

:#ovirt-3.5.z \\ ovirt-3.6.0 \\ ovirt-3.6.z \\ ovirt-4.0.0 \\ ovirt-future - Version propuse flags. Will be set to plus, if planning approved, somebody commits to develop and test the bug\\feature.

:#blocker - Used to block releases due to urgency. Not fixing a bug marked as blocker will delay the release until fixed.

:#exception - Used to mark features\\bugs that should be considered for a release even due the merge windows passed for them. Features post feature freeze and bugs post code freeze.

:#Triaged - Used by planning team to mark that all involved parties know what needs to be fixed and how, when it should be ready and how to test it.

:#planning_ack - Ack that a bug\\feature should be considered for a releases.

:#testing_ack - Ack that someone will test a bug\\feature.

:#devel_ack - Ack that someone will develop needed code a bug\\feature.

:#testing_plan_complete - Flag set by oVirt maintainers to mark severe bugs or large features that needs a test plan. Acked once plan was created.

:#requirements_defined - Flags set by oVirt developers if requirements are not well defined. Acked by oVirt planning team, once requirements are defined by reporter.

:#testing_beta_priority - Marks features\\bugs that need to be tested before the oVirt RC.

:#ci_coverage_complete - Marks severe bugs or important features that need to be added to continuous integration of oVirt.

:#priority_rfe_tracking - Marked by oVirt planning team for the top features planned for a version that are most pressing for a release.

1.  A ‘teams’ drop-down will be added to oVirt to allow tracking according to the handling development team:

:#External

:#Gluster

:#i18n

:#Infra

:#Integration

:#Network

:#Node

:#SLA

:#Spice

:#Storage

:#UX

:#Virt

:#Docs

1.  Since version and target releases will be used to track each sub-project separately. Target milestones will now sync releases between sub-projects. Examples:

:#ovirt-3.5.3

:#ovirt-3.5.4

:#ovirt-3.5.5

:#ovirt-3.6.0-alpha

:#ovirt-3.6.0-beta

:#ovirt-3.6.0-rc

:#ovirt-3.6.0-ga

1.  RFEs will be tracked in a separate component of each sub-project, since they will likely touch multiple logical components in the sub-project. Complex features that touch several sub-projects will be tracked in ‘ovirt-engine’ and cloned on a need basis to other sub-projects to capture needed changes.
2.  Layered product will be added to mark issues affecting other projects (ManageIQ, Foreman, Neutron..).
3.  RFE was opened to add community votes on oVirt, so community need will be considered in planning.

## oVirt tracker rework milestones (ending early Oct 2015)

*   Bugzilla Team: Creation of new classification.
*   Planning Team: Manual creation of rules\\behaviours for Bugzilla (example: adding ‘RFE’ to bug name will set ‘FutureFeature’ keyword).
*   Sub-projects maintainers: addition of versions/targets. An RFE to automate this was already opened to allow automation of build process.
*   Bugzilla Team: Lock of old oVirt tracker to read\\edit only.
*   Everyone: New bugs will be opened on classification only.
*   Planning Team: Move of all bugs\\RFEs to new tracker.
*   Sub-projects maintainers: Scrub of RFEs\\bugs to version\\target\\component.

[Planning Spreadsheet](https://docs.google.com/spreadsheets/d/1SOJNw1WQHEhE2rVP26qNtu30aKLQIV8JEzPp8KqCbwU/edit?usp=sharing)
