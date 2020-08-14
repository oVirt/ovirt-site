---
title: RandomUtilsSeedingRule
category: unit-testing-utilities
authors: amureini
---

# Random Utils Seeding Rule

`RandomUtilsSeedingRule` is JUnit `@Rule` that allows better control of `RandomUtils`' random see in unit test environments.

>**Note**:<br/>
> `RandomUtilsSeedingRule` supports JUnit 4 and JUnit 5 Legacy Engine. For JUnit
> Jupiter, use [RandomUtilsSeedingExtension](mockconfigextension.html) instead.

## Creating the Rule

Like with any `@Rule`, the only thing you need to do in order to incorporate it in your test class is to declare a public member annotated with `@Rule`:

```java
@Rule
public RandomUtilsSeedingRule rusr = new RandomUtilsSeedingRule();
```

## Logging the Random Seed

Now that you have the `RandomUtilsSeedingRule` defined, your test will automagically log the random seed it uses, e.g.:

    11:02:24,643 INFO  [RandomUtilsSeedingRule] Property "test.random.seed" was not set, using System.currentTimeMillis() as a seed.
    11:02:24,644 INFO  [RandomUtilsSeedingRule] Running test with random seed: 1337155344644

Note that this is done using oVirt's standard LogFactory and Log, so make sure you configure the logging in your project.

## Injecting a Random Seed

Once you have a failed test due to a specific random input, you would probably want to reproduce it. This can be done by specifying the environment variable `test.random.seed`.

You can make sure the injection worked properly by examining the log. If, for example, you set `test.random.seed=123`, your output should look like this:

    11:11:53,159 INFO  [RandomUtilsSeedingRule] Running test with random seed: 123
