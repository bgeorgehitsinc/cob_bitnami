#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load Discourse environment
. /opt/bitnami/scripts/discourse-env.sh

# Load libraries
. /opt/bitnami/scripts/libdiscourse.sh
. /opt/bitnami/scripts/libfile.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/liblog.sh

# Ensure the Discourse base directory exists and has proper permissions
info "Configuring file permissions for Discourse"
ensure_user_exists "$DISCOURSE_DAEMON_USER" --group "$DISCOURSE_DAEMON_GROUP" --system
# The backups and uploads directories are created at runtime after persistence logic, making it fail, so we create them here
declare -a writable_dirs=(
    # Skipping DISCOURSE BASE_DIR intentionally because it contains a lot of files/folders that should not be writable
    "$DISCOURSE_VOLUME_DIR"
    # Folders to persist
    "${DISCOURSE_BASE_DIR}/plugins"
    "${DISCOURSE_BASE_DIR}/public/backups"
    "${DISCOURSE_BASE_DIR}/public/uploads"
    # Folders that need to be writable for the app to work
    "${DISCOURSE_BASE_DIR}/app/assets"
    "${DISCOURSE_BASE_DIR}/log"
    "${DISCOURSE_BASE_DIR}/public"
    "${DISCOURSE_BASE_DIR}/tmp"
    # Avoid Bundle usage warnings by creating a .bundler folder in the home directory
    "$(su "$DISCOURSE_DAEMON_USER" -s "$SHELL" -c "echo ~/.bundle")"
)
for dir in "${writable_dirs[@]}"; do
    ensure_dir_exists "$dir"
    # Use daemon:root ownership for compatibility when running as a non-root user
    configure_permissions_ownership "$dir" -d "775" -f "664" -u "$DISCOURSE_DAEMON_USER" -g "$DISCOURSE_DAEMON_GROUP"
done
