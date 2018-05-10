---
title: InjectorExtension
category: unit-testing-utilities
authors: amureini
---

# Injector Extension

`InjectorExtension` is JUnit Jupiter extension that allows binding 
mock objects to the `Injector`.
It's the JUnit Jupiter counterpart of the old InjectorRule.

## Creating the extension

Like with any extension, the only thing you need to do in order to
incorporate it in your test class is to add an `@ExtendWith` annotation.

In order to bind a mock, simply annotate the mocked object with an
@InjectedMock annotation:

```java
@ExtendWith(InjectorExtension.class)
public class MyTest{
    @Mock
    @InjectedMock
    public OsRepository osRepository;
```

[Category:Unit Testing Utilities](/develop/dev-process/unit-testing-utilities/)
