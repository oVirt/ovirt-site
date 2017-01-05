# Host High Availability

The Red Hat Virtualization Manager uses fencing to keep the hosts in a cluster responsive. A **Non Responsive** host is different from a **Non Operational** host. **Non Operational** hosts can be communicated with by the Manager, but have an incorrect configuration, for example a missing logical network. **Non Responsive** hosts cannot be communicated with by the Manager.

If a host with a power management device loses communication with the Manager, it can be fenced (rebooted) from the Administration Portal. All the virtual machines running on that host are stopped, and highly available virtual machines are started on a different host.

All power management operations are done using a proxy host, as opposed to directly by the Red Hat Virtualization Manager. At least two hosts are required for power management operations.

Fencing allows a cluster to react to unexpected host failures as well as enforce power saving, load balancing, and virtual machine availability policies. You should configure the fencing parameters for your host's power management device and test their correctness from time to time.

Hosts can be fenced automatically using the power management parameters, or manually by right-clicking on a host and using the options on the menu. In a fencing operation, an unresponsive host is rebooted, and if the host does not return to an active status within a prescribed time, it remains unresponsive pending manual intervention and troubleshooting.

If the host is required to run virtual machines that are highly available, power management must be enabled and configured.
