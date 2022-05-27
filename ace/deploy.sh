#!/bin/bash -x

NODE_SPEC="$1"
SERVER="$2"
source `dirname $0`/initenv.sh
APP="$(cat appname)"
mqsideploy $NODE_SPEC -e $SERVER -a "${APP}.bar"
