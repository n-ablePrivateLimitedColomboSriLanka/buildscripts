#!/bin/bash -x

shopt -s globstar

SHARED_LIBS_URL="$1"

# This should be unique and applications/libraries shouldn't use this 
# as repository directory or application name. A random string
# is appended
APPLICATION_DEFAULT_DIR="${APPLICATION_DEFAULT_DIR:-APPLICATION_5JITHW8YDN7KSW}"

resolveDependencies() {
	DEPENDENCIES="$1"
	python3 `dirname $0`/resolve_dependencies.py $SHARED_LIBS_URL $DEPENDENCIES
}

build() {
	APP_NAME="$1"
	# Build the bar file
	mqsicreatebar -data `pwd` -b "${APP_NAME}.bar" -a "$APP_NAME" -deployAsSource
}

APP_DOT_PROJECT=$APPLICATION_DEFAULT_DIR/**/.project
APP_NAME=`xmllint --format $APP_DOT_PROJECT | grep -m 1 -oP '<name>\K\N+(?=</name>)'`
APP_PATH=`dirname $APP_DOT_PROJECT`
DEPENDENCIES=`xmllint --format $APP_DOT_PROJECT \
		| grep -oP '<project>\K\N+(?=</project>)' \
		| awk 'BEGIN {lines=""} {lines = lines " " $1} END {print lines}'`

ln -sf "$APP_PATH" "$APP_NAME"

source `dirname $0`/initenv.sh
resolveDependencies "$DEPENDENCIES"
build "$APP_NAME" "$DEPENDENCIES"
echo "$APP_NAME" > appname
