#!/usr/bin/env bash
set -e

USAGE_STRING="Usage: build-push-docker.sh -t <tag name> -r <registry repo name> -u <registry user>. Ensure GITHUB_TOKEN is set for authentication to GHCR"

while getopts ":t:" opt; do
  case ${opt} in
    t )
      TAG="${OPTARG}"
      ;;
    r )
      REPO="${OPTARG}"
      ;;
    u )
      USER="${OPTARG}"
      ;;
    \? ) echo "${USAGE_STRING}"
         exit -1
      ;;
  esac
done

TAG=${TAG:-"latest"}
REPO=${REPO:-"kayleevo9x/playground"}
USER=${USER:-"kayleevo9x"}
export CR_PATH=$GITHUB_TOKEN
echo $CR_PAT | docker login ghcr.io -u $USER --password-stdin
docker build \
  -t helloworld-asp-api:$TAG --platform "linux/amd64" .
docker tag helloworld-asp-api:$TAG ghcr.io/$REPO/helloworld-asp-api:$TAG
docker push ghcr.io/$REPO/helloworld-asp-api:$TAG