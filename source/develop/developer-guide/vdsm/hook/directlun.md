---
title: directlun
authors: dyasny
---

# directlun

Add a LUN that a host's device-mapper can access to a VM:

Syntax:

      directlun: directlun=3600144f0e90c870000004d4194ed001f
                 directlun=3600144f0e90c870000004d4194ed001f:readonly
                 directlun=lun1[:option1[;option2]][,lun2[:option1[;option2]]]...

will add disk device of specified lun id (lun id in client side, i.e. the one that multipath creates as in this example 3xxxxxxx, 3 is Solaris prefix).

Option section: directlun=lunid:readonly,lunid... - currenly, only the "readonly" option is available.

NOTE: Will be made obsolete by the direct LUN feature in 3.1

