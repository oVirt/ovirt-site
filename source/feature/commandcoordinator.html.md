---
title: CommandCoordinator
category: feature
authors: moti, rnori
wiki_category: Feature
wiki_title: Features/Design/CommandCoordinator
wiki_revision_count: 44
wiki_last_updated: 2014-09-18
---

# Command Coordinator

## Introduce CommandCoordinator Framework and Ability To Persist Commands in Database

### Summary

Refactor the code in AsyncTask Manager to introduce Command Coordinator which holds many of the functions that resided in the CommandBase. The Command Coordinator exposes the functionaliy to persist any command to the database and retrieve it.

### Owner

*   Name: [ rnori](User:Ravi Nori)

<!-- -->

*   Email: <rnori@redhat.com>

### Current status

      Target Release: 3.5

*   Status: ...
*   Last updated date: April 7 2014

### Detailed Description

A new table in the database will hold all the information to persisit a command and rebuild it at a later point of time. Currently Asyc Tasks table holds the parameters needed to reconstruct an AsyncTask, but after the introduction of the CommandEntity table the async tasks table will no longer have these columns. The new table will be used to store both SPM and NON SPM commands. All the columns from the Async Tasks table pertaining to a command will be mored to the new table. In addition to the columns that already existed in Async Tasks table the new table will also have the parent command id. This would be useful to reconstruct the parent command parameters when rebuilding the command.

#### Details of Command Entity Table

        CREATE TABLE command_entities
        (
            command_id UUID NOT NULL,
            command_type integer NOT NULL,
            parent_command_id UUID DEFAULT NULL,
            root_command_id UUID DEFAULT NULL,
            action_parameters text,
            action_parameters_class varchar(256),
            created_at TIMESTAMP WITH TIME ZONE,
            CONSTRAINT pk_command_entities PRIMARY KEY(command_id),
            CONSTRAINT FK_parent_command_id FOREIGN KEY(parent_command_id)
               REFERENCES command_entities(command_id) ON DELETE CASCADE,
            CONSTRAINT FK_root_command_id FOREIGN KEY(root_command_id)
               REFERENCES command_entities(command_id) ON DELETE CASCADE
        );
        CREATE INDEX idx_parent_command_id ON command_entities(parent_command_id) WHERE parent_command_id IS NOT NULL;
        CREATE INDEX idx_root_command_id ON command_entities(root_command_id) WHERE root_command_id IS NOT NULL;

#### Methods to persist command

The command coordinator exposes two new methods persistCommand and retrieveCommand. Persist command can be invoked on any command by calling command.persistCommand(VdcActionType parentCommand). This calls Command Coordinator to persit the command into the database.

         public abstract void persistCommand(Guid commandId, Guid parentCommandId, Guid rootCommandId, VdcActionType actionType, VdcActionParametersBase params);
         public abstract CommandBase`<?>` retrieveCommand(Guid commandId);

#### Command Entity DAO

Command entity DAO is the class object that deals with persisting the CommandEntity object. There are methods in this class to save/update/retrive and delete the command entity. New stored procedures will need to be added to support this functionality. Exisiting stored procedures in Async Tasks needs to be modified to reflect the removal of columns from the table.

### Dependencies / Related Features

<http://www.ovirt.org/Features/Design/LiveMerge>

<Category:Feature>
