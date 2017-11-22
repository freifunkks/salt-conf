#!/usr/bin/env python2

from contextlib import contextmanager

import httplib
import json
import socket
import time


SERVER_FD_NG = 'api.flipdot.org'
API_FD_NG = {
    'api': '',
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
            if type(value) is dict:
                for k, v in value.items():
                    line = "%s.%s.%s %s %s\n" % (prefix, key, k, float(v), now)
                    s.sendall(line.encode('latin-1'))
            elif type(value) is list:
                for item in value:
                    # Beverages
                    if 'location' in item and 'name' in item:
                        line = "%s.%s.%s.%s.%s %s %s\n" % (prefix, key, item['location'], item['name'], item['unit'], float(item['value']), now)
                    # Heater
                    elif not 'name' in item:
                        line = "%s.%s.%s.%s %s %s\n" % (prefix, key, item['location'], item['unit'], float(item['value']), now)
                    else:
                        line = "%s.%s.%s.%s %s %s\n" % (prefix, key, item['name'], item['unit'], float(item['value']), now)
                    s.sendall(line.encode('latin-1'))
            else:
                # Must be int or something
                line = "%s.%s %s %s\n" % (prefix, key, float(value), now)
                s.sendall(line.encode('latin-1'))


def main():
    update = {}

    # Get values from the space api
    conn = httplib.HTTPSConnection(SERVER_FD_NG)
    conn.request('GET', API_FD_NG['api'])

    r = conn.getresponse()
    if r.status is not 200:
        print r.status, r.reason, "for", SERVER_FD_NG
    else:
        data = json.loads(r.read())
        sensors = data['state']['sensors']

        # user values
        try:
            known_users = len(sensors['people_now_present'][0]['names'].split(','))
        except:
            known_users = 0

        try:
            unknown_users = sensors['people_now_present'][0]['value']
        except:
            unknown_users = 0

        try:
            update['heater_setpoint'] = sensors['heater_set_point'][0]['value']
        except:
            update['heater_setpoint'] = 0

        try:
            update['heater_valve'] = sensors['heater_valve'][0]['value']
        except:
            update['heater_valve'] = 0

        try:
            update['temperature'] = sensors['temperature']
        except:
            pass

        is_open = 1 if data['open'] else 0
        all_users = known_users + unknown_users

        update['users_all'] = all_users
        update['users_known'] = known_users
        update['users_unknown'] = unknown_users
        update['is_open'] = is_open

        # co2 values: 0-3000 (unit ppm)
        try:
            co2 = sensors['co2'][0]['value']
        except KeyError:
            co2 = 0
        update['co2'] = co2

        # power
        try:
            power = sensors['power']
            power_api = []
            for i in power:
                tmp = {}
                # prefix / key
                tmp['name'] = i['location']
                tmp['unit'] = i['unit']
                tmp['value'] = i['value']
                power_api.append(tmp)

            update['power'] = power_api
        except:
            pass

        # drinks storage 0-XX per drink (unit crates)
        update['drinks'] = sensors['beverage_supply']

    conn.close()

    write_to_graphite(update)


if __name__ == "__main__":
    main()
