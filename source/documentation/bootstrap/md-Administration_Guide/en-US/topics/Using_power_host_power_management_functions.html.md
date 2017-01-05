# Using Host Power Management Functions

**Summary**

When power management has been configured for a host, you can access a number of options from the Administration Portal interface. While each power management device has its own customizable options, they all support the basic options to start, stop, and restart a host.

**Using Host Power Management Functions** 


1. Use the **Hosts** resource tab, tree mode, or the search function to find and select the host in the results list.

2. Click the **Power Management** drop-down menu.

3. Select one of the following options:

    * **Restart**: This option stops the host and waits until the host's status changes to `Down`. When the agent has verified that the host is down, the highly available virtual machines are restarted on another host in the cluster. The agent then restarts this host. When the host is ready for use its status displays as `Up`.

    * **Start**: This option starts the host and lets it join a cluster. When it is ready for use its status displays as `Up`.

    * **Stop**: This option powers off the host. Before using this option, ensure that the virtual machines running on the host have been migrated to other hosts in the cluster. Otherwise the virtual machines will crash and only the highly available virtual machines will be restarted on another host. When the host has been stopped its status displays as `Non-Operational`.

    **Important:** When two fencing agents are defined on a host, they can be used concurrently or sequentially. For concurrent agents, both agents have to respond to the Stop command for the host to be stopped; and when one agent responds to the Start command, the host will go up. For sequential agents, to start or stop a host, the primary agent is used first; if it fails, the secondary agent is used.

4. Selecting one of the above options opens a confirmation window. Click **OK** to confirm and proceed.

**Result**

The selected action is performed.
