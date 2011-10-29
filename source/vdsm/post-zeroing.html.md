---
title: Vdsm Post Zeroing
category: vdsm
authors: danken
wiki_category: Vdsm
wiki_title: Vdsm Post Zeroing
wiki_revision_count: 1
wiki_last_updated: 2011-10-29
---

# Vdsm Post Zeroing

"Post Zeroing" is the process of writing zeroes on the image files in an attempt to overwrite sensitive file content.

In file domains, post zeroing is usually done to preallocate the file and try to occupy as much contiguous space as possible this, of course, has a lot to do with you OS\\File System\\Storage stack. Block domains will not have any benefit from preallocating so this feature is usually not used on block domains.

Block domains, on the other hand can benefit from post-zeroing on delete. This is done so when this extent is realocated to another volume, you wouldn't get residual data from the previous volume thus causing a possible data leak between VMs. Post-zeroing upon delete in file domains is pretty useless because the file system usually keeps track of unallocated space in the file.

<Category:Vdsm>
