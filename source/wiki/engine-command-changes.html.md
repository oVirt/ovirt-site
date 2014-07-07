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

3. Invoke internal commands properly from classes that are not commands In case a command is using a helper (a class that does not extend CommandBase, and usually holds some functionality that is shared for several commands who are not of the same inheritence sub tree) , or another class which is not a command - the syntax of

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

4. Handle command context propgation

In order to properly propagate context , the command context should be duplicated when calling command.

This can be done either by using the clone method of the CommandContext object, or by calling CommandBase.cloneContext which will return a cloned context of the contet of the command.

In some cases, we may want to alter fields of the duplicated context - for example, reset the compensation context (so the internal command will create its own compensation context).

In order to perform this, the following withXXX and withoutXXX methods were introduced to commandContext - withLock(EngineLock), withExecutionContext(ExecutionContext), withCompensationContext(CompensationContext), withEngineContext(EngineContext),

withoutLock(), withoutExecutionCOntext(, withoutCompensationContext()

for example -

         cloneContext().withExecutionContext(runVmContext).withoutLock().withoutCompensationContext());

will clone the context, , set on it the runVM execution context, and reset both the lock and the compensation context.

It is also possible to use the CommandBase.cloneContextAndDetachFromParent in order to perform context cloning and "detach" from all the detachable components of the context which are the lock , the execution context and the compensation context.

5. Propgate engine context to queries

Similar to command context propgation it is required to propagate the engine context to internal queries.

CommandBase.runInternalQuery and QueriesCommandBase.runInternalQuery were introruced and can be used to run an internal query with the engine context associated with the current context.

Internal queries that are invoked using these methods should have a CTOR with engine context. For example:

          runInternalQuery(VdcQueryType.GetAllFromExportDomain, params);

and

          public GetAllFromExportDomainQuery(P parameters, EngineContext engineContext) {
                super(parameters, engineContext);
           }
