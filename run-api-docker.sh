echo docker run \
  -e MYSQL_CONNECT_STRING=$DOCKER_RDIO_MYSQL_CONNECT_STRING \
  -e RDIO_KEY=$RDIO_KEY \
  -e RDIO_SECRET=$RDIO_SECRET \
  --link trusting_kirch:mysql \
  royvandewater/rdio-sync-api
