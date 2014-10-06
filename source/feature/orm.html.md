---
title: ORM
authors: liran.zelkha
wiki_title: Features/ORM
wiki_revision_count: 12
wiki_last_updated: 2014-10-07
---

# ORM

We plan to start a migration process of our current DAO access layer to a more standard, JPA based, DAO layer.

This process is triggered by several requirements:

1.  Numbered list item Performance issues.

Things like caching, connection life cycle, etc are provided by many JPA frameworks. We expect major performance improvements in oVirt Engine on account of this change

1.  Numbered list item Simplicity issues.

Multiple stored procedures, complex views, manually writing row-mapper classes - all can be avoided by using the JPA framework.

## Implementation process

We will start with the following:

1.  Patch to add Hibernate and persistence.xml to the environment
2.  Patch to move the Bookmark entity to JPA
3.  Patch to move the Providers entity to JPA
4.  Patch to move the Job entity to JPA
5.  Patch to move the VdsGroup entity to JPA

Other entities will be moved after that
