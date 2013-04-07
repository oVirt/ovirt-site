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

oVirt Java-SDK is auto-generated software development kit for the oVirt engine api.

__TOC__

## Concepts

*   Auto-Generated
*   Complete protocol abstraction.
*   Full compliance with the oVirt api architecture.
*   Self descriptive.
*   Intuitive and easy to use.

## IDE Examples

### Creating the proxy

------------------------------------------------------------------------

![](0-1jdk.jpg "0-1jdk.jpg")

#### Authenticating using username and password

![](0-1-1jdk.jpg "0-1-1jdk.jpg")

#### Authenticating using sessionid

![](0-1-2jdk.jpg "0-1-2jdk.jpg")

### Listing all collections

------------------------------------------------------------------------

![](1jsdk.jpg "1jsdk.jpg")

### Listing collection's methods

------------------------------------------------------------------------

![](2jdk.jpg "2jdk.jpg")

### Querying collection with oVirt search engine query & custom constraint

------------------------------------------------------------------------

![](3jdk.jpg "3jdk.jpg")

### Accessing resource methods and properties

------------------------------------------------------------------------

![](4jdk.jpg "4jdk.jpg")

### Creating resource

------------------------------------------------------------------------

![](5jdk.jpg "5jdk.jpg")

### Accessing resource properties and sub-collections

------------------------------------------------------------------------

![](6jdk.jpg "6jdk.jpg")

### Accessing sub-collection methods

------------------------------------------------------------------------

![](7jdk.jpg "7jdk.jpg")

### Querying sub-collection by custom constraint.

------------------------------------------------------------------------

TBD

### Retrieving sub-collection resource.

------------------------------------------------------------------------

![](8jdk.jpg "8jdk.jpg")

### Accessing sub-collection resource properties and methods

------------------------------------------------------------------------

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

### Maven deployment

1. add mvn-releases repository to your ~/.m2/settings.xml under <repositories>

`   `<repository>
`       `<id>`mvn-releases`</id>
`       `<url>[`https://oss.sonatype.org/content/repositories/releases`](https://oss.sonatype.org/content/repositories/releases)</url>
`       `<releases>
`       `</releases>
`       `<snapshots>
`           `<enabled>`false`</enabled>
`       `</snapshots>
`   `</repository>

2. add sdk dependency to your project pom.xml

`   `<dependency>
`       `<groupId>`org.ovirt.engine.sdk`</groupId>
`       `<artifactId>`ovirt-engine-sdk-java`</artifactId>
`       `<version>`x.y.z.q-v`</version>
`       `<type>`jar`</type>
`       `<scope>`compile`</scope>
`   `</dependency>

             "x.y.z.q-v" is a latest sdk release (list of available releases can be found at `[`java-sdk-changelog`](java-sdk-changelog)`)

3. deploy sdk dependencies and javadoc

           mvn dependency:resolve -Dclassifier=javadoc

4. compile

            mvn clean install

### Development deployment

#### Code generation

           1. pull + compile + deploy latest ovirt-engine sources
           2. cd ovirt-engine-sdk-java-codegen
           3. compile
           4. run (this will generate sdk from the ovirt-engine)

#### Development

           all SDK development is done on the ovirt-engine-sdk-java-codegen project,
           i.e if you have yet not supported funcionality in SDK, this is a place to add
           support for it.

## TODO list

1. generate entry-point (/api) methods (done)

2. generate searchable list() methods (done)

3. generate method/s overloads using header/url params (done)

4. generate delete method/s overloads with body (done)

5. support persistent authentication (done)

6. implement SSL support (done)

7. implement SSL CA certificate validation (in-progress)

8. implement client validation

9. allow setters generation for collection based fields in org.ovirt.engine.sdk.entities

10. implement in collection.get(name) search using engine.search

11. implement timeout in SDK constructor

12. implement sdk debug mode

13. remove @SuppressWarnings("unused") from decorators

14. move get/list methods from the decorators to the parent classes

15. implement unique treatment for COLLECTION2ENTITY pattern exceptions

16. implement logger in codegen

17. add deployment capabilities

18. upload artifacts to mvn repo (done)

19. Implement querying collections using custom constraint.

20. in doc change parameters format to javaDoc style (done)

## Change Log

[java-sdk-changelog](java-sdk-changelog)

## Maintainer

Michael Pasternak <mpastern@redhat.com>

<Category:SDK>
