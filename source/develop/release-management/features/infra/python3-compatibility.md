---
title: Vdsm python3 compatibility
category: feature
authors: apuimedo, danken, vfeenstr
---

# Vdsm python3 compatibility

## Summary

Python 3 is already 5 years old and the pioneering distributions such as Arch Linux have been running with it as default Python interpreter for quite some time. [Soon](https://fedoraproject.org/wiki/Changes/Python_3_as_Default) the turn will come for Fedora, which is one of the community supported distributions of oVirt.

The goal of this page is to drive VDSM and it's components to become a single codebase that supports:

*   Python-2.6 (Could probably be eventually dropped when we make the next major version).
*   Python-2.7
*   Python-3.3+

## Instigator

*   Name: Antoni Segura Puimedon (APuimedo)
*   Email: apuimedo aT redhat.com

To help us achieve that, this page will keep links to some useful resources and a list of things ported and to port.

## Useful resources

*   [Making C Python modules 2.x and 3.x compatible with a bit of ifdefing.](http://docs.python.org/3/howto/cporting.html)
*   [Book on Python3 porting (opened at the C Python modules section).](http://python3porting.com/cextensions.html)
*   [Six: Python 2 and 3 helper library.](https://pypi.org/project/six/)
*   [Great blog post about single codebase for the versions we want to support (MUST READ).](http://lucumr.pocoo.org/2013/5/21/porting-to-python-3-redux/)

## Status (Feel free to add components/dependencies that should be ported)

| Name              | Dependency | Component | Description                                                                     | Completion                                                  |
|-------------------|------------|-----------|---------------------------------------------------------------------------------|-------------------------------------------------------------|
| lib/vdsm          | 0          | 1         | vdsm's own library                                                              | No                                                          |
| vdsm/netconf      | 0          | 1         | vdsm's network configurator package                                             | No                                                          |
| vdsm/storage      | 0          | 1         | vdsm's storage package                                                          | No                                                          |
| vdsm              | 0          | 1         | vdsm's main code                                                                | No                                                          |
| lib/vdsm/tool     | 0          | 1         | vdsm's utilities (mainly for command line)                                      | No                                                          |
| vdsClient         | 0          | 1         | vdsm's command line client                                                      | No                                                          |
| python-ethtool    | 1          | 0         | vdsm's network dependency for setting/retrieving netlink and ioctl information. | Patch submitted upstream (apuimedo)                         |
| python-nose       | 1          | 0         | vdsm's testing dependency.                                                      | Yes                                                         |
| python-pep8       | 1          | 0         | vdsm's formatting checks build-dependency.                                      | Yes                                                         |
| python-pthreading | 1          | 0         | vdsm's better threading.                                                        | Yes (not necessary in Python3)                              |
| python-cpopen     | 1          | 0         | vdsm's better popen.                                                            | Yes (not necessary in Python3)                              |
| python-inotify    | 1          | 0         | -                                                                               | Has to be investigated                                      |
| python-netaddr    | 1          | 0         | -                                                                               | Has to be investigated                                      |
| python-dmidecode  | 1          | 0         | -                                                                               | Has to be investigated                                      |
| python-argparse   | 1          | 0         |                                                                                 | Part of Python standard library since 3.2                   |
| libvirt bindings  | 1          | 0         | vdsm's libvirt wrapper dependency.                                              | Latest libvirt-python GIT version builds wrappers for both. |
| python-inotify    | 1          | 0         | -                                                                               | Yes                                                         |

