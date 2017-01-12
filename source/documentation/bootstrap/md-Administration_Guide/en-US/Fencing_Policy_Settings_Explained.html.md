# Fencing Policy Settings Explained

The table below describes the settings for the **Fencing Policy** tab in the **New Cluster** and **Edit Cluster** windows.

**Fencing Policy Settings**

| Field | Description/Action |
|-
| **Enable fencing** | Enables fencing on the cluster. Fencing is enabled by default, but can be disabled if required; for example, if temporary network issues are occurring or expected, administrators can disable fencing until diagnostics or maintenance activities are completed. Note that if fencing is disabled, highly available virtual machines running on non-responsive hosts will not be restarted elsewhere. |
| **Skip fencing if host has live lease on storage** | If this check box is selected, any hosts in the cluster that are Non Responsive and still connected to storage will not be fenced. |
| **Skip fencing on cluster connectivity issues** | If this check box is selected, fencing will be temporarily disabled if the percentage of hosts in the cluster that are experiencing connectivity issues is greater than or equal to the defined **Threshold**. The **Threshold** value is selected from the drop-down list; available values are **25**, **50**, **75**, and **100**. |
