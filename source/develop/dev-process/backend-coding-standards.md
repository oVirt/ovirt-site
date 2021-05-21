---
title: Backend Coding Standards
authors:
  - abonas
  - lhornyak
---

<!-- TODO: Content review -->

# Backend Coding Standards

This page is a collection of coding standards in the ovirt engine backend. Not all of these standards are properly maintained, they are more like 'guidelines'

## Java code conventions

Java code style conventions and best practices should be applied in the project.

<http://www.oracle.com/technetwork/java/javase/documentation/codeconvtoc-136057.html>

## RowMapper singletons

RowMappers should have a single instance e.g.

      private final static class FooRowMapper implements ParameterizedRowMapper`<Foo>` {
        public final static FooRowMapper instance = new FooRowMapper();
        public Foo mapRow(ResultSet rs, int rowNum) {
          //and so on...
        }
      }

So you do not have to instantiate the rowmapper all the time.
