---
title: Engine Command changes
authors: ovedo, rnori, yair zaslavsky
wiki_title: Wiki/Engine Command changes
wiki_revision_count: 8
wiki_last_updated: 2014-07-08
---

# Engine commands infrastructure changes for 3.5

### Context changes

Version 3.5 introduced the usage of engine session ID through all over the engine flows.

Instead of holding the session ID on thread local, The commandContext object is used in order to propgate context through engine flow, including the engine session Id.

EngineContext is introduced In addition to the Lock , Execution context and compensation context that existed in version 3.4 .

EngineContext is a context that should exist throughout the engine flow , currently holding the engineSessionId.

In order to invoke an internal command, and pass the context of the calling command, one past perform the following steps:

1. Add a CTOR to the internal command, cotaning the "CommandContext commandContext" argument as the last argument.

For example:
 public CreateSnapshotCommand(T parameters, CommandContext cmdContext) {

                    super(parameters, cmdContext);      
                    setSnapshotName(parameters.getDescription());
            }

2. From commands, instead of using getBackend().runInternalAction or Backend.getInstance().runInternalAction use

            runInternalAction       
      This method was introduced at CommandBase, and is reposible for propagating the context.

For example:

                 VdcReturnValueBase returnValue = runInternalAction(VdcActionType.HotPlugDiskToVm, params);       

3. In case a command is using a helper (a class that does not extend CommandBase, and usually holds some functionality that is shared for several commands who are not of the same inheritence sub tree) the syntax of

                 Backend.getInstance().runInternalAction(...) should be used. 

In this case, the caller might or might not pass the command context as a parameter to the call.

If command context is not passed, the Command class should have a CTOR without a command context.

If command context is passed, the Command class shoud have a CTOR with a command context.

For example: LiveSnapshotTaskHandler.execute invokes an internal action:

        VdcReturnValueBase vdcReturnValue =
                         Backend.getInstance().runInternalAction(VdcActionType.CreateAllSnapshotsFromVm,
                         getCreateSnapshotParameters(),
                         ExecutionHandler.createInternalJobContext());

The CTOR of the internal action is:

         public CreateAllSnapshotsFromVmCommand(T parameters, CommandContext commandContext) {
             super(parameters, commandContext);
             //....
         }
