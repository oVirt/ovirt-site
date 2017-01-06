# Syntax for the ovirt-log-collector Command

The basic syntax for the log collector command is:

    ovirt-log-collector [options] list [all, clusters, datacenters]
    ovirt-log-collector [options] collect

The two supported modes of operation are `list` and `collect`.

* The `list` parameter lists either the hosts, clusters, or data centers attached to the Red Hat Virtualization Manager. You are able to filter the log collection based on the listed objects.

* The `collect` parameter performs log collection from the Red Hat Virtualization Manager. The collected logs are placed in an archive file under the `/tmp/logcollector` directory. The `ovirt-log-collector` command assigns each log a specific file name.

Unless another parameter is specified, the default action is to list the available hosts together with the data center and cluster to which they belong. You will be prompted to enter user names and passwords to retrieve certain logs.

There are numerous parameters to further refine the `ovirt-log-collector` command.

**General options**

`--version`
: Displays the version number of the command in use and returns to prompt.

`-h`, `--help`
: Displays command usage information and returns to prompt.

`--conf-file=PATH`
: Sets `PATH` as the configuration file the tool is to use.

`--local-tmp=PATH`
: Sets `PATH` as the directory in which logs are saved. The default directory is `/tmp/logcollector`.

`--ticket-number=TICKET`
: Sets `TICKET` as the ticket, or case number, to associate with the SOS report.

`--upload=FTP_SERVER`
: Sets `FTP_SERVER` as the destination for retrieved logs to be sent using FTP. Do not use this option unless advised to by a Red Hat support representative.

`--log-file=PATH`
: Sets `PATH` as the specific file name the command should use for the log output.

`--quiet`
: Sets quiet mode, reducing console output to a minimum. Quiet mode is off by default.

`-v`, `--verbose`
: Sets verbose mode, providing more console output. Verbose mode is off by default.

**Red Hat Virtualization Manager Options**

These options filter the log collection and specify authentication details for the Red Hat Virtualization Manager.

These parameters can be combined for specific commands. For example, `ovirt-log-collector --user=admin@internal --cluster ClusterA,ClusterB --hosts "SalesHost"*` specifies the user as `admin@internal` and limits the log collection to only `SalesHost` hosts in clusters `A` and `B`.

`--no-hypervisors`
: Omits virtualization hosts from the log collection.

`-u USER`, `--user=USER`
: Sets the user name for login. The `USER` is specified in the format `user@domain`, where `user` is the user name and `domain` is the directory services domain in use. The user must exist in directory services and be known to the Red Hat Virtualization Manager.

`-r FQDN`, `--rhevm=FQDN`
: Sets the fully qualified domain name of the Red Hat Virtualization Manager server from which to collect logs, where `FQDN` is replaced by the fully qualified domain name of the Manager. It is assumed that the log collector is being run on the same local host as the Red Hat Virtualization Manager; the default value is `localhost`.

`-c CLUSTER`, `--cluster=CLUSTER`
: Collects logs from the virtualization hosts in the nominated `CLUSTER` in addition to logs from the Red Hat Virtualization Manager. The cluster(s) for inclusion must be specified in a comma-separated list of cluster names or match patterns.

`-d DATACENTER`, `--data-center=DATACENTER`
: Collects logs from the virtualization hosts in the nominated `DATACENTER` in addition to logs from the Red Hat Virtualization Manager. The data center(s) for inclusion must be specified in a comma-separated list of data center names or match patterns.

`-H HOSTS_LIST`, `--hosts=HOSTS_LIST`
: Collects logs from the virtualization hosts in the nominated `HOSTS_LIST` in addition to logs from the Red Hat Virtualization Manager. The hosts for inclusion must be specified in a comma-separated list of host names, fully qualified domain names, or IP addresses. Match patterns are also valid.

**SOS Report Options**

The log collector uses the JBoss SOS plugin. Use the following options to activate data collection from the JMX console.

`--jboss-home=JBOSS_HOME`
: JBoss installation directory path. The default is `/var/lib/jbossas`.

`--java-home=JAVA_HOME`
: Java installation directory path. The default is `/usr/lib/jvm/java`.

`--jboss-profile=JBOSS_PROFILE`
: Displays a quoted and space-separated list of server profiles; limits log collection to specified profiles. The default is `'rhevm-slimmed'`.

`--enable-jmx`
: Enables the collection of run-time metrics from Red Hat Virtualization's JBoss JMX interface.

`--jboss-user=JBOSS_USER`
: User with permissions to invoke JBoss JMX. The default is `admin`.

`--jboss-logsize=LOG_SIZE`
: Maximum size in MB for the retrieved log files.

`--jboss-stdjar=STATE`
: Sets collection of JAR statistics for JBoss standard JARs. Replace `STATE` with `on` or `off`. The default is `on`.

`--jboss-servjar=STATE`
: Sets collection of JAR statistics from any server configuration directories. Replace `STATE` with `on` or `off`. The default is `on`.

`--jboss-twiddle=STATE`
: Sets collection of twiddle data on or off. Twiddle is the JBoss tool used to collect data from the JMX invoker. Replace `STATE` with `on` or `off`. The default is `on`.

`--jboss-appxml=XML_LIST`
: Displays a quoted and space-separated list of applications with XML descriptions to be retrieved. Default is `all`.

**SSH Configuration**

`--ssh-port=PORT`
: Sets `PORT` as the port to use for SSH connections with virtualization hosts.

`-k KEYFILE`, `--key-file=KEYFILE`
: Sets `KEYFILE` as the public SSH key to be used for accessing the virtualization hosts.

`--max-connections=MAX_CONNECTIONS`
: Sets `MAX_CONNECTIONS` as the maximum concurrent SSH connections for logs from virtualization hosts. The default is `10`.

**PostgreSQL Database Options**

The database user name and database name must be specified, using the `pg-user` and `dbname` parameters, if they have been changed from the default values.

Use the `pg-dbhost` parameter if the database is not on the local host. Use the optional `pg-host-key` parameter to collect remote logs. The PostgreSQL SOS plugin must be installed on the database server for remote log collection to be successful.

`--no-postgresql`
: Disables collection of database. The log collector will connect to the Red Hat Virtualization Manager PostgreSQL database and include the data in the log report unless the `--no-postgresql` parameter is specified.

`--pg-user=USER`
: Sets `USER` as the user name to use for connections with the database server. The default is `postgres`.

`--pg-dbname=DBNAME`
: Sets `DBNAME` as the database name to use for connections with the database server. The default is `rhevm`.

`--pg-dbhost=DBHOST`
: Sets `DBHOST` as the host name for the database server. The default is `localhost`.

`--pg-host-key=KEYFILE`
: Sets `KEYFILE` as the public identity file (private key) for the database server. This value is not set by default; it is required only where the database does not exist on the local host.
