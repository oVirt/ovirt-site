---
title: Using oVirt and Vagrant
author: myoung34
tags: community, documentation, howto, vagrant
date: 2017-02-10 21:00:00 CET
comments: true
published: true
---

Introducing oVirt virtual machine management via Vagrant.

In this short tutorial I'm going to give a brief introduction on how to use [vagrant](http://vagrantup.com) to manage oVirt with the new [community developed oVirt v4 Vagrant provider](http://www.github.com/myoung34/vagrant-ovirt4).

READMORE

## Background

Vagrant is a way to tool to create portable and reproducible environments. We can use it to provision and manage virtual machines in oVirt by managing a base box (small enough to fit in github as an artifact) and a Vagrantfile. The Vagrantfile is the piece of configuration that defines everything about the virtual machines: memory, cpu, base image, and any other configuration that is specific to the hosting environment.

## Prerequisites

* A fully working and configured oVirt cluster of any size
* A system capable of compiling and running the [oVirt ruby SDK gem](http://github.com/ovirt/ovirt-engine-sdk-ruby)
* Vagrant 1.8 or later
* The oVirt vagrant plugin installed via `$ vagrant plugin install vagrant-ovirt4`

## The Vagrantfile

To start off, I'm going to use this Vagrantfile:

```ruby
Vagrant.configure("2") do |config|
  config.vm.box = 'ovirt4'
  config.vm.hostname = "test-vm"
  config.vm.box_url = 'https://github.com/myoung34/vagrant-ovirt4/blob/master/example_box/dummy.box?raw=true'

  config.vm.network :private_network,
    :ip => '192.168.56.100', :nictype => 'virtio', :netmask => '255.255.255.0', #normal network configuration
    :ovirt__ip => '192.168.2.198', :ovirt__network_name => 'ovirtmgmt', :ovirt__gateway => '192.168.2.125' # oVirt specific information, overwrites previous on oVirt provider

  config.vm.provider :ovirt4 do |ovirt|
    ovirt.url = 'https://ovirt/ovirt-engine/api'
    ovirt.username = "admin@internal"
    ovirt.password = "mypassword"
    ovirt.insecure = true
    ovirt.debug = true
    ovirt.cluster = 'Default'
    ovirt.template = 'vagrant-centos7'
    ovirt.console = 'vnc'
  end
end
```

In the configuration file, there are some pieces on which to elaborate. The URL, password, and username should be self-explanatory. The `config.vm.network` block has some special mappings (prefixed by `ovirt__`) so that it can be used in any provider, as well as oVirt. Vagrantfiles can manage lifecycles across providers, which is why the oVirt-specific mappings are in a `config.vm.provider :ovirt4` configuration block as well.

Within our `ovirt4` configuration section, we have set SSL verify to off (to allow self-signed certificates), the cluster is set to `Default` (and available in the oVirt UI), and the template to use as a starting point is `vagrant-centos7`.

The base template will need to be created per your environment, but a starting helper script for redhat based distributions such as CentOS [is available here](https://github.com/myoung34/vagrant-ovirt4/blob/master/tools/prepare_redhat_for_box.sh). It basically installs some base packages like the oVirt agent but also sets up a local user `vagrant` inside the VM that is required to proceed. Please read through it carefully.

## Getting to it

In the directory where the `Vagrantfile` lives, we can create and start a VM.

```sh
$ vagrant up
Bringing machine 'default' up with 'ovirt4' provider...
==> default: Creating VM with the following settings...
==> default:  -- Name:          test-vm
==> default:  -- Cluster:       Default
==> default:  -- Template:      vagrant-centos7
==> default:  -- Console Type:  vnc
==> default: Waiting for VM to become "ready" to start...
==> default: Starting VM.
==> default: Waiting for VM to get an IP address...
==> default: Machine is booted and ready for use!
==> default: Rsyncing folder: /home/vagrant/ => /vagrant
==> default: Setting hostname...
    default:
    default: Vagrant insecure key detected. Vagrant will automatically replace
    default: this with a newly generated keypair for better security.
    default:
    default: Inserting generated public key within guest...
    default: Removing insecure key from the guest if it's present...
    default: Key inserted! Disconnecting and reconnecting using new SSH key...
```

If you look in oVirt we now have a virtual machine named `test-vm` running.

![vagrant vm listed](vagrant-ovirt-up-1.png)

We can do things such as manage snapshots:

```sh
$ vagrant snapshot list
==> default: Retrieving list of snapshots...
id     description     date

$ vagrant snapshot save somename
==> default: Creating snapshot...

$ vagrant snapshot list
==> default: Retrieving list of snapshots...
                                  id     description                          date
3dd34cbf-4698-446f-82bb-00ac66931411        somename     2017-02-10T05:34:53-06:00

$ vagrant snapshot delete 3dd34cbf-4698-446f-82bb-00ac66931411
==> default: Deleting snapshot...

$ vagrant snapshot list
==> default: Retrieving list of snapshots...
id     description     date
```

We can SSH into the box or run commands via SSH:


```sh
$ vagrant ssh
Last login: Wed Feb  8 21:27:23 2017 from marc-pc

$ hostname
test-vm
$ logout
Connection to 192.168.2.238 closed.

$ vagrant ssh -c 'hostname; whoami'
test-vm
vagrant
Connection to 192.168.2.238 closed.

```

We can also run [provisioners](https://www.vagrantup.com/docs/provisioning/) against the machine. Add this to your Vagrantfile:

```ruby
  config.vm.provision "shell",
    inline: "whoami >> /home/vagrant/somefile"
```

Now let's see what happens when we use it:

```sh
$ vagrant provision
==> default: Rsyncing folder: /home/vagrant/ => /vagrant
==> default: Running provisioner: shell...
    default: Running: inline script

$ vagrant ssh -c 'cat ~/somefile'
root
Connection to 192.168.2.238 closed.
```

Lastly, we can tear down the VM and all of its artifacts:

```sh
$ vagrant destroy -f
==> default: Halting VM...
==> default: Waiting for VM to shutdown...
==> default: Removing VM...
```
