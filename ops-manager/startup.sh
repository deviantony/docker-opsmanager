#!/usr/bin/env sh

echo "Stalling for MongoDB"
while true; do
    nc -q 1 database 27017 >/dev/null && break
done

/opt/mongodb/mms/bin/mongodb-mms start
/opt/mongodb/mms-backup-daemon/bin/mongodb-mms-backup-daemon start

# Should be replaced by supervisord
tail -f /opt/mongodb/mms/logs/mms0.log
