#!/bin/sh

set -eu

# update db or create
#/usr/bin/freshclam --config-file=/etc/clamav/freshclam.conf

mkdir -p /var/log/supervisor/
touch /var/log/supervisor/clamav_init.log
touch /var/log/supervisor/clamd.log
touch /var/log/supervisor/freshclam.log
chmod -R 0777 /var/log/supervisor/

echo "Starting the services"
supervisorctl start freshclam
supervisorctl start clamd
sleep 5

#exec supervisord -c ${SUPERVISOR_CONF} -n
