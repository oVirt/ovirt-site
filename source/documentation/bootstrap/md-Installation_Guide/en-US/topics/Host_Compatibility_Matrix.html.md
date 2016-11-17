# Host Compatibility Matrix

The following table outlines the supported host versions in each compatibility version of Red Hat Virtualization.

**Note:** The latest version of VDSM is backwards compatible with all previous versions of Red Hat Virtualization.

**Host Compatibility Matrix**

| Supported RHEL or RHVH Version | 3.6 | 4.0
|-
| 7.0 | ✓ |   |
| 7.1 | ✓ |   |
| 7.2 | ✓ | ✓ |

When you create a new data center, you can set the compatibility version. Select the compatibility version that suits all the hosts in the data center. Once set, version regression is not allowed. For a fresh Red Hat Virtualization installation, the latest compatibility version is set in the Default Data Center and Default Cluster; to use an older compatibility version, you must create additional data centers and clusters.
