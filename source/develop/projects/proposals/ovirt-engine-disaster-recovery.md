---
title: Project Proposal - oVirt Engine Disaster Recovery (oVirt Engine DR)
category: project-proposal
authors: xandradx, jandrad, dbinary
wiki_category: Project proposal
wiki_title: Project Proposal - oVirt Engine Disaster Recovery (oVirt Engine DR)
wiki_revision_count: 1
wiki_last_updated: 2016-07-13
---

# Project Proposal - oVirt Engine Disaster Recovery (oVirt Engine DR)

## Summary

oVirt Engine DR  is a web application, that uses Java + Ovirt API + PostgreSQL and MariaDB, to perform the task needed to recover from a Disaster Recovery.

## Owner and Initial Maintainers

* José Eduardo Andrade Escobar <jandrad@chocomango.net>
* Jorge Luis Andrade Escobar <jandrade@itm.gt>
* Luis Armando Pérez Marín <lperez@itm.gt>


## Current Status

*   This project is in [incubation](/governance/adding-a-subproject/).
*   Last updated: Jul 13 2016

oVirt Engine DR currently exists as an independent open source project hosted on [github](https://github.com/xandradx/ovirt-engine-disaster-recovery). This wiki page will gather input on whether oVirt Engine DR should become an oVirt sub-project and (if so) how best to integrate it into the oVirt stack.

## oVirt Infrastructure

*   Bugzilla
*   Mailing list: devel

## Detailed Description

oVirt Engine DR, uses oVirt API and perform tasks that would require manual intervention, in case of a Disaster Recovery.

* Disables Power Management for Hosts
* Manual Fence all Hosts in non_responsive state
* Modifies Server Storage Connections (currently directly to Engine Database)
* Activates some Hosts to be able to recover from Disaster
* oVirt Engine DR stores the configuration on a MariaDB database, and let the administrator create other users, that can't change configuration but can start the procedure.


**High-level work items:**

*   Remove the need to alter Engine Database directly, would requiere modification to oVirt API.


oVirt Engine DR is a written in java and should probably be packaged independently. 

*  The application was designed to be run on a different machine that the engine, this was a requirement for an specific customer.

## License

Licensed under the Apache License, Version 2.0 (Apache-2.0) <http://www.apache.org/licenses/LICENSE-2.0>

## Benefit to oVirt

We have seen that most of the tasks needed to be executed in order succesfully move to an alternative site in case of a Disaster, requires a deep knowledge of oVirt, scripting, an API usage. This application eliminates the complexity for a regular oVirt user, and will provide an easy to use interface to perform the tasks.


## Scope

oVirt Engine DR, use the oVirt API, any changes made to the API, affects our project. 

## Test Plan

*Not yet specified.*

## User Experience

At this time there's going to be a new portal, that the user can access. In order to use the application. And should be installed on a different Machine that the engine runs on. 

## Dependencies

*   ovirt-engine-sdk-java
*   MariaDB
*   Play framework

## Contingency Plan

There is no user friendly solution to perform this complex task. 

## Documentation

oVirt Engine DR is documented [in the source](https://github.com/xandradx/ovirt-engine-disaster-recovery), this project implemements, approach #2, presented on this slides DevConf.cz - 2014 [Disaster Recovery Strategies Using oVirt's new Storage Connection Management Features](http://www.slideshare.net/AllonMureinik/dev-conf-ovirt-dr)

## Release Notes

*Not yet provided.*


[Category:Project proposal](Category:Project proposal)
