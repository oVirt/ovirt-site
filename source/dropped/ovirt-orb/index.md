---
title: oVirt Orb
category: documentation
toc: true
---

# oVirt Orb

`oVirt Orb` lets you try out oVirt on your own laptop. You can
test it and play with it, all without the need to manually
install all the components or use multiple hosts or a storage
server. `oVirt Orb` is based on the Lago framework and runs the
whole oVirt environment on a single machine by creating a
number of VMs. VMs that play as hypervisors can run nested VMs.

`oVirt Orb` ships pre-baked VM images and a `LagoInitFile` that
tells Lago how to use them. The images are built by the
`build-artifacts` job of the [ovirt-demo-tool](https://gerrit.ovirt.org/#/q/project:ovirt-demo-tool).

## Requirements

- Operating System:

  Currently, Orb can run on either supported Fedora versions or Centos 7.

- CPU:

  Orb is currently supported on Intel's CPUs. The CPU model should be Sandy Bridge or newer.

- Disk Space:

  Orb requires that you have at least 7GB of free space wherever you are running it.

- Memory:

  Orb requires that your system will have at least 8GB of RAM.

## Installing requirements

In order to run the `oVirt Orb`, you will need first to install Lago and some more dependencies:
- [Lago project](http://lago.readthedocs.io/en/latest/Installation.html).

  Lago is the framework that provides the basis for running all the required machines for our environment.
  We'll later feed it with the configuration and pre-built images of the machines, but first we need to install it.
- [oVirt Lago plugin](http://lago-ost-plugin.readthedocs.io/en/latest/Installation.html).

  This Lago plugin makes Lago aware of oVirt specifics.
- [oVirt Python SDK](https://pypi.python.org/pypi/ovirt-engine-sdk-python).

  The oVirt Python SDK allows code written in Python to easily work with oVirt Engine.
  This SDK is used extensively by oVirt Lago plugin

## Getting oVirt Orb
- Download `oVirt Orb`:

  Current latest `oVirt Orb` images are based on latest oVirt 4.3 release and can be downloaded from [here](http://resources.ovirt.org/pub/ovirt-4.3/ovirt-orb/).
  You will need to download both the `ovirt-orb-*.tar.xz` and `ovirt-orb-*.tar.xz.md5`
- Verify that archive is not broken or tampered with:

      $ md5sum -c ovirt-orb-[oVirt Orb version].tar.xz.md5
      ovirt-orb-[oVirt Orb version].tar.xz: OK

- Extract the archive:

      $ cd orb-dir
      $ tar xf ovirt-orb-[oVirt Orb version].tar.xz

## Running the environment

Please note: All commands must be run from the inside of the directory created by the extraction of the oVirt Orb archive!

    $ lago init          # bootstrap lago
    $ lago ovirt start   # start virtual hosts and Engine

After a few seconds, you should see oVirt engine's IP, username, and password:

    The environment is ready to be used.
    You can access the web UI with the following link and credentials:
    https://192.168.202.4
    Username: admin
    Password: 123

You can enter oVirt Engine's web UI by browsing to the supplied
URL. You may need to add an exception for your browser to trust
the self-signed certificate created by Lago.

You can use Lago to save a snapshot of your environment and to revert to it later

    $ lago snapshort nice_state
    ... some possibly-destructive modifcation to your environment
    $ lago revert nice_state

As of version 4.2.2, the environment starts up three VMs; one
for Engine and storage, and two others for virtual hypervisors,
interconnected via several virtual networks. The precise make
of the environment may change in the future.

### Stopping the environment

    lago ovirt stop    # stop ovirt and the virtual hosts that run it
    lago destroy       # remove the environment created by lago
