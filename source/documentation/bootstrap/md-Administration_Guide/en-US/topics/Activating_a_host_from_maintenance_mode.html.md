# Activating a Host from Maintenance Mode

A host that has been placed into maintenance mode, or recently added to the environment, must be activated before it can be used. Activation may fail if the host is not ready; ensure that all tasks are complete before attempting to activate the host.

**Activating a Host from Maintenance Mode**

1. Click the **Hosts** resources tab and select the host.

2. Click **Activate**.

The host status changes to `Unassigned`, and finally `Up` when the operation is complete. Virtual machines can now run on the host. Virtual machines that were migrated off the host when it was placed into maintenance mode are not automatically migrated back to the host when it is activated, but can be migrated manually. If the host was the Storage Pool Manager (SPM) before being placed into maintenance mode, the SPM role does not return automatically when the host is activated.
