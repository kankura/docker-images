#!/bin/bash

echo Checking command...
echo command: $@

# Make sure service is running
service rsyslog start

# Touch the log file so we can tail on it
touch /var/log/haproxy.log

echo
echo "Starting cron for logrotate..."
cron

# cronのデフォルトメール送付先を変更
[[ $MAILTO -ne "" ]] && echo MAILTO=$MAILTO >> /var/spool/cron/crontabs/root

echo
echo "Call the official docker-entrypoint.sh"
#cat /docker-entrypoint.sh
bash /docker-entrypoint.sh $@

