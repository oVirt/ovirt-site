---
title: Action Permissions overview
authors: moti, roy
wiki_title: Action Permissions overview
wiki_revision_count: 5
wiki_last_updated: 2012-10-31
---

# Action Permissions overview

## Abstract

This is and overview and a how-to for developers. It should give a good idea about how
permissions are build into the backend archetecture and how to add/update autorization to commands and entities.

## Terminology

*   Permission

The building block in authorization which is composed from the target Object, User, and Role Ids.

            Permission
           /     |     \
        Object  User   Role

*   Role

Role is Action groups container. A role can also be associated as a USER/ADMIN type. ADMIN roles have Action Groups which USER dont

*   PreDifined Roles

SuperUser, DataCenterAdmin are examples of predefined roles inserted during installation to DB. They could be edited.
for the list of full predefind roles see PredefinedRoles.java and dbscripts/insert_predefined_roles.sql

*   Action Group

group of Actions

*   Action

The basic building block. Every Command in the engine is an Action and has a unique ID given in the VdcActionType.java

*   MLA - multi level administration.

To make a long story short it was the initial name of the permission feature in the engine. At first there was no
authorization on actions (woohoo!) so a special UI was designed to enforce it and its name was "Multi Level Administration Portal"
