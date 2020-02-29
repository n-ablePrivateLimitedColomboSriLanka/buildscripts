#!/bin/bash -x

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
	cp -rn /home/jenkins/iib/libs/* .
	# This function needs to be modified in order to support any case
}

build() {
	# Find the application name
	APP=`echo ./*/application.descriptor | awk -F '/' '{print $2}'`

	# Build dependency string
	DEP=`xmllint --format */application.descriptor \
		| grep -oP '<libraryName>\K\w+' \
		| awk 'BEGIN {lines="-l"} {lines = lines " " $1} END {print lines}'`
	# Build the bar file
	VER="${APP}_`git tag -l | tail -1`.bar"
	mqsicreatebar -data `pwd` -b "$VER" -a "$APP" $DEP -deployAsSource
}

checkoutLatestLibs() {
	CUR_DIR=`pwd`
	cd /home/jenkins/iib/repositories
	for dir in *;do 
		git reset --hard HEAD && git pull
	done;
	cd $CUR_DIR
}


initEnv
resolveDep
build
