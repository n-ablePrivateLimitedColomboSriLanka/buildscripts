initEnv() {
    # Setup environment for ACE toolkit    
    . /opt/ace-12.0.3.0/server/bin/mqsiprofile

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