---
title: psql
authors: emesika
---

# psql

Help

       \h
       \?

Editor

       \e 

Format

       \x 

History

       \set HISTFILE ~/.psql_history- :HOST - :DBNAME  (history file per host/db)
       \set HISTSIZE 2000
       CTRL + r

Cost

       \timing

Run script

       \i [script name]

# pgadminIII

A UI tool over psql

# How do I know if my query is efficient ?

## Analyse

ANALYZE collects statistics about the contents of tables in the database, and stores the results in the pg_statistic system catalog. Subsequently, the query planner uses these statistics to help determine the most efficient execution plans for queries.

With no parameter, ANALYZE examines every table in the current database. With a parameter, ANALYZE examines only that table. It is further possible to give a list of column names, in which case only the statistics for those columns are collected.

       ANALYZE [ VERBOSE ] [ table [ ( column [, ...] ) ] ]

## Explain

This command displays the execution plan that the PostgreSQL planner generates for the supplied statement. The execution plan shows how the table(s) referenced by the statement will be scanned — by plain sequential scan, index scan, etc. — and if multiple tables are referenced, what join algorithms will be used to bring together the required rows from each input table.

The most critical part of the display is the estimated statement execution cost, which is the planner's guess at how long it will take to run the statement (measured in units of disk page fetches). Actually two numbers are shown: the start-up time before the first row can be returned, and the total time to return all the rows. For most queries the total time is what matters, but in contexts such as a subquery in EXISTS, the planner will choose the smallest start-up time instead of the smallest total time (since the executor will stop after getting one row, anyway). Also, if you limit the number of rows to return with a LIMIT clause, the planner makes an appropriate interpolation between the endpoint costs to estimate which plan is really the cheapest.

The ANALYZE option causes the statement to be actually executed, not only planned. The total elapsed time expended within each plan node (in milliseconds) and total number of rows it actually returned are added to the display. This is useful for seeing whether the planner's estimates are close to reality.

       EXPLAIN [ ( option [, ...] ) ] statement
       where option can be one of:
        ANALYZE [ boolean ]
        VERBOSE [ boolean ]
        COSTS [ boolean ]
        BUFFERS [ boolean ]
        FORMAT { TEXT | XML | JSON | YAML }

see also
[Using EXPLAIN](http://www.postgresql.org/docs/9.0/static/using-explain.htm)
[Online EXPLAIN](http://explain.depesz.com/)
