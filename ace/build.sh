#!/bin/bash -x

shopt -s globstar

SHARED_LIBS_URL="https://raw.githubusercontent.com/IreshMMOut/ACESharedLibDirectory/master/libraries.csv"

initEnv() {
    # Setup environment for ACE toolkit    
    . /opt/ace-12.0.3.0/server/bin/mqsiprofile

    #Make sure the X server or Xvfb is running    
    if ! ( pgrep -x Xorg > /dev/null || pgrep -x Xvfb > /dev/null ); then
       # Start Xvfb    
        Xvfb :99 &
    fi

    if ! [ -n "$DISPLAY" ]; then
        # Export display environment variable    
        export DISPLAY=:99
    fi
}

resolveDependencies() {
	DEP="$1"
	python3 `dirname $0`/resolve_dependencies.py $SHARED_LIBS_URL $DEP
}

build() {
	APP="$1"
	DEP="-l $2"
	if [ -z "${2// }"]; then
		DEP=""
	fi
	# Build the bar file
	mqsicreatebar -data `pwd` -b "${APP}.bar" -a "$APP" $DEP -deployAsSource
}

APP=`xmllint --format ./**/.project | grep -oP '<name>\K\w+(?=</name>)'`
APP_PATH=`dirname ./**/.project`
DEPENDENCIES=`xmllint --format */*.descriptor \
		| grep -oP '<libraryName>\K\w+' \
		| awk 'BEGIN {lines=""} {lines = lines " " $1} END {print lines}'`

ln -sf "$APP_PATH" "$APP"

initEnv
resolveDependencies "$DEPENDENCIES"
build "$APP" "$DEPENDENCIES"
