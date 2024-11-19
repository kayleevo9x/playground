#!/bin/bash
set -ex

WORKSPACE_DIR=$(pwd)

cd ${WORKSPACE_DIR}/applications/url-shortener

docker compose up postgresql -d

echo "Done! Run the following command to start the app locally"
echo "uvicorn url_shortener.main:app --host 0.0.0.0 --port 8000 --reload --log-level debug"
