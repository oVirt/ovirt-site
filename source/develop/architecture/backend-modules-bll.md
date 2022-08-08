---
title: Backend modules BLL
category: architecture
authors: amuller
---

# Backend modules BLL

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
*   Command-specific validation - Every command can implement 'canDoAction'. For example 'AddNetworkCommand' checks that a storage pool exists, that the network does not already exist, and that the new network's prefix is valid - All checks that make sense for this specific command. In case one of those checks fails, we need to know why. We use a POJO called 'ValidationResult'. Error messages are keyed via 'VdcBllMessages', which is an enum contaning many error codes. Those error keys are translated via a file called AppErrors.properties.

**Error message replacements:** Replacements can be classified into two types: Static and dynamic. Most error messages start with the prefix Cannot ${ACTION} ${TYPE}. Action is the type of action the user is performing, and type is the entity we're working on such as host, virtual NIC or network. Action and type have pre-fabricated values that can be replaced via CommandBase's validate method. Dynamic replacements are error-specific and will usually be filled with values coming from the command's parameters.

**More on errors:** Important errors the user should know about are presented to the user via a popup. Those error messages are translated from an error key to the actual string in the client side. Alternatively, another mechanism exists called the Audit Log, which lets you output to a log that is visible in the GUI. The audit log is used to output informative messages, as well as warnings and errors. AuditLogMessage is a properties file that defines the translations from error codes to strings, and those translations are done on the server side. CommandBase inherits from AuditLogableBase, and many replacements keys/values are present there, for example: VdsName and UserName. Another way to add dynamic replacements used by Audit Log messages is AuditLogMessage.'AddCustomValue'. Finally you may add custom replacement keys/values via @CustomLogFields annotations. For example when implementing a specific command, you may use @CustomLogField at the top of the class, then implement a getter method of the same name that will return the value matching that key. To actually output to the audit log, you use AuditLogDirector.log, which accepts an AuditLogableBase contaning the replacement values, and AuditLogType which is the error key itself. The log method knows to format the final string (After replacements) to the audit log in the GUI.

**Audit Log Severities:** Normal - Successful commands, or other informative messages (For example: When the user logs in). Warning - Something bad happened but the command continued, or warnings show as low disk space on a host. Error - As discussed above Alert - Rendered outside of the audit log, in a special more central location as orange exclamation marks followed by the message. Power management messages use alerts.

**Transactionality:** CommandBase.execute first calls handleTransactivity. Each command can be forced to use an existing transaction, a new transaction or none at all, using the 'TransactionScopeOption' enum:

*   Suppress - No transaction
*   RequiresNew - Require a new transaction
*   Required - Require a transaction, may use an existing one

The enum value is passed with the commands' options. However, the command may use an annotation which overrides the transaction option passed in to the command. In any case, the 'handleTransactivity' method fills in a class field called scope. The scope value (Suppress, RequiresNew or Required) is passed on to the static method 'TransactionSupport.executeInScope'. The method accepts the scope value and the command to run, and runs the command's 'runInTransaction' method.

