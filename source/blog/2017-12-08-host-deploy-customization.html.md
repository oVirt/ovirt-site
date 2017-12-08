---
title: Customizing the host deploy process
author: omachace
tags: Ansible, Automation, Configuration management, host-deploy, firewalld
date: 2017-12-08 15:00:00 CET
comments: true
published: true
---

In 4.2 release we have introduced a possibility to customize the host-deploy process by running the Ansible post-tasks after the host-deploy process successfully finishes.

READMORE

## The reason
Prior to oVirt 4.2 release administrators could customize host's firewall rules using `engine-config` option `IPTablesConfigSiteCustom`.
Unfortunately writing custom `iptables` rules into string value to be used in `engine-config` was very user unfriendly and using `engine-config` to provide custom
`firewalld` rules would be even much worse. Because of above we have introduced Ansible integration as a part of host deploy flow, which allows administrators to
add any custom actions executed on the host during host deploy flow.

## Special tasks file

As part of this role we also include additional tasks, which could be written by the user, to modify the host-deploy
process for example to open some more FirewallD ports.

Those additional tasks can be added to following file:

```
/etc/ovirt-engine/ansible/ovirt-host-deploy-post-tasks.yml
```

This post-task file is executed as part of host-deploy process just before setup network invocation.

## Example
An example post-tasks file is provided by ovirt-engine installation, at following location:

```
/etc/ovirt-engine/ansible/ovirt-host-deploy-post-tasks.yml.example
```

This is just an example file, to add some task into host deploy flow, you need to create below mentioned file and add some proper Ansible custom tasks:


```
$ touch /etc/ovirt-engine/ansible/ovirt-host-deploy-post-tasks.yml
```

Now let's add some tasks which should be executed on the host.
Note that you can call any Ansible task, not only firewalld task.

```bash
$ cat << EOF >> /etc/ovirt-engine/ansible/ovirt-host-deploy-post-tasks.yml
> ---
> - name: Enable custom firewall port
>   firewalld:
>     port: "12345/tcp"
>     permanent: yes
>     immediate: yes
>     state: enabled
>
> - name: Print debug information
>   debug:
>     msg: "My custom tasks was successfully executed!"
> EOF
```

When you add new host or reinstall an existing host, you may see the installation logs in `/var/log/ovirt-engine/host-deploy/` directory.
Ansible specific log files has `-ansible` suffix. In events view you can see relevant log file path for the specific host installation or
reinstallation.

Note that host's firewall type `iptables` is deprecated in version 4.2 and will be removed in version 4.3
