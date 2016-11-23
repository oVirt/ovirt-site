# Using Cloud-Init to Initialize a Virtual Machine

Use Cloud-Init to automate the initial configuration of a Linux virtual machine. You can use the Cloud-Init fields to configure a virtual machine's host name, time zone, root password, authorized keys, network interfaces, and DNS service. You can also specify a custom script, a script in YAML format, to run on boot. The custom script allows for additional Cloud-Init configuration that is supported by Cloud-Init but not available in the Cloud-Init fields. For more information on custom script examples, see [Cloud config examples](http://cloudinit.readthedocs.org/en/latest/topics/examples.html).

**Using Cloud-Init to Initialize a Virtual Machine**

This procedure starts a virtual machine with a set of Cloud-Init settings. If the relevant settings are included in the template the virtual machine is based on, review the settings, make changes where appropriate, and click **OK** to start the virtual machine.

1. Click the **Virtual Machines** tab and select a virtual machine.

2. Click **Run Once**.

3. Expand the **Initial Run** section and select the **Cloud-Init** check box.

4. Enter a host name in the **VM Hostname** text field.

5. Select the **Configure Time Zone** check box and select a time zone from the **Time Zone** drop-down menu.

6. Select the **Use already configured password** check box to use the existing credentials, or clear that check box and enter a root password in the **Password** and **Verify Password** text fields to specify a new root password.

7. Enter any SSH keys to be added to the authorized hosts file on the virtual machine in the **SSH Authorized Keys** text area.

8. Select the **Regenerate SSH Keys** check box to regenerate SSH keys for the virtual machine.

9. Enter any DNS servers in the **DNS Servers** text field.

10. Enter any DNS search domains in the **DNS Search Domains** text field.

11. Select the **Network** check box and use the **+** and **-** buttons to add or remove network interfaces to or from the virtual machine.

12. Enter a custom script in the **Custom Script** text area. Make sure the values specified in the script are appropriate. Otherwise, the action will fail.

13. Click **OK**.

**Note:** To check if a virtual machine has Cloud-Init installed, select a virtual machine and click the **Applications** sub-tab. Only shown if the guest agent is installed.
