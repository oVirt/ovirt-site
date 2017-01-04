# New Pool and Edit Pool General Settings Explained

The following table details the information required on the **General** tab of the **New Pool** and **Edit Pool** windows that are specific to virtual machine pools. All other settings are identical to those in the **New Virtual Machine** window.

**General settings**

| Field Name | Description |
|-
| **Template** | The template on which the virtual machine pool is based. |
| **Description** | A meaningful description of the virtual machine pool. |
| **Comment** | A field for adding plain text human-readable comments regarding the virtual machine pool. |
| **Prestarted VMs** | Allows you to specify the number of virtual machines in the virtual machine pool that will be started before they are taken and kept in that state to be taken by users. The value of this field must be between `0` and the total number of virtual machines in the virtual machine pool. |
| **Number of VMs/Increase number of VMs in pool by** | Allows you to specify the number of virtual machines to be created and made available in the virtual machine pool. In the edit window it allows you to increase the number of virtual machines in the virtual machine pool by the specified number. By default, the maximum number of virtual machines you can create in a pool is 1000. This value can be configured using the `MaxVmsInPool` key of the `engine-config` command. |
| **Maximum number of VMs per user** | Allows you to specify the maximum number of virtual machines a single user can take from the virtual machine pool at any one time. The value of this field must be between `1` and `32,767`. |
| **Delete Protection** | Allows you to prevent the virtual machines in the pool from being deleted. |
