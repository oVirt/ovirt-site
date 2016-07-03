---
title: Dependency Injection and Mockito
author: Jenny Tokar jtokar@redhat.com
tags: community, blog, infrastructure, unittest, java
date: 2016-06-29 15:00:00 CET
---

#Dependency Injection and Mockito

Recently I encountered a small issue in a static helper class that was full of static helper methods. After I finished dealing with the issue at hand and 
as part of following the boy scout rule (always leave the campground cleaner than you found it) I decided to refactor the class and the code using it. 
More specifically to remove all the static modifiers and to inject this class whenever it was needed. 
The refactoring was easy enough but things got a bit more interesting once I got to a class that was using one of the static helper methods. 
The class had a wrapper method that called the static method and did nothing more.

```java
    @Inject
    private HostedEngineHelper hostedEngineHelper;
    
    public boolean isHostedEngine(StorageDomain storageDomain){
            return hostedEngineHelper.isHostedEngineStorageDomain(storageDomain);
    }
```

Those kind of wrapper methods are common in code that uses mocking testing frameworks for unit testing. They certainly are very easy to mock. However, code 
shouldn’t exist for the sake of tests and unnecessary methods that are dirtying it should be removed. 
##Introducing @InjectMocks
And here comes the nice part: Mockito supports injecting mock classes into the tested class in a very neat way. 
You simply add the helper class you need with the **“@Mock”** annotation and put the **“@InjectMocks”** annotation on the class you are mocking for testing and that’s it. 
Mockito will inject the mocked instance to the mocked class so you won’t fall on null pointer exceptions and you will be able to mock the methods you are 
not testing directly.

So instead of having something like this in your test class:

```java
    public StorageDomainCommandBase<StorageDomainParametersBase> cmd = spy(new TestStorageCommandBase(new StorageDomainParametersBase()));

    @Test
    public void shouldElectActiveDataDomain() {
        final StorageDomain domain =prepareStorageDomainForElection(StorageDomainStatus.Active, "not he domain name");
        doReturn(false).when(cmd).isHostedEngine(any(StorageDomain.class));
        assertEquals(domain, cmd.electNewMaster());
    }
```

You end up with something like this:
 
```java
    @Mock
    private HostedEngineHelper hostedEngineHelper;

    @InjectMocks
    @Spy
    public StorageDomainCommandBase<StorageDomainParametersBase> cmd = new TestStorageCommandBase(new StorageDomainParametersBase());

    @Test
    public void shouldElectActiveDataDomain() {
        final StorageDomain domain = prepareStorageDomainForElection(StorageDomainStatus.Active, "not he domain name");
        when(hostedEngineHelper.isHostedEngineStorageDomain(any(StorageDomain.class))).thenReturn(false);
        assertEquals(domain, cmd.electNewMaster());
    }
```

  
Injecting the helper class instead of using it in a static way allows a much cleaner way for writing clear and concise code that doesn't leave the readers wondering about redundant methods. 

