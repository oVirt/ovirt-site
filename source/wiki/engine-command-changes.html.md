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

Same goes for runMultipleActions
 For example:

Hi all, Thanks to the help of Alon, oved, Tal, Moti, Arik and others, the following changes were introduced:

1. Internal commands invocation -

When invoking an internal command from a command, please use the following :

Instead of Backend.getInstance().runInternalAction... Same goes for runMultipleActions. For examp

This method has two variants - one that accepts command context, and the other that does not have a command contet -

runInternalAction(VdcActionType,VdcActionParametersBase,CommandContext)

and

runInternalAction(VdcActionType,VdcActionParametersBase)

If CommandContext is not passed the context at the calling command will be cloned and set at the child command.

If a Command context is pased - it should be the responsibility of the caller to clone, however, this will give the caller some degree of freedom to determine whether various parts of the context will be cloned, or not.

Examples:

runInternalAction(VdcActionType.AddPermission, permissionParams) has the same effect as : runInternlAction(VdcActionType.AddPermissiosn, permissionParams, getContext().clone())

runInternlAction(VdcActionType.AddPermissiosn, permissionParams, getContext().clone().withoutCompensationContext()) - will cause the compensation context to be reset, and let the child command determine the value of compensation context (at handleTransactivity method).

The complete list of "context alteration methods" are -

withCompensationContext(CompensationContext) , withoutCompensationContext() withLock(EngineLock), withoutLock() withExecutionContext(ExecutionContext), withoutExecutionContext() - bare in mind that all these follow the chaining method "design pattern" [1] (I would like to thank Moti for the naming suggestions)

two methods for running InternalAction with context for tasks were created:

runInternalActionWithTasksContext(VdcActionType, VdcActionParametersBase)

runInternalActionWithTasksContext(VdcActionType, VdcActionParametersBase, EngineLock)

These methods use ExecutionHandler.createDefaultContextForTasks to create the relevant command context to be passed to the child command.

runInternalMultipleActions was introduced to command base in a similar manner, with 3 versions:

runInternalMultipleActions(VdcActionType, ArrayList<VdcActionParametersBase>)

runInternalMultipleActions(VdcActionType, ArrayList<VdcActionParametersBase>, ExecutionContext)

runInternalMultipleActions(VdcActionType, ArrayList<VdcActionParametersBase>, CommandContext)

2. Queries invocation -

runInternalQuery(VdcQueryType, VdcQueryParametersBase) was introduced to command base.

Basically it takes the engine context from the current command context, and runs the internal query with it.

EngineContext is the context which should hold all the common attributes to our flows at engine - currently it holds the engineSessionId, working towards moving correlationId to it as well.

3. Commands & Queries coding

Each internal query should have a ctor that takes the parameters, and also the engine context . As some of the queries are both internal and non internal you may have two ctors - one with parameters only, one with parameters and EngineContext

for example

public class GetUnregisteredDiskQuery

extends QueriesCommandBase

{

         public GetUnregisteredDiskQuery(P parameters) {
             this(parameters, null);
         }

         public GetUnregisteredDiskQuery(P parameters, EngineContext context) {
             super(parameters, context);
         }

Notice that the ctor without the context calls the one with the context.

Same happens at Commands:

        public RemovePermissionCommand(T parameters) {
             this(parameters, null);
         }

         public RemovePermissionCommand(T parameters, CommandContext commandContext) {
             super(parameters, commandContext);
         }

4. runVdsCommand was introduced to CommandBase as well

runVdsCommand(VDSCommandType, VdsCommandParameters) - currently this just runs the vds command on vds broker, working on propagating the engine context via vds broker as well.

Please use the above in your code. If you see any issues , or places where its problematic to use, feel free to contact me.

[1] <http://en.wikipedia.org/wiki/Method_chaining>
