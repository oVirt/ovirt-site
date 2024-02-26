---
title: RPMs and GPG
authors: sandrobonazzola
---

# RPMs and GPG

## RPM Repositories
### oVirt 4.5
oVirt 4.5 is shipped via CentOS repositories.
If you are going to install on RHEL or derivatives please follow [Installing on RHEL or derivatives](/download/install_on_rhel.html) first.

In order to enable oVirt 4.5 repositories on CentOS Stream you need to execute:
```bash
dnf install -y centos-release-ovirt45
```

### Older releases of oVirt which reached End of Life and are no longer supported

-   [ovirt-4.4](https://resources.ovirt.org/pub/ovirt-4.4/)
-   [ovirt-4.3](https://resources.ovirt.org/pub/ovirt-4.3/)
-   [ovirt-4.2](https://resources.ovirt.org/pub/ovirt-4.2/)
-   [ovirt-4.1](https://resources.ovirt.org/pub/ovirt-4.1/)
-   [ovirt-4.0](https://resources.ovirt.org/pub/ovirt-4.0/)
-   [ovirt-3.6](https://resources.ovirt.org/pub/ovirt-3.6/)
-   [ovirt-3.5](https://resources.ovirt.org/pub/ovirt-3.5/)
-   [ovirt-3.4](https://resources.ovirt.org/pub/ovirt-3.4/)
-   [ovirt-3.3](https://resources.ovirt.org/pub/ovirt-3.3/)

## Mirrors for oVirt Downloads

**NOTE**: most of the oVirt 4.5 packages are shipped via CentOS Virtualization SIG mirrors.

Previous releases and packages which couldn't build within CentOS Community Build System are available on
[oVirt](https://resources.ovirt.org/pub/) repository and its [mirrors](/community/get-involved/repository-mirrors.html)


## GPG Keys used by oVirt

How does oVirt Project use GPG keys to sign packages?
Each stable RPM package that is published by oVirt Project is signed with a GPG signature.
By default, yum and the graphical update tools will verify these signatures and refuse to install any packages that are not signed or have bad signatures.
You should always verify the signature of a package before you install it.
These signatures ensure that the packages you install are what was produced by the oVirt Project and have not been altered (accidentally or maliciously)
by any mirror or website that is providing the packages. Nightly repositories won't be signed.

### Importing Keys Manually

For some repositories, such as repositories with stable in default configuration, yum is able to find a proper key for the repository and asks the user
for confirmation before importing the key if the key is not already imported into the rpm database.

To get the public key:

    $ gpg --recv-keys FE590CB7
    $ gpg --list-keys --with-fingerprint FE590CB7
    ---
    pub   2048R/FE590CB7 2014-03-30 [expires: 2028-04-06]
          Key fingerprint = 31A5 D783 7FAD 7CB2 86CD  3469 AB8C 4F9D FE59 0CB7
    uid                  oVirt <infra@ovirt.org>
    sub   2048R/004BC303 2014-03-30 [expires: 2028-04-06]
    ---
    $ gpg --export --armor FE590CB7 > ovirt-infra.pub
    # rpm --import ovirt-infra.pub

Importing keys Automatically for oVirt 4.4:

    dnf install https://resources.ovirt.org/pub/yum-repo/ovirt-release44.rpm

**Important:** yum will prompt sysadmin to acknowledge import of key, make sure key id is FE590CB7.

### Verifying a package

When using default configuration of yum package updating and installation tool in stable releases, signature of each package is verified before it is installed.
Signature verification can be turned off and on globally or for specific repository with gpgcheck directive.
Do not override the default setting of this directive unless you have a very good reason to do so.
If you do not use yum, you can check the signature of the package using the following command:

    rpm {-K|--checksig} PACKAGE_FILE ...

### Currently used keys


| Key ID     | Key Type     | Key Fingerprint                                     | Key Description | Created    | Expires    | Revoked | Notes |
|------------|--------------|-----------------------------------------------------|-----------------|------------|------------|---------|-------|
| `FE590CB7` | 2048-bit RSA | `31A5 D783 7FAD 7CB2 86CD 3469 AB8C 4F9D FE59 0CB7` | oVirt           | 2014-03-30 | 2028-04-06 |         |       |
|------------|--------------|-----------------------------------------------------|-----------------|------------|------------|---------|-------|
| `24901D0C` | 4096-bit RSA | `3C98 E81D B93D EA6D 54DE 690E 44E4 75CB 2490 1D0C` | oVirt           | 2022-11-02 | 2032-10-30 |         |       |
{: .bordered}
