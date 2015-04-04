#!/bin/bash

docker run \
  --link rdio-sync-mysql:mysql \
  -e RDIO_SECRET=$RDIO_SECRET \
  -e RDIO_KEY=$RDIO_KEY \
  -p 3004:3004 \
  royvandewater/rdio-sync-api:devel
