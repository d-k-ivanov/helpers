#!/usr/bin/python

import re

f = open("/etc/passwd")

print "-" * 84
print '{0:34}{1:48}{2:2}'.format("| ","Users and Groups"," |")
print "-" * 84
print '{0:2}{1:10}{2:3}{3:10}{4:3}{5:54}{6:2}'.format("| ","Username"," | ","UID"," | ","Groups"," |")

for fline in f:
    groups = []
    h = open("/etc/group")
    for hline in h:
        if fline.split(":")[3] == hline.split(":")[2]:
            groups.append(hline.split(":")[0])
        if re.search(fline.split(":")[0],hline) is not None:
            if not hline.split(":")[2] == fline.split(":")[3]:
                groups.append(hline.split(":")[0])
    h.close()
    print '{0:2}{1:10}{2:3}{3:10}{4:3}{5:54}{6:2}'.format("| ",fline.split(":")[0]," | ",fline.split(":")[2]," | ",",".join(groups)," |")

print "-" * 84

f.close()
