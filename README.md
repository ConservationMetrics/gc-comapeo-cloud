# gc-comapeo-cloud

Wrapper Docker image for [CoMapeo Cloud](https://github.com/digidem/comapeo-cloud) that handles mounted volume permissions for CapRover deployments.

## Why This Wrapper?

The [`comapeo-cloud`](https://github.com/digidem/comapeo-cloud) Dockerfile runs as a non-root `node` user, which can't write to mounted volumes without proper permissions. 

This wrapper:

1. Starts as `root` 
2. Creates and `chown`s the `STORAGE_DIR` to `node:node`
3. Drops privileges back to `node` user
4. Executes the original CoMapeo Cloud command

## Storage Directory

The `STORAGE_DIR` (default: `/data`) contains three critical components:

- **`db/`** - SQLite databases storing project data and encrypted hypercore keys
- **`core/`** - Hypercore data structures
- **`root-key`** - A random 128-bit key used to:
  - Derive the server's public-private keypair (identifies the server to sync clients)
  - Encrypt the hypercore encryption keys stored in the database
  - Decrypt encryption keys for hypercores (all hypercores are encrypted at rest)
  - Sign and validate hypercore entries

If the server has no data or hasn't been added to projects, it's safe to start without a root-key (one will be generated). However, once the server is in use, **always back up the entire `STORAGE_DIR`** including the `root-key`.

## CapRover One-Click App

See the [`comapeo-cloud.yml`](https://github.com/ConservationMetrics/gc-deploy/blob/main/caprover/one-click-apps/v4/apps/comapeo-cloud.yml) file in the `gc-deploy` repository for the one-click app configuration.

## Deployment

Images are automatically built weekly (every Monday) and pushed to Docker Hub as `communityfirst/gc-comapeo-cloud:latest`. The [`build.sh`](build.sh) script fetches the latest upstream CoMapeo Cloud version and wraps it. You can also trigger builds manually via GitHub Actions.