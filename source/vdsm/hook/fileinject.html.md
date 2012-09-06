---
title: fileinject
authors: dyasny
wiki_title: VDSM-Hooks/fileinject
wiki_revision_count: 3
wiki_last_updated: 2012-09-14
---

# fileinject

The fileinject hook is receives a target file name and its content and creates that file in target machine.

The hook will try to add the file only to the operating system partition, i.e.

*   Windows: /c/myfile
*   Linux: /myfile

Please note that in Windows the path is case sensitive!

syntax:

`   fileinject=/`<target file name>` : `<file content>
         fileinject=/myfile:some file content\n etc...
