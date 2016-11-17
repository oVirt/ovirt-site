# Database Server Firewall Requirements

Red Hat Virtualization supports the use of a remote database server. If you plan to use a remote database server with Red Hat Virtualization then you must ensure that the remote database server allows connections from the Manager.

**Host Firewall Requirements**

| Port(s) | Protocol | Source | Destination | Purpose |
|-
| 5432    | TCP, UDP | Red Hat Virtualization Manager | PostgreSQL database server | Default port for PostgreSQL database connections. |

If you plan to use a local database server on the Manager itself, which is the default option provided during installation, then no additional firewall rules are required.
