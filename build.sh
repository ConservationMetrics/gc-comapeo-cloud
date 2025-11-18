#!/bin/bash

set -e

# Fetch latest semver tag from Docker Hub
LATEST_VERSION=$(curl -s "https://hub.docker.com/v2/repositories/communityfirst/comapeo-cloud/tags?page_size=100" | \
  jq -r '.results[].name' | \
  grep -E '^[0-9]+\.[0-9]+\.[0-9]+$' | \
  sort -V | \
  tail -1)

echo "Building wrapper for upstream version: $LATEST_VERSION"

TIMESTAMP=$(date +%Y%m%d)
TAG="${LATEST_VERSION}-${TIMESTAMP}"

docker build \
  --build-arg BASE_VERSION="$LATEST_VERSION" \
  -t communityfirst/gc-comapeo-cloud:latest \
  -t communityfirst/gc-comapeo-cloud:"$TAG" \
  .

echo "Pushing tags: latest, $TAG"
docker push communityfirst/gc-comapeo-cloud:latest
docker push communityfirst/gc-comapeo-cloud:"$TAG"

