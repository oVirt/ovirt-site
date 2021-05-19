---
title: CommandCoordinator
category: feature
authors: moti, rnori
---

# Command Coordinator

## Introduce CommandCoordinator Framework and Ability To Persist Commands in Database

### Summary

Refactor the code in AsyncTask Manager to introduce CommandCoordinator which holds many of the functions that resided in the CommandBase. The CommandCoordinator exposes the functionality to persist any command to the database and retrieve it.

### Owner

*   Name: Ravi Nori (rnori)

<!-- -->

*   Email: <rnori@redhat.com>

### Current status

*   Last updated on -- by (WIKI)

### Detailed Description

A new table in the database will hold all the information to persist a command and rebuild it at a later point of time. Currently Asyc Tasks table holds the parameters needed to reconstruct an AsyncTask, but after the introduction of the CommandEntity table the async tasks table will no longer have these columns. The new table will be used to store both SPM and NON SPM commands. All the columns from the Async Tasks table pertaining to a command will be moved to the new table. In addition to the columns that already existed in Async Tasks table the new table will also have the parent command id. This would be useful to reconstruct the parent command parameters when rebuilding the command.

### Benefit to oVirt

This feature lets NON Spm commands like LiveMerge to be persisted into the database. So long running commands can use this feature to persist the command and load it up at a latter point of time from the database. This is especially useful in case the engine was restarted during the execution of LiveMerge or any long running command by providing a way to save and load the command. The async tasks table currently holds the information for SPM tasks to rebuild a command, but after this change the data will no longer is saved in async_tasks table. It will be saved in the command_entities table.

### Dependencies / Related Features

[Features/Design/CommandCoordinatorFlowsAndEvents](/develop/release-management/features/infra/command-coordinator-flows-and-events.html)
[LiveMerge](/develop/release-management/features/storage/live-merge.html)

### Documentation / External references

<https://bugzilla.redhat.com/show_bug.cgi?id=1083769>

![](/images/wiki/Coco.png)

#### Details of Command Entity Table

    CREATE TABLE command_entities
    (
     command_id uuid NOT NULL,
     command_type integer NOT NULL,
     root_command_id uuid,
     command_parameters text,
     command_params_class character varying(256),
     created_at timestamp with time zone,
     status character varying(20) DEFAULT NULL::character varying,
     callback_enabled boolean DEFAULT false,
     callback_notified boolean DEFAULT false,
     return_value text,
     return_value_class character varying(256),
     job_id uuid,
     step_id uuid,
     executed boolean DEFAULT false,
     CONSTRAINT pk_command_entities PRIMARY KEY (command_id)
    )
    CREATE INDEX idx_root_command_id ON command_entities(root_command_id)
    WHERE root_command_id IS NOT NULL;

#### Methods to persist/retrieve/delete command

The CommandCoordinator exposes new methods persistCommand and retrieveCommand. Persist command can be invoked on any command by calling command.persistCommand(VdcActionType parentCommand) or command.persistCommand(VdcActionType parentCommand, enableCallback) to enable call backs from the CommandExecutor framework. This calls CommandCoordinator to persit the command into the database.

Below are the list of methods from CommandCRUDOperations interface.

    public boolean hasCommandEntitiesWithRootCommandId(Guid rootCommandId);
    public CommandEntity createCommandEntity(Guid cmdId, VdcActionType actionType, VdcActionParametersBase params);
    public List<Guid> getChildCommandIds(Guid commandId);
    public CommandEntity getCommandEntity(Guid commandId);
    public CommandStatus getCommandStatus(Guid commandId);
    public List<CommandEntity> getCommandsWithCallBackEnabled();
    public void persistCommand(CommandEntity cmdEntity);
    public void persistCommand(CommandEntity cmdEntity, CommandContext cmdContext);
    public CommandBase<?> retrieveCommand(Guid commandId);
    public void removeCommand(Guid commandId);
    public void removeAllCommandsInHierarchy(Guid commandId);
    public void removeAllCommandsBeforeDate(DateTime cutoff);
    public void updateCommandStatus(Guid commandId, CommandStatus status);
    public void updateCommandExecuted(Guid commandId);
    public void updateCallBackNotified(Guid commandId);

#### Command Entity DAO

Command entity DAO is the class object that deals with persisting the CommandEntity object. There are methods in this class to save/update/retrieve and delete the command entity. New stored procedures will need to be added to support this functionality. Existing stored procedures in Async Tasks needs to be modified to reflect the removal of columns from the table.

    void saveOrUpdate(CommandEntity commandEntity);
    void remove(Guid commandId);
    void removeAllBeforeDate(Date cutoff);
    void updateExecuted(Guid id);
    void updateNotified(Guid id);
    void updateStatus(Guid command, Status status);

#### Command Entity Cleanup Manager

A new cleanup manager similar to AuditLogCleanupManager that removes any old commands that have been persisted but not have not been cleaned up after they were marked completed.

### CommandExecutor Framework

The CommandExecutor framework is build on top of the new methods introduced in CommandCoordinator. A command can be submitted to the CommandExecutor to be run in a separate thread and the command can provide a CommandCallBack which as callback methods that the CommandExecutor will invoke at various points in the lifecycle of the command.

#### Submit a command to CommandExecutor

To submit a command to the CommandExecutor framework the parent command can invoke the executeAsyncCommand providing the action type and the action parameters.

    public static Future<VdcReturnValueBase> executeAsyncCommand(
          VdcActionType actionType, VdcActionParametersBase parameters, CommandContext cmdContext)

#### CommandCallBack

The implementation of the command can override getCallBack methods to provide a custom command callback handler.

    @Override
    public CommandCallBack getCallBack() {
        return new CustomCommandCallback();
    }

The CommandCallBack is an abstract class with various methods that will be invoked during the life cycle of the command. The doPolling method of the callback is invoked at regular intervals by a quartz scheduler giving the callback a way to determine if the command has completed execution. Once the command has completed execution and the status of the execution has been determined, the command callback needs to update the status of the command using CommandCoordinatorUtil.updateCommandStatus(CommandStatus stauts), setting the status to either SUCCEEDED/FAILED. Once the status has been updated, the onFailed/onSucceeded method is invoked by the CommandExecutor.

    import org.ovirt.engine.core.common.action.VdcReturnValueBase;
    import org.ovirt.engine.core.compat.Guid;
    import java.util.List;
    public abstract class CommandCallBack {
        public CommandCallBack() {}
        public void executed(VdcReturnValueBase result) {
        }
        public void doPolling(Guid cmdId, List<Guid> childCmdIds) {
        }
        public void onFailed(Guid cmdId, List<Guid> childCmdIds) {
        }
        public void onSucceeded(Guid cmdId, List<Guid> childCmdIds) {
        }
    }

#### Parent CommandCallBack

Below is a simple example of a CommandCallBack. The example shows the call back implementation for a parent command. The command call back on each doPolling, checks the status of the child commands. If all child commands have completed it executes the endAction and sets the status to succeeded/failed.

    import org.ovirt.engine.core.bll.tasks.CommandCoordinatorUtil;
    import org.ovirt.engine.core.bll.tasks.interfaces.CommandCallBack;
    import org.ovirt.engine.core.common.action.RemoveSnapshotParameters;
    import org.ovirt.engine.core.compat.CommandStatus;
    import org.ovirt.engine.core.compat.Guid;
    import org.ovirt.engine.core.utils.log.Log;
    import org.ovirt.engine.core.utils.log.LogFactory;
    public class CustomCommandCallback extends CommandCallBack {
        private static final Log log = LogFactory.getLog(CustomCommandCallback.class);
        @Override
        public void doPolling(Guid cmdId, List<Guid> childCmdIds) {
            boolean anyFailed = false;
            for (Guid childCmdId : childCmdIds) {
                switch (CommandCoordinatorUtil.getCommandStatus(childCmdId)) {
                case ACTIVE:
                    log.info("Waiting on child commands to complete");
                    return;
                case FAILED:
                case FAILED_RESTARTED:
                case UNKNOWN:
                    anyFailed = true;
                    break;
                default:
                    break;
                }
            }
            CustomCommand<CustomCommandParameters> command =  (CustomCommand<CustomCommandParameters>) CommandCoordinatorUtil.retrieveCommand(cmdId);
            command.getParameters().setTaskGroupSuccess(!anyFailed);
            command.setCommandStatus(anyFailed ? CommandStatus.FAILED : CommandStatus.SUCCEEDED);
            log.infoFormat("All child commands have completed, status {1}", command.getCommandStatus());
        }
        @Override
        public void onSucceeded(Guid cmdId, List<Guid> childCmdIds) {
            getCommand(cmdId).endAction();
            CommandCoordinatorUtil.removeAllCommandsInHierarchy(cmdId);
        }
        @Override
        public void onFailed(Guid cmdId, List<Guid> childCmdIds) {
            getCommand(cmdId).endAction();
            CommandCoordinatorUtil.removeAllCommandsInHierarchy(cmdId);
        }
    }

#### Child CommandCallBack

The command callback for the child command is much simpler, it just needs to monitor the status of the command and update the status with the CommandExeuctor using the CommandCoordinatorUtil methods.

    import org.ovirt.engine.core.bll.tasks.CommandCoordinatorUtil;
    import org.ovirt.engine.core.bll.tasks.interfaces.CommandCallBack;
    import org.ovirt.engine.core.common.action.MergeParameters;
    import org.ovirt.engine.core.common.businessentities.VmJob;
    import org.ovirt.engine.core.compat.CommandStatus;
    import org.ovirt.engine.core.compat.Guid;
    import org.ovirt.engine.core.dal.dbbroker.DbFacade;
    import org.ovirt.engine.core.utils.log.Log;
    import org.ovirt.engine.core.utils.log.LogFactory;
    public class ChildCommandCallback extends CommandCallBack {
        private static final Log log = LogFactory.getLog(MergeCommandCallback.class); 
        @Override
        public void doPolling(Guid cmdId, List<Guid> childCmdIds) {
            // If the VM Job exists, the command is still active
            boolean isRunning = false;
            ChildCommand<ChildCommandParameters> command = (ChildCommand<ChildCommandParameters>) CommandCoordinatorUtil.retrieveCommand(cmdId));
`           boolean isDone = <custom code to check if command is running, call to database etc.>
            if (isDone) {
`               boolean succeeded = <custom code to check if command has succeeded, call to database etc.>
                command.setSucceeded(succeeded);
                command.setCommandStatus(succeeded ? CommandStatus.SUCCEEDED : CommandStatus.FAILED);
                command.persistCommand(command.getParameters().getParentCommand(), true);
            }
        }
    }

#### Persisting command return value

If data in return value(VdcReturnValueBase) of a command needs to be passed from child command to the parent command, this can be achieved by persisting the return value in the database. Nothing special needs to be done to persist this data to the db, all that the child command needs to do is to execute persistCommand after setting the needed data in the return value. This is also useful after server restarts where the return value of the child commands can be looked up by the parent command from the database.

#### Command Executed Flag

The executed flag is used to determine if the command executed to completion. If there is an exception or if the engine was restarted during the execution of the command this flag is false. To use this flag in the endWithFailure or endSuccessfully method the command needs to be managed by the CommandCoordinator framework. This can be achived by calling the persist command in the executeCommand method. Once it is managed by the CommandCoordinator framework the executed flag indicates if the command was executed to completion.

    @Override
    protected void executeCommand() {
         persistCommand(getParameters().getParentCommand(), false);
         .....
    }

    @Override
    protected void endWithFailure() {
           .....
           if (CommandCoordinatorUtil.getCommandExecutionStatus(getCommandId()) == CommandExecutionStatus.EXECUTED) {
              ....
          }
          ......
      }

### Testing

All the Async tasks need to work with the new code changes. Instead of commands being persisted into async tasks table, the command should be persisted in the new command_entities table.

### Test Cases

*   [QA:TestCase CommandCoordinator](/develop/qa/test-cases/commandcoordinator.html)



### Deep Dive Presentation

Deep Dive into CommandCoordinator Framework [Youtube](https://www.youtube.com/watch?v=V-mEttpaGL4)

