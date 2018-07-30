#!/usr/bin/env bash
set -e

# TODO: does not work with gcr.io/distroless/cc@sha256:923564f1d33ac659c15edf538b62f716ed436d7cc5f6a9d64460b8affba9ccd9 !
INPUT_IMAGE="gcr.io/distroless/base@sha256:628939ac8bf3f49571d05c6c76b8688cb4a851af6c7088e599388259875bde20"
docker pull $INPUT_IMAGE
rm -f base new-image
docker save -o base $INPUT_IMAGE

echo "> Adding hello-worls.sh to the base image..."
gcc hello-world.c -o hello-world
./../docker-add-layer base hello-world new-image

echo "> Trying the new image..."
LOADED_IMAGE_ID=`docker load < new-image | tail -n 1 | cut -d ':' -f 3`
OUTPUT=`docker run --entrypoint "/hello-world" $LOADED_IMAGE_ID`
if [[ "$OUTPUT" != "Hello, world!" ]]
then
  echo "$OUTPUT is not equal to \"Hello, world!\""
fi
