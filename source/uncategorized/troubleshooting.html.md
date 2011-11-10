---
title: Troubleshooting
authors: 8none1, alonbl, dneary, hozn, jbrooks, jumper45, mburns, sgtpepper, tscofield
wiki_title: Troubleshooting
wiki_revision_count: 15
wiki_last_updated: 2014-12-07
---

# Troubleshooting

## Node

### Installation

### Usage

## Engine

### Installation

* When building the oVirt-Engine with maven, some tests might fail. Try running the maven clean install command with: -DskipTests

### Usage

When I add my host its status is unreachable. The logs indicate the the host is missing the 'engine' network.
Solution: you need to add a bridge to the host with the name 'engine'
