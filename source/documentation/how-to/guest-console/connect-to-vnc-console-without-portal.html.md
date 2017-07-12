---
title: How to Connect to VNC Console Without Portal
category: howto
authors: dyasny
---

<!-- TODO: Content review -->

# How to Connect to VNC Console Without Portal

This method has been tested with tigerVNC (vncviewer) client on RHEL and Fedora.

The client.conf file should contain the path and the executable for the VNC client:

     CLIENTPATH=/usr/bin/
     CLIENTEXEC=vncviewer

Usage:

             vncConnect.py - Locate a VM by name and open it's VNC console
             Usage:  vncConnect.py | [arg].internal..[argN]
             Options:
             --help:                Print this help screen.
`       --address=`<FQDN or IP: Use non-default (127.0.0.1) IP to access
          the RHEV-M API.
        --port=<PORT>`:         Use non-default (443) port to access`
               the RHEV-M API.
             --user=`<Username>`:     Use non-default (admin@internal) username
               to access RHEV-M API. Must use USER@DOMAIN
             --password=`<PASSWORD>`: Enter the API user password
             --vm=`<VM NAME>`:        Enter name of the requested VM
             If no options are entered, or --password and/or --vm options are
             missing, will enter interactive mode.

vncClient.py ![](vncClient.bz2 "fig:vncClient.bz2"):

    #!/bin/env python

    import urllib2
    import sys
    import base64
    import os
    from xml.dom import minidom
    import subprocess
    import getopt
    import traceback
    import random

    def usage():
        print """
            vncConnect.py - Locate a VM by name and open it's VNC console
            Usage:  vncConnect.py | [arg].internal..[argN]
            Options:
            --help:                Print this help screen.
            --address=<FQDN or IP: Use non-default (127.0.0.1) IP to access
              the RHEV-M API.
            --port=<PORT>:         Use non-default (443) port to access
              the RHEV-M API.
            --user=<Username>:     Use non-default (admin@internal) username
              to access RHEV-M API. Must use USER@DOMAIN
            --password=<PASSWORD>: Enter the API user password
            --vm=<VM NAME>:        Enter name of the requested VM

            If no options are entered, or --password and/or --vm options are
            missing, will enter interactive mode.
        """
        sys.exit(0)

    def APIcall(call):
        global USER, PASSWD, APIURL
        URL = APIURL + call
        request = urllib2.Request(URL)
        base64string = base64.encodestring('%s:%s' % (USER, PASSWD)).strip()
        request.add_header("Authorization", "Basic %s" % base64string)
        #log('API GET called: ' + call)
        try:
            xmldata = urllib2.urlopen(request).read()
        except urllib2.URLError, e:
            print "Error: cannot connect to REST API: %s" % (e)
            print "Try to login using the same user/pass in Admin Portal\
            and check the error!"
            sys.exit(2)
        return minidom.parseString(xmldata)

    def APIpost(call, postdata):
        global USER, PASSWD, APIURL
        URL = APIURL + call
        request = urllib2.Request(URL)
        base64string = base64.encodestring('%s:%s' % (USER, PASSWD)).strip()
        request.add_header("Authorization", "Basic %s" % base64string)
        request.add_header('Content-Type', 'application/xml')
        #log('API POST called: ' + call + ' :: ' + postdata)
        try:
            xmldata = urllib2.urlopen(request, postdata).read()
        except urllib2.URLError, e:
            print "Error: cannot connect to REST API: %s" % (e)
            print "Try to login using the same user/pass in Admin Portal \
            and check the error!"
            sys.exit(2)
        return minidom.parseString(xmldata)

    def run():
        global ADDR, API_PORT, VM, USER, PASSWD
        xmldata = APIcall('vms')
        for vm in xmldata.getElementsByTagName('vm'):
            if vm.getElementsByTagName('name')[0].firstChild.data == VM:
                vmxml = vm
                break

        try:
            host = vmxml.getElementsByTagName('address')[0].firstChild.data
            port = vmxml.getElementsByTagName('port')[0].firstChild.data
        except e:
            print "Error: VM probably not running: %s" % (e)

        if vmxml.getElementsByTagName('display')[0].\
        getElementsByTagName('type')[0].firstChild.data != 'vnc':
            print "Error: VM is not using VNC"
            sys.exit(2)

        vmid = vmxml.attributes.items()[1][1]

        ticket = random.randint(10000000, 99999999)
        xml_request = """<action>
            <ticket>
                <value>""" + str(ticket) + """</value>
                   <expiry>60</expiry>
              </ticket>
            </action>"""
        URL = 'vms/' + vmid + '/ticket'
        APIpost(URL, xml_request)
        return host, port, ticket

    def getArgs():
        global ADDR, API_PORT, VM, USER, PASSWD
        print "Missing some options. Entering interactive mode..."
        i = raw_input('Enter the RHEV-M address [' + ADDR + ']: ')
        if i != '':
            ADDR = i
        i = raw_input('Enter the RHEV-M API port [' + API_PORT + ']: ')
        if i != '':
            API_PORT = i
        i = raw_input('Enter the RHEV-M API user name [' + USER + ']: ')
        if i != '':
            USER = i
        i = raw_input('Enter the RHEV-M API password [' + PASSWD + ']: ')
        if i != '':
            PASSWD = i
        i = raw_input('Enter the Virtual Machine name [' + VM + ']: ')
        if i != '':
            VM = i

    def startVnc(host, port, ticket, viewerpath, viewerexec):
        cmd = "echo " + str(ticket) + " | /" + viewerpath + viewerexec + \
        " " + str(host) + ":" + str(port) + " --passwdInput=true"
        #print cmd
        subprocess.call(cmd, shell=True)

    if __name__ == '__main__':
        #Setting defaults, to be overriden by user
        API_PORT = "443"
        USER = "admin@internal"
        ADDR = "127.0.0.1"
        PASSWD = ""
        VM = ""
        CONF = os.getcwd() + "/client.conf"
        VPATH = "None"
        VEXEC = "None"

        try:
            v = open(CONF)
        except SystemExit as e:
            raise e
            exit(1)

        for val in v:
            if val.split('=')[0] == "CLIENTPATH":
                VPATH = val.split('=')[1].rstrip()
            elif val.split('=')[0] == "CLIENTEXEC":
                VEXEC = val.split('=')[1].rstrip()
            else:
                print "Wrong configuration value encountered"

        if VPATH == "None" or VEXEC == "None":
            print "Configuration values for CLIENTEXEC or CLIENTPATH \
            missing in " + CONF
            exit(1)

        try:
            opts, args = getopt.getopt(sys.argv[1:], "h", \
            ['help', 'address=', 'port=', 'user=', 'password=', 'vm='])
            for o, v in opts:
                #print (o,v)
                if o == "-h" or o == "--help":
                    usage()
                    sys.exit(0)
                elif o == '--address':
                    ADDR = v
                elif o == '--port':
                    API_PORT = v
                elif o == '--user':
                    USER = v
                elif o == '--password':
                    PASSWD = v
                elif o == '--vm':
                    VM = v
                else:
                    print "Wrong argument " + v
                    sys.exit(1)

        except SystemExit as e:
            raise e
        except:
            print traceback.format_exc()
            sys.exit(1)

        if PASSWD == "" or VM == "":
            getArgs()

        APIURL = 'https://' + ADDR + ':' + API_PORT + '/api/'

        host, port, ticket = run()
        startVnc(host, port, ticket, VPATH, VEXEC)

        sys.exit(0)
