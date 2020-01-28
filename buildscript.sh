#!/bin/bash

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

resolveDep() {
	cp -r ~/iiblibs/ExceptionManager .
	# This function needs to be modified in order to support any case
}

build() {
	# Find the application name
	APP=`echo ./*/application.descriptor | awk -F '/' '{print $2}'`

	# Build the bar file
	mqsicreatebar -data `pwd` -b "$1" -a "$APP" -l ExceptionManager -deployAsSource
}


initEnv
resolveDep
build "my.bar"
