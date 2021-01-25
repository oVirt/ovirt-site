---
title: engineCli
authors: hateya
---

# engine Cli

## Create a Basic Environment using engine-cli (ovirt-shell)

In order to connect to ovirt-engine using the ovirt-shell, (CLI api which uses REST-API), the following details are required:

*   URL - The URL consists of http method, ovirt-engine's ip, ovirt-engine's port and the api's entry point. The http method and and port are usually https/8443 for secure connection (default), or http/8080 for insecure connection. The insecure connection is usually used in development environments. The api's entry point is fixed - "/api"

<!-- -->

*   User/Password - The user consists of username, the "@" sign and domain name. You can use both either the internal user's account or any of your LDAP users that has login permissions and of course permissions to perform your requests.

<!-- -->

*   The following commands will connect you to the interactive shell:

```bash
         # ovirt-shell
         # (disconnected) > connect "http://localhost:8080/api" "user@domain" "password"
         # [oVirt-shell:connected]#
```

*   Once you are connected to the shell, you can simply run '`help`', which will revel some of the following options:

```
       AVAILABLE COMMANDS
       
         * action           execute an action on an object
         * cd               change directory
         * clear            clear the screen
         * connect          connect to a oVirt manager
         * console          open a console to a VM
         * create           create a new object
         * delete           delete an object
         * disconnect       disconnect from oVirt manager
         * exit             quit this interactive terminal
         * getkey           dump private ssh key
         * help             show help
         * list             list or search objects
         * ping             test the connection
         * pwd              print working directory
         * save             save configuration variables
         * set              set a configuration variable
         * show             show one object
         * status           show status
         * update           update an object
```

Below you can find an example ovirt-engine-sdk for the following steps:

*   Create iSCSI Data Center
*   Create Cluster
*   Install Host
*   Create iSCSI Storage Domain on Data Center
*   Attach ISO domain to Data Center
*   Attach Export domain to Data Center
*   Create VM with one NIC and one Disk
*   Start/hibernate/resume/stop vm
*   Export vm (into Export Domain)
*   Delete vm
*   Import vm (from Export Domain)
*   Create a snapshot to vm
*   Create a Template from VM
*   Create VM from Template

<!-- -->

*   Create iSCSI Data Center:
