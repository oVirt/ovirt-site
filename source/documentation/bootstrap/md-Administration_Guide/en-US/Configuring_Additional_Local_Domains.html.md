# Configuring Additional Local Domains

Creating additional local domains other than the default `internal` domain is also supported. This can be done using the `ovirt-engine-extension-aaa-jdbc` extension and allows you to create multiple domains without attaching external directory servers, though the use case may not be common for enterprise environments.

Additionally created local domains will not get upgraded autonmatically during standard Red Hat Virtualization upgrades and need to be upgraded manually for each future release. For more information on creating additional local domains and how to upgrade the domains, see the README file at `/usr/share/doc/ovirt-engine-extension-aaa-jdbc-version/README.admin`.
