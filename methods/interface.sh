#!/bin/bash

function create_git_release_tag() {
    local TAG="$1"
    local MESSAGE="$2"
    echo "TAG: $TAG"
    echo "MESSAGE: $MESSAGE"
    
    if ! git rev-parse "$TAG" >/dev/null 2>&1; then
        git tag "$TAG" -m "$MESSAGE"
    fi
}

function git_commit() {
    local BRANCH="$1"
    local MESSAGE="$2"
    local SUB_PATH="${3:-'.'}"
    echo "SUB_PATH: $SUB_PATH"
    echo "BRANCH: $BRANCH"
    echo "MESSAGE: $MESSAGE"
    cd "$SUB_PATH"
    git checkout "$BRANCH"
    git add -A
    git commit -m "$MESSAGE"
}

function git_push_ref() {
    local REMOTE="$1"
    local REF="$2"
    local GIT_CRED="$3"
    local SUB_PATH="${4:-'.'}"
    echo "REMOTE: $REMOTE"
    echo "REF: $REF"
    echo "SUB_PATH: $SUB_PATH"

    cd "$SUB_PATH"
    git_with_basic_auth "$GIT_CRED" push -u origin "$REF"
}

function is_ref_up_to_date() {
    local BASE_REF="$1"
    local HEAD_REF="$2"
    git merge-base --is-ancestor "origin/${BASE_REF}" "$HEAD_REF" 
    return $?
}

function get_repository_type() {
    set -x
    REPO_PATH="$1"
    (is_repository_java $REPO_PATH && echo "JAVA") || \
    (is_respository_ace $REPO_PATH && echo "ACE") || \
    echo "UNDEFINED"
}