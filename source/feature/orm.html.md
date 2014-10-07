---
title: ORM
authors: liran.zelkha
wiki_title: Features/ORM
wiki_revision_count: 12
wiki_last_updated: 2014-10-07
---

# ORM

### Summary

We plan to start a migration process of our current DAO access layer to a more standard, JPA based, DAO layer.

### Owner

*   Name: Liran Zelkha

### Current Status

Implementation

### Detailed Description

#### Use Cases

### Benefit to oVirt

*   Performance issues. Things like caching, connection life cycle, etc are provided by many JPA frameworks. We expect major performance improvements in oVirt Engine on account of this change
*   Simplicity issues. Multiple stored procedures, complex views, manually writing row-mapper classes - all can be avoided by using the JPA framework.

### Dependencies / Related Features

N/A

### Documentation / External References

1.  Hibernate homepage: <http://hibernate.org/>
2.  JPA homepage: <http://www.oracle.com/technetwork/java/javaee/tech/persistence-jsp-140049.html>

### Comments and Discussion

*   Refer to [Talk:Foreman Integration](Talk:Foreman Integration)

# Implementation process

We will start with the following:

1.  Patch to add Hibernate and persistence.xml to the environment. See <http://gerrit.ovirt.org/#/c/33832/> <http://gerrit.ovirt.org/#/c/33835/>
2.  Patch to move the Bookmark entity to JPA. See <http://gerrit.ovirt.org/#/c/33836/>
3.  Patch to move the Providers entity to JPA
4.  Patch to move the Job entity to JPA
5.  Patch to move the VdsGroup entity to JPA

Other entities will be moved after that
