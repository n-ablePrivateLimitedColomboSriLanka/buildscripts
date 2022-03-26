#!/bin/bash -x

shopt -s globstar

SHARED_LIBS_URL="$1"

resolveDependencies() {
	DEP="$1"
	python3 `dirname $0`/resolve_dependencies.py $SHARED_LIBS_URL $DEP
}

build() {
	APP_NAME="$1"
	# Build the bar file
	mqsicreatebar -data `pwd` -b "${APP_NAME}.bar" -a "$APP_NAME" -deployAsSource
}

APP=`xmllint --format ./**/.project | grep -m 1 -oP '<name>\K\N+(?=</name>)'`
APP_PATH=`dirname ./**/.project`
DEPENDENCIES=`xmllint --format ./**/.project \
		| grep -oP '<project>\K\N+(?=</project>)' \
		| awk 'BEGIN {lines=""} {lines = lines " " $1} END {print lines}'`

ln -sf "$APP_PATH" "$APP"

source `dirname $0`/initenv.sh
resolveDependencies "$DEPENDENCIES"
build "$APP" "$DEPENDENCIES"
echo "$APP" > appname
