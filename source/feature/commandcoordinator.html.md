---
title: CommandCoordinator
category: feature
authors: moti, rnori
wiki_category: Feature
wiki_title: Features/Design/CommandCoordinator
wiki_revision_count: 44
wiki_last_updated: 2014-09-18
feature_name: Introduce CommandCoordinator Framework and Ability To Persist Commands
  in Database
feature_modules: engine
feature_status: In Development
---

# Command Coordinator

## Introduce CommandCoordinator Framework and Ability To Persist Commands in Database

### Summary

Refactor the code in AsyncTask Manager to introduce Command Coordinator which holds many of the functions that resided in the CommandBase. The Command Coordinator exposes the functionaliy to persist any command to the database and retrieve it.

### Owner

*   Name: [ Ravi Nori](User:rnori)

<!-- -->

*   Email: <rnori@redhat.com>

### Current status

*   Last updated on -- by [ WIKI}}](User:{{urlencode:{{REVISIONUSER}})

### Detailed Description

A new table in the database will hold all the information to persisit a command and rebuild it at a later point of time. Currently Asyc Tasks table holds the parameters needed to reconstruct an AsyncTask, but after the introduction of the CommandEntity table the async tasks table will no longer have these columns. The new table will be used to store both SPM and NON SPM commands. All the columns from the Async Tasks table pertaining to a command will be moved to the new table. In addition to the columns that already existed in Async Tasks table the new table will also have the parent command id. This would be useful to reconstruct the parent command parameters when rebuilding the command.

### Benefit to oVirt

This feature lets NON Spm coomands like LiveMerge to be persisted into the database. So long running commands can use this feature to persist the command and load it up at a latter point of time from the database. This is especially useful in case the engine was restarted during the execution of LiveMerge or any long running command by providing a way to save and load the command. The async tasks table currently holds the information for SPM tasks to rebuild a command, but after this change the data will no longer is saved in async_tasks table. It will be saved in the command_entites table.

### Dependencies / Related Features

<http://www.ovirt.org/Features/Design/LiveMerge>

### Documentation / External references

<https://bugzilla.redhat.com/show_bug.cgi?id=1083769>

![](Coco.png "Coco.png")

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

#### Methods to persist/retrieve/delete command

The command coordinator exposes two new methods persistCommand and retrieveCommand. Persist command can be invoked on any command by calling command.persistCommand(VdcActionType parentCommand). This calls Command Coordinator to persit the command into the database.

         public abstract void persistCommand(Guid commandId, Guid parentCommandId, Guid rootCommandId, VdcActionType actionType, VdcActionParametersBase params);
         public abstract CommandBase`<?>` retrieveCommand(Guid commandId);
         public abstract void removeCommand(Guid commandId);
         public abstract void removeAllCommandsBeforeDate(Date cutoff);

#### Command Entity DAO

Command entity DAO is the class object that deals with persisting the CommandEntity object. There are methods in this class to save/update/retrive and delete the command entity. New stored procedures will need to be added to support this functionality. Exisiting stored procedures in Async Tasks needs to be modified to reflect the removal of columns from the table.

         void saveOrUpdate(CommandEntity commandEntity);
         void remove(Guid commandId);
         void removeAllBeforeDate(Date cutoff);
         void updateStatus(Guid command, Status status);

#### Command Entity Cleanup Manager

A new cleanup manager similar to AuditLogCleanupManager that removes any old commands that have been persisted but not have not been cleaned up afetr they were marked completed.

### Testing

All the Async tasks need to work with the new code changes. Instead of commands being persisted into async tasks table, the command should be persisted in the new command_entities table.

### Comments and Discussion

*   Refer to [Talk:Introduce CommandCoordinator Framework and Ability To Persist Commands in Database](Talk:Introduce CommandCoordinator Framework and Ability To Persist Commands in Database)

<Category:Feature> <Category:Template>
