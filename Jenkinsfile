pipeline {
	agent any

	stages {
		stage('Checkout buildscript') {
			sh '''cd ~/.buildscripts/iib/iresh-s-buildscripts'''
			sh '''git reset HEAD --hard && git pull'''
		}
		stage('Build') {
			sh '''~/.buildscripts/iib/iresh-s-buildscripts/buildscript.sh'''
		}
	}
}
