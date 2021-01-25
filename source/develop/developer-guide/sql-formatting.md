---
title: formatting
authors: emesika
---

<!-- TODO: Content review -->

# SQL Formatting

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
      FROM t;

## AND/OR

Always in the beginning of line

      a > 1
      AND b<10

## Operators

Always surround operators with one space

      a + b = c

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

## Nested Conditions

Example 1

      SELECT DISTINCT vds.*
             FROM vds
             WHERE (
                     NOT v_is_filtered
                     OR EXISTS (
                         SELECT 1
                         FROM user_vds_permissions_view
                         WHERE user_id = v_user_id
                             AND entity_id = vds_id
                         )
                     );

Example 2

        WHILE FOUND LOOP v_id := CAST(v_tempId AS UUID);
                 SELECT count(*)
                 INTO v_result
                 FROM users
                 WHERE user_id IN (
                         SELECT ad_element_id AS user_id
                         FROM permissions,
                             roles
                         WHERE permissions.role_id = roles.id
                             AND ad_element_id IN (
                                 (
                                     SELECT ad_groups.id
                                     FROM ad_groups,
                                         engine_sessions
                                     WHERE engine_sessions.user_id = v_id
                                         AND ad_groups.id IN (
                                             SELECT *
                                             FROM fnsplitteruuid(engine_sessions.group_ids)
                                             )
                                     UNION
                                     SELECT v_id
                                     )
                                 )
                             AND (
                                 roles.role_type = 1
                                 OR permissions.role_id = '00000000-0000-0000-0000-000000000001'
                                 )
                         );
             UPDATE users
             SET last_admin_check_status = CASE
                     WHEN v_result = 0
                         THEN FALSE
                     ELSE TRUE
                     END
             WHERE user_id = v_id;
             FETCH myCursor
             INTO v_tempId;
         END LOOP;

Example 3

      IF EXISTS (
                 SELECT 1
                 FROM vm_device
                 WHERE vm_id = v_vm_id
                     AND type = 'balloon'
                     AND device = 'memballoon'
                 ) THEN result := true;
      END IF ;
