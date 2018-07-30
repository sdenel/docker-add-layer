[![Build Status](https://travis-ci.com/sdenel/docker-add-layer.svg?branch=master)](https://travis-ci.com/sdenel/docker-add-layer)

A python script adding a layer to a Docker image **without** needing the daemon.

Useful, for example, during a CI pipeline inside Docker when you don't want to do Docker in Docker. Requires Python 3.1+ 

# Installation

```bash
# With wget:
wget https://raw.githubusercontent.com/sdenel/docker-add-layer/master/docker-add-layer
# With curl:
curl https://raw.githubusercontent.com/sdenel/docker-add-layer/master/docker-add-layer > docker-add-layer
# Then:
chmod +x docker-add-layer
```


# Example
The following lines builds a new image with a C program printing "hello world!". The image is gzipped afterward, but it is an optional step:
```bash
docker pull gcr.io/distroless/base
docker save -o base gcr.io/distroless/base
gcc tests/hello-world.c -o hello-world
./docker-add-layer base hello-world new-image
gzip -9 -k -f -c new-image > new-image-gz # This line is optional, but reduces by half the size of the image
LOADED_IMAGE_ID=`docker load < new-image-gz | tail -n 1 | cut -d ':' -f 3`
docker run --entrypoint "/hello-world" $LOADED_IMAGE_ID # This should display "Hello, world!"
```
