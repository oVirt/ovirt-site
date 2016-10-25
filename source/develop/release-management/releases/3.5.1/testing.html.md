---
title: oVirt 3.5.1 Testing
category: integration
authors: didi, phurrelmann, sandrobonazzola, stirabos
wiki_category: Integration
wiki_title: Testing/oVirt 3.5.1 Testing
wiki_revision_count: 19
wiki_last_updated: 2015-01-16
---

# oVirt 3.5.1 Testing

## What to do as a participant

*   Look at [oVirt 3.5 TestDay](oVirt 3.5 TestDay) for understanding what should be tested
*   Update the Participants section.
*   Run into any issues? Report it on IRC, user mailing list, or bugzilla.

## Participants

Test Days are open to anyone.

If you have your own setup, we will provide all the software packages and the required information.

If you're willing to participate, please add yourself to the table below:

## Release Candidate

| Name                                               | part tested       | Storage | Networking | Distribution | Bugs |
|----------------------------------------------------|-------------------|---------|------------|--------------|------|
| [Sandro Bonazzola](https://github.com/sandrobonazzola) | AIO clean install | NFS     | basic      | Fedora 20    |      |
| [Simone Tiraboschi](User:Stirabos)      | AIO clean install | NFS     | basic      | Centos 6.5   |      |
| [Simone Tiraboschi](User:Stirabos)      | AIO clean install | NFS     | basic      | Centos 7     |      |

## Development

| Name                                               | part tested                                                                                  | Storage | Networking | Distribution                                   | Bugs |
|----------------------------------------------------|----------------------------------------------------------------------------------------------|---------|------------|------------------------------------------------|------|
| [Sandro Bonazzola](https://github.com/sandrobonazzola) | AIO clean install                                                                            | NFS     | basic      | Fedora 20                                      |      |
| [Sandro Bonazzola](https://github.com/sandrobonazzola) | Upgrade from 3.4.4                                                                           | NFS     | basic      | CentOS 6.6                                     |      |
| [Simone Tiraboschi](User:Stirabos)      | hosted-engine from scratch                                                                   | NFSv4   | basic      | CentOS 6.6 for the hosts and for the engine VM |      |
| [Sandro Bonazzola](https://github.com/sandrobonazzola) | [QA:TestCase Hosted Engine Upgrade](QA:TestCase Hosted Engine Upgrade) from 3.4.4 | NFS     | basic      | CentOS 6.6                                     | <s>  
                                                                                                                                                                                                                             </s>  |
| [Sandro Bonazzola](https://github.com/sandrobonazzola) | [QA:TestCase Hosted Engine Upgrade](QA:TestCase Hosted Engine Upgrade) from 3.4.4 | NFS     | basic      | Host: Fedora 20                                
                                                                                                                                                                             VM: Fedora 19                                  | <s>  
                                                                                                                                                                                                                             </s>  |
| [Patrick Hurrelmann](User:phurrelmann)  | clean install, hosted-engine                                                                 | iSCSI   | basic      | CentOS 7                                       |      |
| [Didi](User:Didi)                       | engine on rhel7                                                                              | NFS     | basic      | RHEL 7                                         |      |

