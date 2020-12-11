#!/bin/bash
#
# Environment configuration for rabbitmq

# The values for all environment variables will be set in the below order of precedence
# 1. Custom environment variables defined below after Bitnami defaults
# 2. Constants defined in this file (environment variables with no default), i.e. BITNAMI_ROOT_DIR
# 3. Environment variables overridden via external files using *_FILE variables (see below)
# 4. Environment variables set externally (i.e. current Bash context/Dockerfile/userdata)

export BITNAMI_ROOT_DIR="/opt/bitnami"
export BITNAMI_VOLUME_DIR="/bitnami"

# Logging configuration
export MODULE="${MODULE:-rabbitmq}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
rabbitmq_env_vars=(
    RABBITMQ_CLUSTER_NODE_NAME
    RABBITMQ_CLUSTER_PARTITION_HANDLING
    RABBITMQ_DISK_FREE_RELATIVE_LIMIT
    RABBITMQ_DISK_FREE_ABSOLUTE_LIMIT
    RABBITMQ_ERL_COOKIE
    RABBITMQ_LOAD_DEFINITIONS
    RABBITMQ_MANAGER_BIND_IP
    RABBITMQ_MANAGER_PORT_NUMBER
    RABBITMQ_NODE_NAME
    RABBITMQ_NODE_PORT_NUMBER
    RABBITMQ_NODE_TYPE
    RABBITMQ_VHOST
    RABBITMQ_USERNAME
    RABBITMQ_PASSWORD
    RABBITMQ_FORCE_BOOT
    RABBITMQ_ENABLE_LDAP
    RABBITMQ_LDAP_TLS
    RABBITMQ_LDAP_SERVERS
    RABBITMQ_LDAP_SERVERS_PORT
    RABBITMQ_LDAP_USER_DN_PATTERN
    RABBITMQ_LOGS
)
for env_var in "${rabbitmq_env_vars[@]}"; do
    file_env_var="${env_var}_FILE"
    if [[ -n "${!file_env_var:-}" ]]; then
        export "${env_var}=$(< "${!file_env_var}")"
        unset "${file_env_var}"
    fi
done
unset rabbitmq_env_vars

# Paths
export RABBITMQ_VOLUME_DIR="/bitnami/rabbitmq"
export RABBITMQ_BASE_DIR="/opt/bitnami/rabbitmq"
export RABBITMQ_BIN_DIR="${RABBITMQ_BASE_DIR}/sbin"
export RABBITMQ_DATA_DIR="${RABBITMQ_VOLUME_DIR}/mnesia"
export RABBITMQ_CONF_DIR="${RABBITMQ_BASE_DIR}/etc/rabbitmq"
export RABBITMQ_CONF_FILE="${RABBITMQ_CONF_DIR}/rabbitmq.conf"
export RABBITMQ_CONF_ENV_FILE="${RABBITMQ_CONF_DIR}/rabbitmq-env.conf"
export RABBITMQ_HOME_DIR="${RABBITMQ_BASE_DIR}/.rabbitmq"
export RABBITMQ_LIB_DIR="${RABBITMQ_BASE_DIR}/var/lib/rabbitmq"
export RABBITMQ_LOG_DIR="${RABBITMQ_BASE_DIR}/var/log/rabbitmq"
export RABBITMQ_PLUGINS_DIR="${RABBITMQ_BASE_DIR}/plugins"
export RABBITMQ_MOUNTED_CONF_DIR="${RABBITMQ_VOLUME_DIR}/conf"
export PATH="${RABBITMQ_BIN_DIR}:${PATH}"

# System users (when running with a privileged user)
export RABBITMQ_DAEMON_USER="rabbitmq"
export RABBITMQ_DAEMON_GROUP="rabbitmq"

# RabbitMQ settings
export RABBITMQ_CLUSTER_NODE_NAME="${RABBITMQ_CLUSTER_NODE_NAME:-}"
export RABBITMQ_CLUSTER_PARTITION_HANDLING="${RABBITMQ_CLUSTER_PARTITION_HANDLING:-ignore}"
export RABBITMQ_DISK_FREE_RELATIVE_LIMIT="${RABBITMQ_DISK_FREE_RELATIVE_LIMIT:-1.0}"
export RABBITMQ_DISK_FREE_ABSOLUTE_LIMIT="${RABBITMQ_DISK_FREE_ABSOLUTE_LIMIT:-}"
export RABBITMQ_ERL_COOKIE="${RABBITMQ_ERL_COOKIE:-}"
export RABBITMQ_LOAD_DEFINITIONS="${RABBITMQ_LOAD_DEFINITIONS:-no}"
export RABBITMQ_MANAGER_BIND_IP="${RABBITMQ_MANAGER_BIND_IP:-0.0.0.0}"
export RABBITMQ_MANAGER_PORT_NUMBER="${RABBITMQ_MANAGER_PORT_NUMBER:-15672}"
export RABBITMQ_NODE_NAME="${RABBITMQ_NODE_NAME:-rabbit@localhost}"
export RABBITMQ_NODE_PORT_NUMBER="${RABBITMQ_NODE_PORT_NUMBER:-5672}"
export RABBITMQ_NODE_TYPE="${RABBITMQ_NODE_TYPE:-stats}"
export RABBITMQ_VHOST="${RABBITMQ_VHOST:-/}"

# RabbitMQ authentication
export RABBITMQ_USERNAME="${RABBITMQ_USERNAME:-user}"
export RABBITMQ_PASSWORD="${RABBITMQ_PASSWORD:-bitnami}"

# Force boot cluster
export RABBITMQ_FORCE_BOOT="${RABBITMQ_FORCE_BOOT:-no}"

# LDAP
export RABBITMQ_ENABLE_LDAP="${RABBITMQ_ENABLE_LDAP:-no}"
export RABBITMQ_LDAP_TLS="${RABBITMQ_LDAP_TLS:-no}"
export RABBITMQ_LDAP_SERVERS="${RABBITMQ_LDAP_SERVERS:-}"
export RABBITMQ_LDAP_SERVERS_PORT="${RABBITMQ_LDAP_SERVERS_PORT:-389}"
export RABBITMQ_LDAP_USER_DN_PATTERN="${RABBITMQ_LDAP_USER_DN_PATTERN:-}"

# RabbitMQ native environment variables (see https://www.rabbitmq.com/relocate.html)
export RABBITMQ_MNESIA_BASE="$RABBITMQ_DATA_DIR"

# Print all log messages to standard output
export RABBITMQ_LOGS="${RABBITMQ_LOGS:--}"

# Custom environment variables may be defined below
