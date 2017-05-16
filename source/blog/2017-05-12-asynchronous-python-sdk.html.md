---
title: Be asynchronous with Python SDK
author: omachace
date: 2017-05-12 08:00:00 UTC
tags: ovirt, python, sdk, pipelining, async, api
comments: false
published: false
---

Python SDK version 4.1.4 introduced support for sending asynchronous requests and HTTP pipelining. In this blog post we will explain those terms and we will show you an example how to use the Python SDK in asynchronous manner.

## Asynchronous requests

In order to the SDK to to work in an asynchronous fashion, we introduces two new features to our SDK, multiple connections and HTTP pipelining.
This can bring the value when user want to fetch the inventory of the oVirt system. The time to fetch the inventory may be significantly decresed.
You can see some comparison of the synchronous and asynchronous requests below.

### Multiple connections

Previously the SDK used only one opened connection which sequentially send the requests according to user program and always waited for the server response for corresponding request.
In new version of the SDK the user can specify the number of connections the SDK should create to the server, and the specific requests created by user program use one of the connections.

### HTTP pipelining

As you can see at the image below, the HTTP requests are executed sequentially by default. The next request in order can be executed, when the previous request is received.
With HTTP Pipelining client can send multiple requests without waiting for ther server response. Only idempotent HTTP methods can be pipelined.

```
With pipelining disabled            With pipelining enabled

       |     |                            |      |
       | \   |                            | \    |
       |  \  |                            |  \   |
       |   \ |                            | \ \  |
       |    \|                            |  \ \ |
       |    /|                            |   \ \|
       |   / |                            |    \/| 
       |  /  |                            |    /\|
CLIENT | /   | SERVER              CLIENT |   / /| SERVER
       | \   |                            |  / / |
       |  \  |                            | / /  |
       |   \ |                            |/ /   |
       |    \|                            | /    |
       |    /|                            |      |
       |   / |                            
       |  /  |                            
       | /   |                            
```

## SDK implementation

To not break the backward compatibility of the SDK, we have introduced a new boolean parameter called ```wait```, to the methods of SDK services.
The default values is ```True```, so it's working in synchronous fashion. If the user send the ```wait=False```, the SDK will send a request specified by user program and will return the ```Future``` object,
which is defined as follows:

```python
class Future(object):
    """
    Instances of this class are returned for operations that specify the
    `wait=False` parameter.
    """

    def wait(self):
        """
        Waits till the result of the operation that created this future is
        available.
        """
```

So in order to wait for the response user need to call the ```wait``` method, which will return the resultion object.

## Example

```python
import ovirtsdk4 as sdk

connection = sdk.Connection(
    url='https://example.engine.com/ovirt-engine/api',
    username='admin@internal',
    password='123456',
    ca_files='ca.pem',
    connections=5,
    pipeline=5,
)

system_service = connection.system_service()

vms_service = system_service.vms_service()
vms = system_service.vms_service().list()

futures = {}
for vm in vms:
    vm_service = vms_service.vm_service(vm.id)
    disks_future = vm_service.disk_attachments_service().list(wait=False)
    nics_future = vm_service.nics_service().list(wait=False)
    perms_future = vm_service.permissions_service().list(wait=False)
    futures[vm.name] = [disks_future, nics_future, perms_future]

for vm_name, vm_resources in futures.iteritems():
    for resource in vm_resources:
        resource.wait()

connection.close()
```

You can check another [example] in git repository of Python SDK.

## Benchmark

I did small benchmark on my small oVirt setup with about 100 Virtual machines and
executed the example above, with following result:

```bash
omachace ~ $ time python sync.py 

real	0m4.746s
user	0m4.109s
sys	  0m0.447s

omachace ~ $ time python async.py 

real	0m2.569s
user	0m2.015s
sys	  0m0.179s
```

[example]: https://github.com/oVirt/ovirt-engine-sdk/blob/master/sdk/examples/asynchronous_inventory.py
