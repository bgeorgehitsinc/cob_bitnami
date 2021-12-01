#!/bin/bash
#
# Environment configuration for cassandra

# The values for all environment variables will be set in the below order of precedence
# 1. Custom environment variables defined below after Bitnami defaults
# 2. Constants defined in this file (environment variables with no default), i.e. BITNAMI_ROOT_DIR
# 3. Environment variables overridden via external files using *_FILE variables (see below)
# 4. Environment variables set externally (i.e. current Bash context/Dockerfile/userdata)

# Load logging library
. /opt/bitnami/scripts/liblog.sh

export BITNAMI_ROOT_DIR="/opt/bitnami"
export BITNAMI_VOLUME_DIR="/bitnami"

# Logging configuration
export MODULE="${MODULE:-cassandra}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
cassandra_env_vars=(
    CASSANDRA_CLIENT_ENCRYPTION
    CASSANDRA_CLUSTER_NAME
    CASSANDRA_DATACENTER
    CASSANDRA_ENABLE_REMOTE_CONNECTIONS
    CASSANDRA_ENABLE_RPC
    CASSANDRA_ENABLE_USER_DEFINED_FUNCTIONS
    CASSANDRA_ENDPOINT_SNITCH
    CASSANDRA_HOST
    CASSANDRA_INTERNODE_ENCRYPTION
    CASSANDRA_NUM_TOKENS
    CASSANDRA_PASSWORD_SEEDER
    CASSANDRA_SEEDS
    CASSANDRA_PEERS
    CASSANDRA_RACK
    CASSANDRA_BROADCAST_ADDRESS
    CASSANDRA_STARTUP_CQL
    CASSANDRA_IGNORE_INITDB_SCRIPTS
    CASSANDRA_CQL_PORT_NUMBER
    CASSANDRA_JMX_PORT_NUMBER
    CASSANDRA_TRANSPORT_PORT_NUMBER
    CASSANDRA_CQL_MAX_RETRIES
    CASSANDRA_CQL_SLEEP_TIME
    CASSANDRA_INIT_MAX_RETRIES
    CASSANDRA_INIT_SLEEP_TIME
    CASSANDRA_PEER_CQL_MAX_RETRIES
    CASSANDRA_PEER_CQL_SLEEP_TIME
    ALLOW_EMPTY_PASSWORD
    CASSANDRA_AUTHORIZER
    CASSANDRA_AUTHENTICATOR
    CASSANDRA_USER
    CASSANDRA_PASSWORD
    CASSANDRA_KEYSTORE_PASSWORD
    CASSANDRA_TRUSTSTORE_PASSWORD
    CASSANDRA_KEYSTORE_LOCATION
    CASSANDRA_TRUSTSTORE_LOCATION
    CASSANDRA_SSL_VALIDATE
    SSL_VERSION
)
for env_var in "${cassandra_env_vars[@]}"; do
    file_env_var="${env_var}_FILE"
    if [[ -n "${!file_env_var:-}" ]]; then
        if [[ -r "${!file_env_var:-}" ]]; then
            export "${env_var}=$(< "${!file_env_var}")"
            unset "${file_env_var}"
        else
            warn "Skipping export of '${env_var}'. '${!file_env_var:-}' is not readable."
        fi
    fi
done
unset cassandra_env_vars

# Paths
export CASSANDRA_BASE_DIR="${BITNAMI_ROOT_DIR}/cassandra"
export CASSANDRA_BIN_DIR="${CASSANDRA_BASE_DIR}/bin"
export CASSANDRA_CONF_DIR="${CASSANDRA_BASE_DIR}/conf"
export CASSANDRA_VOLUME_DIR="/bitnami/cassandra"
export CASSANDRA_DATA_DIR="${CASSANDRA_VOLUME_DIR}/data"
export CASSANDRA_COMMITLOG_DIR="${CASSANDRA_DATA_DIR}/commitlog"
export CASSANDRA_DEFAULT_CONF_DIR="${CASSANDRA_BASE_DIR}/conf.default"
export CASSANDRA_HISTORY_DIR="${HOME}/.cassandra"
export CASSANDRA_INITSCRIPTS_DIR="/docker-entrypoint-initdb.d"
export CASSANDRA_LOG_DIR="${CASSANDRA_BASE_DIR}/logs"
export CASSANDRA_MOUNTED_CONF_DIR="${CASSANDRA_VOLUME_DIR}/conf"
export CASSANDRA_TMP_DIR="${CASSANDRA_BASE_DIR}/tmp"
export JAVA_BASE_DIR="${BITNAMI_ROOT_DIR}/java"
export JAVA_BIN_DIR="${JAVA_BASE_DIR}/bin"
export PYTHON_BASE_DIR="${BITNAMI_ROOT_DIR}/python"
export PYTHON_BIN_DIR="${PYTHON_BASE_DIR}/bin"
export CASSANDRA_CONF_FILE="${CASSANDRA_CONF_DIR}/cassandra.yaml"
export CASSANDRA_LOG_FILE="${CASSANDRA_LOG_DIR}/cassandra.log"
export CASSANDRA_FIRST_BOOT_LOG_FILE="${CASSANDRA_LOG_DIR}/cassandra_first_boot.log"
export CASSANDRA_INITSCRIPTS_BOOT_LOG_FILE="${CASSANDRA_LOG_DIR}/cassandra_init_scripts_boot.log"
export CASSANDRA_PID_FILE="${CASSANDRA_TMP_DIR}/cassandra.pid"
export PATH="${CASSANDRA_BIN_DIR}:${JAVA_BIN_DIR}:${PYTHON_BIN_DIR}:${PATH}"

# System users (when running with a privileged user)
export CASSANDRA_DAEMON_USER="cassandra"
export CASSANDRA_DAEMON_GROUP="cassandra"

# Cassandra cluste serttings
export CASSANDRA_CLIENT_ENCRYPTION="${CASSANDRA_CLIENT_ENCRYPTION:-false}"
export CASSANDRA_CLUSTER_NAME="${CASSANDRA_CLUSTER_NAME:-My Cluster}"
export CASSANDRA_DATACENTER="${CASSANDRA_DATACENTER:-dc1}"
export CASSANDRA_ENABLE_REMOTE_CONNECTIONS="${CASSANDRA_ENABLE_REMOTE_CONNECTIONS:-true}"
export CASSANDRA_ENABLE_RPC="${CASSANDRA_ENABLE_RPC:-true}"
export CASSANDRA_ENABLE_USER_DEFINED_FUNCTIONS="${CASSANDRA_ENABLE_USER_DEFINED_FUNCTIONS:-false}"
export CASSANDRA_ENDPOINT_SNITCH="${CASSANDRA_ENDPOINT_SNITCH:-SimpleSnitch}"
export CASSANDRA_HOST="${CASSANDRA_HOST:-}"
export CASSANDRA_INTERNODE_ENCRYPTION="${CASSANDRA_INTERNODE_ENCRYPTION:-none}"
export CASSANDRA_NUM_TOKENS="${CASSANDRA_NUM_TOKENS:-256}"
export CASSANDRA_PASSWORD_SEEDER="${CASSANDRA_PASSWORD_SEEDER:-no}"
export CASSANDRA_SEEDS="${CASSANDRA_SEEDS:-$CASSANDRA_HOST}"
export CASSANDRA_PEERS="${CASSANDRA_PEERS:-$CASSANDRA_SEEDS}"
export CASSANDRA_RACK="${CASSANDRA_RACK:-rack1}"
export CASSANDRA_BROADCAST_ADDRESS="${CASSANDRA_BROADCAST_ADDRESS:-}"

# Database initialization settings
export CASSANDRA_STARTUP_CQL="${CASSANDRA_STARTUP_CQL:-}"
export CASSANDRA_IGNORE_INITDB_SCRIPTS="${CASSANDRA_IGNORE_INITDB_SCRIPTS:-no}"

# Port configuration
export CASSANDRA_CQL_PORT_NUMBER="${CASSANDRA_CQL_PORT_NUMBER:-9042}"
export CASSANDRA_JMX_PORT_NUMBER="${CASSANDRA_JMX_PORT_NUMBER:-7199}"
export CASSANDRA_TRANSPORT_PORT_NUMBER="${CASSANDRA_TRANSPORT_PORT_NUMBER:-7000}"

# Retries and sleep time configuration
export CASSANDRA_CQL_MAX_RETRIES="${CASSANDRA_CQL_MAX_RETRIES:-20}"
export CASSANDRA_CQL_SLEEP_TIME="${CASSANDRA_CQL_SLEEP_TIME:-5}"
export CASSANDRA_INIT_MAX_RETRIES="${CASSANDRA_INIT_MAX_RETRIES:-100}"
export CASSANDRA_INIT_SLEEP_TIME="${CASSANDRA_INIT_SLEEP_TIME:-5}"
export CASSANDRA_PEER_CQL_MAX_RETRIES="${CASSANDRA_PEER_CQL_MAX_RETRIES:-100}"
export CASSANDRA_PEER_CQL_SLEEP_TIME="${CASSANDRA_PEER_CQL_SLEEP_TIME:-10}"

# Authentication, Authorization and Credentials
export ALLOW_EMPTY_PASSWORD="${ALLOW_EMPTY_PASSWORD:-no}"
export CASSANDRA_AUTHORIZER="${CASSANDRA_AUTHORIZER:-CassandraAuthorizer}"
export CASSANDRA_AUTHENTICATOR="${CASSANDRA_AUTHENTICATOR:-PasswordAuthenticator}"
export CASSANDRA_USER="${CASSANDRA_USER:-cassandra}"
export CASSANDRA_PASSWORD="${CASSANDRA_PASSWORD:-}"
export CASSANDRA_KEYSTORE_PASSWORD="${CASSANDRA_KEYSTORE_PASSWORD:-cassandra}"
export CASSANDRA_TRUSTSTORE_PASSWORD="${CASSANDRA_TRUSTSTORE_PASSWORD:-cassandra}"
export CASSANDRA_KEYSTORE_LOCATION="${CASSANDRA_KEYSTORE_LOCATION:-${CASSANDRA_VOLUME_DIR}/secrets/keystore}"
export CASSANDRA_TRUSTSTORE_LOCATION="${CASSANDRA_TRUSTSTORE_LOCATION:-${CASSANDRA_VOLUME_DIR}/secrets/truststore}"
export CASSANDRA_TMP_P12_FILE="${CASSANDRA_TMP_DIR}/keystore.p12"
export CASSANDRA_SSL_CERT_FILE="${CASSANDRA_VOLUME_DIR}/client.cer.pem"
export SSL_CERTFILE="$CASSANDRA_SSL_CERT_FILE"
export CASSANDRA_SSL_VALIDATE="${CASSANDRA_SSL_VALIDATE:-false}"
export SSL_VALIDATE="$CASSANDRA_SSL_VALIDATE"

# cqlsh settings
export SSL_VERSION="${SSL_VERSION:-TLSv1_2}"

# Custom environment variables may be defined below
