initEnv() {
    # Setup environment for ACE toolkit    
    ACE_INSTALLATION=/opt/ibm/ace-12
    . $ACE_INSTALLATION/server/bin/mqsiprofile

    export CLASSPATH=$ACE_INSTALLATION/server/messages:$ACE_INSTALLATION/common/classes:$ACE_INSTALLATION/server/classes:$ACE_INSTALLATION/common/classes/IntegrationAPI.jar:$ACE_INSTALLATION/server/classes/brokerutil.jar:/var/mqsi/common/wsrr

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

initEnv
