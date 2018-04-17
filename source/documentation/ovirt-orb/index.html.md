---
title: oVirt Orb
category: documentation
layout: toc
---

# oVirt Orb

oVirt Orb is a project that allows anyone to easily take an oVirt for a ride, test and play with it.
All without the need to manually install all the components.
It's based on the Lago framework and runs the whole environment on a single machine by creating a number of VMs, using a concept of nested virtualization.

## Requirements

- Operating System

Currently, Orb can run on either supported Fedora versions or Centos 7.

- CPU

Orb is currently supported on Intel's CPUs. The CPU model should be Sandy Bridge or newer.

- Disk Space

Orb requires that you have at least 7GB of free space wherever you are running it.

- Memory

Orb requires that your system will have at least 8GB of RAM.

## Installing requirements

In order to run the oVirt Orb, you will need first to install Lago and some more dependencies.

### Installing Lago
Lago is the framework that provides the basis for running all the required machines for our environment.
We'll later feed it with the configuration and pre-built images of the machines, but first we need to install it.
[Lago project installation documentation](http://lago.readthedocs.io/en/latest/Installation.html)

### Installing oVirt Lago plugin
This plugin makes the Lago aware of oVirt specifics.
[oVirt Lago plugin installation documentation](http://lago-ost-plugin.readthedocs.io/en/latest/Installation.html)

### Installing oVirt Python SDK
The oVirt Python SDK allows code written in Python to easily work with oVirt Engine.
[oVirt Python SDK installation documentation](https://pypi.python.org/pypi/ovirt-engine-sdk-python/4.2.4).

## Getting oVirt Orb

### Downloading oVirt Orb
The current oVirt Orb images based on oVirt 4.2.2 can be downloaded from [here](http://resources.ovirt.org/pub/ovirt-4.2/ovirt-orb/).
You will need to download both the ovirt-orb-*.tar.xz and ovirt-orb-*.tar.xz.md5

### Verifying that archive is not broken

Verify the download file with md5sum:

    md5sum -c ovirt-orb-[oVirt Orb version].tar.xz.md5

You should see the following message on screen:

    ovirt-orb-[oVirt Orb version].tar.xz: OK

### Extracting the archive

    xz --decompress --stdout ovirt-orb-[oVirt Orb version].tar.xz | tar -xv

## Running the environment

Please note: All commands must be run from the inside of the directory created by the extraction of the oVirt Orb archive!

### Bootstrapping the environment

    lago init

### Starting the environment

    lago ovirt start

On the screen you should see oVirt engine's IP, username, and password.

You can enter to the web UI by entering the engine's IP in your browser.

### Stopping the environment

    lago ovirt stop

### Destroying the environment

If you want to recreate Orb, run the following and bootstrap Orb again.

    lago destroy
