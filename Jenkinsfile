pipeline {
	agent any

	stages {
		stage('Checkout buildscript') {
			steps {
				sh '''cd ~/.buildscripts/iib/iresh-s-buildscripts'''
				sh '''git reset HEAD --hard && git pull'''
			}
		}
		stage('Build') {
			steps {
				sh '''~/.buildscripts/iib/iresh-s-buildscripts/buildscript.sh'''
			}
		}
	}
}
