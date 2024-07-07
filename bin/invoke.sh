#!/bin/bash

METHOD="$1"
shift 1
ARGS=("$@")

SCRIPT_DIR="$JENKINS_BUILD_SCRIPTS_DIR"
source "$SCRIPT_DIR/source.sh"
init_env

$METHOD "${ARGS[@]}"
exit $?