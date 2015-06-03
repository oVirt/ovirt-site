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

The goal of this project is to simplify the workflow of moving a new ISO or disk image into the oVirt environment by providing a browser-based UI and REST API through which the upload can be performed. These new methods will support uploading files located on the admin's local machine (e.g. with a file selection dialog in webadmin) or by specifying a remote URI from which oVirt should download the file and place it on the storage domain.

### Owner

*   Name: Greg Padgett <gpadgett@redhat.com>
*   Name: Amit Aviram <aaviram@redhat.com>
*   Name: Nir Soffer <nsoffer@redhat.com>

### Detailed Description

#### Goals

1.  Upload VM Disk Image to Storage Domain
2.  Upload ISO Image to ISO Domain
3.  Download VM Disk Image from URL to Storage Domain
4.  (future?) Download ISO Image from URL to ISO Domain
5.  (future) Import entire OVA
6.  (future) Import and convert (v2v) vmdk
7.  (future) Provide an API to perform random I/O on disk images aready on the storage

Each supported operation will be available in WebAdmin and the REST API. (Users uploading via the REST API will probably want to use a supplementary script or tool.) Select operations, such as VM disk image upload, may be available in the User Portal in future releases.

The implementation will support uploading files much larger than a typical HTTP request, on the order of several (even hundreds) of GB or more, without relying on launching external programs, processes, tools, etc.

#### Limitations

*   IE 10, FF 3.6, or Chrome 13 or greater are required for the Upload functionality due to lack of necessary HTML5 APIs in prior versions

#### User Experience

The upload action will be initiated in webadmin by navigating to Storage > Images > Upload. A local file or remote URI pointing to an image/ISO can be selected. The interface will then discover the image size and type (qcow/raw in the case of disk images) and allow the user to select other flags such as if the image will be bootable.

After the input is set, the user will press OK to begin an upload. The data will be sent either from the machine logged into webadmin (in which case the UI must remain open) or downloaded remotely (in which case the UI can be closed). Progress will be reported during the upload, and after completion the image will appear on the storage domain and be ready for use by attaching the disk to a VM, booting from the ISO, etc.

If the user wishes to cancel the ongoing operation, there will be a place in the UI (TBD) where this can be done. Similarly, resuming an upload is also desired and will (we hope) make it into the initial release.

TBD: dialog/tab/window requirements to allow users to navigate to other areas of webadmin while an upload from the local machine is in progress.

### Technical Details

#### Upload Servlet and vdsm-imaged

Before describing the image upload flow, two new system entities need introduction: the upload servlet, and vdsm-imaged.

The upload servlet is a Java servlet (actually maybe a message-driven bean, edits to this document TBD) that may be on the engine host or another host with the same connectivity as engine: that is, it can be reached directly by clients such as webadmin. It exposes functionality to forward data from client applications in the public/open network onward to virtualization hosts in a private network, avoiding issues related to network accessibility while at the same time offloading data transfer that would otherwise have to take place inside the engine.

The second new entity is vdsm-imaged (ie "vdsm image daemon"). The purpose of this is to provide an API allowing session-based data transfer to/from VM disk and ISO images which would otherwise need to occur in vdsm, allowing vdsm to maintain its purpose of managing VM metadata via JSON (or XML-RPC) without taking on the additional I/O load required for this feature.

While these two entities may be used for an occasional image upload, their purpose is further justified by an upcoming goal of providing an API to perform random I/O on VM disk images, which could serve regular, scripted operations which would have a major impact on the responsiveness of the critical services provided by engine and vdsm.

#### Operation Sequence

The following sequence diagram, described below, details the flow for a successful image upload from a machine logged into webadmin:

![](Image_Upload-HTTP_Sequence_Diagram.png "Image_Upload-HTTP_Sequence_Diagram.png")

(UMLet diagram source: <Media:Image_Upload_Sequence_Diagram.uxf.gz>

When the user starts the upload, a command is executed in the engine backend to initiate the process. This command adds a new disk (or in the case of resumption, verifies an existing disk) of a given name, capacity, flags, etc. When the disk is ready, engine locks it, then sends a command to vdsm to start the transfer session. This prepares the disk and instantiates a ticket which is pushed to vdsm-imaged to authorize later data transfer requests. Engine will also start a command which will persist for the duration of the transfer session, which will persist the session information as well as refresh the transfer ticket (described later).

The engine returns this transfer ticket, along with an additional signed ticket and the servlet URL, to the UI. The UI passes these tickets to the servlet, which creates a session with the UI based on the trust transferred by the engine via the signed ticket. The UI sends data to the servlet in chunks (due to browser bugs preventing streaming of very large amounts of data), which is immediately sent to vdsm-imaged along with the transfer ticket. Vdsm-imaged verifies that the transfer ticket allows the upload and writes the data to the image.

The transfer ticket itself contains information needed to authorize writing to a particular disk image (or ISO). In order to protect against replays and stabilize a system where engine or vdsm may have failed, the ticket will time out after a certain period of time (5 minutes? TBD). As engine is the session manager, the command it started when the transfer was initiated will peridically wake up to renew the session. When it does this, it instruct vdsm to update the expiration of the transfer ticket, in turn extending the ticket lifetime in vdsm-imaged and allowing uploading to continue beyond the original ticket expiration.

Progress reporting during the transfer will occur in one of two ways (TBD): either by vdsm querying vdsm-imaged and returning status through engine, or by the UI asking the servlet to ask vdsm-imaged. Regardless, status will appear in the UI of how much data has been sent.

Once all data has been sent by the UI, it turns back to the engine to close the transfer session. The engine will then ask vdsm to end the session, whereby it revokes the transfer ticket from vdsm-imaged and tears down the image. The engine then unlocks the disk, after which the image will be available on the storage domain to be attached to a VM and used as any other image.

#### Upload Cancellation, Host Maintenance, and Load Balancing

Certain conditions may require interrupting the image upload data transfer. Because this transfer occurs independently from the engine and vdsm, the best way to interrupt it is by revoking the transfer ticket. This is the method used when a user cancels the upload process or when a host is put into maintenance mode. The engine tells vdsm to revoke the ticket, and vdsm in turn revokes it from vdsm-imaged. At this point, vdsm-imaged closes any connections using that ticket, causing failure to propagate up to the UI.

The UI can determine what happened by retrying the request--if vdsm-imaged indicates that the ticket is bad, the UI will query the engine and the engine can reply with a reason for the revocation.

An advantage of this scheme is that by having the UI query the engine and attempt a retry, the engine can choose to redirect the data flow to another servlet and/or host by simply returning a new servlet address and issuing a different set of tickets, allowing for load balancing, host consolidation, or other operations requiring alterations to the data flow.

#### Upload from URI

In addition to uploading a file from the admin's UI session, a file from a URI can also be uploaded to storage. The majority of the flow remains the same, with the exception of the transfer loop. In this case, instead of the UI sending data to the servlet, it will instead send a URI which will spawn a download task. If vdsm-imaged can perform the download then it will do so, otherwise (such as if vdsm-imaged cannot reach the URI) it will be downloaded by the servlet. Job control will remain the same in this case, with the transfer token being the key to continue or stop the task.

#### Flows

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

We can also go via engine to vdsm for the progress, but this path seems shorter and simpler - we don't need to add new verbs to engine and vdsm. (Method TBD)

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

### Security Considerations

*   Image format: In the typical oVirt use case, qcow2-formatted images are created by qemu, with the headers/format controlled by the host software. Because this feature allows that mechanism to be bypassed with the importation of complete images, attention will be paid to the possibility of a compromised image exposing the host data. (TBD: risk analysis, if any.)
*   Servlet access: We should ensure access to the servlet and vdsm-imaged can only occur from the public network with a signed ticket, or from the private network.
*   Access to images: vdsm-imaged must authorize all storage operations against a valid transfer ticket, and must ensure tickets cannot be arbitrarily sent to it by anyone other than vdsm.

### Dependencies / Related Features

*   [ Features/StoragePool_Metadata_Removal](SPM Removal) changes the way the engine works with storage, any interactions with this project should be examined.

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
