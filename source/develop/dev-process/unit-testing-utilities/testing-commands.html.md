---
title: Testing Commands
category: unit-testing-utilities
authors: amureini
---
# Testing Commands
Commands are the main entities in the BLL package, each command
representing a single logical action in the system.

## Injecting Dependencies
Most of the commands' external dependencies (such as DAOs, validators,
helpers, etc) are injected - i.e., they are annotated by `@Inject`, and
the CDI framework is in charge of initializing them. Luckily,
[Mockito](http://site.mockito.org/) suites testing such code very well,
and by annotating the class under test with `@InjectMocks`, Mockito's
framework will inject any field annotated with `@Mock` or `@Spy` to
that class.

It's worth noting that the BLL module overrides Mockito's default
answer, and any method returning a `ValidationResult` will return by
default `ValidationResult.VALID` and not `null` (unless explicitly
stubbed to return a different value, of course).
