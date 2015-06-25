---
title: formatting
authors: emesika
wiki_title: OVirt-DB-Issues/formatting
wiki_revision_count: 29
wiki_last_updated: 2015-11-16
---

# formatting

The following SQL formatting rules apply to code written as views/SP/upgrade scripts under the dbscripts folder:

## Indentation

All indentations should use 4 spaces

## Capitalization

Keyword: UPPER
Data type: lower
Table name : lower
Column name : lower
Function name : InitCap for SP, lower for general functions that also must start with fn_db_
Column alias: lower
Variable : lower, starts with v_
Constraint: lower

## Comma option

Always after item

## AND/OR

Always in the end of line

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
