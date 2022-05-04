---
title: Repository mirrors
category: infra
authors:
  - amarchuk
  - bproffitt
  - dcaroest
  - ngoldin
  - ederevea
---

# Repository mirrors

## Mirroring oVirt repositories

Do you want to host a mirror? Do you have some bandwidth to spare?

Drop us a line at [infra](mailto:infra-support@ovirt.org) and tell us about yourself! You just need to pass us a public ssh key, and once set up you'll be able to rsync from our site with the following command:

       rsync -rltHvvP mirror@resources.ovirt.org:/var/www/html destination/dir

After some validation we will add your site to this page and to the mirrorlist!

**Thanks a lot for your bandwidth!**

## For admins

We have a simple setup to allow mirroring of the oVirt repositories. Right now the mirroring is done through ssh with rsync. You'll find in **resources.ovirt.org** a user named **mirror**. That's the user that the mirrors should use, which has a lot of entries under *~/.ssh/authorized_keys*. Each entry is restricted to run only a specific command that allows them to rsync the repo directory.
Please refer to the [read the docs page](https://ovirt-infra-docs.readthedocs.io/en/latest/General/Mirror/index.html) for more info on adding mirrors.

### Adding a mirror

Then when the mirror is in sync you can add it to the mirrorlist (*resources.ovirt.org:/var/www/html/pub/yum-repo/mirrorlist*) and to this wiki.

## Current mirrors

| Name                                                                  | Location                       | HTTP                                                  | FTP                                                   | rsync                                          | Contact                         | Other                                                                           |
|-----------------------------------------------------------------------|--------------------------------|-------------------------------------------------------|-------------------------------------------------------|------------------------------------------------|---------------------------------|---------------------------------------------------------------------------------|
| [NLUUG](http://www.nluug.nl)                                          | The Netherlands (Amsterdam)    | [http](http://ftp.nluug.nl/os/Linux/virtual/ovirt/)   | [ftp](ftp://ftp.nluug.nl/pub/os/Linux/virtual/ovirt/) |                                                | ftpmirror-beheer_at_nluug.nl    | Syncing on all odd hours, bandwidth is currently 4 Gb/s and we do IPV4 and IPV6 |
| [Studenten Net Twente (SNT)](http://www.snt.utwente.nl/)              | The Netherlands                | [http](http://ftp.snt.utwente.nl/pub/software/ovirt/) | [ftp](ftp://ftp.snt.utwente.nl/pub/software/ovirt/)   |                                                | ftpcom at snt.utwente.nl        |                                                                                 |
| [Georgia Tech Software Library (GTlib)](http://www.gtlib.gatech.edu/) | United States (Georgia)        | [http](http://www.gtlib.gatech.edu/pub/oVirt/pub/)    | [ftp](ftp://www.gtlib.gatech.edu/pub/oVirt/pub/)      | [rsync](rsync://rsync.gtlib.gatech.edu/oVirt/) | gtlib_at_gtlib.gatech.edu       |                                                                                 |
| [ibiblio](http://www.ibiblio.org/)                                    | United States (North Carolina) | [http](http://mirrors.ibiblio.org/ovirt/)             |                                                       |                                                | cmpalmer_at_ibiblio.org         |                                                                                 |
| [Rochester Institute of Technology](http://www.rit.edu)               | United States (New York)       | [http](http://mirrors.rit.edu/ovirt/)                 | [ftp](ftp://mirrors.rit.edu/ovirt/)                   |                                                | pfmeec_at_rit.edu               |                                                                                 |
| [Duke University](http://duke.edu)                                    | United States (North Carolina) | [http](http://mirror.linux.duke.edu/ovirt/pub/)       |                                                       |                                                | drew.stinnett_at_duke.edu       |                                                                                 |
| [Plus.line AG](http://www.plusline.net/en/)                           | Germany (Frankfurt)            | [http](http://ftp.plusline.net/ovirt/)                | [ftp](ftp://ftp.plusline.net/pub/ovirt/)              | [rsync](rsync://ftp.plusline.net/ovirt/)       | ftp-admin_at_plusline.net       |                                                                                 |
| [Silesian University in Opava](http://www.slu.cz)                     | Czech Republic (Opava)         | [http](http://mirror.slu.cz/ovirt/)                   | [ftp](ftp://mirror.slu.cz/ovirt/)                     |                                                | jiri_slezka_at_slu_cz           | 1Gbps, IPv6 ready                                                               |
| [ISOC-IL](http://mirror.isoc.org.il/)                                 | Israel                         | [http](http://mirror.isoc.org.il/pub/ovirt/)          | [ftp](ftp://mirror.isoc.org.il/pub/ovirt/)            |                                                | mirrormaster_at_isoc_org_il     |                                                                                 |
| [NFrance Conseil](https://www.nfrance.com/)                           | France                         | [http](http://ovirt.repo.nfrance.com/)                |                                                       |                                                | network_at_nfrance_com          |                                                                                 |
| [Rackspace](https://www.rackspace.com/)                               | Globally Load Balanced         | [http](http://mirror.rackspace.com/ovirt)             |                                                       | [rsync](rsync://mirror.rackspace.com/ovirt/)   | mirroradmin_at_rackspace_com    | 1Gbps, sync every 4 hours                                                       |
| [Massclouds](http://www.massclouds.com/)                              | China                          | [http](http://mirror.massclouds.com/ovirt/)           | [ftp](ftp://mirror.massclouds.com/ovirt/)             |                                                | zhao_jda_at_massclouds_com      |                                                                                 |
| [Nanjing University](https://www.nju.edu.cn/)                         | China                          | [https](https://mirrors.nju.edu.cn/ovirt/)            |                                                       |                                                |                                 |                                                                                 |
| [GARR](https://garr.it/en/)                                           | Italy                          | [https](https://ovirt.mirror.garr.it/)                |                                                       |                                                | mirror-service_at_garr.it       |                                                                                 |
