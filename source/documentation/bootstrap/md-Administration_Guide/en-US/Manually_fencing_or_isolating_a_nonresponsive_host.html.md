# Manually Fencing or Isolating a Non Responsive Host

**Summary**

If a host unpredictably goes into a non-responsive state, for example, due to a hardware failure; it can significantly affect the performance of the environment. If you do not have a power management device, or it is incorrectly configured, you can reboot the host manually.

**Warning:** Do not use the **Confirm host has been rebooted** option unless you have manually rebooted the host. Using this option while the host is still running can lead to a virtual machine image corruption.

**Manually fencing or isolating a non-responsive host** 

1. On the **Hosts** tab, select the host. The status must display as `non-responsive`.

2. Manually reboot the host. This could mean physically entering the lab and rebooting the host.

3. On the Administration Portal, right-click the host entry and select the **Confirm Host has been rebooted** button.

4. A message displays prompting you to ensure that the host has been shut down or rebooted. Select the **Approve Operation** check box and click **OK**.

**Result**

You have manually rebooted your host, allowing highly available virtual machines to be started on active hosts. You confirmed your manual fencing action in the Administrator Portal, and the host is back online.
