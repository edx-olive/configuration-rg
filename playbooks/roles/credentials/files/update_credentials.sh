#!/usr/bin/env bash

if ! test -x /edx/bin/python.credentials -o -x /edx/bin/python.edxapp ; then
  # for multi-instance installations: do nothing on non edxapp instances
  exit
fi

SHELL=/bin/bash
CREDENTIALS_CFG=/edx/etc/credentials.yml
LOG_FILE=/edx/var/log/update_credentials/edx.log
mkdir -p `dirname ${LOG_FILE}`
exec &>> ${LOG_FILE}
exec 2>&1
export SHELL
export CREDENTIALS_CFG

if test -x /edx/bin/python.credentials ; then
  sudo -Eu credentials /edx/app/credentials/venvs/credentials/bin/python /edx/app/credentials/credentials/manage.py copy_catalog --settings=credentials.settings.production
else
  echo "credentials service not found" >&2
fi
