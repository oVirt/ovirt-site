---
title: TaskManager
category: feature
authors:
  - moti
  - sandrobonazzola
---

# Task Manager

## Summary

A Task Manager is a monitor which shows the current actions running in ovirt-engine and tracks their progress. It also capable of presenting completed commands for a configure period of time.

## Owner

*   Name: Moti Asayag (Moti)
*   Email: <masayag@redhat.com>

## Current status

[Task Manager Detailed Design](/develop/release-management/features/infra/taskmanagerdetailed.html)

*   Last updated date: Sun Jan 01 2012

## Detailed Description

A Task Manager is a monitor which shows the current actions running in ovirt-engine server. It provides transparency for the administrator regarding the actions, their status and progress. Usually, each action invoked by a user will be monitored by the Task Manager. It will be achieved by representing each action as an entry in the Tasks view of the Webadmin.

## Benefit to oVirt

Today, the administrator is not capable of knowing which actions are running in the engine-core system, unless going over the events log or the engine server logs and searching for a specific command. Some of the actions in the engine-core are synchronous, hence the user receive an immediate feedback about the action. However when invoking durable actions, there is no trivial way to monitor the advance of those actions. The Task Manager could be extended to manage actions in the future (e.g. restart failed commands).

## Dependencies / Related Features

Affected oVirt projects:

*   Engine-core
*   Webadmin
*   API


[TaskManager](/develop/release-management/features/) [TaskManager](/develop/release-management/releases/3.1/feature.html)
