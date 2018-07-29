#!/usr/bin/env bash
set -e

rm -f base
docker save -o base gcr.io/distroless/cc@sha256:2de13d6b26ed1aaa436228ec45b725c408e7d474d8eea9c11f81be8682c374a9
./../docker-add-layer base hello-world.sh new-image
LOADED_IMAGE_ID=`docker load < new-image | cut -d ':' -f 3`
OUTPUT=`docker run --entrypoint "/hello-world.sh" $LOADED_IMAGE_ID`
if [[ "$OUTPUT" != "Hello, world!" ]]
then
  echo "$OUTPUT is not equal to \"Hello, world!\""
fi