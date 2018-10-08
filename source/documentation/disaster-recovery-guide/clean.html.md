# Clean the Primary Site

After you fail over, you must clean the environment in the primary site before failing back to it:

* Reboot all hosts in the primary site.
* Ensure the secondary site's storage domains are in read/write mode and the primary site's storage domains are in read only mode.
* Synchronize the replication from the secondary site's storage domains to the primary site's storage domains.  
* Clean the primary site of all storage domains to be imported. This can be done manually in the Manager, or by creating and running an Ansible playbook. See [Detaching a Storage Domain](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.2/html-single/administration_guide/#Detaching_a_storage_domain) in the *Administration Guide* for manual instructions, or [Create the Playbook to Clean the Primary Site](../create_cleanup) for information to create the Ansible playbook.

This example uses the `dr-cleanup.yml` playbook created earlier to clean the environment.

**Cleaning the primary site:**

Clean up the primary site with the following command:

```
# ansible-playbook dr-cleanup.yml --tags "clean_engine"
```

You can now failback the environment to the primary site. See [Execute a Failback](../execute_failback) for more information.
