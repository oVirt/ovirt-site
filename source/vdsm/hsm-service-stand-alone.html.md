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

The VDSM service exposes a set of node level APIs to the virtualization manager for managing KVM virtual machine life cycle and storage images for these virtual machines. Among these APIs, storage image APIs are implemented on NFS file systems, block devices, gluster file system, &etc. Decoupling the storage image service from VDSM service will make the VDSM service more modular. Also an opportunity is provided for other virtualization stacks to leverage this modular storage service(HSM service). Other virtulization stacks may include OpenStack's glance, cinder projects.

To make the HSM service stand alone, VDSM service will be re-factored like these. The VDSM service will keep the same APIs as before to oVirt engine and other node level API consumers. HSM service starts as an stand-alone XML-RPC service provider to the VDSM service. Also it is negotiable to support other bindings like REST API, however XML-RPC binding is the initial proposal here. HSM service will start as a stand alone service and export the XML-RPC APIs by a well known port.

      I) VDSM service open the connection to HSM service.  If the open fails, it will fall back to the legacy way without HSM standalone service.
        Like:
      class APIBase(object)
           def __init__(self):
               cli = hsm.ServiceProxy(hsm_proxy_server)
       
               if cli:  <---HSM standalone service exists
                  self._irs = cli
               else:  <---fall back to the legacy way
                  self._cif = clientIF.getInstance()
                  self._irs = self._cif.irs
                  
           

II) superVDSM service will be cloned to serve both VDSM service and HSM service

III) Two-mode task manager in VDSM service and HSM service will be introduced. So the task manager embedded in HSM service can operate in two modes, transparent mode and non-transparent mode. In transparent mode, all of the tasks under it should be transparent to the task manager and the tasks will be managed by the up-layer manager in fact. In non-transparent mode, the task manager will manage the tasks under it as before. The existing task manager in VDSM service will configure the task manager embedded in HSM service to transparent mode and manage the tasks in HSM service.

IV) log service will be cloned to serve both VDSM and HSM service.

V)The configuration parameters in vdsm.conf should be pull out to another hsm.conf file. And all vdsm process should not read hsm.conf directly. If it is necessary to get the hsm configurations, an API will be added into hsm process for vdsm querying

         like [irs] section in vdsm.conf.

VI) All of the HSM files should be self contained and will be packaged into another RPM package different from VDSM package.

VII) All of the python modules shared by both VDSM service and HSM service should go into python site-packages directory which is like /usr/lib/python2.7/site-packages/vdsm Now, task.py doesn't sit in this directory, we should fix it in this proposal.

<Category:Vdsm>
