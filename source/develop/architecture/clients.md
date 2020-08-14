---
title: Clients
category: architecture
authors: amuller
---

# Clients

There are three clients that access the engine backend.
The user portal, admin portal and the REST API.
All three clients access the backend through the [Bll](/develop/architecture/backend-modules-bll.html) (Business logic unit) module's Backend class.
Backend is a singleton, Enterprise Java Bean, and makes use of annotations.
The main entry points into the class (and thus the backend itself) are the methods RunAction, EndAction and RunQuery.
The goal in the long run is to make the REST API the only client of the Backend class, and the user and admin portals
access the backend through the REST API, to create a situation where only one formal client exists.

