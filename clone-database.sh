#!/bin/bash

set -uo pipefail

# Start Postgres
gosu postgres postgres -D /data &

# Wait for Postgres to respond
RET=1
while [ $RET -ne 0 ]; do
    sleep 1
    psql -h127.0.0.1 -Upostgres -c "SELECT 1;" &> /dev/null
    RET=$?
done

PGPASS_REGEX='^\([^:]\+\):\([^:]\+\):\([^:]\+\):\([^:]\+\):\([^:]\+\)$'

# For each row in pgpass, create -> dump -> import -> remove dump
for SOURCE in `grep -v "^\s*#" /root/.pgpass`; do
  DUMP_FLAGS=`echo "${SOURCE}"|sed -e "s/${PGPASS_REGEX}/-h \1 -p \2 --no-owner -U \4 -v \3/g"`
  DB=`echo "${SOURCE}"|sed -e "s/${PGPASS_REGEX}/\3/g"`
  eval "psql -h127.0.0.1 -Upostgres -c 'CREATE DATABASE ${DB};'"
  eval "pg_dump ${DUMP_FLAGS} > /tmp/${DB}.sql"
  eval "psql -U postgres -h 127.0.0.1 ${DB} < /tmp/${DB}.sql"
  rm "/tmp/${DB}.sql"
done

killall postgres
