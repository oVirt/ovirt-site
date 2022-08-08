---
title: Using oVirt Engine with a PostgreSQL container.
authors: leni1
---
The base environment is CentOS 7.

oVirt Engine is assumed to running as per the configuration in oVirt Engine with a PostgreSQL container.

Alternatively you may have both PostgreSQL and oVirt installed locally on your machine, so long as you are able
to log into the oVirt Engine successfully.

### Steps

1. Make sure that the Docker service is running:
   ```console
   $ sudo service docker start
   ```
   or
   ```console
   $ sudo systemctl start docker.service
   ```

2. Use the Docker image of ManageIQ available at Docker Hub: https://hub.docker.com/r/manageiq/manageiq/

   Pull the Docker image as follows:
   ```console
   $ sudo docker pull manageiq/manageiq:fine-3
   ```

At present, the tag is `fine:3` but that changes with time, so to be sure go to https://manageiq/download to see what the latest tag is.

3. Run the container
   ```console
   $ sudo docker run --name ovirt-manageiq --privileged -d -p 8443:443 manageiq/manageiq:fine-3
   ```

Note: Trying to access the container via `https://localhost:8443` will raise a "Secure Connection Failed" error.

Waiting a few moments and trying again will show you the "Insecure Connection" warning. Click on the "Advanced" button and
add an exception for the site. Confirming the exception should bring you to the ManageIQ Login page.

Default login for ManageIQ:
 * user: `admin`
 * password: `smartvm`

4. Change Options

Click on 'Admininstrator' and then select 'Configuration' to change how the appliance behaves:
1. Select the appliance to configure

    CFME Region: Region 0 → Zones → Zone: Default zone(current) → Server: EVM\[1\](current) should be selected by default.

    The hostname and IP address of the appliance will be shown here, be careful as in some cases this will be the internal IP address and not the one you connected to.

    You can change the Company Name to whatever you want, the change will be reflected in the interface.
    Change it to ManageIQ
    Select your time zone, and, if you want, you can change the language default.

2. Adding oVirt Engine as a provider to ManageIQ:
Compute -> Infrastructure -> Providers
Click on 'Configuration'. Select 'Add a new infrastructure provider'.
- Hostname of the both the provider and the C & U database should be the IP address of the
  Docker container that has oVirt Engine's database.
- API port for the provider should be that of oVirt Engine (443) and that of the C & U database should be
  5432 (for PostgreSQL).
- Remember to specify the correct database name, owner and password for the C & U database
  (e.g. if you configured oVirt to have a database and owner called `engine`, be sure to use the same for the
  C & U database for ManageIQ along with the associated credentials).
