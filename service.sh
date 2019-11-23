#!/usr/bin/env bash
cd /go/src/github.com/adachin-go
realize start &
nginx -g "daemon off;"

while true
do
  sleep 10
done
 
