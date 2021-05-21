---
title: Automatic installation of Windows drivers
category: feature
authors: tgolembi
---

# Automatic installation of Windows drivers

## Summary

The feature simplifies the installation of MS Windows on a VM when virtio disk
and network drivers are used. oVirt provides a floppy with file
`Autounattend.xml` which tells the installer where to find the necessary virtio
drivers.

## Motivation

The process of installing VM with MS Windows is complicated by the lack of
virtio drivers on the installation media. If the user wants to use virtio disk
and network during installation -- which is suggested because of significant
speed improvement -- he has to perform some preparatory steps. The user has to
manually load the virtio storage drivers and possibly also virtio network
drivers from the floppy disk in the initial phase of installation. This process
puts unnecessary burden on the user.

## Automation

The installation process of MS Windows can be automated by providing removable
media containing file called `Autounattend.xml`. The XML file allows automation
of many aspects of the installation. From answers to dialog questions to disk
partitioning to completely unattended installation.

In case of this feature we use it to tell Windows where it can find the
necessary drivers. The installer will then load the drivers automatically and
also installs them to the target OS. That way they are available during the
installation as well as on the first boot of the new system.

## How to use the feature

TBA (UX design is still in progress)

## Details

First *osinfo* database will be modified to contain the directory with the
drivers. By default, the directories correspond to the paths as seen on the
floppy in `virtio-win` package.

Second, the auto-install floppy is created on the fly just before the VM is
started. The floppy image specified in *Run Once* dialog is copied to the
payload directory on VDSM and `Autounattend.xml` is injected onto it. The
`Autounattend.xml` is created from the template by replacing the path to the
drivers from *osinfo*. We cannot use single XML file because of bugs in drivers
loading code in Windows.
