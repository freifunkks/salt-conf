#!/usr/bin/env python2

from contextlib import contextmanager
from datetime import datetime

import sys
import httplib
import json
import socket
import time


SERVER_FD = 'flipdot.org'
API_FD = {
    'status': '/spacestatus/status.json',
}

SERVER_IG = 'infragelb.de'
API_IG = {
    'power': '/flipdot-power/',
}


@contextmanager
def get_socket(host, port):
    sock = socket.socket()
    sock.settimeout(1)
    sock.connect((host, port))
    yield sock
    sock.close()

def write_to_graphite(data, prefix='fd'):
    now = time.time()
    with get_socket('localhost', 2003) as s:
        for key, value in data.items():
            line = "%s.%s %s %s\n" % (prefix, key, float(value), now)
            s.sendall(line.encode('latin-1'))

def main():
    update = {}

    # Get user data
    conn = httplib.HTTPConnection(SERVER_FD)
    conn.request('GET', API_FD['status'])
    r = conn.getresponse()

    data = json.loads(r.read())
    conn.close()

    try:
        known_users = len(data['known_users'])
        known_users_names = map(lambda x: x['nick'], data['known_users'])
    except KeyError:
        known_users = 0
        known_users_names = []
    try:
        unknown_users = data['unknown_users']
    except KeyError:
        unknown_users = 0
    try:
        setpoint = data['temperature_setpoint']
    except KeyError:
        setpoint = None
    try:
        realvalue = data['temperature_realvalue']
    except KeyError:
        realvalue = None
    try:
        heater_valve = data['heater_valve']
    except KeyError:
        heater_valve = None

    all_users = known_users + unknown_users


    # Get temperature data
    # TODO: integrate power consumption in space api
    conn = httplib.HTTPConnection(SERVER_IG)
    conn.request('GET', API_IG['power'])
    power_consumption = conn.getresponse().read()
    power_consumption = power_consumption.split(',')[-1].strip()
    power_consumption = int(power_consumption)

    update['space.users_all'] = all_users
    update['space.users_known'] = known_users
    update['space.users_unknown'] = unknown_users
    update['space.power_consumption'] = power_consumption
    write_to_graphite(update)


if __name__ == "__main__":
    main()

