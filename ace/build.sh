#!/bin/bash -x

createSymbolicLinks() {
	# This function will be generalized in the future
	ln -s IIB_CMN_ExceptionManagerLib/ExceptionManager ExceptionManager
	ln -s IIB_CMN_LoggerLib Logger
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

initEnv
createSymbolicLinks
