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

**Validation:** Before actually executing the command, we must validate that the user can actually run the command. Validation is handled in many different aspects:

*   Authorization - Each command sets its own permissions required in order to run the command. 'isUserAuthorizedToRunAction' checks for the required permissions.
*   Input validation - oVirt uses the javax.validation.constraints framework in order to check the parameters passed into the command, using annotations in the different parameter classes. For example, @Size (min, max definitions), @Pattern (regex definitions), and so on. Each annotation also defines its own error key in case the validation fails on that field.
*   Locking - Many commands have the potential to be ran in parallel, mostly through automated scripts using the REST API. A lock is initially obtained and then freed either when validation fails (Before the execution stage begins), or if validation succeeds after execution finishes.
*   Command-specific validation - Every command can implement 'canDoAction'. For example 'AddNetworkCommand' checks that a storage pool exists, that the network does not already exist, and that the new network's prefix is valid - All checks that make sense for this specific command. In case one of those checks fails, we need to know why. We use a POJO called 'ValidationResult'. Error messages are implemented via 'VdcBllMessages', which is an enum contaning many enum value error codes. Those error keys are translated via a file called AppErrors.properties.

**Error message replacements:** Replacements can be classified into two types: Static and dynamic. Most error messages start with the prefix Cannot ${ACTION} ${TYPE}. Action is the type of action the user is performing, and type is the entity we're working on such as host, virtual NIC or network. Action and type have pre-fabricated values that can be replaced via CommandBase's validate method. Dynamic replacements are error-specific and will usually be filled with values coming from the command's parameters.

**Transactionality:** CommandBase.execute first calls handleTransactivity. Each command can be forced to use an existing transaction, a new transaction or none at all, using the 'TransactionScopeOption' enum:

*   Suppress - No transaction
*   RequiresNew - Require a new transaction
*   Required - Require a transaction, may use an existing one

The enum value is passed with the commands' options. However, the command may use an annotation which overrides the transaction option passed in to the command. In any case, the 'handleTransactivity' method fills in a class field called scope. The scope value (Suppress, RequiresNew or Required) is passed on to the static method 'TransactionSupport.executeInScope'. The method accepts the scope value and the command to run, and runs the command's 'runInTransaction' method.

<Category:Architecture>
