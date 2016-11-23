# Configuring a Highly Available Virtual Machine

High availability must be configured individually for each virtual machine.

**Configuring a Highly Available Virtual Machine**

1. Click the **Virtual Machines** tab and select a virtual machine.

2. Click **Edit**.

3. Click the **High Availability** tab.

    **The High Availability Tab**

    ![](images/7322.png)

4. Select the **Highly Available** check box to enable high availability for the virtual machine.

5. Select **Low**, **Medium**, or **High** from the **Priority** drop-down list. When migration is triggered, a queue is created in which the high priority virtual machines are migrated first. If a cluster is running low on resources, only the high priority virtual machines are migrated.

6. Click **OK**.
