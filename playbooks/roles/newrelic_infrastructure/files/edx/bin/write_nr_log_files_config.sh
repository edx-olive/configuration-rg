#!/usr/bin/env bash

LOG_FILE_PATH="/etc/newrelic-infra/logging.d/logging.yml"
NEWRELIC_INFRASTRUCTURE_LOG_FILES=$1

if [ -z "$NEWRELIC_INFRASTRUCTURE_LOG_FILES" ]; then
  echo "Variable NEWRELIC_INFRASTRUCTURE_LOG_FILES is empty"
else
  echo "# $NEWRELIC_INFRASTRUCTURE_LOG_FILES" > $LOG_FILE_PATH
  echo "logs:" >> $LOG_FILE_PATH
  chmod 775 $LOG_FILE_PATH
  for file in $NEWRELIC_INFRASTRUCTURE_LOG_FILES
  do
    echo "  - name: $file
    file: $file" >> $LOG_FILE_PATH
  done
fi 
