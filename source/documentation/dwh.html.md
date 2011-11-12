---
title: Ovirt DWH
category: documentation
authors: quaid, sradco, yaniv dary
wiki_category: Documentation
wiki_title: Ovirt DWH
wiki_revision_count: 5
wiki_last_updated: 2015-01-14
---

# Ovirt DWH

A historic database that allows users to create reports over a static API using business intelligence suites that enable you to monitor the system. This package contains the ETL (**E**xtract **T**ransform **L**oad) process created using Talend Open Studio and DB scripts to create a working history DB.

## oVirt Engine DWH Views

The engine API for the ETL that Creates a more user friendly interface of the engine tables and gaps the differences between the engine to the history database tables. It is the first stage in data transformation

## DB Tables and API Views Information

*   Sample data is collected at the end of every minute and is kept for up to 48 hours.
*   Hourly level is aggregated every hour for the hour before last and is kept for 2 months.
*   Daily level is aggregated every day for the day before last and is kept for 5 years.
*   Upgrade is done via reentrent PL/pgSQL files.

<Category:Documentation> <Category:DWH>
