#!/bin/bash
BACKUP_DIR="/opt/mysql_backup"
STORE_SERVER="192.168.3.27"
STORE_USER="student"
STORE_DIR="/opt/store/mysql_backup/"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="$BACKUP_DIR/codeby_db_$TIMESTAMP.sql.gz"

mysqldump --databases codeby_db | gzip > "$BACKUP_FILE"

if [ $? -eq 0 ]; then
    echo "done backup"
else
    echo "error backup" >&2
    exit 1
fi

rsync -avz -e "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" "$BACKUP_DIR/" "$STORE_USER@$STORE_SERVER:$STORE_DIR"

if [ $? -eq 0 ]; then
    echo "done sync"
else
    echo "error sync" >&2
    exit 1
fi
