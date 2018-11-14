#!/usr/bin/env python
# -*- coding: utf-8 -*-
import socket
import sys

def check_server_port(address, port):
    s = socket.socket()
    print("Connecting to %s on port %s" % (address, port))
    try:
        s.connect((address, port))
        print("Successfully connected to %s:%s" % (address, port))
        return True
    except socket.error as e:
        print("Connection to %s:%s failed. Reason: %s" % (address, port, e))
        return False

if __name__ == '__main__':
    import argparse    
    parser = argparse.ArgumentParser(description='Script for checking tcp port.')
    parser.add_argument('-a', '--address', dest='address', default='localhost', help='IP addres for check', metavar='ADDRESS')
    parser.add_argument('-p', '--port', dest='port', type=int, default=80, help='Port for check', metavar='ADDRESS')
    args = parser.parse_args()

    result = check_server_port(args.address, args.port)
    sys.exit(not result)

