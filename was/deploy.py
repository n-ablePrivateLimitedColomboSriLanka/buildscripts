import os

# Check current working directory.
retval = os.getcwd()
print "Current working directory %s" % retval

files = os.listdir(os.getcwd())

for file_ in files:
    print (file_)
    filePath = os.getcwd() + "/" + file_
    appName = file_[0:-4]
    config = [
        "-nopreCompileJSPs",
        "-distributeApp",
        "-nouseMetaDataFromBinary",
        "-nodeployejb",
        "-appname",
        appName,
        "-createMBeansForResources",
        "-noreloadEnabled",
        "-deployws",
        "-validateinstall",
        "warn",
        "-noprocessEmbeddedConfig",
        "-filepermission",
        ".*\.dll=755#.*\.so=755#.*\.a=755#.*\.sl=755",
        "-noallowDispatchRemoteInclude",
        "-noallowServiceRemoteInclude",
        "-asyncRequestDispatchType",
        "DISABLED",
        "-nouseAutoLink",
        "-noenableClientModule",
        "-clientMode",
        "isolated",
        "-novalidateSchema",
        "-MapModulesToServers",
        [
            [
                ".*",
                ".*",
                "WebSphere:cell=soaprodmon1Cell01,cluster=BPMDEVPS.AppCluster",
            ]
        ],
        "-MetadataCompleteForModules",
        [[".*", ".*", "true"]],
    ]

    try:
        AdminApp.install(filePath, config)
        print (file_ + "has been installed")
    except:
        print ("Failed installing app: " + appName)

print ("Installations finished!, Saving configurations")
AdminConfig.save()

print ("Synchronizing active nodes in the cell")
AdminNodeManagement.syncActiveNodes()
