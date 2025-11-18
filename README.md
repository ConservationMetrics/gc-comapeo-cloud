# gc-comapeo-cloud

Wrapper Docker image for [CoMapeo Cloud](https://github.com/digidem/comapeo-cloud) that handles mounted volume permissions for CapRover deployments.

## Why This Wrapper?

The [`comapeo-cloud`](https://github.com/digidem/comapeo-cloud) Dockerfile runs as a non-root `node` user, which can't write to mounted volumes without proper permissions. This wrapper:

1. Starts as `root` 
2. Creates and `chown`s the `STORAGE_DIR` to `node:node`
3. Drops privileges back to `node` user
4. Executes the original CoMapeo Cloud command

## CapRover One-Click App

See the [`comapeo-cloud.yml`](https://github.com/ConservationMetrics/gc-deploy/blob/main/caprover/one-click-apps/v4/apps/comapeo-cloud.yml) file in the `gc-deploy` repository for the one-click app configuration.

## Deployment

Images are automatically built weekly (every Monday) and pushed to Docker Hub as `communityfirst/gc-comapeo-cloud:latest`. The [`build.sh`](build.sh) script fetches the latest upstream CoMapeo Cloud version and wraps it. You can also trigger builds manually via GitHub Actions.