docker run \
  -e RDIO_KEY=$RDIO_KEY \
  -e RDIO_SECRET=$RDIO_SECRET \
  --link trusting_kirch:mysql \
  royvandewater/rdio-sync-api:devel

