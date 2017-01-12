# Basic engine-image-uploader Usage Examples

The following is an example of how to use the engine uploader command to list export storage domains:

**Listing export storage domains using the image uploader**

    # engine-image-uploader list
    Please provide the REST API password for the admin@internal oVirt Engine user (CTRL+D to abort):
    Export Storage Domain Name | Datacenter  | Export Domain Status
    myexportdom               | Myowndc 　  | active

The following is an example of how to upload an Open Virtualization Format (OVF) file:

**Uploading a file using the image uploader**

    # engine-image-uploader -e myexportdom upload myrhel6.ovf
    Please provide the REST API password for the admin@internal oVirt Engine user (CTRL+D to abort):
