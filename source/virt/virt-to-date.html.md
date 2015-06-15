---
title: Virt-to-date
authors: hateya
wiki_title: Virt-to-date
wiki_revision_count: 4
wiki_last_updated: 2012-01-15
---

# Virt-to-date

## Introduction

virt-to-date is a simple tool which mainly built for managing upstream GIT repositories, and allows simple creation of up-to-date, local, yum repository. please note that tool is only supported for Fedora based machine, other distros will be supported in the future.

Virt-to-date main functionalities are:

* clone GIT repository for pre-defined components; by default, for:

        - vdsm
        - libivirt
        - rhevm
        - lvm2
        - device-mapper
        - spice
        - qemu-kvm

* make rpm out of those repositories, by default for:

        - vdsm
        - libvirt  

* fetch latest packages out of Fedora KOJI server, by default for all the above, and others like: bridge-utils, sanlock, udev, iproute, qemu-kvm, spice, lvm2, device-mapper and a lot more.

* create local yum repository with all required packages by oVirt-node for single based Fedora-16 host running VDSM.

## Usage

         Usage: virt-to-date.py [options]
         
         Options:
           -h, --help           show this help message and exit
           --build-all          Clone upstream GIT, build rpms, download latest
                                packages, build repository and deploy to remote hosts
           --clone-git          Clone upstream GIT - can pass with single or multiple
                                package list
           --projects=PROJLIST  
           --install            Install needed packages allowing compile, build and
                                deploy needed packages
           --build-latest       Refresh upstream GIT, build latest packages, recreates
                                Yum repository
           --skip-web           
           --skip-git           
           --deploy             Deploy latest upstream packages to remote hosts, if no
                                hosts is provided, taken from config
           --hosts=HOSTS        
           --list-projects      Display a list of supported Projects
           --create-repo        Display a list of current packages in yum repository

## Git location:

tool files can be found on git-hub, just run the following command:

`   git clone `[`https://github.com/hateya/virt-to-date.git`](https://github.com/hateya/virt-to-date.git)
