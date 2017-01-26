---
title: Clients
category: architecture
authors: amuller
wiki_category: Architecture
wiki_title: Clients
wiki_revision_count: 1
wiki_last_updated: 2013-02-12
---

# Clients

There are three clients that access the engine backend. The user portal, admin portal and the REST API. All three clients access the backend through the [Bll](/documentation/architecture/backend-modules-bll/) (Business logic unit) module's Backend class. Backend is a singleton, Enterprise Java Bean, and makes use of annotations. The main entry points into the class (and thus the backend itself) are the methods RunAction, EndAction and RunQuery. The goal in the long run is to make the REST API the only client of the Backend class, and the user and admin portals access the backend through the REST API, to create a situation where only one formal client exists.

[Category: Architecture](Category: Architecture)
