# Quality of Service

Red Hat Virtualization allows you to define quality of service entries that provide fine-grained control over the level of input and output, processing, and networking capabilities that resources in your environment can access. Quality of service entries are defined at the data center level and are assigned to profiles created under clusters and storage domains. These profiles are then assigned to individual resources in the clusters and storage domains where the profiles were created.

## Storage Quality of Service

Storage quality of service defines the maximum level of throughput and the maximum level of input and output operations for a virtual disk in a storage domain. Assigning storage quality of service to a virtual disk allows you to fine tune the performance of storage domains and prevent the storage operations associated with one virtual disk from affecting the storage capabilities available to other virtual disks hosted in the same storage domain.

* [Creating a Storage Quality of Service Entry](Creating_a_Storage_Quality_of_Service_Entry)
* [Removing a Storage Quality of Service Entry](Removing_a_Storage_Quality_of_Service_Entry)

## Virtual Machine Network Quality of Service

Virtual machine network quality of service is a feature that allows you to create profiles for limiting both the inbound and outbound traffic of individual virtual network interface controllers. With this feature, you can limit bandwidth in a number of layers, controlling the consumption of network resources.

* [Adding QoS](Adding_QoS)
* [Settings in the New Network QoS and Edit Network QoS Windows Explained](Settings_in_the_New_Network_QoS_and_Edit_Network_QoS_Windows_Explained1)
* [Removing QoS](Removing_QoS)

## Host Network Quality of Service

Host network quality of service configures the networks on a host to enable the control of network traffic through the physical interfaces. Host network quality of service allows for the fine tuning of network performance by controlling the consumption of network resources on the same physical network interface controller. This helps to prevent situations where one network causes other networks attached to the same physical network interface controller to no longer function due to heavy traffic. By configuring host network quality of service, these networks can now function on the same physical network interface controller without congestion issues.

* [Creating a Host Network Quality of Service Entry](Creating_a_Host_Network_Quality_of_Service_Entry)
* [Settings in the New Host Network QoS and Edit Host Network QoS Windows Explained](Settings_in_the_New_Host_Network_QoS_and_Edit_Host_Network_QoS_Windows_Explained)
* [Removing a Host Network Quality of Service Entry](Removing_a_Host_Network_Quality_of_Service_Entry)

## CPU Quality of Service

CPU quality of service defines the maximum amount of processing capability a virtual machine can access on the host on which it runs, expressed as a percent of the total processing capability available to that host. Assigning CPU quality of service to a virtual machine allows you to prevent the workload on one virtual machine in a cluster from affecting the processing resources available to other virtual machines in that cluster.

* [Creating a CPU Quality of Service Entry](Creating_a_CPU_Quality_of_Service_Entry)
* [Removing a CPU Quality of Service Entry](Removing_a_CPU_Quality_of_Service_Entry)

