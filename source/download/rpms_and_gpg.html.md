# RPMs and GPG

## RPM Repositories for oVirt

-   **[ovirt-4.3 - Latest stable release](https://resources.ovirt.org/pub/ovirt-4.3/)**

### Older unsupported version releases of oVirt

-   [ovirt-4.2](https://resources.ovirt.org/pub/ovirt-4.2/)
-   [ovirt-4.1](https://resources.ovirt.org/pub/ovirt-4.1/)
-   [ovirt-4.0](https://resources.ovirt.org/pub/ovirt-4.0/)
-   [ovirt-3.6](https://resources.ovirt.org/pub/ovirt-3.6/)
-   [ovirt-3.5](https://resources.ovirt.org/pub/ovirt-3.5/)
-   [ovirt-3.4](https://resources.ovirt.org/pub/ovirt-3.4/)
-   [ovirt-3.3](https://resources.ovirt.org/pub/ovirt-3.3/)

### Nightly builds of oVirt

-   [ovirt-4.4 Nightly](https://resources.ovirt.org/pub/ovirt-master-snapshot)
-   [ovirt-4.3 Nightly](https://resources.ovirt.org/pub/ovirt-4.3-snapshot)

## Mirrors for oVirt Downloads

### Europe

- [NLUUG](https://ftp.nluug.nl/os/Linux/virtual/ovirt/) (
[oVirt 4.3](https://ftp.nluug.nl/os/Linux/virtual/ovirt/ovirt-4.3/)
[oVirt 4.2](https://ftp.nluug.nl/os/Linux/virtual/ovirt/ovirt-4.2/)
[oVirt 4.1](https://ftp.nluug.nl/os/Linux/virtual/ovirt/ovirt-4.1/)
[oVirt 4.0](https://ftp.nluug.nl/os/Linux/virtual/ovirt/ovirt-4.0/)
[oVirt 4.4 Development Nightly](http://ftp.nluug.nl/os/Linux/virtual/ovirt/ovirt-master-snapshot/))
- [Plus.line AG](http://www.plusline.net/en/) (
[oVirt 4.3](http://ftp.plusline.net/ovirt/ovirt-4.3/)
[oVirt 4.2](http://ftp.plusline.net/ovirt/ovirt-4.2/)
[oVirt 4.1](http://ftp.plusline.net/ovirt/ovirt-4.1/)
[oVirt 4.0](http://ftp.plusline.net/ovirt/ovirt-4.0/)
[oVirt 4.4 Development Nightly](http://ftp.plusline.net/ovirt/ovirt-master-snapshot/))
- [SNT - University of Twente](http://ftp.snt.utwente.nl/pub/software/ovirt/) (
[oVirt 4.3](http://ftp.snt.utwente.nl/pub/software/ovirt/ovirt-4.3/)
[oVirt 4.2](http://ftp.snt.utwente.nl/pub/software/ovirt/ovirt-4.2/)
[oVirt 4.1](http://ftp.snt.utwente.nl/pub/software/ovirt/ovirt-4.1/)
[oVirt 4.0](http://ftp.snt.utwente.nl/pub/software/ovirt/ovirt-4.0/)
[oVirt 4.4 Development Nightly](http://ftp.snt.utwente.nl/pub/software/ovirt/ovirt-master-snapshot/))

### North America

- [Duke University](http://archive.linux.duke.edu/ovirt/) (
[oVirt 4.3](http://archive.linux.duke.edu/ovirt/pub/ovirt-4.3/)
[oVirt 4.2](http://archive.linux.duke.edu/ovirt/pub/ovirt-4.2/)
[oVirt 4.1](http://archive.linux.duke.edu/ovirt/pub/ovirt-4.1/)
[oVirt 4.0](http://archive.linux.duke.edu/ovirt/pub/ovirt-4.0/)
[oVirt 4.4 Development Nightly](http://archive.linux.duke.edu/ovirt/pub/ovirt-master-snapshot/))
- [Georgia Institute of Technology](http://www.gtlib.gatech.edu/pub/oVirt) (
[oVirt 4.3](http://www.gtlib.gatech.edu/pub/oVirt/pub/ovirt-4.3/)
[oVirt 4.2](http://www.gtlib.gatech.edu/pub/oVirt/pub/ovirt-4.2/)
[oVirt 4.1](http://www.gtlib.gatech.edu/pub/oVirt/pub/ovirt-4.1/)
[oVirt 4.0](http://www.gtlib.gatech.edu/pub/oVirt/pub/ovirt-4.0/)
[oVirt 4.4 Development Nightly](http://www.gtlib.gatech.edu/pub/oVirt/pub/ovirt-master-snapshot/)
[FTP Site](ftp://ftp.gtlib.gatech.edu/pub/oVirt))
- [ibiblio](http://mirrors.ibiblio.org/ovirt/) (
[oVirt 4.3](http://mirrors.ibiblio.org/ovirt/pub/ovirt-4.3/)
[oVirt 4.2](http://mirrors.ibiblio.org/ovirt/pub/ovirt-4.2/)
[oVirt 4.1](http://mirrors.ibiblio.org/ovirt/pub/ovirt-4.1/)
[oVirt 4.0](http://mirrors.ibiblio.org/ovirt/pub/ovirt-4.0/)
[oVirt 4.4 Development Nightly](http://mirrors.ibiblio.org/ovirt/pub/ovirt-master-snapshot/))

### Asia

- [Hamakor](http://mirror.isoc.org.il/pub/ovirt/) (
[ovirt 4.3](http://mirror.isoc.org.il/pub/ovirt/ovirt-4.3/)
[ovirt 4.2](http://mirror.isoc.org.il/pub/ovirt/ovirt-4.2/)
[ovirt 4.1](http://mirror.isoc.org.il/pub/ovirt/ovirt-4.1/)
[ovirt 4.0](http://mirror.isoc.org.il/pub/ovirt/ovirt-4.0/)
[oVirt 4.4 Development Nightly](http://mirror.isoc.org.il/pub/ovirt/ovirt-master-snapshot/))

## GPG Keys used by oVirt

**Important:** We are going to sign RPMs only from next release. Please wait for the announcement email

How does oVirt Project use GPG keys to sign packages? Each stable RPM package that is published by oVirt Project is signed with a GPG signature. By default, yum and the graphical update tools will verify these signatures and refuse to install any packages that are not signed or have bad signatures. You should always verify the signature of a package before you install it. These signatures ensure that the packages you install are what was produced by the oVirt Project and have not been altered (accidentally or maliciously) by any mirror or website that is providing the packages. Nightly repositories wont be signed.

### Importing Keys Manually

For some repositories, such as repositories with stable in default configuration, yum is able to find a proper key for the repository and asks the user for confirmation before importing the key if the key is not already imported into the rpm database.

To get the public key:

    $ gpg --recv-keys FE590CB7
    $ gpg --list-keys --with-fingerprint FE590CB7
    ---
    pub   2048R/FE590CB7 2014-03-30 [expires: 2021-04-03]
          Key fingerprint = 31A5 D783 7FAD 7CB2 86CD  3469 AB8C 4F9D FE59 0CB7
    uid                  oVirt <infra@ovirt.org>
    sub   2048R/004BC303 2014-03-30 [expires: 2021-04-03]
    ---
    $ gpg --export --armor FE590CB7 > ovirt-infra.pub
    # rpm --import ovirt-infra.pub

Importing keys Automatically

    yum install https://resources.ovirt.org/pub/yum-repo/ovirt-release43.rpm

**Important:** yum will prompt sysadmin to acknowledge import of key, make sure key id is FE590CB7.

### Verifying a package

When using default configuration of yum package updating and installation tool in stable releases, signature of each package is verified before it is installed. Signature verification can be turned off and on globally or for specific repository with gpgcheck directive. Do not override the default setting of this directive unless you have a very good reason to do so. If you do not use yum, you can check the signature of the package using the following command

    rpm {-K|--checksig} PACKAGE_FILE ...

### Currently used keys

| Key ID     | Key Type     | Key Fingerprint                                     | Key Description | Created    | Expires    | Revoked | Notes |
|------------|--------------|-----------------------------------------------------|-----------------|------------|------------|---------|-------|
| `FE590CB7` | 2048-bit RSA | `31A5 D783 7FAD 7CB2 86CD 3469 AB8C 4F9D FE59 0CB7` | oVirt           | 2014-03-30 | 2021-04-03 |         |       |
