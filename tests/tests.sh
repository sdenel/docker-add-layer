#!/usr/bin/env bash
set -e

docker pull gcr.io/distroless/cc
rm -f base
docker save -o base gcr.io/distroless/cc
./../docker-add-layer base hello-world.sh new-image
LOADED_IMAGE_ID=`docker load < new-image | cut -d ':' -f 3`
OUTPUT=`docker run --entrypoint "/hello-world.sh" $LOADED_IMAGE_ID`
if [[ "$OUTPUT" != "Hello, world!" ]]
then
  echo "$OUTPUT is not equal to \"Hello, world!\""
fi