# Basic ISO Uploader Usage

The example below demonstrates the ISO uploader and the list parameter. The first command lists the available ISO storage domains; the `admin@internal` user is used because no user was specified in the command. The second command uploads an ISO file over NFS to the specified ISO domain.

**List Domains and Upload Image**

    # engine-iso-uploader list
    Please provide the REST API password for the admin@internal oVirt Engine user (CTRL+D to abort):
    ISO Storage Domain Name   | Datacenter          | ISO Domain Status
    ISODomain                 | Default             | active
    # engine-iso-uploader --iso-domain=[ISODomain] upload [RHEL6.iso]
    Please provide the REST API password for the admin@internal oVirt Engine user (CTRL+D to abort):

