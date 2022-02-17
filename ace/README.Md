# Shared Library Management

List of shared libraries are kept within a csv file in the following format,
```
<library_name>,<git_clone_url>,<path_to_lib_from_repo_root>
```
An example would be,
```
RESTRequest_SharedLibrary,https://github.com/IreshMMOut/RESTRequest_SharedLib.git,/
```
**Important:** <library_name> should be equal to the one defined in .project file which is also displayed in the toolkit.

The file should be hosted in a repository and should be accessbile via http(s). For an example,

Repository: https://github.com/IreshMMOut/ACESharedLibDirectory

HTTPS URL: https://raw.githubusercontent.com/IreshMMOut/ACESharedLibDirectory/master/libraries.csv

This file is referred to as the  "<shared_lib_directory>" in the provided Jenkinsfile template
# Understanding the placeholders in Jenkinsfile
Please refer the Jenkinsfile.example