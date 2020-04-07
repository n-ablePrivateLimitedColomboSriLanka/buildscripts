#!/bin/bash

[ -f ./pom.xml ] && grep java ./pom.xml > /dev/null && (echo JAVA; exit)

echo NOTJAVA
