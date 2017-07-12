---
title: How to Connect to SPICE Console Without Portal
category: howto
authors: amuller, apuimedo, djasa, jniederm
---

# How to Connect to SPICE Console Without Portal

Sometimes User or Admin Portal isn't the best way to launch a SPICE console, or worse, it doesn't work at all. For these cases (or for debugging), there are alternative ways to launch the console. This article will describe them, ordered from cleanest to hackier ones.

## Under the Hood

So what happens when you hit the "Console" button?

1.  ovirt-engine sets a new password and it's expiry time (by default 120 s) which compose together a ticket
2.  ovirt-engine looks up other connection details (more on them later) in its database
3.  ovirt-engine passes all the connection info to the portal
4.  portal sets variables on spice-xpi object
5.  spice-xpi launches spice client and passes variables to it via unix socket
6.  spice client connects directly to a host using data given to it by the portal

## Assumptions and Prerequisities

*   client used: `remote-viewer`, in Fedora/RHEL included in `virt-viewer` package. The old client is goo'ol' spicec which uses slightly different CLI syntax
*   the whole ovirt setup is TLS-secured
*   the ovirt-engine, the hypervisor and the client you're connecting from are distinct computers. If some of them are the same, things get somewhat simpler
    -   assuming Fedora/RHEL hypervisor, things might be slightly different for ovirt-node
*   some variables used troughout the article:
    -   `CA_FILE`: file with ovirt CA certificate file - you'll have to choose it's location and name (it may end in .pem, .cer and .crt extension, prefer .pem for consistency)
    -   `OVIRT`: name/IP of the ovirt engine
    -   `USER`, `PASS`: self-explaining, user in form of `user@domain`
    -   `VM_NAME`, `VM_UUID`: self-explaining
    -   `HOST`, `HOST_UUID`: hypervisor name/IP and UUID
    -   `PORT`: non-tls port qemu is listening on
    -   `SPORT`: tls port qemu is listening on
    -   `SUBJECT`: host subject of the hypervisor. More on last three later

## Getting ovirt-engine CA

You should do this only over trustworthy network (or have ssh keys verified...)! If you are connecting over an insecure network (internet), you should either already have oVirt CA cert on your client or replace oVirt's root CA with an intermediate CA signed by root CA which you already have on the disk!

*   from the web: `wget -O ${CA_FILE} http://${OVIRT}/ovirt-engine/services/pki-resource?resource=ca-certificate&format=X509-PEM-CA`
*   from the engine via ssh: `scp root@${OVIRT}:/etc/pki/ovirt-engine/ca.pem ${CA_FILE}`
*   from the host via ssh: `scp root@${HOST}:/etc/pki/vdsm/libvirt-spice/ca-cert.pem ${CA_FILE}`

## Clean Methods

All of these are supported and encouraged to be used in production whenever they fit. They don't require any direct actions on the hosts, all your communication (apart from actual client lauch) is with ovirt-engine.

### Connecting Using ovirt-shell "automatically"

Install ovirt-shell on the client if not present. On Fedora:

` root@client# `**`yum` `install` `ovirt-engine-cli`**

run ovirt-shell and connect to the VM from it:

       bash$ ovirt-shell
       [oVirt shell (disconnected)]# connect `[`https://`](https://)`${OVIRT}/ ${USER} ${PASS} 
       [oVirt shell (connected)]# console ${VM_NAME}

client window should pop-up

### Connecting Using ovirt-shell "manually"

If the steps above don't work, you can lauch the client manually based on info ovirt-shell gives you:

` client$ `**`ovirt-shell`**
` [oVirt shell (disconnected)]# `**`connect` [`https://`](https://)`${OVIRT}/` `${USER}` `${PASS}`**
` [oVirt shell (connected)]# `**`show` `vm` `${VM_NAME}`**
       ...
       display-address           : `**`10.34.58.4`**`        # HOST is in bold
       ...
       display-port              : `**`5914`**`              # PORT
       display-secure_port       : `**`5915`**`              # SPORT
       ...
       host-id                   : `**`f35dd7be-51b6-11e1-9275-0016365acdc4`**`      # HOST_UUID

Now get last remaining bit of info about host:

` [oVirt shell (connected)]# `**`show` `host` `${HOST_UUID}`**
       ...
       certificate-subject                  : `**`O=organization` `name,` `CN=common-name`**`         # SUBJECT

The host subject has to be stripped of spaces after commas, in this case it will look like this: `O=organization name,CN=common-name`

And set the ticket:

` [oVirt shell (connected)]# `**`action` `vm` `${VM_NAME}` `ticket`**
` ticket-value : `**`YvwK2U403JXk`**

Now you can connect to the VM (you'll be asked for password in a modal window):

       bash$ remote-viewer --spice-ca-file ${CA_FILE} --spice-host-subject "${SUBJECT}" spice://${HOST}/?port=${PORT}\&tls-port=${SPORT}
       

### Connecting Using REST API

ovirt-shell is in fact nothing more than nicely wrapped up oVirt REST API, so if you don't have it installed, you can get the same info using just `curl`:

       # find your VM:
` client$ `**`curl` `--cacert` `${CA_FILE}` `-u` `${USER}:${PASS}` `-H` `"Content-Type:` `application/xml"` `-X` `GET` `"`[`https://`](https://)`${OVIRT}/api/vms"`**
       ... lots of xml
`     `<vm href="**\1**" id="**\1**">
`         `<name>`${VM_NAME}`</name>

In XML of this VM, look up necessary info:

*   URI to post to when you'll set the ticket:

`             `<link href="/api/vms/${VM_UUID}/ticket" rel="ticket"/>

Client connection details (HOST, PORT and SPORT):

`         `<display>
`             `<type>`spice`</type>
                   

<address>
**10.34.58.4**

</address>
`             `<port>**`5914`**</port>
`             `<secure_port>**`5915`**</secure_port>
                   
`         `</display>

Host UUID:

`         `<host href="**\1**" id="${HOST_UUID}"/>

Now look up host hubject of the host (and delete the space after comma again):

` client$ `**`curl` `--cacert` `${CA_FILE}` `-u` `${USER}:${PASS}` `-H` `"Content-Type:` `application/xml"` `-X` `GET` `"`[`https://`](https://)`${OVIRT}/api/hosts/${HOST_UUID}"`**
`         `<subject>`O=some organization, CN=common-name`</subject>

Set the ticket:

` client$ `**`curl` `--cacert` `${CA_FILE}` `-u` `${USER}:${PASS}` `-H` `"Content-Type:` `application/xml"` `-X` `POST` `-d` `'`<action><ticket><expiry>`120`</expiry></ticket></action>`'` `"`[`https://`](https://)`${OVIRT}/api/vms/${VM_UUID}/ticket"`**
       ...
`         `<value>**`6BOZ+27RAWrt`**</value>

Connect to the client again (again, r-v will ask for the password in a pop-up window):

` bash$ `**`remote-viewer` `--spice-ca-file` `${CA_FILE}` `--spice-host-subject` `"${SUBJECT}"` `spice://${HOST}/?port=${PORT}\&tls-port=${SPORT}`**
       

## Hacky Methods

Actually only one method will be described. Other methods exist but you won't need them as long as your goal is to have Vms managed by oVirt...

### Set Ticket using vdsClient

First you'll have to pinpoint on which host the VM is running in Admin Portal, ovirt-shell or REST API. Then you have to get VM_UUID and pid of qemu process that runs your VM (QEMU_PID):

` bash$ `**`ssh` `root@${HOST}`**
` root@HOST# `**`vdsClient` `-s` `0` `list` `table`**
       `**`${VM_UUID}`**`    `**`${QEMU_PID}`**`     ${VM_NAME}      ${VM_STATUS}

find out ports where qemu is listening:

` root@HOST# `**`ps` `-f` `${QEMU_PID}`**
       qemu     ${QEMU_PID}     1  1 Jul17 ?        Sl   513:33 /usr/libexec/qemu-kvm ... -spice port=`**`5914`**`,tls-port=`**`5915`**`,... ...

find out host subject and do the usual space-after-comma deletion:

` root@HOST# `**`openssl` `x509` `-in` `/etc/pki/vdsm/libvirt-spice/server-cert.pem` `-noout` `-text` `|` `grep` `Subject:`**
`         Subject: `**`O=some` `organization,` `CN=common-name`**

set the ticket. You have to set both password and its time validity:

` root@HOST# `**`vdsClient` `-s` `0` `setVmTicket` `${VM_UUID}` `${PASS}` `${VALIDITY}`**

Now you can log out from the host and connect with a spice client:

       bash$ **\1**

## It Still Doesn't work!

Well, check that:

*   your host's display interface is reachable from the client:

         root@client# nmaps -sS -p ${PORT},${SPORT} ${HOST}
         ...
         PORT     STATE SERVICE
         5914/tcp `**`open`**`  unknown
         5915/tcp `**`open`**`  unknown

*   verify that host subject exposed by REST API is the same as the one in `/etc/pki/vdsm/libvirt-spice/server-cert.pem` on respective host
*   verify that host subject does not contain spaces after commas, so it should look like this: `O=org,CN=common-name`, not like this `O=org, CN=common-name`

