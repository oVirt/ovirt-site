---
title: HSM service stand alone
category: vdsm
authors: sming
wiki_category: Vdsm
wiki_title: HSM service stand alone
wiki_revision_count: 11
wiki_last_updated: 2012-11-20
---

# HSM service stand alone

VDSM storage service stand alone(HSM service standalone)

The VDSM service exposes a set of node level APIs to the virtualization manager for managing KVM virtual machine life cycle and storage images for these virtual machines. Among these APIs, storage image APIs are implemented on NFS file systems, block devices, gluster file system, &etc. Decoupling the storage image service from VDSM service will make the VDSM service more modular. Also an opportunity is provided for other virtualization stacks to leverage this modular storage service(HSM service).

To make the HSM service stand alone, VDSM service will be re-factored like these. The VDSM service will keep the same APIs as before. HSM service starts as an stand-alone XML-RPC service provider to the VDSM service. Also it is negotiable to support other bindings like REST API, however XML-RPC binding is the initial proposal here. HSM service will start as a stand alone service and export the XML-RPC APIs by a well known port.

      I) VDSM service open the connection to HSM service.  If the open fails, it will fall back to the legacy way without HSM standalone service.
        Like:
      class APIBase(object)
           def __init__(self):
               cli = hsm.ServiceProxy(hsm_proxy_server)
       
               if cli:
                  self._irs = cli
               else:
                  self._cif = clientIF.getInstance()
                  self._irs = self._cif.irs
                  
           

II) superVDSM service will be cloned to serve both VDSM service and HSM service

III) Two modes task managers in VDSM service and HSM service will be introduced. So the task manager embedded in HSM service can operate in two modes, transparent mode and non-transparent mode. In transparent mode, all of the tasks under it should be transparent to the task manager and the tasks will be managed by the up-layer manager in fact. In non-transparent mode, the task manager will manage the tasks under it as before. The existing task manager in VDSM service will configure the task manager embedded in HSM service to transparent mode and manage the tasks in HSM service.

VI)log service will be cloned to serve both VDSM and HSM service.

VII)The configuration parameters in vdsm.conf should be pull out to another hsm.conf file.

         like [irs] section in vdsm.conf.

<Category:Vdsm>
