---
title: Image Upload
category: feature
authors: gpadgett
wiki_category: Feature
wiki_title: Features/Image Upload
wiki_revision_count: 7
wiki_last_updated: 2015-06-03
feature_name: Image Upload
feature_modules: engine,storage,vdsm
feature_status: Planning
---

# Image Upload

### Summary

Placing an ISO on an ISO domain today involves use of the command line, either via the ISO Uploader tool or manual copying of the ISO image. Similarly, importing a VM disk image to a data domain requires an import from existing storage, virt-v2v operation, or other manual method.

The goal of this project is to simplify the workflow of moving a new ISO or disk image into the oVirt environment by providing a browser-based UI and REST API. These new methods will support uploading files directly selected from the admin's local machine (ie file selection dialog in a browser, or data attached to a REST API request), or by specifying a remote URL from which oVirt should download the file.

### Owner

*   Name: Greg Padgett <gpadgett@redhat.com>
*   Name: Amit Aviram <aaviram@redhat.com>

### Detailed Description

#### Goals

1. Upload VM Disk Image to Storage Domain 1. Upload ISO Image to ISO Domain 1. Download VM Disk Image from URL to Storage Domain 1. (future?) Download ISO Image from URL to ISO Domain 1. (future) Import entire OVA 1. (future) Import and convert (v2v) vmdk

Each supported operation will be available in WebAdmin and the REST API. (Users uploading via the REST API will probably want to use a supplementary script or tool.) Select operations, such as VM disk image upload/download, may be available in the User Portal.

The implementation will support uploading files much larger than a typical HTTP request, on the order of several (even hundreds) of GB or more, without relying on launching external programs, processes, tools, etc.

#### Limitations

*   IE 10, FF 3.6, or Chrome 13 or greater are required for the Upload functionality

#### Upload

##### Overview

The upload action will allow a user to upload a file from his/her local machine to the oVirt environment. Once a file is selected and the upload process is initiated, WebAdmin will stream the request to the engine (or a proxy), which will forward it to a host, which in turn will write it to the storage. During the upload process the user will be updated via a progress bar, and will have the ability to cancel an ongoing upload. Pausing and/or resuming uploads may also be supported.

##### GUI Flow

The Image Upload operation will be accessible in the Storage area of WebAdmin, by selecting an ISO domain or Data domain, for ISOs and VM Disk Images (respectively). <TODO mockup>

An image must be selected, after which the upload can be initiated. <TODO mockup>

The user will see a progress bar and can cancel the operation if desired. <TODO mockup>

##### Technical Details

To work around limitations in file size for the necessary HTTP requests, the upload will be chunked and will follow a similar convention to the APIs used by other cloud providers.

![](Image_Upload-HTTP_Sequence_Diagram.png "Image_Upload-HTTP_Sequence_Diagram.png")

The request to initiate the upload will be transmitted to the engine, which will:

*   Instruct VDSM to allocate space for the image
*   Return a URL and token for the client to use when uploading data
*   Lock necessary locks for the upload to be completed safely
*   Record the request and all associated actions (token, locks, etc) in a database table specifically for tracking uploads
*   Create an audit log entry for the upload action

Subsequent requests sending data will need to use this URL and token to tag the data being sent. The data will be supplied by the HTML5 File APIs, which will allow the data to be read from the user's machine, split into chunks, and sent to the engine. As the data is received by the engine, the engine will monitor the process to ensure the entire image is uploaded successfully.

If connection issues occur, the UI code should issue limited retries to ease use of flaky connections. If this is not adequate or other failures occur, the partial upload will remain on the storage for some configurable period of time (hours or days, default TBD). The user can then choose to attempt to resume the upload or cancel it altogether (thus removing the data) if desired. If the data still remains after the configurable time period, a cleanup process running on the engine will remove the stale data. (TODO: is this needed?) During the upload process, the temporary data should be accounted for in space utilization queries, quotas, etc as appropriate. (TODO: determine which places this is needed)

A successful upload will result in the engine unlocking the image and making the image available for use.

##### Code Changes

TBD specifics - this is a list of general changes

GUI

*   New Upload and Remove buttons in Storage > (ISO Domain) > Images
*   New Upload and Remove buttons in Storage > (Data Domain) > Disks
*   New dialog to manage uploading images and code to initiate the request and send data to the engine

*   Uses HTML5 File API, GWT JSNI will likely be needed to integrate this into WebAdmin

*   Is there a way to "background" the upload process?

*   This should use the REST API to communicate with the backend, if possible

*   Progress bar and code to retrieve the status of upload operations
*   Cancel/Resume buttons and associated code to send the appropriate requests to the engine

REST API

*   New request type(s) for uploading data: initiate, send chunk, finalize, cancel, resume

Backend

*   New DB table and POJO for tracking uploads
*   New command for uploading data (lock records, record to db, forwards data to vdsm, etc)
*   Cleanup process to periodically scan for and remove incomplete, expired uploads
*   New servlet to forward data so that the engine core doesn't need to manage it?

VDSM

*   Extend do_PUT() or create an alternate method to receive disk data to be written to a storage domain
*   Extend do_PUT() or create a method accepting ISO images to be written to an ISO domain (note: almost all data-oriented methods in VDSM use GUID sets to identify the object, whereas names are used to identify ISOs, making the verbs incompatible)
*   (TBD?) Verb to remove incomplete/expired uploads

#### Download

##### Overview

The download action will allow a URL to be specified from which an image can be pulled down onto a storage domain. After a URL is entered, a process on engine will start that will be responsible for downloading from the URL and forwarding it to a host. A user should be able to cancel an in-progress download operation at any time, as well as see the progress in the GUI or via the API.

##### GUI Flow

The Image Download operation can be reached via the same method as Image Upload. <TODO mockup>

A URL will be entered to identify the image to download. <TODO mockup>

The download can then be initiated. The user will see a progress bar and can cancel the download if desired. <TODO mockup>

##### Technical Details

The download process differs from the upload process mainly in how the engine receives the data needed to send to the host.

Initiation of the download will be done through a standard UI/API request. In the engine a task will spawn that will download data from the given URL and forward it to the host. This task should update a db table with its progress, respond to requests to cancel (possibly also via db), and take care of the download lifecycle. This may include retries and/or resuming the download. As with the image upload, it may be possible to offload the work of downloading toa separate servlet, even on a separate host if desired. In addition, the engine should manage locking, audit logs, etc as it would with an image upload.

As downloaded data is received by the engine, it will be forwarded to a host in the same manner as for image upload. From the host's perspective, the download process should look the same as an upload.

##### Code Changes

This lists the changes needed beyond those required by the image upload process.

GUI

*   New option in the "upload" dialog to provide a URL for the image, and code to initiate the download request
*   Progress bar and code to retrieve the status of download operations
*   Cancel/Resume buttons and associated code to send the appropriate requests to the engine

REST API

*   New request type(s) for downloading data: initiate, finalize, cancel, resume

Backend

*   New DB table and POJO for tracking downloads
*   Task to manage download lifecycle and respond to requests to cancel, pause (if supported), etc
*   Code to integrate download task with prior upload flow to manage locking, logging, etc and forwarding data to the host
*   Necessary changes to the cleanup process to scan for and remove incomplete, expired downloaded data from storage domain

VDSM

*   No changes should be necessary (download appears the same as an upload to the host)

### Security Considerations

In the typical oVirt use case, qcow2-formatted images are created by qemu, with the headers/format controlled by the host software. Because this feature allows that mechanism to be bypassed with the importation of complete images, attention will be paid to the possibility of a compromised image exposing the host data. (TBD: risk analysis, if any.)

### Dependencies / Related Features

*   [ Features/StoragePool_Metadata_Removal](SPM Removal) may provide us with better control of locking images on the storage rather than relying on engine-side locks.

### Limitations

*   Uploading large files via the UI requires HTML5 APIs (File, Blob, FileReader, ...) that were not supported in IE until IE10.

### Documentation / External references

*   <https://bugzilla.redhat.com/1091377>
*   <https://bugzilla.redhat.com/1122970>

### Testing

TBD

### Comments and Discussion

*   Refer to <Talk:ImageUpload>

<Category:Feature>
