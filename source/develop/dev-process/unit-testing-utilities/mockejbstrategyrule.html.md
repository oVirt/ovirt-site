---
title: MockEJBStrategyRule
category: unit-testing-utilities
authors: amureini
wiki_category: Unit Testing Utilities
wiki_title: MockEJBStrategyRule
wiki_revision_count: 1
wiki_last_updated: 2012-11-25
---

# Mock EJB Strategy Rule

`MockEJBStrategyRule` is JUnit `@Rule` that handles mocking of the beans and resources managed by the EjbUtils class. Specifically, it seamlessly handles mocking transaction management, which is a common usecase in many bll tests.

## Creating the Rule

Like with any `@Rule`, the only thing you need to do in order to incorporate it in your test class is to declare a public member annotated with `@Rule`:

    @Rule
    public MockEJBStrategyRule ejbRule = new MockEJBStrategyRule();

This declaration will mock EjbUtils' internal strategy, and handle mocking away transaction management.

## Mocking Additional Beans

Transaction management is fine and well, but sometimes our tests will require additional behaviour defined for other beans. This can be achieved by passing a map from `BeanType` to the implementing mock. A simplified, single-line constructor, is also available for mocking an additional single bean

    @Rule
    public MockEJBStrategyRule ejbRule = new MockEJBStrategyRule(BeanType.SCHEDULER, mySchedulerMock);

[Category:Unit Testing Utilities](Category:Unit Testing Utilities)
