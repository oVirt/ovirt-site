# Migrating Templates to the Export Domain

**Note:** The export storage domain is deprecated. Storage data domains can be unattached from a data center and imported to another data center in the same environment, or in a different environment. Virtual machines, floating virtual disk images, and templates can then be uploaded from the imported storage domain to the attached data center. See the [Importing Existing Storage Domains](https://access.redhat.com/documentation/en/red-hat-virtualization/4.0/single/administration-guide#sect-Importing_Existing_Storage_Domains) section in the *Red Hat Virtualization Administration Guide* for information on importing storage domains.

Export templates into the export domain to move them to another data domain, either in the same Red Hat Virtualization environment, or another one. This procedure requires access to the Administration Portal.

**Exporting Individual Templates to the Export Domain**

1. Click the **Templates** tab and select a template.

2. Click **Export**.

3. Select the **Force Override** check box to replace any earlier version of the template on the export domain.

4. Click **OK** to begin exporting the template; this may take up to an hour, depending on the virtual machine disk image size and your storage hardware.

Repeat these steps until the export domain contains all the templates to migrate before you start the import process.

Click the **Storage** tab, select the export domain, and click the **Template Import** tab in the details pane to view all exported templates in the export domain.
