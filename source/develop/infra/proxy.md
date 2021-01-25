---
title: Proxy
category: infra
authors: dcaroest
---

# Proxy

**NOTE**: for the latest version of this doc, see <http://ovirt-infra-docs.readthedocs.org/en/latest/>

In the [Phoenix lab](/develop/infra/phoenix-lab-overview.html) setup we have now a proxy VM that is also serving as repository proxy for all the slaves, mainly for mock usage but can be used as a generic proxy.

The proxy has two services to be able to provide a reliable and fast cache, the [Squid](#squid) proxy and the repoproxy.py. The second is only used for the yum repositories, to be able to get the failover and speed increases from the mirrorlists but being able to properly cache the results.

## Squid

The squid proxy is configured to reply only to ips from the Phoenix lab, it has a huge disk cache to allow caching as many files as possible.

To invalidate a cache object, you must login to the squid server and run:

` [root@proxy ~]# squidclient -m PURGE `<URL_TO_PURGE>

Where <URL_TO_PURGE> is the url you want to invalidate, you should get a 200 response if everything went well:

    HTTP/1.1 200 OK
    Server: squid
    Mime-Version: 1.0
    Date: Tue, 03 Feb 2015 11:59:27 GMT
    Content-Length: 0
    X-Cache: MISS from proxy.phx.ovirt.org
    X-Cache-Lookup: NONE from proxy.phx.ovirt.org:3128
    Via: 1.1 proxy.phx.ovirt.org (squid)
    Connection: close

## Repoproxy

The repoproxy is a small python script that proxies yum repo requests to mirrors, it's configured using the repos.yaml file (in the puppet module), where you define each repo it's serving, and the mirrorlist to use. For example:

    [myrepo]
    mirrorurl=http://wherever.com/mirrorlist?repo=myrepo&ver={releasever}&arch={arch}

That will allow you to transparently get a response from the first working mirror through the proxy using the url:

`http://myproxy:5000/myrepo/21/x86_64`

Where the next two path sections after the repository name are the releasever and arch parameters you see in the mirrorlist url. That will get the mirrorlist from the url:

`http://wherever.com/mirrorlist?repo=myrepo$ver=21&arc=x86_64`

Then try each of the mirrors until finds one that responde to the requested path (in this case, just '/') and return it. It caches the responding mirrors so the tests will only be done once per path tops.

The logs are located at /var/log/repoproxy.log, and the files under /opt/repoproxy
