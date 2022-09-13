---
title: Backend modules DAL
category: architecture
authors: amuller
---

# Backend modules DAL

**Introduction:** The dal module, or Data Access Layer, provides access to the PostgreSQL database used by the engine. This module uses several concepts:

POJO - Plain Old Java Object - A class with no logic, only data fields with accessors. Commonly known as structs or records in other languages, and Entity in storage jargon. DAO - Data Access Object - A gateway between a POJO/Entity and its representation in persistent storage. A DAO provides an abstraction over which type of persistent storage is used to store the given POJO. Ideally, each POJO would have its own DAO, however in the oVirt codebase that is not necessarily the case. Entities/POJOs include VMs, hosts, networks and so on. Basically, any entity in the codebase that is to be serialized to persistent storage uses its DAO.

**Significant DAOs:**

*   DAO itself is an empty interface
*   ReadDAO - An interface that defines the R (Read) part of CRUD: get by ID, and getAll (Get all rows of type T)
*   ModificationsDAO - An interface that defines the other parts of CRUD: save defines Create, update defines Update and remove defines Delete.

Both ReadDAO and ModificationsDAO are generic interfaces defined by two generics: T must extent BusinessEntity, and ID is serializable. The implication is that DAOs that are of Read or Modifications flavors need to work with Entities that implement BusinessEntity. BusinessEntity is simply an interface that encapsulates an entity with an ID.

*   GenericDAO - An interface for DAOs that are both Read and Modifications, or CRUD complete. Most DAOs implement this interface. As the name suggests it is a generic interface like ReadDAO and ModificationsDAO.

**Spring and JDBC:** The dal module uses the popular [Spring](http://www.springsource.org/) library for its JDBC (Java Database Connectivity) wrapper to talk to the PostgreSQL database.

