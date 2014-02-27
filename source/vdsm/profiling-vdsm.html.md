---
title: Profiling Vdsm
category: vdsm
authors: fromani
wiki_title: Profiling Vdsm
wiki_revision_count: 11
wiki_last_updated: 2014-03-17
---

# Profiling Vdsm

## Summary

This page collects informations and hints about how to profile VDSM. To profile VDSM, you need to do some small and self-contained modifications. Make sure you have the cProfile package available.

**WORK IN PROGRESS**

## General recommendations

*   use standard python tools wherever/whenever feasible and as first choice: they are the most common, widely available, well understood and easily interoperable

<!-- -->

*   bear in mind VDSM is a multi-thread and multi-process system daemon. It has both short-running and long-running threads.

## collecting and inspecting statistics

The advantage of using the standard python tools is that statistics are in the Pstats format, so the [standard way of inspecting them applies](http://docs.python.org/2/library/profile.html).

To explore statistics or to quickly change the presentation of the statistics, the pstats interactive mode can be handy

         python -m pstats /path/to/main/profile/data

[quick description of the interactive mode](http://stefaanlippens.net/python_profiling_with_pstats_interactive_mode)

TODO: add helper snippets/scripts

## profiling functions

If you want to profile single funcions, this decorator is a simple yet effective solution. Credit for this code goes to Antoni Segura Puimedon for the original implementation; the version presented here was edited with the sole purpose to be self-contained:

         def profile(func):
             from cProfile import Profile
             from functools import wraps
             from tempfile import NamedTemporaryFile
             @wraps(func)
             def profiled_execution(*args, **kwargs):
                 logging.info('profiling method %s' % func.__name__)
                 profiler = Profile()
                 ret = profiler.runcall(func, *args, **kwargs)
                 prof_file = NamedTemporaryFile(mode='w',
                                                prefix=func.__name__,
                                                delete=False)
                 profiler.dump_stats(prof_file.name)
                 logging.info('profiled method %s and dumped results to %s' % (
                              func.__name__, prof_file.name))
                 return ret
             return profiled_execution

The "logging" module is already used extensively inside VDSM so it is assumed to be available. You can embed this snippet in the file containing the function you want to profile, or in the vdsm library code. In this case, a good place is lib/vdsm/utils.py in the VDSM source tree.

## profile the entire VDSM

To profile the entire VDSM, you may use [yappi](http://code.google.com/p/yappi/). Despite being a third-party solution, yappi fits nicely with VDSM because it is not intrusive and it is designed to work with long-running multi-threaded applications.

yappi is eaily installable from pip. It is a C extension, so make sure you have the C compiler and the python development packages installed.

A simple way to use yappi is to embed this snippet

         def full_profile():
             try:
                 import yappi
         
                 def dump_prof():
                     from tempfile import NamedTemporaryFile
                     ystats = yappi.get_func_stats()
                     stats = yappi.convert2pstats(ystats)
                     prof_file = NamedTemporaryFile(mode='w',
                                                    prefix='vdsm_yprof',
                                                    delete=False)
                     stats.dump_stats(prof_file.name)
                 import atexit
                 atexit.register(dump_prof)
                 yappi.start()
             except ImportError:
                 pass

inside the vdsm entry point (vdsm/vdsm or /usr/share/vdsm/vdsm) right after the

         if __name__ == "__main__":

line. The stats are gathered in a tempfile prefixed with the 'vdsm_yprof' string, one file per VDSM run, written when VDSM ends. It is recommended to let VDSM end cleanly.
