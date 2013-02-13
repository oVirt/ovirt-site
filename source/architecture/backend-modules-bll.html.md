---
title: Backend modules bll
category: architecture
authors: amuller
wiki_category: Architecture
wiki_title: Backend modules bll
wiki_revision_count: 4
wiki_last_updated: 2013-02-14
---

# Backend modules bll

**Introduction:** The bll (Business Logic Layer) encapsulates the different actions and queries the user can apply, and implements the actual logic required to run said commands. In the bll, every action has a value in the VdcActionType enum. The naming convention is of importance - \*Command. For example: RunVMCommand, SetupNetworkCommand, and so on. Each enum value has a corresponding class, and that class is instantiated by a factory via reflection. Similarly, queries have \*Query enum values in the VdcQueryType enum, and each enum value has a corresponding class. For each command or query there is the appropriate POJO that represents the commands' parameters. Some parameter structs are shared between different commands.

**Backend.RunAction:** This is the main entry point for the Bll bean. RunAction uses CommandsFactory.CreateCommand receives an enum value and command parameters and instantiates the appropriate command. The command is then actually ran via command.executeAction(), which first runs the base class of all commands: CommandBase's executeAction initial implementation. CommandBase.executeAction first checks for command-wide validations, and then runs the derived command implementation. In the validations stage, the field 'returnValue' is filled, including its subfields 'canDoAction' and 'errorMessage'. A command acts very similarly to a function and thus its 'returnValue' field acts as a metaphor for an actual return value of a function. If the validation was successful, the execution stage begins, which fills 'succeeded' and 'exceptions'.

**Backend.runInternalMultipleActions:** When the user runs many commands at once (For example, removing 5 VMs from a host at the same time), Backend uses the 'MultipleActionsRunner' class. Its Execute method runs the validations of all commands asynchronously and at the same time and then waits on all the validation threads. Once all validations have completed, one of two options may happen: Either the action group is configured so that all validations must pass to apply all commands, or every command that passes validation is executed on a per-command basis.

**Significant command methods:**

1.  canDoAction - Extra command-specific validation
2.  executeCommand - The actual code to be executed

<Category:Architecture>
