#!/bin/bash

function git_with_basic_auth() {
    local GIT_CRED="$1"
    shift 1
    git -c http.extraheader="Authorization: Basic $(echo -n "$GIT_CRED" | base64)" "$@"
}

function init_env() {
    git config --global --add safe.directory "*"
    git config --global user.name "Jenkins"
    git config --global user.email "contact@jenkins.com"
}

function is_repository_java() {
    shopt -s globstar
    REPO_PATH="$1"
    POM_FILE=$REPO_PATH/**/pom.xml
    [ -f $POM_FILE ] && \
        grep java $POM_FILE > /dev/null && \
        return 0 || \
        return 1
}

function is_respository_ace() {
    shopt -s globstar
    REPO_PATH="$1"
    DOT_PROJECT_FILE=$REPO_PATH/**/.project
    [ -f $DOT_PROJECT_FILE ] && \
        grep projectDescription $DOT_PROJECT_FILE > /dev/null && \
        return 0 || \
        return 1
}
