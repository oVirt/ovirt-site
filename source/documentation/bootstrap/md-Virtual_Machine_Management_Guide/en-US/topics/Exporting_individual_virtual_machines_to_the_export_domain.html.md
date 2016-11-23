# Exporting a Virtual Machine to the Export Domain

Export a virtual machine to the export domain so that it can be imported into a different data center. Before you begin, the export domain must be attached to the data center that contains the virtual machine to be exported.

**Warning:** The virtual machine must be shut down before being exported. 

**Exporting a Virtual Machine to the Export Domain**

1. Click the **Virtual Machines** tab and select a virtual machine.

2. Click **Export**.

3. Optionally select the following check boxes: 

    * **Force Override**: overrides existing images of the virtual machine on the export domain.

    * **Collapse Snapshots**: creates a single export volume per disk. This option removes snapshot restore points and includes the template in a template-based virtual machine, and removes any dependencies a virtual machine has on a template. For a virtual machine that is dependent on a template, either select this option, export the template with the virtual machine, or make sure the template exists in the destination data center.

        **Note:** When you create a virtual machine from a template, two storage allocation options are available under **New Virtual Machine** > **Resource Allocation** > **Storage Allocation**.

        * If **Clone** was selected, the virtual machine is not dependent on the template. The template does not have to exist in the destination data center.

        * If **Thin** was selected, the virtual machine is dependent on the template, so the template must exist in the destination data center or be exported with the virtual machine. Alternatively, select the **Collapse Snapshots** check box to collapse the template disk and virtual machine disk into a single disk.

        To check which option was selected, select a virtual machine and click the **General** tab in the details pane.

4. Click **OK**.

The export of the virtual machine begins. The virtual machine displays in the **Virtual Machines** results list with an `Image Locked` status while it is exported. Depending on the size of your virtual machine hard disk images, and your storage hardware, this can take up to an hour. Use the **Events** tab to view the progress. When complete, the virtual machine has been exported to the export domain and displays on the **VM Import** tab of the export domain's details pane.
