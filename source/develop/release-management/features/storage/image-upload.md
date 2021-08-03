---
title: oVirt Image I/O
category: feature
authors:
  - aaviram
  - gpadgett
  - nsoffer
  - derez
---

# oVirt Image I/O

## Documentation

http://ovirt.github.io/ovirt-imageio/

## Summary

The goal of this feature is to simplify the workflow of introducing new oVirt images (e.g ISOs or Disk images) into the oVirt environment, and exposing oVirt existing images, by providing a browser-based UI and REST API through which uploads/downloads can be performed. These new methods will support uploading files located on the admin's local machine (e.g. with a file selection dialog in webadmin) or by specifying a remote URL from which oVirt should fetch the file and place it on the storage domain, and downloading oVirt images to the admin's local machine.

Before introducing this feature, placing images on oVirt's domains involved using the command line, either via the ISO/Disk Uploader tool or manual copying of an ISO image to its domain. Similarly, importing a VM disk image to a data domain requires an import from existing storage, virt-v2v operation, or other manual method. On the other way, it wasn't possible to expose these images in any way except manually reaching them via oVirt's host.

## Owner

*   Name: Greg Padgett <gpadgett@redhat.com>
*   Name: Amit Aviram <aaviram@redhat.com>
*   Name: Nir Soffer <nsoffer@redhat.com>
*   Name: Daniel Erez <derez@redhat.com>

## Detailed Description

### Goals

1.  Upload VM images to oVirt Storage.
2.  Upload VM images from a URL to oVirt Storage.
3.  Download oVirt Images.
4.  Provide a [REST] API to upload/download and/or perform random I/O on disk images on the storage.
5.  (future) Import entire OVA
6.  (future) Import and convert (v2v) vmdk

Each supported operation will be available in Webadmin and the REST API. Select operations, such as VM disk image upload, may be available in the User Portal in future releases. REST API users will want to use a script or other automation for ease of use.

The implementation will support uploading files much larger than a typical HTTP request, on the order of several (even hundreds) of GB or more, without relying on launching external programs, processes, tools, etc.

### Limitations

*   IE 10, Firefox 3.6, or Chrome 13 or greater are required to upload via Webadmin due to lack of necessary HTML5 APIs in older browsers. The UI will detect this and enable upload only if supported.

### User Experience

The upload action for a VM disk is initiated and controlled in Webadmin by navigating to _Storage_ > _file_/_block domain_ > _Disks_, or _Disks_ tab- And using the control buttons present; ISO upload will be under _Storage_ > _ISO domain_ > _Images_.

A dialog will allow the user to select the image source (local file browser or a remote URL) and--for disk images--details for the disk creation. The interface will verify the image type, qcow2 header if applicable, and verify that the image will fit on the created disk.

After the input is set, the user will press OK to begin the upload. For a local file upload, data will be sent from a background process in the UI; if a URL was selected, the proxy will download the image without the UI's necessary involvement.

The image will appear in the tab from which the upload was initiated, where progress can be viewed and the image can be paused/resumed or cancelled. After completion the image will appear on the storage domain and be ready for use by attaching the disk to a VM, booting from the ISO, etc.

### ovirt-imageio

Before describing the image upload flow, a new ovirt project needs introduction: ovirt-imageio.

This project is composed by three sub-projects: ovirt-imageio-proxy, ovirt-imageio-daemon, and a common project ovirt-imageio-common which both are using.

ovirt-imageio-proxy is a Python daemon that can run on the engine host or on another machine having the same connectivity as engine: that is, it can be reached directly by clients such as webadmin as well as communicate with the virt hosts. It exposes an API to accept data from client applications in the public/open network to forward to the virtualization hosts in the private network, avoiding issues related to network accessibility while at the same time offloading data transfer that would otherwise have to take place inside the engine. It also will contain functionality that can fetch image data from a remote URL, an alternative to accepting it from the client, which enables the upload-from-URL functionality mentioned above.

The second new entity is ovirt-imageio-daemon. The purpose of this is to provide an API allowing session-based data transfer between clients and images which would otherwise need to occur in VDSM, allowing VDSM to maintain its purpose of managing VM metadata via JSON (or XML-RPC) without taking on the additional I/O load required for this feature.

While these two entities may be used for an occasional image upload, their purpose is further justified by an upcoming goal of providing an API to perform random I/O on VM disk images, which could serve regular, scripted operations that could otherwise have a major impact on the responsiveness of the critical services provided by engine and VDSM.

### Operation Sequence

The following sequence diagram, described below, details the flow for a successful image  transfer from a machine logged into webadmin:

![](/images/wiki/Image_Upload-HTTP_Sequence_Diagram.png)


Using the webadmin, when the user starts a transfer, the UI executes a TransferImageCommand on the backend to initiate the process. The command writes an ImageTransfer entity to the database to track the job and returns its ID tothe UI. The UI and command now both execute asynchronously: the UI polls the entity status using TransferImageCommand, while the backend initializing the transfer, (e.g. in upload, creates a disk/ISO if it is not already supplied, gives it a name, capacity, flags, etc.)

When the disk is ready, engine locks it and executes the StartImageTransferSession VDSM verb to start the transfer session. This prepares the disk and instantiates a ticket which is pushed to ovirt-imageio-daemon to authorize later data transfer requests.

The engine then updates the ImageTransfer entity, letting the client (UI or REST client) know that it can start sending data. It also returns the transfer ticket, an additional signed ticket, and the ovirt-imageio-proxy service URL to the UI. The UI passes these tickets to the proxy with its first data transfer, which creates a session with the UI based on the trust transferred by the engine via the signed ticket. Note here, that in the webadmin flow- the browser must add the engine's CA Cert to its trusted authorities list, otherwise it will block the connection. 

Data is now sent to the proxy in chunks (browser bugs prevent streaming very large amounts of data), which is sent to ovirt-imageio-daemon accompanied by the transfer ticket. ovirt-imageio-proxy verifies that the transfer ticket allows the transfer and writes the data to the image. The transfer ticket itself contains information needed to authorize writing/reading to/from a particular disk image (or ISO). In order to protect against replays and stabilize a system where engine or VDSM may have failed, the ticket will time out after a certain period of time (default 5 minutes).

There are three periodic communication sequences occurring while the data is being sent:

1.  Engine extends the image transfer session by executing the VDSM verb ExtendImageTransferSession. VDSM then updates the transfer ticket expiration in ovirt-imageio-daemon.
2.  The UI sends a heartbeat to the engine to let it know the data is still being transferred. If this isn't received, engine will assume the UI has closed and will stop the image transfer session. This update is implicitly made by updating the transfer status, using TransferImageStatusCommand.

Once all data has been sent/received by client, it updates the ImageTransfer entity using TransferImageStatusCommand. Flow control shifts back to the engine, which will close the transfer session. The engine will also tell VDSM to end the transfer session, whereby vdsm revokes the transfer ticket from ovirt-imageio-daemon, verifies it, and tears down the image. The engine then unlocks the disk, after which the image will be available on the storage domain to be attached to a VM and used as any other image. Finally, engine will remove the ImageTransfer entity, and the UI will display that the upload is complete.

### Upload Pause/Resume, Cancellation, Host Maintenance, and Load Balancing

The user can choose to pause and/or cancel an in-progress transfer. Pausing the session via the webadmin can be performed only when uploading. To do so, the image can be selected in the UI and the Pause or Cancel buttons can be pressed. Either action will update the ImageTransfer entity, causing the UI to stop sending data, and the backend will stop the image transfer session. Cancellation will cause the backend command to mark the image as illegal and stop. Pausing the transfer will leave the backend command active, periodically polling for resumption.

To resume an upload, the user can select a paused upload and press the Resume button. A local file or remote URL can be specified. The image data will be (partially, quickly) verified against the new file, and the ImageTransfer status will be updated such that the engine command resumes the image transfer session. The UI will then resume sending data where it had previously left off.

Host Maintenance: TBD

Load Balancing (not yet implemented): the engine can at any point decide to stop the image transfer session and establish a new one with a different proxy and/or virtualization host. The failure will be detected by the proxy and will bubble up, where the UI can query the engine to attempt a retry. The engine can choose to redirect the data flow to another proxy and/or host by simply returning a new servlet address and issuing a different set of tickets, allowing for load balancing, host consolidation, or other operations requiring alterations to the data flow.

### Upload from URL

The majority of the flow between uploading a file from the admin's UI session vs. a file from a URL remains the same, with the exception of the transfer loop. In this case, instead of the UI sending data to the proxy, it will instead send a URL which will cause a download task to be spawned. The proxy will download the data and forward it to ovirt-imageio-daemon. Job control will depend on communication with the proxy in this case rather than the UI.

### REST API and Image I/O

The REST API can be used for image upload from a file, URL, for download an image, or for random I/O access to images on the storage.

The flows for these operations will be similar to that described above: a transfer session will be initiated via engine, the data will be sent to the proxy, and when complete, the session should be closed via the engine API. There are a couple differences. Note, that the REST API is just for managing the transfer, where the actual data transfer is being done by a tool to be chosen by the client. This means that the client will be responsible for receiving the transfer and signed tickets and sending them on to the proxy.

For a detailed information and examples regarding the usage of the Image I/O REST API, please refer to the api-model documentation, which can be found in /api/Model under your running engine.

### Flows

* __Starting a new transfer session__
  * The user requests to start a transfer session.
    * A new transfer can be started, with a supplied image or without. If one is not supplied, the Engine will create one.
  * The Engine starts to poll the command until it finishes its initialization.
  * Once the initialization is over, Engine tells VDSM to start an image transfer session with a ticket.
  * VDSM prepares an image.
  * VDSM sends the transfer ticket to ovirt-imageio-daemon.
  * Engine sends tickets back to the client.
  * The client starts sending/receiving data with its ticket.
  * Proxy verifies ticket and open connection to ovirt-imageio-daemon
  * Proxy sends ticket uuid to ovirt-imageio-daemon
  * ovirt-imageio-daemon verifies that it has a ticket with this uuid.
  * proxy pushes data to ovirt-imageio-daemon.
  * ovirt-imageio-daemon writes data to path associated with the ticket.
  * The client sends data to the proxy, while extending the session through the Engine.
    * In each request, the client finishes sending data, waits for 200 OK from proxy,
    * Proxy finished, waits for 200 OK from ovirt-imageio-daemon.
    * ovirt-imageio-daemon returns 200 OK.
  * The client finishes, finalizes the session with engine.
  * engine tells VDSM to end the session.
  * VDSM revokes the ticket for this session.
  * ovirt-imageio-daemon removes the ticket.
  * VDSM tears down the image.
  * VDSM verifies the image.
  * Engine frees the image, making it ready for use.

* **Upload from URL**
  * A transfer flow is being established as described above.
  * (TBD) The client sends the URL to the proxy, which opens a stream channel from the URL into ovirt-imageio-daemon.

* **Reporting progress (Currently available only from the UI)**
  * After every successful request, the UI updates the engine with the status of the transfer, mentioning the amount of data sent.
  * Engine saves this info in the transfer's entity in the DB.
  * UI displays current progress.

* **Putting host in maintenance (TBD)**
  * engine tells VDSM to revoke the tickets
  * VDSM revokes ovirt-imageio-daemon tickets
  * ovirt-imageio-daemon closes connections using revoked tickets
  * VDSM tears down images
  * UI may retry operation, will get another host to continue the upload/download

* **Cancel operation**
  * UI sends cancel session request to engine
  * engine tells VDSM to revoke the ticket due to cancellation
  * VDSM revokes the ovirt-imageio-daemon ticket
  * ovirt-imageio-daemon deletes the ticket and closes connections
  * VDSM tears down image

* **Renewing a ticket**
  * engine sends new renew session ticket request to VDSM
  * VDSM updates the ticket expiration time
  * ovirt-imageio-daemon restarts expiration timer for this ticket

* **Pausing a transfer**
  * The client chooses to pause the transfer.
  * A transfer status is sent to the Engine, stating that the current phase is `paused`
  * The Engine calls a VDSM verb to stop the session.
  * VDSM sends a request to ovirt-imageio-daemon
  * ovirt-imageio-daemon stops the session
  * The engine's command keeps polling the tranfer, until it will be resumed by the client.
  * When the client will resume the transfer, a new session will be requested from ovirt-imageio-daemon, and the transfer flow will continue as described above.

## Security Considerations

*   Image format: In the typical oVirt use case, qcow2-formatted images are created by qemu, with the headers/format controlled by the host software. Because this feature allows that mechanism to be bypassed with the importation of complete images, attention will be paid to the possibility of a compromised image exposing the host data. (TBD: risk analysis, if any.)
*   Proxy access: We should ensure access to the proxy and ovirt-imageio-daemon can only occur from the public network with a signed ticket, or from the private network.
*   Access to images: ovirt-imageio-daemon must authorize all storage operations against a valid transfer ticket, and must ensure tickets cannot be arbitrarily sent to it by anyone other than VDSM.

## Dependencies / Related Features

*   [StoragePool Metadata Removal](/develop/release-management/features/storage/storagepool-metadata-removal.html) changes the way the engine works with storage, any interactions with this project should be examined.

## Limitations

*   Uploading large files via the UI requires HTML5 APIs (File, Blob, FileReader, ...) that were not supported in IE until IE10.

## External references

*   <https://bugzilla.redhat.com/show_bug.cgi?id=1091377>
*   <https://bugzilla.redhat.com/show_bug.cgi?id=1122970>

