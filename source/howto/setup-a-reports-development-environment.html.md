---
title: How to setup a oVirt Reports development environment
category: howto
authors: alonbl, bproffitt, quaid, sradco, yaniv dary
wiki_category: Documentation
wiki_title: How to setup a oVirt Reports development environment
wiki_revision_count: 37
wiki_last_updated: 2014-11-25
---

# How to setup a oVirt Reports development environment

*   Clone the git repository 'ovirt-reports' project from the ovirt gerrit.
*   Download and install the latest edition of JasperReports Server CE Edition.

`The CE is available on this link: `[`https://community.jaspersoft.com/project/jasperreports-server/releases`](https://community.jaspersoft.com/project/jasperreports-server/releases)

It is preferred you use JBoss as your applications server and Postgres as your JasperReports Server configuration database. This can be done using the war installation. Please make sure to setup import and export scripts using the install guide provided by Jasper and install Jaspersoft Studio. Another option is installing via the JasperReports Server installer. Details on this are also provided by the installation guide.

*   If the ovirt_engine_history database is not installed locally or is protected by password, you will have to edit an xml file in this path and add the details:

< repository folder path >/packaging/ovirt-reports/resources/reports_resources/JDBC/data_sources/ovirt.xml

More information on changing the data source properties is available in the JasperReports Server documentation.

*   Use import script to load the reports repository, using the commend:

      ./js-import.sh --input-dir < repository folder path >/packaging/ovirt-reports --update

*   Build the required jars in the path :

      < repository folder path >/ovirt-engine-reports

*   Place the jars created under < repository folder path >/lib in JasperReports Server folder in the path:

      Apache Tomcat: jasperserver/WEB-INF/lib
      JBoss: jasperserver.war/WEB-INF/lib

*   Restart the application server.
*   The server can now be run and accessed in the link:

      < host >:8080/jasperserver/

with the following credentials:

      User: admin
      password: admin1!

*   Open Jaspersoft Studio Designer.
*   Setup the JasperReports Server repository viewer to view the repository you imported the reports to. Details for doing this are provided in the Jaspersoft Studio guide by Jasper.
*   Reports can now be edited via Jaspersoft Studio .

<Category:Documentation> <Category:Reports> [Category:Development environment](Category:Development environment) [Category:How to](Category:How to)
