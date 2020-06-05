# mongodb-backup

This image runs mongodump to backup data using cronjob to folder `/backup`

## Example:

```
docker network create mongodbbackup

docker run -d --name mongodb --network mongodbbackup -p 27017:27017 -e MONGO_INITDB_ROOT_USERNAME=root -e MONGO_INITDB_ROOT_PASSWORD=qwerty12345 pedropilla/mongodb-dummydb

docker run -d --name mongodbbackup --network mongodbbackup -e MONGODB_HOST=mongodb -e MONGODB_USER=root -e MONGODB_PASS=qwerty12345 -e CRON_TIME='*/1 * * * *' -e MAX_BACKUPS=30 -e EXTRA_OPTS=--forceTableScan -v $(pwd):/backup pedropilla/mongodb-backup
```

## Parameters

    MONGODB_HOST    the host/ip of your mongodb database. Default: mongodb
    MONGODB_PORT    the port number of your mongodb database. Default: 27017
    MONGODB_USER    the username of your mongodb database. Default: root
    MONGODB_PASS    the password of your mongodb database. Default: qwerty12345
    MONGODB_DB      the database name to dump. If not specified, it will dump all the databases
    EXTRA_OPTS      the extra options to pass to mongodump command
    CRON_TIME       the interval of cron job to run mongodump. `0 0 * * *` by default, which is every day at 00:00
    MAX_BACKUPS     the number of backups to keep. When reaching the limit, the old backup will be discarded. No limit, by default
    INIT_BACKUP     if set, create a backup when the container launched

## Restore from a backup

See the list of backups, you can run:

    docker exec mongodbbackup ls /backup

To restore database from a certain backup, simply run:

    docker exec mongodbbackup /restore.sh /backup/2020.06.05.111000
