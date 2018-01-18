---
title: oVirt Engine Related Tasks
---

# Chapter 4: oVirt Engine Related Tasks

## Removing the oVirt Engine

You can use the `engine-cleanup` command to remove specific components or all components of the oVirt Engine.

**Note:** A backup of the engine database and a compressed archive of the PKI keys and configuration are always automatically created. These files are saved under `/var/lib/ovirt-engine/backups/`, and include the date and `engine-` and `engine-pki-` in their file names, respectively.

**Removing the oVirt Engine**

1. Run the following command on the machine on which the oVirt Engine is installed:

        # engine-cleanup

2. You are prompted whether to remove all oVirt Engine components:

    * Type `Yes` and press **Enter** to remove all components:

            Do you want to remove all components? (Yes, No) [Yes]:

    * Type `No` and press **Enter** to select the components to remove. You can select whether to retain or remove each component individually:

            Do you want to remove Engine database content? All data will be lost (Yes, No) [No]:
            Do you want to remove PKI keys? (Yes, No) [No]:
            Do you want to remove PKI configuration? (Yes, No) [No]:
            Do you want to remove Apache SSL configuration? (Yes, No) [No]:

3. You are given another opportunity to change your mind and cancel the removal of the oVirt Engine. If you choose to proceed, the `ovirt-engine` service is stopped, and your environment's configuration is removed in accordance with the options you selected.

        During execution engine service will be stopped (OK, Cancel) [OK]:
        ovirt-engine is about to be removed, data will be lost (OK, Cancel) [Cancel]:OK

4. Remove the oVirt packages

**Prev:** [Chapter 3: Installing oVirt](../chap-Installing_oVirt)<br>
**Next:** [Chapter 5: Introduction to Hypervisor Hosts](../chap-Introduction_to_Hypervisor_Hosts)
