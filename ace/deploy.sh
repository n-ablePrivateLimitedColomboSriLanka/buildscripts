#!/bin/bash

NODE_SPEC="$1"
SERVER="$2"
source `dirname $0`/initenv.sh
mqsideploy $NODE_SPEC -e $SERVER -a `echo *.bar`