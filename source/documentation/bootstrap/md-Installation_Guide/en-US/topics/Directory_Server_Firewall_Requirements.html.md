# Directory Server Firewall Requirements

Red Hat Virtualization requires a directory server to support user authentication. A number of ports must be opened in the directory server's firewall to support GSS-API authentication as used by the Red Hat Virtualization Manager.

**Host Firewall Requirements**

| Port(s)  | Protocol | Source | Destination | Purpose |
|-
| 88, 464  | TCP, UDP | Red Hat Virtualization Manager | Directory server | Kerberos authentication. |
| 389, 636 | TCP      | Red Hat Virtualization Manager | Directory server | Lightweight Directory Access Protocol (LDAP) and LDAP over SSL. |
