#!/usr/bin/env python

import json
import requests
from contextlib import contextmanager
import time
import socket
import logging

logger = logging.getLogger(__name__)

@contextmanager
def get_socket(host, port):
    sock = socket.socket()
    sock.settimeout(1)
    sock.connect((host, port))
    yield sock
    sock.close()


def write_to_graphite(data, prefix='fffd'):
    now = time.time()
    with get_socket('nms.services.fffd', 2003) as s:
        for key, value in data.items():
            line = "%s.%s %s %s\n" % (prefix, key, float(value), now)
            s.sendall(line.encode('latin-1'))

def main():
    logging.basicConfig(level=logging.WARN)

    URL = 'http://meshviewer.fulda.freifunk.net/data/nodes.json'

    gateways = []

    try:
        client_count = 0

        data = requests.get(URL, timeout=1).json()
        nodes = data['nodes']
        known_nodes = len(nodes.keys())
        online_nodes = 0
        update = {}
        gateway_count = 0
        for node_mac, node in nodes.items():
            try:
                hostname = node['nodeinfo']['hostname']

                flags = node['flags']
                if flags['online']:
                  online_nodes += 1

                if flags['gateway']:
                  gateway_count += 1
                  gateways.append(hostname)

                statistics = node['statistics']
                try:
                  loadavg = statistics['loadavg']
                  update['%s.loadavg' % hostname] = loadavg
                except KeyError:
                  pass
                try:
                  uptime = statistics['uptime']
                  update['%s.uptime' % hostname] = uptime
                except KeyError:
                  pass
                try:
                  mem = statistics['memory_usage']
                  update['%s.memory' % hostname] = mem
                except KeyError:
                  pass

                try:
                  clients = statistics['clients']
                  client_count += int(clients)
                  update['%s.clients' % hostname] = clients
                except KeyError:
                  pass

                try:
                  traffic = statistics['traffic']
                  for key in ['tx', 'rx', 'mgmt_tx', 'mgmt_rx', 'forward']:
                      update['%s.traffic.%s.packets' % (hostname, key)] = traffic[key]['packets']
                      update['%s.traffic.%s.bytes' % (hostname, key)] = traffic[key]['bytes']
                except KeyError:
                  pass
            except KeyError as e:
                print(time.time())
                print('error while reading ', node_mac)

        update['clients'] = client_count
        update['known_nodes'] = known_nodes
        update['online_nodes'] = online_nodes
        update['gateways'] = gateway_count
        write_to_graphite(update)
    except Exception as e:
        print(e)

if __name__ == "__main__":
    main()

