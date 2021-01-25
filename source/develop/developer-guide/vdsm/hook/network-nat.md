---
title: network-nat
authors: rstory
---

# network-nat

This hook can be used to force a VM to use a libvirt network that is managed outside of ovirt, such as an openvswitch network, or libvirt's default network.

This is a modification of the existing extnet hook.

## engine setup

Go to the engine machine's command line and do:

         sudo engine-config -s CustomDeviceProperties=\
         '{type=interface;prop={extnet_pg=^[a-zA-Z0-9_ ---]+(:[a-zA-Z0-9_ ---]+|)$}}'

Verify that it was properly added

         sudo engine-config -g CustomDeviceProperties

Restart the engine.

## webadmin setup

Define a vNIC profile for a network that has a 'extnet_pg' custom device property with value 'ovs-network:vlan-20', for example.

Then, attach the defined profile to the relevant vNIC. When the VM is run, the relevant vNIC will be attached to the network and portgroup that you passed it.

## Hook

You just need to create a python executable and put it in:

       /usr/libexec/vdsm/hooks/before_device_create
       /usr/libexec/vdsm/hooks/before_nic_hotplug

    #!/usr/bin/python

    """
    Tweak an interface defintion so that it uses a specific network and port group.
    It applies on a per vnic basis, it gets triggered and used by two different
    events:
    * before_device_create
    * before_nic_hotplug

    This hook can be used to force a VM to use a libvirt network that is managed
    outside of ovirt, such as an openvswitch network, or libvirt's default network.
    """

    import copy
    import os
    import sys
    import traceback
    import xml.dom

    import hooking

    HOOK_NAME = 'extnet_ovs'

    def replaceSource(interface, newnet, port_group=None):
        source = interface.getElementsByTagName('source')[0]
        source.removeAttribute('bridge')
        source.setAttribute('network', newnet)
        if port_group is not None:
            source.setAttribute('portgroup', port_group)
            interface.setAttribute('type', 'network')

    def main():
        newnet = os.environ.get('extnet_ovs')
        if ':' in newnet:
            newnet, port_group = newnet.split(':')
            if newnet is not None:
                doc = hooking.read_domxml()
                interface, = doc.getElementsByTagName('interface')
                replaceSource(interface, newnet, port_group)
                hooking.write_domxml(doc)

    def test():
        interface = xml.dom.minidom.parseString("""
                <interface type="bridge">
                <address bus="0x00" domain="0x0000" function="0x0" slot="0x03"\
                type="pci"/>
                <mac address="00:1a:4a:16:01:b0"/>
                <model type="virtio"/>
                <source bridge="ovirtmgmt"/>
                <filterref filter="vdsm-no-mac-spoofing"/>
                <link state="up"/>
                <boot order="1"/>
                </interface>
                """).getElementsByTagName('interface')[0]

        ovs_interface = xml.dom.minidom.parseString("""
        <interface type='bridge'>
        <mac address='00:1a:4a:83:fb:00'/>
        <source bridge='ovirtmgmt'/>
        <target dev='vnet0'/>
        <model type='virtio'/>
        <filterref filter='vdsm-no-mac-spoofing'/>
        <link state='up'/>
        <bandwidth>
        </bandwidth>
        <alias name='net0'/>
        <address type='pci' domain='0x0000' bus='0x00' slot='0x03' function='0x0'/>
        </interface>
        """).getElementsByTagName('interface')[0]

        print "Interface before forcing network: %s" % \
            interface.toxml(encoding='UTF-8')

        first_test = copy.deepcopy(interface)
        replaceSource(first_test, 'Eureka!')
        print "Interface after forcing network: %s" % \
            first_test.toxml(encoding='UTF-8')

        second_test = copy.deepcopy(interface)
        replaceSource(second_test, 'ovs-network', port_group='vlan-20')
        print "Interface after forcing network and port group: %s" % \
            second_test.toxml(encoding='UTF-8')

        print "OVS interface before forcing network: %s" % \
            ovs_interface.toxml(encoding='UTF-8')

        replaceSource(ovs_interface, 'ovs-network', port_group='vlan-10')
        print "OVS interface after forcing network and port group: %s" % \
            ovs_interface.toxml(encoding='UTF-8')

    if __name__ == '__main__':
        try:
            if '--test' in sys.argv:
                test()
            else:
                main()
        except:
            hooking.exit_hook('extnet hook: [unexpected error]: %s\n' %
                              traceback.format_exc())
