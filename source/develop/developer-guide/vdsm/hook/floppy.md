---
title: floppy
authors: dyasny
---

# floppy

The floppy vdsm hook will add a floppy image to the libvirt domain entry:

syntax:

      floppy=/path/to/vfd

XML changes will look like this:

```
<disk type='file' device='floppy'>
    <target dev='fda' />
</disk>
```

Note: some linux distros need to load the floppy disk kernel module:

         # modprobe floppy

Syntax:

      floppy: floppy=/path/to/vfd

