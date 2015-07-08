---
title: formatting
authors: emesika
wiki_title: OVirt-DB-Issues/formatting
wiki_revision_count: 29
wiki_last_updated: 2015-11-16
---

# formatting

The following SQL formatting rules apply to code written as views/SP/upgrade scripts under the dbscripts folder:

Please note that each example demonstrates ONLY teh specific rule and not the entire formatting for simplicity.

## Indentation

All indentations should use 4 spaces no TABs are allowed

## Capitalization

Keyword: UPPER
 SELECT Data type: lower
 varchar(32) Table name : lower
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

       wrong:
         select 
         a
         ,b
         ,c 
         from T;
       right:
         select 
           a,
           b,
           c
         from T;

## AND/OR

Always in the end of line

       wrong:
        a > 1 
        and b < 10
       right: 
        a > 1 and
        b < 10

## Operators

Always surround operators with one space

       wrong:
        WHERE
            a+b=c
        rght:
        WHERE
            a + b = c

## Select Query

Column list : in a new line
column list style : stacked
INTO clause : in a new line
FROM clause : in a new line
FROM clause table list style : stacked
FROM clause join : join table in a new line , ON keyword on a new line
WHERE clause : condition in a new line
WHERE clause : AND/OR at end of line
GROUP BY clause : Column list in a new line
GROUP BY column list style : stacked
ORDER BY clause : Column list in a new line
ORDER BY column list style : stacked
