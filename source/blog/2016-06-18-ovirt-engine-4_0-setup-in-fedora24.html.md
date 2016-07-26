---
title: OVirt engine 4.0 installation issues on fedora 24
author: yquinn
tags: community, news, blog
date: 2016-06-18 15:00:00 CET
---

This Blog post relates to OVirt engine release 4.0 installation on fedora 24 and probably is relevant for lower ovirt release versions.
Having Fedora release 24 (Twenty Four) installed on my new laptop (while it is still in beta phase - but this is still relevant for GA)
I have ran an ovirt installation and encountered the following error message :

ovirt-engine[5566] ERROR run:532 Error: Unable to change process owner ([Errno 1] Operation not permitted)

This is an outcome of permission problems with python-daemon 2.1.0 which is the default package 
in fedora 24 release that i have used.

To overcome this issue i had to downgrade the python-daemon version to 2.0.6
e.g. sudo pip install python-daemon==2.0.6
(a reference to similar general issue can be found here : https://groups.google.com/forum/#!topic/pywws/I0c_RW4DRzg)


Any further issues related to ovirt installation and fedora 24 
will be added to this blog post.
