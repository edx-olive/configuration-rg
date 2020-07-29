Role to configure duplicity backups
===================================

Required extra vars:
====================

backup_enabled: <True|False>
backup_aws_region: "eu-west-1" # required for regions different from 'ua-east-1'

Available targets
=================

to get help please refer [official duplicity documentation - URL Format](http://duplicity.nongnu.org/vers7/duplicity.1.html#sect7)

quick overview:

```
TARGET
syntax is
  scheme://[user:password@]host[:port]/[/]path

probably one out of
  file://[/absolute_]path # 3 dashes for absolute path!
  ftp[s]://user[:password]@other.host[:port]/some_dir
  hsi://user[:password]@other.host/some_dir
  cf+http://container_name
  imap[s]://user[:password]@host.com[/from_address_prefix]
  rsync://user[:password]@other.host[:port]::/module/some_dir
  rsync://user@other.host[:port]/relative_path
  rsync://user@other.host[:port]//absolute_path
  # for the s3 user/password are AWS_ACCESS_KEY_ID/AWS_SECRET_ACCESS_KEY
  s3://[user:password]@host/bucket_name[/prefix]
  s3+http://[user:password]@bucket_name[/prefix]
  ssh://user[:password]@other.host[:port]/some_dir
  tahoe://alias/directory
  webdav[s]://user[:password]@other.host/some_dir
```

Custom profiles configuration:
==============================

```
backup_cron_schedule: "21 10 * * *"
backup_duplicity:
backup_target: 'target.host.ltd'
backup_target_method: '<s3|azure|ftp|rsync|ssh|sftp>'
backup_target_user: '<username>'
backup_target_pass: '<user_password>'
backup_profiles:
  - name: <backup_name1>
    type: '<file|mysql|mongo|postgres>|...'  # for full list of available profiles see templates/profiles
    backup_volsize: 250                      # size of duplicity volume in Mbytes (intended to be
                                             # small for small backups, large for huge)
    <profile_configuration>                  # see templates/profiles/<type>/README.md
      ...
```

Examples:
=========
```
backup_runas_user: 'root'  # must be root for "profiles[type]: file" to read files with any owner and attr
                           # can be blank (default duplicity user) for other types of backup (for example db dumps)
backup_enabled: true
backup_duplicity:
backup_target: 'ftp.example.com'
backup_target_method: 'ftp'
backup_target_user: 'ftpuser'
backup_target_pass: 'secret'
backup_profiles:
  - name: home_directory
    type: file
    source: /home/
    backup_volsize: 1024
    exclude:
      - '- **.pyc'
      - '- **.mp3'
      - '- **.avi'

  - name: mysql
    type: mysql
    databases:                         # default: all databases
      - web_database
      - web_admin
    mysql_host: localhost              # default: localhost
    mysql_user: mysqluser
    mysql_password: mysqluserpassword

  - name: mysql_docker
    type: docker-mysql
    databases:                         # default: all databases
      - web_database
      - web_admin
    mysql_container: project_mysql     # default: mysql
    mysql_user: mysqluser
    mysql_password: mysqluserpassword

  - name: mongo
    type: mongo
    databases:                         # default: all databases
      - edxapp
      - cs_comments_service
    mongo_host: localhost
    mongo_user: admin
    mongo_password: mongoadminuserpassword
    mongo_authdb: admin
    mongodump_extra_args: '--ssl --forceTableScan'
```

Specific backends notes:
========================

- sftp - `backup_target` **must** contain double dashes between hostname and path (192.168.0.1**//**backup/mysql/)

GPG encryption:
===============

- on local machine execute:
```
gpg --gen-key
gpg --armor --export KEYIDB12A89D52E01191C
gpg --armor --export-secret-key KEYIDB12A89D52E01191C
```
- place output of first export into `backup_gpg_key_pub` variable
- place out of second export into `backup_gpg_key_priv` variable
- configure next variables:
```
backup_gpg_key: "KEYIDB12A89D52E01191C"
backup_gpg_key_sign: "{{ backup_gpg_key }}"
backup_gpg_opts: "--trust-model always"
backup_gpg_pw: PASSWORDUSEDON-gen-key
backup_gpg_key_pub: |
  -----BEGIN PGP PUBLIC KEY BLOCK-----

    mQENBFxMURgBCADLP2h4WAb6Mpt+8Dn8Vf+tih1Z7fyea8sFjpWGOSf8dF9kFSmS
    ...
    ...
backup_gpg_key_priv: |
  -----BEGIN PGP PRIVATE KEY BLOCK-----

    lQPGBFxMURgBCADLP2h4WAb6Mpt+8Dn8Vf+tih1Z7fyea8sFjpWGOSf8dF9kFSmS
    ...
    ...
```

** Warrning for GPG 2.1 or greater (Ubuntu 18.04 or greater)**
to disable prompting a passphrase on terminal use this extra vars configuration:
```
backup_gpg_opts: "--trust-model always --pinentry-mode loopback"
```
https://bugs.launchpad.net/ubuntu/+source/duply/+bug/1638516
