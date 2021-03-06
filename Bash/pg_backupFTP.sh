#!/bin/bash
#pg_config
HOSTNAME=""
USERNAME=""
PASSWORD=""
DATABASE=""

#backup_ftp_config
HOST=''
USER=''
PASSWD=''
FILE=$(date +%Y-%m-%d).backup.gz
FTP_PORT=''

# make pg_dump
echo "Pulling Database: This may take a few minutes"
export PGPASSWORD="$PASSWORD"
pg_dump -F t -h $HOSTNAME -U $USERNAME $DATABASE > $(date +%Y-%m-%d).backup
unset PGPASSWORD
gzip $(date +%Y-%m-%d).backup
echo "Pull Complete"

echo "Clearing old backups"
find . -type f -iname '*.backup.gz' -ctime +15 -not -name '????-??-01.backup.gz' -delete
echo "Clearing Complete"


#SendViaFtp
ftp -n $HOST $FTP_PORT <<END_SCRIPT
quote USER $USER
quote PASS $PASSWD
binary
put $FILE
quit
END_SCRIPT
exit 0
