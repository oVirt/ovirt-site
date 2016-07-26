---
title: oVirt Engine 4.0 Installation Issues on Fedora 24
author: yquinn
tags: community, news, blog
date: 2016-07-26 16:30:00 CET
comments: true
published: true
---

This blog post relates to oVirt Engine release 4.0 installation on Fedora 24 and probably is relevant for earlier oVirt releases.
Having Fedora 24 (Twenty Four) installed on my new laptop (while it was still in beta phase, but this is still relevant for GA),
I ran an oVirt installation and encountered the following error message :

```
ovirt-engine[5566] ERROR run:532 Error: Unable to change process owner ([Errno 1] Operation not permitted)
```

This is an outcome of permission problems with python-daemon 2.1.0, which is the default package in the Fedora 24 release.

To overcome this issue, I had to downgrade the python-daemon version to 2.0.6 (e.g., `sudo pip install python-daemon==2.0.6`,
a reference to similar general issue can be found here: https://groups.google.com/forum/#!topic/pywws/I0c_RW4DRzg)

Any further issues related to oVirt installation and Fedora 24 will be added to this blog post.
