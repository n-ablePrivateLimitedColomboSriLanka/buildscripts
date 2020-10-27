# iresh-s-buildscripts

## WAS deployscript invocation example:
##### Please note that the user.dir should be where the .ear files exist

```bash
/SOA/bpmdev/IBM/BPM/profiles/BPMDEVDmgr/bin/wsadmin.sh -lang jython -javaoption "-Djython.package.path=/SOA/bpmdev/IBM/BPM/plugins/com.ibm.ws.wlm.jar" -javaoption "-Duser.dir=/SOA/bpmdev/DevEnviromentEAR" -f /SOA/bpmdev/wsadmin-scripts/deploy.py
```
