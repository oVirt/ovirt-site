---
title: Vdsm Log Files
category: vdsm
authors: abaron, danken, fromani, quaid
---

# Vdsm Log Files

## General

*   The purpose of this wiki is to describe how to read the vdsm.log file and make sense of it

<!-- -->

*   Vdsm's log files reside under `/var/log/vdsm/`

<!-- -->

*   The log files are named `vdsm.log(.\d+.xz)?`.

<!-- -->

*   *Note that the logs are in lzma2 format, which is not-quite-standard but very efficient for log files.* (use less/xzless and xzgrep to access the log)

## Libvirt logs

To better understand the behaviour of VDSM, it may be useful to look also at libvirt logs. This is especially true when troubleshooting VDSM. Libvirt logs are sent to systemd's journal if available. Otherwise, are logged to /var/lib/libvirt/libvirtd.log (some linux distributions default to /var/lib/libvirt.log)

### Libvirt debug logs

Since oVirt 3.5.0 (VDSM 4.16.0), VDSM does not enable the overly verbose libvirt debug logs automatically. To manually enable libvirt debug logs, please refer to the [official libvirt documentation](http://wiki.libvirt.org/page/DebugLogs) Please note that when reporting libvirt bugs, it is often required to attach the relevant libvirt debug logs.

## Reading the log

### Line structure

*   Log lines have the following format:

      ThreadID/TaskID::LOG_LEVEL::DATE TIME::MODULE::#LINE::LOGGER_NAME::(FUNC_NAME) MESSAGE

*   When vdsm starts up it writes the following line to the log:

      MainThread::`[`INFO::2011-12-05`](INFO::2011-12-05)` 07:04:56,101::vdsm::71::vds::(run) I am the actual vdsm 4.9-0

*   First a breakdown of this line:

      MainThread - name of the thread (can be either MainThread, Thread-XXX with
                   a sequential number, task uuid when async task or Dummy-XXX
                   for storage mailbox)

      INFO - log message level (TRACE, DEBUG, INFO, WARNING, ERROR)
             2011-12-05 07:04:56,101 - Time of message

      vdsm - python module name which wrote to log (in this case vdsm.py)

      71 - line number in the pythonn module

      vds - logger name

      '(run) I am the actual vdsm 4.9-112.1' - message body
      Specifically, this startup message contains '4.9-112.1' which denotes the vdsm version. 

### Tracebacks

*   Normally when there is an unhandled error then vdsm will print a traceback which looks something like this:

      MainThread::ERROR::2011-12-05 07:04:56,300::vdsm::74::vds::(run) Traceback (most 
      recent call last):
         File "/usr/share/vdsm/vdsm", line 72, in run
             serve_clients(log) 
         File "/usr/share/vdsm/vdsm", line 40, in serve_clients
             cif = clientIF.clientIF(log) 
         File "/usr/share/vdsm/clientIF.py", line 111, in init
             self._libvirt = libvirtconnection.get() 
         File "/usr/share/vdsm/libvirtconnection.py", line 111, in get
             conn = libvirt.openAuth('qemu:///system', auth, 0) 
         File "/usr/lib64/python2.6/site-packages/libvirt.py", line 102, in openAuth
             if ret is None:raise libvirtError('virConnectOpenAuth() failed')
         libvirtError: Failed to connect socket to '/var/run/libvirt/libvirt-sock': No 
         such file or directory

*   In the above example you can see that module /usr/share/vdsm/libvirtconnection.py tried to open authentication against libvirt and failed

### Caller IP

*   Every invocation of a vdsm verb starts with a line logging the identity of the caller
*   Non storage verbs start with a log line which contains both the caller IP and invoked verb and its params:

         Thread-15::DEBUG::2011-12-07 11:44:17,737::clientIF::54::vds::(wrapper) 
         [10.35.17.240]::call getVdsCapabilities with () {}

*   Storage verbs log the caller and the verb in separate lines:

      Thread-16::DEBUG::2011-06-23 19:03:11,607::clientIF::225::
      Storage.Dispatcher.Protect::(wrapper) [10.35.16.71]
      Thread-1950::`[`INFO::2011-12-07`](INFO::2011-12-07)` 12:14:15,018::dispatcher::94::
      Storage.Dispatcher.Protect::(run) Run and protect: getDeviceList, args: ( storageType=2)

*   Note that running vdsClient would log with the IP of the host from which the command was invoked even if it is on the same node on which vdsm is running.
    To distinguish vdsClient from the engine you need to identify the caller IP.

### Storage flows

*   All storage commands run as tasks inside vdsm. Some run as synchronous tasks while others run as asynchronous tasks.
*   All storage commands start and end with a log message that has "Run and protect: VERB NAME"
*   Entry line looks like:

      Thread-1952463::`[`INFO::2011-09-18`](INFO::2011-09-18)` 05:01:01,867::dispatcher::109::Storage.Dispatcher.Protect::
      (run) Run and protect: getSpmStatus, args: ( spUUID=ffb469ec-d98b-4614-b3fc-c88f206d4 cfd)

*   The above means that thread number 1952463 started running the 'getSpmStatus' command for storage pool 'ffb469ec-d98b-4614-b3fc-c88f206d4cfd'
*   The entire synchronous part of the task will always log with the same thread number at the beginning of the line, so to follow the operation flow all you need to do is grep 'Thread-1952463::' and you'll get all log lines that pertain to the synchronous part of the call.
*   Task example:

      Thread-1952463::DEBUG::2011-09-18 05:01:01,868::task::611::TaskManager.Task::(_updateState)
      Task=8a107a91-ecb4-4e10-9fb3-a7b400ed2c44::moving from state init -> state preparing
      Thread-1952463::DEBUG::2011-09-18 05:01:01,868::spm::695::Storage.SPM::
      (public_getSpmStatus) spUUID=ffb469ec-d98b-4614-b3fc-c88f206d4cfd: spmStatus=SPM spmLver=0 
      spmId=1
      Thread-1952463::DEBUG::2011-09-18 05:01:01,868::task::1205::TaskManager.Task::(prepare) 
      Task=8a107a91-ecb4-4e10-9fb3-a7b400ed2c44::finished: 
      {'spm_st': {'spmId': 1, 'spmStatus ': 'SPM', 'spmLver': 0}}
      Thread-1952463::DEBUG::2011-09-18 05:01:01,869::task::611::TaskManager.Task::(_updateState)
      Task=8a107a91-ecb4-4e10-9fb3-a7b400ed2c44::moving from state preparing -> state finished
      Thread-1952463::DEBUG::2011-09-18 05:01:01,869::resourceManager::806::
      ResourceManager.Owner::(releaseAll) Owner.releaseAll requests {} resources {}
      Thread-1952463::DEBUG::2011-09-18 05:01:01,870::resourceManager::841::
      ResourceManager.Owner::(cancelAll) Owner.cancelAll requests {}
      Thread-1952463::DEBUG::2011-09-18 05:01:01,870::task::1003::TaskManager.Task::(_decref)
      Task=8a107a91-ecb4-4e10-9fb3-a7b400ed2c44::ref 0 aborting False
      Thread-1952463::`[`INFO::2011-09-18`](INFO::2011-09-18)` 05:01:01,870::dispatcher::115::
      Storage.Dispatcher.Protect::(run) Run and protect: getSpmStatus, Return response:
      {'status': {'message': 'OK', 'code': 0},
      'spm_st': {'spmId': 1, 'spmStatus': 'SPM', 'spmLver': 0}}

*   Note the last 'Run and protect' line which is only logged if the task finished without an exception.
*   The second 'Run and protect' line logs the return info sent back to caller (normally engine).
*   Return messages always have the status dictionary which states whether the command finished successfully or not and additional info if needed, in this case spm status.
*   A successful command will return with: 'status': {'message': 'OK', 'code': 0}

<!-- -->

*   In order to understand which (storage) commands were called you can just look for 'Run and protect' calls and go through them to understand the flow (again, all params passed and return values are logged).

### Async tasks

#### Async Tasks explained

*   Async tasks start out like any other verb as follows:

      Thread-50::`[`INFO::2011-06-23`](INFO::2011-06-23)` 13:04:29,774::dispatcher::94::Storage.Dispatcher.Protect::
      (run) Run and protect: spmStart, args:
      ( spUUID=a2cc366a-a7a3-4684-8f8a-e53bce1da025 prevID =-1 prevLVER=-1
      recoveryMode=-1 scsiFencing=False)

*   The return response of an async verb contains the task id ('uuid' variable):

      Thread-50::`[`INFO::2011-06-23`](INFO::2011-06-23)` 13:04:29,782::dispatcher::100::Storage.Dispatcher.Protect::
      (run) Run and protect: spmStart, Return response: 
      {'status': {'message': 'OK', 'code': 0}, 'uuid': 'bad26fcc-6e8b-4046-aab0-b4cbfb735aeb'}

*   In order to follow the progress of the async task all you need to do is look for the log lines which start with the task id:

      bad26fcc-6e8b-4046-aab0-b4cbfb735aeb::DEBUG::2011-06-23 13:04:29,783::task::904::
      TaskManager.Task::(_runJobs) Task.run: running job 0: spmStart: 
<bound method SPM.start of <storage.spm.SPM instance at 0x1c8eb00>`>`
      (args: ('a2cc366a-a7a3-4684-8f8a-e53bce1da025', -1, -1, -1,
      False, 250, None) kwargs: {})

*   A successfully finished task log will look like this:

      bad26fcc-6e8b-4046-aab0-b4cbfb735aeb::DEBUG::2011-06-23 13:04:32,855::task::912::
      TaskManager.Task::(_runJobs) Task.run: exit - success: result
      bad26fcc-6e8b-4046-aab0-b4cbfb735aeb::DEBUG::2011-06-23 13:04:32,856::task::492::
      TaskManager.Task::(_debug) Task bad26fcc-6e8b-4046-aab0-b4cbfb735aeb: ref 0 aborting False
      bad26fcc-6e8b-4046-aab0-b4cbfb735aeb::DEBUG::2011-06-23 13:04:32,857::threadPool::
      47::Misc.ThreadPool::(setRunningTask) Number of running tasks: 0

*   Engine also periodically calls getTaskStatus which looks like:

      Thread-66::`[`INFO::2011-06-23`](INFO::2011-06-23)` 13:04:33,848::dispatcher::94::Storage.Dispatcher.Protect::
      (run) Run and protect: getTaskStatus, args: ( taskID=bad26fcc-6e8b-4046-aab0-b4cbfb735aeb)
      Thread-66::DEBUG::2011-06-23 13:04:33,848::task::492::TaskManager.Task::(_debug) Task fc97d685-b677-4942-8df6-c0b6fcd33873: moving from state init -> state preparing
      Thread-66::DEBUG::2011-06-23 13:04:33,849::taskManager::82::TaskManager::(getTaskStatus) Entry. taskID: bad26fcc-6e8b-4046-aab0-b4cbfb735aeb
      Thread-66::DEBUG::2011-06-23 13:04:33,849::taskManager::85::TaskManager::(getTaskStatus) Return. Response: {'code': 0, 'message': '1 jobs completed successfuly', 'taskState': 'finished', 'taskResult': 'success', 'taskID': 'bad26fcc-6e8b-4046-aab0-b4cbfb735aeb'}
      ...
      Thread-66::`[`INFO::2011-06-23`](INFO::2011-06-23)` 13:04:33,851::dispatcher::100::Storage.Dispatcher.Protect::(run) Run and protect: getTaskStatus, Return response: {'status': {'message': 'OK', 'code': 0}, 'taskStatus': {'code': 0, 'message': '1 jobs completed successfuly', 'taskState': 'finished', 'taskResult': 'success', 'taskID': 'bad26fcc-6e8b-4046-aab0-b4cbfb735aeb'}}

*   As you can see in the first 'Run and protect' line the query was about task 'bad26fcc-6e8b-4046-aab0-b4cbfb735aeb'
*   The last line of the thread shows that the task is finished and that it completed successfully ('taskState': 'finished', 'taskResult': 'success')
*   When trying to follow a flow of an async task, the task id will appear in the rhevm logs and we can take it from there and search for the task in the vdsm log (grep all lines with it for example)

### External commands

*   Whenever vdsm executes an external command it does so via the execCmd method and logs the command and the return code and output:

      21a24db4-d553-437b-844b-30414bcc8f97::DEBUG::2011-06-23 13:11:12,125::blockSD::732::Storage.Misc.excCmd::(mountMaster) '/usr/bin/sudo -n /sbin/e2fsck -p /dev/52493f96-d716-409f- b696-8cb8d5b43527/master' (cwd None) 21a24db4-d553-437b-844b-30414bcc8f97::DEBUG::2011-06-23 13:11:12,195::blockSD::732::Storage.Misc.excCmd::(mountMaster) SUCCESS: `<err>` = ; `<rc>` = 0

*   As you can see above, the command completed successfully (SUCCESS) and then following is the stderr (<err> = ) and return code (<rc> = 0)
*   When a command fails it looks like this:

      21a24db4-d553-437b-844b-30414bcc8f97::DEBUG::2011-06-23 13:11:12,196::blockSD::757::Storage.Misc.excCmd::(mountMaster) '/usr/bin/sudo -n /sbin/tune2fs -j /dev/52493f96-d716-409f -b696-8cb8d5b43527/master' (cwd None) 21a24db4-d553-437b-844b-30414bcc8f97::DEBUG::2011-06-23 13:11:12,213::blockSD::757::Storage.Misc.excCmd::(mountMaster) FAILED: `<err>` = 'The filesystem already has a journal.\n';`<rc>` = 1

*   Note that the above line is VERY important when trying to debug issues many times \*before\* the traceback we can find a command that failed and explains why the flow failed. When posting an excerpt into bugzilla it is very important to check whether this happened and copy everything from this point down to the traceback.

### Correlating user flows

*   The next important step is to actually understand how user flows correlate to

the vdsm log.

#### Create template

*   Create template is a 'copyImage' command which is an async task so it will look like:

      Thread-1713::`[`INFO::2011-07-03`](INFO::2011-07-03)` 11:31:29,891::dispatcher::94::Storage.Dispatcher.Protect::(run) Run and protect: copyImage, args: ( sdUUID=eea4a640-a90a-4c7e-aa23-ae7420a5f9cb spUUID=e235e2c8-05cf-4868-b749-e0447fd0196e vmUUID=6580ecb9-5f3d-4f32-a420-ed6a1cd3a295 srcImgUUID=dbed3bfd-f247-4884-95e5-31a09bc561ca srcVolUUID=94bfb3b4-5060-462b-b85a-f8d2f1c77cd1 dstImgUUID=43299473-9a01-4905-bed4-489f1ba2c94b dstVolUUID=10645650-2231-46ee-bceb-618181d9ae7a description=DasdAS dstSdUUID=eea4a640-a90a-4c7e-aa23-ae7420a5f9cb volType=6 volFormat=4 preallocate=2 postZero=False force=False)
      ...
      Thread-1713::`[`INFO::2011-07-03`](INFO::2011-07-03)` 11:31:30,544::dispatcher::100::Storage.Dispatcher.Protect::(run) Run and protect: copyImage, Return response: {'status': {'message': 'OK', 'code': 0}, 'uuid': 'e62a8238-30bf-4f38-99e5-2da35769783b'}
      ...
      e62a8238-30bf-4f38-99e5-2da35769783b::DEBUG::2011-07-03 11:31:30,545::task::492::TaskManager.Task::(_debug) Task e62a8238-30bf-4f38-99e5-2da35769783b: _save: orig /rhev/data-center/e235e2c8-05cf-4868-b749-e0447fd0196e/tasks/e62a8238-30bf-4f38-99e5-2da35769783b temp /rhev/data-center/e235e2c8-05cf-4868-b749-e0447fd0196e/tasks/e62a8238-30bf-4f38-99e5-2da35769783b.temp

*   Following is the command that actually converts the VM disk into the new template disk (this will normally take a long time):

      e62a8238-30bf-4f38-99e5-2da35769783b::DEBUG::2011-07-03 11:31:34,110::volume::929::Storage.Misc.excCmd::(qemuConvert) '/bin/nice -n 19 /usr/bin/ionice -c 2 -n 7 /usr/bin/qemu-img convert -f qcow2 /rhev/data-center/e235e2c8-05cf-4868-b749-e0447fd0196e/eea4a640-a90a-4c7e-aa23-ae7420a5f9cb/images/dbed3bfd-f247-4884-95e5-31a09bc561ca/94bfb3b4-5060-462b-b85a-f8d2f1c77cd1 -O qcow2 /rhev/data-center/e235e2c8-05cf-4868-b749-e0447fd0196e/eea4a640-a90a-4c7e-aa23-ae7420a5f9cb/images/43299473-9a01-4905-bed4-489f1ba2c94b/10645650-2231-46ee-bceb-618181d9ae7a' (cwd None)
      e62a8238-30bf-4f38-99e5-2da35769783b::DEBUG::2011-07-03 11:31:34,124::task::492::TaskManager.Task::(_debug) Task e62a8238-30bf-4f38-99e5-2da35769783b: _save: orig /rhev/data-center/e235e2c8-05cf-4868-b749-e0447fd0196e/tasks/e62a8238-30bf-4f38-99e5-2da35769783b temp /rhev/data-center/e235e2c8-05cf-4868-b749-e0447fd0196e/tasks/e62a8238-30bf-4f38-99e5-2da35769783b.temp
      e62a8238-30bf-4f38-99e5-2da35769783b::DEBUG::2011-07-03 11:31:34,196::volume::929::Storage.Misc.excCmd::(qemuConvert) SUCCESS: `<err>` = []; `<rc>` = 0

#### Import / Export

*   Import / Export of a VM or template is actually a 'moveImage' command which is also an async task so again:

      Thread-785::`[`INFO::2011-06-12`](INFO::2011-06-12)` 11:32:40,202::dispatcher::94::Storage.Dispatcher.Protect::(run) Run and protect: moveImage, args: ( spUUID=5ccf59cb-4924-4e13-85d4-fe2b882a857d srcDomUUID=a0c2b674-456a-4eff-9717-915a4151a25c dstDomUUID=8cea8d77-f2ff-4ae6-8567-36e00afcd5ba imgUUID=197305c8-6e35-4e73-b316-f61bfc6c7800 vmUUID=d00a23e1-076e-4351-b4a0-d1c15e59dbd2 op=1 postZero=False force=False)
      ...
      Thread-785::`[`INFO::2011-06-12`](INFO::2011-06-12)` 11:32:41,091::dispatcher::100::Storage.Dispatcher.Protect::(run) Run and protect: moveImage, Return response: {'status': {'message': 'OK', 'code': 0}, 'uuid': 'ed948e15-7ff0-4598-a5af-0b96a8df547c'}
      ...
      ed948e15-7ff0-4598-a5af-0b96a8df547c::DEBUG::2011-06-12 11:32:41,092::task::492::TaskManager.Task::(_debug) Task ed948e15-7ff0-4598-a5af-0b96a8df547c: moving from state queued -> state running

*   The command that copies the disk is dd and if the disk has multiple volumes then there will be multiple consecutive dd commands

      ed948e15-7ff0-4598-a5af-0b96a8df547c::DEBUG::2011-06-12 11:32:44,220::image::538::Storage.Misc.excCmd::(move) '/usr/bin/ionice -c2 -n7 /bin/dd if=/rhev/data-center/5ccf59cb-4924 -4e13-85d4-fe2b882a857d/a0c2b674-456a-4eff-9717-915a4151a25c/images/197305c8-6e35-4e73-b316-f61bfc6c7800/07381c87-3ebe-48f7-a633-21e41564d578 of=/rhev/data-center/5ccf59cb-4924- 4e13-85d4-fe2b882a857d/8cea8d77-f2ff-4ae6-8567-36e00afcd5ba/images/197305c8-6e35-4e73-b316-f61bfc6c7800/07381c87-3ebe-48f7-a633-21e41564d578 bs=1048576 seek=0 skip=0 conv=notrun c count=1024 oflag=direct' (cwd None) 

