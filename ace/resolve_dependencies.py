#!/usr/bin/python3
import urllib.request
import sys
import csv
import os
import xml.etree.ElementTree as ET

def get_dependencies_from_project_file(path):
    tree = ET.parse(path)
    root = tree.getroot()
    project_elements = root.findall("./projects/*")
    return [project_element.text for project_element in project_elements]

def get_shared_lib_directory(url):
    shared_libs_list_file = urllib.request.urlopen(url)
    reader = csv.reader(
        [line.decode("utf-8") for line in shared_libs_list_file.readlines()]
    )
    shared_libs_list = list(reader)
    shared_libs_directory = {}
    for shared_lib in shared_libs_list:
        shared_libs_directory[shared_lib[0]] = shared_lib[1:]
    return shared_libs_directory


SHARED_LIBS_URL = sys.argv[1]
PROJECT_FILE_PATH = sys.argv[2]
BRANCH_NAME=sys.argv[3]

shared_libs_directory = get_shared_lib_directory(SHARED_LIBS_URL)
root_dependencies = get_dependencies_from_project_file(PROJECT_FILE_PATH)

dependency_stack = []
dependency_stack.extend(root_dependencies)
checked_out_dependencies = {}

while len(dependency_stack) > 0:
    cur_dependency = dependency_stack.pop()
    # Process the current dependency
    if cur_dependency in shared_libs_directory and not checked_out_dependencies.get(cur_dependency):
        clone_url = shared_libs_directory[cur_dependency][0]
        path = shared_libs_directory[cur_dependency][1]
        repository_name = clone_url.split("/")[-1].strip(".git")
        clone_cmd = f"git clone --branch {BRANCH_NAME} {clone_url}"
        print(clone_cmd)
        os.system(clone_cmd)
        os.system(f"ln -sf {repository_name}{path} {cur_dependency}")
        checked_out_dependencies[cur_dependency] = True
        transitive_dependencies = get_dependencies_from_project_file(f"{cur_dependency}/.project")
        dependency_stack.extend(transitive_dependencies)

