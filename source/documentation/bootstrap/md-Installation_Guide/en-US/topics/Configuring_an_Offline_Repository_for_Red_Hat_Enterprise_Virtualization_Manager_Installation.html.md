# Configuring a Local Repository for Offline Red Hat Virtualization Manager Installation

To install Red Hat Virtualization Manager on a system that does not have a direct connection to the Content Delivery Network, download the required packages on a system that has Internet access, then create a repository that can be shared with the offline Manager machine. The system hosting the repository must be connected to the same network as the client systems where the packages are to be installed.

1. Install Red Hat Enterprise Linux 7 Server on a system that has access to the Content Delivery Network. This system downloads all the required packages, and distributes them to your offline system(s).

    **Important:** Ensure that the system used in this procedure has a large amount of free disk space available. This procedure downloads a large number of packages, and requires up to 50GB of free disk space.

2. Register your system with the Content Delivery Network, entering your Customer Portal user name and password when prompted:

        # subscription-manager register

3. Subscribe the system to all required entitlements:

    1. Find the `Red Hat Enterprise Linux Server` and `Red Hat Virtualization` subscription pools and note down the pool IDs.

            # subscription-manager list --available
    2. Use the pool IDs located in the previous step to attach the entitlements to the system:

            # subscription-manager attach --pool=pool_id

    3. Disable all existing repositories:

            # subscription-manager repos --disable=*

    4. Enable the required repositories:

            # subscription-manager repos --enable=rhel-7-server-rpms
            # subscription-manager repos --enable=rhel-7-server-supplementary-rpms
            # subscription-manager repos --enable=rhel-7-server-rhv-4.0-rpms
            # subscription-manager repos --enable=jb-eap-7-for-rhel-7-server-rpms

    5. Ensure that all packages currently installed are up to date:

            # yum update

        **Note:** Reboot the machine if any kernel related packages have been updated. 

4. Servers that are not connected to the Internet can access software repositories on other systems using File Transfer Protocol (FTP). To create the FTP repository, install and configure `vsftpd`:

    1. Install the `vsftpd` package:

            # yum install vsftpd

    2. Start the `vsftpd` service, and ensure the service starts on boot:

            # systemctl start vsftpd.service
            # systemctl enable vsftpd.service

    3.Create a sub-directory inside the `/var/ftp/pub/` directory. This is where the downloaded packages will be made available:

            # mkdir /var/ftp/pub/rhevrepo

5. Download packages from all configured software repositories to the `rhevrepo` directory. This includes repositories for all Content Delivery Network subscription pools the system is subscribed to, and any locally configured repositories:

        # reposync -l -p /var/ftp/pub/rhevrepo

    This command downloads a large number of packages, and takes a long time to complete. The `-l` option enables yum plug-in support.

6. Install the `createrepo` package:

        # yum install createrepo

7. Create repository metadata for each of the sub-directories where packages were downloaded under `/var/ftp/pub/rhevrepo`:

        # for DIR in `find /var/ftp/pub/rhevrepo -maxdepth 1 -mindepth 1 -type d`; do createrepo $DIR; done;

8. Create a repository file, and copy it to the `/etc/yum.repos.d/` directory on the offline machine on which you will install the Manager.

    The configuration file can be created manually or with a script. Run the script below on the system hosting the repository, replacing *ADDRESS* in the `baseurl` with the IP address or fully qualified domain name of the system hosting the repository:

        #!/bin/sh
        
        REPOFILE="/etc/yum.repos.d/rhev.repo"
        
        for DIR in `find /var/ftp/pub/rhevrepo -maxdepth 1 -mindepth 1 -type d`; do  
            echo -e "[`basename $DIR`]" > $REPOFILE 
            echo -e "name=`basename $DIR`" >> $REPOFILE 
            echo -e "baseurl=ftp://<replaceable>ADDRESS</replaceable>/pub/rhevrepo/`basename $DIR`" >> $REPOFILE 
            echo -e "enabled=1" >> $REPOFILE 
            echo -e "gpgcheck=0" >> $REPOFILE 
            echo -e "\n" >> $REPOFILE
        done;   

9. Install the Manager packages on the offline system. See [Installing Red Hat Enterprise Virtualization Manager](Installing_Red_Hat_Enterprise_Virtualization_Manager1) for instructions. Packages are installed from the local repository, instead of from the Content Delivery Network.

10. Configure the Manager. See [Red Hat Enterprise Virtualization Manager Configuration Overview](Red_Hat_Enterprise_Virtualization_Manager_Configuration_Overview) for initial configuration instructions.

11. Continue with host, storage, and virtual machine configuration.
