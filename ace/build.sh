#!/bin/bash -x

shopt -s extglob

SHARED_LIBS_URL="https://raw.githubusercontent.com/IreshMMOut/ACESharedLibDirectory/master/libraries.csv"

initEnv() {
    # Setup environment for ACE toolkit    
    . /opt/IBM/ace-11.0.0.7/server/bin/mqsiprofile

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
	DEP=`xmllint --format */@(restapi|application).descriptor \
		| grep -oP '<libraryName>\K\w+' \
		| awk 'BEGIN {lines=""} {lines = lines " " $1} END {print lines}'`
	python3 `dirname $0`/resolve_dependencies.py $SHARED_LIBS_URL $DEP
}

build() {
	#Clean existing bar files
	rm -rf *.bar

	# Find the application name
	APP=`echo ./*/@(restapi|application).descriptor | awk -F '/' '{print $2}'`

	# Build dependency string
	DEP=`xmllint --format */@(restapi|application).descriptor \
		| grep -oP '<libraryName>\K\w+' \
		| awk 'BEGIN {lines="-l"} {lines = lines " " $1} END {if(lines!="-l") print lines}'`
	# Build the bar file
	mqsicreatebar -data `pwd` -b ${APP}.bar -a "$APP" $DEP -deployAsSource
}


initEnv
resolveDependencies
build
