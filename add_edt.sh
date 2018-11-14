#/usr/bin/env bash
mysqladmin --user=root --password=$MYSQL_ROOT_PASSWORD create edt
dbf2mysql -h localhost -U root -P $MYSQL_ROOT_PASSWORD \
          -d edt -t storet \
          -c -v \
          /data/storet.dbf
dbf2mysql -h localhost -U root -P $MYSQL_ROOT_PASSWORD \
          -d edt -t chemical \
          -c -v \
          /data/chemical.dbf
