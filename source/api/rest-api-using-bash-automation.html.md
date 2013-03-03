---
title: REST API Using BASH Automation
category: api
authors: lspevak
wiki_title: REST API Using BASH Automation
wiki_revision_count: 6
wiki_last_updated: 2013-04-30
---

# REST API Using BASH Automation

## Introduction

To prepare and regularly refresh a development and/or testing environment for oVirt Engine can be a time-consuming procedure. The REST API can help significantly with the task. This article concentrates on calling oVirt REST API using a BASH scripting from the Linux command line.

It uses:

*   BASH interpreter
*   curl (HTML command line client)
*   xmllint (XPath command line parser)

The goal is to support typical commands:

*   create host server
*   create/import/attach/activate storage domain
*   create virtual machine (VM) and its network, attach image disk and iso disk (CD-ROM)

Basic operations:

*   The commands should always check the current state, fetch needed parameters and run the actions only if required, e.g. a host is created from the command, if it doesn't exist only.
*   The runtime environment is always synchronized with the script state. If the action is asynchronous, it should wait for a given time-out period and periodically check status \* of the operation by calling the REST API, parsing returned values using XPath processor and checking expected target status value.
*   For HTTPS connection a trusted authority (CA) server certificate is required, else '--insecure' option is to be specified for the curl command.
*   The responses are saved and processed from the specified communication file.

The script has two parts:

*   general support routines (HTTP method call using curl client, XPath parser)
*   environment synchronization script

## General support routines

*   File: rest_api_routines.sh

<!-- -->

    #! /bin/bash
    #
    # Copyright (c) 2013 Red Hat, Inc.
    #
    # Licensed under the Apache License, Version 2.0 (the "License");
    # you may not use this file except in compliance with the License.
    # You may obtain a copy of the License at
    #
    #           http://www.apache.org/licenses/LICENSE-2.0
    #
    # Unless required by applicable law or agreed to in writing, software
    # distributed under the License is distributed on an "AS IS" BASIS,
    # WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    # See the License for the specific language governing permissions and
    # limitations under the License.
    #
    # oVirt environment synchronization script
    #
    # required utilities: xmllint, curl

    HEADER_CONTENT_TYPE="Content-Type: application/xml"
    HEADER_ACCEPT="Accept: application/xml"
    # communication file for request/response
    COMM_FILE="/tmp/restapi_comm.xml"

    # get number of rows returned by XPath expression
    function getXPathCount {
        local xPath="count($1)"
        echo $(xmllint --xpath $xPath $COMM_FILE)
    }

    # get string value of node returned by XPath expression
    function getXPathValue {
        local xPath="string($1)"
        echo $(xmllint --xpath $xPath $COMM_FILE)
    }

    function callGETService {
        local uri=$1
        local certAtt=""

        if [[ -n "$CA_CERT_PATH" ]]; then
            certAtt="--cacert $CA_CERT_PATH"
        fi

        echo "Calling URI (GET): " ${uri}
        curl -X GET -H "${HEADER_ACCEPT}" -H "${HEADER_CONTENT_TYPE}" -u "${USER_NAME}:${USER_PASSW}" "$certAtt" "${ENGINE_URL}${uri}" --output "${COMM_FILE}" 2> /dev/null > "${COMM_FILE}"
    }

    function callPOSTService {
        local uri=$1
        local xml=$2
        local certAtt=""

        if [[ -n "$CA_CERT_PATH" ]]; then
            certAtt="--cacert $CA_CERT_PATH"
        fi

        echo "Calling URI (POST): " ${uri}
        curl -X POST -H "${HEADER_ACCEPT}" -H "${HEADER_CONTENT_TYPE}" -u "${USER_NAME}:${USER_PASSW}" "$certAtt" "${ENGINE_URL}${uri}" -d "${xml}" 2> /dev/null > "${COMM_FILE}"
    }

    # wait till XPath returns non-zero number of rows from specified REST API GET service
    function waitForStatus {
        local uri=$1
        local xPathStatusTest=$2
        local xPathStatusValue=$3
        local timeoutIntervalSec=$4

        local status="0"
        for i in $(seq 1 10); do
            callGETService "${uri}"
            local c=`getXPathCount "${xPathStatusTest}"`
            local val=`getXPathValue "${xPathStatusValue}"`

            if [[ "$c" > "0" ]]; then
                echo "Target status ${val} reached. Done."
                status="1"
                break;
            else
                echo "Waiting for ${timeoutIntervalSec} s...(${i}, value=${val})"
                sleep ${timeoutIntervalSec}
            fi
        done;

        if [[ "$status" == "0" ]]; then
            echo "Timeout, waiting interrupted."
        fi
    }

    # get all hosts
    function getHosts {
        callGETService "/api/hosts"
        local c=`getXPathCount "/hosts/host[@id]"`
        echo "Current host count: " ${c}
    }

    # create host if it doesn't exist
    function createHost {
        local hostName=$1
        local hostAddress=$2
        local hostPassword=$3
        local clusterName=$4

        getHosts
        local hostCount=`getXPathCount "/hosts/host[name='${hostName}']"`
        getClusters
        local idCluster=`getXPathValue "/clusters/cluster[name='${clusterName}']/@id"`

        if [[ "${hostCount}" == "0" ]]; then
            echo "Host doesn't exist, creating: ${hostName}..."
            local xml="<host><name>${hostName}</name><address>${hostAddress}</address><root_password>${hostPassword}</root_password><cluster id='${idCluster}' href='/api/clusters/${idCluster}'/></host>"
            callPOSTService "/api/hosts" "${xml}"
            # show response
            cat $COMM_FILE
            # wait for host creation
            waitForStatus "/api/hosts" "/hosts/host[name='${hostName}']/status[state='up']" "/hosts/host[name='${hostName}']/status/state" 10
            echo "Host created."
        else
            echo "Host exists: ${hostName}"
        fi
    }

    # get all clusters
    function getClusters {
        callGETService "/api/clusters"
        local c=`getXPathCount "/clusters/cluster[@id]"`
        echo "Current cluster count: " ${c}
    }

    # get all storage domains
    function getStorages {
        callGETService "/api/storagedomains"
        local c=`getXPathCount "/storage_domains/storage_domain[@id]"`
        echo "Current storage domain count: " ${c}
    }

    # create storage domain if it doesn't exist
    function createStorage {
        local type=$1
        local fsType=$2
        local name=$3
        local address=$4
        local path=$5
        local hostName=$6

        getStorages
        # test if storage exists, if so, do not continue
        local c=`getXPathCount "/storage_domains/storage_domain[name='${name}']"`

        if [[ "$c" == "0" ]]; then
            echo "Storage domain doesn't exist, creating: ${name}..."
            local xml="<storage_domain><name>$name</name><type>$type</type><storage><type>$fsType</type><address>$address</address><path>$path</path></storage><host><name>$hostName</name></host></storage_domain>"
            callPOSTService "/api/storagedomains" "${xml}"
            cat ${COMM_FILE}
            echo "Storage domain create request has been sent."
        else
            echo "Storage domain exists: ${name}"
        fi
    }

    # import storage domain if it doesn't exist (name is not specified)
    function importStorage {
        local type=$1
        local fsType=$2
        local address=$3
        local path=$4
        local hostName=$5

        getStorages
        # test if storage exists, if so, do not continue
        local c=`getXPathCount "/storage_domains/storage_domain[type='${type}']"`

        if [[ "$c" == "0" ]]; then
            echo "Storage domain doesn't exist, importing type: ${type}..."
            local xml="<storage_domain><type>$type</type><storage><type>$fsType</type><address>$address</address><path>$path</path></storage><host><name>$hostName</name></host></storage_domain>"
            callPOSTService "/api/storagedomains" "${xml}"
            cat ${COMM_FILE}
            echo "Storage domain import request has been sent."
        else
            echo "Storage domain exists: ${name}"
        fi
    }

    function createNfsDataStorage {
        local name=$1
        local address=$2
        local path=$3
        local hostName=$4

        createStorage "data" "nfs" $name $address $path $hostName
    }

    function createNfsIsoStorage {
        local name=$1
        local address=$2
        local path=$3
        local hostName=$4

        createStorage "iso" "nfs" $name $address $path $hostName
    }

    function createNfsExportStorage {
        local name=$1
        local address=$2
        local path=$3
        local hostName=$4

        createStorage "export" "nfs" $name $address $path $hostName
    }

    function importNfsIsoStorage {
        local address=$1
        local path=$2
        local hostName=$3

        importStorage "iso" "nfs" $address $path $hostName
    }

    function importNfsExportStorage {
        local address=$1
        local path=$2
        local hostName=$3

        importStorage "export" "nfs" $address $path $hostName
    }

    # get DC
    function getDataCenters {
        callGETService "/api/datacenters"
        local c=`getXPathCount "/data_centers/data_center[@id]"`
        echo "Current data center count: " ${c}
    }

    function attachStorageToDataCenter {
        local dataCenterName=$1
        local storageName=$2

        getDataCenters
        local idDataCenter=`getXPathValue "/data_centers/data_center[name='${dataCenterName}']/@id"`
        echo "idDataCenter: " ${idDataCenter}

        callGETService "/api/datacenters/${idDataCenter}/storagedomains"

        local storagesAttachedCount=`getXPathCount "/storage_domains/storage_domain[name='${storageName}']/data_center[@id]"`
        local idStorage=`getXPathValue "/storage_domains/storage_domain[name='$storageName']/@id"`
        echo "storagesAttachedCount: " ${storagesAttachedCount}
        echo "idStorage: " ${idStorage}

        if [[ "${storagesAttachedCount}" == "0" ]]; then
            echo "Storage is not attached, attaching: ${storageName}..."
            local xml="<storage_domain><name>${storageName}</name></storage_domain>"
            callPOSTService "/api/datacenters/${idDataCenter}/storagedomains" "${xml}"
            cat ${COMM_FILE}
            echo "Storage domain attach request has been sent."
        else
            echo "Domain: ${storageName} already attached to data center: ${dataCenterName}"
        fi
    }

    # activate DC storage
    function activateDataCenterStorage {
        local dataCenterName=$1
        local storageName=$2

        getDataCenters
        local idDataCenter=`getXPathValue "/data_centers/data_center[name='$dataCenterName']/@id"`
        getStorages
        local idStorageDomain=`getXPathValue "/storage_domains/storage_domain[name='$storageName']/@id"`
        local storageDomainUri="/api/datacenters/${idDataCenter}/storagedomains"

        # get status of storage domain
        callGETService "${storageDomainUri}"

        local xPathStatusTest="/storage_domains/storage_domain[@id='${idStorageDomain}']/status[state='active']"
        local xPathStatusValue="/storage_domains/storage_domain[@id='${idStorageDomain}']/status/state"

        local activeCount=`getXPathCount "${xPathStatusTest}"`

        if [[ "${activeCount}" == "0" ]]; then
            echo "Storage is not active, activating: ${storageName}..."
            local xml="<action/>"
            callPOSTService "/api/datacenters/${idDataCenter}/storagedomains/${idStorageDomain}/activate" "${xml}"
            sleep 10
            cat ${COMM_FILE}
            echo "Attach request sent."
          # wait till storage domain is active
          waitForStatus "${storageDomainUri}" "${xPathStatusTest}" "${xPathStatusValue}" 20
        else
            echo "Domain ${storageName} is already active."
        fi
    }

    # get VM
    function getVirtualMachines {
        callGETService "/api/vms"
        local c=`getXPathCount "/vms/vm"`
        echo "Current VM count: " ${c}
    }

    # create VM
    function createVirtualMachineFromTemplate {
        local vmName=$1
        local clusterName=$2
        local templateName=$3
        # bytes
        local memorySize=$4

        getVirtualMachines
        local c=`getXPathCount "/vms/vm[name='${vmName}']"`

        if [[ "$c" == "0" ]]; then
            echo "VM doesn't exist, creating: ${vmName}..."
            local xml="<vm><name>${vmName}</name><cluster><name>${clusterName}</name></cluster><template><name>${templateName}</name></template><memory>${memorySize}</memory><os type='other_linux'><boot dev='hd'/></os><type>server</type></vm>"
            callPOSTService "/api/vms" "${xml}"
            cat ${COMM_FILE}
            echo "VM created."
        else
            echo "VM exists: ${vmName}"
        fi
    }

    # create VM network
    function createVirtualMachineNIC {
        local vmName=$1
        local networkName=$2

        getVirtualMachines
        local c=`getXPathCount "/vms/vm[name='${vmName}']"`

        if [[ "$c" == "0" ]]; then
            echo "VM doesn't exist: ${vmName}"
        else
            local idVM=`getXPathValue "/vms/vm[name='${vmName}']/@id"`

            callGETService "/api/vms/${idVM}/nics"
            local nicsCount=`getXPathCount "/nics/nic[@id]"`

            if [[ "$nicsCount" == "0" ]]; then
              echo "NIC doesn't exist, creating..."
              local xml="<nic><name>nic1</name><network><name>${networkName}</name></network></nic>"
              callPOSTService "/api/vms/${idVM}/nics" "${xml}"
              cat ${COMM_FILE}
              echo "NIC created."
            else
              echo "NIC exists."
          fi
        fi
    }

    # create VM storage
    function createVirtualMachineDisk {
        local vmName=$1
        local diskSize=$2
        local storageName=$3

        getVirtualMachines
        local c=`getXPathCount "/vms/vm[name='${vmName}']"`

        if [[ "$c" == "0" ]]; then
            echo "VM doesn't exist: ${vmName}"
        else
            local idVM=`getXPathValue "/vms/vm[name='${vmName}']/@id"`

            callGETService "/api/vms/${idVM}/disks"
            local diskCount=`getXPathCount "/disks/disk[@id]"`

            if [[ "$diskCount" == "0" ]]; then
              echo "Disk doesn't exist, creating..."
              getStorages
            local idStorageDomain=`getXPathValue "/storage_domains/storage_domain[name='${storageName}']/@id"`
            echo "idStorageDomain: " ${idStorageDomain}
              local xml="<disk><storage_domains><storage_domain id='${idStorageDomain}'/></storage_domains><size>${diskSize}</size><type>system</type><interface>virtio</interface><format>cow</format><bootable>true</bootable></disk>"
              callPOSTService "/api/vms/${idVM}/disks" "${xml}"
              cat ${COMM_FILE}
              echo "Disk created."
            else
              echo "Disk exists."
          fi
        fi
    }

    # create VM iso drive
    function createVirtualMachineCDROM {
        local vmName=$1
        local isoImageName=$2

        getVirtualMachines
        local c=`getXPathCount "/vms/vm[name='${vmName}']"`

        if [[ "$c" == "0" ]]; then
            echo "VM doesn't exist: ${vmName}"
        else
            local idVM=`getXPathValue "/vms/vm[name='${vmName}']/@id"`

            callGETService "/api/vms/${idVM}/cdroms"
            local diskCount=`getXPathCount "/cdroms/cdrom[@id]/file[@id]"`

            if [[ "$diskCount" == "0" ]]; then
              echo "CD-ROM doesn't exist, creating..."
              local xml="<cdrom><file id='${isoImageName}'/></cdrom>"
              callPOSTService "/api/vms/${idVM}/cdroms" "${xml}"
              cat ${COMM_FILE}
              echo "CD-ROM created."
            else
              echo "CD-ROM exists."
          fi
        fi
    }

## Environment synchronization script

*   File: synch_env.sh

<!-- -->

    # configuration of the oVirt engine
    ENGINE_URL="http://localhost:8700"
    USER_NAME="admin@internal"
    USER_PASSW="YOUR_PASSWORD"
    # CA certificate path
    CA_CERT_PATH=""

    DIR=`dirname $0`
    source ${DIR}/rest_api_routines.sh

    echo "Current status..."
    getDataCenters
    getClusters
    getHosts
    getVirtualMachines

    echo "Synchronizing configuration..."
    createHost "server1.example.com" "192.168.10.10" "123456" "Default"
    createHost "server2.example.com" "192.168.10.11" "123456" "Default"

    # create vs. import
    createNfsDataStorage "Storage_DATA" "192.168.10.12" "/mnt/export/nfs/data" "server1.example.com"
    attachStorageToDataCenter "Default" "Storage_DATA"
    activateDataCenterStorage "Default" "Storage_DATA"

    createNfsExportStorage "Storage_EXPORT" "192.168.10.12" "/mnt/export/nfs/export" "server1.example.com"
    attachStorageToDataCenter "Default" "Storage_EXPORT"
    activateDataCenterStorage "Default" "Storage_EXPORT"

    importNfsIsoStorage "192.168.10.12" "/mnt/export/nfs/iso" "server1.example.com"
    # supply existing name of iso domain (imported):
    attachStorageToDataCenter "Default" "iso"
    # supply existing name of iso domain (imported):
    activateDataCenterStorage "Default" "iso"

    # VM 512M, disk 10GB
    createVirtualMachineFromTemplate "Fedora17_test1" "Default" "Blank" "536870912"
    createVirtualMachineNIC "Fedora17_test1" "ovirtmgmt"
    createVirtualMachineDisk "Fedora17_test1" "10485760000" "Storage_DATA"
    # iso file must be a part of the iso domain
    createVirtualMachineCDROM "Fedora17_test1" "Fedora-17-x86_64-DVD.iso"
