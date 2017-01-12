# Creating an OVF Archive That is Compatible With the Image Uploader

**Summary**

You can create files that can be uploaded using the `engine-image-uploader` tool.

**Creating an OVF Archive That is Compatible With the Image Uploader**

1. Use the Manager to create an empty export domain. An empty export domain makes it easy to see which directory contains your virtual machine.

2. Export your virtual machine to the empty export domain you just created.

3. Log in to the storage server that serves as the export domain, find the root of the NFS share and change to the subdirectory under that mount point. You started with a new export domain, there is only one directory under the exported directory. It contains the `images/` and `master/` directories.

4. Run the `tar -zcvf my.ovf images/ master/` command to create the tar/gzip OVF archive.

5. Anyone you give the resulting OVF file to (in this example, called `my.ovf`) can import it to Red Hat Virtualization Manager using the `engine-image-uploader` command.

**Result**

You have created a compressed OVF image file that can be distributed. Anyone you give it to can use the `engine-image-uploader` command to upload your image into their Red Hat Virtualization environment.
