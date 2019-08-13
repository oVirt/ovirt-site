---
title: REST API Using BASH Automation
category: api
authors: lspevak
---

# REST API Using BASH Automation

## Introduction

To prepare and regularly refresh a development and/or testing environment for oVirt Engine can be a time-consuming procedure. The REST API can help significantly with the task. This article concentrates on calling oVirt REST API using a BASH scripting from the Linux command line.

It uses:

*   BASH interpreter
*   curl (HTML command line client)
*   xmllint (XPath command line parser)

## Supported commands

*   create host server
*   create/import/attach/activate storage domain
*   create virtual machine (VM) and its network, attach image disk and iso disk (CD-ROM)

## Basic operations

*   The commands should always check the current state, fetch needed parameters and run the actions only if required, e.g. a host is created from the command, if it doesn't exist only.
*   The runtime environment is always synchronized with the script state. If the action is asynchronous, it should wait for a given time-out period and periodically check status of the operation by calling the REST API, parsing returned values using XPath processor and checking expected target status value.
*   For HTTPS connection a trusted authority (CA) server certificate is required, else '--insecure' option is to be specified for the curl command.
*   The responses are saved and processed from the specified communication file.

## Source code

The script has two parts:

*   general support routines (HTTP method call using curl client, XPath parser)
*   environment synchronization script

For download:

*   rest_api_routines.sh
*   synch_env.sh

Here: [TGZ](http://resources.ovirt.org/old-site-files/wiki/Rest_api_files.tar.gz)

GitHub sources:

*   git clone <git://github.com/lspevak/ovirt-restapiconf.git>

The following sections contain snipples of code showing the creation of a host in the Engine.

## General support routines

### XPath support

*   support for getting a value or count of elements selected by a XPath expression in XML file using xmllint tool

<!-- -->

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

### HTTP client support

*   basic support for GET, POST methods using curl client

<!-- -->

    HEADER_CONTENT_TYPE="Content-Type: application/xml"
    HEADER_ACCEPT="Accept: application/xml"

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

### Waiting for the state with a time-out

*   Asynchronous tasks require a testing of the current state returned by HTTP GET method in cycle.

<!-- -->

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

### List hosts and create host actions

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

### Listing names of objects

*   Using combination of XPath count and XPath string functions, you can iterate e.g. names.

<!-- -->

    function showList {
        local xPath=$1

        local c=`getXPathCount "${xPath}"`

        for i in $(seq 1 ${c})
        do
            local val=`getXPathValue "(${xPath})[$i]"`
            echo ${val}
        done

        echo "Count: ${c}"
    }

    ...
    # show names of configured hosts
    function showHostList {
        showList "/hosts/host/name"
    }

    # show names of configured VMs
    function showVMList {
        showList "/vms/vm/name"
    }

## Environment synchronization script

*   The script uses general routines and describes the target state of your environment.

<!-- -->

    # configuration of the oVirt engine
    ENGINE_URL="http://localhost:8700"
    USER_NAME="admin@internal"
    USER_PASSW="YOUR_PASSWORD"
    # CA certificate path
    CA_CERT_PATH=""

    echo "Current hosts..."
    getHosts

    echo "Synchronizing configuration..."
    createHost "server1.example.com" "192.168.10.10" "123456" "Default"
    createHost "server2.example.com" "192.168.10.11" "123456" "Default"

    getHosts
    showHostList
