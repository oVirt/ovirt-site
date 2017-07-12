---
title: Testing Queries
category: unit-testing-utilities
authors: amureini
---

# Testing Queries

Queries are the main way for extracting data from the oVirt Engine for clients palced outside it. As such, they are a critical part of the engine, and should be thoroughly tested. This page discusses the base classes provided in oVirt Engine's testing framework which help facilitate these tests.

## AbstractQueryTest

This is the base class for testing any query. It provides several mocked and spied objects and is in charge of setting up the query instance for your tests. Note that it's implementation uses reflection based on the generics parameters given to your class, so it is important to pass them accurately.

### Declaring A Test Class

To use it, simply declare your test class as follows:

    public class MyQueryTest extends AbstractQueryTest<MyParamters, MyQuery<MyParamters>> {
     ...
    }

### Utility Methods

Extenting this class will provide you with several utility methods to use in your tests:

1.  `getQuery()` - returns the query to use in the test, with a mocked up user
2.  `getQueryParameters()` - return **a mock** parameter object the query was constructed with. You can add additional behavior to it using `when(...).thenRerurn(...)` statements.
3.  `getDbFacadeMockInstance()` - returns a mocked instance of `DbFacade`. You can add additional behavior to it (e.g., adding mocks for specific DAOs) using `when(...).thenRerurn(...)` statements.

### Built-in Tests

1.  `testQueryType()` - asserts you didn't forget to add your query to `VdcQueryType`. Note this test is run from the base class, and does not need to be called explicitly.

## AbstractUserQueryTest

`AbstractUserQueryTest` is an extention of `AbstractQueryTest` designed to cater to user queries, which adds some additional functionality to the base class.

### Utility Methods

1.  `getUser()` - returns the mocked user running the query

### Built-in Tests

1.  `testQueryIsAUserQuery()` - tests your query was indeed marked as a user query. Note this test is run from the base class, and does not need to be called explicitly.

[Category:Unit Testing Utilities](/develop/dev-process/unit-testing-utilities/)
