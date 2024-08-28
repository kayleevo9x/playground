#!/usr/bin/env bash
set -e

USAGE_STRING="Usage: build-push-docker.sh -t <tag name>"

# Deal with args
while getopts ":t:" opt; do
  case ${opt} in
    t )
      TAG="${OPTARG}"
      ;;
    \? ) echo "${USAGE_STRING}"
         exit -1
      ;;
  esac
done

TAG=${TAG:-"latest"}
echo $CR_PAT | docker login ghcr.io -u kayleevo9x --password-stdin
docker build \
  -t url-shortener-api:$TAG --platform "linux/amd64" --target main .
docker tag url-shortener-api:$TAG ghcr.io/kayleevo9x/playground/url-shortener-api:$TAG
docker push ghcr.io/kayleevo9x/playground/url-shortener-api:$TAG