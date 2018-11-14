#!/usr/bin/env python
# -*- coding: utf-8 -*-
from sys import exit

class outputColors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'

    def disable(self):
        self.HEADER = ''
        self.OKBLUE = ''
        self.OKGREEN = ''
        self.WARNING = ''
        self.FAIL = ''
        self.ENDC = ''
        self.BOLD = ''
        self.UNDERLINE = ''

def check_mongo_uri(uri):
    import pymongo
    import socket
    uriDict = pymongo.uri_parser.parse_uri(uri, default_port=27017, validate=True, warn=False)
    print(uriDict)
    nodes = uriDict['nodelist']
    db = uriDict['database']

    node_counter = 0
    bad_nodes = []
    connection_string = []
    for node in nodes:
        print(color.BOLD + 'testing:' + color.OKGREEN + str(node) + color.ENDC)
        connection_string.append('{}:{}'.format(node[0],node[1]))
        s = socket.socket()
        s.settimeout(5)
        try:
            s.connect(node)
        except socket.error as e:
            print(color.FAIL + "Connection to node {} on port {} failed: {}".format(node[0], node[1], e) + color.ENDC)
            bad_nodes.append(node[0])
        finally:
            s.close()
        node_counter += 1
    if not bad_nodes:
        print(uri)
        client = pymongo.MongoClient(uri)
        #print('mongodb://' + str(connection_string).strip("[]").replace("\'", "").replace(" ","")) 
        #client = pymongo.MongoClient('mongodb://' + str(connection_string).strip("[]").replace("\'", "").replace(" ","")) 
        pass
    else:
        print('Test failed due problems on following nodes: ')
        for node in bad_nodes:
            print('{}'.format(node))
        exit(1)
    
    if not db:
        print(color.FAIL + 'You should pass database name: mongodb://%s/DATABASE_NAME/...' + color.ENDC % nodes)
        exit(1)   

    if db in client.database_names():
        print(color.OKGREEN + 'Everything looks good!' + color.ENDC)
        print('\tValid nodes:\t' + color.BOLD + '{}'.format(nodes) + color.ENDC)
        print('\tDatabase:\t' + color.BOLD + '{}'.format(db) + color.ENDC)
        print('\tOptions:\t' + color.BOLD + '{}'.format(uriDict['options']) + color.ENDC)
        return True
    else:
        print(color.FAIL + 'Wrong DB name! \nExited...' + color.ENDC)
        exit(1)

if __name__ == '__main__':
    from argparse import ArgumentParser
    # Options
    parser = ArgumentParser(description='Validate MongoDB URI')
    parser.add_argument("-u", dest="uri", help="MongoDB uri string (default: mongodb://localhost:27017/)", metavar="MONGO_URI")
    args = parser.parse_args()

    color = outputColors()
    #color.disable()
    print(color.BOLD + 'Checking MongoDB connection string: ' + color.OKGREEN + args.uri + color.ENDC)

    result = check_mongo_uri(args.uri)
    exit(not result)
