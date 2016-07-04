---
title: Application scoped tests for oVirt with Arquillian
author: rmohr
tags: "oVirt","Arquillian", "Builder", "Postgres", "Unit Test", "Wildfly"
date: 2016-07-04 16:30:00 CET
comments: true
published: false
---

[oVirt's](http://ovirt.org) heart `ovirt-engine` is a monolith with more
than one million lines of codes based on Wildfly. One of the problems faced
when working on such big projects is that sometimes writing tests is extremely
complex. You spend a tremendous amount of time mocking database access and
irrelevant services for the unit under test.

One way to deal with that complexity is to treat the
database as part of the application. While we will see the advantages of this
for writing tests it does also make a lot of sense for other reasons.

In the past the database was not part of the application, it was the opposite.
The database was *the* integration point of different applications and
services. A database was full of different views for BI, Finance, Shops, and
many more. This has changed over time. Nowadays the integration mostly happens
through REST or similar APIs, giving applications the freedom to choose the one
(or even more than one) database technology suiting their domain.

Back to the topic of this post: To integrate the database into the tests, some
requirements need to be met:

 * Database rollback after every test
 * An easy way to create, update and delete test relevant data on the database layer must be provided
 * The main application infrastructure should be up and things like CDI injections should work.

Since `ovirt-engine` is based on [Wildfly](http://wildfly.org/),
[Arquillian](http://arquillian.org/) is the perfect choice for meeting these
requirements.

Getting started with Arquillian is pretty easy. Add the right dependencies to your Maven `pom.xml`:

```xml
  <dependencies>
    <dependency>
      <groupId>javax.enterprise</groupId>
      <artifactId>cdi-api</artifactId>
      <scope>provided</scope>
    </dependency>
    <dependency>
      <groupId>org.jboss.spec</groupId>
      <artifactId>jboss-javaee-6.0</artifactId>
      <type>pom</type>
      <scope>provided</scope>
    </dependency>
    <dependency>
      <groupId>org.jboss.arquillian.junit</groupId>
      <artifactId>arquillian-junit-container</artifactId>
      <scope>test</scope>
    </dependency>
    <dependency>
      <groupId>org.jboss.shrinkwrap.resolver</groupId>
      <artifactId>shrinkwrap-resolver-depchain</artifactId>
      <scope>test</scope>
      <type>pom</type>
    </dependency>
    <dependency>
      <groupId>org.jboss.arquillian.container</groupId>
      <artifactId>arquillian-weld-ee-embedded-1.1</artifactId>
      <version>1.0.0.CR8</version>
      <scope>test</scope>
    </dependency>
    <dependency>
      <groupId>org.jboss.weld</groupId>
      <artifactId>weld-core</artifactId>
      <version>1.1.5.Final</version>
      <scope>test</scope>
    </dependency>
    <dependency>
      <groupId>org.slf4j</groupId>
      <artifactId>slf4j-simple</artifactId>
      <version>1.6.4</version>
      <scope>test</scope>
    </dependency>
  </dependencies>
```

Create a simple Arquillian test:

```java
@RunWith(Arquillian.class)
public class SimpleTest {

    @Inject
    TestBean testBean;

    @Deployment
    public static JavaArchive deploy() {
        return ShrinkWrap.create(JavaArchive.class)
                .addClass(
                        TestBean.class
                ).addAsManifestResource(
                        EmptyAsset.INSTANCE,
                        ArchivePaths.create("beans.xml")
                );
    }

    @Test
    public void shouldPrintHello() {
        testBean.printHello();
    }

    public static class TestBean {
        public void printHello() {
            System.out.println("Hi I am injected");
        }
    }
}
```
and your first test with real injections is running. A good
starting point for understanding Arquillian better is the [Getting
Started](http://arquillian.org/guides/getting_started/) article on the
Arquillian homepage.

Arquillian can also do automatic rollback for you with its [Transaction
Extension](http://arquillian.org/modules/transaction-extension/).  Since this
requires the download of a full JavaEE Application Server it is not an option
for oVirt right now. To still get automatic rollback I only had to create a
custom Arquillian Extension which can be found
[here](https://github.com/oVirt/ovirt-engine/tree/aa000f27c7bcb17cf82fbd2579059664838cfea7/backend/manager/modules/bll/src/test/java/org/ovirt/engine/arquillian/database).
Look at
[RollbackRule.java](https://github.com/oVirt/ovirt-engine/blob/aa000f27c7bcb17cf82fbd2579059664838cfea7/backend/manager/modules/bll/src/test/java/org/ovirt/engine/arquillian/database/RollbackRule.java)
in the extension to see how the Spring transaction manager is hooked into
Arquillian without the need of a real JTA transaction manager. Almost everyting
in Arquillian is extensible, that is really where this project shines. 

All this is already part of oVirt, so when writing tests, you don't have to
care about this anymore. Inherit from the right base class and start
writing your test. 

### Writing an oVirt application scoped test step-by-step

Creating an application scoped test for oVirt is pretty simple:
```java
@Category(IntegrationTest.class)
public class AddVmCommandTest extends TransactionalCommandTestBase {
    @Deployment
    public static JavaArchive createDeployment() {
        return TransactionalCommandTestBase.createDeployment();
    }
```

The `@Category` annotation on the class tells Maven that it should launch the
test in the integration test phase. The advantage of running them not as
regular unit tests is that we can update the database schema before we run the
first integration test with the standard Maven life-cycle. Regular unit tests
can still run in the normal test phase and are independent from any resource
needs of the integration tests.

Arquillian based tests need a static method with the `@Deployment` annotation
on it. There we return a `JavaArchive`. Arquillian supports different
application types (EAR, WAR, JAR). For our scenario the advantage of the
`JavaArchive` is that in contrast to WAR and EAR deployments everything on the
classpath will also be accessable in the tests, whereas the other application
types are far better isolated. However, to make classes injectable they need to
be part of the generated JAR itself. The `JavaArchive` follows a nice builder
pattern and adding your own services is just a matter of calling
`JavaArchive#addClasses(...)`.

All DAOs and the basic `ovirt-engine` services are already added to the archive by the base class `TransactionalCommandTestBase`, so just calling
`#createDeployment()` of the base class should be enough for many cases.

That is not the only thing the base class does for us. It does:

 * Transaction handling. After every test the database is rolled back
 * Creating a default datacenter with a default host and a default VM in the database.
 * Loading the default config values of ovirt-engine
 * Loading the default OS configuration for different OS types
 * Loading and setting up the ovirt-engine lock manager for the application
 * Packing all DAOs and the most common services in the Arquillian JAR.

The next step is to set up your test:
```java
    @Inject
    BackendInternal backend;

    @Inject
    StoragePoolDao storagePoolDao;


    private AddVmParameters parameters;

    @Before
    public void setUp() {
        parameters = new AddVmParameters();
        vmBuilder.reset().cluster(defaultCluster).os(OS_RHEL7_X86_64).name("my_vm");
    }
```
Arquillian gives us the possibility to use injections in the test class itself.
Here the `StoragePoolDao` is injected. Further in the `@Before` method a
default scenario for the tests is defined. In this case testing the
`AddVmCommand` is the goal. Therefore a VM which will make the `AddVmCommand`
operation pass is defined (not created yet) with the `VmBuilder` (The builders
are an important part of reducing redundant code, see below for more details).

Defining a scenario which will be valid for the code under test is one of
the key elements for writing tests. Not only for this kind of application
scoped tests, also for writing unit tests in general. This scenaro is
enough to make the common use case for the code under test succeed:
```java
    @Test
    public void shouldAddVm() {
        parameters.setVm(vmBuilder.build());
        VdcReturnValueBase returnValue = backend.runInternalAction(VdcActionType.AddVm, parameters);
        assertThat(returnValue.getSucceeded()).isTrue();
    }
```
Recreating the same valid scenario before every test makes it now extremely
easy to test specific scenarios. The following test tests if the
`AddVmCommand` will detect a VM entity without a name by just tweaking the
default scenario in a minimal way:
```java
    @Test
    public void shouldDetectMissingName() {
        parameters.setVm(vmBuilder.name(null).build());
        VdcReturnValueBase returnValue = backend.runInternalAction(VdcActionType.AddVm, parameters);
        assertThat(returnValue.getSucceeded()).isFalse();
        assertThat(returnValue.getValidationMessages()).contains(EngineMessage.ACTION_TYPE_FAILED_NAME_MAY_NOT_BE_EMPTY.name());
    }
```

Since a key feature of these kind of tests is that all changes in the database
are rolled back after every test, we can also tweak peristed entities in the database to create our scenarios. Here the default storage pool in the database
is loaded, set to `NotOperational` and persisted again. As a result the
`AddVmCommand` should fail:

```java
    @Test
    public void shouldDetectNonOperationalStoragePool() {
        defaultStoragePool.setStatus(StoragePoolStatus.NotOperational);
        storagePoolDao.update(defaultStoragePool);

        parameters.setVm(vmBuilder.build());
        VdcReturnValueBase returnValue = backend.runInternalAction(VdcActionType.AddVm, parameters);
        assertThat(returnValue.getSucceeded()).isFalse();
        assertThat(returnValue.getValidationMessages()).contains(EngineMessage.ACTION_TYPE_FAILED_IMAGE_REPOSITORY_NOT_FOUND.name());
    }

}
```

### Populating the database

While Arquillian and some custom extensions are preparing the environment to
reduce the amount of repetitive set-up code for the tests, this does still not
give us a nice way to populate the database with the data needed for a specific
test. Currently ovirt-engine uses a fixture file for DAO testing. All entities
are described there in an XML format and before every test the database is
populated with that data. While this works it has some drawbacks. Mainly:

 * It is hard to add new entities in XML.
 * It is hard to update the entities in the XML file when the entity class changes.
 * All tests need to take into account that there might be unrelated data in the database for other tests.
 * It is hard to see which tests use which parts of the persisted data
 
A nice trick I have learned some time ago from the excellent engineers behind
[Frendseek](http://www.friendseek.com/) is to use `builders` for the entities.
With these builders the basic set-up of a full datacenter in the engine looks
like this:

```java
@RunWith(Arquillian.class)
public abstract class TransactionalTestBase {

    [...]

    @Before
    public void setUpDefaultEnvironment() {
        [...]

        MacRange macRange = new MacRange();
        macRange.setMacFrom("00:2A:4A:16:01:51");
        macRange.setMacTo("00:2A:4A:16:01:e6");


        defaultStoragePool = storagePoolBuilder.up().persist();
        defaultMacPool = macPoolBuilder.macRanges(macRange).persist();
        defaultCluster = clusterBuilder
                .macPool(defaultMacPool)
                .storagePool(defaultStoragePool)
                .architecture(ArchitectureType.x86_64)
                .cpuName("Intel Conroe Family")
                .persist();
        defaultCpuProfile = cpuProfileBuilder.cluster(defaultCluster).persist();
        defaultHost = vdsBuilder.cluster(defaultCluster).persist();
        defaultVM = vmBuilder.host(defaultHost).os(OS_RHEL7_X86_64).up().persist();
    }
}
```

When calling `#persist()` on the builder the entity is persisted to the
database and a fresh loaded copy of the entity is returned. There exists also
the `#build()` counterpart on every builder which can also be used in normal
unit tests without database access.

There are two very important rules when writing builders for new entities:

 * Calling `builder.reset().persist()` should always work. In other words, if values which are required to meet database constraints are missing, fill them with random values to make a call to `#persist()` always succeed. Don't pre-fill any other values to keep the tests as predictable as possible.
 * Instantiating a builder and calling `#build()` should work without the need to have CDI or a database present. It basically allows you to reuse the builders for standard unit tests.

The final step to make the usage of the builders and the default environment even more convenient, is to declare them in the base class as protected fields. This allows inherited test cases to easily access the pre-persisted default entities and the builders, like demonstrated on the `AddVmCommandTest` example above.

### Conclusion
Comparing the classic [AddVmCommandTest](https://gerrit.ovirt.org/gitweb?p=ovirt-engine.git;a=blob;f=backend/manager/modules/bll/src/test/java/org/ovirt/engine/core/bll/AddVmCommandTest.java;h=5cacad4b8058ac10aa45f7e0cfd00c4f38fbbd88;hb=80274308dcadddea46cde895f7418b022cb6224e) with the new [integration/AddVmCommandTest](https://gerrit.ovirt.org/gitweb?p=ovirt-engine.git;a=blob;f=backend/manager/modules/bll/src/test/java/org/ovirt/engine/core/bll/integration/AddVmCommandTest.java;h=a7da66974beaf3694d26aa0f3507c5b146d67c59;hb=80274308dcadddea46cde895f7418b022cb6224e) immediately shows how much simpler it is to quickly write new tests. Further we can stop imitating application internal DAO and service logic with Mockito, making it easier to refactor the application and the tests. Since we are also not mocking any of the DAOs or core services there is a higher chance of immediately detecting changes of behaviour (intendet or unintended) which would break dependent services.

This post was originally published at [rmohr.github.io](http://rmohr.github.io/continuous%20integration/2016/07/04/application-scoped-tests-for-ovirt-with-arquillian).
