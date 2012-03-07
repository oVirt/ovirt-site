---
title: Backend Coding Standards
authors: abonas, gina, lhornyak
wiki_title: Backend Coding Standards
wiki_revision_count: 12
wiki_last_updated: 2015-05-20
---

# Backend Coding Standards

This page is a collection of coding standards in the ovirt engine backend. Not all of these standards are properly maintained, they are more like 'guidelines'

### private members should be at the bottom of the class

If you have private methods or embedded classes in your class (e.g. a rowmapper class in a DAO), then it should be at the bottom of the class. The idea here is that they are implementation details and viewers should read the public API first.

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
