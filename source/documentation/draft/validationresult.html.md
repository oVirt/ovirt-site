---
title: ValidationResult
category: draft-documentation
authors: mkolesni
wiki_category: Draft documentation
wiki_title: ValidationResult
wiki_revision_count: 2
wiki_last_updated: 2013-03-17
---

# Validation Result

## What it is?

*   It's a container that is used to pass the result of some validation check performed in the "can do action".
*   The container can state if the result is valid or not, and if invalid it has a message of the error.
    -   Optionally it can also contain replacements of variables in the message.

## Some examples

### A valid result

      ValidationResult.VALID

*   isValid() returns true

### An invalid result

      new ValidationResult(VdcBllMessages.NETWORK_NOT_EXISTS)

*   isValid() returns false
*   getMessage() returns VdcBllMessages.NETWORK_NOT_EXISTS

### An invalid result containing a replacement

      new ValidationResult(VdcBllMessages.ACTION_TYPE_FAILED_MANAGEMENT_NETWORK_REQUIRED,
              String.format(NETWORK_NAME_REPLACEMENT, networkName))

*   isValid() returns false
*   getMessage() returns VdcBllMessages.ACTION_TYPE_FAILED_MANAGEMENT_NETWORK_REQUIRED
    -   The translation for it is:
    -   ACTION_TYPE_FAILED_MANAGEMENT_NETWORK_REQUIRED=Cannot ${action} ${type}. The management network '${NetworkName}' must be required, please change the network to be required and try again.
*   getVariableReplacements() returns "$NetworkName <networkName>" where <networkName> is the variable.
    -   We don't replace action/type since it's the command's responsibility and is done elsewhere.
    -   We do replace whatever the validation is responsible for (in this case, the network name).

## What is it good for?

*   This way we can write method to validate that is decoupled from the logic of returning the values to the caller.
    -   CommandBase has validate(ValidationResult) method which is responsible for this bit.
    -   Replacements are provided by validating method, no code spilled outside.
*   We can reuse the come more easily since it's decoupled from a specific command class.
*   The validation calls can be chained with &&/||

      validate(something()) && validate(somethingElse())

## How to test this?

*   Tests are really easy
*   You could test the result itself:

      // Test that validation result is valid
      assertEquals(ValidationResult.VALID, someValidation());
      // Test that validation result is invalid
      assertEquals(VdcBllMessages.SOME_ERROR, someValidation().getMessage());
      // Test that validation result is invalid and has replacement
      assertEquals(new ValidationResult(VdcBllMessages.SOME_ERROR, EXPECTED_REPLACEMENT), someValidation());

*   However, these tests aren't really good since they rely on implementation details, rather than the essence of the result itself.
    -   You could, of course, do more thorough testing, but then you'd have test code duplication.
*   This is why ValidationResultMatchers class was added, which allows testing using [JUnit's assertThat syntax](https://github.com/junit-team/junit/wiki/Matchers-and-assertthat):

      // Test that validation result is valid
      assertThat(someValidation(), isValid());
      // Test that validation result is invalid
      assertThat(someValidation(), failsWith(VdcBllMessages.SOME_ERROR));
      // Test that validation result is invalid and has replacement
      assertThat(someValidation(), both(failsWith(VdcBllMessages.SOME_ERROR)).and(replacements(hasItem(EXPECTED_REPLACEMENT))));

*   Although the syntax is a bit more verbose, these tests test the actual essence of the validation.
    -   Additionally, the matcher syntax is much more flexible.

[Category:Draft documentation](Category:Draft documentation) <Category:Engine> [Category:How to](Category:How to)
