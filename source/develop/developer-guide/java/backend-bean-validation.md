---
title: Backend Bean Validation
authors: roy
---

# Backend Bean Validation How-to

Adding validation on beans used in the backend is easy and should be adopted by everyone.
Using the [jsr 303](http://beanvalidation.org/1.0/spec/) and its Jboss reference implementation [hibernate validator](http://docs.jboss.org/hibernate/stable/validator/reference/en-US/html_single/#d0e2704), the work is really clean and quick.

## Where is it used currently in

To validate the command inputs parameters classes i.e. all the descendants of **VdcActionParametersBase** and the beans they are composed from. The validation is fits into the execution before CanDoAction phase:

      Authorization check 
             |
              -> Backward Compatibility check
                           |
                            -> *Validate Inputs*
                                    |
                                     -> Can do action

## How to annotate my command inputs

### Basic Usage

lets look at existing validation of a hot plugging a disk to a VM. The command involved is ` HotPlugDiskToVM ` which uses ` HotPlugDiskToVmParameter ` and
we want to validate to target ` diskId ` will never be null.

the required constraint annotation is:

      public class HotPlugDiskToVmParameters extends VmDiskOperatinParameterBase {
         @NotNull
         private Guid diskId;

that's it. The rest is done by ` CommandBase.validateInputs() ` !

### complex hierarchy validation - @Valid

if you need to validate a member inside an object passed:

      class VmManagementParameterBase
      @Valid
      private VmStatic vmStatic

and in VmStatic class

      class VmStatic
      @Size(min = 1)
      private Name name;

### Control when to use a validation - Validation Groups

An annotated parameter class could be shared by one or more Commands thus the validation proposed by the annotation doesn't necessarily fit into all.

example: we need to validate storage_domain_static name when its passed in a parameter class
for adding storage or updating it. Other Commands that has it in their params should ignore those
validation constraints.

To achieve that we use Validation Groups. Its a marker interface passed to the validator and make it look only for validation marked with those interfaces.

1st annotate and specify a new marker interface in ` groups `

       class StorageDomainManagementParameter extends StorageDomainParametersBase {
         @Valid
         private storage_domain_static privateStorageDomain;
      ...
       @ValidName(message = "VALIDATION.STORAGE_DOMAIN.NAME.INVALID", groups = { CreateEntity.class, UpdateEntity.class })
       private String name = "";

The marker interface:

      import javax.validation.groups.Default;
      public interface CreateEntity extends Default { }
       

now state what validation groups your command needs by invoking addValidationGroups or overriding addValidationGroup method

      class CreateFooEntityCommand {
      public CreateFooEntityCommand() {
          addValidationGroup(CreateEntity.class);

or

      @Override
         protected List`<Class<?>`> getValidationGroups() {
             return addValidationGroup(CreateEntity.class);
         }

### Custom canDoMessages in validations

      @NotNull(message = "VALIDATION_NULL_VM_GUID"
      private Guid vmId

      AppErrors.properties:
      VALIDATION_NULL_VM_GUID=Null VM id is prohibited here.


## Further readings

Read on the [built-in constrains](http://docs.jboss.org/hibernate/stable/validator/reference/en-US/html_single/#validator-defineconstraints-builtin) you can use.

Read on how to [create your own custom constraints](http://docs.jboss.org/hibernate/stable/validator/reference/en-US/html_single/#validator-customconstraints)
