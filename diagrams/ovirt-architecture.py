#!/usr/bin/env python3

"""
oVirt architecure, using https://diagrams.mingrammer.com/
"""

from diagrams import Cluster, Diagram, Edge
from diagrams.custom import Custom
from diagrams.generic.os import Centos, LinuxGeneral, Windows
from diagrams.onprem.compute import Server
from diagrams.onprem.database import PostgreSQL
from diagrams.onprem.network import Wildfly
from diagrams.programming.language import Java, Nodejs, Python
from diagrams.onprem.logging import Rsyslog

LIBVIRT = "../source/images/logos/libvirt.png"

with Diagram("oVirt Architecture", direction="LR"):

    with Cluster("Datacenter", direction="LR"):
        with Cluster("Cluster"):
            with Cluster("Node 1") as node1:
                os1 = LinuxGeneral("Linux")
                with Cluster("libvirt"):
                    libvirt1 = Custom("libvirt", LIBVIRT)
                    vdsm1 = Python("VDSM")
                    mom1 = Python("MoM")
                    with Cluster("Windows11 VM"):
                        vm1_1 = Windows("Windows 11/QEMU GA")
                    with Cluster("CentOS Stream 8 VM"):
                        vm2_1 = Centos("CentOS Stream 8/QEMU GA")
                with Cluster("Metrics"):
                    rs1 = Rsyslog()
                vdsm1 >> Edge(color="red") << vm1_1
                vdsm1 >> Edge(color="red") << vm2_1
                libvirt1 >> Edge(color="red") << vdsm1
                vm1_1 - libvirt1
                vm2_1 - libvirt1
                mom1 - vdsm1

            with Cluster("Node 2") as node2:
                os2 = LinuxGeneral("Linux")
                with Cluster("libvirt"):
                    libvirt2 = Custom("libvirt", LIBVIRT)
                    vdsm2 = Python("VDSM")
                    mom2 = Python("MoM")
                    with Cluster("Windows11 VM"):
                        vm1_2 = Windows("Windows 11/QEMU GA")
                    with Cluster("CentOS Stream 8 VM"):
                        vm2_2 = Centos("CentOS Stream 8/QEMU GA")
                with Cluster("Metrics"):
                    rs2 = Rsyslog()
                vdsm2 >> Edge(color="red") << vm1_2
                vdsm2 >> Edge(color="red") << vm2_2
                libvirt2 >> Edge(color="red") << vdsm2
                vm1_2 - libvirt2
                vm2_2 - libvirt2
                mom2 - vdsm2

    with Cluster("oVirt Engine Host") as engine:
        osEngine = LinuxGeneral("Linux")
        with Cluster("Wildfly"):
            wildfly = Wildfly("Wildfly")
            with Cluster("oVirt DWH"):
                ovirtDWH = Java("oVirt DWH")
                dwhpgsql = PostgreSQL("oVirt DWH DB")
            with Cluster("oVirt Engine"):
                oVirtEngineWebadminPortal = Java(
                    "oVirt Engine\nWeb Admin Portal"
                )
                ovirtEngineBackend = Java("oVirt Engine\nBackend")
                pgsql = PostgreSQL("oVirt Engine DB")
        oVirtWebUI = Nodejs("oVirt Web UI")
        oVirtEngineUIExtension = Nodejs("oVirt Engine\nUI Extension")
        with Cluster("Metrics"):
            rs = Rsyslog()

    #with Cluster("AAA"):
    #    ipa = Server("LDAP / IPA")
    #    ad = Server("Active Directory")

    ovirtDWH >> Edge(color="darkgreen") << dwhpgsql
    ovirtEngineBackend >> Edge(color="darkgreen") << pgsql
    vdsm2 >> Edge(color="red") << ovirtEngineBackend
    vdsm1 >> Edge(color="red") << ovirtEngineBackend

    ovirtEngineBackend - ovirtDWH

    ovirtEngineBackend >> Edge(color="brown") << oVirtEngineWebadminPortal
    ovirtEngineBackend >> Edge(color="brown") << oVirtWebUI
    ovirtEngineBackend >> Edge(color="brown") << oVirtEngineUIExtension

    #ovirtEngineBackend >> Edge(color="darkgreen") << [ipa, ad]
    [rs1, rs2] >> rs
