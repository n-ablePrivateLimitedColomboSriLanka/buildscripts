#!/bin/bash -x

shopt -s extglob

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

createSymbolicLinks() {
	# This function will be generalized in the future
	ln -sf IIB_CMN_ExceptionManagerLib/ExceptionManager ExceptionManager
	ln -sf IIB_CMN_LoggerLib Logger
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
	VER="${APP}_`git tag -l | tail -1`.bar"
	mqsicreatebar -data `pwd` -b "$VER" -a "$APP" $DEP -deployAsSource
}

initEnv
createSymbolicLinks
build
