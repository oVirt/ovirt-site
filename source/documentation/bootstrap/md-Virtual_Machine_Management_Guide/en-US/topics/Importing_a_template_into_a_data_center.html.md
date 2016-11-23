# Importing a Template into a Data Center

**Note:** The export storage domain is deprecated. Storage data domains can be unattached from a data center and imported to another data center in the same environment, or in a different environment. Virtual machines, floating virtual disk images, and templates can then be uploaded from the imported storage domain to the attached data center. See the [Importing Existing Storage Domains](https://access.redhat.com/documentation/en/red-hat-virtualization/4.0/single/administration-guide#sect-Importing_Existing_Storage_Domains) section in the *Red Hat Virtualization Administration Guide* for information on importing storage domains.

Import templates from a newly attached export domain. This procedure requires access to the Administration Portal.

**Importing a Template into a Data Center**

1. Click the **Storage** tab and select the newly attached export domain.

2. Click the **Template Import** tab in the details pane and select a template.

3. Click **Import**.

4. Select the templates to import.

5. Use the drop-down lists to select the **Destination Cluster** and **Storage** domain. Alter the **Suffix** if applicable.

    Alternatively, clear the **Clone All Templates** check box.

6. Click **OK** to import templates and open a notification window. Click **Close** to close the notification window.

The template is imported into the destination data center. This can take up to an hour, depending on your storage hardware. You can view the import progress in the **Events** tab.

Once the importing process is complete, the templates will be visible in the **Templates** resource tab. The templates can create new virtual machines, or run existing imported virtual machines based on that template.
