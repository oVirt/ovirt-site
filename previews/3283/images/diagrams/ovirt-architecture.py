#!/usr/bin/env python3

"""
oVirt architecure, using https://diagrams.mingrammer.com/
"""


from diagrams import Cluster, Diagram, Edge
from diagrams.custom import Custom
from diagrams.elastic.elasticsearch import Elasticsearch, Kibana
from diagrams.generic.compute import Rack
from diagrams.generic.network import Switch
from diagrams.generic.os import Centos, Windows
from diagrams.ibm.user import Browser
from diagrams.onprem.database import PostgreSQL
from diagrams.onprem.logging import Rsyslog
from diagrams.onprem.monitoring import Grafana
from diagrams.onprem.network import Apache, Wildfly
from diagrams.onprem.storage import Glusterfs, Ceph
from diagrams.programming.language import Java, Nodejs, Python

LOGO = "../logos/{product}.png"

with Diagram(
    "oVirt Architecture",
    direction="TB",
    graph_attr={"nodesep": "1", "ranksep": "1", "splines": "compound"}
):

    with Cluster("Storage Domains"):
        gluster = Glusterfs("Gluster storage")
        iscsi = Rack("ISCSI Storage")
        fc = Rack("Fiber Channel\nStorage")
        nfs = Rack("NFS\nStorage")
        storage_net = Switch("Storage Network")
        [gluster, iscsi, fc, nfs] >> Edge(color="red") << storage_net
        ceph = Ceph("Ceph Storage")
        ceph >> Edge(color="blue") << storage_net

    with Cluster("OpenShift"):
        kibana = Kibana("Kibana")
        elastic = Elasticsearch("ElasticSearch")
        kibana << elastic
    kibana_browser = Browser("Admin connected\nto Kibana")
    kibana >> Edge(color="red") << kibana_browser

    with Cluster("Node 1") as node1:
        cockpit1 = Custom("Cockpit", LOGO.format(product="cockpit"))
        storage_nic = Custom("Storage NIC", "")

        with Cluster("Services"):
            imageio_cli = Python("oVirt ImageIO Client")
            vmconsole = Python("oVirt VMConsole")
        with Cluster("Virtualization"):
            with Cluster("Windows11 VM"):
                vm1_1 = Windows("Windows 11\nQEMU GA")
            with Cluster("CentOS Stream 9 VM"):
                vm2_1 = Centos("CentOS Stream 9\nQEMU GA")
            vdsm1 = Python("VDSM")
            mom1 = Python("MoM")
            libvirt1 = Custom("libvirt", LOGO.format(product="libvirt"))
            mom1 - Edge(color="green") - vdsm1
            libvirt1 - Edge(color="green") - vdsm1
            vdsm1 >> Edge(color="red") << [vm1_1, vm2_1]

        [vm1_1, vm2_1] >> Edge(color="red") << vmconsole
        cinderlib = Python("Cinderlib")
        cinderlib - Edge(color="green") - vdsm1
        cinderlib >> Edge(color="blue") << storage_nic
        with Cluster("Metrics"):
            rsyslog1 = Rsyslog("RSyslog")
            collectd1 = Custom("CollectD", LOGO.format(product="collectd"))
            rsyslog1 << collectd1

    cockpit_browser = Browser("Admin connected\nto Host's Cockpit")
    cockpit1 >> Edge(color="red") << cockpit_browser

    with Cluster("oVirt Engine Host") as engineHost:
        enginedb = PostgreSQL("Engine DB")
        dwhdb = PostgreSQL("DWH DB")
        with Cluster("oVirt Backend"):
            engine = Wildfly("oVirt Engine\nBackend")
            vdsm_jsonrpc_java = Java("VDSM JSON-RPC Java")
            vdsm_jsonrpc_java >> Edge(color="red") << engine
        engine >> Edge(color="green") << enginedb
        with Cluster("Services"):
            wsproxy = Python("oVirt\nWebSocket Proxy")
            imageioDaemon = Python("oVirt\nImageIO Daemon")
            vmconsole_proxy = Python("oVirt\nVMConsole\nProxy")
        with Cluster("oVirt Web Admin"):
            ovirtCockpitSso = Nodejs("oVirt\nCockpit SSO")
            webadmin = Wildfly("oVirt Engine\nWeb Admin")
            ovirtCockpitSso - webadmin
            oVirtEngineUIExtension = Nodejs("oVirt Engine\nUI Extension")
        webui = Nodejs("oVirt Web UI")
        keycloack = Custom(
            "oVirt Keycloack SSO",
            LOGO.format(product="keycloak")
        )
        webadmin - keycloack
        oVirtEngineUIExtension >> Edge(color="brown") << engine
        apache = Apache()
        webadmin - apache
        dwh = Wildfly("oVirt DWH")
        dwhdb >> Edge(color="green") << dwh
        enginedb >> Edge(color="green") << dwh
        grafana = Grafana("Grafana")
        with Cluster("Metrics"):
            rsyslog = Rsyslog("RSyslog")
            collectd = Custom("CollectD", LOGO.format(product="collectd"))
            rsyslog << collectd
        keycloack - grafana
        keycloack - webui
        dwhdb >> Edge(color="brown") << grafana
        engine >> Edge(color="brown") << webadmin
        engine >> Edge(color="brown") << webui
        imageioDaemon >> Edge(color="red") << engine
        vmconsole_proxy - engine

    vdsm1 >> Edge(color="red") << vdsm_jsonrpc_java
    elastic << rsyslog
    elastic << rsyslog1
    cockpit1 >> Edge(color="red") << ovirtCockpitSso

    engine_browser = Browser("Admin connected\nto oVirt Engine")
    grafana_browser = Browser("Admin connected\nto Grafana")
    webui_browser = Browser("user connected\nto oVirt Web UI")
    vm1_console_browser = Browser("user connected to\nVM1 via NoVNC")
    apache >> Edge(color="red") << engine_browser
    grafana >> Edge(color="red") << grafana_browser
    webui >> Edge(color="red") << webui_browser
    vm1_1 >> Edge(color="red") << wsproxy
    vm1_console_browser >> Edge(color="red") << wsproxy
    imageio_cli >> Edge(color="red") << imageioDaemon
    storage_nic >> Edge(color="red") << [imageio_cli, vdsm1]
    storage_net >> Edge(color="red") << storage_nic
    storage_net >> Edge(color="blue") << storage_nic
    vmconsole >> Edge(color="red") << vmconsole_proxy
    terminal = Custom("SSH terminal", "")
    terminal >> Edge(color="red") << vmconsole_proxy
