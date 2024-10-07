#!/bin/bash
set -ex

WORKSPACE_DIR=$(pwd)
poetry config cache-dir ${WORKSPACE_DIR}/.cache

echo "install dependencies"
cd ${WORKSPACE_DIR}/applications/url-shortener
echo "Install python url-shortener dependencies and build"
poetry install 
poetry build
echo "Done! Run the following command to start the app locally"
echo "uvicorn url_shortener.main:app --host 0.0.0.0 --port 8000 --reload --log-level debug"
