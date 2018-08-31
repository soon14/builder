#!/bin/bash
set -xe

image_name="builder"
release_ver=${1:-v5.0}
docker_tag=${1:-v5.0}


trap 'clean_tmp; exit' QUIT TERM EXIT

function clean_tmp() {
  echo "clean temporary file..."
  [ -f Dockerfile.release ] && rm -rf Dockerfile.release
}


function release(){
  # get commit sha
  git_commit=$(git log -n 1 --pretty --format=%h)
  # get git describe info
  release_desc=${release_ver}-${git_commit}

  sed "s/__RELEASE_DESC__/$release_desc/" Dockerfile >Dockerfile.release
  docker build --no-cache -t rainbond/${image_name}:${docker_tag} -f Dockerfile.release .
  docker tag rainbond/${image_name}:${docker_tag}  rainbond/${image_name}
  if [ -z "$1" ];then
    docker push rainbond/${image_name}:${docker_tag}
  else
    docker tag rainbond/${image_name} goodrain.me/${image_name}
    docker push goodrain.me/${image_name}
  fi
}

case $1 in
  local)
      release local
      ;;
  *)
      release
      ;;
esac
