---
title: MockConfigExtension
category: unit-testing-utilities
authors: amureini
---

# Mock Config Extension

`MockConfigExtension` is JUnit Jupier extension that handles mocking of
the Config class. It replaces the [MockConfigRule](mockconfigrule.html)
that was used for previous JUnit versions.

## Creating the extension

Like with any extension, the only thing you need to do in order to
incorporate it in your test class is to add an `@ExtendWith`
annotation.

```java
@ExtendWith(MockConfigExtension.class)
public class MyTest {
    // Code ...
```

## Basic mocking

For the basic usecase, where all the tests in the class use the same
mocked configuration, just create a method with the signature
`public static Stream<MockConfigDescriptor<?>> mockConfiguration()`.
E.g.:

```java
public static Stream<MockConfigDescriptor<?>> mockConfiguration() {
    return Stream.of(
        // "general" version
        MockConfigDescriptor.of(ConfigValues.UserSessionTimeOutInterval, 30),

        // Specific 4.2 config value
        MockConfigDescriptor.of(ConfigValues.PassDiscardSupported, Version.v4_2, true)
    );
}
```

## Mocking different config values per test

Sometimes, different methods will need different config values. This
can be achieved by creating different methods (with a similar
signature) to supply the mocked config values, and annotating the test
with the `@MockedConfig` annotation to specify that it should use the
aforementioned method. E.g.:

```java
public static Stream<MockConfigDescriptor<?>> mockSpecialConfiguration() {
    return Stream.of(MockConfigDescriptor.of(ConfigValues.UserSessionTimeOutInterval, 60));
}

@Test
@MockedConfig("mockSpecialConfiguration")
public void specialTest() {
    // Code
}
```
