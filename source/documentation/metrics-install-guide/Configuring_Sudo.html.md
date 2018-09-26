# Configuring Sudo

**Configure sudo not to require a tty**

Create a file under */etc/sudoers.d/*, for example *999-cloud-init-requiretty*, and add `Defaults !requiretty` to the file.

For example:

```
# cat /etc/sudoers.d/999-cloud-init-requiretty
Defaults !requiretty
```

