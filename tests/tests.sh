#!/usr/bin/env bash
set -e

# TODO: does not work with gcr.io/distroless/cc@sha256:923564f1d33ac659c15edf538b62f716ed436d7cc5f6a9d64460b8affba9ccd9 !

docker pull gcr.io/distroless/cc@sha256:2de13d6b26ed1aaa436228ec45b725c408e7d474d8eea9c11f81be8682c374a9
rm -f base new-image
docker save -o base gcr.io/distroless/cc@sha256:2de13d6b26ed1aaa436228ec45b725c408e7d474d8eea9c11f81be8682c374a9
./../docker-add-layer base hello-world.sh new-image
LOADED_IMAGE_ID=`docker load < new-image | tail -n 1 | cut -d ':' -f 3`
OUTPUT=`docker run --entrypoint "/hello-world.sh" $LOADED_IMAGE_ID`
if [[ "$OUTPUT" != "Hello, world!" ]]
then
  echo "$OUTPUT is not equal to \"Hello, world!\""
fi
