#!/bin/bash

set -xe

commitid=$(git log -n 1 --pretty --format=%h)
release_ver=5.0
build_ver=5.0.4
release_desc=${build_ver}-${commitid}
sed "s/__RELEASE_DESC__/$release_desc/" Dockerfile >Dockerfile.release
docker build --no-cache -t rainbond/rbd-builder:${release_ver} -f Dockerfile.release .
rm -rf Dockerfile.release
