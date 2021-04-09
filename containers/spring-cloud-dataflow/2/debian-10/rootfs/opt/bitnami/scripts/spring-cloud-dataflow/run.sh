#!/bin/bash
#
# Bitnami Spring Cloud Data Flow run

# shellcheck disable=SC1091,SC2153

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load libraries
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libos.sh

# Load Spring Cloud Data Flow environment variables
. /opt/bitnami/scripts/spring-cloud-dataflow-env.sh

info "** Starting Spring Cloud Data Flow **"

__run_cmd="java"
read -r -a java_opts <<< "$JAVA_OPTS"
__run_flags=("-jar" "-Duser.home=${HOME}" "${SPRING_CLOUD_DATAFLOW_BASE_DIR}/spring-cloud-dataflow.jar" "--spring.config.additional-location=${SPRING_CLOUD_DATAFLOW_CONF_FILE}" "$@")
[[ "${#java_opts[@]}" -gt 0 ]] && __run_flags=("${java_opts[@]}" "${__run_flags[@]}")

if am_i_root; then
    exec gosu "$SPRING_CLOUD_DATAFLOW_DAEMON_USER" "$__run_cmd" "${__run_flags[@]}"
else
    exec "$__run_cmd" "${__run_flags[@]}"
fi
