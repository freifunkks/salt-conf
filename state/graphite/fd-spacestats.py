#!/usr/bin/env python2

from contextlib import contextmanager

import httplib
import json
import socket
import time


SERVER_FD = 'flipdot.org'
API_FD = {
    'status': '/spacestatus/status.json',
}

SERVER_FD_NG = 'api.flipdot.org'
API_FD_NG = {
    'api': '',
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


def write_to_graphite(data, prefix='fd.space'):
    now = time.time()
    with get_socket('localhost', 2003) as s:
        for key, value in data.items():
            line = "%s.%s %s %s\n" % (prefix, key, float(value), now)
            s.sendall(line.encode('latin-1'))


def main():
    update = {}

    # Get user data
    conn = httplib.HTTPSConnection(SERVER_FD)
    conn.request('GET', API_FD['status'])

    r = conn.getresponse()
    if r.status is not 200:
        print r.status, r.reason, "for", SERVER_FD
    else:
        data = json.loads(r.read())

        try:
            known_users = len(data['known_users'])
        except KeyError:
            known_users = 0

        try:
            unknown_users = data['unknown_users']
        except KeyError:
            unknown_users = 0

        try:
            update['heater_setpoint'] = data['temperature_setpoint']
        except:
            pass

        try:
            update['heater_temperature'] = data['temperature_realvalue']
        except:
            pass

        try:
            update['heater_valve'] = data['heater_valve']
        except:
            pass

        try:
            is_open = 1 if data['open'] else 0
        except KeyError:
            is_open = 0

        all_users = known_users + unknown_users

        update['users_all'] = all_users
        update['users_known'] = known_users
        update['users_unknown'] = unknown_users
        update['is_open'] = is_open

    conn.close()

    # Get the API stuff like co2 sensor
    conn = httplib.HTTPSConnection(SERVER_FD_NG)
    conn.request('GET', API_FD_NG['api'])

    r = conn.getresponse()
    if r.status is not 200:
        print r.status, r.reason, "for", SERVER_IG
    else:
        data = json.loads(r.read())

    # co2 values: 0-3000 (unit ppm)
        try:
            co2 = data['state']['sensors']['co2'][0]['value']
        except KeyError:
            co2 = 0
        update['co2'] = co2

    conn.close()

    # Get temperature data
    # TODO: integrate power consumption in space api
    conn = httplib.HTTPConnection(SERVER_IG)
    conn.request('GET', API_IG['power'])

    r = conn.getresponse()
    if r.status is not 200:
        print r.status, r.reason, "for", SERVER_IG
    else:
        power_consumption = r.read()
        power_consumption = power_consumption.split(',')[-1].strip()
        power_consumption = int(power_consumption)

        update['power_consumption'] = power_consumption

    conn.close()
    write_to_graphite(update)


if __name__ == "__main__":
    main()
