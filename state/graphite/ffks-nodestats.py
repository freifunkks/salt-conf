#!/usr/bin/env python3

import json
import sys
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

def write_to_graphite(data, prefix='ffks'):
    now = time.time()
    with get_socket('localhost', 2003) as s:
        for key, value in data.items():
            line = "%s.%s %s %s\n" % (prefix, key, float(value), now)
            s.sendall(line.encode('latin-1'))

def main():
    logging.basicConfig(level=logging.WARN)

    path = '/home/ffks-map/meshviewer/build/data/nodes.json'

    gateways = []

    try:
        client_count = 0

        data = json.load(open(path, 'r'))
        nodes = data['nodes']
        known_nodes = len(nodes.keys())
        online_nodes = 0
        update = {}
        gateway_count = 0
        for node_mac, node in nodes.items():
            try:
                hostname = node['nodeinfo']['hostname'].replace('.', '-')

                flags = node['flags']
                if flags['online']:
                  online_nodes += 1

                if flags['gateway']:
                  gateway_count += 1
                  gateways.append(hostname)

                statistics = node['statistics']
                try:
                  loadavg = statistics['loadavg']
                  update['nodes.%s.loadavg' % hostname] = loadavg
                except KeyError:
                  pass
                try:
                  uptime = statistics['uptime']
                  update['nodes.%s.uptime' % hostname] = uptime
                except KeyError:
                  pass
                try:
                  mem = statistics['memory_usage']
                  update['nodes.%s.memory' % hostname] = mem
                except KeyError:
                  pass

                try:
                  clients = statistics['clients']
                  client_count += int(clients)
                  update['nodes.%s.clients' % hostname] = clients
                except KeyError:
                  pass

                try:
                  traffic = statistics['traffic']
                  for key in ['tx', 'rx', 'mgmt_tx', 'mgmt_rx', 'forward']:
                      update['nodes.%s.traffic.%s.packets' % (hostname, key)] = traffic[key]['packets']
                      update['nodes.%s.traffic.%s.bytes' % (hostname, key)] = traffic[key]['bytes']
                except KeyError:
                  pass
            except KeyError as e:
                print(time.time())
                print('error while reading ', node_mac)

        update['collect.clients'] = client_count
        update['collect.known_nodes'] = known_nodes
        update['collect.online_nodes'] = online_nodes
        update['collect.gateways'] = gateway_count
        write_to_graphite(update)
    except Exception as e:
        print(e)

if __name__ == "__main__":
    main()

