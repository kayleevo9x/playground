#!/usr/bin/env bash

set -e

case $1 in
  api)  
    exec uvicorn url_shortener.main:app --host 0.0.0.0 --port 8000
    ;;
  api-debug)
    exec uvicorn url_shortener.main:app --host 0.0.0.0 --port 8000 --reload --log-level debug
    ;;
  *)
    echo "Unrecognized entrypoint command $1. Running it directly."
    exec "$@"
    ;;
esac