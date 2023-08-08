#!/bin/bash

# Location to place backups.
BACKUP_DIR="/storage/backups"
RESOURCES_DIR="/storage/docker-volumes/"

#Instead of clearly written username and password you can use a .pgpass file to store the password:  https://www.postgresql.org/docs/current/libpq-pgpass.html
HOSTNAME=127.0.0.1
USERNAME=postgres
PASSWORD=postgres
DATABASE_A=db_name

export PGPASSWORD="$PASSWORD"

[ ! -d $backup_dir ] && mkdir -p $backup_dir

pg_dump --host $HOSTNAME --port 5432 --username $USERNAME --format custom --blobs --verbose --file $BACKUP_DIR/$DATABASE_A-$(date +%Y-%m-%d).backup $DATABASE_A
unset PGPASSWORD
#compress content
gzip $BACKUP_DIR/$DATABASE_A-$(date +%Y-%m-%d).backup

#delete all backup files older than 5 days
find $BACKUP_DIR -type f -iname '$DATABASE_A-*.backup.gz' -mtime +5 -delete

#Upload backup on cloud drive