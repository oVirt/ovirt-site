---
title: Vdsm Log Files
category: vdsm
authors: abaron, danken, quaid
wiki_category: Vdsm
wiki_title: Vdsm Log Files
wiki_revision_count: 6
wiki_last_updated: 2012-02-13
---

# Vdsm Log Files

Vdsm's log files reside under `/var/log/vdsm/`

They are named `vdsm.log(.\d+.xz)?`.

*Notice that the logs are in lzma2 format, which is not-quite-standard but very efficient for log files.*

Log lines are in the format of:

      ThreadID/TaskID::ERROR_LEVEL::DATE TIME::FILE_NAME::LINE::LOGGER_NAME::(FUNCTION_NAME) MESSAGE

## Common lookups

There are common things you would like to do while reading logs in Vdsm. These are all less lookup expressions.

*   To follow a thread or a task use "^THREAD_OR_TASKID::"
*   Every call through the storage API generates a "Run and protect" call. Following these will give you a grasp of what users of Vdsm asked Vdsm to do, when, and what was the response.

<Category:Vdsm>
