---
title: Testing ovirt-engine changes without a real cluster
author: msivak
tags: oVirt, Test, vdsmfake, ovirt-engine, development
date: 2016-11-14 08:30:00 CET
comments: true
published: true
---

The ovirt-engine component of oVirt is the brain of oVirt and is responsible for managing attached systems; providing the webadmin UI and REST interfaces; and other core tasks. The process of setting up a real cluster on which to deploy the project is a time-consuming task that greatly increases patch turnaround time and can provide a significant barrier of entry to those wanting to contribute to the project.

READMORE

## Development Environment

There are couple of preparation steps you must take to create your development environment. I am using CentOS 7 as my development machine so I will use that system to describe everything, but it should be pretty straightforward to adapt the article to Fedora.

We first need the source code for the ovirt-engine itself. You can get it from the project's code review tool: [gerrit.ovirt.org](http://gerrit.ovirt.org). Just execute the following command and wait for it to finish:

```
# git clone git://gerrit.ovirt.org/ovirt-engine.git
```

You will also need a directory for the development deployments, so create a directory somewhere. Mine is in ~/Applications/ovirt-engine-prefix. I have set the$OVIRT_PREFIX environment variable to point to that path, so when you see it used throughout this article, substitute the path for your own development deployments directory.

Now you have to install all the necessary development packages and a postgres database. Please follow the `Prerequisities`, `System settings`, and `PostgreSQL accessibility` sections of the main [README.adoc](https://gerrit.ovirt.org/gitweb?p=ovirt-engine.git;a=blob;f=README.adoc;h=ba141ab34728da6048ab9659acd6d9ca45c975f4;hb=8b2b8fdf6921a4da4fa098e7cf37edbe9796f45c) file. Do not create any databases or users yet, though!

Databases will be created later, but a database user is needed, so create a PostgreSQL user `engine` with the password set to `engine`:

```
# su - postgres -c "psql -d template1"
template1=# create user engine password 'engine';
```

## Resolving Fake Host Names

We will be using [oVirt host simulator](https://gerrit.ovirt.org/gitweb?p=ovirt-vdsmfake.git;a=summary) (also known as vdsmfake) to be able to test the virtual machine, host, and storage related functionality. A single simulator can act as multiple hosts, but the engine needs a separate FQDN (fully qualified domain name) for each host. There is an elegant way to assign multiple names to a single machine (your development laptop for example) using [dnsmasq](http://www.thekelleys.org.uk/dnsmasq/doc.html) integration with NetworkManager.

Create the following two files with the provided content:

- /etc/NetworkManager/dnsmasq.d/10-vdsmfake.conf

  ```
  address=/vdsm.fake/127.0.0.1
  ```

- /etc/NetworkManager/conf.d/20-dnsmasq.conf 

  ```
  [main]
  dns=dnsmasq
  ```

Install and properly configure the necessary services as shown below. Do not be confused by the fact you are disabling dnsmasq, as it will be started internally by the NetworkManager.

```
$ yum install dnsmasq
$ systemctl disable dnsmasq
$ systemctl restart NetworkManager
```

Once you have completed the above steps, you will be able to access your machine using any name with the `.vdsm.fake` suffix. For example `host1.vdsm.fake`, `blue.vdsm.fake`, or anything else.

If you do not feel like touching the NetworkManager configuration, there is an alternative approach. You can add additional static localhost aliases to /etc/hosts. Please check the example line below to see how:

```
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4 host1.vdsm.fake host2.vdsm.fake host3.vdsm.fake
```

The disadvantage of the /etc/hosts approach is that you have to edit the file always when you want to create an additional hostname for your virtual hosts.

## Compiling the Engine

The full compilation with all language variants takes a looong time and eats a huge amount of resources. Fortunately, there are couple of options to disable compilation of pieces we won't need.

To create a full development build, use the commands below. By specifying the prefix "$OVIRT_PREFIX/my-first-test", the build will be created in that directory. Don't forget to substitute the path for your own development deployments directory if you haven't set the OVIRT_PREFIX environment variable. Also, do not attempt to create this build unless you have at least 8 GiB of free RAM!

```
# PREFIX="$OVIRT_PREFIX/my-first-test"
# make clean install-dev PREFIX="$PREFIX"
```

The command can be further tweaked using a couple of variables. The most important options you might or might not want are:

- `BUILD_GWT_USERPORTAL=0` -- You can use this variable to disable the user portal
- `BUILD_GWT_WEBADMIN=0` -- You can use this variable to disable the webadmin UI
- `DEV_EXTRA_BUILD_FLAGS_GWT_DEFAULTS="-Dgwt.userAgent=safari"` -- This variable will change the default compiled browser variant to be Chrome compatible

The engine will be deployed to the specified `$PREFIX` directory once the `install-dev` command finishes. It's not usable yet though. The database still needs to be created and there is a configuration step that must also be performed.

## Setting Up the Deployed Engine

Now is the time to prepare the database for the currently deployed engine. I am usually working on multiple fixes for multiple branches at the same time so I typically use a separate database for each branch or feature I work on. Here I will create a database named `firsttest`.

```
# su - postgres -c "psql -d template1"
template1=# drop database firsttest;
template1=# create database firsttest owner engine template template0 encoding 'UTF8' lc_collate 'en_US.UTF-8' lc_ctype 'en_US.UTF-8';
```

The deployed engine can be configured now. Execute the setup command and answer all the questions. Do not forget to use the proper database user (`engine`), password (`engine`), and database name (`firsttest`). Also, one of the setup questions will ask you to provide an administrator password. Make sure you remember the password you provide because you will need it to log in to the engine later..

```
# "${PREFIX}/bin/engine-setup"
```

The remaining steps modify configuration values related to the fake hosts we'll be using.

The host simulator does not support encrypted communication so we need to disable it:

```
sudo -i -u postgres psql $ENGINE_DB -c "UPDATE vdc_options set option_value = 'false' WHERE option_name = 'SSLEnabled';"
sudo -i -u postgres psql $ENGINE_DB -c "UPDATE vdc_options set option_value = 'false' WHERE option_name = 'EncryptHostCommunication';"
```

Since the fake host isn't real, we also have to disable the host deploy option, otherwise the engine would try to update and configure the development machine if provided the proper credentials!

```
psql $ENGINE_DB -c "UPDATE vdc_options set option_value = 'false' where option_name = 'InstallVds'"
```

The last option we'll set instructs the engine to send the hostname with every request that goes to the host. This allows us to use a single vdsmfake instance to simulate multiple hosts at once:

```
psql $ENGINE_DB -c "UPDATE vdc_options set option_value = 'true' WHERE option_name = 'UseHostNameIdentifier';"
```

## Starting Up the Engine and Adding the Fake Hosts

A properly deployed and configured engine can be now started using the following command:

```
$ "${PREFIX}/share/ovirt-engine/services/ovirt-engine/ovirt-engine.py" start
```

Once the service boots up, you can access it by going to [http://localhost:8080](http://localhost:8080) and logging in using the engine credentials you provided during the setup phase.

![oVirt welcome screen](/images/vdsmfake/welcome.png)

Our fake hosts can be started by first cloning the [source](git://gerrit.ovirt.org/ovirt-vdsmfake.git), entering the ovirt-vdsmfake directory and using maven to start the [jetty](http://www.eclipse.org/jetty/) container:

```
# git clone git://gerrit.ovirt.org/ovirt-vdsmfake.git
# pushd ovirt-vdsmfake
# mvn clean jetty:run
```

You can now add as many hosts as you need to the engine using any made up names and addresses (just suffix them with `.vdsm.fake`). The engine requires you to enter a password when adding a host, but any random string is fine there (it won't be used anyway).

![adding a new host](/images/vdsmfake/new-host.png)

You have to connect a storage domain to make the engine fully operational, so go to the Storage tab and create a new storage domain using any random NFS path. The fake hosts will report a connection success without actually talking to any remote server and this will enable the Datacenter functionality.

![adding a new storage domain](/images/vdsmfake/storage.png)

## What To Do Next?

The setup is now ready and you can use most of the functionality to test your changes or just play with the engine. Starting, stopping, and migrating VMs will work (no real VMs will exist though - everything is faked by the host simulator) as will most of the other administrative flows.

In case you update the source code, just stop the engine using Control-C, execute the `make install-dev` and `engine-setup` (only needed if database structure was updated) commands to redeploy the changed pieces. Then you can start the engine again and test your changes.

I hope this tutorial was useful for you. To make the process even simpler, I have attached a simple script that compiles all the steps into one simple command dev-build.sh, which is found at http://www.ovirt.org/download/dev-build.sh, that does almost everything (including the engine-setup) for you. Before using it, you will need to tweak the `ROOT` path in it to point to your `$OVIRT_PREFIX` directory. It also supports couple of command line options like `--clean` (cleans the existing prefix and database before deploying) and `--config` (reruns the setup steps for an existing prefix). The default password it generates for the administrator user is `letmein`.

```
pushd ovirt-engine
dev-build.sh firsttest
```

Please forward any questions to the usual development mailing list devel@ovirt.org or to me personally to msivak@redhat.com.
