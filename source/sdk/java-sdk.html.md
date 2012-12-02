---
title: Java-sdk
category: sdk
authors: adahms, michael pasternak, moti
wiki_category: SDK
wiki_title: Java-sdk
wiki_revision_count: 73
wiki_last_updated: 2014-07-24
---

# Java-sdk

oVirt Java-SDK package a software development kit for the oVirt engine api.

__TOC__

## Concepts

*   Complete protocol abstraction.
*   Full compliance with the oVirt api architecture.
*   Self descriptive.
*   Auto-Generated
*   Intuitive and easy to use.

## IDE Examples

### Creating the proxy & Listing all collections

![](1jsdk.jpg "1jsdk.jpg")

### Listing collection's methods

![](2jdk.jpg "2jdk.jpg")

### Querying collection with oVirt search engine query & custom constraint

TBD

### Accessing resource methods and properties

![](4jdk.jpg "4jdk.jpg")

### Creating resource

![](5jdk.jpg "5jdk.jpg")

### Accessing resource properties and sub-collections

![](6jdk.jpg "6jdk.jpg")

### Accessing sub-collection methods

![](7jdk.jpg "7jdk.jpg")

### Querying sub-collection by custom constraint.

TBD

### Retrieving sub-collection resource.

![](8jdk.jpg "8jdk.jpg")

### Accessing sub-collection resource properties and methods

![](9jdk.jpg "9jdk.jpg")

## Examples

### create proxy

         // #1 - import
         import org.ovirt.engine.sdk.Api;

         // #2 - create proxy
         Api api = new Api("`[`http://localhost:8080/api`](http://localhost:8080/api)`", "user@domain", "password");

### list entities

         // #1 - list resources
         List`<VM>` vms = api.getVMs().list();

### update resource

         // #1 - fetch resource
         VM vm = api.getVMs().get("test");

         // #2 - modify it
         vm.setDescription("java_sdk");

         // #3 - update it
         VM newVM = vm.update();

### get resource by name

         // #1 - fetch resource using name
         VM vm = api.getVMs().get("test");

### get resource by id

         // #1 - fetch resource using id
         VM vm = api.getVMs().get(UUID.fromString("5a89a1d2-32be-33f7-a0d1-f8b5bc974ff6"));

### add resource

         // #1 - create parameters
         org.ovirt.engine.sdk.entities.VM vmParams = new org.ovirt.engine.sdk.entities.VM();
         vmParams.setName("myVm");
         vmParams.setCluster(api.getClusters().get("myCluster"));
         vmParams.setTemplate(api.getTemplates().get("myTemplate"));

         // #2 - add resource
         VM vm = api.getVMs().add(vmParams);

         or

         // #1 - create parameters
         org.ovirt.engine.sdk.entities.VM vmParams = new org.ovirt.engine.sdk.entities.VM();
         vmParams.setName("myVm");
         org.ovirt.engine.sdk.entities.Cluster clusterParam = new Cluster();
         clusterParam.setName("myCluster");
         vmParams.setCluster(clusterParam);
         org.ovirt.engine.sdk.entities.Template templateParam = new Template();
         templateParam.setName("myTemplate");
         vmParams.setTemplate(templateParam);

         // #2 - add resource
         VM vm = api.getVMs().add(vmParams);

### perform an action on resource

         // #1 - fetch resource
         VM vm = api.getVMs().get("test");

         // #2 - create params
         Action actionParam = new Action();
         org.ovirt.engine.sdk.entities.VM vmParam = new org.ovirt.engine.sdk.entities.VM();
         actionParam.setVm(vmParam);

         // #3 - perform an action
         Action res = vm.start(actionParam);

         or

         // #1 - fetch resource
         VM vm = api.getVMs().get("test");

         // #2 - create params + perform an action
         Action res = vm.start(new Action() {
             {
                 setVm(new org.ovirt.engine.sdk.entities.VM());
             }
         });

### list sub-resources

         // #1 - fetch resource
         VM vm = api.getVMs().get("test");

         // #2 - list sub-resources
         List`<VMDisk>` disks = vm.getDisks().list();  

### get sub-resource

         // #1 - fetch resource
         VM vm = api.getVMs().get("test");

         // #2 - fetch sub-resource
         VMDisk disk = vm.getDisks().get("my disk");

### add sub-resource to resource

         // #1 - fetch resource
         VM vm = api.getVMs().get("test");

         // #2 - create parameters
         Disk diskParam = new Disk();
         diskParam.setProvisionedSize(1073741824L);
         diskParam.setInterface("virtio");
         diskParam.setFormat("cow");

         // #3 - add sub-resource
         Disk disk = vm.getDisks().add(diskParam);

### update sub-resource

         // #1 - fetch resource
         VM vm = api.getVMs().get("test");

         // #2 - fetch sub-resource
         VMDisk disk = vm.getDisks().get("test_Disk1");

         // #3 - modify sub-resource
         disk.setAlias("test_Disk1_updated");

         // #4 - update it
         VMDisk updateDisk = disk.update();

### run action on sub-resource

         // #1 - fetch resource
         VM vm = api.getVMs().get("test");

         // #2 - fetch sub-resource
         VMDisk disk = vm.getDisks().get("test_Disk1");

         // #3 - create parameters
         Action actionParam = new Action();

         // #4 - run an action on sub-resource
         Action result = disk.activate(actionParam);

## Repository

gerrit.ovirt.org:ovirt-engine-sdk-java

## Deployment

Till java-sdk project deployable by rpm, just compile it and reference it from your project.

## TODO list

1. generate entry-point (/api) methods

2. generate searchable list() methods

3. generate method/s overloads using header/url params

4. support persistance-auth

5. implement sdk debug mode

6. do not throw third party exceptions

7. remove @SuppressWarnings("unused") from decorators

8. move get/list methods from the decorators to the parent class

9. implement logger in codegen

10. add MakeFile

11. upload artifacts to mvn repo

## Change Log

[java-sdk-changelog](java-sdk-changelog)

## Maintainer

Michael Pasternak: mpastern@redhat.com

<Category:JAVA-SDK>
