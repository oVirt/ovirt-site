---
title: Upgrade Cluster
authors:
  - lizsurette
---

# Upgrade Cluster

The admin can choose to upgrade a cluster in their environment. This feature design is dependent on the Ansible playbook that will be used:
<https://github.com/oVirt/ovirt-ansible-cluster-upgrade/blob/master/README.md>

### Select Cluster
The Admin navigates to the Cluster view, selects a Cluster (initial design will support only one Cluster Upgrade at once), and chooses “Upgrade” from the menu.
![selectcluster](img/upgrade-cluster-select-cluster.png)

### Select Hosts
The Admin is presented with the Cluster Upgrade wizard where the first step is to select which Hosts from the Cluster they would like to upgrade. They can filter and sort this list to make it easy to select/unselect Hosts to upgrade if needed.
![selecthosts](img/upgrade-cluster-select-hosts.png)

### Upgrade Options
Step 2 of the wizard presented the admin with a number of additional options that affect the Virtual Machines that will be stopped during the Upgrade.
![upgradeoptions](img/upgrade-cluster-upgrade-options.png)

### Review
The last step of the wizard is a confirmation of the Hosts and Virtual Machines that will be affected during the upgrade process.
![upgradereview](img/upgrade-cluster-review.png)

### Monitoring the Upgrade
After kicking off the upgrade process, the admin will see a toast notification to confirm that the upgrade started. From there they can drill into the Notification Drawer to find more details.
![upgradestarted](img/upgrade-cluster-upgrade-started.png)

### Detailed Status of Upgrade
The admin can expand the Notification Drawer and the Task to view more detailed information gathered from the Ansible Playbook output.
![upgradedetails](img/upgrade-cluster-details.png)

[![SPDX-License-Identifier: Apache-2.0](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
