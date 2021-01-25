---
title: Searchbackend
authors: lhornyak, ykaul
---

# Search backend

Search backend is part of the ovirt engine backend, it translates search queries to SQL, runs them against the database and returns the result.

## Query syntax

Some example query:

*   Events : event_host = dev-164
*   Users : name = admin
*   Vms : ip = 127.0.0.1

## Autocompleters

Autocompleters help the users to build a query, the logic is built into searchbackend. See org.ovirt.engine.core.searchbackend.IAutoCompleter interface and implementing classes.

## Generated SQL

The generated SQL would need some optimization.

The problems in general:

*   The operator \`=\` is interpreted as like, which is fine with string results, but no good with identifiers
*   The search query is wrapped with an outer query and mapped with id, so the primary key will be scanned even if it is not used in the result and not filtered

      engine=# explain SELECT * FROM (SELECT * FROM audit_log WHERE ( audit_log_id IN (SELECT audit_log.audit_log_id FROM  audit_log   WHERE  audit_log.vds_id::varchar LIKE '78933a44-360c-11e1-8fec-2f707af25b44' ))  ORDER BY audit_log_id DESC ) as T1 OFFSET (1 -1) LIMIT 100;
                                                            QUERY PLAN                                                        
      -------------------------------------------------------------------------------------------------------------------------
      Limit  (cost=`**`592.60..593.13`**` rows=42 width=3163)
        ->  Sort  (cost=592.60..592.71 rows=42 width=826)
              Sort Key: public.audit_log.audit_log_id
              ->  Nested Loop  (cost=335.25..591.47 rows=42 width=826)
                    ->  HashAggregate  (cost=335.25..335.67 rows=42 width=8)
                          ->  Seq Scan on audit_log  (cost=0.00..335.14 rows=42 width=8)
                                Filter: (((vds_id)::character varying)::text ~~ '78933a44-360c-11e1-8fec-2f707af25b44'::text)
                    ->  Index Scan using pk_audit_log on audit_log  (cost=0.00..6.08 rows=1 width=826)
                          Index Cond: (public.audit_log.audit_log_id = public.audit_log.audit_log_id)

(9 rows)

The first problem is that LIKE can not use indices. In this query, we could just use =.

      engine=# EXPLAIN SELECT * FROM (SELECT * FROM audit_log WHERE ( audit_log_id IN (SELECT audit_log.audit_log_id  FROM  audit_log   WHERE  audit_log.vds_id = '78933a44-360c-11e1-8fec-2f707af25b44' ))  ORDER BY audit_log_id DESC ) as T1 OFFSET (1 -1) LIMIT 100;                                            QUERY  PLAN                                            
      --------------------------------------------------------------------------------------------------
      Limit  (cost=`**`499.25..499.64`**` rows=31 width=3163)
        ->  Sort  (cost=499.25..499.33 rows=31 width=826)
              Sort Key: public.audit_log.audit_log_id
              ->  Nested Loop  (cost=293.46..498.49 rows=31 width=826)
                    ->  HashAggregate  (cost=293.46..293.77 rows=31 width=8)
                          ->  Seq Scan on audit_log  (cost=0.00..293.39 rows=31 width=8)
                                Filter: (vds_id = '78933a44-360c-11e1-8fec-2f707af25b44'::uuid)
                    ->  Index Scan using pk_audit_log on audit_log  (cost=0.00..6.59 rows=1 width=826)
                          Index Cond: (public.audit_log.audit_log_id = public.audit_log.audit_log_id)

As a result of this simplification, the estimated query cost dropped from ~600 to ~500. Now let's introduce an index to support the query

      engine=# CREATE INDEX idx_audit_log_vds_id on audit_log(vds_id);CREATE INDEX
      engine=# EXPLAIN SELECT * FROM (SELECT * FROM audit_log WHERE (audit_log_id IN (SELECT audit_log.audit_log_id  FROM  audit_log   WHERE  audit_log.vds_id = '78933a44-360c-11e1-8fec-2f707af25b44' ))  ORDER BY audit_log_id DESC ) as T1 OFFSET (1 -1) LIMIT 100;
                                                      QUERY PLAN                                                 
      ------------------------------------------------------------------------------------------------------------
      Limit  (cost=`**`292.67..293.05`**` rows=31 width=3163)
        ->  Sort  (cost=292.67..292.74 rows=31 width=826)
              Sort Key: public.audit_log.audit_log_id
              ->  Nested Loop  (cost=86.88..291.90 rows=31 width=826)
                    ->  HashAggregate  (cost=86.88..87.19 rows=31 width=8)
                          ->  Bitmap Heap Scan on audit_log  (cost=4.49..86.80 rows=31 width=8)
                                Recheck Cond: (vds_id = '78933a44-360c-11e1-8fec-2f707af25b44'::uuid)
                                ->  Bitmap Index Scan on idx_audit_log_vds_id  (cost=0.00..4.48 rows=31 width=0)
                                      Index Cond: (vds_id = '78933a44-360c-11e1-8fec-2f707af25b44'::uuid)
                    ->  Index Scan using pk_audit_log on audit_log  (cost=0.00..6.59 rows=1 width=826)
                          Index Cond: (public.audit_log.audit_log_id = public.audit_log.audit_log_id)

(11 rows)

Note that the estimated cost dropped because it can check a relevant index. Now let's simplify the SQL statement to avoid index-scanning pk_audit_log, by removing the redundant outer query.

      engine=# EXPLAIN SELECT * FROM audit_log   WHERE  audit_log.vds_id = '78933a44-360c-11e1-8fec-2f707af25b44'  ORDER BY audit_log_id DESC OFFSET 0 LIMIT 100;
                                                QUERY PLAN                                           
      ------------------------------------------------------------------------------------------------
      Limit  (cost=`**`87.57..87.65`**` rows=31 width=826)
        ->  Sort  (cost=87.57..87.65 rows=31 width=826)
              Sort Key: audit_log_id
              ->  Bitmap Heap Scan on audit_log  (cost=4.49..86.80 rows=31 width=826)
                    Recheck Cond: (vds_id = '78933a44-360c-11e1-8fec-2f707af25b44'::uuid)
                    ->  Bitmap Index Scan on idx_audit_log_vds_id  (cost=0.00..4.48 rows=31 width=0)
                          Index Cond: (vds_id = '78933a44-360c-11e1-8fec-2f707af25b44'::uuid)

(7 rows)

This refactoring dropped query cost estimation from ~500 to less than 100, therefore this simplification in the searchbackend could give results faster and generate less load on the database server.
