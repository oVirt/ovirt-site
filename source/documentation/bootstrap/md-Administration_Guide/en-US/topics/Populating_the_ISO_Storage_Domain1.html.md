# Populating the ISO Storage Domain

An ISO storage domain is attached to a data center. ISO images must be uploaded to it. Red Hat Virtualization provides an ISO uploader tool that ensures that the images are uploaded into the correct directory path, with the correct user permissions.

The creation of ISO images from physical media is not described in this document. It is assumed that you have access to the images required for your environment.

**Populating the ISO Storage Domain**

1. Copy the required ISO image to a temporary directory on the system running Red Hat Virtualization Manager.

2. Log in to the system running Red Hat Virtualization Manager as the `root` user.

3. Use the `engine-iso-uploader` command to upload the ISO image. This action will take some time. The amount of time varies depending on the size of the image being uploaded and available network bandwidth.

    **ISO Uploader Usage**

    In this example the ISO image `RHEL6.iso` is uploaded to the ISO domain called `ISODomain` using NFS. The command will prompt for an administrative user name and password. The user name must be provided in the form `user name@domain`.

        # engine-iso-uploader --iso-domain=ISODomain upload RHEL6.iso

The ISO image is uploaded and appears in the ISO storage domain specified. It is also available in the list of available boot media when creating virtual machines in the data center to which the storage domain is attached.
