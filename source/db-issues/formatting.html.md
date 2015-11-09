---
title: formatting
authors: emesika
wiki_title: OVirt-DB-Issues/formatting
wiki_revision_count: 29
wiki_last_updated: 2015-11-16
---

# formatting

The following SQL formatting rules apply to code written as views/SP/upgrade scripts under the dbscripts folder:

Please note that each example demonstrates ONLY the specific rule and not the entire formatting for simplicity.

## Indentation

All indentations should use 4 spaces no TABs are allowed

## Capitalization

Keyword: UPPER
 SELECT Data type: UPPER
 VARCHAR(32) Table name : lower
 users Column name : lower
 user_name Function name : InitCap for SP, lower for general functions that also must start with fn_db_
 InsertAuditLog

       fn_db_add_column

Column alias: lower
 dept AS department Variable : lower, starts with v_
 v_user Constraint: lower

       fk_user_user_sessions

## Comma option

Always after item

      SELECT
      a,
      b,
      c
      FROM t;

## AND/OR

Always in the beginning of line

      a > 1
      AND b<10

## Operators

Always surround operators with one space

      a + b = c

## Select Query

Column list style : stacked
 INSERT INTO T (name,
 size)
VALUES('a',
 1);

FROM clause : in a new line
 SELECT \*
FROM T FROM clause table list style : stacked
 SELECT \*
 FROM a,
 b FROM clause join : join table in a new line
 SELECT a.\*
FROM a
INNER JOIN b ON a.id = b.id WHERE clause : condition in a new line
 SELECT \*
FROM t
WHERE a = 1; WHERE clause : AND/OR at beginning of line
 SELECT \*
FROM t
WHERE a = 1
AND b='x'; GROUP BY clause : Column list in a new line
 SELECT \*
FROM t
WHERE a = 1
GROUP BY b; GROUP BY column list style : stacked
 SELECT \*
FROM t
WHERE a = 1
GROUP BY b,
 c; ORDER BY clause : Column list in a new line
 SELECT \*
FROM t
WHERE a = 1
ORDER BY b; ORDER BY column list style : stacked
 SELECT \*
FROM t
WHERE a = 1
ORDER BY b,
 c;

Nested conditions
