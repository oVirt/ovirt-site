---
title: oVirt on Arch Linux
authors: apuimedo, sandrobonazzola
wiki_title: OVirt on Arch Linux
wiki_revision_count: 3
wiki_last_updated: 2015-10-09
---

# OVirt on Arch Linux

This page contains tracks the effort for making oVirt work on the [Arch Linux](https://www.archlinux.org/) distribution.

### Instigator

*   Name: [ Antoni Segura Puimedon](User:APuimedo)
*   Email: apuimedo aT redhat.com

## Existing packages

You can get the list of existing packages here <https://aur.archlinux.org/packages/?K=ovirt&SB=p>

## Engine

There is a [package](https://aur.archlinux.org/packages/ovirt-engine-git/) for the git version. Testing would be needed to verify its correctness. Missing: Packaging for stable releases.

## VDSM

### Packaging

There is an [ongoing effort](https://github.com/celebdor/vdsm-aur) of packaging vdsm and all of its dependencies (which are not already on AUR). There, on the vdsm pkgbuild you can find an updated list of the dependencies that are known, present in AUR and also those yet to be packaged.

One of the challenges is the fact that vdsm is usually packaged into subpackages, which is supported by recent versions of makepkg and pacman, but it is unsupported by AUR. One possible solution would be for oVirt to host its own Arch repository for just the vdsm package and subpackages.

*   Different Service names

| Fedora | Arch Linux |
|--------|------------|
| iscsid | open-iscsi |

### Missing code

It is needed to finish merging the iproute2 configurator so that networking becomes functional.
