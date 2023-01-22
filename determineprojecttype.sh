#!/bin/bash
shopt -s globstar

PROJECT_DIR="$1"
DOT_PROJECT_FILE=$PROJECT_DIR/**/.project
POM_FILE=$PROJECT_DIR/**/pom.xml

[ -f $POM_FILE ] && grep java $POM_FILE > /dev/null && echo JAVA && exit 0

[ -f $DOT_PROJECT_FILE ] && grep projectDescription $DOT_PROJECT_FILE > /dev/null && echo ACE && exit 0

echo UNDEFINED
