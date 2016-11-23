# Importing a Virtual Disk Image from an OpenStack Image Service as a Template

Virtual disk images managed by an OpenStack Image Service can be imported into the Red Hat Virtualization Manager if that OpenStack Image Service has been added to the Manager as an external provider. This procedure requires access to the Administration Portal.

1. Click the **Storage** tab and select the OpenStack Image Service domain.

2. Click the **Images** tab in the details pane and select the image to import.

3. Click **Import**.

4. Select the **Data Center** into which the virtual disk image will be imported.

5. Select the storage domain in which the virtual disk image will be stored from the **Domain Name** drop-down list.

6. Optionally, select a **Quota** to apply to the virtual disk image.

7. Select the **Import as Template** check box.

8. Select the **Cluster** in which the virtual disk image will be made available as a template.

9. Click **OK**.

The image is imported as a template and is displayed in the **Templates** tab. You can now create virtual machines based on the template.
