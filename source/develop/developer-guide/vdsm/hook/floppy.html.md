---
title: floppy
authors: dyasny
wiki_title: VDSM-Hooks/floppy
wiki_revision_count: 2
wiki_last_updated: 2012-09-14
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

Download link: <http://ovirt.org/releases/nightly/rpm/EL/6/hooks/vdsm-hook-floppy-4.10.0-0.442.git6822c4b.el6.noarch.rpm>
