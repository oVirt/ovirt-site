---
title: oVirt on Arch Linux
authors: apuimedo, sandrobonazzola
---

# oVirt on Arch Linux

This page contains tracks the effort for making oVirt work on the [Arch Linux](https://www.archlinux.org/) distribution.

Nobody is currently leading this effort.

### Instigator

*   Name: Antoni Segura Puimedon (APuimedo)
*   Email: apuimedo aT redhat.com

## Existing packages

You can get the list of existing packages here <https://aur.archlinux.org/packages/?K=ovirt&SB=p>


## VDSM

### Packaging

There was an [effort](https://github.com/celebdor/vdsm-aur) of packaging vdsm and all of its dependencies (which are not already on AUR).
There, on the vdsm pkgbuild you can find a list of the dependencies that are known, present in AUR and also those yet to be packaged.

One of the challenges is the fact that vdsm is usually packaged into subpackages, which is supported by recent versions of makepkg and pacman, but it is unsupported by AUR.
One possible solution would be for oVirt to host its own Arch repository for just the vdsm package and subpackages.

*   Different Service names

| Fedora | Arch Linux |
|--------|------------|
| iscsid | open-iscsi |

### Missing code

It is needed to finish merging the iproute2 configurator so that networking becomes functional.
