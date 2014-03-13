---
title: Vdsm Coding Guidelines
category: vdsm
authors: adahms, danken, dougsland
wiki_title: Vdsm Coding Guidelines
wiki_revision_count: 6
wiki_last_updated: 2014-07-31
---

## Vdsm Coding Guidelines

*   Vdsm is written in Python (at least mostly), and its coding style should follow the best practices of Python coding, unless otherwise declared.
*   PEP8 is holy
*   API calls and arguments are mixedCased, but new internal modules should use underscore_separated_names.
*   Class names are in CamelCase
*   All indentation is made of the space characters. Tabs are evil.
*   Whitespace between code stanzas help to breath while reading code.
*   Let logging method do the formatting for you:

      logging.debug('hello %s', 'world')

Rather than

      logging.debug('hello %s' % 'world')
