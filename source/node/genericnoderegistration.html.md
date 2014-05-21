---
title: GenericNodeRegistration
category: node
authors: alonbl, dougsland, rbarry
wiki_title: Features/Node/GenericNodeRegistration
wiki_revision_count: 9
wiki_last_updated: 2015-05-20
---

# Generic Node Registration

### Summary

This will provide a generic, extensible way for Node to register to management servers.

### Owner

*   Name: [ Ryan Barry](User:rbarry)

<!-- -->

*   Email: rbarry AT redhat DOT com
*   IRC: rbarry

### Current status

*   Development 50% complete
*   Link to feature page in a specific release. That release may complete the feature, or parts of it. The complete scope of this feature in this release will be described in the release feature page
*   Last updated: ,

### Detailed Description

The current registration process for oVirt Node relies upon vdsm-reg, which relies on configuration-as-code and is not suitable for other managers. Generic registration will provide a registration process which relies on structured data (YAML or JSON) to describe steps and parameters for execution.

### Benefit to oVirt

Increased agility, easier integration into other projects.

### Dependencies / Related Features

*   Affected Packages
    -   ovirt-node

### Documentation / External references

The code for vdsm-reg and the [Features/HostDeployProtocol](Features/HostDeployProtocol) describe the other end of the process.

Draft spec is:

    {
        "register": {
            "steps": [ 
                {
                    "name": "get_ca",
                    "action": "get",
                    "parameters": {
                        "host": "engine.example.com",
                        "url": "http://{host}/url?cmd=get-ca-roots",
                        "filename": "/etc/pki/ovirt-engine.key"
                    }
                },
                {
                    "name": "approve",
                    "action": "ui",
                    "parameters": {
                        "key": "OVIRT_ENGINE_FINGERPRINT"
                    }
                },
                {
                    "name": "persist_ca",
                    "action": "persist",
                    "parameters": {
                        "file": "/etc/pki/ovirt-engine.key"
                    }
                },
                {
                    "name": "get_ssh",
                    "action": "get",
                    "parameters": {
                        "host": "engine.example.com",
                        "url": "http://{host}/url?=cmd=get-sshkey&type=manager",
                        "filename": "/tmp/ovirt-engine.key"
                    }
                },
                {
                    "name": "authorize",
                    "action": "exec",
                    "parameters": {
                        "cmd": "cat/tmp/ovirt-engine.key>>/home/admin/.ssh/.authorized_keys"
                    }
                },
                {
                    "name": "persist_ssh",
                    "action": "persist",
                    "parameters": {
                        "file": "/home/admin/.ssh/.authorized_keys"
                    }
                },
                {
                    "name": "finish",
                    "action": "get",
                    "parameters": {
                        "host": "engine.example.com",
                        "url": "http://{host}/url?cmd=register&name={name}&ip={ip}&sshkeyfingerprint={fingerprint}&user={user}",
                        "name": "node.example.com",
                        "ip": "10.0.0.1",
                        "fingerprint": "DE:AD:BE:EF",
                        "user": "admin"
                    }
                }
            ]
        }
    }

### Comments and Discussion

This below adds a link to the "discussion" tab associated with your page. This provides the ability to have ongoing comments or conversation without bogging down the main feature page

*   Refer to [Talk:Generic Node Registration](Talk:Generic Node Registration)

<Category:Feature> <Category:Template> <Category:Node>
