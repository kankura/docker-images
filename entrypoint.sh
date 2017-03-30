#!/bin/sh

echo "Show args as commands"
echo command: $@

# Make sure service is running
service rsyslog start

# Touch the log file so we can tail on it
touch /var/log/haproxy.log

echo
echo "Starting cron for logrotate..."
#cp /kc/infra/common/common-conf/etc/cron.d/kc-cron-check /etc/cron.d
cron

# Added a logrotate setting
\cp /logrotate.d/* /etc/logrotate.d
# cronのデフォルトメール送付先を変更
#echo MAILTO= >> /var/spool/cron/crontabs/root


echo
echo "Call the official docker-entrypoint.sh"
#cat /docker-entrypoint.sh
bash /docker-entrypoint.sh $@

