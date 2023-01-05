#!/bin/bash

PROJECT_DIR="$1"

[ -f $PROJECT_DIR/pom.xml ] && grep java $PROJECT_DIR/pom.xml > /dev/null && echo JAVA && exit 0

[ -f $PROJECT_DIR/.project ] && grep projectDescription $PROJECT_DIR/.project > /dev/null && echo ACE && exit 0

echo UNDEFINED
