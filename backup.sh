#!/bin/bash
source /env.sh
OPTS="--gzip"
DATE=$(date +%Y.%m.%d.%H.%M)
OUTPUT=/backup/${MONGO_DB:-all}-$DATE.gz

if [ ! -z "$MONGO_USER" ]
then
  OPTS="$OPTS --username $MONGO_USER"
fi

if [ ! -z "$MONGO_PASS" ]
then
  OPTS="$OPTS --password $MONGO_PASS"
fi

if [ ! -z "$MONGO_DB" ]
then
  OPTS="$OPTS --db $MONGO_DB"
fi

echo "=> Backup started at $DATE"
mongodump --forceTableScan $OPTS --host "$MONGO_HOST" --port "$MONGO_PORT" --authenticationDatabase admin --archive="$OUTPUT"

if [ -n "$MAX_BACKUPS" ]; then
  while [ "$(find /backup -maxdepth 1 -type f | wc -l)" -gt "$MAX_BACKUPS" ]
  do
    TARGET=$(ls -t /backup | tail -n 1)
    rm -rf "/backup/$TARGET"
    echo "Backup $TARGET is deleted"
  done
fi

echo "=> Backup done"
