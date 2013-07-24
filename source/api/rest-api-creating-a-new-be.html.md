---
title: REST API Creating a new BE
category: api
authors: emesika
wiki_title: REST API Creating a new BE
wiki_revision_count: 10
wiki_last_updated: 2013-07-24
---

# REST API - Adding a new BE

In this wiki we will introduce all the steps needed in the REST API side in order to add a new Business Entity
Examples on each step are based on work done in [patch](http://gerrit.ovirt.org/#/c/16159) for the Extrenal Tasks [RFE](http://www.ovirt.org/Features/ExternalTasks)

### Creating BE in api.xsd

First, we will have do define the new BE in the api.xsd
This is a XML meta-data file that helps to generate the new BE classes.
In the example we will see a new *Job* entity and a new "Step" entity
There is an heirarchy between "Job" and "Step" , A "Job" can contain several tests.
Also, keep in mind that steps can be nested, we will get to that later.

### Working with nested entities (i.e disks under a vm , steps under a job etc.)

### Adding Mappers

#### Adding tests

### Adding resource classes for single entity

#### Adding tests

### Adding resource classed for entity collections

#### Adding tests

### Enabling parameter passing in the URL

#### Adding tests

### Handling root resources

### Adding Permissions

### Adding enums to capabilities

### Defining new BE API in the RSDL
