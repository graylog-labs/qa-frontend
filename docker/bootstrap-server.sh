#!/bin/sh

PREFIX=`dirname $0`
docker-compose -f $PREFIX/docker-compose.yml up &

echo -n "Waiting for Graylog to come up"
until `curl -s http://localhost:12900/ > /dev/null`; do echo -n "."; sleep 1; done
