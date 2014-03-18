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
*   [PEP8](http://legacy.python.org/dev/peps/pep-0008/) is holy.
*   API calls and arguments are mixedCased, but new internal modules should use underscore_separated_names.
*   Class names are in CamelCase.
*   All indentation is made of the space characters. Tabs are evil. In makefiles, however, tabs are obligatory.
*   Whitespace between code stanzas are welcome. They help to breath while reading long code. However, splitting them to helper functions could be even better.
*   Let logging method do the formatting for you:

      logging.debug('hello %s', 'world')

Rather than

      logging.debug('hello %s' % 'world')

*   try-except blocks should be tiny (if existing at all), and the caught exception should be the narrowest possible. Note that the following code

      try:
        code_that_may_raise
      except Exception:
        log

basically means "I do not care if code_that_may_raise fails or succeeds"; if this is the case, why should we even try to run it?

*   Swallowing an exception is evil, but if you have to do it, log it.
*   Long if-elif should end with an `else:` clause. `else: pass` is perfectly acceptable, since it tells the reader of the code "yes, I thought of this case, and we should do nothing when we get to it".
*   Configurables should be avoided. The code should do the "right thing" and not expect the end user to tweak vdsm.conf on each of their machines.
