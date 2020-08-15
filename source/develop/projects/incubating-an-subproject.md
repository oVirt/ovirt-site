---
title: Incubating an oVirt Subproject
authors: bproffitt
---

# Incubating an oVirt Subproject

One of the key goals of oVirt is to deliver both a cohesive complete stack and discretely reusable components
for open virtualization management and to do this on a well defined schedule.
This means that each project, can be quite autonomous in terms of development and project release schedules,
however some key coordination needs to be achieved in order to meet the goal of providing a usable release on a well defined schedule.

Each project must agree to support the oVirt complete stack (CS) release schedule:

A project may do so by syncing its release schedule with the oVirt CS release schedule,
it may use any prior release and work fixes/patches to resolve integration issues, do a custom build, or some other scheme.
The key here is that the project is aware of the oVirt CS release schedule, and has a concrete plan in order to help make
that release be timely and successful.

Each project must agree to provide or integrate with one of the published APIs:

In order to release a cohesive stack, everything needs to work together.
The core of this is the engine.
If a new project is started it needs to integrate with a published API, or an additional API needs to be created into the engine project
to support the new project. Finally additional API’s can come into scope to provide facilities/capabilities that the engine consumes.
The board signs off on which project provide API’s to make sure there is coordination between the projects.
The board is not responsible for the technical aspects of the API’s, just the facilitation when named API projects are added or removed.
In order to coordinate and facilitate cross project architecture and schedule issues the [arch@ovirt.org](mailto:arch@ovirt.org) is used.

The key is that all projects in some or other way need to be integrated with the engine, either directly, indirectly by providing services to it, exposing, or extending it. In addition the board my vote to include additional projects that are complementary to the oVirt eco-system on a case by case basis.

If you would like to start a new project in oVirt, or contribute an existing project into oVirt please mail [mailto:board@oVirt.org](mailto:board@oVirt.org)

## oVirt Project Acceptance Policy

The oVirt Board has realized that for oVirt to be truly successful, the quality and health of its associated projects must be extremely high.
However, oVirt also realizes the need to have a low “barrier to entry” for new projects as well as a streamlined approach
to accepting in new projects.

Re-using guidelines from the “tried and true” operation of the Apache Software Foundation (ASF),
oVirt is enacting an Incubation process based on the ASF Incubator project;
for more detailed information about Apache and the Incubator, please see:

<http://www.apache.org/>
<http://incubator.apache.org/>

### Process

All oVirt projects will need to enter oVirt through the oVirt Incubator, regardless of history, heritage, etc… of the project.
This entrance is required to ensure the following conditions are met before becoming a “full-fledged” oVirt project:

The new project agrees...
... to integrate with one of the oVirt published APIs
.. to support the platforms release schedule.

All IP associated with the project codebase and support files (e.g.: website content, logos, documentation, etc) is in good standing,
tracked and provides a clear license from copyright holder to oVirt.
A “healthy” project, as [determined by the oVirt Board](/develop/projects/requirements-for-healthy-subprojects.html), exists.

If an accepted project does not meet the above requirements, it will remain in the incubation state until such measures are corrected.
It is the task of the Board to clearly detail to the project what measures are required for graduation.

The Incubated project can, at any time, petition for a vote of the Board to graduate to full status.
The vote of the Board must be unanimous.
Any NO votes must clearly indicate why the Director did not approve graduation and must provide clear guidance on what he/she is
looking for to address the deficiency.

