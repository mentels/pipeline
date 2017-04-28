# InfluxMigration

## Get the input Influx running

```bash
# start influx containers containers
docker-compose up

# import data
docker cp tide_log.tar.gz influxmigration_influx_in_1:/root
docker exec influxmigration_influx_in_1 tar -xvvzf  /root/tide_log.tar.gz
docker exec influxmigration_influx_in_1 influxd restore -metadir /var/lib/influxdb/meta tide_log_backup
docker exec influxmigration_influx_in_1 influxd restore -datadir /var/lib/influxdb/data -database tide_log tide_log_backup

# restart containers
docker-compose restart

# see if the metrics are there
curl -G 'http://localhost:8086/query?pretty=true' --data-urlencode "db=tide_log" --data-urlencode "q=SHOW MEASUREMENTS"

```


