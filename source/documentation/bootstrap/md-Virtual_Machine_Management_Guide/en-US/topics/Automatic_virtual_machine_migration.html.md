# Automatic Virtual Machine Migration

Red Hat Virtualization Manager automatically initiates live migration of all virtual machines running on a host when the host is moved into maintenance mode. The destination host for each virtual machine is assessed as the virtual machine is migrated, in order to spread the load across the cluster.

The Manager automatically initiates live migration of virtual machines in order to maintain load balancing or power saving levels in line with scheduling policy. While no scheduling policy is defined by default, it is recommended that you specify the scheduling policy which best suits the needs of your environment. You can also disable automatic, or even manual, live migration of specific virtual machines where required.

