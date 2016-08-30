#!/usr/bin/env python2

from contextlib import contextmanager
from datetime import datetime

import httplib
import json
import socket
import sys
import time
import logging
import re

SERVER_DISCOURSE = 'fd.cfs.im'
API_DISCOURSE = {
    'stats': '/admin/dashboard.json',
    'api_key': '{{ pillar.discourse.api_key }}',
    'api_username': 'Mailinglisten-Dummy'
}

logger = logging.getLogger(__name__)

want_values = {
    # input : output
    "version_check.missing_versions_count": "version.behind_stable",
#    "updated_at": "timestamp",
    "moderators": "users.moderators",
    "admins": "users.admins",
    "suspended": "users.suspended",
    "disk_space.uploads_used": "disk.uploads",
    "disk_space.backups_used": "disk.backups",
    "disk_space.backups_free": "disk.free",
}

SI = {'y': 1e-24,  # yocto
       'z': 1e-21,  # zepto
       'a': 1e-18,  # atto
       'f': 1e-15,  # femto
       'p': 1e-12,  # pico
       'n': 1e-9,   # nano
       'u': 1e-6,   # micro
       'm': 1e-3,   # mili
       'c': 1e-2,   # centi
       'd': 1e-1,   # deci
       'k': 1e3,    # kilo
       'M': 1e6,    # mega
       'G': 1e9,    # giga
       'T': 1e12,   # tera
       'P': 1e15,   # peta
       'E': 1e18,   # exa
       'Z': 1e21,   # zetta
       'Y': 1e24,   # yotta
}

RE_NUM = re.compile("^(\d*(?:\.\d*)?)\s*(?:(\w)B)?$")


def convert_si(value):
    match = RE_NUM.match(str(value))
    if match:
        groups = match.groups()
        if len(groups) == 1 or groups[1] is None:
            return float(groups[0])
        value = float(groups[0])
        value *= SI[groups[1]]
        return value
    return value


@contextmanager
def get_socket(host, port):
    sock = socket.socket()
    sock.settimeout(1)
    sock.connect((host, port))
    yield sock
    sock.close()


def write_to_graphite(data, prefix='fd.comms.forums'):
    now = time.time()
    with get_socket('localhost', 2003) as s:
        for key, value in data.items():
            line = "%s.%s %f %s\n" % (prefix, key, float(value), now)
            s.sendall(line.encode('latin-1'))


def main():
    logging.basicConfig(level=logging.INFO)
    update = {}

    # Get Forum stats
    conn = httplib.HTTPSConnection(SERVER_DISCOURSE)
    conn.request('GET', API_DISCOURSE['stats'] +
                 "?api_key=" + API_DISCOURSE['api_key'])
    r = conn.getresponse()
    if r.status is not 200:
        logger.error("%s %s for %s", r.status, r.reason, SERVER_DISCOURSE)
    else:
        stats_str = r.read()
        logging.debug(stats_str)
        stats = json.loads(stats_str)
        logging.debug(json.dumps(stats, indent=2))

        for key, map_key in want_values.iteritems():
            node = stats
            for pathelem in key.split('.'):
                if pathelem not in node:
                    logger.warn("key %s not found.", key)
                    node = None
                    break
                node = node[pathelem]
            if node is not None:
                update[map_key] = convert_si(node)

        for report in stats['global_reports']:
            if report['type'] == "posts":
                update['posts.total'] = report['total']
            elif report['type'] == "topics":
                update['topics.total'] = report['total']
            elif report['type'] == "signups":
                update['signups.total'] = report['total']
            elif report['type'] == "likes":
                update['likes.total'] = report['total']
            elif report['type'] == "visits":
                update['visits.total'] = report['total']

    conn.close()
    write_to_graphite(update)


if __name__ == "__main__":
    main()
