# Using Cloud-Init to Prepare a Template

As long as the `cloud-init` package is installed on a Linux virtual machine, you can use the virtual machine to make a cloud-init enabled template. Specify a set of standard settings to be included in a template as described in the following procedure or, alternatively, skip the Cloud-Init settings steps and configure them when creating a virtual machine based on this template.

**Note:** While the following procedure outlines how to use Cloud-Init when preparing a template, the same settings are also available in the **New Virtual Machine**, **Edit Template**, and **Run Once** windows.

**Using Cloud-Init to Prepare a Template**

1. Click the **Virtual Machines** tab and select a virtual machine.

2. Click **Edit**.

3. Click the **Initial Run** tab and select the **Use Cloud-Init/Sysprep** check box.

4. Enter a host name in the **VM Hostname** text field.

5. Select the **Configure Time Zone** check box and select a time zone from the **Time Zone** drop-down list.

6. Expand the **Authentication** section and select the **Use already configured password** check box to user the existing credentials, or clear that check box and enter a root password in the **Password** and **Verify Password** text fields to specify a new root password.

7. Enter any SSH keys to be added to the authorized hosts file on the virtual machine in the **SSH Authorized Keys** text area.

8. Select the **Regenerate SSH Keys** check box to regenerate SSH keys for the virtual machine.

9. Expand the **Networks** section and enter any DNS servers in the **DNS Servers** text field.

10. Enter any DNS search domains in the **DNS Search Domains** text field.

11. Select the **Network** check box and use the **+** and **-** buttons to add or remove network interfaces to or from the virtual machine.

12. Expand the **Custom Script** section and enter any custom scripts in the **Custom Script** text area.

13. Click **Ok**.

14. Click **Make Template** and enter the fields as necessary.

15. Click **Ok**.

You can now provision new virtual machines using this template.
