---
title: Java-sdk
category: feature
authors:
  - adahms
  - michael pasternak
  - moti
toc: true
---

# Java-sdk

The oVirt Java-SDK is an automatically generated software development kit for the oVirt engine API.
This software development kit allows you to develop Java-based applications for automating a variety of complex administrative tasks in oVirt.


## Concepts

*   Auto-Generated
*   Complete protocol abstraction.
*   Full compliance with the oVirt api architecture.
*   Self descriptive.
*   Intuitive and easy to use.

## IDE Examples

### Creating the proxy:

------------------------------------------------------------------------

![](/images/wiki/0-1jdk.png)

#### Authenticating using user name and password:

![](/images/wiki/0-1-1jdk.png)

#### Authenticating using sessionid:

![](/images/wiki/0-1-2jdk.png)

### Listing all collections:

------------------------------------------------------------------------

![](/images/wiki/1jsdk.png)

### Listing the methods of a collection:

------------------------------------------------------------------------

![](/images/wiki/2jdk.png)

### Querying a collection using a oVirt search engine query and custom constraints:

------------------------------------------------------------------------

![](/images/wiki/3jdk.png)

### Accessing resource methods and properties:

------------------------------------------------------------------------

![](/images/wiki/4jdk.png)

### Creating a resource:

------------------------------------------------------------------------

![](/images/wiki/5jdk.png)

### Accessing resource properties and sub-collections:

------------------------------------------------------------------------

![](/images/wiki/6jdk.png)

### Accessing sub-collection methods:

------------------------------------------------------------------------

![](/images/wiki/7jdk.png)

### Querying a sub-collection using custom constraints:

------------------------------------------------------------------------

TBD

### Retrieving a sub-collection resource:

------------------------------------------------------------------------

![](/images/wiki/8jdk.png)

### Accessing sub-collection resource properties and methods:

------------------------------------------------------------------------

![](/images/wiki/9jdk.png)

## Examples

### create proxy

```java
         // #1 - import
         import org.ovirt.engine.sdk.Api;

         // #2 - create proxy
         Api api = new Api("http://localhost:8080/api", "user@domain", "password");
```

### list entities

```java
         // #1 - list resources
         List`<VM>` vms = api.getVMs().list();
```

### update resource
```java
         // #1 - fetch resource
         VM vm = api.getVMs().get("test");

         // #2 - modify it
         vm.setDescription("java_sdk");

         // #3 - update it
         VM newVM = vm.update();
```

### get resource by name
```java
         // #1 - fetch resource using name
         VM vm = api.getVMs().get("test");
```

### get resource by id
```java
         // #1 - fetch resource using id
         VM vm = api.getVMs().get(UUID.fromString("5a89a1d2-32be-33f7-a0d1-f8b5bc974ff6"));
```

### add resource
```java
         // #1 - create parameters
         org.ovirt.engine.sdk.entities.VM vmParams = new org.ovirt.engine.sdk.entities.VM();
         vmParams.setName("myVm");
         vmParams.setCluster(api.getClusters().get("myCluster"));
         vmParams.setTemplate(api.getTemplates().get("myTemplate"));

         // #2 - add resource
         VM vm = api.getVMs().add(vmParams);
```

or

```java
         // #1 - create parameters
         org.ovirt.engine.sdk.entities.VM vmParams = new org.ovirt.engine.sdk.entities.VM();
         vmParams.setName("myVm");
         org.ovirt.engine.sdk.entities.Cluster clusterParam = new Cluster();
         clusterParam.setName("myCluster");
         vmParams.setCluster(clusterParam);
         org.ovirt.engine.sdk.entities.Template templateParam = new Template();
         templateParam.setName("myTemplate");
         vmParams.setTemplate(templateParam);

         // #2 - add resource
         VM vm = api.getVMs().add(vmParams);
```

### perform an action on resource
```java

         // #1 - fetch resource
         VM vm = api.getVMs().get("test");

         // #2 - create params
         Action actionParam = new Action();
         org.ovirt.engine.sdk.entities.VM vmParam = new org.ovirt.engine.sdk.entities.VM();
         actionParam.setVm(vmParam);

         // #3 - perform an action
         Action res = vm.start(actionParam);
```

or

```java

         // #1 - fetch resource
         VM vm = api.getVMs().get("test");

         // #2 - create params + perform an action
         Action res = vm.start(new Action() {
             {
                 setVm(new org.ovirt.engine.sdk.entities.VM());
             }
         });
```

### list sub-resources
```java

         // #1 - fetch resource
         VM vm = api.getVMs().get("test");

         // #2 - list sub-resources
         List`<VMDisk>` disks = vm.getDisks().list();
```

### get sub-resource
```java

         // #1 - fetch resource
         VM vm = api.getVMs().get("test");

         // #2 - fetch sub-resource
         VMDisk disk = vm.getDisks().get("my disk");
```

### add sub-resource to resource
```java

         // #1 - fetch resource
         VM vm = api.getVMs().get("test");

         // #2 - create parameters
         Disk diskParam = new Disk();
         diskParam.setProvisionedSize(1073741824L);
         diskParam.setInterface("virtio");
         diskParam.setFormat("cow");

         // #3 - add sub-resource
         Disk disk = vm.getDisks().add(diskParam);
```

### update sub-resource
```java

         // #1 - fetch resource
         VM vm = api.getVMs().get("test");

         // #2 - fetch sub-resource
         VMDisk disk = vm.getDisks().get("test_Disk1");

         // #3 - modify sub-resource
         disk.setAlias("test_Disk1_updated");

         // #4 - update it
         VMDisk updateDisk = disk.update();
```

### run action on sub-resource
```java

         // #1 - fetch resource
         VM vm = api.getVMs().get("test");

         // #2 - fetch sub-resource
         VMDisk disk = vm.getDisks().get("test_Disk1");

         // #3 - create parameters
         Action actionParam = new Action();

         // #4 - run an action on sub-resource
         Action result = disk.activate(actionParam);
```

### Best Practices

The api should be shutdown in a finally block so daemon resources are freed:
```java

       Api api = new Api(URL, USER, PASSWORD);
       try {
           api.api.getDataCenters().add(new DataCenter());
           ...
       } finally {
           api.shutdown();
       }
```

## Working with SSL (Secure Socket Layer)

The oVirt Java software development kit provides full support for HTTP over Secure Sockets Layer (SSL) or IETF Transport Layer Security (TLS) protocols by leveraging the Java Secure Socket Extension (JSSE). JSSE has been integrated into the Java 2 platform as of version 1.4 and works with Java-SDK out of the box. On older Java 2 versions, JSSE must be manually installed and configured. Installation instructions can be found at [here](http://java.sun.com/products/jsse/doc/guide/API_users_guide.html#Installation).

Once you have correctly installed JSSE, secure HTTP communication over SSL should be as simple as plain HTTP communication. However, you must supply the Java software development kit with a KeyStore containing the host CA certificate to validate the destination host identity:

### Generating the truststore

1. Download oVirt host CA certificate from `https://host:port/ca.crt`

2. Generate keystore
   ```console
   $ keytool -import -alias "server.crt truststore" -file server.crt -keystore server.truststore
   ```

### Make Java-SDK aware of the keystore

this can be achieved in one of two ways:

1. Via default keystore lookup path
   ```
   $ mkdir ~/.ovirtsdk/
   $ cp server.truststore ~/.ovirtsdk/ovirtsdk-keystore.truststore
   ```

Once the `ovirtsdk-keystore.truststore` installed in the `~/.ovirtsdk`, it will be used for host identity validation upon handshake with the destination host.

2. Via a custom truststore

Use this signature: Api(String url, String username, String password, String keyStorePath)
```java
         Api api = new Api(url, user, password, "/path/server.truststore");
```

### Disable host identity validation

This method SHOULD NOT be used for productive systems due to security reasons, unless it is a conscious decision and you are perfectly aware of security implications of not validating host identity.

use this signature: `Api(String url, String username, String password, boolean noHostVerification)`
```java
         Api api = new Api(url, user, password, true);
```

## Deployment

### Maven deployment

1. add mvn-releases repository to your `~/.m2/settings.xml` under `<repositories>`
   ```xml
   <repository>
       <id>mvn-releases</id>
       <url>https://oss.sonatype.org/content/repositories/releases</url>
       <releases>
       </releases>
       <snapshots>
           <enabled>false</enabled>
       </snapshots>
   </repository>
   ```
2. add sdk dependency to your project pom.xml
   ```xml
   <dependency>
       <groupId>org.ovirt.engine.sdk</groupId>
       <artifactId>ovirt-engine-sdk-java</artifactId>
       <version>x.y.z.q-v</version>
       <type>jar</type>
       <scope>compile</scope>
   </dependency>
   ```
   `x.y.z.q-v` is a latest sdk release (list of available releases can be found at [Java SDK tags](https://github.com/oVirt/ovirt-engine-sdk-java/tags))

3. deploy sdk dependencies and javadoc
   ```console
   $ mvn dependency:resolve -Dclassifier=javadoc
   ```

4. compile
   ```console
   $ mvn clean install
   ```

### Development deployment

#### Code generation

1. pull + compile + deploy latest ovirt-engine sources
2. cd ovirt-engine-sdk-java-codegen
3. compile
4. run (this will generate sdk from the ovirt-engine)

#### Development

All SDK development is done on the ovirt-engine-sdk-java-codegen project,
i.e if you have yet not supported funcionality in SDK, this is a place to add
support for it.

## TODO list

1. generate entry-point (`/api`) methods (done)

2. generate searchable `list()` methods (done)

3. generate method/s overloads using header/url params (done)

4. generate delete method/s overloads with body (done)

5. support persistent authentication (done)

6. implement SSL support (done)

7. implement SSL CA certificate validation (done)

8. implement client validation

9. allow setters generation for collection based fields in org.ovirt.engine.sdk.entities

10. implement in collection.get(name) search using engine.search

11. implement timeout in SDK constructor

12. implement sdk debug mode (done)

13. remove @SuppressWarnings("unused") from decorators

14. move get/list methods from the decorators to the parent classes

15. implement unique treatment for COLLECTION2ENTITY pattern exceptions (in-progress)

16. implement logger in codegen

17. add deployment capabilities (done)

18. upload artifacts to mvn repo (done)

19. Implement querying collections using custom constraint.

20. in doc change parameters format to javaDoc style (done)

21. make API.java thread safe (done)


## Maintainers

Michael Pasternak: mishka8520@yahoo.com, Juan Hernandez: juan.hernandez@redhat.com

