---
title: AsyncTaskManagerChanges 3.3Detailed
authors: rnori
---

# AsyncTaskManagerChanges 3.3Detailed

## Details of Aysnc Task Manager Changes

### Persists Task Place Holder Before Submitting Task to VDSM

One of the issues addressed in these changes is the ability to fail a command if the server has been restarted during the execution of the command. In order for the server to determine that the task has been partially executed and needs to be failed, we need to determine the number of child tasks that need to be execute. This change inserts place holders in to the database table async_tasks for all child tasks of a command in a single transaction. The task id for each place holder is generated on the engine. Once the job has been submitted to the vdsm, the place holder is updated with the vdsm taskid. If the server is restarted during the execution of the command, on server restart we fail all commands that have place holders in the database with out a vdsm task id.

In order to achive this a few changes have been made to the under lying code in the engine.

#### Instantiate and execute command internally rather than through Backend

In the current implementation we have been executing child commands using Backend.runInternalAction, which creates the command using reflection and executes it. But inorder for the command to call a method to insert place holders for the child command a command needs to instantiate the child command and call methods on it.

#### Changes to CommandBase

A few methods have been added to CommandBase, these methods will only be called from with in a command.

        /**
         * Checks to see if the command can be execute and sets a global flag
         */
         protected void checkCanDoAction()

       /**
         * This method is called before executeAction and after checkCanDoAction
         * to insert the async task place holders for the child commands.
         */
        protected void insertAsyncTaskPlaceHolders()

        /**
          * Commands can override this method to build a map of all child commands.
          * Called from insertAsyncTaskPlaceHolders to build a list of all child
          * commands and insert async task place holders for them
          * @return
          */
         protected Map`<Guid, CommandBase<?>`> buildChildCommands()

         /**
          * Called to construct the child command.
          * @param actionType
          * @param parameters
          * @param runAsInternal
          * @param context
          * @return
          */
         protected CommandBase`<?>` constructCommand(VdcActionType actionType,
                 VdcActionParametersBase parameters,
                 boolean runAsInternal,
                 CommandContext context)

         /**
          * calls execute action the child command.
          * @param command
          * @param parameters
          * @return
          */
         protected VdcReturnValueBase runCommand(CommandBase`<?>` command)

#### Change in the way command is executed

So to execute a command in the new framework we would use the following code.

         command.checkCanDoAction();
         command.insertAsyncTaskPlaceHolders();
         returnValue = command.executeAction();

instead of just

         returnValue = command.executeAction();

#### Modifications to Parent Commands

The CommandBase.insertAsyncTaskPlaceHolders method calls buildChildCommands to build a map of all child commands and insert place holders for them. There is a default implemantation provided in CommandBase for buildChildCommands which returns an empty map.

A parent command that is modified to use the feature should over write method buildChildCommands to build a map of child commands. For example the AddVmTemplateCommand can override the buildChildCommands method to build a map of all CreateImageTemplateCommands for each DiskImage.

         @Override
         protected Map`<Guid, CommandBase<?>`> buildChildCommands() {
             Guid vmSnapshotId = Guid.NewGuid();
             for (DiskImage diskImage : mImages) {
                 commandsMap.put(diskImage.getImageId(), constructCommand(
                         VdcActionType.CreateImageTemplate,
                         buildChildCommandParameters(diskImage, vmSnapshotId),
                         true,
                         ExecutionHandler.createDefaultContexForTasks(getExecutionContext())));
             }
             return commandsMap;
         } 

and in the place where AddVmTemplateCommand was calling Back.runInternalAction the new code calls CommandBase.runCommand.

         for (DiskImage diskImage : mImages) {
                 // The return value of this action is the 'copyImage' task GUID:
                 VdcReturnValueBase retValue = runCommand(commandsMap.get(diskImage.getImageId()));
                 .......
         }

#### Modifications to child Commands

The child command that creates a task by calling CommandBase.createTask also needs to be modified. So in this case CreateImageTemplateCommand is modified to override the method insertAsyncTaskPlaceHolders. The method calls CommandBase.createAsyncTask to create a place holder in the db and return the task id associated with it.

         private Guid taskId;
         protected void insertAsyncTaskPlaceHolders() {
                taskId = createAsyncTask(VdcActionType.AddVmTemplate,
                                             VdcObjectType.Storage,
                                             getParameters().getStorageDomainId(),
                                             getParameters().getDestinationStorageDomainId());
         }

The task id is passed to the createTask when executeCommand is called so that the row in the database can be updated with the vdsm id when the task is submitted to vdsm

                     createTask(taskId,
                             vdsReturnValue.getCreationInfo(),
                             VdcActionType.AddVmTemplate,
                             VdcObjectType.Storage,
                             getParameters().getStorageDomainId(),
                             getParameters().getDestinationStorageDomainId());

#### Fail Commands Without Vdsm Id

On server restart in AsyncTaskManager we check for all tasks that have empty vdsm id and fail the command. The empty place holders in the db are cleaned and the command is failed in a single transaction.
