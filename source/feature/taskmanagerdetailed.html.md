---
title: TaskManagerDetailed
category: feature
authors: lpeer, moti, sandrobonazzola
wiki_category: Feature|TaskManager
wiki_title: Features/TaskManagerDetailed
wiki_revision_count: 101
wiki_last_updated: 2015-01-16
---

## Task Manager

### Summary

A Task Manager is a monitor which shows the current actions running in ovirt-engine and tracks their progress. It also capable of presenting completed commands. [http://ovirt.org/wiki/Features/TaskManager Task Manager feature page](http://ovirt.org/wiki/Features/TaskManager Task Manager feature page)

### Owner

*   Name: [ Moti Asayag](User:Moti)
*   Email: <masayag@redhat.com>

### Current status

*   Target Release: 3.1
*   Status: Design Review
*   Last updated date: 30/11/2011

### Detailed Description

A Task Manager is a monitor which shows the current actions running in ovirt-engine server. It provides transparency for the administrator regarding the actions, their progress and status. Usually, each action invoked by a user will be monitored by the Task Manager. It will be achieved by representing each action as an entry in the Tasks view of the Webadmin. Some of the actions are invoked asynchronously and should be monitored as well. An action might be a chain of commands depended on each other and monitored in respect to the action which triggered the commands sequence.
 The requirements for feature are described below:
# Providing a mechanism for tasks management/monitoring via UI (i.e - monitor task status, monitor tasks of given action, stop task, stop all tasks of command, restart of failed command).

1.  Defining a task dependency/task chaining mechanism (Task B will not start before completion of Task A).
2.  Providing a mechanism to invoke commands asynchronously.
3.  Defining a "best effort task" - The success of the parent command of this task will not be dependent on the result of a task).
4.  Providing permission mechanism for the task management.

Version will also contain some changes that are required internally for backend development and to improve task management functionality and correctness of behavior:

1.  Changing serialization of task parameters to JSon - will ease on tasks flow debugging
2.  Improving task recovery mechanism - in case JBoss restart (there might be a mismatch between last stored task info and the current task status in VDSM).
3.  Abstracting the Tasks representation in backend (e.g. VDSM, authentication or

#### Entity Description

The class diagram describes both new and updated entities in backend. ![](async-task-main-class-diagram.jpeg "fig:async-task-main-class-diagram.jpeg") ![](command-entity-class-diagram.jpeg "fig:command-entity-class-diagram.jpeg")

Detailed descriptions:
 **CommandEntity** a representation of a command in the system. Using this entity, a concrete instance inherited of *CommandBase* could be created (e.g. 'resurrection' of a command).

| Column Name        | Column Type | Null? / Default | Definition                                                                              |
|--------------------|-------------|-----------------|-----------------------------------------------------------------------------------------|
| entity_id         | UUID        | not null        | The command entity ID                                                                   |
| entity_name       | String      | not null        | The command entity name                                                                 |
| command_id        | UUID        | not null        | The associated command ID                                                               |
| action_state      | TinyInt     | not null        | The command state                                                                       |
| owner_id          | UUID        | not null        | The user which triggered the command                                                    |
| owner_type        | TinyInt     | not null        | The type user which triggered the command                                               |
| parameters         | text        | not null        | A JSON representation of the parameters associated with the command                     |
| action_type       | integer     | not null        | A JSON representation of the parameters associated with the command                     |
| message            | text        | null            | Stores the can-do-action message                                                        |
| return_value      | text        | null            | Stores the command return value as JSON                                                 |
| visible_to_ui    | bool        | default 'true'  | Describes if current entity should be presented to UI (relevant for sequential command) |
| start_time        | Datetime    | not null        | Command start time                                                                      |
| end_time          | Datetime    | null            | Command end time                                                                        |
| last_update_time | Datetime    | not null        | Command last update time                                                                |

**CommandSequence** a composed entity of the *CommandEntity*, representing whether the current command entity is a part of a sequential command (e.g. depended on other commands to be completed before being executed).

| Column Name            | Column Type | Null? / Default | Definition                                         |
|------------------------|-------------|-----------------|----------------------------------------------------|
| entity_id             | UUID        | not null        | The command entity ID                              |
| sequence_id           | UUID        | not null        | The sequence ID which the command is part of       |
| next_command_id      | UUID        | null            | The next-in-chain command ID                       |
| order_in_sequence    | integer     | not null        | The order of the command in the sequence           |
| initiator_command_id | UUID        | not null        | The ID of the command which initiated the sequence |

**CommandRepository** used to store and fetch command entities from a persistent layer. Later implementation could use internal cache for commands in progress and upon completion to flush the 'CommandEntity'' from memory to database.
**CommandDAO** a DAO interface which defines the DML operations for the Command entities.
**CommandDAODbFacadeImpl** an implementation of the CommandDAO interface.
**GetCommandsQuery** a query which fetches selective or entire command entities from the database.
**GetModifiedCommandsQuery** a query which fetches only commands which were updated since a given time. It is designed to pull only tasks which where updated since the last query invoked by a client.
**SequentialCommandRunnerFactory** a factory which creates a runner for sequential commands.
**SequentialCommandRunner** a sequential command runner is responsible to to create a sequence of commands which includes order and dependencies (in the future 'best effort' command could be integrated with the sequence creation process) and to invoke the sequence.

#### Flows Description

The following section describes the flow of command

#### CRUD

Describe the create/read/update/delete operations on the entities, and what each operation should do.

#### User Experience

Describe user experience related issues. For example: We need a wizard for ...., the behaviour is different in the UI because ....., etc. GUI mockups should also be added here to make it more clear

#### Installation/Upgrade

Describe how the feature will effect new installation or existing one.

#### User work-flows

Describe the high-level work-flows relevant to this feature.

#### Events

What events should be reported when using this feature.

### Dependencies / Related Features and Projects

What other packages depend on this package? Are there changes outside the developers' control on which completion of this feature depends? In other words, completion of another feature owned by someone else and might cause you to not be able to finish on time or that you would need to coordinate? Other Features that might get affected by this feature?

Add a link to the feature description for relevant features. Does this feature effect other oVirt projects? Other projects?

### Documentation / External references

Is there upstream documentation on this feature, or notes you have written yourself? Link to that material here so other interested developers can get involved. Links to RFEs.

### Comments and Discussion

Add a link to the "discussion" tab associated with your page. This provides the ability to have ongoing comments or conversation without bogging down the main feature page

### Open Issues

Issues that we haven't decided how to take care of yet. These are issues that we need to resolve and change this document accordingly.

<Category:Template> <Category:Feature>
