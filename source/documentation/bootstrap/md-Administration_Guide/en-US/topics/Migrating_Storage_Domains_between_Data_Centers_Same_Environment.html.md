# Migrating Storage Domains between Data Centers in the Same Environment

Migrate a storage domain from one data center to another in the same Red Hat Virtualization environment to allow the destination data center to access the data contained in the storage domain. This procedure involves detaching the storage domain from one data center, and attaching it to a different data center.

**Migrating a Storage Domain between Data Centers in the Same Environment**

1. Shut down all virtual machines running on the required storage domain. 

2. Click the **Storage** resource tab and select the storage domain from the results list.

3. Click the **Data Center** tab in the details pane.

4. Click **Maintenance**, then click **OK** to move the storage domain to maintenance mode.

5. Click **Detach**, then click **OK** to detach the storage domain from the source data center. 

6. Click **Attach**. 

7. Select the destination data center and click **OK**. 

The storage domain is attached to the destination data center and is automatically activated. You can now import virtual machines and templates from the storage domain to the destination data center.
