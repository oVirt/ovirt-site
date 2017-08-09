---
title: Hosted-Engine invalid bond modes
authors: Ido Rosenzwig
---

# Hosted-Engine invalid bond modes

Some bond modes (0, 5, 6) cause problems in VM networks.
Therefore, when the user has to select network device, during the Hosted-engine deployment,
bonds that are configured in these modes cannot be selected.

## Enable invalid bond modes

If one wish to configure Hosted-Engine with unsupported bond mode, it can be done by doing the following:               
 
1. create a config file e.g. /etc/ovirt-hosted-engine/my-config.conf with content:

```
[environment:default]
OVEHOSTED_NETWORK/allowInvalidBondModes=bool:True
```

2. create a env file e.g. /etc/ovirt-hosted-engine-setup.env.d/my-env.conf with content:

```
environment="APPEND:CORE/configFileAppend=str:/etc/ovirt-hosted-engine/my-config.conf"
```
