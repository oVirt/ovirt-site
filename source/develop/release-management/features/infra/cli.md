---
title: CLI
category: cli
authors: j.bittner, jfenal, mgoldboi, michael pasternak, tsaban, val0x00ff
---

> **`ovirt-shell` is Deprecated**: It uses the v3 REST API, and lacks all features available since oVirt 4.0. 
Consider using Ansible as a replacement for automation purposes.

# CLI

oVirt CLI is a dynamic, runtime interface discovering command line interface for the oVirt engine

__TOC__

## Concepts

*   dynamic interface that can work against any version of sdk discovering it at runtime
*   Interactive prompt
*   Smart auto-completion
*   Smart help
*   Generic interface (list, show, add, update, action verbs).
*   Self descriptive.

## Usage

### Help

#### syntax

*   note help is dynamically created for each command respectively

       help
       
       or
       
       help `<command>` [arguments] [options]

### Auto-Completion

#### available commands

```
[oVirt shell (connected)]# <TAB><TAB>
EOF         clear       console     remove      echo        help        ping        
show        update      action      connect     add         disconnect
exit        list        shell       status
```

#### available options for specific command

```
[oVirt shell (connected)]# add <TAB><TAB>
cdrom          datacenter     group          network        permission     role           storagedomain  template       vm
cluster        disk           host           nic            permit         snapshot       tag            user           vmpool
```

#### available options for command on specific resource

```
[oVirt shell (connected)]# add vm <TAB><TAB>
cluster-id                               display-type                             os-boot-dev                              template-id
cluster-name                             domain-name                              os-cmdline                               template-name
cpu-topology-cores                       high_availability-enabled                os-initRd                                timezone
cpu-topology-sockets                     high_availability-priority               os-kernel                                type
custom_properties-custom_property        memory                                   os-type                                  usb-enabled
description                              name                                     placement_policy-affinity                
display-monitors                         origin                                   stateless
```

#### available options for command on specific sub-resource

```
[oVirt shell (connected)]# add nic --vm-identifier xxx `<TAB><TAB>` 
interface     mac-address   name          network-id    network-name
```

*   note typing beginning of the option name and then hitting <TAB>, will convert

option to appropriate option format adding prefix or suffix.

### Connect

#### get help for connect

```
[mpastern@ovirt-engine-cli (master)]$ ovirt-shell --help

Usage: ovirt-shell [options]
       ovirt-shell [options] command...
This program is a command-line interface to oVirt Virtualization.
Options:
 -h, --help            show this help message and exit
 -l URL, --url=URL     specifies the API entry point URL
                       (http[s]://server[:port]/api)
 -u USERNAME, --username=USERNAME
                       connect as this user
 -K KEY_FILE, --key-file=KEY_FILE
                       specify client PEM key-file
 -C CERT_FILE, --cert-file=CERT_FILE
                       specify client PEM cert-file
 -A CA_FILE, --ca-file=CA_FILE
                       specify server CA cert-file
 -I, --insecure        allow connecting to SSL sites without certificates
 -F, --filter          enables user permission based filtering
 -P PORT, --port=PORT  specify port
 -T TIMEOUT, --timeout=TIMEOUT
                       specify timeout
 -c, --connect         automatically connect
 -f FILE, --file=FILE  read commands from FILE instead of stdin
```

#### connect from ovirt-shell

```
[mpastern@ovirt-engine-cli (master)]$ ovirt-shell

 ++++++++++++++++++++++++++++++++++++++++++

           Welcome to oVirt shell

 ++++++++++++++++++++++++++++++++++++++++++

[oVirt shell (disconnected)]# connect --url "`[`http://server:8080/api`](http://server:8080/api)`" --user "user@domain" --password 'password'

==========================================
>>> connected to oVirt manager 3.2.0.0 <<<
==========================================

[oVirt shell (connected)]# 
```

#### connect from linux shell

##### configuration file based login

1. `vi ~/.ovirtshellrc`

2. set args:

```
[ovirt-shell]
username = user@domain
url = http[s]://server[:port]/api
#insecure = False
#filter = False
#timeout = -1
password = ******
```
* NOTE: if `url/username/password` is not configured/commented in `.ovirtshellrc`
    and `ovirt-shell` executed in `auto-connect` mode (`ovirt-shell -c/--connect`), 
    you will be prompted to specify it upon login

3. run `ovirt-shell`

```
[mpastern@ovirt-engine-cli (master)]$ ovirt-shell -c

==========================================
>>> connected to oVirt manager 3.2.0.0 <<<
==========================================
++++++++++++++++++++++++++++++++++++++++++

       Welcome to oVirt shell

++++++++++++++++++++++++++++++++++++++++++
[oVirt shell (connected)]# 
```

##### cli options based login

```
[mpastern@ovirt-engine-cli (master)]$ ovirt-shell -c -l "`[`http://server:8080/api`](http://server:8080/api)`" -u "user@domain"
Password: ****
==========================================
>>> connected to oVirt manager 3.1.0.0 <<<
==========================================

++++++++++++++++++++++++++++++++++++++++++

     Welcome to oVirt shell

++++++++++++++++++++++++++++++++++++++++++


[oVirt shell (connected)]# 
```

### Querying

#### list

##### list resources

```
[oVirt shell (connected)]# list vms

id         : aa849efc-4194-4b00-b274-ab32d4c222c9
name       : aa

id         : 7b4ebc3f-40ba-4eb3-94ef-ca222d62fbe6
name       : demo

[oVirt shell (connected)]# list vms --show-all

id                        : aa849efc-4194-4b00-b274-ab32d4c222c9
name                      : aa
cluster-id                : e8861726-0b88-11e1-bd8c-27fb0a7aaa76
cpu-topology-cores        : 1
cpu-topology-sockets      : 1
creation_time             : 2012-02-16T20:00:50.859+02:00
display-monitors          : 1
display-type              : spice
high_availability-enabled : False
high_availability-priority: 1
memory                    : 1073741824
memory_policy-guaranteed  : 1073741824
origin                    : ovirt
os-boot-dev               : hd
os-type                   : unassigned
placement_policy-affinity : migratable
start_time                : 2012-02-29T13:36:27.880Z
stateless                 : False
status-state              : down
template-id               : 9c42b69e-daa3-48d7-bf97-779603892f15
type                      : desktop
usb-enabled               : True

id                        : 7b4ebc3f-40ba-4eb3-94ef-ca222d62fbe6
name                      : demo
cluster-id                : e8861726-0b88-11e1-bd8c-27fb0a7aaa76
cpu-topology-cores        : 1
cpu-topology-sockets      : 1
creation_time             : 2012-02-16T11:15:56.014+02:00
display-address           : 10.35.1.127
display-monitors          : 1
display-type              : vnc
high_availability-enabled : False
high_availability-priority: 1
memory                    : 1073741824
memory_policy-guaranteed  : 1073741824
origin                    : ovirt
os-boot-dev               : hd
os-type                   : unassigned
placement_policy-affinity : migratable
start_time                : 2012-02-29T13:36:27.887Z
stateless                 : False
status-state              : down
template-id               : 9c42b69e-daa3-48d7-bf97-779603892f15
type                      : desktop
```

*   notice: `--show-all` option extends listed entities (default mode is collapsed).

##### list resources using oVirt query engine filtering

```
[oVirt shell (connected)]# list vms --query "name=demo"

id         : 7b4ebc3f-40ba-4eb3-94ef-ca222d62fbe6
name       : demo
```

##### list resources using client side filtering

```
[oVirt shell (connected)]# list vms --kwargs "memory=1073741824"

id         : aa849efc-4194-4b00-b274-ab32d4c222c9
name       : aa

id         : 7b4ebc3f-40ba-4eb3-94ef-ca222d62fbe6
name       : demo

id         : f4a51ae1-4f31-45ee-ab6d-d5965e3bcf71
name       : iscsi_desktop
description: myvm

id         : fea05ded-c246-4e51-885e-fef33a7ef2ad
name       : pythond_sdk_poc2
```

##### list sub-resources

```
[oVirt shell (connected)]# list disks --vm-identifier nfs_desktop

id         : 889bad90-6efa-42c5-a545-d0ce2033218d
name       : Disk 2

id         : 7a014754-a10e-42b3-91ff-6a325043f9b0
name       : Disk 4

id         : 4d267464-e126-45fa-8e42-381e2f82354a
name       : Disk 1

id         : b007747c-ad99-4c03-a318-42ad502afb23
name       : Disk 3

[oVirt shell (connected)]# list nics --vm-identifier demo

id         : fbc1f30f-7c21-44e7-9c0a-7e4ffb57fcb4
name       : nic3

id         : 1f295a64-0a4a-4fba-928d-162b458503a5
name       : nic1

id         : 7ba3c79c-c619-422f-9035-6b5c8e5ea9e6
name       : nic2
```

*   note: ether id or name can be used as `--resource-identifier`

##### list sub-resources using client side filtering

```
[oVirt shell (connected)]# list disks --vm-identifier nfs_desktop --kwargs "name=Disk 3"

id         : b007747c-ad99-4c03-a318-42ad502afb23
name       : Disk 3

[oVirt shell (connected)]# list vms --kwargs "usb-enabled=True"

id         : aa849efc-4194-4b00-b274-ab32d4c222c9
name       : aa

id         : 7b4ebc3f-40ba-4eb3-94ef-ca222d62fbe6
name       : demo
```

*   note: ether id or name can be used as --resource-identifier

#### show

##### show resource

```
[oVirt shell (connected)]# show vm demo

id                        : 7b4ebc3f-40ba-4eb3-94ef-ca222d62fbe6
name                      : demo
cluster-id                : e8861726-0b88-11e1-bd8c-27fb0a7aaa76
cpu-topology-cores        : 1
cpu-topology-sockets      : 1
creation_time             : 2012-02-16T11:15:56.014+02:00
display-address           : 10.35.1.127
display-monitors          : 1
display-type              : vnc
high_availability-enabled : False
high_availability-priority: 1
memory                    : 1073741824
memory_policy-guaranteed  : 1073741824
origin                    : ovirt
os-boot-dev               : hd
os-type                   : unassigned
placement_policy-affinity : migratable
start_time                : 2012-02-29T13:55:15.443Z
stateless                 : False
status-state              : down
template-id               : 9c42b69e-daa3-48d7-bf97-779603892f15
type                      : desktop
usb-enabled               : True

[oVirt shell (connected)]# show vm --name nfs_desktop

id                        : e0adee2b-2c95-483e-8259-2d8b29aa414d
name                      : nfs_desktop
description               : updated_desc
cluster-id                : f16a5ea6-0b88-11e1-9844-bb5eb66ca68b
cpu-topology-cores        : 1
cpu-topology-sockets      : 1
creation_time             : 2011-11-10T14:12:09.379+02:00
display-address           : 0
display-monitors          : 1
display-type              : spice
high_availability-enabled : False
high_availability-priority: 1
memory                    : 536870912
memory_policy-guaranteed  : 536870912
origin                    : rhev
os-boot-dev               : hd
os-type                   : rhel_6x64
placement_policy-affinity : migratable
start_time                : 2012-02-29T13:55:56.448Z
stateless                 : False
status-state              : down
template-id               : 00000000-0000-0000-0000-000000000000
type                      : desktop
usb-enabled               : True
```

##### show resource using client side filtering

```
[oVirt shell (connected)]# show vm --id f4a51ae1-4f31-45ee-ab6d-d5965e3bcf71

id                        : f4a51ae1-4f31-45ee-ab6d-d5965e3bcf71
name                      : iscsi_desktop
description               : myvm
cluster-id                : e8861726-0b88-11e1-bd8c-27fb0a7aaa76
cpu-topology-cores        : 1
cpu-topology-sockets      : 1
creation_time             : 2012-01-04T13:27:05.266+02:00
display-monitors          : 4
display-type              : spice
high_availability-enabled : True
high_availability-priority: 7
memory                    : 1073741824
memory_policy-guaranteed  : 1073741824
origin                    : rhev
os-boot-dev               : hd
os-type                   : unassigned
placement_policy-affinity : migratable
start_time                : 2012-02-29T13:57:07.096Z
stateless                 : False
status-state              : down
template-id               : 9c42b69e-daa3-48d7-bf97-779603892f15
type                      : desktop
usb-enabled               : True
```

##### show sub-resource

```
[oVirt shell (connected)]# show nic nic1 --vm-identifier demo

id         : 1f295a64-0a4a-4fba-928d-162b458503a5
name       : nic1
interface  : virtio
mac-address: 00:1a:4a:16:01:68
network-id : d85a5cb2-057b-40ec-8d9c-b4ee6a7646c4
vm-id      : 7b4ebc3f-40ba-4eb3-94ef-ca222d62fbe6
```

### Add

#### add resource

```
[oVirt shell (connected)]# add vm --name demo2 --template-name iscsi_desktop_tmpl --cluster-name Default_iscsi

id                        : dd981334-afb7-4142-a880-536bb8aef53f
name                      : demo2
cluster-id                : e8861726-0b88-11e1-bd8c-27fb0a7aaa76
cpu-topology-cores        : 1
cpu-topology-sockets      : 1
creation_status-state     : pending
creation_time             : 2012-02-29T16:01:57.896+02:00
display-monitors          : 1
display-type              : spice
high_availability-enabled : False
high_availability-priority: 1
memory                    : 1073741824
memory_policy-guaranteed  : 1073741824
origin                    : ovirt
os-boot-dev               : hd
os-type                   : unassigned
placement_policy-affinity : migratable
start_time                : 2012-02-29T14:02:01.533Z
stateless                 : False
status-state              : image_locked
template-id               : 9c42b69e-daa3-48d7-bf97-779603892f15
type                      : desktop
usb-enabled               : True

[oVirt shell (connected)]# add datacenter --name mydc --storage_type nfs --version-major 3 --version-minor 1

id                              : 4c490b43-e681-49d8-958c-9300787982eb
name                            : mydc
status-state                    : uninitialized
storage_type                    : nfs
supported_versions-version-major: 3
supported_versions-version-minor: 1
version-major                   : 3
version-minor                   : 1
```

#### add sub-resource

```
[oVirt shell (connected)]# add nic --vm-identifier demo2 --network-name engine --name mynic

id         : a211d8bb-8abb-429b-8d36-fc4eb44b6ea8
name       : mynic
interface  : virtio
mac-address: 00:1a:4a:16:01:5a
network-id : d85a5cb2-057b-40ec-8d9c-b4ee6a7646c4
vm-id      : dd981334-afb7-4142-a880-536bb8aef53f
```

### Remove

#### remove resource

```
[oVirt shell (connected)]# remove vm aa
```

#### remove sub-resource

```
[oVirt shell (connected)]# remove disk "Disk 1" --vm-identifier demo2
```

*   note: ether id or name can be used as --resource-identifier

### Update

*   note: You have to quote the description if it contains spaces. E.g. "iscsi_desktop desc"

#### update resource

```
[oVirt shell (connected)]# update vm iscsi_desktop --description iscsi_desktop_desc

id                        : f4a51ae1-4f31-45ee-ab6d-d5965e3bcf71
name                      : iscsi_desktop
description               : iscsi_desktop_desc
cluster-id                : e8861726-0b88-11e1-bd8c-27fb0a7aaa76
cpu-topology-cores        : 1
cpu-topology-sockets      : 1
creation_time             : 2012-01-04T13:27:05.266+02:00
display-monitors          : 4
display-type              : spice
high_availability-enabled : True
high_availability-priority: 7
memory                    : 1073741824
memory_policy-guaranteed  : 1073741824
origin                    : rhev
os-boot-dev               : hd
os-type                   : unassigned
placement_policy-affinity : migratable
start_time                : 2012-02-29T14:08:15.353Z
stateless                 : False
status-state              : down
template-id               : 9c42b69e-daa3-48d7-bf97-779603892f15
type                      : desktop
usb-enabled               : True

[oVirt shell (connected)]# update vm iscsi_desktop --display-monitors 2 --description test1

id                        : f4a51ae1-4f31-45ee-ab6d-d5965e3bcf71
name                      : iscsi_desktop
description               : test1
cluster-id                : e8861726-0b88-11e1-bd8c-27fb0a7aaa76
cpu-topology-cores        : 1
cpu-topology-sockets      : 1
creation_time             : 2012-01-04T13:27:05.266+02:00
display-monitors          : 2
display-type              : spice
high_availability-enabled : True
high_availability-priority: 7
memory                    : 1073741824
memory_policy-guaranteed  : 1073741824
origin                    : rhev
os-boot-dev               : hd
os-type                   : unassigned
placement_policy-affinity : migratable
start_time                : 2012-02-29T14:11:13.357Z
stateless                 : False
status-state              : down
template-id               : 9c42b69e-daa3-48d7-bf97-779603892f15
type                      : desktop
usb-enabled               : True
```

#### update sub-resource

```
[oVirt shell (connected)]# update nic nic1 --vm-identifier demo --interface virtio

id         : 1f295a64-0a4a-4fba-928d-162b458503a5
name       : nic1
interface  : virtio
mac-address: 00:1a:4a:16:01:68
network-id : d85a5cb2-057b-40ec-8d9c-b4ee6a7646c4
vm-id      : 7b4ebc3f-40ba-4eb3-94ef-ca222d62fbe6
```

### Action

#### action on resource

```
[oVirt shell (connected)]# action vm demo start --vm-display-type vnc --async true
error: 
status: 400
reason: Bad Request
detail: [Cannot run VM. Low disk space on relevant Storage Domain.]
```

#### action on sub-resource

```
[oVirt shell (connected)]# action nic bond0 attach --host-identifier grey-vdsa
error: 
status: 400
reason: Bad Request
detail: Action [network.id|name] required for attach
```

### Console

#### connect to vm using vm name

```
console 'my_vm'
```

#### connect to vm using vm id

```
console '7dff8517-7007-42cd-9cf7-b7a13a9d96b7'
```

### Scripting

#### Writing a script

##### Format

no special format, just commands in plain text

```
less /home/mpastern/script
--------------------------

list vms
show vm test | grep status
list vms --query "name=test*" --show-all | grep status
list clusters
list datacenters
...
```

#### Executing script

##### From linux shell

```
[mpastern@lp /]#  ovirt-shell -f /home/mpastern/script
```

##### From ovirt shell

```
[oVirt shell (connected)]# file /home/mpastern/script
```

#### Examples

##### Run all vms

###### The script

1. the script (less run_all_vms.txt) will look like:

```
list vms | grep name | sed s/'name       :'/'action vm'/ | sed -e 's/$/ start/' > /home/mpastern/new_script_to_run
       file /home/mpastern/new_script_to_run
```

2. run the script

```
[RHEVM shell (connected)]# file /home/mpastern/run_all_vms
```

###### Explanations

1. run rhevm command and process the output saving it in to temp script new_script_to_run

```
list vms | grep name | sed s/'name       :'/'action vm'/ | sed -e 's/$/ start/' > /home/mpastern/new_script_to_run
```

2. invoke temp script internally at runtime

```
file /home/mpastern/new_script_to_run
```

## Tweaks

### disable pagination

at `/home/user/.ovirtshellrc` change `autopage` to `False`

## Deployment

### pypi

<http://pypi.python.org/pypi/ovirt-shell>

```
easy_install ovirt-shell
```

### rpm

To build rpm and install it, from ovirt-engine-cli repo:

```
yum install -y rpm-build python-devel python-setuptools python-kitchen

make rpm

yum localinstall rpmtop/RPMS/noarch/ovirt-engine-cli-x.y-z.noarch.rpm
```

Because lxml is not yet packaged, please follow the instructions below to get lxml installed.

### development deployment

For local install in site-packages, from ovirt-engine-cli repo:

```
yum install python-ply libxml2-devel libxslt-devel pexpect python-kitchen
python setup.py develop
```

That will install lxml, because EPEL's python-lxml is not yet up to the version required by CLI.

*   note: both deployment procedures require super-user permissions

## TODO list

[Bugzila](https://bugzilla.redhat.com/buglist.cgi?list_id=6860&classification=Community&query_format=advanced&bug_status=NEW&bug_status=ASSIGNED&component=ovirt-engine-cli&classificiation=oVirt)


## Maintainers

Michael Pasternak: mishka8520@yahoo.com, Juan Hernandez: juan.hernandez@redhat.com

