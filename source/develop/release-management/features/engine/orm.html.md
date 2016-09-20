---
title: ORM
authors: liran.zelkha
wiki_title: Features/ORM
wiki_revision_count: 12
wiki_last_updated: 2014-10-07
---

# ORM

## Summary

We plan to start a migration process of our current DAO access layer to a more standard, JPA based, DAO layer.

## Owner

*   Name: Liran Zelkha

## Current Status

Implementation

## Implementation Process

We will start with the following:

1.  Patch to add Hibernate and persistence.xml to the environment. See <http://gerrit.ovirt.org/#/c/33832/> <http://gerrit.ovirt.org/#/c/33835/>
2.  Patch to move the Bookmark entity to JPA. See <http://gerrit.ovirt.org/#/c/33836/>
3.  Patch to move the Providers entity to JPA
4.  Patch to move the Job entity to JPA
5.  Patch to move the VdsGroup entity to JPA

Other entities will be moved after that

### Implementing DAOs

The DAO class will be implemented the following way:

      @Entity
      @Table(name = "bookmarks")
      public class Bookmark extends IVdcQueryable implements Serializable {
          private static final long serialVersionUID = 8177640907822845847L;

          @Id
          @Column(name = "bookmark_id")
          @Type(type = "org.ovirt.engine.core.dao.GuidMapper")
          private Guid id;

          @Column(name = "bookmark_name")
          private String name;

The Dao facades will need to be implemented in the following way:

      public class BookmarkDAODbFacadeImpl extends HibernateFacade<Bookmark, Guid> implements BookmarkDAO {
          @Override
          public List<Bookmark> getAll() {
              return super.multiResults(getEntityManager().createQuery("select b from Bookmark b"));

The HibernateFacade class provides common actions, like add, remove, update, get and many more. Queries will be written using JPAQL.

### Writing unit tests

Unit tests need to implement BaseHibernateDAOTestCase. Other than that, unit test should behave the same way.

## Benefit to oVirt

*   Performance issues. Things like caching, connection life cycle, etc are provided by many JPA frameworks. We expect major performance improvements in oVirt Engine on account of this change. For instance, check bugs - <https://bugzilla.redhat.com/show_bug.cgi?id=1058824> or <https://bugzilla.redhat.com/show_bug.cgi?id=1141543>
*   Simplicity issues. Multiple stored procedures, complex views, manually writing row-mapper classes - all can be avoided by using the JPA framework.

## Dependencies / Related Features

N/A

## Documentation / External References

1.  Hibernate homepage: <http://hibernate.org/>
2.  JPA homepage: <http://www.oracle.com/technetwork/java/javaee/tech/persistence-jsp-140049.html>

## Comments and Discussion

