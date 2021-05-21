---
title: Engine Vacuum Tool
category: feature
authors: roy
---

# Engine Vacuum

# Description
This page describes the **_engine-vacuum_** cli tool and the **_vacuum setup-plugin_** that uses it.

# Motivation

> "PostgreSQL databases require periodic maintenance known as vacuuming.
For many installations, it is sufficient to let vacuuming be performed by the autovacuum daemon"
> - routine-vacuuming, [postgres documentation][1]

Apart from updating the tables and removing garbage from the tables,
full vacuum is the only vacuum operation that can reclaim disk space back to the operating system.
If the engine db is falling behind in collecting garbage,(autovacuum doesn't perfom optimally) we will
see disk usage growth in time as a result.

The engine-vacuum tool is a wrapper around postgres commands and is aimed to ease Vacuum
maintenance actions on the DB, and can be used easily and securely, as they reuse
the setup credentials to authenticate against the engine db. The tool is being
used by an engine-setup plugin and act as a maintenance task, taking advantage of
the downtime period when updating the engine. The tool can be used just as well
by cron, script or just manual invocation and it covers most of the functionality
of the vacuum commands.

# Scope
This page covers the tool itself, and the engine-setup plugin that was created to use it.

Not covered - Vacuum design and functionality. See the references section to read about vacuum.

# Synopsis

## engine-vacuum

```bash
  engine-vacuum [OPTION]...
```
Located under `/bin/engine-vacuum`, invoking this can perform vacuum, vacuum full
and analyze against the installed engine db, optionally specifying the tables,
without needing to specifying the engine db, user and password.

```bash
engine-vacuum --help

  -a          - run analyze, update optimizer statistics
  -A          - run analyze only, only update optimizer stats, no vacuum
  -f          - do full vacuuming
  -t          - vacuum specific table
  -v          - verbose output
  -h          - print this usage message
```

## Examples
Run vacuum only:

```bash
engine-vacuum
```

Run vacuum analyze:

```bash
engine-vacuum -a
```

Only update [optimizer stats][optimizer-stats-doc], no vacuum:

```bash
engine-vacuum -A
```
Run vacuum full, and verbose for more output:

```bash
engine-vacuum -f -v
```
Run vacuum full, verbose on vm_dynamic and vds_dynamic tables only:

```bash
engine-vacuum -f -v -t vm_dynamic -t vds_dynamic
```

## Vacuum setup plugin
During an execution of engine-setup, excluding new installation, at the
 customization stage, the setup will raise a dialog, asking to perform full vacuum:

```bash
$ engine-setup
...
[ INFO  ] Stage: Environment customization
...
          Perform full vacuum on the engine database engine@localhost?
          This operation may take a while depending on this setup health and the
          configuration of the db vacuum process.
          See https://www.postgresql.org/docs/9.2/static/sql-vacuum.html
          (Yes, No) [No]:
```

Choosing `[Yes]`, will invoke vacuum full verbose on the engine db by
invoking `engine-vacuum -f -v` and by setting `/tmp/{tmpdir}/.pgpass` - See [pgpass documantation][2].

- Default value: _No_ (does nothing)
- Output: to the install log, small elapsed time summary to the console
- Answer file entry: `OVESETUP_DB/engineVacuumFull=bool:False`
- Fail install on error: _Yes_, output will go to the installation log

## Security
The credentials of the user, engine db and password
are taken from /etc/ovirt-engine/engine.conf.d/10-setup-database and passed
using .pgpass file thus not used as a command argument and not in risk to
go into history, log or similar. See [pgpass documentation][2] for more details.

## TODO
- Try to give a rough estimation of how long this is going to take. We can count
the dead rows and at least provide the size of amount of bytes to delete.

```sql
select relname,n_dead_tup from pg_stat_user_tables order by n_dead_tup desc;
```

# References
[1]: https://www.postgresql.org/docs/9.2/static/routine-vacuuming.html
[2]: https://www.postgresql.org/docs/9.2/static/libpq-pgpass.html
[3]: https://bugzilla.redhat.com/show_bug.cgi?id=1388430
[optimizer-stats-doc]: https://wiki.postgresql.org/wiki/Introduction_to_VACUUM,_ANALYZE,_EXPLAIN,_and_COUNT#Using_ANALYZE_to_optimize_PostgreSQL_queries

- [Postgres routine vacuuming documentation page][1]
- [Postgres pgpass documentation page][2]
- [The original RFE for this page][3] - https://bugzilla.redhat.com/show_bug.cgi?id=1388430
- [Using ANALYZE to optimize PostgreSQL queries][optimizer-stats-doc]
