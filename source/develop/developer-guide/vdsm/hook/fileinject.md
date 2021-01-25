---
title: fileinject
authors: dyasny
---

# fileinject

The fileinject hook is receives a target file name and its content and creates that file in target machine.

The hook will try to add the file only to the operating system partition, i.e.

*   Windows: /c/myfile
*   Linux: /myfile

Please note that in Windows the path is case sensitive!

syntax:

`   fileinject=/`<target file name>` : `<file content>
         fileinject=/myfile:some file content\n etc...

Important note for Block Devices: If the disk that you are trying to inject is a block device (ie iSCSI or Fibre Channel) the disk format must be "Preallocated" (not "thin provisioned") or the fileinject hook will fail and abort the running VM process.

Note for SELinux: if you are running SELinux, you need to run this command on the server (temporary until bug #730662 is solved):

      # setsebool -P allow_unconfined_qemu_transition 0

Create a file in guest disk and update it with some specified content (note that it must have "root" path ie '/' in linux and c:\\ in windows ) for example:

*   Linux (case sensitive):

             fileinject:/etc/myfile.txt:content

*   Windows (case insensitive):

             fileinject:/c/windows/myfile.txt:content

This means that with Windows the path must start with '/c/' prefix (if the windows os in in c:\\ /d/ for d:\\) and must start with '/' for linux based machines

