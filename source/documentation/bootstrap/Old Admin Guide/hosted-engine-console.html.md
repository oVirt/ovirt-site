---
title: Hosted Engine Console
authors: didi
wiki_title: Hosted Engine Console
wiki_revision_count: 1
wiki_last_updated: 2015-07-01
---

# Hosted Engine Console

How to access the hosted-engine VM's console during deploy.

If you run deploy directly on the host's console, and have X, using remote-viewer directly is simplest.

If you ssh to the host from some other machine that has X, such as your laptop, you basically have two options: Either use ssh X11 forwarding and run the client on the host (with its window opening on your local machine through the X11 forwarding), or run the client locally on your host. In each case, you can either use a client that connects directly to qemu to get the console, or a client that first connects to libvirtd to get the console's port. The latter is generally not needed, because the port number will always be 5900, as the hosted-engine VM is the first and only one on the machine (deploy aborts if it detects other VMs running).

The deploy process asks about the VM's console type, and allows two options - spice or vnc.

## Client on host

For this to work, you have to install the client on the host, and allow it to run there - either by running it on its console (inside X), or remotely through ssh X11 forwarding (-X or -Y options to ssh).

Run the client with:

*   spice:

      /bin/remote-viewer --spice-ca-file=/etc/pki/vdsm/libvirt-spice/ca-cert.pem spice://localhost?tls-port=5900 --spice-host-subject="C=EN, L=Test, O=Test, CN=Test"

*   vnc:

      /bin/remote-viewer vnc://localhost:5900

## Remote client, ssh tunneling only

Create the tunnel:

      ssh -L5900:localhost:5900 root@$HOST

*   spice:

Copy ca cert from remote host to your local machine:

      scp -p root@$HOST:/etc/pki/vdsm/libvirt-spice/ca-cert.pem /tmp

Then run the client:

      spicec -h localhost -s 5900 --ca-file /tmp/ca-cert.pem --host-subject 'C=EN, L=Test, O=Test, CN=Test' -w $PASSWORD

or:

      remote-viewer --spice-ca-file=/tmp/ca-cert.pem spice://localhost?tls-port=5900 --spice-host-subject="C=EN, L=Test, O=Test, CN=Test"

*   vnc:

      vncviewer :0

## Remote client, connect to libvirt and use tls

You'll have to open libvirtd access on the firewall (with ssl/tls, port 16514 by default)

TODO verify and add commands using remote-viewer, perhaps also virsh. See also [https://bugzilla.redhat.com/show_bug.cgi?id=1215436 bug 1215436](https://bugzilla.redhat.com/show_bug.cgi?id=1215436 bug 1215436)
