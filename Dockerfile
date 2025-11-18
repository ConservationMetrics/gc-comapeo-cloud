# Wrapper around communityfirst/comapeo-cloud that handles permissions for mounted volumes
# This allows CapRover to mount /data without requiring SSH pre-setup

ARG BASE_VERSION=latest
FROM communityfirst/comapeo-cloud:${BASE_VERSION}

# Switch to root to install gosu and set up entrypoint
USER root

# Install gosu for dropping privileges (Debian-based)
RUN apt-get update && \
    apt-get install -y --no-install-recommends gosu && \
    rm -rf /var/lib/apt/lists/* && \
    gosu nobody true

# Copy our entrypoint that will chown STORAGE_DIR and drop to node user
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Use our entrypoint with the base image's CMD
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["dumb-init", "npm", "start"]

