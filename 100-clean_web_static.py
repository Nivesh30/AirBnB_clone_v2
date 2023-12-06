#!/usr/bin/python3
"""
Fabric script (100-clean_web_static.py) to delete out-of-date archives
"""
from fabric.api import env, run, local
from datetime import datetime
import os

env.hosts = ['<IP web-01>', '<IP web-02>']


def do_clean(number=0):
    """Deletes out-of-date archives"""
    number = int(number)
    if number < 2:
        number = 1
    else:
        number += 1

    local_archives = sorted(os.listdir("versions"))
    delete_local = local_archives[:-number]
    for archive in delete_local:
        local("rm versions/{}".format(archive))

    remote_archives = run("ls -1 /data/web_static/releases").split()
    delete_remote = sorted(remote_archives)[:-number]
    for archive in delete_remote:
        run("rm -rf /data/web_static/releases/{}".format(archive))
