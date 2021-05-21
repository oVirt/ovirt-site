---
title: Hosted-Engine invalid bond modes
authors: irosenzw
---

# Hosted-Engine invalid bond modes

Some bond modes (0, 5, 6) cause problems in VM networks.
Therefore, when the user has to select network device, during the Hosted-engine deployment,
in version 4.2 or later,
bonds that are configured in these modes cannot be selected.

See also: [BZ 1233127](https://bugzilla.redhat.com/1233127).

## Enable invalid bond modes

If one wishes to enforce Hosted-Engine setup to allow unsupported bond modes, it can be done by doing the following:

1. Create a setup conf directory, if it does not already exist:

```
# mkdir -p /etc/ovirt-hosted-engine-setup.conf.d
```

2. Create a file in it, named e.g. 99-force-invalid-bond-modes.conf, with the following content:
```
[environment:default]
OVEHOSTED_NETWORK/allowInvalidBondModes=bool:True
```

3. Run ```hosted-engine --deploy``` as usual.

Alternatively, you can pass the option directly on the command line:
```
# hosted-engine --otopi-environment=OVEHOSTED_NETWORK/allowInvalidBondModes=bool:True --deploy
```
