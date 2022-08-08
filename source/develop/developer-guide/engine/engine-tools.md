---
title: oVirt engine tools
authors:
  - abonas
  - adahms
  - knesenko
  - lveyde
  - moti
  - roy
  - yair zaslavsky
---

# oVirt engine tools

Engine tools are mainly standalone java programs wrapped-up by scripts and mostly using the engine libraries

## Tools list

1.  engine-manage-domains
2.  engine-config
3.  engine-notifier
4.  ovirt-log-collector
5.  generate-ssh-keys
6.  store-utils.sh

### Tools description

### engine-manage-domains

Using this tool it is possible to add new authentication domains to serve as resource for users authenticating to oVirt engine.

**How to get the tool**:
The tool is installed when engine is installed.

**How to configure the tool:**
You can edit the configuration located at `/etc/ovirt-engine/engine-manage-domains/engine-manage-domains.conf`

**How to run the tool:**
Running basic example:
```console
# engine-manage-domains add --domain=<MY_DOMAIN> --provider=<ad/ipa/oldap/itds/rhds> --user=<USERNAME>
```

### engine-config

Using this tool it is possible to alter engine's configuration

**How to get the tool:**
The tool is installed when engine is installed.

**How to configure the tool:**
You can edit the configuration located at `/etc/ovirt-engine/engine-config/engine-config.conf`

**How to run the tool:**
Running basic example:
```console
# engine-config -l
```
will show you list of properties that can be alttered

```console
# engine-config-g <property_name>
```
will show you the value of a property

```console
 engine-config-s <property_name>=<property_value>
```
will alter the value of a property


### ovirt-log-collector

Please refer to [The Log Collector Tool](/documentation/administration_guide/#sect-The_Log_Collector_Tool)
documentation within [oVirt Administration Guide](/documentation/administration_guide/)

### Tools TODO

1.  Standardize the usage of all tools and make them consistent
2.  Create common infrastructure both for Java programs and for the wrapping scripts e.g. functions to fulfill classpath dependencies, etc.
3.  Use comon paths for all
4.  Use a single logger library (`apache-commons-logging`)
