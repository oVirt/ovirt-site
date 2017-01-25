# Virtual Machine Device Configuration

The following table shows the relationships between virtual machines and their associated devices, including disks and virtual interfaces.

**v3_5_configuration_history_vms_devices**

| Name | Type | Description |
|-
| history_id  | integer      | The ID of the configuration version in the history database. |
| vm_id       | uuid         | The unique ID of the virtual machine in the system. |
| type        | varchar(30)  | VM Device Type which can be "disk" or "interface" |
| address     | varchar(255) | The virtual machine's device physical address |
| is_managed  | Boolean      | Flag that indicates if the device is managed by the Engine |
| is_plugged  | Boolean      | Flag that indicates if the device is plugged into the virtual machine. |
| is_readonly | Boolean      | Flag that indicates if the device is read only. |
| vm_configuration_version | integer | The virtual machine configuration version at the time the sample was taken. |
| device_configuration_version | integer | The device configuration version at the time the sample was taken. |
| create_date | timestamp with time zone | The date this entity was added to the system. |
| update_date timestamp | timestamp with time zone | The date this entity was added to the system. |
| delete_date | timestamp with time zone | The date this entity was added to the system. |

**Prev:** [Latest Virtual Machine Interface Configuration View](../Latest_virtual_machine_interface_configuration_view) <br>
**Next:** [Latest Virtual Machine Disk Configuration View](../Latest_virtual_machine_disk_configuration_view)
