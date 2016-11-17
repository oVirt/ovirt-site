# Storage Requirements

Hosts require local storage to store configuration, logs, kernel dumps, and for use as swap space. The minimum storage requirements of Red Hat Virtualization Host are documented in this section. The storage requirements for Red Hat Enterprise Linux hosts vary based on the amount of disk space used by their existing configuration but are expected to be greater than those of Red Hat Virtualization Host.

**Red Hat Virtualization Host Minimum Storage Requirements**

| /    | /boot | /var  | swap | Minimum Total |
|-
| 6 GB | 1 GB  | 15 GB | 1 GB | 23 GB |

**Important:** If you are also installing the RHV-M Virtual Appliance for self-hosted engine installation, the /var partition must be at least 60 GB.

For the recommended swap size, see [https://access.redhat.com/solutions/15244](https://access.redhat.com/solutions/15244).
