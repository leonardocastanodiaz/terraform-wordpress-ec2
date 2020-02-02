import os
import sys
import xml.etree.ElementTree as elementTree

root = sys.argv[1]


def update_xml_element(path, element, new_value):
    tree = elementTree.parse(path)
    xml_root = tree.getroot()
    for node in xml_root.iter(element):
        node.text = new_value

    tree.write(path)


def edit_build_configs(builds):
    for build in builds:
        if build.is_dir():
            with os.scandir(build.path) as buildFiles:
                for buildFile in buildFiles:
                    if buildFile.name == 'build.xml':
                        update_xml_element(buildFile.path, 'node', '(master)')


def update_job(job_dir):
    with os.scandir(job_dir.path) as job_files:
        for job_file in job_files:
            if job_file.name == 'builds':
                with os.scandir(job_file.path) as builds:
                    edit_build_configs(builds)


with os.scandir(root) as jobs:
    for job in jobs:
        if job.is_dir():
            update_job(job)
