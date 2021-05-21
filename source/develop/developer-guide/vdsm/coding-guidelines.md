---
title: Vdsm Coding Guidelines
category: vdsm
authors:
  - adahms
  - danken
  - dougsland
---

# VDSM Coding Guidelines

*   VDSM is written primarily in Python, and its coding style should follow the best practices of Python coding unless otherwise declared.
*   [PEP8](http://legacy.python.org/dev/peps/pep-0008/) is holy.
*   API calls and arguments are mixedCased, but new internal modules should use underscore_separated_names.
*   Imports should be grouped in the following order:

    1. Standard library imports

    1. Related third party imports

    1. Local application-specific or library-specific imports You should put a blank line between each group of imports. [More info about import? See PEP8 imports](http://legacy.python.org/dev/peps/pep-0008/#imports)

*   Class names are in CamelCase.
*   All indentation is made of the space characters. Tabs are evil. In makefiles, however, tabs are obligatory.
*   White space between code stanzas are welcome. They help to create breathing while reading long code. However, splitting stanzas into helper functions could be even better.
*   Let logging method do the formatting for you:

      logging.debug('hello %s', 'world')

Rather than:

      logging.debug('hello %s' % 'world')

*   try-except blocks should be tiny (if existing at all), and the caught exception should be the narrowest possible. Note the following code:

      try:
        code_that_may_raise
      except Exception:
        log

Code such as the above basically means "I do not care if code_that_may_raise fails or succeeds". If this is the case, why try run that code at all?

*   Swallowing an exception is evil, but if you have to do it, log it.
*   Long if-elif should end with an `else:` clause. `else: pass` is perfectly acceptable because it tells the reader of the code, "yes, I thought of this case, and we should do nothing when we get to it".
*   Configurables should be avoided. The code should do the "right thing" and not expect the end user to tweak vdsm.conf on each of their machines.
*   `__repr__` is usually preferred over `__str__` to make string information about an instance if only one of the methods is defined, since `__repr__` is used in more situations than `__str__` is.
