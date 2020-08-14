---
title: MockConfigRule
category: unit-testing-utilities
authors: amureini
---

# Mock Config Rule

`MockConfigRule` is JUnit `@Rule` that handles mocking of the Config
class. This removes the need of PowerMocking `Config`, and considerably
speeds up the test.

>**Note**:<br/>
> `MockConfigRule` supports JUnit 4 and JUnit 5 Legacy Engine. For JUnit
> Jupiter, use [MockConfigExtension](mockconfigextension.html) instead.

## Creating the Rule

Like with any Rule, the only thing you need to do in order to
incorporate it in your test class is to declare a public member
annotated with `@Rule` or a public static member annotated with
`@ClassRule`:

```java
@Rule
public final MockConfigRule mcr = new MockConfigRule();
```

## Mocking Different Config Values per Test

Now that you have the `MockConfigRule` defined, you can call the
`mockConfig` method to mock a configuration value. E.g.:

```java
public void testSomethingRegardingLDAP() {
   mcr.mockConfig(ConfigValues.LDAPSecurityAuthentication, ConfigCommon.defaultConfigurationVersion, "SIMPLE");
   // rest of the test the relies on the LDAPSecurityAuthentication configuraion.
}
```

>**Note**:<br/>
> If you omit the version parameter,
> `ConfigCommon.defaultConfigurationVersion` will be used by default:

```java
public void testSomethingRegardingLDAP() {
   mcr.mockConfig(ConfigValues.LDAPSecurityAuthentication, "SIMPLE");
   // rest of the test the relies on the LDAPSecurityAuthentication configuraion.
}
```

## Mocking The Same Config Values for the Entire Test Suite

The above approach is comfortable when each test requires a different
configuration, but sometimes, you'd like you entire test-suite to use
the same configurations. This can be done with a `@Before` annotation,
but that would be tedious and repetitive. `MockConfigRule` provides an
easier way to do this, in the `@Rule`'s construction time, using the
`mockConfig` static creator, e.g.:

```java
@ClassRule
public static final MockConfigRule mcr = new MockConfigRule(
    mockConfig(ConfigValues.LDAPSecurityAuthentication, "SIMPLE"),
    mockConfig(ConfigValues.SearchResultsLimit, 100),
    mockConfig(ConfigValues.AuthenticationMethod, "LDAP"),
    mockConfig(ConfigValues.DBEngine, "postgres")
);
```
