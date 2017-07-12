---
title: Node Troubleshooting
category: node
authors: dougsland, fabiand, mburns
---

# Node Troubleshooting

Since oVirt Node is a non-standard Operating System, the way to debug things is also somewhat different. This page is a just a quick snapshot of things that I know of for debugging what's going on on a running oVirt Node System.

## Boot up problems

### I booted the image and got a login prompt, what is the default password?

*   A: There isn't a default password. You're actually hitting a bug in that the system is not booting correctly. Immediate workaround steps will depend on the actual issue that you're facing.
*   First thing: reboot and set the root user's password from the kernel command line
*   On a separate system, generate a hashed password run:

`
$ openssl passwd -salt 42 ovirt
42OLJtXwdXtEY
`

*   Boot the image
*   Hit <TAB> on the boot menu on the "Install or Updgrade oVirt Node" option
*   Add "rootpw=<hashed_passwd>" (no quotes, and no <>) to the command line, e.g. `rootpw=42OLJtXwdXtEY`
*   Hit enter
*   When the login screen comes up, enter `root`, then the password that you gave to openssl (`ovirt` in the above example)
*   Check the various log files listed in the Log Files section of this FAQ
*   Look for python errors
*   If none present, try running "su - admin"
*   This should dump an error out to the screen

## General

**Disclaimer:** Changes made from the command line are done at your own risk. Making changes has the potential to leave your system in an unusable state.

### Log Files

*   Visible by Pressing F8 on any TUI screen
*   **Node** specific
    -   /var/log/ovirt.log
    -   /var/log/ovirt-node.log
    -   /var/log/ovirt-node.debug.log (when running the installer or setup in debug mode)
    -   /tmp/ovirt.log (in rare cases)
*   **Engine** related
    -   /var/log/vdsm\*
*   **Gluster** related
    -   /var/log/vdsm\*
    -   /var/log/glusterfs\*

### Shell access

*   **Warning** -- Changes you make from the shell are not persistent by default and will be lost if you reboot the host
*   Press F2 from any TUI screen

### Debug Mode

*   **Auto-Installation**: To enable the debug mode during install pass `node.log_level=debug` as a kernel argument, take a look at the [Log Files](Log Files) for the relevant logfiles.
*   **TUI Installation and Setup**: The TUI also has a debug mode - this will log much more stuff and print the stracktraces on the screen. This mode can be entered by following the steps:
    -   Drop to shell (using F2)
    -   re-run the setup using `ovirt-node-setup --debug` or installer using `ovirt-node-installer --debug`
    -   Finally take a look at the [Log Files](Log Files) for the relevant logfiles

### Setting manually oVirt Node root password

*   On TUI press **F2** to go to shell and execute **/usr/libexec/ovirt-config-password**

### Certificate and/or SSL problems?

As debugging approach, to validate your current vdsmcert with cacert, execute:

    # openssl verify -CAfile /etc/pki/vdsm/certs/cacert.pem /etc/pki/vdsm/certs/vdsmcert.pem
     vdsmcert.pem: OK  (returning OK)

1.  openssl x509 -in /etc/pki/vdsm/certs/cacert.pem -noout -text

      # openssl x509 -in /etc/pki/vdsm/certs/vdsmcert.pem -noout -text 
      # openssl x509 -in /etc/pki/vdsm/certs/vdsmcert.pem -noout -text | grep -i issuer (show only issuer)
      # openssl x509 -in /etc/pki/vdsm/certs/cacert.pem -noout -text | grep -i subject (show only subject)

</pre>
### Using yum

Yum is only supported in offline image editing. On a running system, it's disabled. A how-to for editing an ISO image after creation will be coming soon.

### Upgrading oVirt Node

oVirt Node can be updated in two ways:

*   Run a media containing the oVirt Node ISO image
    -   An interactive upgrade dialog appears and guides you through the upgrade process
*   Through oVirt Engine

### SELinux

SELinux is being used by default on oVirt Node. SELinux works by describing how a system should work - if something is not working like expected (e.g. a daemon writes to a file which SELinux doesn't know about), then this write get's blocked. This can lead to all sorts of problems.

If things on Node don't work, just try running Node in "permissive" mode. In "permissive" mode, SELinux logs unexpected behaviour, but doesn't block it. To enable permissive mode, add the following line to the bootloaders kernel line:

    enforce=0

## Making changes on the host

*   **Warning** -- Changes you make from the shell are not persistent by default and will be lost if you reboot the host
*   Help, I dropped to the shell but I can't change anything!?
    -   By default, the root file system of oVirt Node is read only. To make changes temporarily on the system, you can remount it read/write
    -   `mount -o rw,remount /`

### Bind mounts and tmpfs

*   Node heavily relies on bindfs - to persist some files - and tmpfs.
    -   `mount` won't show all the bind mounts on all distributions, looking at `/proc/mounts` might help here. But both methods don't allow to get the complete source of a bindmount if the sources is e.g. a file.
    -   `findmnt` can be used to get an overview over mount targets *and* their sources

### RPM changes

*   **Warning** -- Changes you make from the shell are not persistent by default and will be lost if you reboot the host
*   Can I update an rpm on a running system? I need RPM xxx installed on oVirt Node. Can do I add it?
    -   The answer to these is, in general, "No, you can't update or add an RPM to a running oVirt Node."

For debugging purposes, you can update an rpm, but it's strongly discouraged for long term use.

*   Drop to a shell on the system

<!-- -->

    $ remount / re-write
    $ cd /tmp
    $ wget rpm-files (need to get all dependencies as well)
    $ rpm … (install/update rpms using the rpm command)

*   **Note**: yum is currently not installed on oVirt Node

### Making changes last / Persisting changes

*   You keep warning me that changes made from the shell are not persistent. How can I make them persistent?
    -   Disclaimer: This will not work for all changes and can cause your system to be un-usable.
    -   The `persist` and `unpersist` commands will allow you to make a file and/or directory persistent across reboots.
    -   You will need to make the changes, then persist each file/directory individually
*   Where doesn't this work correctly?
    -   Kernel modules and kernel updates will **NOT** work at all
    -   modprobe.conf changes will not work
    -   Other files used very early in the boot process may not work
    -   Python file changes may not work correctly
        -   The base .py files are removed from the image
        -   It may work if you upload the original .py file, make changes, re-compile, then persist the .pyc and .pyo files.
*   Be aware the the partition for storing changes like this is very small (<10MB). Because of this, it's not recommended that you persist large files or entire rpms.

### I broke something, Help!

*   Q: I accidentally removed or changed a key file while doing stuff from the command line. How do I fix this?
*   A: Well, you were warned that making changes was dangerous. You're best bet is to re-install.
*   Q: Really? No way to undo some of the changes?
*   A: You can try a couple things, but no guarantees...
    -   If the change wasn't persisted, you can try re-booting and you might get things back the way they were before.
    -   If it was to a file that was already persisted before, that probably won't work. You can try unpersisting the file, and rebooting, but that won't work if changes were made in that file that oVirt Node needed.
    -   If you persisted a file and it broke something, but you can get back to the shell, you can try unpersisting the file and rebooting. It may not work if the system had made other changes to the file that are lost when you unpersist.
    -   If those don't work, you can try manually hacking the changed files again to fix it, but you're on you're own with that.
    -   If the above all fail, then re-install is really you're only option.

### Too many logins

As debug purpose only, to increase the number of tty users logging into oVirt Node (currently it's 3), edit:

      # vi /etc/security/limits.conf
       *    -    maxlogins 3  
      # persist /etc/security/limits.conf

### Cannot disable selinux setting /etc/selinux/config plus persist command

       It's required to add kernel parameter during the boot, for example in pxe you could add enforcing=0

[Category: Node](Category: Node)
