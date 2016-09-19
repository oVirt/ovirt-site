---
title: Image Upload
category: feature
authors: gpadgett
wiki_category: Feature
wiki_title: Features/Image Upload
wiki_revision_count: 9
wiki_last_updated: 2015-11-18
feature_name: Image Upload
feature_modules: engine,storage,vdsm
feature_status: Implementation
---

# Image Upload

## Summary

Placing an ISO on an ISO domain today involves using the command line, either via the ISO Uploader tool or manual copying of the ISO image. Similarly, importing a VM disk image to a data domain requires an import from existing storage, virt-v2v operation, or other manual method.

The goal of this project is to simplify the workflow of introducing new ISOs or disk images into the oVirt environment by providing a browser-based UI and REST API through which uploads can be performed. These new methods will support uploading files located on the admin's local machine (e.g. with a file selection dialog in webadmin) or by specifying a remote URL from which oVirt should download the file and place it on the storage domain.

## Owner

*   Name: Greg Padgett <gpadgett@redhat.com>
*   Name: Amit Aviram <aaviram@redhat.com>
*   Name: Nir Soffer <nsoffer@redhat.com>

## Detailed Description

### Goals

1.  Upload VM Disk Image to Storage Domain
2.  Upload ISO Image to ISO Domain
3.  Download VM Disk Image from URL to Storage Domain
4.  Download ISO Image from URL to ISO Domain
5.  (soon) Provide a [REST] API to upload and/or perform random I/O on disk images on the storage
6.  (future) Import entire OVA
7.  (future) Import and convert (v2v) vmdk

Each supported operation will be available in Webadmin and the REST API. Select operations, such as VM disk image upload, may be available in the User Portal in future releases. REST API users will want to use a script or other automation for ease of use.

The implementation will support uploading files much larger than a typical HTTP request, on the order of several (even hundreds) of GB or more, without relying on launching external programs, processes, tools, etc.

### Limitations

*   IE 10, Firefox 3.6, or Chrome 13 or greater are required to upload via Webadmin due to lack of necessary HTML5 APIs in older browsers. The UI will detect this and enable upload only if supported.

### User Experience

The upload action for a VM disk will be initiated and controlled in Webadmin by navigating to Storage > <file/block domain> > Disks and using the control buttons present; ISO upload will be under Storage > <ISO domain> > Images.

A dialog will allow the user to select the image source (local file browser or a remote URL) and--for disk images--details for the disk creation. The interface will verify the image type, qcow header if applicable, and verify that the image will fit on the created disk.

After the input is set, the user will press OK to begin the upload. For a local file upload, data will be sent from a background process in the UI; if a URL was selected, the proxy will download the image without the UI's necessary involvement.

The disk or ISO will appear in the tab from which the upload was initiated, where progress can be viewed and the image can be paused/resumed or cancelled. After completion the image will appear on the storage domain and be ready for use by attaching the disk to a VM, booting from the ISO, etc.

## Technical Details

### Upload Servlet and vdsm-imaged

Before describing the image upload flow, two new system entities need introduction: the upload proxy, and vdsm-imaged.

The upload proxy is a Python daemon that can run on the engine host or on another machine having the same connectivity as engine: that is, it can be reached directly by clients such as webadmin as well as communicate with the virt hosts. It exposes an API to accept data from client applications in the public/open network to forward to the virtualization hosts in the private network, avoiding issues related to network accessibility while at the same time offloading data transfer that would otherwise have to take place inside the engine. It also will contain a downloader that can fetch image data from a remote URL, an alternative to accepting it from the client, which enables the upload-from-URL functionality mentioned above.

The second new entity is vdsm-imaged (ie "vdsm image daemon"). The purpose of this is to provide an API allowing session-based data transfer between clients and images which would otherwise need to occur in vdsm, allowing vdsm to maintain its purpose of managing VM metadata via JSON (or XML-RPC) without taking on the additional I/O load required for this feature.

While these two entities may be used for an occasional image upload, their purpose is further justified by an upcoming goal of providing an API to perform random I/O on VM disk images, which could serve regular, scripted operations that could otherwise have a major impact on the responsiveness of the critical services provided by engine and vdsm.

### Operation Sequence

The following sequence diagram, described below, details the flow for a successful image upload from a machine logged into webadmin:

![](Image_Upload-HTTP_Sequence_Diagram.png "Image_Upload-HTTP_Sequence_Diagram.png")

(UMLet diagram source: <Media:Image_Upload_Sequence_Diagram.uxf.gz>

When the user starts an upload, the UI executes Upload[Disk|Iso]ImageCommand on the backend to initiate the process. The command writes an ImageUpload entity to the database to track the job and returns its ID to the UI. The UI and command now both execute asynchronously: the UI polls the entity status using UploadImageCommand, while the backend creates a disk/ISO of a given name, capacity, flags, etc. When the disk is ready, engine locks it and executes the StartImageTransferSession vdsm verb to start the transfer session. This prepares the disk and instantiates a ticket which is pushed to vdsm-imaged to authorize later data transfer requests.

The engine then updates the ImageUpload entity, letting the UI know that it can start sending data. It also returns the transfer ticket, an additional signed ticket, and the servlet URL to the UI. The UI passes these tickets to the servlet with its first data transfer, which creates a session with the UI based on the trust transferred by the engine via the signed ticket.

Data is now sent to the servlet in chunks (browser bugs prevent streaming very large amounts of data), which is sent to vdsm-imaged accompanied by the transfer ticket. Vdsm-imaged verifies that the transfer ticket allows the upload and writes the data to the image. The transfer ticket itself contains information needed to authorize writing to a particular disk image (or ISO). In order to protect against replays and stabilize a system where engine or vdsm may have failed, the ticket will time out after a certain period of time (default 5 minutes).

There are three periodic communication sequences occurring while the data is being sent:

1.  Engine extends the image transfer session by executing the vdsm verb ExtendImageTransferSession. Vdsm then updates the transfer ticket expiration in vdsm-imaged.
2.  The UI sends a heartbeat to the engine to let it know the data is still being uploaded. If this isn't received, engine will assume the UI has closed and will stop the image transfer session.
3.  Engine will poll for the transfer session statistics to retrieve the amount of data uploaded. It updates the ImageUpload entity with this information, allowing a) the status to be displayed in the UI, and b) resumption to occur at the proper offset.

Once all data has been sent by the UI, it updates the ImageUpload entity using UploadImageStatusCommand. Flow control shifts back to the engine, which will close the transfer session. The engine will also tell vdsm to end the transfer session, whereby vdsm revokes the transfer ticket from vdsm-imaged and tears down the image. The engine then unlocks the disk, after which the image will be available on the storage domain to be attached to a VM and used as any other image. Finally, engine will remove the ImageUpload entity, and the UI will display that the upload is complete.

### Upload Pause/Resume, Cancellation, Host Maintenance, and Load Balancing

The user can choose to pause and/or cancel an in-progress upload. To do so, the image can be selected in the UI and the Pause or Cancel buttons can be pressed. Either action will update the ImageUpload entity, causing the UI to stop sending data, and the backend will stop the image transfer session. Cancellation will cause the backend command to mark the image as illegal and stop. Pausing the upload will leave the backend command active, periodically polling for resumption.

To resume an upload, the user can select a paused upload and press the Resume button. A local file or remote URL can be specified. The image data will be (partially, quickly) verified against the new file, and the ImageUpload status will be updated such that the engine command resumes the image transfer session. The UI will then resume sending data where it had previously left off.

Host Maintenance: TBD

Load Balancing (not yet implemented): the engine can at any point decide to stop the image transfer session and establish a new one with a different proxy and/or virtualization host. The failure will be detected by the proxy and will bubble up, where the UI can query the engine to attempt a retry. The engine can choose to redirect the data flow to another servlet and/or host by simply returning a new servlet address and issuing a different set of tickets, allowing for load balancing, host consolidation, or other operations requiring alterations to the data flow.

### Upload from URL

The majority of the flow between uploading a file from the admin's UI session vs. a file from a URL remains the same, with the exception of the transfer loop. In this case, instead of the UI sending data to the proxy, it will instead send a URL which will cause a download task to be spawned. The proxy will download the data and forward it to vdsm-imaged. Job control will depend on communication with the proxy in this case rather than the UI.

### REST API and Image I/O

The REST API can be used for Image Upload from a file, Image Upload from a URL, or for random I/O access to images on the storage.

The flows for these operations will be similar to that described above: an upload session will be initiated via engine, the data will be sent to the proxy, and when complete, the session should be closed via the engine API. There are a couple differences, however:

*   The random I/O operation will require a new API that allows read/write access to an existing image.
*   The periodic heartbeat to the engine is optional and can be disabled for simpler usage via script, etc.
*   The client will be responsible for receiving the transfer and signed tickets and sending them on to the proxy.
*   The engine may (TBD) be able to return an HTTP redirection to the client, wherein the client only needs to be instructed to send data to a certain endpoint. Engine could get the initial request, initialize the sessions, return a redirect (with an auth cookie to handle the tickets?), and the client could then proceed to send data to the redirected endpoint.

There is still some investigation to do here as to what is possible and/or what requirements we can place on the client for successful integration with other projects.

### Flows

TDB: review

*   upload from file

      - engine tells vdsm to start an image transfer session with a ticket
      - vdsm prepares an image
      - vdsm sends the transfer ticket to imaged
      - engine sends tickets to ui
      - ui starts upload with ticket
      - proxy verifies ticket and open connection to imaged
      - proxy sends ticket uuid to imaged
      - imaged verifies that it has a ticket with this uuid
      - proxy pushes data to imaged
      - imaged writes data to path associated with the ticket
      - ui finishes sending data, waits for 200 OK from proxy
      - proxy finished, waits for 200 OK from imaged
      - imaged returns 200 OK
      - ui finishes, finalizes the session with engine
      - engine tells vdsm to end the session
      - vdsm revokes the ticket for this session
      - imaged removes the ticket
      - vdsm tears down the image

*   upload from uri

      - engine tells vdsm to start transfer session with a ticket
      - vdsm prepares an image
      - vdsm sends the transfer ticket to imaged
      - engine passes ticket to ui
      - ui sends get request to proxy with the signed ticket
      - proxy verifies ticket
      - proxy sends get request to imaged with the ticket uuid
      - imaged verifies ticket uuid
      - imaged sends requested data
      - imaged sends 200 OK
      - ui and proxy succeed, tells engine to end the session
      - engine tells vdsm to end the session
      - vdsm revokes the ticket for this session
      - imaged deletes the ticket

*   random-io

      - engine starts a session with vdsm
      - vdsm prepares an image
      - vdsm sends the transfer ticket to imaged
      - engine returns the ticket to client
      - client performs some requests with proxy
      - proxy sends requests to imaged with ticket uuid
      - when client finishes, it tells engine to end the session
      - engine ends the session with vdsm
      - vdsm revokes the ticket
      - imaged deletes the ticket
      - vdsm tears down the image

*   reporting progress

      - ui sends progress request to proxy with request id
      - proxy sends progress request to imaged
      - ui displays current progress

We can also go via engine to vdsm for the progress, but this path seems shorter and simpler - we don't need to add new verbs to engine and vdsm. However, in the download case the engine will (Method TBD)

*   putting host in maintenance

      - engine tells vdsm to revoke the tickets
      - vdsm revokes imaged tickets
      - imaged closes connections using revoked tickets
      - vdsm tears down images
      - ui may retry operation, will get another host to continue the upload/download

*   cancel operation

      - ui sends cancel session request to engine
      - engine tells vdsm to revoke the ticket due to cancellation
      - vdsm revokes the imaged ticket
      - imaged deletes the ticket and closes connections
      - vdsm tears down image

*   renewing a ticket

      - engine sends new renew session ticket request to vdsm
      - vdsm updates the ticket expiration time
      - vdsm-imaged restarts expiration timer for this ticket

## Security Considerations

*   Image format: In the typical oVirt use case, qcow2-formatted images are created by qemu, with the headers/format controlled by the host software. Because this feature allows that mechanism to be bypassed with the importation of complete images, attention will be paid to the possibility of a compromised image exposing the host data. (TBD: risk analysis, if any.)
*   Proxy access: We should ensure access to the proxy and vdsm-imaged can only occur from the public network with a signed ticket, or from the private network.
*   Access to images: vdsm-imaged must authorize all storage operations against a valid transfer ticket, and must ensure tickets cannot be arbitrarily sent to it by anyone other than vdsm.

## Dependencies / Related Features

*   [ Features/StoragePool_Metadata_Removal](SPM Removal) changes the way the engine works with storage, any interactions with this project should be examined.

## Limitations

*   Uploading large files via the UI requires HTML5 APIs (File, Blob, FileReader, ...) that were not supported in IE until IE10.

## Documentation / External references

*   <https://bugzilla.redhat.com/1091377>
*   <https://bugzilla.redhat.com/1122970>

## Testing

TBD

## Comments and Discussion


