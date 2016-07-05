#!/bin/sh

PREFIX=`dirname $0`
docker-compose -f $PREFIX/docker-compose.yml up &
