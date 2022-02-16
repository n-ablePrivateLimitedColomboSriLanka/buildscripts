#!/usr/bin/python3
import urllib.request
import sys
import csv
import os

SHARED_LIBS_URL=sys.argv[1]
DEPENDENCIES=[]
if len(sys.argv) > 2:
    DEPENDENCIES=sys.argv[2:]

shared_libs_list_file = urllib.request.urlopen(SHARED_LIBS_URL)
reader = csv.reader([line.decode('utf-8') for line in shared_libs_list_file.readlines()])
shared_libs_list = list(reader)

shared_libs_directory = {}
for shared_lib in shared_libs_list:
    shared_libs_directory[shared_lib[0]] = shared_lib[1:]

for dependency in DEPENDENCIES:
    clone_url = shared_libs_directory[dependency][0]
    path = shared_libs_directory[dependency][1]
    repository_name = clone_url.split("/")[-1].strip(".git")

    os.system(f"git clone {clone_url}")
    os.system(f"ln -sf {repository_name}{path} {dependency}")