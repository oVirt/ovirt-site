---
title: Vdsm Developers
category: vdsm
authors: abonas, adahms, amuller, amureini, apahim, apevec, danken, dougsland, ekohl,
  fromani, herrold, itzikb, lhornyak, mbetak, mlipchuk, moolit, moti, mpavlik, nsoffer,
  phoracek, quaid, sandrobonazzola, sgordon, smelamud, vered, vfeenstr, vitordelima,
  yanivbronhaim, ybronhei
---

# Vdsm Developers

## Installing the required repositories

To build VDSM, enable the oVirt repositories by installing the ovirt-release rpm:

      yum install http://resources.ovirt.org/pub/yum-repo/ovirt-release-master.rpm
      
      
 or if you are using Fedora 
 
 
      dnf install http://resources.ovirt.org/pub/yum-repo/ovirt-release-master.rpm
       
If you need a previous installation, use the corresponding repository instead:

      yum install http://resources.ovirt.org/pub/yum-repo/ovirt-release40.rpm 
      yum install http://resources.ovirt.org/pub/yum-repo/ovirt-release36.rpm 
      yum install http://resources.ovirt.org/pub/yum-repo/ovirt-release35.rpm
      
 for Fedora 
    
     dnf install http://resources.ovirt.org/pub/yum-repo/ovirt-release40.rpm 
     dnf install http://resources.ovirt.org/pub/yum-repo/ovirt-release36.rpm 
     dnf install http://resources.ovirt.org/pub/yum-repo/ovirt-release35.rpm

This adds all the required repositories for you, including:

*   EPEL repositories for Red Hat Enterprise Linux, CentOS or similar distributions
*   GlusterFS repositories
*   Fedora Virtualization Preview repositories for Fedora or similar distributions
*   All required GPG keys.

VDSM requires Python 2 as your /usr/bin/python.

## Getting the source

Our public git repository is located at: [oVirt.org](http://gerrit.ovirt.org/gitweb?p=vdsm.git)

You can clone this repository by running the following command:

      git clone "https://gerrit.ovirt.org/vdsm"

## Installing the required packages

      yum install `cat automation/check-patch.packages.el7`

or if you are using Fedora (use .fc28 for Fedora 28):

      dnf install `cat automation/check-patch.packages.fc28`

On any platform, you should also setup VDSM virtual environment.
Follow the setup steps in [README.md](https://github.com/oVirt/vdsm#development-environment-setup)

Once you activate the virtual environment the required development tools
during the build and testing will be available (e.g. tox), keeping your system
clean.

If pip is not available in your distribution, you can install it using
easy_install:

    easy_install pip

## Configuring the source

VDSM uses autoconf and automake as its build system.

To configure a development build environment:

      ./autogen.sh --system --enable-timestamp

To see available options:

     ./configure --help

## Setup virtual environment

Follow the development environment setup in [README.md](https://github.com/oVirt/vdsm#development-environment-setup)

Make sure to activate the virtual environment before running any tests

## Testing

Execute make to compile VDSM first:

      # make

Storage tests require additional setup of fake devices (replace 'setup' with 'teardown' for cleanup):

      # python ./tests/storage/userstorage.py setup

Running the tests except slow and stress tests:

      make check

Running all tests, including slow and stress tests:

      make check-all

This is very slow and consumes lot of resources; running hundreds of
threads and child processes.

To exclude a specific test (test_foo):

      make check NOSE_EXCLUDE=test_foo

Running code style and quality checks:

     make flake8

Running code style and quality checks for specific files:

    .tox/flake8/bin/flake8 /path/to/module.py

The command above works only after running make flake8 in the first
time. You may want to install flake8 on your system for convenience.

### Testing specific modules

Running all the tests is too slow during development. It is recommended
to run the relevant module tests while making changes, and run the
entire test suite before submitting a patch.

Legacy tests use `nose`, newer tests use `pytest`.
Following sub-sections provide a quick reference how to run either `nose` or `pytest` based tests.
Please see `tests/README` for more details about the VDSM tests and how to run them.

#### Running specific nose tests

Please note that `run_test*` scripts are legacy and can be removed in the future.
Preffered way how to run tests is using `tox`.

To run specific tests:

    cd tests
    ./run_tests_local.sh foo_test.py bar_test.py

To enable slow and stress tests:

    ./run_tests_local.sh --enable-slow-tests --enable-stress-tests foo_test.py bar_test.py

To run using different python executable:

    PYTHON_EXE=python3 ./run_tests_local.sh foo_test.py bar_test.py

#### Running specific pytest tests

To run specific module with `tox`:

    tox -e storage-py27,storage-py36

To run specific test direcly via `pytest`:

    cd tests
    export PYTHONPATH=../lib/
    pytest storage/blocksd_test.py


## Building a VDSM RPM

To create an RPM:

      make rpm

VDSM automatically builds using the latest tagged version. If you want to explicitly define a version, use:

      make rpmversion=4.9 rpmrelease=999.funkyBranch

## Building with hooks support

      ./autogen.sh --system  --enable-hooks && make rpm

## Basic installation

The easiest way is to start with vdsm from ovirt-release repos. If you
added a host to engine, your host already installed. If you want to
install vdsm on a new host not added to engine, install vdsm and
vdsm-client:

    dnf install vdsm vdsm-client

To install packages built using "make rpm" use dnf upgrade:

    cd ~/rpmbuild/RPMS
    dnf upgrade */*.rpm

Before starting vdsmd service for the first time vdsm requires some configuration procedures for external services that being used by vdsmd. To ease this process vdsm provides a utility (vdsm-tool). To perform full reconfiguration of external services perform:

      # vdsm-tool configure --force
      (for more information read "vdsm-tool --help") 

Finally start the vdsmd service:

      # service vdsmd start


## Code Style

See [Vdsm Coding Guidelines](/develop/developer-guide/vdsm/coding-guidelines.html).

## Sending patches

Send them to [our gerrit server](http://gerrit.ovirt.org) ([see how](/develop/dev-process/working-with-gerrit.html)). With your first major patch, do not forget to add yourself to the AUTHORS file. Do not be shy - it gives you well-deserved recognition, and it shows to the team that you stand behind your code.

Please be verbose in your commit message. Explain the motivation for your patch, and the reasoning behind it. This information assists the reviewers of your code, before and after it is submitted to the master branch.

The commit message should follow the guidelines in the DISCUSSION section of <http://kernel.org/pub/software/scm/git/docs/git-commit.html> : short subject line, empty line, verbose paragraphs.

General development discussions are in [vdsm-devel@lists.fedorahosted.org](https://lists.fedorahosted.org/mailman/listinfo/vdsm-devel).

### Reviewer Comments

Sending a patch in the open-source world can be difficult. You code, your "baby", is scrutinized by people you do not know, who tend to find problems in it. The reviewer should comment on what's good in your patch, and what is to be improved, and rate your change accordingly.

| Score | What it means                                                                         |
|-------|---------------------------------------------------------------------------------------|
| +2    | Changed approved. If it breaks and the author is gone, I'll debug it.                 |
| +1    | Looks good to me, I'm fine with the change going in as it is.                         |
| 0     | I did not review the patch, or otherwise do no have a solid opinion about it.         |
| -1    | The change should not be merged as it is. A little (or more) work is required.        |
| -2    | The change should not go in at all. It is badly designed or solves the wrong problem. |

One you tick the "Verified" checkbox, remember explaining how exactly you performed the verification. If it was a simple \`make check\` or \`make rpm\` – say so.

## Creating a local yum repository to test changes to VDSM

1) First, you must generate the rpm with your changes from the vdsm source directory:

      #vdsm> ./autogen.sh --system
      #vdsm> make
      #vdsm> make rpm

**Note**: all rpm files will be generated at rpmbuild dir, usually: /home/your-user/rpmbuild/RPMS

2) Setting environment:

*   Install required package

      # yum install createrepo -y

*   Enable httpd service (if it's not installed, install it first with yum install httpd)

      # chkconfig httpd on

or

      # ln -s '/lib/systemd/system/httpd.service' '/etc/systemd/system/multi-user.target.wants/httpd.service'

*   Create the directory that will hold the rpm files (repo)

      # mkdir /var/www/html/my-vdsm-changes

*   Copy the vdsm packages to repo

      # cp ${HOME}/rpmbuild/RPMS/noarch/* /var/www/html/my-vdsm-changes
      # cp ${HOME}/rpmbuild/RPMS/x86_64/* /var/www/html/my-vdsm-changes

*   Create the repo inside the yum.repos.d

      # vi /etc/yum.repos.d/my-vdsm-changes.repo
      [my-vdsm-changes]
      name = my vdsm changes
      baseurl = http://127.0.0.1/my-vdsm-changes
      enabled = 1
      gpgcheck = 0

*   Execute createrepo tool

      # createrepo /var/www/html/my-vdsm-changes

*   Start httpd service

      # service httpd start

*   List all repos and see your new repo

      # yum repolist

**Note**: SELinux might throw permission denied to repo located at /var/www/html/

## Using a virtual machine console

If you want to use the console for a virtual machine using the Spice protocol (VNC is not supported right now), run the following command on the host running ovirt-engine:

    # psql -U postgres engine -c "update vdc_options set option_value = 'false' 
    where option_name = 'UseSecureConnectionWithServers';"

## Fake KVM Support

As developer you might need to add many hosts into your environment for tests. VDSM provides a functionality called 'fake_kvm_support' for **VDSM quality assurance/developers** emulate a real host/kvm hardware without running real guests.

*   1) Create a guest as Fedora 17 (Tested on Fedora 17 but should work in higher versions as well)

<!-- -->

*   2) Install required packages

      # yum install vdsm-hook-faqemu -y 

*   3) Change vdsm config file to enable this feature

      # vi /etc/vdsm/vdsm.conf 
       [vars]

       fake_kvm_support = true  

*   4) Restart the vdsmd daemon (**Only required if you had previously VDSM installed**)

      # systemctl restart vdsmd.service 

*   5) Open the oVirt Engine portal and add the new 'Fake' Host

       Login with your admin user -> Hosts -> New 

*   6) The host should be UP

### Troubleshooting Fake KVM Support

**Problems adding the fake Host in the engine**

The vdsm bootstrapper was deprecated and replaced by ovirt-host-deploy, the /usr/share/doc/ovirt-host-deploy-1.1.0/README, file includes details about how to configure a fake host.

See see [ovirt-host-deploy/README](http://gerrit.ovirt.org/gitweb?p=ovirt-host-deploy.git;a=blob;f=README;hb=HEAD) for fake qemu support.

**Failed: Server does not support virtualization**

If during the installation of the host you received the message "Server does not support virtualization" from oVirt Engine, it's probably because your vdsm version doesn't include the patch: <http://gerrit.ovirt.org/#/c/5611/3> (might be a bug as well).
 This patch add the 'fake kvm' support to vds_bootstrap.

There are several ways to update your vds_bootstrap, for example:

*   Yum update in **oVirt Engine** machine (if the repo is not updated, use the others approaches)

       # yum update vdsm-bootstrap 

*   Clone vdsm tree and create an updated vdsm-bootstrap rpm and update the **oVirt Engine** system

        # git clone "https://gerrit.ovirt.org/vdsm"
        # cd vdsm
        (if required increase the Version/Release from vdsm.spec.in)
        # ./autogen.sh --system && make && make rpm
        # rpm -Uvh ~/rpmbuild/RPMS/noarch/vdsm-bootstrap* 

*   Clone the vdsm tree, execute autogen/make and copy the vds_bootstrap/vds_bootstrap.py to /usr/share/vds_bootstrap

        # git clone "https://gerrit.ovirt.org/vdsm"
        # cd vdsm
        # ./autogen.sh --system && make
        # cp vds_bootstrap/vds_bootstrap.py /usr/share/vds_bootstrap 
                 

*   Manually backport the above <http://gerrit.ovirt.org/5611> patch to your current vds_bootstrap (/usr/share/vds_bootstrap)

        # vi /usr/share/vds_bootstrap/vds_bootstrap.py
        Make the changes manually

**Non Responsive status**

*   Check if vdsm and libvirt daemons are running
*   Firewall?

'''Default networks, the following networks are missing on host 'ovirtmgmt' '''

Something goes wrong setting the bridge ovirtmgmt, check the logs (/tmp/vds\*.log) in the host side.
If required, use the manual process to create the bridge and re-add the host: [Installing VDSM from rpm#Configuring the bridge Interface](/develop/developer-guide/vdsm/installing-vdsm-from-rpm.html#configuring-the-bridge-interface)

## Running Node as guest - Nested KVM

Following the below instructions you can use oVirt Node, Fedora Node and oVirt Engine as guests.

Requires: Processors with **Full Virtualization** embedded

Attention: The below steps were tested on Fedora 17 but should work in higher versions (maybe not even required in the future releases, hopefully virt-manager will handle that directly in the next versions)

"Nested VMX" feature adds this missing capability - of running guest hypervisors (which use VMX) with their own nested guests. It does so by allowing a guest to use VMX instructions, and correctly
 and efficiently emulating them using the single level of VMX available in the hardware.

Finally, we are assuming you already have qemu-kvm/libvirt/virt-manager installed in your system

### Intel

*   1) Check if nested KVM is enabled (should be **Y**)

       # cat /sys/module/kvm_intel/parameters/nested
        N

*   2) In that case, it's disabled, to enable (can be via modprobe conf as well, simply: echo "options kvm-intel nested=1" > /etc/modprobe.d/kvm-intel.conf ):

       # vi /etc/default/grub

Add to the end of line **GRUB_CMDLINE_LINUX kvm-intel.nested=1**

Example:

       GRUB_CMDLINE_LINUX="rd.md=0 rd.dm=0  KEYTABLE=us SYSFONT=True rd.lvm.lv=vg/lv_root rd.luks=0 rd.lvm.lv=vg/lv_swap LANG=en_US.UTF-8 rhgb quiet kvm-intel.nested=1"

*   3) Save the changes:

       # grub2-mkconfig -o /boot/grub2/grub.cfg

*   4) Reboot the system:

       # reboot

*   5) Install hook for nested virtualization on hypervisor/hypervisors. This will configure both the host and guest for nested KVM. With the nestedvt vdsm hook installed, every guest launched from your nested-enabled hosts will inherit its own KVM-hosting capability. [More details](http://community.redhat.com/blog/2013/08/testing-ovirt-3-3-with-nested-kvm):

       # yum install -y vdsm-hook-nestedvt 

*   6) Restart vdsmd on hypervisor

       # service vdsmd restart 

After vdsm restarts, you can check to see that your hooks are installed in your host’s “Host Hooks” tab: ![](/images/wiki/Nestedvt_hook.png)

### AMD

Works out of the box.

*   1) To check if nested KVM is enabled (should be **1**)

       # cat /sys/module/kvm_amd/parameters/nested
        1

*   2) Install oVirt Node as guest with virt-manager (or any other distro).

<!-- -->

*   3) After virtual machine starts, check in the guest that svm flag in the /proc/cpuinfo.

       # grep -m1 svm /proc/cpuinfo
        flags           : fpu de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 syscall nx lm up nopl pni cx16 popcnt hypervisor lahf_lm svm abm sse4a

More info about nested-kvm: <https://github.com/torvalds/linux/blob/master/Documentation/virt/kvm/nested-vmx.rst>

## Building new releases for Fedora or EPEL with fedpkg

In the following example we will build vdsm-4.13.0 using patches for ovirt-3.3.2

1) Clone vdsm package from Fedora git

        $ mkdir ~/vdsm-fedora && cd ~/vdsm-fedora
        $ fedpkg clone vdsm && cd vdsm

Switch the stable branches (at moment f21 is **rawhide**, not stable) and check the last patch added to the build from changelog:

        $ fedpkg switch-branch f20
        $ vi vdsm.spec
        
        Example:
        * Tue Nov 12 2013 Douglas Schilling Landgraf `<xxx@xxx>` - 4.13.0-11
        - update from branch ovirt-3.3 which include:
          upgrade-fix-v3ResetMetaVolSize-argument
          lvm-Do-not-use-udev-cache-for-obtaining-device-list
          Fix-ballooning-rules-for-computing-the-minimum-avail
         Avoid-M2Crypto-races
         spec-declare-we-provide-an-existing-python-cpopen
         configuring-selinux-allowing-qemu-kvm-to-generate-co
`  `<snip>

So, the last patch added to the build 3.3.1 was **configuring-selinux-allowing-qemu-kvm-to-generate-co**, based on that you can use **git format-patch** to generate the patches to be included into next build

2) Clone the vdsm tree:

        $ mkdir ~/vdsm-upstream && cd ~/vdsm-upstream
`  $ git clone `[`git://gerrit.ovirt.org/vdsm`](git://gerrit.ovirt.org/vdsm)

3) Go to branch that hold the patches for 3.3.2, in this case **ovirt-3.3**

        $ git checkout remotes/origin/ovirt-3.3 -b 3.3.2
        Branch 3.3.2 set up to track remote branch ovirt-3.3 from origin.
        Switched to a new branch '3.3.2'

3) Select the patches that you want to add to the build using **format-patch**

        Examples:
        * Last 3 patches:
`    $ git format-patch `**`-3`**
          0001-fuserTests-fix-for-f20-and-arch.patch
          0002-Adding-debian-folder-makefile.patch
          0003-Fix-Makefile.am-in-debian-folder.patch

        * Specifying the commit:
          $ git format-patch `**<commit id>**` -1
          0001-fuserTests-fix-for-f20-and-arch.patch

In our case, the last patch is **configuring-selinux-allowing-qemu-kvm-to-generate-co**

        $ git format-patch -19
        0001-Invalidate-filters-on-HSMs-before-rescanning-extende.patch
        0002-vm-refresh-raw-disk-before-live-extension.patch
        0003-Renaming-etc-sysctl.d-vdsm-to-etc-sysctl.d-vdsm.conf.patch
`  `<snip>

Again, why -19 ? Because we are 19 patches behind from version **3.3.1** You can use **git log** to check how many patches we do have after **configuring-selinux-allowing-qemu-kvm-to-generate-co**

Copy the 19 patches to the ~/vdsm-fedora dir

         $ cp *.patch ~/vdsm-fedora/vdsm

4) Build new vdsm with the new patches

         $ cd ~/vdsm-fedora/vdsm/
         $ vi vdsm.spec

Example:

`  `<snip>
`  Url:            `[`/wiki/Vdsm`](/wiki/Vdsm)
        # The source for this package was pulled from upstream's vcs.
        # Use the following commands to generate the tarball:
`  #  git clone `[`http://gerrit.ovirt.org/p/vdsm`](http://gerrit.ovirt.org/p/vdsm)
        #  cd vdsm
        #  git reset --hard {vdsm_release}
        #  ./autogen.sh --system
        #  make VERSION={version}-{vdsm_release} dist
        Source0:        %{vdsm_name}-%{version}%{?vdsm_relttag}.tar.gz
        # ovirt-3.3.2 patches
        Patch0:         0001-Invalidate-filters-on-HSMs-before-rescanning-extende.patch
        Patch1:         0002-vm-refresh-raw-disk-before-live-extension.patch
        Patch2:         0003-Renaming-etc-sysctl.d-vdsm-to-etc-sysctl.d-vdsm.conf.patch
        ...
        Patch18:       0019-Fix-Makefile.am-in-debian-folder.patch
`  `</snip>

.... continue until the last patch then add the patch macro in the spec for **all patches**

` `<snip>
       %description gluster
       Gluster plugin enables VDSM to serve Gluster functionalities.
       %endif
       %prep
       %setup -q
       # ovirt-3.3.2 patches
       %patch0 -p1
       %patch1 -p1
       %patch2 -p1
       ...
       %patch23 -p1
` `</snip>

**PLEASE NOTE**: if changes/patches are being added to the upstream spec file you MUST manually update the FEDORA spec as well. You can manually verify the patches or use grep -i "vdsm.spec" in the patch generated.

Time to increase the **Release** in the spec and **changelog**

` `<snip>
       Release:        `**`12`**`%{?dist}%{?extra_release}
` `</snip>

       %changelog
       * Thu Nov 28 2013 PERSON_NAME `<xxx@xxx.com>` - 4.13.0-12
       - lvm: Do not use udev cache for obtaining device list (BZ#1014942)
       - Fix ballooning rules for computing the minimum available memory (BZ#1025845)
       ....
       - Fix Makefile.am in debian folder

Ok, build the new spec locally for initial test:

       $ fedpkg local  (or fedpkg srpm)

Hopefully it worked, now let's make a test build in Koji systems:

` $ fedpkg --dist f19 scratch-build --srpm ~/rpmbuild/SRPM/`<vdsm-package.srpm>
` $ fedpkg --dist f20 scratch-build --srpm ~/rpmbuild/SRPM/`<vdsm-package.srpm>
` $ fedpkg --dist el6 scratch-build --srpm ~/rpmbuild/SRPM/`<vdsm-package.srpm>

If it worked correctly, you can use fedpkg import ~/rpmbuild/SRPM/<vdsm-package.srpm> in each branch or use import into master and then git merge in the branches

**PLEASE NOTE**: If it's a beta release, please only import to **master** branch which is rawhide.

       $ fedpkg switch-branch f19
       $ fedpkg import  ~/rpmbuild/SRPM/`<vdsm-package.srpm>`  (you can import f20 build into f19 for example, it will be build again anyway)
       $ fedpkg commit -p
       $ fedpkg build
       $ fepkg update

Which fedpkg build will generate a koji url that will provide the RPMs and can be shared to release engineers/testers.

## ovirt-vmconsole sources

VDSM for ovirt-3.6 depends on ovirt-vmconsole package. To fetch the sources of ovirt-vmconsole, run

      git clone http://gerrit.ovirt.org/p/ovirt-vmconsole.git

## Troubleshooting

### Missing dependencies on EL

Since c0729453573, vdsm requires newer libvirt and selinux-policy packages, which are not available yet in RHEL or Centos repositories, and is not kept in ovirt repositories (such as ovirt-nightly).

### autogen.sh fails with "package version not defined"

You have no tags in your repo. If you want to push your repo from another machine, you must also push the tags:

      git push --tags remote 

## Code Documentation

We have a partial code walk through of the [virt subsystem](/develop/developer-guide/vdsm/vm-startup.html) (virtual machine life cycle, creation, migration) (more to come...)

## Performance and scalability

To analyse the performance and the scalability of the VDSM, you first need to [set up the tools](/develop/developer-guide/vdsm/profiling-vdsm.html). Then you may want to [run common scenarios](/develop/developer-guide/vdsm/benchmarks.html), or write your own using a [template](/develop/developer-guide/vdsm/benchmarks.html), to make sure the results are easily shareable.

