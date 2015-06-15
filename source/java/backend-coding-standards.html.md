---
title: Backend Coding Standards
authors: abonas, gina, lhornyak
wiki_title: Backend Coding Standards
wiki_revision_count: 12
wiki_last_updated: 2015-05-20
---

# Backend Coding Standards

This page is a collection of coding standards in the ovirt engine backend. Not all of these standards are properly maintained, they are more like 'guidelines'

### Infra Bash Script coding guidelines

[Infra Bash style guide](Infra Bash style guide)

### Java code conventions

Java code style conventions and best practices should be applied in the project.

<http://www.oracle.com/technetwork/java/javase/documentation/codeconvtoc-136057.html>

Pay particular attention to standard [Java naming convention](http://www.oracle.com/technetwork/java/javase/documentation/codeconventions-135099.html#367)

### oVirt Engine/IDE

[Building oVirt Engine/IDE#Setting up oVirt engine development environment in Eclipse](Building oVirt Engine/IDE#Setting_up_oVirt_engine_development_environment_in_Eclipse)

### Vdsm coding guidelines

[Vdsm Coding Guidelines](Vdsm Coding Guidelines)

### RowMapper singletons

RowMappers should have a single instance e.g.

      private final static class FooRowMapper implements ParameterizedRowMapper`<Foo>` {
        public final static FooRowMapper instance = new FooRowMapper();
        public Foo mapRow(ResultSet rs, int rowNum) {
          //and so on...
        }
      }

So you do not have to instantiate the rowmapper all the time.

# To be cleared

### Logger

Seems like there is no clear agreement on how the loggers should be declared. What is known is that it should be the 'compat' logger.
